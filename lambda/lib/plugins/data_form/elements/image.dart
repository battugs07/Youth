import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'element_option.dart';

import 'package:image_picker/image_picker.dart';
import 'image_popup.dart';
import 'package:lambda/plugins/progress_dialog/progress_dialog.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:lambda/modules/network_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

class ImageUploadWidget extends StatefulWidget {
  final ElementOption option;

  ImageUploadWidget(this.option, {Key? key}) : super(key: key);

  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final NetworkUtil _http = Get.find();
  ProgressDialog? pr;
  File? image;
  List<Map<String, String>> uploadedImages = [];
  List<Map<String, dynamic>> images = [];
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    initDefaultImage();
  }

  initDefaultImage() {
    if (widget.option.form[widget.option.component] != null) {
      if (widget.option.form[widget.option.component] != "") {
        if (widget.option.meta["file"]["isMultiple"] == true) {
          var preImage =
              jsonDecode(widget.option.form[widget.option.component]);
          if (preImage is List) {
            for (dynamic pre in preImage) {
              images
                  .add({"isNetworkImage": true, "imagePath": pre["response"]});
              uploadedImages
                  .add({"name": pre["name"], "response": pre["response"]});
            }
          }
        } else {
          var imagePath = widget.option.form[widget.option.component];
          String filename = imagePath.split('/').last;
          images.add({"isNetworkImage": true, "imagePath": imagePath});
          uploadedImages.add({"name": filename, "response": imagePath});
        }
      }
    }
  }

  Widget getImageThumbs() {
    List<Widget> thumbs = [];

    for (Map<String, dynamic> thumb in images) {
      if (thumb["imagePath"] != null) {
        if (thumb["isNetworkImage"]) {
          thumbs.add(CircleAvatar(
            radius: thumbs.length >= 3 ? 50 : 80,
            backgroundImage: NetworkImage(
                '${_http.dio.options.baseUrl}${thumb["imagePath"]}'),
          ));
        } else {
          thumbs.add(CircleAvatar(
            radius: thumbs.length >= 3 ? 50 : 70,
            backgroundImage: FileImage(File(thumb["imagePath"])),
          ));
        }
      }
    }
    if (thumbs.length == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              child: Stack(
            children: <Widget>[
              Positioned(
                top: -20,
                right: -15,
                child: IconButton(
                  onPressed: () {
                    ImagePopUp(context, deleteThumb, 0);
                  },
                  icon: Icon(Icons.more_horiz, color: Color(0xFF0074f2)),
                ),
              ),
              thumbs[0],
            ],
          ))
        ],
      );
    }
    return GridView.count(
      shrinkWrap: true, //
      crossAxisCount: thumbs.length >= 3
          ? 3
          : thumbs.length == 2
              ? 2
              : 1,
      // Generate 100 widgets that display their index in the List.
      children: List.generate(thumbs.length, (index) {
        return Container(
            padding: EdgeInsets.only(right: 5, top: 5, left: 5, bottom: 5),
            child: Stack(
              children: <Widget>[
                thumbs[index],
                Positioned(
                  top: -20,
                  right: -15,
                  child: IconButton(
                    onPressed: () {
                      ImagePopUp(context, deleteThumb, index);
                    },
                    icon: Icon(Icons.more_horiz, color: Color(0xFF0074f2)),
                  ),
                )
              ],
            ));
      }),
    );
  }

  void onChange(List<Map<String, String>> _images) {
    setState(() {
      if (_images.length >= 1) {
        if (widget.option.meta["file"]["isMultiple"] == true) {
          widget.option.onChange(widget.option.component, json.encode(_images));
        } else {
          if (_images[0]["response"] != "" && _images[0]["response"] != null) {
            widget.option
                .onChange(widget.option.component, _images[0]["response"]);
          } else {
            widget.option.onChange(widget.option.component, _images[0]["path"]);
          }
        }
      }
    });
  }

  saveOffline(PickedFile image, String filename) async {
    //COPY TO app directory
    var dir = (await getApplicationDocumentsDirectory()).path;
    final File imagePre = File(image.path);
    final File newImage = await imagePre.copy('$dir/$filename');
    await new Future.delayed(const Duration(seconds: 1));

    pr!.hide();
    if (widget.option.meta["file"]["isMultiple"] == true) {
      setState(() {
        images.add({"isNetworkImage": false, "imagePath": newImage.path});
        uploadedImages.add({
          "name": filename,
          "path": newImage.path,
          "response": "",
        });

        onChange(uploadedImages);
      });
    } else {
      setState(() {
        if (images.length == 1) {
          images.removeAt(0);
        }
        if (uploadedImages.length == 1) {
          uploadedImages.removeAt(0);
        }

        images.add({"isNetworkImage": false, "imagePath": image.path});
        uploadedImages.add({
          "name": filename,
          "path": newImage.path,
          "response": "",
        });

        onChange(uploadedImages);
      });
    }
  }

  Future getImage(String type) async {
    Map<Permission, PermissionStatus> permissions =
        await [Permission.storage].request();

    if (permissions[Permission.storage] == PermissionStatus.granted) {
      await Future.delayed(Duration(milliseconds: 500));
      PickedFile? image = await _picker.getImage(
          source: type == 'camera' ? ImageSource.camera : ImageSource.gallery,
          maxWidth: 1000);

      pr = new ProgressDialog(context, ProgressDialogType.Normal);
      pr!.setMessage('Түр хүлээнэ үү...');
      pr!.show();

      if (image != null) {
        String filename = image.path.split('/').last;
        FormData formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(image.path, filename: filename),
        });

        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          await saveOffline(image, filename);
        } else {
          try {
            var response = await _http.post("/lambda/krud/upload", formData);

            await new Future.delayed(const Duration(seconds: 1));

            pr!.hide();
            if (widget.option.meta["file"]["isMultiple"] == true) {
              setState(() {
                images.add({"isNetworkImage": false, "imagePath": image.path});
                uploadedImages.add({
                  "name": filename,
                  "response": response.toString(),
                });

                onChange(uploadedImages);
              });
            } else {
              setState(() {
                if (images.length == 1) {
                  images.removeAt(0);
                }
                if (uploadedImages.length == 1) {
                  uploadedImages.removeAt(0);
                }

                images.add({"isNetworkImage": false, "imagePath": image.path});
                uploadedImages.add({
                  "name": filename,
                  "response": response.toString(),
                });

                onChange(uploadedImages);
              });
            }
          } catch (error) {
            error.printError();
            error.printError();
            error.printError();
            // await saveOffline(image, filename);
          }
        }
      } else {
        await new Future.delayed(const Duration(seconds: 1));

        pr!.hide();
      }
    } else {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.BOTTOMSLIDE,
              headerAnimationLoop: false,
              title: 'Алдаа',
              desc: 'Зураг унших эрх олгогдоогүй байна',
              btnOkOnPress: () {},
              btnOkText: "Хаах",
              btnOkColor: Colors.red)
          .show();
    }
  }

  void deleteThumb(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  Widget imageButtons(FormFieldState<dynamic> field) {
    return Container(
      height: 65,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.only(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 60,
                width: 120,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF0074f2),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                child: MaterialButton(
                  onPressed: () => getImage('camera'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.camera,
                        size: 16,
                        color: Color(0xFF0074f2),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        'Камер',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF0074f2),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 36,
              ),
              Container(
                height: 60,
                width: 120,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF0074f2),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                child: MaterialButton(
                  onPressed: () => getImage('gallery'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.image,
                        size: 16,
                        color: Color(0xFF0074f2),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        'Зургийн галлерей',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF0074f2),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.only(top: 5.0, bottom: 10),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Color.fromRGBO(223, 223, 223, 1), width: 1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(widget.option.label,
                style: new TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                    color: Color.fromRGBO(99, 120, 136, 1))),
            images.length >= 1 ? getImageThumbs() : Container(),
            new FormField(
              initialValue: widget.option.form[widget.option.component] != null
                  ? json.encode(widget.option.form[widget.option.component])
                  : null,
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
                  decoration: InputDecoration().copyWith(
                    errorText: field.errorText,
                    border: InputBorder.none,
                  ),
                  child: imageButtons(field),
                );
              },
            ),
          ],
        ));
  }
}
