import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youth/ui/views/pages/eventDetail.dart';

class EventPage extends StatefulWidget {
  final title;

  const EventPage({Key? key, this.title}) : super(key: key);

  @override
  EventPageState createState() => EventPageState();
}

class EventPageState extends State<EventPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<dynamic> jobs = [];
  NetworkUtil _http = new NetworkUtil();
  int page = 1;
  // final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Future getItemList() async {
    var url = baseUrl + '/mobile/api/getEvents/null?page=' + page.toString();
    var response = await _http.get(url);
    var response_data = response.data['data'];
    var totalPage;

    totalPage = (response_data['total'] / response_data['per_page']).round() + 1;

    if (totalPage >= page) {
      var parsed = response_data['data'] as List<dynamic>;
      for (var item in parsed) {
        jobs.add(item);
      }
    }
    setState(() {});
  }

  void initState() {
    super.initState();
    getItemList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int index = 0;

    // TODO: implement build
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: <Widget>[
          Positioned(
              width: MediaQuery.of(context).size.width,
              top: size.height * 0.3 + 20,
              bottom: 0,
              left: 0,
              child: Container(
                height: size.height * 0.7,
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropHeader(
                    complete: Container(),
                    completeDuration: Duration(milliseconds: 100),
                    waterDropColor: secondaryColor,
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
                      this.jobs = [];
                    });
                    await this.getItemList();
                    await Future.delayed(Duration(milliseconds: 1000));
                    _refreshController.refreshCompleted();
                  },
                  onLoading: () async {
                    setState(() {
                      this.page = this.page + 1;
                    });
                    await this.getItemList();
                    await Future.delayed(Duration(milliseconds: 1000));
                    _refreshController.loadComplete();
                  },
                  child: ListView(
                    controller: new ScrollController(keepScrollOffset: false),
                    shrinkWrap: true,
                    children: jobs.map(
                      (item) {
                        index = index + 1;
                        return Container(
                            width: size.width - 40,
                            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                                border: Border.all(color: knowLedgeColor.withOpacity(0.3), width: 1, style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(8)),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                        width: size.width - 40,
                                        height: 150,
                                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: knowLedgeColor, width: 1))),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                                          child: Image.network(
                                            item['banner'] == null
                                                ? baseUrl + "/assets/youth/images/noImage.jpg"
                                                : baseUrl + item['banner'].toString(),
                                            height: MediaQuery.of(context).size.height,
                                            width: size.width,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                    Container(
                                      width: size.width - 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8)),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                                            alignment: Alignment.centerLeft,
                                            child: Flex(
                                              direction: Axis.horizontal,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    item['title'] == null ? '' : item['title'],
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                    softWrap: false,
                                                    style: TextStyle(color: knowLedgeColor, fontWeight: FontWeight.bold, fontSize: 18),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Container(
                                          //   padding: EdgeInsets.only(left: 10,),
                                          //   margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                                          //   alignment: Alignment.centerLeft,
                                          //   decoration: BoxDecoration(
                                          //       border: Border(
                                          //           left: BorderSide(
                                          //               color: Colors.lightBlue,
                                          //               width: 2
                                          //           )
                                          //       )
                                          //   ),
                                          //   child: Flex(
                                          //     direction: Axis.horizontal,
                                          //     children: [
                                          //       Flexible(
                                          //         child: Text(
                                          //           item['description'] == null ? '' : item['description'],
                                          //           overflow: TextOverflow.ellipsis,
                                          //           maxLines: 1,
                                          //           softWrap: false,
                                          //           style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 16),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
                                            decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 1))),
                                            child: Column(
                                              children: [
                                                Container(
                                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                                    width: MediaQuery.of(context).size.width - 25,
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.location_on, color: eventColor, size: 14.0),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          item['address'] == null ? '' : item['address'].toString(),
                                                          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 14),
                                                        ),
                                                      ],
                                                    )),
                                                Container(
                                                    padding: EdgeInsets.only(top: 0, bottom: 10),
                                                    width: MediaQuery.of(context).size.width - 25,
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.access_time, color: eventColor, size: 14.0),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          'Огноо: ',
                                                          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 14),
                                                        ),
                                                        Text(
                                                          item['created_at'] == null
                                                              ? ''
                                                              : DateFormat("y/MM/dd").format(DateTime.parse(item['created_at'])).toString(),
                                                          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 14),
                                                        ),
                                                      ],
                                                    )),
                                                Container(
                                                    padding: EdgeInsets.only(top: 0, bottom: 10),
                                                    width: MediaQuery.of(context).size.width - 25,
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.supervised_user_circle, color: eventColor, size: 14.0),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          'Үзсэн тоо: ',
                                                          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 14),
                                                        ),
                                                        Text(
                                                          item['views'] == null ? '' : item['views'].toString(),
                                                          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 14),
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Positioned(
                                    bottom: 5,
                                    right: 10,
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => EventDetailPage(
                                                        title: item['title'],
                                                        address: item['address'],
                                                        event_date1: item['event_date1'],
                                                        event_date2: item['event_date2'],
                                                        personcount: item['personcount'],
                                                        banner: item['banner'],
                                                        content: item['content'],
                                                        type: item['type'],
                                                        views: item['views'],
                                                        created_at: item['created_at'],
                                                      )));
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                bottom: 3, // space between underline and text
                                              ),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                color: secondaryColor, // Text colour here
                                                width: 2.0, // Underline width
                                              ))),
                                              child: Text(
                                                'Ца'.toUpperCase(),
                                                style: TextStyle(color: knowLedgeColor, fontSize: 14),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                bottom: 3, // space between underline and text
                                              ),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                color: Colors.white, // Text colour here
                                                width: 2.0, // Underline width
                                              ))),
                                              child: Text(
                                                'аш үзэх'.toUpperCase(),
                                                style: TextStyle(color: knowLedgeColor, fontSize: 14),
                                              ),
                                            ),
                                            Container(
                                                padding: EdgeInsets.only(
                                                  bottom: 3, // space between underline and text
                                                ),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                  color: Colors.white, // Text colour here
                                                  width: 2.0, // Underline width
                                                ))),
                                                child: Icon(
                                                  // FontAwesome.getIconData('angle-double-right'),
                                                  FontAwesome.angle_double_right,
                                                  color: knowLedgeColor,
                                                  size: 18.0,
                                                )),
                                          ],
                                        ))),
                              ],
                            ));
                      },
                    ).toList(),
                  ),
                ),
              )),
          Positioned(
            top: 0.0,
            left: 0.0,
            width: size.width,
            height: size.height * 0.35,
            child: CustomPaint(
              painter: CurvePainter(),
            ),
          ),
          Positioned(
              top: 50.0,
              right: 0,
              left: 0,
              height: size.height * 0.2,
              child: Container(
                height: size.height * 0.2,
                width: size.width,
                child: SvgPicture.asset(
                  'assets/images/svg/page-heading-event.svg',
                  semanticsLabel: 'A red up arrow',
                  fit: BoxFit.cover,
                ),
              )),
          Positioned(
              top: size.height * 0.15,
              left: 25,
              width: size.width,
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.title.toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ))),
          Positioned(
              top: 40.0,
              left: 20.0,
              width: 40.0,
              height: 40.0,
              child: Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(50.0)),
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 33.0,
                      ))))
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Color.fromRGBO(234, 185, 83, 1);
    var path = Path();
    path.lineTo(0, size.height - size.height / 12);
    // path.lineTo(size.width / 1.2, size.height);
    path.lineTo(size.width, size.height - size.height / 3);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
