import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/ui/components/loader.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youth/ui/views/pages/partTimeJobDetail.dart';
import 'package:youth/ui/views/pages/volunteerWorkDetail.dart';

class VolunteerWorkPage extends StatefulWidget {
  final title;
  final subTitle;

  const VolunteerWorkPage({Key? key, this.title, this.subTitle}) : super(key: key);

  @override
  VolunteerWorkPageState createState() => VolunteerWorkPageState();
}

class VolunteerWorkPageState extends State<VolunteerWorkPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<dynamic> jobs = [];
  NetworkUtil _http = new NetworkUtil();
  int page = 1;
  // final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Future getItemList() async {
    var url = baseUrl + '/mobile/api/getVolunteers/null?page=' + page.toString();
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
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: volunteerColor,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.zero,
                centerTitle: true,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: Container(),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        widget.title.toUpperCase(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                ),
                background: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      bottom: 0,
                      child: SvgPicture.asset(
                        "assets/images/svg/page-heading-legal.svg",
                        width: size.width,
                        height: size.height * .13,
                      ),
                    ),
                  ],
                ),
              ),
              // title: Text(widget.title.toUpperCase()),
            ),
          ];
        },
        body: Container(
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
              textStyle: TextStyle(
                color: Color(0xff666666),
              ),
            ),
            controller: _refreshController,
            onRefresh: () async {
              setState(() {
                this.page = 1;
                this.jobs = [];
              });
              await this.getItemList();
              await Future.delayed(
                Duration(milliseconds: 1000),
              );
              _refreshController.refreshCompleted();
            },
            onLoading: () async {
              setState(() {
                this.page = this.page + 1;
              });
              await this.getItemList();
              await Future.delayed(
                Duration(milliseconds: 1000),
              );
              _refreshController.loadComplete();
            },
            child: ListView(
              shrinkWrap: true,
              children: jobs.map(
                (item) {
                  index = index + 1;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VolunteerWorkDetailPage(
                            name: item['name'],
                            description: item['description'],
                            startdate: item['startdate'],
                            enddate: item['enddate'],
                            created_at: item['created_at'],
                            image: item['image'],
                            works: item['works'],
                            org_name: item['org_name'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: size.width - 40,
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(67, 35, 167, 0.3),
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: size.width - 40,
                                height: 150,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color.fromRGBO(67, 35, 167, 0.3),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    topLeft: Radius.circular(8),
                                  ),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        item['image'] != null
                                            ? Container(
                                                height: 90,
                                                child: CachedNetworkImage(
                                                  imageUrl: item['image'],
                                                  imageBuilder: (context, imageProvider) => Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) => Container(
                                                    child: Center(
                                                      child: CircularProgressIndicator(strokeWidth: 2),
                                                    ),
                                                  ),
                                                  errorWidget: (context, url, error) => Image.network(
                                                    baseUrl + "/assets/youth/images/noImage.jpg",
                                                    width: 200,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 90,
                                                child: Image.network(
                                                  baseUrl + "/assets/youth/images/noImage.jpg",
                                                  width: 200,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width - 40,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        top: 10,
                                        right: 10,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Flex(
                                        direction: Axis.horizontal,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              item['works'] == null ? '' : item['works'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              softWrap: false,
                                              style: TextStyle(
                                                color: volunteerColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                      ),
                                      margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(color: Colors.lightBlue, width: 2),
                                        ),
                                      ),
                                      child: Flex(
                                        direction: Axis.horizontal,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              item['description'] == null ? '' : item['description'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              softWrap: false,
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 90,
                                      margin: EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(color: Colors.grey, width: 1),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(top: 10, bottom: 10),
                                            width: MediaQuery.of(context).size.width - 25,
                                            child: Row(
                                              children: [
                                                Icon(Icons.calendar_today, color: Colors.lightBlue, size: 14.0),
                                                SizedBox(width: 5),
                                                Text(
                                                  'Бүртгэх хугацаа: ',
                                                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 14),
                                                ),
                                                Text(
                                                  item['startdate'] == null || item['enddate'] == null
                                                      ? ''
                                                      : DateFormat("y/MM/dd")
                                                              .format(
                                                                DateTime.parse(item['startdate']),
                                                              )
                                                              .toString() +
                                                          " - " +
                                                          DateFormat("y/MM/dd")
                                                              .format(
                                                                DateTime.parse(item['enddate']),
                                                              )
                                                              .toString(),
                                                  style: TextStyle(
                                                    color: volunteerColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(top: 0, bottom: 10),
                                            width: MediaQuery.of(context).size.width - 25,
                                            child: Row(
                                              children: [
                                                Icon(Icons.access_time, color: Colors.lightBlue, size: 14.0),
                                                SizedBox(width: 5),
                                                Text(
                                                  'Нэмсэн огноо: ',
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  item['created_at'] == null
                                                      ? ''
                                                      : DateFormat("y/MM/dd").format(DateTime.parse(item['created_at'])).toString(),
                                                  style: TextStyle(
                                                    color: volunteerColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(top: 0, bottom: 0),
                                            width: MediaQuery.of(context).size.width - 25,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.supervised_user_circle,
                                                  color: Colors.lightBlue,
                                                  size: 14.0,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  'Байгууллага: ',
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  item['org_name'] == null ? '__' : item['org_name'],
                                                  style: TextStyle(
                                                    color: volunteerColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          // Positioned(
                          //   bottom: 5,
                          //   right: 10,
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) =>
                          //               VolunteerWorkDetailPage(
                          //             name: item['name'],
                          //             description: item['description'],
                          //             startdate: item['startdate'],
                          //             enddate: item['enddate'],
                          //             created_at: item['created_at'],
                          //             image: item['image'],
                          //             works: item['works'],
                          //             org_name: item['org_name'],
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //     child: Row(
                          //       children: [
                          //         Container(
                          //           padding: EdgeInsets.only(
                          //             bottom:
                          //                 3, // space between underline and text
                          //           ),
                          //           decoration: BoxDecoration(
                          //               border: Border(
                          //                   bottom: BorderSide(
                          //             color:
                          //                 Colors.lightBlue, // Text colour here
                          //             width: 2.0, // Underline width
                          //           ))),
                          //           child: Text(
                          //             'Ца'.toUpperCase(),
                          //             style: TextStyle(
                          //                 color: volunteerColor, fontSize: 14),
                          //           ),
                          //         ),
                          //         Container(
                          //           padding: EdgeInsets.only(
                          //             bottom:
                          //                 3, // space between underline and text
                          //           ),
                          //           decoration: BoxDecoration(
                          //             border: Border(
                          //               bottom: BorderSide(
                          //                 color:
                          //                     Colors.white, // Text colour here
                          //                 width: 2.0, // Underline width
                          //               ),
                          //             ),
                          //           ),
                          //           child: Text(
                          //             'аш үзэх'.toUpperCase(),
                          //             style: TextStyle(
                          //                 color: volunteerColor, fontSize: 14),
                          //           ),
                          //         ),
                          //         Container(
                          //           padding: EdgeInsets.only(
                          //             bottom:
                          //                 3, // space between underline and text
                          //           ),
                          //           decoration: BoxDecoration(
                          //             border: Border(
                          //               bottom: BorderSide(
                          //                 color:
                          //                     Colors.white, // Text colour here
                          //                 width: 2.0, // Underline width
                          //               ),
                          //             ),
                          //           ),
                          //           child: Icon(
                          //             FontAwesome.getIconData(
                          //                 'angle-double-right'),
                          //             color: volunteerColor,
                          //             size: 18.0,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Color.fromRGBO(66, 34, 166, 1);
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

class TheCustomClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height / 3);
    var firstControlPoint = Offset(0, size.height / 3.5); // adjust the height to move start of the first curve
    var firstEndPoint =
        Offset(size.width / 4.2, size.height / 3.5 + 10); // adjust the width to add the end controll point and height to move end of the first curve

    var secControlPoint = Offset(size.width, size.height / 2.8); // adjust the height to move end of the second curve
    var secEndPoint = Offset(
        size.width, size.height / 3 - 40); // adjust the width to add the right first controll point and height to move start of the second curve

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secControlPoint.dx, secControlPoint.dy, secEndPoint.dx, secEndPoint.dy);

    path.lineTo(size.width, size.height / 3);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    throw UnimplementedError();
  }
}
