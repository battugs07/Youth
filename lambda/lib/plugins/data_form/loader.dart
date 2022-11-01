import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  final Color? color;

  Loader({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
            color: this.color != null ? this.color : Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SpinKitThreeBounce(
              //color: this.color != null ? this.color : Color(0xff666666),
              color: this.color != null
                  ? this.color
                  : Color.fromRGBO(0, 102, 204, 1),
              size: 36.0,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'түр хүлээнэ үү...',
              style: TextStyle(
                  color: this.color != null ? this.color : Color(0xff666666)),
            )
          ],
        ));
  }
}
