import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safe/flutter_icons_null_safe.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:youth/core/viewmodels/base_model.dart';

class LoaderSt extends StatelessWidget {
  final BaseModel? model;

  const LoaderSt({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(color: Color(0xaaffffff)),
      child: model != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                model != null && model!.idle
                    ? SpinKitRing(
                        color: Color(0xff0079FF),
                        size: 36.0,
                        lineWidth: 2,
                      )
                    : Container(),
                model!.success
                    ? Icon(
                        SimpleLineIcons.check,
                        color: Color(0xff2ecc71),
                        size: 30,
                      )
                    : Container(),
                model!.error
                    ? Icon(
                        SimpleLineIcons.info,
                        color: Color(0xffe74c3c),
                        size: 28,
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  model!.idle ? 'түр хүлээнэ үү...' : '',
                  style: TextStyle(color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                ),
                model!.success
                    ? Text(
                        model!.msg != '' ? model!.msg : 'Амжилттай',
                        style: TextStyle(color: Color(0xff2ecc71)),
                        textAlign: TextAlign.center,
                      )
                    : Container(),
                model!.error
                    ? Text(
                        model!.msg != '' ? model!.msg : 'Алдаа гарлаа',
                        style: TextStyle(color: Color(0xffe74c3c)),
                        textAlign: TextAlign.center,
                      )
                    : Container()
              ],
            )
          : Text(''),
    );
  }
}
