import 'dart:convert';

import 'package:lambda/modules/network_util.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/ui/views/about.dart';
import 'package:youth/ui/views/privacy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:youth/ui/views/main.dart';
import 'package:youth/ui/views/terms.dart';

class SidebarScreen extends StatefulWidget {
  final contact;

  const SidebarScreen({Key? key, this.contact}) : super(key: key);
  @override
  _SidebarScreenState createState() => _SidebarScreenState();
}

class _SidebarScreenState extends State<SidebarScreen> {
  @override
  void initState() {
    super.initState();
    print(widget.contact);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.lightGreen,
        // image: DecorationImage(
        //     image: AssetImage('assets/images/logo.png'),
        //     fit: BoxFit.scaleDown,
        //     alignment: Alignment.bottomLeft),
      ),
      child: Material(
          child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.1, .9],
                colors: [
                  // Color.fromRGBO(20, 27, 49, .98),
                  // Color.fromRGBO(39, 60, 117, .75),
                  Colors.white,
                  Colors.white
                ],
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 80.0,
                    top: 50,
                    bottom: 20,
                  ),
                  child: Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage("assets/images/logo.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: ListView(
                      children: <Widget>[
                        Container(
                          height: 34,
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => AboutScreen(),
                                ),
                              );
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.home_outlined,
                                  color: primaryColor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Бидний тухай',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 34,
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => PrivacyScreen(),
                                ),
                              );
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.lock_outline, color: primaryColor),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Нууцлал хамгаалал',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 34,
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => TermsScreen(),
                                ),
                              );
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.check_circle_outline, color: primaryColor),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Үйлчилгээний нөхцөл',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20, top: 90),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(bottom: 5),
                                margin: EdgeInsets.only(right: 30),
                                decoration: BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(
                                    color: primaryColor,
                                    width: 1.4,
                                  ),
                                )),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Холбоо барих'.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.phone_callback_outlined,
                                    size: 17,
                                    color: primaryColor,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 190,
                                    child: Text(
                                      widget.contact == null ? '' : widget.contact['phone'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.mail_outline_outlined,
                                    size: 17,
                                    color: primaryColor,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    widget.contact == null ? '' : widget.contact['email'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 17,
                                    color: primaryColor,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      widget.contact == null ? '' : widget.contact['address'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Copyright © 2020 ГБХЗХГ \n developed by Bitsoft LLC',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
          )
        ],
      )),
    );
  }
}
