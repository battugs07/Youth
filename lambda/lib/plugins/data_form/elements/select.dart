import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'element_option.dart';

class SelectModel {
  int? value;
  String? label;

  SelectModel({this.value, this.label});

  SelectModel.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['label'] = this.label;
    return data;
  }

  String selectAsString() {
    return '${this.label}';
  }
}

class SelectWidget extends StatefulWidget {
  final ElementOption option;

  SelectWidget(this.option, {Key? key}) : super(key: key);

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

      if (widget.option.relations != null) {
        // print(widget.option.relations);
        // print(widget.option.component);

        if (widget.option.relations[widget.option.component] == null) {
          relationKey = widget.option.meta["relation"]["table"];
        }
      }
    });
  }

  // void onChange(String value) {
  //   setState(() {
  //     if (isNumeric(value)) {
  //       var numberValue = int.parse(value);
  //       widget.option.onChange(widget.option.component, numberValue);
  //     } else {
  //       widget.option.onChange(widget.option.component, value);
  //     }
  //   });
  // }

  void onChange(SelectModel? data) {
    if (data != null) {
      if (data.value != null) {
        setState(() {
          widget.option.onChange(widget.option.component, data.value);
        });
      } else {
        setState(() {
          widget.option.onChange(widget.option.component, null);
        });
      }
    } else {
      setState(() {
        widget.option.onChange(widget.option.component, null);
      });
    }
  }

  List<SelectModel> getOptions() {
    List<SelectModel> items = [];
    if (widget.option.meta["options"] != null &&
        widget.option.meta["options"].length >= 1) {
      widget.option.meta["options"].forEach((v) {
        items.add(SelectModel.fromJson(v));
      });

      return items;
    } else {
      if (widget.option.relations != null) {
        filterOption(widget.option.relations[relationKey]).forEach((v) {
          items.add(SelectModel.fromJson(v));
        });
      }
      return items;
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

  String getDefaultValue(List<SelectModel> options) {
    if (widget.option.form[widget.option.component] == null ||
        widget.option.form[widget.option.component] == "" ||
        widget.option.form[widget.option.component] == 0) {
      if (options.length >= 1) {
        return options[0].value.toString();
      } else {
        return "";
      }
    } else {
      int selectedIndex = options.indexWhere((note) =>
          note.value.toString() ==
          widget.option.form[widget.option.component].toString());

      if (selectedIndex >= 0) {
        return widget.option.form[widget.option.component].toString();
      } else {
        if (options.length >= 1) {
          return options[0].value.toString();
        } else {
          return "";
        }
      }
    }
  }

  Future<List<SelectModel>> getData(String? filter) async {
    // var response = await Dio().get(
    //   "https://5d85ccfb1e61af001471bf60.mockapi.io/user",
    //   queryParameters: {"filter": filter},
    // );
    //
    // final data = response.data;
    // if (data != null) {
    //   return UserModel.fromJsonList(data);
    // }

    List<SelectModel> options = getOptions();

    if (filter != null) {
      print(options.where((row) => (row.label!.contains(filter))).toList());
      return options.where((row) => (row.label!.contains(filter))).toList();
    } else {
      return options;
    }
  }

  Widget _dropdownBuilder(BuildContext context, SelectModel? item) {
    if (item == null) {
      if (widget.option.form[widget.option.component] != null) {
        List<SelectModel> options = getOptions();
        int selectedIndex = options.indexWhere((note) =>
            note.value.toString() ==
            widget.option.form[widget.option.component].toString());

        if (selectedIndex >= 0) {
          return Container(
              child: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(options[selectedIndex].label ?? "",
                style: TextStyle(
                    color: Color.fromRGBO(99, 120, 136, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.normal)),
          ));
        }
      }
      return Container(
        padding: EdgeInsets.all(0.0),
        child: Text("Сонгох",
            style: TextStyle(
                color: Color.fromRGBO(99, 120, 136, 1),
                fontSize: 14,
                fontWeight: FontWeight.normal)),
      );
    }

    return Container(
        child: ListTile(
      contentPadding: EdgeInsets.all(0),
      title: Text(item.label ?? ""),
    ));
  }

  Widget _popupItemBuilder(
      BuildContext context, SelectModel? item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.label ?? '',
            style: TextStyle(
                color: Color.fromRGBO(99, 120, 136, 1),
                fontSize: 14,
                fontWeight: FontWeight.normal)),
      ),
    );
  }

  Widget build(BuildContext context) {
    print("hi 1");
    var options = getOptions();
    print("hi 2");
    var defaultValue = getDefaultValue(options);
    print("hi 3");
    return new Container(
        margin: new EdgeInsets.only(top: 5.0, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(widget.option.label,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                    color: Color.fromRGBO(99, 120, 136, 1))),
            SizedBox(height: 4.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(99, 120, 136, 0.2), width: 1),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: new FormField(
                initialValue: defaultValue,
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
                builder: (FormFieldState<dynamic> field) {
                  return InputDecorator(
                    decoration: InputDecoration().copyWith(
                      border: InputBorder.none,
                      errorText: field.errorText,
                      contentPadding: const EdgeInsets.all(0.0),
                    ),
                    child: Theme(
                      data: ThemeData(
                        textTheme: TextTheme(
                            subtitle1: TextStyle(
                                color: Color.fromRGBO(99, 120, 136, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                      ),
                      child: DropdownSearch<SelectModel>(
                        items: options,
                        dropdownBuilder: _dropdownBuilder,
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(0.0),
                            // labelText: widget.option.label,
                            hintText: widget.option.label,
                          ),
                        ),
                        popupProps: PopupProps.bottomSheet(
                          showSearchBox: true,
                          itemBuilder: _popupItemBuilder,
                        ),
                        //onFind: (String? filter) => getData(filter),
                        onChanged: onChange,
                        itemAsString: (SelectModel u) => u.selectAsString(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
