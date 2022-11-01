import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:lambda/plugins/data_form/data_form.dart';
import 'loader.dart';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:lambda/plugins/data_form/model/form.dart';
import 'package:lambda/plugins/data_form/DB/DBHelper.dart';
import 'package:date_format/date_format.dart';

class LambdaDataForm extends StatefulWidget {
  final Function? onSuccess;
  final Function? onReady;
  final Function? onError;
  final String schemaID;
  final String saveBtnText;
  final String? user_condition;
  final bool editMode;
  final bool isPublic;
  final bool? offlineSave;
  final int? editId;

  final Map<String, dynamic>? hiddenValues;

  const LambdaDataForm(
    this.schemaID, {
    Key? key,
    this.onSuccess,
    this.onReady,
    this.onError,
    this.hiddenValues,
    this.user_condition,
    this.editMode = false,
    this.editId,
    this.isPublic = false,
    this.offlineSave = true,
    this.saveBtnText = "Хадгалах",
  }) : super(key: key);

  @override
  LambdaDataFormState createState() => LambdaDataFormState();
}

class LambdaDataFormState extends State<LambdaDataForm> {
  NetworkUtil _http = new NetworkUtil();
  bool loading = true;
  final GlobalKey<DataFormState> dataFromKey = new GlobalKey<DataFormState>();
  dynamic relations;
  List<dynamic>? formula;
  String formName = "";
  Map<String, dynamic> ui = Map<String, dynamic>();
  List<Map<String, dynamic>> schema = <Map<String, dynamic>>[];
  var dbHelper;

  @override
  void initState() {
    super.initState();
    this.initForm();
    dbHelper = DBHelper();
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

  void initForm() {
    String configUrl =
        '/lambda/puzzle/schema/form/${widget.schemaID}?row_id=${widget.editId}';

    if (widget.isPublic) {
      configUrl =
          '/lambda/puzzle/schema-public/form/${widget.schemaID}?row_id=${widget.editId}';
    }

    if (widget.user_condition != null) {
      configUrl =
          configUrl + "/" + Uri.encodeComponent(widget.user_condition ?? "");
    }
    _http.get_(configUrl).then((response) {
      var schema_ = json.decode(response["data"]["schema"]);
      setState(() {
        formName = response["data"]["name"];
        ui["type"] = schema_['ui']["type"];
        ui["schema"] = <Map<String, dynamic>>[];
        for (Map<String, dynamic> schemaElement in schema_['schema']) {
          schema.add(schemaElement);
        }
        for (Map<String, dynamic> uiSchemaElement in schema_['ui']['schema']) {
          ui["schema"].add(uiSchemaElement);
        }
        ui = schema_['ui'];

        if (schema_["formula"] != null) {
          formula = schema_["formula"];
        }

        this.getOptionsData(schema);

//        if(widget.editMode && widget.editId != null){
//          this.editModel();
//        }
      });
    }).catchError((e) {
      ErrorAlert(initForm);
    });
  }

  editModel() async {
    String url =
        '/lambda/krud/${widget.schemaID}/edit/${widget.editId.toString()}';

    if (widget.isPublic) {
      url =
          '/lambda/krud-public/${widget.schemaID}/edit/${widget.editId.toString()}';
    }
    try {
      var response = await _http.post_(url, {});

      setState(() {
        for (int i = 0; i < schema.length; i++) {
          if (response["data"][schema[i]["model"]] != null) {
            schema[i]["default"] = response["data"][schema[i]["model"]];
          }
        }
        loading = false;
      });
    } catch (error) {
      ErrorAlert(editModel);
    }
  }

  getOptionsData(List<Map<String, dynamic>> schema_) async {
    try {
      var relations_ = this.getSelects(schema_);

      var response = await _http
          .post_('/lambda/puzzle/get_options', {"relations": relations_});
      print(response);

      if (widget.editId != null) {
        if (widget.editMode) {
          setState(() {
            relations = response;
          });
          this.editModel();
        } else {
          setState(() {
            relations = response;
            loading = false;
          });
        }
      } else {
        setState(() {
          relations = response;
          loading = false;
        });
      }
    } catch (RuntimeBinderException) {}
  }

  getSelects(List<dynamic> schema_) {
    var selects = Map();
    for (Map<String, dynamic> item in schema_) {
      if (item["formType"] == 'Select' ||
          item["formType"] == 'ISelect' ||
          item["formType"] == 'TreeSelect') {
        if (item["relation"]["table"] != null &&
            item["relation"]["table"] != "") {
          if (!selects.containsKey(item["relation"]["table"])) {
            if (item["relation"]["filter"] == "" ||
                item["relation"]["filter"] == null) {
              selects[item["relation"]["table"]] = item["relation"];
            } else {
              selects[item["model"]] = item["relation"];
            }
          }
        }
      }

      if (item["formType"] == 'AdminMenu') {
        if (item["relation"]["table"])
          selects[item["relation"]["table"]] = item["relation"];
      }

      if (item["formType"] == 'SubForm') {
        if (item["schema"] != null) {
          var preSelects = this.getSelects(item["schema"]);
          if (preSelects != null) {
            selects = {...selects, ...preSelects};
          }
        }
      }
    }
    return selects;
  }

  showOtherError() {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            headerAnimationLoop: false,
            title: 'Алдаа',
            desc: 'Хадгалах үед алдаа гарлаа',
            btnOkOnPress: () {},
            btnOkText: "Хаах",
            btnOkColor: Colors.red)
        .show();
  }

  saveOffline(Map<String, dynamic> data) async {
    var now = new DateTime.now();
    String dateTime =
        formatDate(now, [yyyy, '-', mm, '-', dd, " ", HH, ":", nn, ":", ss]);
    OfflineFormData offlineFormData = OfflineFormData(0, widget.schemaID, 0,
        jsonEncode(data), jsonEncode(schema), formName, dateTime);
    await dbHelper.save(offlineFormData);
    widget.onSuccess!(data);
  }

  void setModel(String name, dynamic value, String type) {
    dataFromKey.currentState!.setModel(name, value, type);
  }

  void onSuccess(Map<String, dynamic> data) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (widget.offlineSave != null) {
        if (!widget.editMode && widget.offlineSave == true) {
          saveOffline(data);
        }
      } else {
        ErrorAlert(() => onSuccess(data));
      }
    } else {
      try {
        String storeUrl = '/lambda/krud/${widget.schemaID}/store';
        if (widget.isPublic) {
          storeUrl = '/lambda/krud-public/${widget.schemaID}/store';
        }

        if (widget.editId != null) {
          if (widget.editMode) {
            storeUrl =
                '/lambda/krud/${widget.schemaID}/update/${widget.editId.toString()}';
            if (widget.isPublic) {
              storeUrl =
                  '/lambda/krud-public/${widget.schemaID}/update/${widget.editId.toString()}';
            }
          }
        }

        print(storeUrl);
        print(data);

        var response = await _http.post_(storeUrl, data, cache: false);

        if (response["status"]) {
          widget.onSuccess!(data);
        } else {
          showOtherError();
        }
      } catch (error) {
        if (error is String) {
          if (widget.offlineSave == true) {
            saveOffline(data);
          } else {
            ErrorAlert(() => onSuccess(data));
          }
        } else {
          print(error);
          //   if (error.data['error'] != null) {
          //     String errorDesc = "";
          //     for (Map<String, dynamic> item in schema) {
          //       if (error["error"][item["model"]] != null) {
          //         for (dynamic err in error["error"][item["model"]]) {
          //           errorDesc = "\n" + "${item["label"]}: " + err.toString();
          //         }
          //       }
          //     }
          //     AwesomeDialog(
          //         context: context,
          //         dialogType: DialogType.ERROR,
          //         animType: AnimType.BOTTOMSLIDE,
          //         headerAnimationLoop: false,
          //         title: 'Алдаа',
          //         desc: errorDesc,
          //         btnOkOnPress: () {},
          //         btnOkText: "Хаах",
          //         btnOkColor: Colors.red)
          //         .show();
          //
          // } else {
          showOtherError();
        }
      }
    }
  }

  void onReady() {
    if (widget.onReady != null) {
      widget.onReady!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading
          ? Loader()
          : DataForm(
              this.onSuccess,
              this.onReady,
              schema,
              ui,
              saveBtnText: widget.saveBtnText,
              relations: relations,
              formula: formula,
              hiddenValues: widget.hiddenValues,
              key: dataFromKey,
            ),
    );
  }
}
