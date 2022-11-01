import 'package:validators/validators.dart';
import 'package:flutter/material.dart';
import 'element_option.dart';

class SelectWidget extends StatefulWidget {
  final ElementOption option;

  SelectWidget(
    this.option, {
    Key? key,
  }) : super(key: key);

  @override
  _SelectWidgetState createState() => _SelectWidgetState();
}

class _SelectWidgetState extends State<SelectWidget> {
  String relationKey = "";

  @override
  void initState() {
    super.initState();
    setRelationKey();
  }

  setRelationKey() {
    setState(() {
      relationKey = widget.option.component;
      if (widget.option.relations[widget.option.component] == null) {
        if (widget.option.meta["relation"]["table"] != null) {
          relationKey = widget.option.meta["relation"]["table"];
        }
      }
    });
  }

  void onChange(String? value) {
    setState(() {
      if (value != null) {
        if (isNumeric(value)) {
          var numberValue = int.parse(value);
          widget.option.onChange(widget.option.component, numberValue);
        } else {
          widget.option.onChange(widget.option.component, value);
        }
      }
    });
  }

  List<dynamic> getOptions() {
    if (widget.option.meta["options"] != null &&
        widget.option.meta["options"].length >= 1) {
      return filterOption(widget.option.meta["options"]);
    } else {
      return filterOption(widget.option.relations[relationKey]);
    }
  }

  List<dynamic> filterOption(List<dynamic> _options) {
    if (widget.option.meta["relation"]["parentFieldOfForm"] != null) {
      if (widget.option
              .form[widget.option.meta["relation"]["parentFieldOfForm"]] !=
          null) {
        return _options
            .where((i) =>
                i["parent_value"] ==
                widget.option
                    .form[widget.option.meta["relation"]["parentFieldOfForm"]])
            .toList();
      } else {
        return _options.length >= 1 ? _options : [];
      }
    } else {
      return _options.length >= 1 ? _options : [];
    }
    return [];
  }

  String getDefaultValue(List<dynamic> options) {
    if (widget.option.form[widget.option.component] == null ||
        widget.option.form[widget.option.component] == "" ||
        widget.option.form[widget.option.component] == 0) {
      return options[0]["value"].toString();
    } else {
      int selectedIndex = options.indexWhere((note) =>
          note["value"].toString() ==
          widget.option.form[widget.option.component].toString());

      if (selectedIndex >= 0) {
        return widget.option.form[widget.option.component].toString();
      } else {
        return options[0]["value"].toString();
      }
    }
  }

  Widget build(BuildContext context) {
    var options = getOptions();
    var defaultValue = getDefaultValue(options);

    return new Container(
        margin: new EdgeInsets.only(top: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(widget.option.label,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
            new Container(
              height: 75,
              child: new DropdownButtonFormField<String>(
                isDense: false,
                itemHeight: 48.0,
                isExpanded: true,
                hint: new Text(widget.option.label),
                value: defaultValue,
                onChanged: onChange,
                validator: (_) {
                  for (int i = 0; i < widget.option.rules!.length; i++) {
                    if (widget.option.rules![i](
                            widget.option.form[widget.option.component]) !=
                        null)
                      return widget.option.rules![i](
                          widget.option.form[widget.option.component]);
                  }
                  return null;
                },
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "",
                  helperText: "",
                  contentPadding: const EdgeInsets.all(0.0),
                  filled: true,
                  fillColor: Color(0xFFFFF5EE),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 1.0,
                      color: Color(0xFFF3705A),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 1.0,
                      color: Color(0xFFF3705A),
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 1.0,
                      color: Color(0xFFF3705A),
                    ),
                  ),
                ),
                items: options.map<DropdownMenuItem<String>>((dynamic data) {
                  return DropdownMenuItem<String>(
                    value: data['value'].toString(),
                    child: new Text(
                      data['label'].toString(),
                      style: new TextStyle(color: Colors.black),
                      overflow: TextOverflow.fade,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ));
  }
}
