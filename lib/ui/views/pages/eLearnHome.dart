import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:youth/ui/views/pages/eLearn.dart';
import 'package:youth/ui/views/pages/podCast.dart';

class ELearnHomePage extends StatefulWidget {
  final title;

  const ELearnHomePage({Key? key, this.title}) : super(key: key);

  @override
  ELearnHomePageState createState() => ELearnHomePageState();
}

class ELearnHomePageState extends State<ELearnHomePage> with SingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[new Tab(text: "Цахим хичээл"), new Tab(text: "Подкаст сонсох")];

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text(
          widget.title.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: eLearnColor,
        bottom: new TabBar(
          isScrollable: true,
          unselectedLabelColor: Colors.white,
          labelColor: primaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: new BubbleTabIndicator(
            indicatorHeight: 25.0,
            indicatorColor: secondaryColor,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          tabs: tabs,
          controller: _tabController,
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: [ELearnPage(title: 'Цахим хичээл'), PodCastPage(title: 'Подкаст сонсох')],
      ),
    );
  }
}
