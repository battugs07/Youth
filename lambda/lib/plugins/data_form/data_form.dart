library json_to_form;

import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'elements/index.dart';
import 'rule.dart';
import 'utils/formula_and_trigger.dart';
import 'loader.dart';
import '../../utils/date.dart';

class DataForm extends StatefulWidget {
  final Map decorations;

  final List<Map<String, dynamic>> schema;
  final Map<String, dynamic> ui;
  final Map<String, dynamic>? hiddenValues;
  final double? padding;
  final Widget? buttonSave;
  final Function onSuccess;
  final Function onReady;
  final String saveBtnText;
  final dynamic relations;
  final List<dynamic>? formula;
  final ValueChanged<dynamic>? onChanged;

  DataForm(
    this.onSuccess,
    this.onReady,
    this.schema,
    this.ui, {
    Key? key,
    this.padding,
    this.onChanged,
    this.hiddenValues,
    this.decorations = const {},
    this.relations,
    this.formula,
    this.buttonSave,
    this.saveBtnText = "Хадгалах",
  }) : super(key: key);

  @override
  DataFormState createState() => DataFormState();
}

class DataFormState extends State<DataForm> {
  final ScrollController _formController = ScrollController();
  Map<String, dynamic> model = Map<String, dynamic>();

  List<Map<String, String>> sections = [];
  int sectionIndex = 0;
  bool loading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => onReady());
    super.initState();

    this.initForm();
  }

  @override
  void onBackPressed() {
    print("BACK");
  }

  void initForm() {
    this.setState(() {
      this.setUiSchemaFormItem(widget.ui["schema"]);

      for (Map<String, dynamic> item in widget.schema) {
        if (item["hidden"] == false) {
          this.setModel(item["model"], item["default"], item["formType"]);
        } else {
          if (item["hidden"] == true && item["label"] != "") {
            this.setModel(item["model"], item["default"], item["formType"]);
          }
        }
      }
    });
  }

  int schemaIndex(model) {
    return widget.schema.indexWhere((item) => item["model"] == model);
  }

  void setUiSchemaFormItem(List<dynamic> items) {
    for (Map item in items) {
      if (item["type"] == "form") {
        int itemIndex = schemaIndex(item["model"]);
      } else if (item.containsKey("children")) {
        if (item["children"] is List<dynamic>) {
          if (item["type"] == "section") {
            setState(() {
              sections.add({
                "id": item["id"].toString(),
                "name": item["name"].toString(),
              });
            });
          }
          this.setUiSchemaFormItem(item["children"]);
        }
      }
    }
  }

  List<FormFieldValidator> setRule(List<dynamic> rules) {
    List<FormFieldValidator> itemRules = [];

    for (dynamic rule in rules) {
      var r = getRule(rule["type"], msg: rule["msg"]);

      if (r != null) {
        itemRules.add(r);
      }
    }
    return itemRules;
  }

  void setModel(String name, dynamic value, String? type) {
    switch (type) {
      case "Switch":
        {
          bool val = false;
          if (value == "true" || value == 1) {
            val = true;
          }
          model[name] = val;
        }
        break;
      case "SubForm":
        {
          model[name] = [];
        }
        break;
      case "Select":
        {
          // if(value != null){
          //   value = value.toString();
          // }
          // model[name] = isNumeric(value) ? int.parse(value) : value;
          model[name] = value;
        }
        break;
      case "Checkbox":
        {
//          model[name] = isNumeric(value) ? int.parse(value) : value;
          model[name] = value;
        }
        break;
      case "Date":
        {
          if (value != null && value != "") {
            model[name] = getParseDate(value);
          } else {
            model[name] = today();
          }
        }
        break;
      case "Datetime":
        {
          if (value != null && value != "") {
            model[name] = getParseTime(value);
          } else {
            model[name] = todayTime();
          }
        }
        break;
      default:
        {
          model[name] = value;
        }
    }

    if (widget.hiddenValues != null) {
      if (widget.hiddenValues![name] != null) {
        model[name] = widget.hiddenValues![name];

        int index = getSchemaIndex(widget.schema, name);

        if (index >= 0) {
          widget.schema[index]["hidden"] = true;
        }
      }
    }

//    if(widget.formula != null){
//      doFormula(widget.formula, name, model, widget.schema, "");
//    }
  }

  int radioValue = 0;

  List<Widget> renderForm(List<dynamic> items) {
    List<Widget> elements = <Widget>[];

    for (Map item in items) {
      if (item["type"] == "form") {
        var meta = setMeta(item, false);

        if (meta["hidden"] == false && meta["disabled"] == false) {
          elements.add(element(
            model,
            meta,
            (String component, dynamic value) =>
                this.onChangeElement(component, value, item["formType"]),
            type: item["formType"],
            key: item["model"],
            label: item["label"],
            relations: widget.relations,
            rules: this.setRule(meta["rules"]),
          ));
        }
      } else if (item["children"] is List<dynamic>) {
        if (item["type"] == "section") {
          if (sections[sectionIndex]["id"] == item["id"]) {
            List<Widget> children = this.renderForm(item["children"]);

            Widget Section = new Container(
                margin: new EdgeInsets.only(top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ));
            elements.add(Section);
          }
        } else {
          if (item["type"] == "col" &&
              item["name"] != "" &&
              item["name"] != null) {
            elements.add(Container(
                color: Color(0xffcccccc),
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(0, 3.0, 0, 7.0),
                padding: const EdgeInsets.fromLTRB(10, 10.0, 10, 10.0),
                child: Text(
                  item["name"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                )));

//            elements.add( Container(
//              height: 1.0,
//              color: Colors.black,
//              margin: const EdgeInsets.fromLTRB(0, 3.0, 0, 3.0),
//              ));

          }
          elements.addAll(this.renderForm(item["children"]));
        }
      }
//      else {
//        if(item["formType"] == "SubForm"){
//
//          var meta = setMeta(item, true);
//          elements.add(
//              element(
//                type:item["formType"],
//                key:item["model"],
//                label:item["label"],
//                form:model,
//                meta:meta,
//                relations:widget.relations,
//                decoration:null, // coming soon
//                onChange:(String component, dynamic value)=>this.onChangeElement(component, value, item["formType"]),
//                rules:this.setRule(meta["rules"]),
//              )
//          );
//
//        }
//      }
    }

    return elements;
  }

  Map<dynamic, dynamic> setMeta(Map<dynamic, dynamic> item, subForm) {
    int sIndex = widget.schema
        .indexWhere((schema) => schema["model"] == item["model"]); //

    Map<dynamic, dynamic> i = sIndex >= 0 ? widget.schema[sIndex] : item;

    if (!subForm) {
      i.remove("table");
      i.remove("extra");
      // i["schemaID"] = widget.schemaID;
    }

    return i;
  }

  void onChangeElement(String component, dynamic value, String elementType) {
    setState(() {
      model[component] = value;
    });
    if (elementType == 'Select') {
      clearChildValue(component);
    }

    /*
    * AFTER CHANGE
    * */
    if (widget.formula is List) {
      if (widget.formula!.length >= 1) {
        setState(() {
          doFormula(widget.formula!, component, model, widget.schema, "");
        });
      }
    }
  }

  void clearChildValue(String component) {
    for (Map<String, dynamic> item in widget.schema) {
      if (item["formType"] == "Select") {
        if (item["relation"]["parentFieldOfForm"] == component) {
          onChangeElement(item["model"], null, "Select");
        }
      }
    }
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSuccess(model);
    }
  }

  final _formKey = GlobalKey<FormState>();

  void pre() {
    setState(() {
      if (sectionIndex > 0) {
        setState(() {
          loading = true;
          sectionIndex--;
        });
        Timer(Duration(milliseconds: 200), () {
          setState(() {
            loading = false;
          });
        });
      }
    });
  }

  void next() {
    if (_formKey.currentState!.validate()) {
      if (sectionIndex < sections.length - 1) {
        setState(() {
          loading = true;
          sectionIndex++;
        });
        Timer(Duration(milliseconds: 200), () {
          setState(() {
            loading = false;
          });
        });
      } else {
        widget.onSuccess(model);
      }
    }
  }

  void onReady() {
    widget.onReady();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        if (sectionIndex > 0) {
          this.pre();
          return Future.value(false);
        } else {
          return Navigator.canPop(context);
        }
      },
      child: Form(
        // autovalidate: false,
        key: _formKey,
        child: Column(
          children: <Widget>[
            sections.length >= 2
                ? Container(
                    padding: EdgeInsets.only(
                        top: 10, right: 0.0, left: 0.0, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: new CircularPercentIndicator(
                            radius: 60.0,
                            lineWidth: 5.0,
                            percent:
                                (sectionIndex + 1) * (1.0 / sections.length),
                            center: new Text(sections.length.toString() +
                                "-с " +
                                (sectionIndex + 1).toString()),
                            progressColor: Color(0xFF7ae62e),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                  sections[sectionIndex]["name"] ??
                                      (sectionIndex + 1).toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Color(0xff333333)),
                                  textAlign: TextAlign.right),
                              sectionIndex + 1 < sections.length
                                  ? Text(
                                      "Дараах: ${sections[sectionIndex + 1]["name"]}",
                                      style:
                                          TextStyle(color: Color(0xff666666)))
                                  : Text(
                                      "Өмнөх: ${sections[sectionIndex - 1]["name"]}"),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
            Container(
//              color: Color(0xFFdfe1e6),
              padding:
                  EdgeInsets.only(top: 10, right: 0.0, left: 0.0, bottom: 15),
              child: Column(
                children: loading
                    ? <Widget>[Loader()]
                    : renderForm(widget.ui["schema"]),
              ),
            ),
            sections.length >= 2
                ? Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: InkWell(
                            onTap: pre,
                            child: widget.buttonSave != null
                                ? widget.buttonSave
                                : new Container(
                                    margin: EdgeInsets.only(right: 5),
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFe1ebfa),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    child: Center(
                                      child: Text(
                                          sectionIndex >= 1 ? "Өмнөх" : "",
                                          style: TextStyle(
                                              color: Color(0xFF2e7ae6),
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                          ),
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: next,
                            child: widget.buttonSave != null
                                ? widget.buttonSave
                                : new Container(
                                    margin: EdgeInsets.only(left: 5),
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF2e7ae6),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    child: Center(
                                      child: Text(
                                          sectionIndex < sections.length - 1
                                              ? "Дараах"
                                              : widget.saveBtnText,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: InkWell(
                      onTap: submitForm,
                      child: widget.buttonSave != null
                          ? widget.buttonSave
                          : new Container(
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: Color(0xFF2e7ae6),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Center(
                                child: Text(widget.saveBtnText,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
