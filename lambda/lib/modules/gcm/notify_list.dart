import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:lambda/plugins/bottom_modal/bottom_modal.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifyList extends StatefulWidget {
  final String? url;
  final String? seenUrl;
  final dynamic model;

  const NotifyList({Key? key, this.url, this.model, this.seenUrl}) : super(key: key);

  @override
  _NotifyListState createState() => _NotifyListState();
}

class _NotifyListState extends State<NotifyList> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  NetworkUtil _http = new NetworkUtil();
  List<dynamic> notifications = [];
  int page = 1;
  SharedPreferences? _prefs;

  showNotification(BuildContext ctx, item) {}

  Future getNotificationList() async {
    var response = await _http.get(widget.url!);
    if (response.chartdata['pageCount'] >= page) {
      var parsed = response.chartdata['data'] as List<dynamic>;

      for (var item in parsed) {
        notifications.add(item);
      }
    }
    int count = int.parse(response.chartdata["unreadCount"].toString() ?? '0');
    _prefs = await SharedPreferences.getInstance();
    _prefs!.setInt("badgeCount", count);

    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await this.getNotificationList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SmartRefresher(
        enablePullDown: true,
//        enablePullUp: model.hasData ? true : false,
        header: WaterDropHeader(
          complete: Container(),
          completeDuration: Duration(milliseconds: 100),
          waterDropColor: Color(0xff0074f2),
        ),
        footer: ClassicFooter(
          idleText: "Цааш үзэх",
          loadingText: "Түр хүлээнэ үү",
          noDataText: "Цааш мэдээлэл байхгүй",
          textStyle: TextStyle(color: Color(0xff666666)),
        ),
        controller: _refreshController,
        onRefresh: () async {
          setState(() {
            this.page = 1;
            this.notifications = [];
          });
          await this.getNotificationList();
          await Future.delayed(Duration(milliseconds: 1000));
          _refreshController.refreshCompleted();
        },
        onLoading: () async {
//          await model.getStickers(model.page + 1, action: "more");
          await Future.delayed(Duration(milliseconds: 1000));
          _refreshController.loadComplete();
        },
        child: ListView(
//                    padding: EdgeInsets.all(0),
          controller: new ScrollController(keepScrollOffset: false),
          shrinkWrap: true,
          children: notifications.map(
            (item) {
              return Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black26, width: .15))),
//                margin: EdgeInsets.only(bottom: 0, top: 5, left: 15, right: 15),
//                padding: EdgeInsets.all(2),
                child: InkWell(
                  onTap: () => this._notifModalBottomSheet(context, item),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: item['isRead'] ? Colors.white : Colors.blueAccent.withOpacity(.13),
                        padding: EdgeInsets.only(top: 10, right: 20, left: 15, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  height: 33,
                                  width: 33,
                                  margin: EdgeInsets.only(right: 10),
//                                  decoration: BoxDecoration(
//                                      borderRadius: BorderRadius.circular(20),
//                                      border: Border.all(
//                                        color: item['isRead']
//                                            ? Colors.orange
//                                            : Colors.white,
//                                      )),
                                  child: Icon(
                                    SimpleLineIcons.bell,
                                    size: 14,
                                    color: item['isRead'] ? Colors.black45 : Colors.orange,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${item['title']}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: item['isRead'] ? Colors.black26.withOpacity(.5) : Colors.black87,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Feather.clock,
                                  size: 12,
                                  color: item['isRead'] ? Colors.black45 : Colors.orange,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Container(
                                  child: Text(
                                    '${item['dateTime']}',
                                    textAlign: TextAlign.start,
                                    style:
                                        TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: item['isRead'] ? Colors.black45 : Colors.orange),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
//                            Container(
//                              child: Text(
//                                '${item['body']}',
//                                textAlign: TextAlign.start,
//                                style: TextStyle(
//                                    fontSize: 12,
//                                    fontWeight: FontWeight.w400,
//                                    color: Color(0xff666666)),
//                              ),
//                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  void _notifModalBottomSheet(context, dynamic item) async {
    if (item['isRead'] == false) {
      await _http.get(widget.seenUrl! + '?itemId=' + item['id']);

      int index = notifications.indexWhere((item) => item['id'].toString() == item['id'].toString());
      print(index);
      print(notifications[index]['isRead']);

      if (index > -1) {
        notifications[index]['isRead'] = true;
        setState(() {});
      }

      int? count = _prefs!.getInt('badgeCount');
      if (count != 0) {
        int newCount = count! - 1;
        _prefs!.setInt('badgeCount', newCount);
      }
    }

    showBottomModal(
      context: context,
      builder: (builder) {
        return Container(
            height: MediaQuery.of(context).size.height / 1.4,
            padding: EdgeInsets.only(top: 0, right: 10, left: 10, bottom: 10),
            child: Stack(
              children: <Widget>[
                Positioned(
                  right: 10,
                  top: 10,
                  child: InkWell(
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(color: Color(0xaaeeeeee), borderRadius: BorderRadius.circular(25)),
                      child: Icon(
                        Ionicons.ios_close,
                        size: 34,
                      ),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                Center(
                    child: Container(
                  margin: EdgeInsets.only(top: 60),
                  child: Column(
                    children: <Widget>[
                      item['imageUrl'] != null
                          ? Container(
                              height: 90,
                              child: CachedNetworkImage(
                                imageUrl: item['imageUrl'],
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                placeholder: (context, url) => Container(
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            )
                          : Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(40)),
                              child: Icon(
                                SimpleLineIcons.bell,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '${item['title']}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Html(
                          data: '${item['body']}',
                          // defaultTextStyle: TextStyle(
                          //   fontSize: 16,
                          //   fontWeight: FontWeight.w500,
                          //   color: Colors.black87,
                          // ),
                        ),
                      )),
                    ],
                  ),
                ))
              ],
            ));
      },
    );
  }
}
