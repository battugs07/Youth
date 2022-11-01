import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../network_util.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as secure;
import 'package:lambda/plugins/progress_dialog/progress_dialog.dart';

class AgentController extends GetxController {
  static AgentController instance = Get.find();

  final storage = new secure.FlutterSecureStorage();
  RxBool hasBio = false.obs;
  RxBool isAuth = false.obs;
  RxBool isRemember = false.obs;
  RxBool isBioRemember = false.obs;
  RxString bioType = "".obs;
  RxString login = "".obs;
  RxString password = "".obs;
  RxString token = "".obs;
  RxString JWT = "".obs;
  RxString userData = "".obs;
  RxString msg = "".obs;

  SharedPreferences? _prefs;
  final LocalAuthentication auth = LocalAuthentication();
  NetworkUtil _netUtil = new NetworkUtil();
  List<BiometricType> _availableBiometrics = <BiometricType>[];

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  setAgent() async {
    bool deviceHasBio = await this.checkBioMetric();

    if (deviceHasBio) {
      hasBio.value = true;
      bioType.value = await this.getAvailableBiometrics();
    } else {
      hasBio.value = false;
    }
  }

  Future<bool> checkAuth() async {
    _prefs = await SharedPreferences.getInstance();

    isAuth.value = _prefs?.getBool('is_auth') ?? false;
    if (isAuth.value) {
      await loadAgentData();

      return true;
    } else {
      return false;
    }
  }

  loadAgentData() async {
    try {
      isRemember.value = _prefs?.getBool("is_remember") ?? false;
      isRemember.value = _prefs?.getBool("is_remember") ?? false;

      if (isRemember.value) {
        login.value = await storage.read(key: "login") ?? "";
        password.value = await storage.read(key: "password") ?? "";
      }

      isBioRemember.value = _prefs?.getBool("is_bio_remember") ?? false;
      userData.value = _prefs?.getString("user") ?? "";
    } catch (e) {
      print(e);
    }
  }

  void handleRemember(bool value) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("is_remember", value);
      if (!value && isBioRemember.value) {
        prefs.setBool("is_remember", value);
      }
      if (!value) {
        prefs.setString("login", "");
        prefs.setString("password", "");
      }
    });
    isRemember.value = value;
    if (!value && isBioRemember.value) {
      isBioRemember.value = value;
    }
    if (!value) {
      login.value = "";
      password.value = "";
    }
  }

  void handleBioRemember(bool value) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("is_bio_remember", value);
      if (value)
        prefs.setBool("is_remember", value);
      else
        prefs.setString("password", "");
    });
    isBioRemember.value = value;
    if (value)
      isRemember.value = value;
    else
      password.value = "";
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

  Future<bool> bioLogin(context, {bool ignoreFirst = false}) async {
    bool isFirst = _prefs?.getBool("is_first") ?? true;

    String msgFirst = '';
    String msgEnabled = '';

    switch (bioType.value) {
      case 'finger':
        msgFirst =
        'Та заавал нэг удаа нэвтэрч орсны дараа хурууны хээгээр нэвтрэх боломжтой!';
        msgEnabled =
        'Та хурууны хээгээр нэвтрэх тохиргоог идэвхижүүлээгүй байна';
        break;
      case 'face':
        msgFirst =
        'Та заавал нэг удаа нэвтэрч орсны дараа Face ID-р нэвтрэх боломжтой!';
        msgEnabled = 'Та Face ID-р нэвтрэх тохиргоог идэвхижүүлээгүй байна';
        break;
//      case 'iris':
//        msgFirst =
//            'Та заавал нэг удаа нэвтэрч орсны дараа Iris-р нэвтрэх боломжтой!';
//        msgEnabled = 'Та Iris-р нэвтрэх тохиргоог идэвхижүүлээгүй байна';
//        break;
    }

    if (isFirst == true && !ignoreFirst) {
      showToast(msgFirst);
      return false;
    }

    bool isBioRemember = _prefs?.getBool("is_bio_remember") ?? true;
    if (isBioRemember == false) {
      showToast(msgEnabled);
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
      login.value = await storage.read(key: "login") ?? "";
      password.value = await storage.read(key: "password") ?? "";
    }

    return authenticated;
  }

  showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  Future<bool> doLogin(context, String url, String login, String password,
      {bool loginByUsername = false}) async {
    ProgressDialog pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage('Түр хүлээнэ үү...');
    pr.show();

    var response = await _netUtil.post(
      url,
      loginByUsername
          ? {
        "phone": login,
        "password": password,
      }
          : {
        "email": login,
        "password": password,
      },
    );
    await new Future.delayed(const Duration(seconds: 1));

    if (response != null && response['status'] == true) {
      userData.value = jsonEncode(response!);

      if (isRemember.value) {
        await storage.write(key: "login", value: login);
      }

      if (response!["token"] != null) {
        await storage.write(key: "jwt", value: response!["token"]);
        JWT.value = response!["token"];
      }

      String? passwordSaved = _prefs?.getString("password");
      if ((isBioRemember.value && passwordSaved == null) ||
          (isBioRemember.value && passwordSaved == "")) {
        bool bioSuccess = await bioLogin(context, ignoreFirst: true);

        if (bioSuccess) {
//          await _prefs.setString("password", password);
          await storage.write(key: "password", value: password);
          await storage.write(key: "login", value: login);
          await _prefs?.setBool("remember_me", true);
          await _prefs?.setBool("is_bio", hasBio.value);
        } else {
//          await _prefs.setString("login", "");
//          await _prefs.setString("password", "");

          await storage.delete(key: "password");
          await storage.delete(key: "login");

          pr.update(
              message: response!.msg ?? 'Хурууны хээ таарсангүй!',
              type: 'error');
          await new Future.delayed(const Duration(seconds: 2));
          pr.hide();
          return false;
        }
      } else {
        if (isBioRemember.value) {
//          await _prefs.setString("password", password);
          await storage.write(key: "password", value: password);
          await _prefs?.setString("login", login);
        }
      }

      await _prefs?.setBool("is_first", false);

      await _prefs?.setBool("is_auth", true);
      isAuth.value = true;
      await _prefs?.setString("user", jsonEncode(response!['data']));
      userData.value = jsonEncode(response!['data']);
      pr.update(message: response['msg'], type: 'success');
      await new Future.delayed(const Duration(seconds: 1));
      pr.hide();
      return true;
    } else {
      pr.update(message: response['msg'], type: 'error');
      await new Future.delayed(const Duration(seconds: 2));
      pr.hide();
      return false;
    }
  }

  Future<void> updateUserState(String url) async {
    var response = await _netUtil.get(url);
    userData.value = jsonEncode(response!);
    await _prefs?.setString("user", jsonEncode(response!));
  }

  Future<void> logout() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs?.setBool("is_auth", false);
    await storage.delete(key: "jwt");
  }

  Future<void> setToken(int userId, String tokenValue, String url) async {
    token.value = tokenValue;
    print("here i am");
    await _netUtil.get('/deviceToken?token=$tokenValue');
  }
}