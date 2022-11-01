library lambda;

import 'package:flutter/material.dart';

class InternetChecker extends StatefulWidget {
  @override
  _InternetCheckerState createState() => _InternetCheckerState();
}

class _InternetCheckerState extends State<InternetChecker> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 5), child: Text('checking connection'));
  }
}
