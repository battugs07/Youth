import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifyBadger extends StatefulWidget {
  final String? url;
  final int? color;
  final int? badgeBg;

  const NotifyBadger({Key? key, this.url, this.color, this.badgeBg}) : super(key: key);

  @override
  _NotifyBadgerState createState() => _NotifyBadgerState();
}

class _NotifyBadgerState extends State<NotifyBadger> {
  NetworkUtil _http = new NetworkUtil();
  List<dynamic> notifications = [];
  int count = 0;
  SharedPreferences? _prefs;
  bool loading = true;

  showNotification(BuildContext ctx, item) {}

  Future getNotificationList() async {
    _prefs = await SharedPreferences.getInstance();
    int? tcount = _prefs!.getInt("badgeCount");
    if (tcount == null) {
      var response = await _http.get(widget.url!);
      setState(() {
        count = int.parse(response.chartdata["unreadCount"].toString() ?? '0');
      });

      _prefs!.setInt("badgeCount", count);
    } else {
      setState(() {
        count = tcount;
      });
    }
  }

  Future<int> calcBadgeCount() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs!.getInt("badgeCount") ?? 0;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
//      onTap: () => this.showNotification(context, item),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 33.0,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 7,
                  left: 0,
                  child: Icon(
                    SimpleLineIcons.bell,
                    size: 22,
                    color: Color(widget.color ?? 0xffffffff),
                  ),
                ),
                FutureBuilder(
                  builder: (context, projectSnap) {
                    if (projectSnap.connectionState == ConnectionState.none && projectSnap.hasData == null) {
                      return Container();
                    }
                    return Positioned(
                      right: 3,
                      child: count > 0
                          ? Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  // color: Color(widget.badgeBg ?? Colors.red),
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  count.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))
                          : Container(),
                    );
                  },
                  future: getNotificationList(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
