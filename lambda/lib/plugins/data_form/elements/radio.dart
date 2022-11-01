import 'package:flutter/material.dart';

import 'element_option.dart';

class RadioWidget extends StatefulWidget {
  final ElementOption option;

  RadioWidget(this.option, {Key? key}) : super(key: key);

  @override
  _RadioWidgetState createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<RadioWidget> {
  dynamic radioValue;

  @override
  void initState() {
    super.initState();
    this.setDefaultValue();
  }

  void setDefaultValue() {
    if (widget.option.form[widget.option.component] == null ||
        widget.option.form[widget.option.component] == "" ||
        widget.option.form[widget.option.component] == 0) {
      setState(() {
        radioValue = widget
            .option.relations[widget.option.component][0]["value"]
            .toString();
      });
    } else {
      radioValue = widget.option.form[widget.option.component].toString();
    }
  }

  void onChange(dynamic value) {
    setState(() {
      radioValue = value;

      widget.option.onChange(widget.option.component, value);
    });
  }

  Widget build(BuildContext context) {
    List<Widget> radios = [];

//    radios.add(new Text(widget.option.label,
//        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)));

    for (var i = 0; i < widget.option.meta["options"].length; i++) {
      radios.add(Radio(
          value: widget.option.meta["options"][i]['value'],
          groupValue: radioValue,
          activeColor: Color.fromRGBO(99, 120, 136, 1),
          onChanged: onChange));
      radios.add(GestureDetector(
        onTap: () {
          setState(() {
            onChange(widget.option.meta["options"][i]['value']);
          });
        },
        child: Container(
          padding: EdgeInsets.only(top: 15.0, bottom: 12.0),
          child: new Text(widget.option.meta["options"][i]['label']),
        ),
      ));
//        new ListTile(
//            title: new Text(widget.option.meta["options"][i]['label']),
//            leading: Radio(
//                value: widget.option.meta["options"][i]['value'],
//                groupValue: radioValue,
//                onChanged: onChange)),

    }

    return new Container(
      margin: new EdgeInsets.only(top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new Text(widget.option.label,
              style: new TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: Color.fromRGBO(99, 120, 136, 1))),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: radios,
          )
        ],
      ),
    );
  }
}
