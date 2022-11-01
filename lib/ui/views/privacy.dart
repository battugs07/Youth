import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/ui/components/header-back.dart';
import 'package:youth/ui/styles/_colors.dart';
import '../components/loader.dart';
import 'package:youth/ui/views/base_view.dart';

class PrivacyScreen extends StatefulWidget {
  @override
  PrivacyScreenState createState() => PrivacyScreenState();
}

class PrivacyScreenState extends State<PrivacyScreen> {
  late Map<String, dynamic>? item;
  NetworkUtil _http = new NetworkUtil();
  // final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Future getItemList() async {
    var url = '$baseUrl/api/mobile/getOtherPage/5';
    var response = await _http.get(url);

    item = response['data'];

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItemList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: HeaderBack(
          title: item == null ? '' : item!['title'],
          reversed: true,
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            margin: EdgeInsets.only(top: 20, bottom: 20),
            child: Html(
              data: item == null ? '' : item!['body'],
              style: {
                "h1": Style(color: textColor, fontSize: FontSize.larger),
                "p": Style(color: textColor),
                "li": Style(color: textColor, fontSize: FontSize.large),
              },
            ),
          ),
        ],
      ),
    );
  }
}
