import 'package:flutter/material.dart';
import './chart.dart';
import 'dart:convert';
import 'package:lambda/modules/network_util.dart';
import 'package:lambda/plugins/data_form/loader.dart';
import 'package:lambda/plugins/chart/models/filter.dart';

class LambdaChart extends StatefulWidget {
  final String schemaID;
  final String? theme;
  final bool hideTitle;
  final List<Filter>? filters;

  LambdaChart(
    this.schemaID, {
    Key? key,
    this.theme,
    this.filters,
    this.hideTitle = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LambdaChartState();
}

class LambdaChartState extends State<LambdaChart> {
  NetworkUtil _http = new NetworkUtil();
  bool loading = true;
  String title = "";
  String type = "";
  Map<String, dynamic> counbox_data = new Map<String, dynamic>();
  Map<String, dynamic> pie_data = new Map<String, dynamic>();
  Map<String, dynamic> area_data = new Map<String, dynamic>();

  List<String> colors = [];

  @override
  void initState() {
    super.initState();
    this.initChart();
  }

  void initChart() {
    setState(() {
      loading = true;
    });
    String configUrl = '/lambda/puzzle/schema-public/chart/${widget.schemaID}';
    _http.get_(configUrl).then((response) {
      var schema_ = json.decode(response["data"]["schema"]);

      setState(() {
        title = response["data"]["name"];

        type = schema_["type"];

        if (schema_["type"] == "countBox") {
          counbox_data["color"] = schema_['bgColor'];
          counbox_data["icon"] = "newspaper";
          this.getCounBoxData(schema_);
        }

        if (schema_["type"] == "PieChart" ||
            schema_["type"] == "TreeMapChart") {
          this.getPieData(schema_);
        }
        if (schema_["type"] == "AreaChart" ||
            schema_["type"] == "ColumnChart" ||
            schema_["type"] == "LineChart") {
          this.getAreaData(schema_);
        }
      });
    }).catchError((e) {});
  }

  getCounBoxData(Map<String, dynamic> schema_) async {
    try {
      var response = await _http
          .post_('/ve/get-data-count', {"countFields": schema_["countFields"]});
      setState(() {
        counbox_data["count"] = response;
        loading = false;
      });
    } catch (RuntimeBinderException) {}
  }

  getPieData(Map<String, dynamic> schema_) async {
    try {
      var response = await _http.post_('/ve/get-data-pie', {
        "value": schema_["value"],
        "title": schema_["title"],
        "filters": widget.filters
      });

      String valueField = schema_["value"][0]["name"];
      String titleField = schema_["title"][0]["name"];

      List<Map<String, dynamic>> data = [];

      var titles = response.map((i) {
        return i[titleField];
      }).toList();

      for (Map i in response) {
        Map<String, dynamic> dataI = new Map();
        dataI['value'] = i[valueField];
        dataI['name'] = i[titleField];
        data.add(dataI);
      }

      setState(() {
        pie_data["data"] = data;
        pie_data["legend"] = titles;
        loading = false;
      });
    } catch (RuntimeBinderException) {
      print("EEEEEEE");
    }
  }

  getAreaData(Map<String, dynamic> schema_) async {
    try {
      var response = await _http.post_('/ve/get-data', {
        "axis": schema_["axis"],
        "lines": schema_["lines"],
        "filters": widget.filters
      });

      List<String> colorsData = [];
      for (dynamic line in schema_["lines"]) {
        if (line["color"] != null && line["color"] != "") {
          colorsData.add(line["color"]);
        }
      }

      List<dynamic> axis = [];
      List<Map<String, dynamic>> series = [];

      for (Map axisEl in schema_["axis"]) {
        for (Map axisdata in response) {
          axis.add(axisdata[axisEl["name"]]);
        }
      }

      for (Map line in schema_["lines"]) {
        List<String> seriesData = [];
        for (Map lineData in response) {
          seriesData.add("${lineData[line["name"]]}");
        }

        Map<String, dynamic> areaDataPre = new Map<String, dynamic>();

        areaDataPre["name"] = line["title"];

        areaDataPre["smooth"] = true;

        areaDataPre["data"] = seriesData;

        if (type == "AreaChart") {
          areaDataPre["type"] = 'line';
          areaDataPre["areaStyle"] = {};
        }

        if (type == "LineChart") {
          areaDataPre["type"] = 'line';
        }

        if (type == "ColumnChart") {
          areaDataPre["type"] = 'bar';
        }

        series.add(areaDataPre);
      }

      setState(() {
        area_data["xdata"] = axis;
        area_data["data"] = series;
        colors = colorsData;
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget renderChart() {
    switch (this.type) {
      case "countBox":
        {
          return Chart(
            "count_box",
            title: this.title,
            hideTitle: this.widget.hideTitle,
            data: counbox_data,
            theme: widget.theme,
          );
        }
      case "PieChart":
        {
          return Chart("pie",
              title: this.title,
              hideTitle: this.widget.hideTitle,
              data: pie_data,
              colors: colors,
              theme: widget.theme);
        }
      case "TreeMapChart":
        {
          return Chart("treemap",
              title: this.title,
              hideTitle: this.widget.hideTitle,
              colors: colors,
              data: pie_data,
              theme: widget.theme);
        }

      case "AreaChart":
        {
          return Chart("area",
              title: this.title,
              hideTitle: this.widget.hideTitle,
              data: area_data,
              colors: colors,
              theme: widget.theme);
        }
      case "LineChart":
        {
          return Chart("area",
              title: this.title,
              hideTitle: this.widget.hideTitle,
              data: area_data,
              colors: colors,
              theme: widget.theme);
        }
      case "ColumnChart":
        {
          return Chart("area",
              title: this.title,
              hideTitle: this.widget.hideTitle,
              data: area_data,
              colors: colors,
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
