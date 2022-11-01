import 'package:flutter/material.dart';
import 'element_option.dart';

class CheckboxWidget extends StatefulWidget {
  final ElementOption option;

  CheckboxWidget(this.option, {Key? key}) : super(key: key);

  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  @override
  void initState() {
    super.initState();
  }

  void onChange(bool? value) {
    setState(() {
      if (value == null) {
        widget.option.onChange(widget.option.component, 0);
      } else {
        if (value) {
          widget.option.onChange(widget.option.component, 1);
        } else {
          widget.option.onChange(widget.option.component, 0);
        }
      }
    });
  }

  Widget _checkbox(FormFieldState<dynamic> field) {
    return Checkbox(
      value: widget.option.form[widget.option.component] != null
          ? widget.option.form[widget.option.component] == 1
          : false,
      onChanged: onChange,
    );
  }

  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.only(top: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
//            new Text(widget.option.label,
//                style:
//                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
            new FormField(
              validator: (_) {
                for (int i = 0; i < widget.option.rules!.length; i++) {
                  if (widget.option.rules![i](
                          widget.option.form[widget.option.component]) !=
                      null)
                    return widget.option
                        .rules![i](widget.option.form[widget.option.component]);
                }
                return null;
              },
              builder: (FormFieldState<dynamic> field) {
                return InputDecorator(
                  decoration: new InputDecoration(
                    hintText: widget.option.label,
                    helperText: "",
                  ),
                  child: ListTile(
                    dense: true,
                    isThreeLine: false,
                    contentPadding: EdgeInsets.all(0.0),
                    leading: _checkbox(field),
                    title: Text(widget.option.label,
                        style: new TextStyle(fontSize: 16.0)),
                    onTap: () {
                      bool newValue =
                          widget.option.form[widget.option.component] != null
                              ? widget.option.form[widget.option.component] == 1
                                  ? false
                                  : true
                              : true;
                      print(newValue);
                      onChange(newValue);
                    },
                  ),
                );
              },
            ),
          ],
        ));
  }
}
