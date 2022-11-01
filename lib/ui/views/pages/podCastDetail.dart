import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/ui/components/header-back.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';

class PodCastDetailPage extends StatefulWidget {
  final title;
  final img;
  final content;
  final guest;
  final embed;
  final link;
  final views;
  final created_at;

  const PodCastDetailPage({Key? key, this.title, this.img, this.created_at, this.content, this.guest, this.views, this.link, this.embed})
      : super(key: key);

  @override
  PodCastDetailPageState createState() => PodCastDetailPageState();
}

class PodCastDetailPageState extends State<PodCastDetailPage> {
  final _key = UniqueKey();
  bool _isLoadingPage = false;
  WebViewController? webController;
  Completer<WebViewController> _controller = Completer<WebViewController>();
  // final flutterWebViewPlugin = FlutterWebviewPlugin();

  final Set<Factory> gestureRecognizers = [
    Factory(() => EagerGestureRecognizer()),
  ].toSet();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: HeaderBack(
          title: 'Подкаст',
          reversed: true,
          customColor: podCastColor,
          arrawBackColor: podCastColor,
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: podCastColor,
            ),
            child: Text(
              widget.title != null ? widget.title : Text(""),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: widget.content != null ? Text(widget.content) : Text('Подкаст'),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Html(
              data: widget.embed != null ? widget.embed : Text(''),
            ),
          ),
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
