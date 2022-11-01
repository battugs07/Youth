import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons_null_safe/flutter_icons_null_safe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:majascan/majascan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youth/core/models/user.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:youth/ui/views/login.dart';
import 'package:youth/ui/views/notifications.dart';
import 'package:youth/ui/views/settings.dart';

import '../../size_config.dart';

class DefaultSliverAppBar extends StatefulWidget {
  const DefaultSliverAppBar({
    Key? key,
    required this.color,
    required this.svgData,
    required this.title,
    this.titleColor,
  }) : super(key: key);

  final String title;
  final Color color;
  final Color? titleColor;
  final String svgData;

  @override
  _DefaultSliverAppBarState createState() => _DefaultSliverAppBarState();
}

class _DefaultSliverAppBarState extends State<DefaultSliverAppBar> {
  String result = "";

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
  Widget build(BuildContext context) {
    User? user;
    SharedPreferences? _prefs;
    return SliverAppBar(
      expandedHeight: getProportionateScreenHeight(200),
      floating: false,
      pinned: true,
      backgroundColor: widget.color,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Flexible(
              flex: 1,
              child: Text(
                widget.title.toUpperCase(),
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(14),
                  color: widget.titleColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        background: SvgPicture.asset(
          widget.svgData,
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: GestureDetector(
            onTap: _scanQR,
            child: Icon(
              Icons.qr_code_scanner_outlined,
              size: 31,
              color: Colors.white,
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
            },
            child: const Icon(
              Ionicons.ios_notifications_outline,
              size: 31,
              color: Colors.white,
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
                if (_prefs == null ? false : _prefs.getBool("is_auth") == false) {
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
                      builder: (context) => SettingsScreen(),
                    ),
                  );
                }
              }
            },
            child: Icon(
              // Ionicons.getIconData('ios-contact'),
              Ionicons.ios_contact,
              size: 31,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
