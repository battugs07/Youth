import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/core/models/user.dart';
import 'package:youth/core/viewmodels/user_model.dart';
import 'package:youth/ui/styles/_colors.dart' as prefix0;
import 'package:youth/ui/styles/_colors.dart';
import 'package:youth/ui/views/login.dart';
import 'package:youth/ui/views/notifications.dart';
import 'package:youth/ui/views/pages/knowLedgeWithoutHead.dart';
import 'package:youth/ui/views/sidebar.dart';

import '../components/navbar/navigation_bar.dart';
import '../components/navbar/navigation_bar_item.dart';

import "./home.dart";
import "./calendar.dart";
import "./settings.dart";

class MainScreen extends StatefulWidget {
  final _MainScreenState mainState = _MainScreenState();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController = new PageController(initialPage: 0);
  BuildContext? ctx;
  int _currentIndex = 0;
  bool navBarMode = true;
  Widget pagePrev = HomeScreen();
  Widget pageNext = CalendarScreen();
  Map<String, dynamic>? contact;
  NetworkUtil _http = new NetworkUtil();
  static const JsonCodec json = JsonCodec();
  // User? user;
  SharedPreferences? _prefs;
  String? xp;

  final List<Widget> _children = [HomeScreen(), CalendarScreen(), const KnowLedgePage(title: 'Мэдлэг, Мэдээлэл'), SettingsScreen()];

  // Future getContactList() async {
  //   var url = '$baseUrl/api/mobile/getContact';
  //   var response = await _http.get(url);
  //   contact = json.decode(response.toString());
  //   print('----------------------------------');
  //   print(response.toString());
  //   // print(contact!);
  //   setState(() {});
  // }

  void changePage(int index) {
    if (_currentIndex != index) {
      int pageIndex = 0;
      if (_currentIndex > index) {
        setState(() {
          pagePrev = _children[index];
        });
      } else {
        pageIndex = 1;
        setState(() {
          pageNext = _children[index];
        });
      }

      setState(() {
        _currentIndex = index;
      });

      _pageController.animateToPage(
        pageIndex,
        duration: Duration(milliseconds: 10),
        curve: Curves.ease,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // getContactList();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _prefs = await SharedPreferences.getInstance();
      setState(() {
        xp = _prefs!.getString('xp');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    int bgColor = 0xffffffff;
    // final userState = Provider.of<UserModel>(context);
    // user = userState.getUser;
    // print(user);
    return Scaffold(
      // appBar: AppBar(
      //   iconTheme: IconThemeData(
      //       color: primaryColor
      //   ),
      //   backgroundColor: Color(0xfff2f3fa),
      //   elevation: 0,
      //   actions: <Widget>[
      //     // Padding(
      //     //     padding: EdgeInsets.only(right: 10.0),
      //     //     child: GestureDetector(
      //     //         onTap: () {},
      //     //         child: Icon(Ionicons.getIconData('ios-search'),
      //     //             size: 31, color: primaryColor)
      //     //     )
      //     // ),
      //     Padding(
      //         padding: EdgeInsets.only(right: 10.0),
      //         child: GestureDetector(
      //           onTap: () {
      //             Navigator.push(
      //                 context,
      //                 CupertinoPageRoute(
      //                     builder: (context) => NotificationsScreen()));
      //
      //           },
      //           child: Icon(
      //               Ionicons.getIconData('ios-notifications-outline'),
      //               size: 31,
      //               color: primaryColor)
      //         )
      //     ),
      //     Padding(
      //         padding: EdgeInsets.only(right: 15.0),
      //         child: GestureDetector(
      //             onTap: () {
      //               print('------user');
      //               print(user);
      //
      //               if(user == null){
      //                 Navigator.push(
      //                     context,
      //                     CupertinoPageRoute(
      //                         builder: (context) => LoginPage()));
      //               }else{
      //                 if(_prefs == null ? false : _prefs.getBool("is_auth") == false){
      //                   Navigator.push(
      //                       context,
      //                       CupertinoPageRoute(
      //                           builder: (context) => LoginPage()));
      //                 }else{
      //                   Navigator.push(
      //                       context,
      //                       CupertinoPageRoute(
      //                           builder: (context) => SettingsScreen()));
      //                 }
      //               }
      //
      //             },
      //             child: Icon(
      //                 Ionicons.getIconData('ios-contact'),
      //                 size: 31,
      //                 color: primaryColor)
      //         )
      //     ),
      //   ],
      // ),
      backgroundColor: Colors.white,
      body: PageView.builder(
        physics: new NeverScrollableScrollPhysics(),
        controller: _pageController,
        itemBuilder: (context, index) {
          if (index == 0) {
            return pagePrev;
          } else {
            return pageNext;
          }
        },
        // itemBuilder: (BuildContext? context, int? index) {
        //   switch (index) {
        //     case 0:
        //       return pagePrev;
        //     case 1:
        //       return pageNext;
        //   }
        // },
      ),
      // bottomNavigationBar: Container(
      //   child: TitledBottomNavigationBar(
      //     onTap: changePage,
      //     ctx: context,
      //     reverse: navBarMode,
      //     curve: Curves.easeInBack,
      //     activeColor: prefix0.primaryColor.withOpacity(.9),
      //     inactiveColor: Color(0x6634495e),
      //     initialIndex: 0,
      //     currentIndex: _currentIndex,
      //     items: [
      //       NavigationBarItem(
      //           title: 'Нүүр',
      //           icon: Ionicons.getIconData('ios-home'),
      //           backgroundColor: Color(bgColor)),
      //       NavigationBarItem(
      //           title: 'Эвэнт',
      //           icon: Ionicons.getIconData('ios-calendar'),
      //           backgroundColor: Color(bgColor)),
      //       NavigationBarItem(
      //           title: 'Мэдлэг',
      //           icon: Ionicons.getIconData('ios-globe'),
      //           backgroundColor: Color(bgColor)),
      //       NavigationBarItem(
      //           title: 'Миний булан',
      //           icon: Ionicons.getIconData('ios-contact'),
      //           backgroundColor: Color(bgColor)),
      //     ],
      //   ),
      // ),
    );
  }
}
