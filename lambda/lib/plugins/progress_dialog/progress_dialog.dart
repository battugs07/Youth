import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

String _dialogMessage = "Loading...";

enum ProgressDialogType { Normal, Download, Success, Error }

ProgressDialogType _progressDialogType = ProgressDialogType.Normal;
double _progress = 0.0;

bool _isShowing = false;

class ProgressDialog {
  _MyDialog? _dialog;

  BuildContext? _buildContext;
  BuildContext? _context;

  ProgressDialog(
      BuildContext buildContext, ProgressDialogType progressDialogtype) {
    _buildContext = buildContext;
    _progressDialogType = progressDialogtype;
  }

  void setMessage(String mess) {
    _dialogMessage = mess;
  }

  void update({double? progress, String? message, String? type}) {
    if (_progressDialogType == ProgressDialogType.Download) {
      _progress = progress ?? 0;
    }

    if (type == 'success') {
      _progressDialogType = ProgressDialogType.Success;
    }
    if (type == 'error') {
      _progressDialogType = ProgressDialogType.Error;
    }

    _dialogMessage = message ?? "";
    print('working until here');
    _dialog?.update();
  }

  bool isShowing() {
    return _isShowing;
  }

  void hide() {
    _isShowing = false;
    _progressDialogType = ProgressDialogType.Normal;
    if (_context != null) {
      Navigator.of(_context!).pop();
    }
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
            width: 145,
            height: 145,
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

  Widget drawMsgContent() {
    if (_progressDialogType == ProgressDialogType.Success) {
      return BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                CupertinoIcons.checkmark_alt_circle,
                size: 42,
                color: Color(0xff2ecc71),
              ),
              SizedBox(height: 10.0),
              Wrap(
                children: <Widget>[
                  Text(
                    _dialogMessage.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xff2ecc71),
                        fontSize: 10.0,
                        fontWeight: FontWeight.w500),
                  )
                ],
              )
            ],
          ),
        ),
      );
    }

    if (_progressDialogType == ProgressDialogType.Error) {
      return BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                CupertinoIcons.exclamationmark_circle,
                size: 48,
                color: Color(0xffe74c3c),
              ),
              SizedBox(height: 10.0),
              Wrap(
                children: <Widget>[
                  Text(
                    _dialogMessage.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xffe74c3c),
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
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
            child: Text(_dialogMessage,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500)),
            top: 25.0,
          ),
          Positioned(
            child: Text("$_progress/100",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400)),
            bottom: 15.0,
            right: 15.0,
          ),
        ],
      );
    }

    return BackdropFilter(
      filter: new ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitRing(color: Color(0xff005fc2), size: 48.0, lineWidth: 2),
            SizedBox(height: 15.0),
            Wrap(
              children: <Widget>[
                Text(
                  _dialogMessage.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff005fc2),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(child: drawMsgContent());
  }
}
