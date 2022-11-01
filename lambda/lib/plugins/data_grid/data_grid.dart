import 'package:flutter/material.dart';
import 'scroller.dart';

class DataGrid extends StatefulWidget {
  final List<dynamic>? data;
  final List<dynamic> schema;
  final double height;
  final Function? rowOnTap;
  final Function? listItem;
  DataGrid(this.schema,
      {Key? key, this.data, this.height = 0, this.rowOnTap, this.listItem})
      : super(key: key);

  @override
  _DataGridState createState() => _DataGridState();
}

class _DataGridState extends State<DataGrid> {
  String sortColumn = "";
  bool isAscending = true;
  double totalWidth = 0;

  @override
  void initState() {
    super.initState();
    initGrid();
  }

  void initGrid() {
    double preDouble = 0;
    for (Map<String, dynamic> column in widget.schema) {
      if (!column["hide"]) {
        preDouble = preDouble + column["width"].toDouble();
      }
    }
    setState(() {
      totalWidth = preDouble;
    });
  }

  void rowOnTap(Map<String, dynamic> row) {
    widget.rowOnTap!(row);
  }

  List<Widget> getHeaders() {
    List<Widget> headerWidgets = [];
    for (Map<String, dynamic> column in widget.schema) {
      if (!column["hide"]) {
        if (column["sortable"]) {
          headerWidgets.add(new MaterialButton(
            padding: EdgeInsets.all(0),
            child: getHeaderCol(
                column["label"].toString() +
                    (sortColumn == column["model"]
                        ? (isAscending ? '↓' : '↑')
                        : ''),
                column["width"].toDouble()),
            onPressed: () {
              setState(() {
                sortColumn = column["model"];
                isAscending = !isAscending;
              });
            },
          ));
        } else {
          headerWidgets.add(getHeaderCol(
              column["label"].toString(), column["width"].toDouble()));
        }
      }
    }
    return headerWidgets;
  }

  Widget getHeaderCol(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget rowBuilder(BuildContext context, int index) {
    List<Widget> columns = [];
    for (Map<String, dynamic> column in widget.schema) {
      if (!column["hide"]) {
        var value = widget.data![index][column["model"]];

        if (value == null) {
          value = "";
        }
        value.toString();
        columns.add(Container(
          child: Text(value.toString()),
          width: column["width"].toDouble(),
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ));
      }
    }

    if (widget.data![index]["is_offline_row"] != null) {
      return Container(
          color: Colors.orange[50],
          child: GestureDetector(
            onTap: () {
              this.rowOnTap(widget.data![index]);
            },
            child: Row(
              children: columns,
            ),
          ));
    } else {
      return GestureDetector(
        onTap: () {
          this.rowOnTap(widget.data![index]);
        },
        child: Row(
          children: columns,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.listItem != null
        ? Container(
            // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return widget.listItem!(widget.data![index], rowOnTap);
              },
            ),
          )
        : Container(
            child: ScrollAbleTable(
                headerWidgets: getHeaders(),
                rowBuilder: rowBuilder,
                itemCount: widget.data!.length,
                width: totalWidth,
                rowSeparatorWidget: const Divider(
                  color: Colors.black54,
                  height: 1.0,
                  thickness: 0.0,
                )),
            height: widget.height >= 1
                ? widget.height
                : MediaQuery.of(context).size.height,
          );
  }
}
