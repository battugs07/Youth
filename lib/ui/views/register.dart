import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lambda/modules/agent/agent_controller.dart';
import 'package:lambda/modules/responseModel.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/core/viewmodels/aimag_model.dart';
import 'package:youth/core/viewmodels/user_model.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:youth/ui/views/verify.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:provider/provider.dart';
import 'package:lambda/plugins/progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/user.dart';
import '../../locator.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  AgentController agentController = locator<AgentController>();
  bool loading = false;
  String email = '';
  String lastname = '';
  String firstname = '';
  String password = '';
  int aimag_id = 0;
  int soum_id = 0;

  NetworkUtil _netUtil = new NetworkUtil();
  GlobalKey key = new GlobalKey();
  List _aimagList = [];
  List _sumList = [];

  List<DropdownMenuItem<String>>? _dropDownMenuItemsAimag;
  List<DropdownMenuItem<String>>? _dropDownMenuItemsSum;
  var _currentAimag;
  var _currentSum;

  Future getAimagList() async {
    var url = baseUrl + '/api/mobile/aimag';
    var response = await _netUtil.get(url);
    print(response);
    var parsed = response.data as List<dynamic>;
    for (var item in parsed) {
      _aimagList.add(item);
    }
    _dropDownMenuItemsAimag = getDropDownMenuAimag();
    //_currentAimag = _dropDownMenuItemsAimag[0].value;

    setState(() {});
  }

  Future getSumList(aimagID) async {
    var url = baseUrl + '/api/mobile/soum/' + aimagID;
    var response = await _netUtil.get(url);
    var parsed = response.data as List<dynamic>;
    _sumList = [];
    for (var item in parsed) {
      _sumList.add(item);
    }
    _dropDownMenuItemsSum = getDropDownMenuSum();
    _currentSum = _dropDownMenuItemsSum![0].value;
    setState(() {});
  }

  @override
  void initState() {
    getAimagList();
    getSumList(22);
    super.initState();
  }

  doRegister(BuildContext context) async {
    ProgressDialog pr = new ProgressDialog(context, ProgressDialogType.Normal);
    FocusScope.of(context).requestFocus(new FocusNode());
    await Future.delayed(Duration(milliseconds: 300));

    pr.setMessage('Түр хүлээнэ үү...');
    pr.show();

    final state = Provider.of<UserModel>(context, listen: false);
    User? user = state.getUser;

    ResponseModel response = await _netUtil.post('/api/mobile/register-bio', {
      "user": user!.id,
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "aimag_id": _currentAimag,
      "soum_id": _currentSum,
      "password": password,
    });

    if (response.status) {
      User user = new User.fromJson(response.data);

      // await agentController.init(context);
      pr.update(message: 'Амжилттай бүртгэгдлээ', type: 'success');
      await new Future.delayed(const Duration(seconds: 1));
      pr.hide();

      bool? isAuth = await agentController.doLogin(context, '/api/mobile/login', user.phone!, password);

      if (isAuth!) {
        var prefs = await SharedPreferences.getInstance();
        final userState = Provider.of<UserModel>(context, listen: false);
        String? userData = prefs.getString('user');
        User user = new User.fromJson(jsonDecode(userData!));
        userState.setUser(user);
        Navigator.pushReplacementNamed(context, '/main');
      }
    } else {
      pr.update(message: response.msg, type: 'error');
      await new Future.delayed(const Duration(milliseconds: 1500));
      pr.hide();
    }
  }

  List<DropdownMenuItem<String>> getDropDownMenuAimag() {
    List<DropdownMenuItem<String>> items = [];

    _aimagList.forEach(
      (city) {
        items.add(
          new DropdownMenuItem(
            value: city["id"].toString(),
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 10,
                  color: Color(0xff0079FF).withOpacity(0.7),
                ),
                SizedBox(width: 10),
                Text(
                  city["ner"],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    //fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            // child: new Text(city["ner"])
          ),
        );
      },
    );

    return items;
  }

  List<DropdownMenuItem<String>> getDropDownMenuSum() {
    print('getDropDownMenuSum');
    List<DropdownMenuItem<String>> items = [];
    _sumList.forEach(
      (city) {
        items.add(
          new DropdownMenuItem(
            value: city["id"].toString(),
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 10,
                  color: Color(0xff0079FF).withOpacity(0.7),
                ),
                SizedBox(width: 10),
                Text(
                  city["ner"],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    //fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            // child: new Text(city["ner"])
          ),
        );
      },
    );

    return items;
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
                  Container(
                    child: Image.asset(
                      'assets/images/register.png',
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
                          Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 0.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                //color: secondaryLighten.withAlpha(16),
                                borderRadius: BorderRadius.circular(50.0),
                                border: Border.all(
                                  color: Color.fromRGBO(147, 157, 186, .78),
                                  style: BorderStyle.solid,
                                  width: 1.2,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Row(
                                    children: [
                                      Icon(
                                        Icons.account_circle,
                                        color: Color.fromRGBO(147, 157, 186, .78),
                                        size: 20.09,
                                      ),
                                      SizedBox(width: 15),
                                      Text(
                                        'Аймаг сонгох',
                                        style: TextStyle(
                                          color: Color.fromRGBO(147, 157, 186, .78),
                                          fontSize: 18,
                                          //fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  value: _currentAimag,
                                  items: _dropDownMenuItemsAimag,
                                  onChanged: changedDropDownItemAimag("d"),
                                  isExpanded: true,
                                  iconSize: 30.0,
                                  //style: TextStyle(color: Colors.lightBlue),
                                  dropdownColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 14.0,
                          ),
                          Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.0,
                                vertical: 0.0,
                              ),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                //color: secondaryLighten.withAlpha(16),
                                borderRadius: BorderRadius.circular(50.0),
                                border: Border.all(
                                  color: Color.fromRGBO(147, 157, 186, .78),
                                  style: BorderStyle.solid,
                                  width: 1,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                hint: Row(
                                  children: [
                                    Icon(
                                      Icons.location_history_rounded,
                                      color: Color.fromRGBO(147, 157, 186, .78),
                                      size: 20.09,
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      'Сум сонгох',
                                      style: TextStyle(
                                        color: Color.fromRGBO(147, 157, 186, .78),
                                        fontSize: 18,
                                        //fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                                value: _currentSum,
                                items: _dropDownMenuItemsSum,
                                onChanged: changedDropDownItemSum(''),
                                isExpanded: true,
                                iconSize: 30.0,
                                //style: TextStyle(color: Colors.lightBlue),
                                dropdownColor: Colors.white,
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            initialValue: lastname,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(2),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              labelText: 'Овог',
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(147, 157, 186, .78),
                                fontSize: 18,
                                //fontWeight: FontWeight.w400,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(width: 1),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(width: 1, color: Colors.red),
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.account_circle,
                                  color: Color.fromRGBO(147, 157, 186, .78),
                                  size: 22,
                                ),
                              ),
                            ),
                            validator: (val) {
                              return val!.isEmpty ? 'Овог оо оруулна уу!' : null;
                            },
                            onSaved: (val) => lastname = val!,
                          ),
                          SizedBox(
                            height: 14.0,
                          ),
                          TextFormField(
                            initialValue: firstname,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(2),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              labelText: 'Нэр',
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(147, 157, 186, .78),
                                fontSize: 18,
                                //fontWeight: FontWeight.w400,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(width: 1),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(width: 1, color: Colors.red),
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.account_circle,
                                  color: Color.fromRGBO(147, 157, 186, .78),
                                  size: 22,
                                ),
                              ),
                            ),
                            validator: (val) {
                              return val!.isEmpty ? 'Нэрээ оруулна уу!' : null;
                            },
                            onSaved: (val) => firstname = val!,
                          ),
                          SizedBox(
                            height: 14.0,
                          ),
                          TextFormField(
                            initialValue: email,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(2),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              labelText: 'Имэйл хаяг',
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(147, 157, 186, .78),
                                fontSize: 18,
                                //fontWeight: FontWeight.w400,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(width: 1),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(width: 1, color: Colors.red),
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.account_circle,
                                  color: Color.fromRGBO(147, 157, 186, .78),
                                  size: 22,
                                ),
                              ),
                            ),
                            validator: (val) {
                              return val!.isEmpty ? 'Имэйл хаягаа оруулна уу!' : null;
                            },
                            onSaved: (val) => email = val!,
                          ),
                          SizedBox(
                            height: 14.0,
                          ),
                          TextFormField(
                            initialValue: password,
                            obscureText: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(2),
                              border: OutlineInputBorder(borderSide: BorderSide(width: 1), borderRadius: BorderRadius.circular(25)),
                              labelText: 'Нууц үг',
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(147, 157, 186, .78),
                                fontSize: 18,
                                //fontWeight: FontWeight.w400,
                              ),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide(width: 1)),
                              focusedErrorBorder:
                                  OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide(width: 1, color: Colors.red)),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Color.fromRGBO(147, 157, 186, .78),
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
                              color: Color(0xff0079FF),
                              borderRadius: new BorderRadius.circular(50.0),
                            ),
                            child: MaterialButton(
                              child: Container(
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        'Бүртгүүлэх',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color.fromRGBO(255, 255, 255, .8),
                                          fontSize: 16,
                                          //fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onPressed: () {
                                final form = this._registerFormKey.currentState;
                                if (form!.validate()) {
                                  form.save();
                                  this.doRegister(context);
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
              height: 36,
              child: MaterialButton(
                  padding: EdgeInsets.only(top: 15, left: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        //Ionicons.ios_arrow_back,
                        FontAwesomeIcons.arrowLeft,
                        color: Color(0xff0079FF),
                        size: 14,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Буцах',
                        style: TextStyle(
                          color: Color(0xff0079FF),
                          fontSize: 16,
                          //fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () => Navigator.pop(context)),
            ),
          ),
        ],
      ),
    );
  }

  changedDropDownItemAimag(String selectedAimag) {
    print('changed aimag');
    print(selectedAimag);
    getSumList(selectedAimag);
    setState(() {
      _currentAimag = selectedAimag;
    });
  }

  changedDropDownItemSum(String selectedSum) {
    setState(() {
      _currentSum = selectedSum;
    });
  }

  void showMoreText(String text) {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: text,
        textStyle: TextStyle(color: Colors.black),
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.9,
        backgroundColor: Colors.white,
        padding: EdgeInsets.all(4.0),
        borderRadius: BorderRadius.circular(10.0));

    /// show the popup for specific widget
    popup.show(
      widgetKey: key,
    );
  }
}
