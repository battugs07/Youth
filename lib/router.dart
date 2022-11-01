import 'package:flutter/material.dart';
import 'package:youth/ui/views/verify.dart';
import './ui/views/init.dart';
import './ui/views/login.dart';
import './ui/views/register.dart';
import './ui/views/recovery.dart';
import './ui/views/reset.dart';
import './ui/views/main.dart';
import './ui/views/register_by_phone.dart';

class Router {
  Router._();

  static final routes = <String, WidgetBuilder>{
    '/': (context) => InitScreen(),
    '/login': (context) => LoginPage(),
    '/register_by_phone': (context) => RegisterByPhonePage(),
    '/register': (context) => RegisterPage(),
    '/recovery': (context) => RecoveryPage(),
    '/reset': (context) => ResetPage(),
    '/main': (context) => MainScreen(),
  };
}
