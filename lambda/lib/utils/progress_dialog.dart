import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

String _dialogMessage = "Loading...";

enum ProgressDialogType { Normal, Download, Success, Error }

ProgressDialogType? _progressDialogType = ProgressDialogType.Normal;
double _progress = 0.0;

bool _isShowing = false;

Color secondaryColor = Color(0xffffc61e);

class ProgressDialog {
  _MyDialog? _dialog;

  BuildContext? _buildContext, _context;

  ProgressDialog(BuildContext? buildContext, ProgressDialogType? progressDialogtype) {
    _buildContext = buildContext;
    _progressDialogType = progressDialogtype;
  }

  void setMessage(String mess) {
    _dialogMessage = mess;
  }

  void update({double? progress, String? message, String? type}) {
    if (_progressDialogType == ProgressDialogType.Download) {
      _progress = progress!;
    }

    if (type == 'success') {
      _progressDialogType = ProgressDialogType.Success;
    }
    if (type == 'error') {
      _progressDialogType = ProgressDialogType.Error;
    }

    _dialogMessage = message!;
    print('working until here');
    _dialog!.update();
  }

  bool isShowing() {
    return _isShowing;
  }

  void hide() {
    _isShowing = false;
    _progressDialogType = ProgressDialogType.Normal;
    Navigator.of(_context!).pop();
  }

  void show() {
    _dialog = new _MyDialog();
    _isShowing = true;

    showDialog<dynamic>(
      context: _buildContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        _context = context;
        return Center(
          child: Container(
            // width: 145,
            // height: 145,
            child: _dialog,
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class _MyDialog extends StatefulWidget {
  var _dialog = new _MyDialogState();

  update() {
    print('dialog update');
    _dialog.changeState();
  }

  @override
  // ignore: must_be_immutable
  State<StatefulWidget> createState() {
    return _dialog;
  }
}

class _MyDialogState extends State<_MyDialog> {
  changeState() {
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _isShowing = false;
  }

  Widget? drawMsgContent() {
    if (_progressDialogType == ProgressDialogType.Normal) {
      return Center(
          child: BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitRing(color: secondaryColor, size: 48.0, lineWidth: 2),
            SizedBox(height: 15.0),
            Wrap(
              children: <Widget>[
                Text(
                  _dialogMessage != null ? _dialogMessage.toUpperCase() : '',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: secondaryColor, fontSize: 12.0, fontWeight: FontWeight.w500),
                )
              ],
            )
          ],
        ),
      ));
    }

    if (_progressDialogType == ProgressDialogType.Success) {
      return Center(
          child: BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                EvilIcons.check,
                size: 48,
                color: Color(0xff1abc9c),
              ),
              SizedBox(height: 10.0),
              Wrap(
                children: <Widget>[
                  Text(
                    _dialogMessage != null ? _dialogMessage.toUpperCase() : '',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xff1abc9c), fontSize: 12.0, fontWeight: FontWeight.w500),
                  )
                ],
              )
            ],
          ),
        ),
      ));
    }

    if (_progressDialogType == ProgressDialogType.Error) {
      return Center(
        child: BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                EvilIcons.exclamation,
                size: 48,
                color: Color(0xffe74c3c),
              ),
              SizedBox(height: 10.0),
              Wrap(
                children: <Widget>[
                  Text(
                    _dialogMessage != null ? _dialogMessage.toUpperCase() : '',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xffe74c3c), fontSize: 12.0, fontWeight: FontWeight.w500),
                  )
                ],
              )
            ],
          ),
        ),
      );
    }

    if (_progressDialogType == ProgressDialogType.Download) {
      return Stack(
        children: <Widget>[
          Positioned(
            child: Text(_dialogMessage != null ? _dialogMessage : '',
                style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w500)),
            top: 25.0,
          ),
          Positioned(
            child: Text("$_progress/100", style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w400)),
            bottom: 15.0,
            right: 15.0,
          ),
        ],
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.transparent),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: drawMsgContent(),
        ));
  }
}
