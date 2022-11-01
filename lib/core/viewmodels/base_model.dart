import 'package:flutter/material.dart';

class BaseModel extends ChangeNotifier {
  bool _loading = false;
  bool _idle = true;
  bool _success = false;
  bool _error = false;
  String _msg = '';

  bool get loading => _loading;

  bool get idle => _idle;

  bool get success => _success;

  bool get error => _error;

  String get msg => _msg;

  void setLoading(bool value) {
    if (value == false) {
      _success = false;
      _error = false;
    }

    _idle = value;
    _loading = value;
    notifyListeners();
  }

  void updateLoading(String loadingType, [String msg = '']) {
    _msg = msg;
    if (loadingType == 'success') {
      _success = true;
      _idle = false;
      _error = false;
    }

    if (loadingType == 'error') {
      print('error');
      _error = true;
      _idle = false;
      _success = false;
    }
    notifyListeners();
  }

  modelNotifier() {
    notifyListeners();
  }
}
