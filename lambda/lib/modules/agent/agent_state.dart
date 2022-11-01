import 'package:flutter/material.dart';

class AgentState with ChangeNotifier {
  AgentState();

  bool _status = false;
  String _msg = '';
  bool _is_remember = false;
  bool _is_bio = false;
  String _bio_type = '';
  bool _is_bio_remember = false;
  String _bio_txt = '';
  String _token = '';
  String? _login;
  String? _password;
  bool _is_first = true;
  String _user = '';

  setStatus(bool val) {
    _status = val;
    notifyListeners();
  }

  setMsg(String val) {
    _msg = val;
    notifyListeners();
  }

  setRemember(bool val) {
    _is_remember = val;
    notifyListeners();
  }

  setBio(bool val) {
    _is_bio = val;
    notifyListeners();
  }

  setBioType(String val) {
    _bio_type = val;
    notifyListeners();
  }

  setBioRemember(bool val) {
    _is_bio_remember = val;
    notifyListeners();
  }

  setBioTxt(String val) {
    _bio_txt = val;
    notifyListeners();
  }

  setToken(String val) {
    _token = val;
    notifyListeners();
  }

  setLogin(String val) {
    _login = val;
    notifyListeners();
  }

  setPasword(String val) {
    _password = val;
    notifyListeners();
  }

  setFirst(bool val) {
    _is_first = val;
    notifyListeners();
  }

  setUser(String val) {
    _user = val;
  }

  bool get status => _status;

  String get msg => _msg;

  bool get is_remember => _is_remember;

  bool get is_bio => _is_bio;

  String get bio_type => _bio_type;

  bool get is_bio_remember => _is_bio_remember;

  String get bio_txt => _bio_txt;

  String get token => _token;

  String get login => _login!;

  String get password => _password!;

  bool get is_first => _is_first;

  String get user => _user;
}
