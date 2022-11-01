import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/core/models/event.dart';
import 'package:youth/ui/styles/_colors.dart';

class YouthEventDetail extends StatefulWidget {
  final Event? item;

  const YouthEventDetail({Key? key, this.item}) : super(key: key);
  @override
  _YouthEventDetailState createState() => _YouthEventDetailState();
}

class _YouthEventDetailState extends State<YouthEventDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Text(
              widget.item!.title!,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
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
                    widget.item!.banner != null
                        ? Image.network(
                            baseUrl + widget.item!.banner.toString(),
                          )
                        : Text(''),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      //child: Html(data: widget.news.content),
                      child: Html(
                        data: widget.item!.content.toString(),
                        style: {
                          "p": Style(
                            color: kTextColor,
                            fontSize: FontSize(13),
                            fontWeight: FontWeight.normal,
                          ),
                        },
                      ),
                    ),
                    Container(
                      height: 90,
                      margin: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 30,
                        bottom: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
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
                                  Icons.access_time,
                                  color: knowLedgeColor,
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
                                  widget.item!.createdAt!,
                                  style: TextStyle(
                                    color: knowLedgeColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
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
          ),
        ],
      ),
    );
  }
}
