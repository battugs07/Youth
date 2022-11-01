import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_echarts/flutter_echarts.dart';
import '../theme/shine_theme_script.dart' show shineThemeScript;
import '../theme/dark_theme_script.dart' show darkThemeScript;
import '../theme/macarons_theme_script.dart' show macaronsThemeScript;

class TreeMap extends StatefulWidget {
  final String? title;
  final String? theme;
  final dynamic legend;
  final dynamic data;

  TreeMap({
    Key? key,
    this.title,
    this.theme,
    @required this.legend,
    @required this.data,
  }) : super(key: key);

  @override
  _TreeMapState createState() => _TreeMapState();
}

class _TreeMapState extends State<TreeMap> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Echarts(
        extensions: [shineThemeScript, darkThemeScript, macaronsThemeScript],
        theme: widget.theme != "" ? widget.theme : "shine",
        option: '''
  {
  "title": {
    "left": "left",
    "text": "${this.widget.title}"
  },
  "toolbox": {
    "feature": {}
  },
  "tooltip": {
    "trigger": "item"
  },
  "legend": {
    "orient": "vertical",
    "right": 5,
    "top": 20,
    "bottom": 20,
    "type": "plain",
    "data":${jsonEncode(this.widget.legend)}
  },
  "series": [
    {
      "name": "${this.widget.title}",
      "type": "treemap",
      "radius": "55%",
      "center": [
        "50%",
        "60%"
      ],
      "data":  ${jsonEncode(this.widget.data)},
      "roam": "move",
      "itemStyle": {
        "normal": {
          "label": {
            "textStyle": {
              "baseline": "top"
            }
          }
        }
      }
    }
  ]
}
''',
      ),
      width: MediaQuery.of(context).size.width - 30,
      height: MediaQuery.of(context).size.width + 100,
    );
  }
}
