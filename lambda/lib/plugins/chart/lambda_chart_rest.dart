import 'package:flutter/material.dart';
import './chart.dart';

import 'package:lambda/modules/network_util.dart';
import 'package:lambda/plugins/data_form/loader.dart';
import 'package:lambda/plugins/chart/models/filter.dart';

class LambdaChartRest extends StatefulWidget {
  final String APIurl;
  final String? title;
  final String chartType;
  final String? theme;
  final List<Filter>? filters;
  final List<String>? colors;
  LambdaChartRest(
    this.APIurl,
    this.chartType, {
    Key? key,
    this.theme,
    this.title,
    this.filters,
    this.colors,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LambdaChartRestState();
}

class LambdaChartRestState extends State<LambdaChartRest> {
  NetworkUtil _http = new NetworkUtil();
  bool loading = true;

  dynamic chartData;

  @override
  void initState() {
    super.initState();
    this.initChart();
  }

  void initChart() {
    setState(() {
      loading = true;
    });
    String configUrl = widget.APIurl;
    _http.post_(configUrl, {"filters": widget.filters}).then((response) {
      setState(() {
        chartData = response["data"];
        loading = false;
      });
    }).catchError((e) {
      print(e);
      // print(e);
      // print(e);
    });
  }

  Widget renderChart() {
    switch (this.widget.chartType) {
      case "countBox":
        {
          return Chart(
            "count_box",
            title: widget.title,
            data: chartData,
            colors: widget.colors,
            theme: widget.theme,
          );
        }
      case "PieChart":
        {
          return Chart("pie",
              title: widget.title,
              data: chartData,
              colors: widget.colors,
              theme: widget.theme);
        }
      case "TreeMapChart":
        {
          return Chart("treemap",
              title: widget.title,
              data: chartData,
              colors: widget.colors,
              theme: widget.theme);
        }

      case "AreaChart":
        {
          return Chart("area",
              title: widget.title,
              data: chartData,
              colors: widget.colors,
              theme: widget.theme);
        }
      case "LineChart":
        {
          return Chart("area",
              title: widget.title,
              data: chartData,
              colors: widget.colors,
              theme: widget.theme);
        }
      case "ColumnChart":
        {
          return Chart("area",
              title: widget.title,
              data: chartData,
              colors: widget.colors,
              theme: widget.theme);
        }

      default:
        {
          return Center(
            child: Text('Chart type not found'),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading
          ? Loader()
          : Container(
              child: this.renderChart(),
            ),
    );
  }
}
