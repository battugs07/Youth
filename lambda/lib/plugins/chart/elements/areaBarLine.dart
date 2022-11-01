import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'dart:convert';
import '../theme/shine_theme_script.dart' show shineThemeScript;
import '../theme/dark_theme_script.dart' show darkThemeScript;
import '../theme/macarons_theme_script.dart' show macaronsThemeScript;

class AreaBarLineChart extends StatefulWidget {
  final String? title;
  final String? type;
  final String? theme;
  final List<String>? colors;
  final dynamic legend;
  final dynamic data;
  final dynamic xdata;

  AreaBarLineChart({
    Key? key,
    this.title,
    this.type,
    this.theme,
    this.colors,
    @required this.legend,
    @required this.data,
    @required this.xdata,
  }) : super(key: key);

  @override
  _AreaBarLineChartState createState() => _AreaBarLineChartState();
}

class _AreaBarLineChartState extends State<AreaBarLineChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String colorValue = "";

    if (widget.colors != null) {
      if (widget.colors!.length >= 1) {
        colorValue = '"color": ${jsonEncode(widget.colors)},';
      }
    }

    return Container(
      child: Echarts(
        extensions: [shineThemeScript, darkThemeScript, macaronsThemeScript],
        theme: widget.theme != "" ? widget.theme : "shine",
        option: '''
   {
  "title": {
    "text": "${this.widget.title}"
  },
  "tooltip": {
    "trigger": "axis"
  },
  "legend": {
    "data": ${jsonEncode(this.widget.legend)},
    "align": "left",
    "left": 10,
    "top": 25
  },
  "toolbox": {
    "feature": {
      "magicType": {
        "type": [
          "line",
          "bar"
        ],
        "title": {
          "line": "Шугман",
          "bar": "Багнан"
        }
      }
    }
  },
  "xAxis": {
    "type": "category",
    "boundaryGap": true,
    "data": ${jsonEncode(this.widget.xdata)}
  },
  "yAxis": {
    "type": "value",
    "scale": true,
    "show": true,
    max: function (value) {
        return value.max - 0;
    },
    axisLabel : {
        
          formatter: function(n){
          if(n*1 >= 1000){
             return Math.round(n/1000)+"М" 
          } else {
          
              return Math.round(n);
              }
          }
        },
    min: function (value) {
        return value.min - 0;
    },
    // "position":"right",
    "boundaryGap": [
      0,
      "100%"
    ]
  },
  // "dataZoom": [
  //   {
  //     "startValue": "{this.widget.xdata[0]}"
  //   },
  //   {
  //     "type": "inside"
  //   }
  // ],
  $colorValue
  "series": ${jsonEncode(this.widget.data)}
}

   ''',
      ),
      width: MediaQuery.of(context).size.width,
      height: (MediaQuery.of(context).size.width / 2) + 60,
    );
  }
}
