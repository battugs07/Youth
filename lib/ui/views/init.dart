import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lambda/modules/agent/agent_controller.dart';

import 'package:youth/core/models/user.dart';
import 'package:youth/core/viewmodels/user_model.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitScreen extends StatefulWidget {
  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  NetworkUtil _http = new NetworkUtil();
  AgentController agentController = new AgentController();
  late User? user;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _prefs = await SharedPreferences.getInstance();
      await this.checkAuth(context);
      // if (user != null) {
      //   await this.checkPermission(user!.id);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  Future<void> checkAuth(BuildContext context) async {
    if (_prefs!.getBool('is_auth') != null && _prefs!.getBool('is_auth') == true) {
      final userState = Provider.of<UserModel>(context);
      String? userData = _prefs!.getString('user');
      user = new User.fromJson(jsonDecode(userData!));
      userState.setUser(user!);
    } else {
      Navigator.of(context).pushReplacementNamed('/main');
    }
  }

  Future<void> checkPermission(int? userId) async {
    // String imei = await deviceID();
    // print(imei);
    // var response = await _http.get('/api/m/check/${imei}/${userId}');

    // if (response.data['status'] == false) {
    // ignore: dead_code
    if (false) {
      agentController.logout();
    } else {
      // _prefs.setBool("watch", response.data['watchAccess']);
      // _prefs.setString("xp", response.data['xp'].toString());
      Navigator.of(context).pushReplacementNamed('/main');
    }
  }
}
