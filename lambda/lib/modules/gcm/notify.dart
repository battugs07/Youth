import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:lambda/utils/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Notify {
  SharedPreferences? _prefs;
  NetworkUtil _netUtil = new NetworkUtil();

  Future? initNotify(String userId, BuildContext ctx) {
    Firebase.initializeApp().whenComplete(() async {
      await configFirebase(userId, ctx);
    });

    if (Platform.isAndroid) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          print('Message also contained a notification: ${message.notification}');
          ProgressDialog pr;

          Toast.show(message.notification!.title!, duration: Toast.lengthLong, gravity: Toast.bottom, backgroundColor: Color.fromARGB(0, 255, 0, 0));
        }
      });
    }
    return null;
  }

  Future configFirebase(userId, BuildContext ctx) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // print('User granted permission: ${settings.authorizationStatus}');
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );

      String? token = await messaging.getToken();
      _prefs = await SharedPreferences.getInstance();
      // if (_prefs.getString('pushToken') == null) {
      _prefs!.setString("pushToken", token!);
      await _netUtil.get('/token/$userId/$token', base: dotenv.env['APP'] == "animax" ? "https://animax.mn/api/m" : "https://wemax.app/api/m");
      // }
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> checkPermission() async {
    _prefs = await SharedPreferences.getInstance();
    String? userId = _prefs!.getString("userId");

    var response = await _netUtil.get('/check/notify/$userId');

    _prefs!.setBool("watch", response.chartdata['watchAccess']);
    _prefs!.setBool("hentai", response.chartdata['hentaiAccess']);
    _prefs!.setString("xp", response.chartdata['xp'].toString());
    _prefs!.setString("day", response.chartdata['day'].toString());

    if (response.chartdata['hasNotification'] == true) {
      _prefs!.setBool("hasNotification", true);
    } else {
      _prefs!.setBool("hasNotification", false);
    }
  }
}
