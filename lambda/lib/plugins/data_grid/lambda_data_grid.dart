import 'package:flutter/material.dart';
import 'data_grid.dart';
import 'dart:convert';
import 'package:lambda/modules/network_util.dart';
import 'package:lambda/plugins/data_form/loader.dart';

class LambdaDataGrid extends StatefulWidget {
  final String? user_condition;
  final String schemaID;
  final Color activeColor;
  final List<dynamic>? offlineData;
  final Function? rowOnTap;
  final Function? listItem;

  LambdaDataGrid(this.schemaID,
      {Key? key,
      this.user_condition,
      this.offlineData,
      this.activeColor = Colors.blue,
      this.rowOnTap,
      this.listItem})
      : super(key: key);

  @override
  _LambdaDataGridState createState() => _LambdaDataGridState();
}

class _LambdaDataGridState extends State<LambdaDataGrid> {
  NetworkUtil _http = new NetworkUtil();
  List<dynamic> data = [];
  bool loading = true;
  int currentPage = 1;
  String sortName = 'id';
  String sortOrder = 'desc';
  int lastPage = 0;
  int total = 0;

  List<dynamic> schema = <dynamic>[];

  @override
  void initState() {
    super.initState();

    initGrid();
  }

  @override
  void didUpdateWidget(LambdaDataGrid oldWidget) {
    setState(() {
      loading = true;
    });
    initGrid();
    super.didUpdateWidget(oldWidget);
  }

  void initGrid() {
    String configUrl = '/lambda/puzzle/schema/grid/${widget.schemaID}';

    _http.get_(configUrl).then((response) {
      var schemaData = json.decode(response["data"]["schema"]);
      setState(() {
        schema = schemaData["schema"];
        sortName = schemaData["sort"];
        sortOrder = schemaData["sortOrder"];
      });

      fetchData(true, currentPage);
    }).catchError((e) {
      ErrorAlert(initGrid);
    });
  }

  void rowOnTap(Map<String, dynamic> row) {
    if (widget.rowOnTap != null) {
      widget.rowOnTap!(row);
    }
  }

  void fetchData(bool changeLoading, int page) {
    if (changeLoading) {
      setState(() {
        loading = true;
      });
    }

    var url =
        '/lambda/puzzle/grid/data/${widget.schemaID}?&paginate=50&page=${page.toString()}&sort=$sortName&order=$sortOrder';

    Map<String, dynamic> filters = Map<String, dynamic>();

    if (widget.user_condition != null) {
      filters["user_condition"] = jsonDecode(widget.user_condition!);
    }

    _http.post_(url, filters).then((response) {
      setState(() {
        data = response["data"];
        lastPage = response["last_page"];
        total = response["total"];
        currentPage = page;
        if (changeLoading) {
          loading = false;
        }
      });
    }).catchError((e) {
      if (changeLoading) {
        ErrorAlert(() => fetchData(false, currentPage));
      } else {
        ErrorAlert(() {},
            errorTxt: "Таны хандсан мэдээлэл оффлайнаар байхгүй байна",
            actionTex: "Хаах");
      }
    });
  }

  void ErrorAlert(Function tryAgian,
      {String errorTxt = "", String actionTex = ""}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return AlertDialog(
          title: new Text("Сервертэй холбогдож чадсангүй"),
          content: new Text(
              errorTxt == "" ? "Интернет холболт оо шалгана уу" : errorTxt),
          actions: <Widget>[
            MaterialButton(
              child: Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(4)),
                child: Text(
                  actionTex != "" ? actionTex : "Дахин оролдох",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                tryAgian();
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> getPagination() {
    List<Widget> pager = [];

    bool isFirstPage = false;
    bool isLastPage = false;

    if (currentPage == 1) {
      isFirstPage = true;
    }
    if (lastPage == currentPage) {
      isLastPage = true;
    }
    pager.add(new RawMaterialButton(
      onPressed: () {
        if (!isFirstPage) {
          fetchData(false, currentPage - 1);
        }
      },
      child: Icon(Icons.arrow_back_ios,
          color: isFirstPage ? Color(0xFF999999) : widget.activeColor,
          size: 15),
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.white,
      padding: const EdgeInsets.all(10.0),
      constraints: BoxConstraints(),
    ));

    List<int> ranges = [];

    int left = currentPage - 1;

    int right = currentPage + 3;

    if (currentPage == 1) {
      right = currentPage + 4;
    }

    for (var i = 1; i <= lastPage; i++) {
      if (i >= left && i < right) {
        ranges.add(i);
      }
    }

    for (int i in ranges) {
      pager.add(SizedBox(width: 5));
      pager.add(new RawMaterialButton(
        onPressed: () {
          fetchData(false, i);
        },
        child: Text(
          i.toString(),
          style: TextStyle(
              color: currentPage == i ? Colors.white : widget.activeColor),
        ),
        shape: new CircleBorder(),
        elevation: 2.0,
        fillColor: currentPage == i ? widget.activeColor : Colors.white,
        padding: const EdgeInsets.all(15.0),
        constraints: BoxConstraints(),
      ));
    }
    pager.add(SizedBox(width: 5));
    pager.add(RawMaterialButton(
      onPressed: () {
        if (!isLastPage) {
          fetchData(false, currentPage + 1);
        }
      },
      child: Icon(Icons.arrow_forward_ios,
          color: isLastPage ? Color(0xFF999999) : widget.activeColor, size: 15),
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.white,
      padding: const EdgeInsets.all(10.0),
      constraints: BoxConstraints(),
    ));

    return pager;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading
          ? Loader()
          : Column(
              children: [
                total >= 1
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(top: 30.0),
                        child: Text(
                          "Мэдээлэл олдсонгүй !!!",
                          style: TextStyle(
                              color: Color.fromRGBO(99, 120, 136, 1),
                              fontWeight: FontWeight.normal,
                              fontSize: 14),
                        ),
                      ),
                Expanded(
                  child: DataGrid(
                    schema,
                    data: widget.offlineData != null
                        ? [...widget.offlineData!, ...data]
                        : data,
                    rowOnTap: this.rowOnTap,
                    listItem: widget.listItem!,
                  ),
                ),
                lastPage >= 2
                    ? Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                width: 1.0, color: Color(0xFFCCCCCC)),
                          ),
                        ),
                        height: 60,
                        padding: EdgeInsets.only(
                            right: 10, top: 5, left: 10, bottom: 5),
                        child: Row(
                          children: getPagination(),
                        ),
                      )
                    : Container()
              ],
            ),
    );
  }
}
