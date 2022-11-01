import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';

void main() {
  debugPaintSizeEnabled = false;
  Provider.debugCheckInvalidValueType = null;
  SharedPreferences.setMockInitialValues({});
  runApp(App());
}
