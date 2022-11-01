import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons_null_safe/flutter_icons_null_safe.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lambda/modules/agent/agent_controller.dart';
import 'package:lambda/modules/responseModel.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/core/models/user.dart';
import 'package:youth/ui/components/bottom_modal.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:provider/provider.dart';
import 'package:youth/core/viewmodels/user_model.dart';
import 'package:youth/ui/components/header-back.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth/ui/views/settings.dart';

import '../../locator.dart';
import 'notifications.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AgentController agentController = new AgentController();
  NetworkUtil _http = locator<NetworkUtil>();
  ResponseModel _response = ResponseModel.fromError();
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  Map<String, dynamic>? item;

  User? user;
  bool loading = false;
  bool success = false;
  File? image;
  String? avatarPath;
  String? nickname;
  String? phone;
  String? age;
  int? gender;
  bool isNetworkImage = true;
  SharedPreferences? _prefs;

  Future getImage(String type) async {
    // image = await ImagePicker.pickImage(
    //     source: type == 'camera' ? ImageSource.camera : ImageSource.gallery);

    setState(() {
      isNetworkImage = false;
      this.getAvatarThumb();
      avatarPath = image!.path;
    });
  }

  Future<void> getUserInfo(id) async {
    var url = baseUrl + '/api/mobile/profile/' + id.toString();
    var response = await _http.get(url);
    item = response.data;

    setState(() {});
  }

  Future<void> checkAuth(BuildContext context) async {
    if (_prefs?.getBool('is_auth') != null && _prefs?.getBool('is_auth') == true) {
      final userState = Provider.of<UserModel>(context, listen: false);
      String? userData = _prefs!.getString('user');
      user = new User.fromJson(jsonDecode(userData!));
      //print(user.surname + " surname");
      getUserInfo(user!.id);
    }
  }

  @override
  void initState() {
    super.initState();
    // SchedulerBinding.instance.addPostFrameCallback((_) async {
    //   _prefs = await SharedPreferences.getInstance();
    //   await this.checkAuth(context);
    // });
  }

  Widget getAvatarThumb() {
    if (isNetworkImage) {
      var urlPattern = r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
      var match = new RegExp(urlPattern, caseSensitive: false).firstMatch(avatarPath!);

      if (match == null) {
        return CircleAvatar(
          radius: 70,
          backgroundImage: NetworkImage(baseUrl + avatarPath!),
        );
      }

      return CircleAvatar(
        radius: 70,
        backgroundImage: NetworkImage(avatarPath!),
      );
    } else {
      return CircleAvatar(
        radius: 70,
        backgroundImage: AssetImage(avatarPath!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserModel>(context, listen: false);
    user = userState.getUser;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: HeaderBack(
          title: 'Миний булан',
          reversed: true,
          customColor: Colors.grey,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              alignment: Alignment.topRight,
              //width: double.infinity,
              child: SizedBox(
                width: 90,
                height: 35,
                child: MaterialButton(
                  padding: EdgeInsets.only(left: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: primaryColor,
                  onPressed: () async {
                    await agentController.logout;
                    Navigator.pushReplacementNamed(context, '/main');
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/svg/Log out.svg",
                        width: 15,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Гарах",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  ProfilePicture(
                    profilePicture: user!.profile_image != null && user!.profile_image != ""
                        ? baseUrl + user!.profile_image!
                        : baseUrl + "/assets/youth/images/noImage.jpg",
                  ),
                  SizedBox(height: 20),
                  ProfileMenu(
                    fieldType: " Ургийн овог:",
                    text: user!.surname != null ? user!.surname! : '',
                  ),

                  ProfileMenu(
                    fieldType: "Овог:",
                    text: user!.last_name != null ? user!.last_name! : '',
                  ),
                  ProfileMenu(
                    fieldType: "Нэр:",
                    text: user!.first_name != null ? user!.first_name! : '',
                  ),
                  ProfileMenu(
                    fieldType: "Нэвтрэх нэр:",
                    text: user!.phone != null ? user!.phone! : '',
                  ),
                  ProfileMenu(
                    fieldType: "Регистр:",
                    text: user!.register != null ? user!.register! : '',
                  ),
                  ProfileMenu(
                    fieldType: "Утас:",
                    text: user!.phone != null ? user!.phone! : '',
                  ),

                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  //   decoration: BoxDecoration(
                  //     boxShadow: [shadow],
                  //   ),
                  //   child: FlatButton(
                  //     padding: EdgeInsets.all(20),
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(15)),
                  //     color: Color(0xFFF5F6F9),
                  //     onPressed: () async {
                  //       await AgentController.logout();
                  //       Navigator.pushReplacementNamed(context, '/main');
                  //     },
                  //     child: Row(
                  //       children: [
                  //         SvgPicture.asset(
                  //           "assets/images/svg/Log out.svg",
                  //           width: 15,
                  //           color: primaryColor,
                  //         ),
                  //         SizedBox(width: 20),
                  //         Expanded(
                  //           child: Text(
                  //             "Гарах",
                  //             style: Theme.of(context).textTheme.bodyText1,
                  //           ),
                  //         ),
                  //         Icon(
                  //           Icons.arrow_forward_ios,
                  //           size: 15,
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPickImageModal(context) {
    showBottomModal(
      context: context,
      builder: (builder) {
        return Container(
          height: 200,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              padding: EdgeInsets.only(top: 33),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 110,
                    width: 120,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFF0074f2),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8)),
                    child: MaterialButton(
                      onPressed: () => getImage('camera'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            // Feather.getIconData('camera'),
                            Feather.camera,
                            size: 30,
                            color: Color(0xFF0074f2),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Камер',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF0074f2),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 36,
                  ),
                  Container(
                    height: 110,
                    width: 120,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFF0074f2),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8)),
                    child: MaterialButton(
                      onPressed: () => getImage('gallery'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            // Feather.getIconData('image'),
                            Feather.image,
                            size: 30,
                            color: Color(0xFF0074f2),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Зургийн галлерей',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF0074f2),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.fieldType,
    required this.text,
  }) : super(key: key);

  final String fieldType, text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        boxShadow: [shadow],
      ),
      child: MaterialButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xFFF5F6F9),
        onPressed: () {},
        child: Row(
          children: [
            Text(
              fieldType,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(width: 20),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    Key? key,
    required this.profilePicture,
  }) : super(key: key);

  final String profilePicture;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        // overflow: Overflow.visible,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(profilePicture),
          ),
        ],
      ),
    );
  }
}
