import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/ui/components/header-back.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ELearnDetailPage extends StatefulWidget {
  final title;
  final thumb;
  final description;
  final body;
  final teachername;
  final updated_at;
  final created_at;

  const ELearnDetailPage({Key? key, this.title, this.thumb, this.created_at, this.description, this.body, this.teachername, this.updated_at})
      : super(key: key);

  @override
  ELearnDetailPageState createState() => ELearnDetailPageState();
}

class ELearnDetailPageState extends State<ELearnDetailPage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: HeaderBack(
          title: 'Цахим Хичээл',
          reversed: true,
          customColor: eLearnColor,
          arrawBackColor: eLearnColor,
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: eLearnColor,
            ),
            child: Text(
              widget.title != null ? widget.title : '',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: bgColor,
              ),
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Container(
                    child: Html(data: widget.body != null ? widget.body : ""),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 30,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width - 25,
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: eLearnColor,
                                size: 14.0,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Шинэчилсэн огноо: ',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                widget.updated_at == null ? '' : DateFormat("y/MM/dd").format(DateTime.parse(widget.updated_at)).toString(),
                                style: TextStyle(
                                  color: eLearnColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 0, bottom: 10),
                          width: MediaQuery.of(context).size.width - 25,
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: eLearnColor,
                                size: 14.0,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Нэмсэн огноо: ',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                widget.created_at == null ? '' : DateFormat("y/MM/dd").format(DateTime.parse(widget.created_at)).toString(),
                                style: TextStyle(
                                  color: eLearnColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 0, bottom: 10),
                          width: MediaQuery.of(context).size.width - 25,
                          child: Row(
                            children: [
                              Icon(
                                Icons.supervised_user_circle,
                                color: eLearnColor,
                                size: 14.0,
                              ),
                              SizedBox(width: 5),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Бэлтгэсэн багш: ',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * .8,
                                    child: Text(
                                      widget.teachername == null ? "" : widget.teachername.toString(),
                                      style: TextStyle(
                                        color: eLearnColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
