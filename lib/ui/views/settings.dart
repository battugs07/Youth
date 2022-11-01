import 'dart:io';

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
import 'package:youth/ui/styles/_colors.dart';
import 'package:youth/ui/views/settings.dart';

import '../../locator.dart';
import 'notifications.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AgentController agentController = new AgentController();
  NetworkUtil _http = locator<NetworkUtil>();
  ResponseModel _response = ResponseModel.fromError();
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();

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

  Future getImage(String type) async {
    // image = await ImagePicker.pickImage(
    //     source: type == 'camera' ? ImageSource.camera : ImageSource.gallery);

    setState(() {
      isNetworkImage = false;
      this.getAvatarThumb();
      avatarPath = image!.path;
    });
  }

  Future<void> updateProfile() async {
    setState(() {
      loading = true;
    });
    final form = this._profileFormKey.currentState;
    form!.save();

    FormData formData = new FormData.fromMap({
      "avatar": user!.avatar,
      "nickname": nickname,
      "phone": phone,
      "gender": gender,
      "age": age,
      "file": image!.path != null ? await MultipartFile.fromFile(image!.path, filename: "${user!.id}-avatar.jpg") : null,
    });

    _response = await _http.post('/api/mobile/update/profile/${user!.id}', formData);

    final userState = Provider.of<UserModel>(context);
    user = new User.fromJson(_response.data);
    print(_response);
    userState.setUser(user!);

    await Future.delayed(Duration(milliseconds: 1500));
    setState(() {
      loading = false;
      success = true;
    });

    await Future.delayed(Duration(milliseconds: 1500));

    setState(() {
      success = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        gender = user!.gender as int;
        //avatarPath = user.image;
      });
    });
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
    final userState = Provider.of<UserModel>(context);
    user = userState.getUser;

    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: primaryColor,
          centerTitle: false,
          title: Text(
            'Хувийн мэдээлэл',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          leading: MaterialButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              print('working back btn');
              Navigator.pop(context);
            },
            child: Container(
              height: 30,
              width: 30,
              child: Icon(
                Ionicons.ios_arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          elevation: 0,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Stack(
                    children: <Widget>[
                      Form(
                        key: _profileFormKey,
                        child: ListView(
                          padding: EdgeInsets.all(0),
                          children: <Widget>[
                            Container(
                              height: 140,
                              margin: EdgeInsets.only(bottom: 15),
                              child: Center(
                                child: Stack(
                                  children: <Widget>[
                                    // (user.image == null || user.image == '')
                                    //     ? CircleAvatar(
                                    //         radius: 70,
                                    //         backgroundImage: AssetImage(
                                    //             'assets/images/avatar2.png'),
                                    //       )
                                    //     : getAvatarThumb(),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        child: Center(
                                          child: IconButton(
                                            icon: Icon(
                                              Feather.camera,
                                              color: Color(0xffffffff),
                                              size: 18,
                                            ),
                                            onPressed: () => this.showPickImageModal(context),
                                          ),
                                        ),
                                        height: 44,
                                        width: 44,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(22),
                                          border: Border.all(
                                            width: 3,
                                            color: Color(0xff141B31),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 82,
                              margin: EdgeInsets.only(bottom: 10, top: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [shadow],
                              ),
                              padding: EdgeInsets.only(
                                left: 20,
                                right: 10,
                                top: 10,
                                bottom: 0,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Таны нэр'.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff8899aa),
                                    ),
                                  ),
                                  Container(
                                    child: TextFormField(
                                      //initialValue: user.nickname ?? '',
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                147,
                                                157,
                                                186,
                                                .88,
                                              ),
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                          errorStyle: TextStyle(height: 0),
                                          hintText: ''),
                                      style: TextStyle(color: Color(0xff666666), fontSize: 20, fontWeight: FontWeight.w600),
                                      onSaved: (val) {
                                        setState(() {
                                          nickname = val;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            Container(
                              height: 82,
                              margin: EdgeInsets.only(bottom: 10, top: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [shadow],
                              ),
                              padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Утасны дугаар'.toUpperCase(),
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xff8899aa)),
                                  ),
                                  Container(
                                    child: TextFormField(
                                      initialValue: user!.phone ?? '',
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(color: Color.fromRGBO(147, 157, 186, .88), fontSize: 20, fontWeight: FontWeight.w600),
                                          errorStyle: TextStyle(height: 0),
                                          hintText: ''),
                                      style: TextStyle(color: Color(0xff666666), fontSize: 20, fontWeight: FontWeight.w600),
                                      onSaved: (val) {
                                        setState(() {
                                          phone = val;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            Container(
                              height: 82,
                              margin: EdgeInsets.only(bottom: 10, top: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [shadow],
                              ),
                              padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Хүйс'.toUpperCase(),
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xff8899aa)),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        new Radio(
                                          value: 0,
                                          groupValue: gender,
                                          activeColor: primaryColor,
                                          onChanged: (val) {
                                            setState(() {
                                              gender = val;
                                            });
                                          },
                                        ),
                                        new Text(
                                          'Эмэгтэй',
                                          style: new TextStyle(fontSize: 16.0),
                                        ),
                                        new Radio(
                                          value: 1,
                                          groupValue: gender,
                                          activeColor: primaryColor,
                                          onChanged: (val) {
                                            setState(() {
                                              gender = val;
                                            });
                                          },
                                        ),
                                        new Text(
                                          'Эрэгтэй',
                                          style: new TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            Container(
                              height: 82,
                              margin: EdgeInsets.only(bottom: 10, top: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [shadow],
                              ),
                              padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Нас'.toUpperCase(),
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xff8899aa)),
                                  ),
                                  Container(
                                    child: TextFormField(
                                      initialValue: user!.age ?? '0',
                                      keyboardType: TextInputType.numberWithOptions(),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(color: Color.fromRGBO(147, 157, 186, .88), fontSize: 20, fontWeight: FontWeight.w600),
                                          errorStyle: TextStyle(height: 0),
                                          hintText: ''),
                                      style: TextStyle(color: Color(0xff666666), fontSize: 20, fontWeight: FontWeight.w600),
                                      onSaved: (val) {
                                        setState(() {
                                          age = val;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 18),
                              child: MaterialButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () => this.updateProfile(),
                                child: Container(
                                  height: 32,
                                  padding: EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                    top: 7.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    'Хадгалах'.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      loading
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.black45,
                              ),
                              child: SpinKitRing(
                                color: Color(0xff0079FF),
                                size: 36.0,
                                lineWidth: 2,
                              ),
                            )
                          : Container(),
                      success
                          ? Container(
                              width: double.infinity,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.black45),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    SimpleLineIcons.check,
                                    color: Color(0xff2ecc71),
                                    size: 30,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    _response.msg,
                                    style: TextStyle(
                                      color: Color(0xff2ecc71),
                                    ),
                                  )
                                ],
                              ))
                          : Text('')
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
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
    required this.text,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback press;

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
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 15,
              color: primaryColor,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 15,
            )
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
            backgroundImage: AssetImage("assets/images/avatar2.png"),
          ),
          Positioned(
            bottom: 0,
            right: -12,
            child: SizedBox(
              width: 46,
              height: 46,
              child: MaterialButton(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: BorderSide(color: Colors.white)),
                color: Color(0xFFF5F6F9),
                onPressed: () {},
                child: SvgPicture.asset("assets/images/svg/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
