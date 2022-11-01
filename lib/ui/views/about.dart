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

class AboutScreen extends StatefulWidget {
  @override
  AboutScreenState createState() => AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {
  Map<String, dynamic>? item;
  NetworkUtil _http = new NetworkUtil();
  // final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Future getItemList() async {
    var url = '$baseUrl/api/mobile/getOtherPage/1';
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
      backgroundColor: bgColor,
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
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            margin: EdgeInsets.only(bottom: 20),
            child: Html(
              data: item == null ? '' : item!['body'],
              style: {
                "h1": Style(color: textColor, fontSize: FontSize.larger),
                "p": Style(color: textColor, textAlign: TextAlign.justify),
                "li": Style(color: textColor, fontSize: FontSize.large),
              },
            ),
          ),
        ],
      ),
    );
  }
}
