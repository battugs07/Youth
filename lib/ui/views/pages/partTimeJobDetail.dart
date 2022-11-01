import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PartTimeJobDetailPage extends StatefulWidget {
  final title;
  final description;
  final date;

  const PartTimeJobDetailPage({Key? key, this.title, this.description, this.date}) : super(key: key);

  @override
  PartTimeJobPageDetailState createState() => PartTimeJobPageDetailState();
}

class PartTimeJobPageDetailState extends State<PartTimeJobDetailPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int index = 0;

    // TODO: implement build
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: <Widget>[
          Positioned(
              width: MediaQuery.of(context).size.width,
              top: size.height * 0.3 + 20,
              bottom: 0,
              left: 0,
              child: Container(
                  height: size.height * 0.7,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Text(
                        widget.title == null ? '' : widget.title,
                        style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(widget.description == null ? '' : widget.description),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        widget.date == null ? '' : DateFormat("y/MM/dd").format(DateTime.parse(widget.date)).toString(),
                        style: TextStyle(color: secondaryColor),
                      )
                    ],
                  ))),
          Positioned(
            top: 0.0,
            left: 0.0,
            width: size.width,
            height: size.height * 0.35,
            child: CustomPaint(
              painter: CurvePainter(),
            ),
          ),
          Positioned(
              top: 70.0,
              right: size.width * 0.1,
              width: size.width * 2,
              height: size.height * 0.2,
              child: Container(
                height: size.height * 0.2,
                width: size.width,
                // color: Colors.greenAccent,
                child: SvgPicture.asset(
                  'assets/images/svg/page-heading-part-time.svg',
                  semanticsLabel: 'A red up arrow',
                  fit: BoxFit.cover,
                ),
              )),
          Positioned(
              top: 47.0,
              right: 20,
              width: size.width,
              child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'Цагийн ажлын зар'.toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ))),
          Positioned(
              top: 40.0,
              left: 20.0,
              width: 40.0,
              height: 40.0,
              child: Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(50.0)),
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 33.0,
                      ))))
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Color.fromRGBO(51, 142, 108, 0.9);
    var path = Path();
    path.lineTo(0, size.height - size.height / 12);
    // path.lineTo(size.width / 1.2, size.height);
    path.lineTo(size.width, size.height - size.height / 3);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
