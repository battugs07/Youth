import 'package:flutter/material.dart';
import '../element_option.dart';
import 'package:lambda/modules/network_util.dart';

class SubformWidget extends StatefulWidget {
  final ElementOption option;

  SubformWidget(this.option, {Key? key}) : super(key: key);

  @override
  _SubformWidgetState createState() => _SubformWidgetState();
}

class _SubformWidgetState extends State<SubformWidget> {
  NetworkUtil _http = new NetworkUtil();
  bool loading = true;

  @override
  void initState() {
    print(widget.option.meta);

    super.initState();
  }

  void ErrorAlert(Function tryAgian, {String errorTxt = ""}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return AlertDialog(
          title: new Text("Сервертэй холбогдож чадсангүй"),
          content: new Text(
              errorTxt == "" ? "Интернет холболт оо шалгана уу" : errorTxt),
          actions: <Widget>[
            MaterialButton(
              child: Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(4)),
                child: Text(
                  "Дахин оролдох",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                tryAgian();
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.only(top: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[Text(widget.option.meta["name"])],
        ));
  }
}
