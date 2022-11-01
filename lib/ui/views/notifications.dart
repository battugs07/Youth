import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:youth/ui/components/header-back.dart';
import 'package:youth/ui/styles/_colors.dart';
import '../components/header.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NetworkUtil _netUtil = new NetworkUtil();
  bool loading = true;

  final List<String> notificationList = ['', '', ''];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: HeaderBack(
          title: 'Мэдэгдэл',
          reversed: true,
        ),
      ),
      body: Container(
        child: Center(
          child: Text(
            'Мэдэгдэл ирээгүй байна.',
            style: TextStyle(color: primaryColor),
          ),
        ),
      ),
    );

    return Scaffold(
        body: Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Header(
              title: 'Мэдэгдэл',
              reversed: false,
            ),
            Expanded(
              flex: 1,
              child: loading
                  ? Text('')
                  : ListView(
                      padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                      children: <Widget>[
                        //News list
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
//                            child: Column(
//                                children:
//                                notificationList.map().toList())
                        ),
                      ],
                    ),
            ),
          ],
        )
      ],
    ));
  }
}
