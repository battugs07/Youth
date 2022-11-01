import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lambda/modules/responseModel.dart';
import 'package:youth/core/viewmodels/user_model.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:youth/ui/views/verify.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:provider/provider.dart';
import 'package:lambda/plugins/progress_dialog/progress_dialog.dart';
import '../../core/models/user.dart';

class ResetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  bool loading = false;
  String password = '';
  NetworkUtil _netUtil = new NetworkUtil();

  @override
  void initState() {
    super.initState();
  }

  doReset() async {
    ProgressDialog pr = new ProgressDialog(context, ProgressDialogType.Normal);
    FocusScope.of(context).requestFocus(new FocusNode());
    await Future.delayed(Duration(milliseconds: 500));

    pr.setMessage('Түр хүлээнэ үү...');
    pr.show();

    final state = Provider.of<UserModel>(context, listen: false);
    User? user = state.getUser;

    ResponseModel response = await _netUtil.post('/api/mobile/reset/password', {'user': user?.id, 'password': password});
    //print(user.id);
    //print(password);
    if (response.status) {
      User user = new User.fromJson(response.data);
      final state = Provider.of<UserModel>(context, listen: false);
      state.setUser(user);

      pr.update(message: response.msg, type: 'success');
      await new Future.delayed(const Duration(seconds: 1));
      pr.hide();

      Navigator.pushReplacementNamed(context, '/login');
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryColor),
        // title: const Text(
        //   'Мэдэгдэл',
        //   style: TextStyle(color: primaryColor),
        // ),
        backgroundColor: Color(0xfff2f3fa),
        elevation: 0,
      ),
      backgroundColor: Color(0xfff2f3fa),
      body: Stack(
        children: <Widget>[
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      'assets/images/register.png',
                      height: 150,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 50, left: 35, right: 35, bottom: 30),
                    child: Form(
                      key: _registerFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            initialValue: password,
                            obscureText: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(2),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              labelText: 'Шинэ нууц үг',
                              hintStyle: TextStyle(
                                color: primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(width: 1),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: primaryColor,
                                size: 22,
                              ),
                            ),
                            onSaved: (val) => password = val!,
                            validator: (val) {
                              return val!.isEmpty ? 'Нууц үгээ оруулна уу!' : null;
                            },
                          ),
                          SizedBox(
                            height: 25.0,
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
                                        'Нууц үг солих'.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Color.fromRGBO(255, 255, 255, .8), fontSize: 16, fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onPressed: () {
                                final form = this._registerFormKey.currentState;
                                if (form!.validate()) {
                                  form.save();
                                  this.doReset();
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
        ],
      ),
    );
  }
}
