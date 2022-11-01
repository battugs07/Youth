import 'package:flutter/material.dart';

class NavigationBarItem {
  final String? title;
  final IconData? icon;
  final bool? floating;
  final Color? backgroundColor;

  NavigationBarItem({@required this.icon, @required this.title, this.backgroundColor = Colors.white60, this.floating});
}
