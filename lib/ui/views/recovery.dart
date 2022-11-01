import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lambda/modules/responseModel.dart';
import 'package:youth/core/viewmodels/user_model.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:youth/ui/styles/_colors.dart' as prefix0;
import 'package:youth/ui/views/verify.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:provider/provider.dart';
import 'package:lambda/plugins/progress_dialog/progress_dialog.dart';
import '../../core/models/user.dart';

class RecoveryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController phone = new TextEditingController();
  bool loading = false;

  NetworkUtil _netUtil = new NetworkUtil();

  @override
  void initState() {
    super.initState();
  }

  doRecovery(context) async {
    ProgressDialog pr = new ProgressDialog(context, ProgressDialogType.Normal);
    FocusScope.of(context).requestFocus(new FocusNode());
    await Future.delayed(Duration(milliseconds: 300));

    pr.setMessage('Түр хүлээнэ үү...');
    pr.show();

    ResponseModel response = await _netUtil.post('/api/mobile/recovery', {
      "phone": phone.text,
    });

    print(response);

    if (response.status) {
      User user = new User.fromJson(response.data);
      final state = Provider.of<UserModel>(context, listen: false);
      state.setUser(user);

      pr.update(message: 'Нууц үг сэргээх код илгээгдлээ', type: 'success');
      await new Future.delayed(const Duration(seconds: 1));
      pr.hide();

      Navigator.push(context, CupertinoPageRoute(builder: (context) => VerifyPage('recover')));
    } else {
      pr.update(message: response.msg, type: 'error');
      await new Future.delayed(const Duration(milliseconds: 1500));
      pr.hide();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryColor),
        // title: const Text(
        //   'Мэдэгдэл',
        //   style: TextStyle(color: primaryColor),
        // ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Image.asset(
                        'assets/images/lock.png',
                        height: 150,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 50,
                        left: 35,
                        right: 35,
                        bottom: 30,
                      ),
                      child: Form(
                        key: _registerFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
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
                            Container(
                              height: 42,
                              margin: EdgeInsets.only(top: 25),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: new BorderRadius.circular(50.0),
                                boxShadow: [shadow],
                              ),
                              child: MaterialButton(
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      'Send reset code'.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  //print(1234);
                                  this.doRecovery(context);
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
            // SafeArea(
            //   child: Container(
            //     height: 46,
            //     child: FlatButton(
            //       padding: EdgeInsets.only(top: 15, left: 20),
            //       child: Row(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: <Widget>[
            //           Icon(
            //             //Icons.ios_arrow_back,
            //             FontAwesomeIcons.arrowLeft,
            //             color: primaryColor,
            //             size: 16,
            //           ),
            //           SizedBox(
            //             width: 5,
            //           ),
            //           Text(
            //             'Буцах',
            //             style: TextStyle(
            //               color: primaryColor,
            //               fontSize: 17,
            //               fontWeight: FontWeight.w500,
            //             ),
            //           ),
            //         ],
            //       ),
            //       onPressed: () => Navigator.pop(context),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
