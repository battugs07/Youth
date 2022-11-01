import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'agent_state.dart';
import '../network_util.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lambda/modules/responseModel.dart';
import 'package:lambda/plugins/progress_dialog/progress_dialog.dart';

class AgentUtil {
  static AgentUtil _instance = new AgentUtil.internal();

  AgentUtil.internal();

  factory AgentUtil() => _instance;

  final LocalAuthentication auth = LocalAuthentication();
  NetworkUtil _netUtil = new NetworkUtil();
  List<BiometricType> _availableBiometrics = <BiometricType>[];

  SharedPreferences? _prefs;
  ResponseModel? response;
  AgentState? _agent;
  ProgressDialog? pr;

  Future<void> init(context) async {
    _agent = Provider.of<AgentState>(context, listen: false);
    pr = new ProgressDialog(context, ProgressDialogType.Normal);
    bool hasBio = await this.checkBioMetric();

    if (hasBio) {
      _agent!.setBio(true);
      String bType = await this.getAvailableBiometrics();
      _agent!.setBioTxt(bType);
    } else {
      _agent!.setBio(false);
    }
  }

  Future<bool> checkAuth() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs!.getBool('is_auth') != null && _prefs!.getBool('is_auth') == true) {
      this.loadAgentData();
      return true;
    }
    return false;
  }

  loadAgentData() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      bool isRemember = await _prefs!.getBool("is_remember") ?? false;
      _agent!.setRemember(isRemember);

      if (isRemember) {
        String login = _prefs!.getString("login") ?? "";
        String password = _prefs!.getString("password") ?? "";
        _agent!.setLogin(login);
        _agent!.setPasword(password);
      }

      bool isBioRemember = _prefs!.getBool("is_bio_remember") ?? false;
      _agent!.setBioRemember(isBioRemember);
    } catch (e) {
      print(e);
    }
  }

  void handleRemember(bool value) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("is_remember", value);
    });
    _agent!.setRemember(value);
  }

  void handleBioRemember(bool value) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("is_bio_remember", value);
    });
    _agent!.setBioRemember(value);
  }

  Future<bool> checkBioMetric() async {
    try {
      return await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> getAvailableBiometrics() async {
    _availableBiometrics = await auth.getAvailableBiometrics();

    // For iOS
    if (Platform.isIOS) {
      if (_availableBiometrics.contains(BiometricType.face)) {
        return 'face';
      } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
        return 'finger';
      }
    }

    // For Android
    if (Platform.isAndroid) {
      if (_availableBiometrics.contains(BiometricType.fingerprint)) {
        return 'finger';
      }
    }

    return '';
  }

  Future<bool> bioLogin(context) async {
    _prefs = await SharedPreferences.getInstance();

    bool isFirst = _prefs!.getBool("is_first") ?? true;

    String msgFirst = '';
    String msgEnabled = '';
    switch (_agent!.bio_type) {
      case 'finger':
        msgFirst = 'Та заавал нэг удаа нэвтэрч орсны дараа хурууны хээгээр нэвтрэх боломжтой!';
        msgEnabled = 'Та хурууны хээгээр нэвтрэх тохиргоог идэвхижүүлээгүй байна';
        break;
      case 'face':
        msgFirst = 'Та заавал нэг удаа нэвтэрч орсны дараа Face ID-р нэвтрэх боломжтой!';
        msgEnabled = 'Та Face ID-р нэвтрэх тохиргоог идэвхижүүлээгүй байна';
        break;
//      case 'iris':
//        msgFirst =
//            'Та заавал нэг удаа нэвтэрч орсны дараа Iris-р нэвтрэх боломжтой!';
//        msgEnabled = 'Та Iris-р нэвтрэх тохиргоог идэвхижүүлээгүй байна';
//        break;
    }

    if (isFirst == true) {
      showToast(context, 'error', msgFirst);
      return false;
    }

    bool isBioRemember = _prefs!.getBool("is_bio_remember") ?? true;
    if (isBioRemember == false) {
      showToast(context, 'error', msgEnabled);
      return false;
    }

    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Хурууны хээгээ уншуулж нэвтэрнэ үү',
        // useErrorDialogs: true,
        // stickyAuth: true
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (authenticated) {
      String? login = _prefs!.getString("login");
      String? password = _prefs!.getString("password");
      _agent!.setLogin(login!);
      _agent!.setPasword(password!);
    }

    return authenticated;
  }

  showToast(context, String type, String msg) {
    int bgColor = 0xcceb4d4b;

    if (type == "success") {
      bgColor = 0xcc2ecc71;
    }
    Toast.show(msg, duration: Toast.lengthLong, gravity: Toast.bottom, backgroundColor: Color(bgColor));
  }

  Future<bool> login(context, String url, String login, String password) async {
    pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr!.setMessage('Түр хүлээнэ үү...');
    pr!.show();
    print('---->');
    print(response);
    response = await _netUtil.post(
      url,
      {
        "login": login,
        "password": password,
      },
    );

    await new Future.delayed(const Duration(seconds: 1));
    _agent = Provider.of<AgentState>(context, listen: false);

    if (response!.status) {
      _agent!.setStatus(true);
      _agent!.setUser(jsonEncode(response!.data));

      if (_agent!.is_remember) {
        await _prefs!.setString("login", login);
        await _prefs!.setString("password", password);
        await _prefs!.setBool("remember_me", true);
      }

      await _prefs!.setBool("is_first", false);
      await _prefs!.setBool("is_bio", _agent!.is_bio);
      await _prefs!.setBool("is_auth", true);
      await _prefs!.setString("user", jsonEncode(response!.data));
//      showToast(context, "success", "Амжилттай нэвтэрлээ");
      pr!.update(message: 'Амжилттай нэвтэрлээ', type: 'success');
      await new Future.delayed(const Duration(seconds: 1));
      pr!.hide();
      return true;
    } else {
      _agent!.setStatus(false);
      _agent!.setMsg(response!.msg);
      print(response!.msg);
//      showToast(context, "error", 'Нэвтрэх нэр эсвэл нууц үг буруу байна!');
      pr!.update(message: response!.msg ?? 'Нэвтрэх нэр эсвэл нууц үг буруу байна!', type: 'error');
      await new Future.delayed(const Duration(seconds: 2));
      pr!.hide();
      return false;
    }
  }

  Future<void> updateUserState(String url) async {
    await _netUtil.get(url);
    _agent!.setStatus(true);
    _agent!.setUser(jsonEncode(response!.data));
    await _prefs!.setString("user", jsonEncode(response!.data));
  }

  Future<void> logout() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs!.setBool("is_auth", false);
  }

  Future<void> setToken(int userId, String token, String url) async {
    if (_agent != null && (_agent!.token == '' || _agent!.token == null || _agent!.token != token)) {
      _agent!.setToken(token);
    }

    print("here i am");
    await _netUtil.get('/deviceToken?token=${token}');
  }
}
