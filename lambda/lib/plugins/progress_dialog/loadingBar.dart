import 'package:flutter/material.dart';
import 'package:get/get.dart';

showLoading() {
  Get.defaultDialog(
      title: "Түр хүлээнэ үү...",
      content: CircularProgressIndicator(),
      barrierDismissible: false);
}

showDialog(String text) {
  Get.defaultDialog(
      title: text,
      content: CircularProgressIndicator(),
      barrierDismissible: false);
}

dismissLoadingWidget() {
  Get.back();
}
