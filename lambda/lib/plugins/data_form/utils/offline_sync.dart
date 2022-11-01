import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lambda/plugins/data_form/model/form.dart';
import 'package:lambda/plugins/data_form/DB/DBHelper.dart';
import 'package:lambda/modules/network_util.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OFFLINE {
  getData({String schemaId = "", Function? callBack}) async {
    var dbHelper = DBHelper();
    List<OfflineFormData> formDataList;
    List<dynamic> offlineData = [];

    if (schemaId != "") {
      formDataList = await dbHelper.getOfflineOfflineFormData(schemaId);
    } else {
      formDataList = await dbHelper.getOfflineOfflineFormDataAll();
    }

    if (formDataList.length >= 1) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        for (OfflineFormData formData in formDataList) {
          var rowData = jsonDecode(formData.data ?? "{}");
          rowData["is_offline_row"] = true;
          offlineData.add(rowData);
        }

        callBack!(offlineData);
      } else {
        for (OfflineFormData formData in formDataList) {
          var rowData = jsonDecode(formData.data ?? "{}");
          rowData["is_offline_row"] = true;
          offlineData.add(rowData);
        }

        callBack!(offlineData);
      }
    } else {
      callBack!([]);
    }
  }

  Future<String> uploadImage(String path, NetworkUtil _http) async {
    String filename = path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(path, filename: filename),
    });

    try {
      var response =
          await _http.post_("/lambda/krud/upload", formData, cache: false);

      if (response.chartdata != null) return response.chartdata.toString();
    } catch (error) {
      return "";
    }

    return "";
  }

  Future<Map<String, dynamic>> uploadImages(List<dynamic> schemas,
      Map<String, dynamic> data, NetworkUtil _http) async {
    for (dynamic schema in schemas) {
      if (schema["formType"] == "Image") {
        if (data[schema["model"]] != null && data[schema["model"]] != "") {
          if (schema["file"]["isMultiple"] == true) {
            var images = jsonDecode(data[schema["model"]]);

            if (images is List<dynamic>) {
              for (dynamic image in images) {
                if (image["path"] != null && image["path"] != "") {
                  String imagePath = await uploadImage(image["path"], _http);

                  if (imagePath != "") {
                    image["response"] = imagePath;
                  }
                }
              }
              data[schema["model"]] = jsonEncode(images);
            } else {
              String imagePath = await uploadImage(images["path"], _http);

              if (imagePath != "") {
                images["response"] = imagePath;
                data[schema["model"]] = jsonEncode(images);
              }
            }
          } else {
            String imagePath = await uploadImage(data[schema["model"]], _http);

            if (imagePath != "") {
              data[schema["model"]] = imagePath;
            }
          }
        }
      }
    }

    return data;
  }

  syncData({Function? callBack, context}) async {
    var dbHelper = DBHelper();
    List<OfflineFormData> formDataList;

    formDataList = await dbHelper.getOfflineOfflineFormDataAll();

    if (formDataList.length >= 1) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.none) {
        NetworkUtil _http = new NetworkUtil();

        int totalSuccess = 0;
        for (OfflineFormData formData in formDataList) {
          var data = jsonDecode(formData.data ?? "{}");
          var schemas = jsonDecode(formData.schema ?? "[]");

          data = await uploadImages(schemas, data, _http);

          try {
            var response = await _http.post_(
                '/lambda/krud/${formData.schemaId.toString()}/store', data,
                cache: false);

            if (response.chartdata["status"] != null) {
              if (response.chartdata["status"]) {
                formData.synced = 1;
                totalSuccess++;
                dbHelper.update(formData);
              } else {}
            }
          } catch (error) {}
        }

        if (context != null && totalSuccess >= 1) {
          Fluttertoast.showToast(
              msg: '$totalSuccess мэдээлэл сервер лүү илгээгдлээ',
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.green,
              textColor: Colors.white);
        }
      }
    }
  }
}
