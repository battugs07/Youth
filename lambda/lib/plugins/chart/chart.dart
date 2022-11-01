import 'package:flutter/material.dart';
import './elements/pie.dart';
import './elements/areaBarLine.dart';
import './elements/treeMap.dart';
import './elements/countBox.dart';

class Chart extends StatefulWidget {
  final String type;
  final String? theme;
  final String? title;
  final dynamic data;
  final bool hideTitle;
  final List<String>? colors;
  Chart(
    this.type, {
    Key? key,
    this.title,
    this.theme,
    this.colors,
    this.data,
    this.hideTitle = false,
  }) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  void initState() {
    super.initState();
  }

  Widget renderChart() {
    switch (this.widget.type) {
      case "count_box":
        {
          return new CountBox(
              data: this.widget.data["count"],
              color: this.widget.data["color"],
              icon: this.widget.data["icon"],
              title: this.widget.title ?? "");
        }
      case "pie":
        {
          return new PieChart(
              title: this.widget.title ?? "",
              legend: this.widget.data['legend'],
              data: this.widget.data['data'],
              theme: this.widget.theme ?? "shine",
              hideTitle: this.widget.hideTitle);
        }
      case "bar":
        {
          return new AreaBarLineChart(
              colors: this.widget.colors ?? <String>[],
              title: this.widget.title ?? "",
              type: this.widget.type,
              legend: this.widget.data['legend'],
              xdata: this.widget.data['xdata'],
              data: this.widget.data['data'],
              theme: this.widget.theme ?? "shine");
        }
        break;
      case "area":
        {
          return new AreaBarLineChart(
              colors: this.widget.colors ?? <String>[],
              title: this.widget.title ?? "",
              type: this.widget.type,
              legend: this.widget.data['legend'],
              xdata: this.widget.data['xdata'],
              data: this.widget.data['data'],
              theme: this.widget.theme ?? "shine");
        }
        break;
      case "line":
        {
          return new AreaBarLineChart(
              colors: this.widget.colors ?? <String>[],
              title: this.widget.title ?? "",
              type: this.widget.type,
              legend: this.widget.data['legend'],
              xdata: this.widget.data['xdata'],
              data: this.widget.data['data'],
              theme: this.widget.theme ?? "shine");
        }
        break;
      case "treemap":
        {
          return new TreeMap(
              title: this.widget.title ?? "",
              legend: this.widget.data['legend'],
              data: this.widget.data['data'],
              theme: this.widget.theme ?? "shine");
        }
        break;
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
      child: this.renderChart(),
    );
  }
}
