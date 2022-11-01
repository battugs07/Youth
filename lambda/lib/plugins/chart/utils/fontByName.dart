import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FontByName {
  static IconData icon(String fontClass) {
    switch (fontClass) {
      case "newspaper":
        {
          return FontAwesomeIcons.newspaper;
        }
      case "nodeJs":
        {
          return FontAwesomeIcons.nodeJs;
        }
      case "flaticon-map-location":
        {
          return FontAwesomeIcons.nodeJs;
        }
      default:
        {
          return FontAwesomeIcons.newspaper;
        }
    }
  }

  FontByName();
}
