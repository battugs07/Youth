import 'package:flutter/material.dart';
import 'element_option.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:date_format/date_format.dart';

class DateTimePickerWidget extends StatefulWidget {
  final ElementOption option;

  final bool dateTimeMode;

  DateTimePickerWidget(this.option, {Key? key, this.dateTimeMode = false})
      : super(key: key);

  @override
  _DateTimePickerWidgetState createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  @override
  void initState() {
    super.initState();
  }

  void onChange(DateTime? value) {
    if (value != null) {
      setState(() {
        if (widget.dateTimeMode) {
          widget.option.onChange(
              widget.option.component,
              formatDate(
                  value, [yyyy, '-', mm, '-', dd, " ", HH, ":", nn, ":", ss]));
        } else {
          widget.option.onChange(widget.option.component,
              formatDate(value, [yyyy, '-', mm, '-', dd]));
        }
      });
    } else {
      widget.option.onChange(widget.option.component, null);
    }
  }

  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.only(top: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(widget.option.label,
                style: new TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                    color: Color.fromRGBO(99, 120, 136, 1))),
            SizedBox(height: 4.0),
            new DateTimeField(
              format: widget.dateTimeMode
                  ? DateFormat("yyyy-MM-dd HH:mm:ss")
                  : DateFormat("yyyy-MM-dd"),
              onShowPicker: widget.dateTimeMode
                  ? (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.combine(date, time);
                      } else {
                        return currentValue;
                      }
                    }
                  : (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    },
              initialValue: widget.option.form[widget.option.component] != null
                  ? DateTime.parse(widget.option.form[widget.option.component])
                  : null,
              style: TextStyle(
                  color: Color.fromRGBO(99, 120, 136, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
              decoration: new InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                hintText: widget.option.label,
                helperText: "",
                hintStyle: TextStyle(
                    color: Color.fromRGBO(99, 120, 136, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(0, 102, 204, 1)),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(223, 223, 223, 1)),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
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
