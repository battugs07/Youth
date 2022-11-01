import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:youth/ui/styles/_colors.dart';

class Loader extends StatelessWidget {
  final Color loaderColor;
  const Loader({
    Key? key,
    required this.loaderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SpinKitFadingCube(
            color: loaderColor != null ? loaderColor : primaryColor,
            size: 28.0,
          ),
        ],
      ),
    );
  }
}
