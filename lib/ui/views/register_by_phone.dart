import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lambda/modules/responseModel.dart';
import 'package:youth/core/viewmodels/user_model.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:youth/ui/views/verify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:provider/provider.dart';
import 'package:lambda/plugins/progress_dialog/progress_dialog.dart';
import 'package:lambda/plugins/verify_input/verify_input.dart';
import '../../core/models/user.dart';

class RegisterByPhonePage extends StatefulWidget {
  // const RegisterByPhonePage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterByPhonePage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController phone = new TextEditingController();
  bool loading = false;

  NetworkUtil _netUtil = new NetworkUtil();

  @override
  void initState() {
    super.initState();
  }

  doRegister(BuildContext context) async {
    ProgressDialog pr = ProgressDialog(context, ProgressDialogType.Normal);
    FocusScope.of(context).requestFocus(FocusNode());
    await Future.delayed(const Duration(milliseconds: 300));

    pr.setMessage('Түр хүлээнэ үү...');
    pr.show();

    var response = await _netUtil.post('/api/mobile/register', {
      "phone": phone.text,
    });

    if (response != null) {
      pr.update(message: 'Амжилттай бүртгэгдлээ', type: 'success');
      await Future.delayed(const Duration(seconds: 1));
      pr.hide();
      print('navigate to verify page');
      Navigator.push(context, CupertinoPageRoute(builder: (context) => VerifyPage('register')));
      Navigator.pushNamed(context, '/verify');
    } else {
      pr.update(message: 'Алдаа гарлаа', type: 'error');
      await Future.delayed(const Duration(milliseconds: 1500));
      pr.hide();
    }
    // if (response.status) {
    //   User user = new User.fromJson(response.data);
    //   final state = Provider.of<UserModel>(context, listen: false);
    //   state.setUser(user);

    //   pr.update(message: 'Амжилттай бүртгэгдлээ', type: 'success');
    //   await new Future.delayed(const Duration(seconds: 1));
    //   pr.hide();

    //   Navigator.push(context, CupertinoPageRoute(builder: (context) => VerifyPage('register')));
    //   Navigator.pushNamed(context, '/verify');
    // } else {
    //   pr.update(message: response.msg, type: 'error');
    //   await new Future.delayed(const Duration(milliseconds: 1500));
    //   pr.hide();
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFfffff),
      body: Stack(
        children: <Widget>[
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Container(
                  //   height: MediaQuery.of(context).size.height / 2.8,
                  //   child: Center(
                  //     child: Container(
                  //       height: 70,
                  //       margin: EdgeInsets.only(bottom: 20),
                  //       child: Image.asset("assets/images/logo.png"),
                  //     ),
                  //   ),
                  // ),
                  Text(
                    'Утасны дугаараа оруулна уу',
                    style: TextStyle(color: primaryColor),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 50, left: 35, right: 35, bottom: 30),
                    child: Form(
                      key: _registerFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // VerifyInput(
                          //   length: 8,
                          //   itemSize: 35,
                          //   keyboardType: TextInputType.numberWithOptions(),
                          //   onCompleted: (val) {
                          //     setState(
                          //       () {
                          //         phone = val;
                          //       },
                          //     );
                          //   },
                          //   itemDecoration: BoxDecoration(
                          //     border: Border(
                          //       bottom: BorderSide(
                          //         width: .7,
                          //         color: Colors.black54,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          /*VerifyCodeInput(
                            onComplete: (String value) {
                              print('Your input code is : $value');
                              phone = value;
                            },
                          ),*/
                          Container(
                            padding: EdgeInsets.all(2.0),
                            alignment: Alignment.center,
                            height: 48,
                            decoration: BoxDecoration(
                              //color: secondaryLighten.withAlpha(16),
                              border: Border.all(
                                color: primaryColor,
                                width: 1,
                              ),
                              borderRadius: new BorderRadius.circular(50.0),
                            ),
                            child: TextFormField(
                              controller: phone,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Утасны дугаараа оруулна уу',
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(147, 157, 186, .78),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(0.0),
                                  child: Icon(
                                    FontAwesomeIcons.mobileAlt,
                                    color: primaryColor,
                                    size: 18,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                          SizedBox(
                            height: 14.0,
                          ),
                          Container(
                            height: 46,
                            margin: EdgeInsets.only(top: 13),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: new BorderRadius.circular(50.0),
                            ),
                            child: MaterialButton(
                              child: Container(
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        'Илгээх'.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color.fromRGBO(255, 255, 255, .8),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onPressed: () {
                                final form = _registerFormKey.currentState;
                                if (form!.validate()) {
                                  form.save();
                                  doRegister(context);
                                }
                              },
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
          SafeArea(
            child: Container(
              height: 46,
              child: MaterialButton(
                padding: EdgeInsets.only(top: 15, left: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      //Icons.ios_arrow_back,
                      FontAwesomeIcons.arrowLeft,
                      color: primaryColor,
                      size: 16,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Буцах',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
