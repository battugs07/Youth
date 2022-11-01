import 'package:flutter/material.dart';
import 'package:youth/ui/components/navbar.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:youth/ui/components/header.dart';

class JobScreen extends StatefulWidget {
  @override
  _JobScreenState createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Header(
            title: 'Ажлын байр',
            reversed: true,
          ),
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[],
                    ),
                  ),
                ],
              ),
            ),
          ),
          DefaultTabController(
            length: 2,
            child: Wrap(
              children: <Widget>[
                Container(
                  height: 36,
                  child: TabBar(
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: primaryColor,
                    unselectedLabelColor: primaryColor.withAlpha(60),
                    isScrollable: true,
                    indicator: MD2Indicator(
                      indicatorHeight: 3.4,
                      indicatorColor: Color(0xfff39c12),
                      indicatorSize: MD2IndicatorSize.tiny,
                    ),
                    tabs: <Widget>[
                      Tab(text: "Шинэ ажлын зар"),
                      Tab(text: "Цагийн ажил"),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: TabBarView(
                    children: [
                      Text('here1'),
                      Text('here1'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
