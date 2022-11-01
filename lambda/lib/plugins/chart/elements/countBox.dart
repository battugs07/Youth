import 'package:flutter/material.dart';
import 'package:lambda/utils/hexColor.dart';
import 'package:lambda/plugins/chart/utils/fontByName.dart';
import 'package:lambda/utils/number.dart';

class CountBox extends StatefulWidget {
  final String? title;
  final String? color;
  final String? icon;
  final int? data;

  CountBox({Key? key, this.title, this.color, this.data, this.icon})
      : super(key: key);

  @override
  _CountBoxState createState() => _CountBoxState();
}

class _CountBoxState extends State<CountBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 30, top: 20, left: 30, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                )),
            padding: EdgeInsets.only(right: 15, top: 15, left: 15, bottom: 15),
            margin: EdgeInsets.only(
              right: 30,
            ),
            child: Icon(
              FontByName.icon(this.widget.icon ?? "fa fa-user"),
              color: HexColor(this.widget.color ?? "#000"),
              size: 20,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                formatter.format(this.widget.data),
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white, fontSize: 21),
              ),
              Container(
                  width: MediaQuery.of(context).size.width - 140,
                  child: Text(this.widget.title ?? "",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white, fontSize: 16)))
            ],
          )
        ],
      ),
      color: HexColor(this.widget.color ?? "#000"),
      width: MediaQuery.of(context).size.width,
    );
  }
}
