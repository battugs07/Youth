import 'package:flutter/material.dart';
import 'element_option.dart';

class InputWidget extends StatefulWidget {
  final ElementOption option;
  final bool? obscureText;
  final int? maxLines;
  final TextInputType? keyboardType;

  InputWidget(this.option,
      {Key? key,
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.maxLines = 1})
      : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  void initState() {
    super.initState();
  }

  void onChange(String value) {
    setState(() {
      if (widget.option.meta["formType"] == "Number") {
        widget.option.onChange(widget.option.component, int.parse(value));
      } else {
        widget.option.onChange(widget.option.component, value);
      }
    });
  }

  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.only(top: 5.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(widget.option.label,
                style: new TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                    color: Color.fromRGBO(99, 120, 136, 1))),
            SizedBox(height: 4.0),
            new TextFormField(
              controller: null,
              obscureText: widget.obscureText ?? false,
              maxLines: widget.maxLines,
              keyboardType: widget.keyboardType,
              initialValue: widget.option.form[widget.option.component] != null
                  ? widget.option.meta["formType"] == "Number" &&
                          widget.option.form[widget.option.component] == 0
                      ? null
                      : widget.option.form[widget.option.component].toString()
                  : null,
              // decoration: new InputDecoration(
              //   contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
              //   isDense: true,
              //   hintText: widget.option.label,
              //   helperText: "",
              //   filled: true,
              //   fillColor: Theme.of(context).scaffoldBackgroundColor,
              //   enabledBorder: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(8),
              //     borderSide: BorderSide(
              //       width: 1.0,
              //       color: Color(0x80000000),
              //     ),
              //   ),
              //   focusedBorder: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(8),
              //     borderSide: BorderSide(
              //       width: 1.0,
              //       color: Color(0x80000000),
              //     ),
              //   ),
              //   errorBorder: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(8),
              //     borderSide: BorderSide(
              //       width: 1.0,
              //       color: Color(0x80000000),
              //     ),
              //   ),
              // ),

              style: TextStyle(
                  color: Color.fromRGBO(99, 120, 136, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(0, 102, 204, 1)),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(223, 223, 223, 1)),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  fillColor: Color.fromRGBO(0, 102, 204, 1),
                  hintText: '',
                  hintStyle: TextStyle(
                      color: Color.fromRGBO(99, 120, 136, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.normal)),
              onChanged: onChange,
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
            ),
          ],
        ));
  }
}
