import 'package:lambda/modules/network_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

String fixImagePath(String imgUrl) {
  if (imgUrl == null || imgUrl == '') {
    return 'assets/animax/images/nophoto.jpeg';
  } else {
    List<String> tmpUrl = imgUrl.split("/");
    if (tmpUrl[0] == 'uploaded' || tmpUrl[1] == 'uploaded') {
      return imgUrl;
    }
    return 'uploaded/' + imgUrl;
  }
}

Future<void> checkPermission(int userId) async {
  NetworkUtil _http = new NetworkUtil();
  // String imei = await deviceID();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // var response = await _http.get('/api/m/check/${imei}/${userId}');

  // prefs.setBool("watch", response.data['watchAccess']);
  // prefs.setBool("hentai", response.data['hentaiAccess']);
  // prefs.setString("xp", response.data['xp'].toString());
}

// Future<String> deviceID() async {
//   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//   if (Platform.isIOS) {
//     IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
//     return iosDeviceInfo.identifierForVendor; // unique ID on iOS
//   } else {
//     AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
//     return androidDeviceInfo.androidId; // unique ID on Android
//   }
// }
