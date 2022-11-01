import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safe/flutter_icons_null_safe.dart';
import 'package:youth/ui/styles/_colors.dart';

class Header extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffold;
  final String? title;
  final bool? reversed;

  Header({@required this.title, this.reversed, this.scaffold});

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: widget.reversed! ? Colors.transparent : Color(0xff020D18),
          ),
          child: SafeArea(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Row(
                      // mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 44.0,
                          width: 44.0,
                          // decoration: BoxDecoration(
                          //     border: Border(
                          //         right:
                          //         BorderSide(color: Color(0xffababba)))),
                          child: IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              widget.scaffold!.currentState!.openDrawer();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        margin: EdgeInsets.only(right: 12),
                        width: 27.0,
                        height: 50,
                        child: Icon(Ionicons.ios_notifications_outline, size: 31, color: primaryColor),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        margin: EdgeInsets.only(right: 15),
                        width: 30.0,
                        height: 50,
                        child: Icon(Ionicons.ios_search, size: 31, color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
