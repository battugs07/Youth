// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../plugins/progress_dialog/progress_dialog.dart';
// import '../network_util.dart';
// import '../responseModel.dart';
// import 'agent_state.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart' as secure;
// class SocialAuth {
//   NetworkUtil _http = new NetworkUtil();
//   ProgressDialog pr;
//   ResponseModel response = new ResponseModel.fromError();
//   AgentState _agent;
//   SharedPreferences _prefs;
//   final storage = new secure.FlutterSecureStorage();
//  final GoogleSignIn _googleSignIn = GoogleSignIn(
//    scopes: [
//      'email',
//    ],
//  );

//   Future<bool> googleLogin(BuildContext context) async {
//    pr = new ProgressDialog(context, ProgressDialogType.Normal);
//    await _googleSignIn.signOut();
//    try {
//      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//      await this.doLogin(context, 1, googleUser);
//    } catch (error) {
//      print(error);
//    }

//    if (response.status) {
//      pr.update(message: 'Амжилттай нэвтэрлээ', type: 'success');
//      await new Future.delayed(const Duration(seconds: 2));
//      pr.hide();
//      return true;
//    } else {
//      pr.setMessage('Түр хүлээнэ үү...');
//      pr.show();

//      pr.update(message: 'Алдаа гарлаа!', type: 'error');
//      await new Future.delayed(const Duration(seconds: 2));
//      pr.hide();
//      return false;
//    }

//   }

//   Future<bool> fbLogin(BuildContext context) async {
//     pr = new ProgressDialog(context, ProgressDialogType.Normal);

//     final FacebookLogin facebookLogin = FacebookLogin();

// //    final existingToken = await facebookLogin.currentAccessToken;
// //    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;

// //    if (existingToken != null) {
// //      final graphResponse = await Dio().get(
// //          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${existingToken}');
// //      await this.doLogin(context, 0, graphResponse.data);
// //    } else {
//     await facebookLogin.logOut();
//     final FacebookLoginResult result = await facebookLogin.logIn(['email']);
// //      final FacebookLoginResult result =
// //          await facebookLogin.logInWithReadPermissions(['email']);
//     print("result here");
//     print(result.accessToken);

//     switch (result.status) {
//       case FacebookLoginStatus.loggedIn:
//         final token = result.accessToken.token;
//         final graphResponse = await Dio().get(
//             'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
//         await this.doLogin(context, 0, graphResponse.data);
//         break;
//       case FacebookLoginStatus.cancelledByUser:
//         print('you have cancelled');
//         break;
//       case FacebookLoginStatus.error:
//         print('error occured');
//         break;
//     }
// //    }


//     if (response.status) {
//       pr.update(message: 'Амжилттай нэвтэрлээ', type: 'success');
//       await new Future.delayed(const Duration(seconds: 2));
//       pr.hide();

//       return true;
//     } else {
//       pr.setMessage('Түр хүлээнэ үү...');
//       pr.show();

//       pr.update(message: 'Алдаа гарлаа!', type: 'error');
//       await new Future.delayed(const Duration(seconds: 2));
//       pr.hide();
//       return false;
//     }
//   }

//   Future<void> doLogin(
//       BuildContext context, int stype, dynamic user) async {
//     _agent = Provider.of<AgentState>(context, listen: false);

//     pr = new ProgressDialog(context, ProgressDialogType.Normal);
//     pr.setMessage('Түр хүлээнэ үү...');
//     pr.show();

//     //facebook
//     if (stype == 0) {
//       var profile = json.decode(user);


//       response = await _http.post("/api/social/login", {
//         "email": profile['email'],
//         "avatar": 'https://graph.facebook.com/v3.1/${profile['id']}/picture',
//         "firstname": profile['first_name'],
//         "lastname": profile['last_name'],
//         "google": '',
//         "facebook": profile['id'],
//       });
//     }

//     //google
//     if (stype == 1) {

//       response = await _http.post('/api/social/login', {
//         "email": user.email,
//         "avatar": user.photoUrl,
//         "firstname": user.displayName,
//         "lastname": '',
//         "google": user.id,
//         "facebook": '',
//       });
//     }




//     if (response.status) {
//       // _prefs = await SharedPreferences.getInstance();
//       // await _prefs.setBool("is_auth", true);
//       // print(response.data);
//       // await _prefs.setString("user", jsonEncode(response.data));

//       // Future setUser(dynamic user, String token) async {

//         _prefs = await SharedPreferences.getInstance();
//         await _prefs.setBool("is_auth", true);
//         await _prefs.setString("user", jsonEncode(response.data["user"]));
//         await storage.write(key: "jwt", value: response.data["token"]);
//       // }
//     }
//   }
// }
