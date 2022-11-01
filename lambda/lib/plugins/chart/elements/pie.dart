import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

class PieChart extends StatefulWidget {
  final String? title;
  final String? theme;
  final dynamic legend;
  final dynamic data;
  final bool hideTitle;

  PieChart({
    Key? key,
    this.title,
    this.theme,
    this.hideTitle = false,
    @required this.legend,
    @required this.data,
  }) : super(key: key);

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String title = ' "title": {"left": "left","text": "${this.widget.title}"},';
    if (widget.hideTitle) {
      title = "";
    }
    return Container(
      child: Echarts(
        // extensions: [shineThemeScript, darkThemeScript, macaronsThemeScript],
        // theme: widget.theme != "" ?  widget.theme : "shine",
        option: '''
   {
   reloadAfterInit:true,
  $title
  "tooltip": {
    "trigger": "item",
    "formatter": "{a} <br/>{b} : {c} ({d}%)"
  },

  "legend": {
    "data": ${jsonEncode(this.widget.legend)},
    "bottom": "bottom"
  },
  "series": [
    {
      "name": "${this.widget.title}",
      "type": "pie",
      "radius": "55%",
      "center": [
        "50%",
        "${this.widget.legend.length >= 6 ? '40%' : '50%'}"
      ],
      "data": ${jsonEncode(this.widget.data)},
      "itemStyle": {
        "emphasis": {
          "shadowBlur": 10,
          "shadowOffsetX": 0,
          "shadowColor": "rgba(0, 0, 0, 0.5)"
        }
      },
      "label": {
        "normal": {
          "show": true,
          "position": "top"
        }
      }
    }
  ]
}
  ''',
      ),
      width: MediaQuery.of(context).size.width - 30,
      // height:this.widget.legend.length >= 6 ? MediaQuery.of(context).size.width+100 : MediaQuery.of(context).size.width-50,
      height: MediaQuery.of(context).size.width - 40,
    );
  }
}
