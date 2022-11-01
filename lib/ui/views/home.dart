import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_icons_null_safe/flutter_icons_null_safe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:majascan/majascan.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/core/models/contact.dart';
import 'package:youth/core/models/user.dart';
import 'package:youth/core/viewmodels/user_model.dart';
import 'package:youth/ui/components/dynamic_flexible_spacebar_title.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youth/ui/views/login.dart';
import 'package:youth/ui/views/notifications.dart';
import 'package:youth/ui/views/qrScanner.dart';
import 'package:youth/ui/views/pages/VolunteerWork/volunteer_work.dart';
import 'package:youth/ui/views/pages/eLearnHome.dart';
import 'package:youth/ui/views/pages/event/event_page.dart';
import 'package:youth/ui/views/pages/knowLedge/knowLedge.dart';
import 'package:youth/ui/views/pages/lawPage/law.dart';

import 'package:youth/ui/views/pages/partTimeJob.dart';
import 'package:youth/ui/views/profile.dart';
import 'package:youth/ui/views/settings.dart';
import 'package:youth/ui/views/sidebar.dart';
import 'dart:convert' as convert;
import 'package:youth/ui/views/pages/nationalCouncil/national_council.dart';
import 'package:youth/ui/views/pages/YouthCouncil/youth_council_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  // final GlobalKey<FormState> _searchFormKey = GlobalKey<FormState>();
  User? user;
  SharedPreferences? _prefs;
  dynamic contact;
  NetworkUtil _http = new NetworkUtil();
  String result = "";

  Future getContactList() async {
    final response = await _http.get('/api/mobile/getContact');
    String jsonsDataString = response.toString();
    // print(jsonsDataString);
    contact = response;
    return contact;
  }

  Future _scanQR() async {
    try {
      String? qrResult = await MajaScan.startScan(
          title: "QRcode scanner", titleColor: Colors.amberAccent[700], qRCornerColor: Colors.orange, qRScannerColor: Colors.orange);
      setState(() {
        result = qrResult!;
        _launchURL(qrResult);
      });
    } on PlatformException catch (ex) {
      if (ex.code == MajaScan.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  void _launchURL(_url) async => await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  @override
  void initState() {
    super.initState();
    getContactList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width / 2;
    final userState = Provider.of<UserModel>(context);
    user = userState.getUser;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        elevation: 0,
        child: SidebarScreen(contact: contact),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 150,
              pinned: true,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  color: bgColor,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 10.0,
                        left: 7,
                        child: Text(
                          'Залуучуудыг дэмжих хөтөлбөр',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                title: DynamicFlexibleSpaceBarTitle(
                  child: Text(
                    'Залуу хүн',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                ),
                titlePadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: primaryColor,
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                    onTap: _scanQR,
                    child: const Icon(
                      Icons.qr_code_scanner_outlined,
                      size: 31,
                      color: primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => NotificationsScreen(),
                        ),
                      );
                      getContactList();
                    },
                    child: const Icon(
                      Icons.notifications_none_outlined,
                      // Ionicons.notifications,
                      size: 31,
                      color: primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      print('------user');
                      print(user);

                      if (user == null) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      } else {
                        if (_prefs == null ? false : _prefs?.getBool("is_auth") == false) {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              //builder: (context) => SettingsScreen(),
                              builder: (context) => ProfileScreen(),
                            ),
                          );
                        }
                      }
                    },
                    child: Icon(
                      Icons.account_circle_outlined,
                      size: 31,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ];
        },
        body: Container(
          color: bgColor,
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          child: GridView.count(
            padding: EdgeInsets.only(top: 0, bottom: 10, left: 15, right: 15),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: (itemWidth / 185),
            physics: new NeverScrollableScrollPhysics(),
            controller: new ScrollController(keepScrollOffset: false),
            shrinkWrap: true,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YouthCouncilPage(title: 'Залуучууд Хөгжлийн зөвлөл'),
                    ),
                  );
                },
                child: Container(
                  height: 90,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [shadow],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          'assets/images/logo-zhz.jpg',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Залуучууд Хөгжлийн Зөвлөл',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFa01e66),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NationalCouncilPage(title: 'Залуучууд Хөгжлийн Үндэсний зөвлөл'),
                    ),
                  );
                },
                child: Container(
                  height: 90,
                  //padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [shadow],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Container(
                        width: 90,
                        height: 90,
                        child: Image.asset(
                          'assets/images/logo-uz-ok.jpg',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Залуучууд Хөгжлийн Үндэсний зөвлөл',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF283890),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VolunteerWorks(
                        title: 'Сайн дурын ажил',
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 90,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [shadow],
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 20),
                        child: SvgPicture.asset(
                          'assets/images/svg/menu-volunteer.svg',
                          width: 70,
                          height: 70,
                          color: volunteerColor,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.only(top: 4, bottom: 4, right: 3, left: 4),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: volunteerColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Сайн дурын ажил',
                                  style: TextStyle(
                                    fontSize: 13.8,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                // Text(
                                //   '5 сайн дурын ажил байна',
                                //   style: TextStyle(
                                //       fontSize: 10.7, color: Colors.white),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PartTimeJobPage(title: 'Цагийн ажил'),
                    ),
                  );
                },
                child: Container(
                  height: 90,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [shadow],
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.topCenter,
                        child: SvgPicture.asset(
                          'assets/images/svg/menu-parttime.svg',
                          width: 70,
                          height: 70,
                          color: partTimeColor,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.only(top: 4, bottom: 4, right: 3, left: 4),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFF02b557),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Цагийн ажил',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ELearnHomePage(title: 'Цахим хичээл'),
                    ),
                  );
                },
                child: Container(
                  height: 90,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [shadow],
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.topCenter,
                        child: SvgPicture.asset(
                          'assets/images/svg/menu-lesson.svg',
                          width: 70,
                          height: 70,
                          color: Color(0xFF5f58CC),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.only(top: 4, bottom: 4, right: 3, left: 4),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFF7068fc),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Цахим хичээл',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LawPage(title: 'Хууль'),
                    ),
                  );
                },
                child: Container(
                  height: 90,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [shadow],
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.topCenter,
                        child: SvgPicture.asset(
                          'assets/images/svg/menu-legal.svg',
                          width: 70,
                          height: 70,
                          color: Color(0xFF992d34),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.only(top: 4, bottom: 4, right: 3, left: 4),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFd63e49),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Хууль',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KnowLedgePage(title: 'Мэдлэг, Мэдээлэл'),
                    ),
                  );
                },
                child: Container(
                  height: 90,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [shadow],
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.topCenter,
                        child: SvgPicture.asset(
                          'assets/images/svg/menu-news.svg',
                          width: 70,
                          height: 70,
                          color: knowLedgeColor,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.only(top: 4, bottom: 4, right: 3, left: 4),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: knowLedgeColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Мэдээ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                // Text(
                                //   'Хууль эрх зүйн мэдлэг',
                                //   style: TextStyle(
                                //     fontSize: 10.7,
                                //     color: Colors.white,
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventPage(
                        title: 'Арга Хэмжээ',
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 90,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [shadow],
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.topCenter,
                        child: SvgPicture.asset(
                          'assets/images/svg/menu-event.svg',
                          width: 70,
                          height: 70,
                          color: eventColor,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.only(top: 4, bottom: 4, right: 3, left: 4),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: eventColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Эвэнт',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                // Text(
                                //   'Эрүүл мэнд, гэр бүл',
                                //   style: TextStyle(
                                //     fontSize: 10.7,
                                //     color: Colors.white,
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
