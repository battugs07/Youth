import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/core/models/Elearn.dart';
import 'package:youth/core/viewmodels/elearn_model.dart';
import 'package:youth/ui/components/empty_items.dart';
import 'package:youth/ui/components/loader.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youth/ui/views/pages/eLearnDetail.dart';
import 'package:youth/ui/views/pages/knowLedge/knowLedgeDetail.dart';
import 'package:youth/ui/views/pages/lawPage/lawDetail.dart';
import 'package:youth/ui/views/pages/partTimeJobDetail.dart';
import 'package:youth/ui/views/pages/volunteerWorkDetail.dart';

import '../base_view.dart';

class ELearnPage extends StatefulWidget {
  final title;

  const ELearnPage({Key? key, this.title}) : super(key: key);

  @override
  ELearnPageState createState() => ELearnPageState();
}

class ELearnPageState extends State<ELearnPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<dynamic> jobs = [];
  NetworkUtil _http = new NetworkUtil();
  int page = 1;
  // final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Future getItemList() async {
    var url = baseUrl + '/api/mobile/getLessons?page=' + page.toString();
    var response = await _http.get(url);
    var response_data = response['data'];
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

    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        child: BaseView<ElearnModel>(
          onModelReady: (model) {
            model.getElarnList(1, action: 'refresh');
          },
          builder: (context, model, child) => model.loading
              ? Loader(loaderColor: eLearnColor)
              : SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: model.hasData ? true : false,
                  header: ClassicHeader(
                    idleText: "Доош чирч дахин ачааллана",
                    releaseText: "Дахин ачааллах",
                    refreshingText: "Түр хүлээнэ үү...",
                    completeText: 'Дахин ачааллаж дууслаа',
                    textStyle: TextStyle(color: Colors.grey),
                  ),
                  footer: ClassicFooter(
                    idleText: "Цааш үзэх",
                    noDataText: "Цааш мэдээлэл байхгүй",
                    textStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  controller: _refreshController,
                  onRefresh: () async {
                    await model.getElarnList(1, action: "refresh");
                    await Future.delayed(Duration(milliseconds: 1000));
                    _refreshController.refreshCompleted();
                  },
                  onLoading: () async {
                    await model.getElarnList(model.page + 1, action: "more");
                    await Future.delayed(Duration(milliseconds: 1000));
                    _refreshController.loadComplete();
                  },
                  child: model.elearnDataList.length > 0
                      ? ListView(
                          padding: EdgeInsets.only(left: 15, right: 15, bottom: 30),
                          children: model.elearnDataList.map(
                            (Elearn item) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ELearnDetailPage(
                                        title: item.title,
                                        thumb: item.thumb,
                                        description: item.headline,
                                        body: item.body,
                                        teachername: item.teachername,
                                        updated_at: item.updatedAt,
                                        created_at: item.createdAt,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 1,
                                        color: Colors.grey.withOpacity(0.23),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: eLearnColor.withOpacity(.7),
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 136,
                                        child: Stack(
                                          children: <Widget>[
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(4),
                                              child: item.thumb != null
                                                  ? CachedNetworkImage(
                                                      imageUrl: baseUrl + item.thumb!,
                                                      imageBuilder: (context, imageProvider) => Container(
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                            image: imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      placeholder: (context, url) => Center(
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          backgroundColor: Colors.red,
                                                        ),
                                                      ),
                                                      errorWidget: (context, url, error) => Container(
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                            image: NetworkImage(
                                                              baseUrl + "/assets/youth/images/noImage.jpg",
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            baseUrl + "/assets/youth/images/noImage.jpg",
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            Positioned(
                                              left: 0,
                                              top: 20,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: eLearnColor.withOpacity(.7),
                                                  borderRadius: BorderRadius.only(
                                                    bottomRight: Radius.circular(4.0),
                                                    topRight: Radius.circular(4.0),
                                                  ),
                                                ),
                                                padding: EdgeInsets.only(
                                                  top: 3,
                                                  bottom: 3,
                                                  right: 10,
                                                  left: 10,
                                                ),
                                                child: Wrap(
                                                  children: <Widget>[
                                                    Icon(
                                                      FontAwesomeIcons.clock,
                                                      color: Colors.white,
                                                      size: 13,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      item.createdAt.toString().substring(0, 10),
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 13,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title!.length > 75
                                                  ? item.title!.toUpperCase().substring(0, 75) + "..."
                                                  : item.title!.toUpperCase(),
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        )
                      : EmptyItems(),
                ),
        ),
      ),
    );

    // TODO: implement build
    // return Scaffold(
    //   body: Stack(
    //     children: <Widget>[
    //       Positioned(
    //           width: MediaQuery.of(context).size.width,
    //           top: 0,
    //           bottom: 0,
    //           left: 0,
    //           child: Container(
    //             height: size.height * 0.7,
    //             child: SmartRefresher(
    //               enablePullDown: true,
    //               enablePullUp: true,
    //               header: WaterDropHeader(
    //                 complete: Container(),
    //                 completeDuration: Duration(milliseconds: 100),
    //                 waterDropColor: secondaryColor,
    //               ),
    //               footer: ClassicFooter(
    //                 idleText: "Цааш үзэх",
    //                 loadingText: "Түр хүлээнэ үү",
    //                 noDataText: "Цааш мэдээлэл байхгүй",
    //                 textStyle: TextStyle(color: Color(0xff666666)),
    //               ),
    //               controller: _refreshController,
    //               onRefresh: () async {
    //                 setState(() {
    //                   this.page = 1;
    //                   this.jobs = new List();
    //                 });
    //                 await this.getItemList();
    //                 await Future.delayed(Duration(milliseconds: 1000));
    //                 _refreshController.refreshCompleted();
    //               },
    //               onLoading: () async {
    //                 setState(() {
    //                   this.page = this.page + 1;
    //                 });
    //                 await this.getItemList();
    //                 await Future.delayed(Duration(milliseconds: 1000));
    //                 _refreshController.loadComplete();
    //               },
    //               child: ListView(
    //                 controller: new ScrollController(keepScrollOffset: false),
    //                 shrinkWrap: true,
    //                 children: jobs.map(
    //                   (item) {
    //                     index = index + 1;
    //                     return Container(
    //                         width: size.width - 40,
    //                         margin: EdgeInsets.symmetric(
    //                             horizontal: 20, vertical: 20),
    //                         decoration: BoxDecoration(
    //                             border: Border.all(
    //                                 color: podCastColor.withOpacity(0.3),
    //                                 width: 1,
    //                                 style: BorderStyle.solid),
    //                             borderRadius: BorderRadius.circular(8)),
    //                         child: Stack(
    //                           children: [
    //                             Column(
    //                               children: [
    //                                 Container(
    //                                     width: size.width - 40,
    //                                     height: 150,
    //                                     decoration: BoxDecoration(
    //                                         border: Border(
    //                                             bottom: BorderSide(
    //                                                 color: podCastColor,
    //                                                 width: 1))),
    //                                     child: ClipRRect(
    //                                       borderRadius: BorderRadius.only(
    //                                           topRight: Radius.circular(8),
    //                                           topLeft: Radius.circular(8)),
    //                                       child: Image.network(
    //                                         item['thumb'] == null
    //                                             ? baseUrl +
    //                                                 "/assets/youth/images/noImage.jpg"
    //                                             : baseUrl +
    //                                                 item['thumb'].toString(),
    //                                         height: MediaQuery.of(context)
    //                                             .size
    //                                             .height,
    //                                         width: size.width,
    //                                         fit: BoxFit.cover,
    //                                       ),
    //                                     )),
    //                                 Container(
    //                                   width: size.width - 40,
    //                                   decoration: BoxDecoration(
    //                                     color: Colors.white,
    //                                     borderRadius: BorderRadius.only(
    //                                         bottomRight: Radius.circular(8),
    //                                         bottomLeft: Radius.circular(8)),
    //                                   ),
    //                                   child: Column(
    //                                     children: [
    //                                       Container(
    //                                         padding: EdgeInsets.only(
    //                                             left: 10, top: 10, right: 10),
    //                                         alignment: Alignment.centerLeft,
    //                                         child: Flex(
    //                                           direction: Axis.horizontal,
    //                                           children: [
    //                                             Flexible(
    //                                               child: Text(
    //                                                 item['title'] == null
    //                                                     ? ''
    //                                                     : item['title'],
    //                                                 overflow:
    //                                                     TextOverflow.ellipsis,
    //                                                 maxLines: 3,
    //                                                 softWrap: false,
    //                                                 style: TextStyle(
    //                                                     color: podCastColor,
    //                                                     fontWeight:
    //                                                         FontWeight.bold,
    //                                                     fontSize: 18),
    //                                               ),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                       Container(
    //                                         padding: EdgeInsets.only(
    //                                           left: 10,
    //                                         ),
    //                                         margin: EdgeInsets.only(
    //                                             left: 10, top: 10, right: 10),
    //                                         alignment: Alignment.centerLeft,
    //                                         decoration: BoxDecoration(
    //                                             border: Border(
    //                                                 left: BorderSide(
    //                                                     color: secondaryColor,
    //                                                     width: 2))),
    //                                         child: Flex(
    //                                           direction: Axis.horizontal,
    //                                           children: [
    //                                             Flexible(
    //                                               child: Text(
    //                                                 item['headline'] == null
    //                                                     ? ''
    //                                                     : item['headline'],
    //                                                 overflow:
    //                                                     TextOverflow.ellipsis,
    //                                                 maxLines: 3,
    //                                                 softWrap: false,
    //                                                 style: TextStyle(
    //                                                     color: Colors.black87,
    //                                                     fontWeight:
    //                                                         FontWeight.w500,
    //                                                     fontSize: 16),
    //                                               ),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                       Container(
    //                                         margin: EdgeInsets.only(
    //                                             left: 10,
    //                                             right: 10,
    //                                             top: 30,
    //                                             bottom: 10),
    //                                         decoration: BoxDecoration(
    //                                             border: Border(
    //                                                 top: BorderSide(
    //                                                     color: Colors.grey,
    //                                                     width: 1))),
    //                                         child: Column(
    //                                           children: [
    //                                             Container(
    //                                                 padding: EdgeInsets.only(
    //                                                     top: 10, bottom: 10),
    //                                                 width:
    //                                                     MediaQuery.of(context)
    //                                                             .size
    //                                                             .width -
    //                                                         25,
    //                                                 child: Row(
    //                                                   children: [
    //                                                     Icon(
    //                                                         Icons
    //                                                             .calendar_today,
    //                                                         color: podCastColor,
    //                                                         size: 14.0),
    //                                                     SizedBox(width: 5),
    //                                                     Text(
    //                                                       'Шинэчилсэн огноо: ',
    //                                                       style: TextStyle(
    //                                                           color: Colors
    //                                                               .black54,
    //                                                           fontWeight:
    //                                                               FontWeight
    //                                                                   .w500,
    //                                                           fontSize: 14),
    //                                                     ),
    //                                                     Text(
    //                                                       item['updated_at'] ==
    //                                                               null
    //                                                           ? ''
    //                                                           : DateFormat(
    //                                                                   "y/MM/dd")
    //                                                               .format(DateTime
    //                                                                   .parse(item[
    //                                                                       'updated_at']))
    //                                                               .toString(),
    //                                                       style: TextStyle(
    //                                                           color:
    //                                                               podCastColor,
    //                                                           fontWeight:
    //                                                               FontWeight
    //                                                                   .w500,
    //                                                           fontSize: 14),
    //                                                     ),
    //                                                   ],
    //                                                 )),
    //                                             Container(
    //                                                 padding: EdgeInsets.only(
    //                                                     top: 0, bottom: 10),
    //                                                 width:
    //                                                     MediaQuery.of(context)
    //                                                             .size
    //                                                             .width -
    //                                                         25,
    //                                                 child: Row(
    //                                                   children: [
    //                                                     Icon(Icons.access_time,
    //                                                         color: podCastColor,
    //                                                         size: 14.0),
    //                                                     SizedBox(width: 5),
    //                                                     Text(
    //                                                       'Нэмсэн огноо: ',
    //                                                       style: TextStyle(
    //                                                           color: Colors
    //                                                               .black54,
    //                                                           fontWeight:
    //                                                               FontWeight
    //                                                                   .w500,
    //                                                           fontSize: 14),
    //                                                     ),
    //                                                     Text(
    //                                                       item['created_at'] ==
    //                                                               null
    //                                                           ? ''
    //                                                           : DateFormat(
    //                                                                   "y/MM/dd")
    //                                                               .format(DateTime
    //                                                                   .parse(item[
    //                                                                       'created_at']))
    //                                                               .toString(),
    //                                                       style: TextStyle(
    //                                                           color:
    //                                                               podCastColor,
    //                                                           fontWeight:
    //                                                               FontWeight
    //                                                                   .w500,
    //                                                           fontSize: 14),
    //                                                     ),
    //                                                   ],
    //                                                 )),
    //                                             Container(
    //                                                 padding: EdgeInsets.only(
    //                                                     top: 0, bottom: 10),
    //                                                 width:
    //                                                     MediaQuery.of(context)
    //                                                             .size
    //                                                             .width -
    //                                                         25,
    //                                                 child: Row(
    //                                                   children: [
    //                                                     Icon(
    //                                                         Icons
    //                                                             .supervised_user_circle,
    //                                                         color: podCastColor,
    //                                                         size: 14.0),
    //                                                     SizedBox(width: 5),
    //                                                     Text(
    //                                                       'Бэлтгэсэн багш: ',
    //                                                       style: TextStyle(
    //                                                           color: Colors
    //                                                               .black54,
    //                                                           fontWeight:
    //                                                               FontWeight
    //                                                                   .w500,
    //                                                           fontSize: 14),
    //                                                     ),
    //                                                     Text(
    //                                                       item['teachername'] ==
    //                                                               null
    //                                                           ? '__'
    //                                                           : item['teachername']
    //                                                               .toString(),
    //                                                       style: TextStyle(
    //                                                           color:
    //                                                               podCastColor,
    //                                                           fontWeight:
    //                                                               FontWeight
    //                                                                   .w500,
    //                                                           fontSize: 14),
    //                                                     ),
    //                                                   ],
    //                                                 )),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 )
    //                               ],
    //                             ),
    //                             Positioned(
    //                                 bottom: 5,
    //                                 right: 10,
    //                                 child: GestureDetector(
    //                                     onTap: () {
    //                                       Navigator.push(
    //                                           context,
    //                                           MaterialPageRoute(
    //                                               builder: (context) =>
    //                                                   ELearnDetailPage(
    //                                                     title: item['title'],
    //                                                     thumb: item['thumb'],
    //                                                     description:
    //                                                         item['headline'],
    //                                                     body: item['body'],
    //                                                     teachername:
    //                                                         item['teachername'],
    //                                                     updated_at:
    //                                                         item['updated_at'],
    //                                                     created_at:
    //                                                         item['created_at'],
    //                                                   )));
    //                                     },
    //                                     child: Row(
    //                                       children: [
    //                                         Container(
    //                                           padding: EdgeInsets.only(
    //                                             bottom:
    //                                                 3, // space between underline and text
    //                                           ),
    //                                           decoration: BoxDecoration(
    //                                               border: Border(
    //                                                   bottom: BorderSide(
    //                                             color:
    //                                                 secondaryColor, // Text colour here
    //                                             width: 2.0, // Underline width
    //                                           ))),
    //                                           child: Text(
    //                                             'Ца'.toUpperCase(),
    //                                             style: TextStyle(
    //                                                 color: podCastColor,
    //                                                 fontSize: 14),
    //                                           ),
    //                                         ),
    //                                         Container(
    //                                           padding: EdgeInsets.only(
    //                                             bottom:
    //                                                 3, // space between underline and text
    //                                           ),
    //                                           decoration: BoxDecoration(
    //                                               border: Border(
    //                                                   bottom: BorderSide(
    //                                             color: Colors
    //                                                 .white, // Text colour here
    //                                             width: 2.0, // Underline width
    //                                           ))),
    //                                           child: Text(
    //                                             'аш үзэх'.toUpperCase(),
    //                                             style: TextStyle(
    //                                                 color: podCastColor,
    //                                                 fontSize: 14),
    //                                           ),
    //                                         ),
    //                                         Container(
    //                                             padding: EdgeInsets.only(
    //                                               bottom:
    //                                                   3, // space between underline and text
    //                                             ),
    //                                             decoration: BoxDecoration(
    //                                                 border: Border(
    //                                                     bottom: BorderSide(
    //                                               color: Colors
    //                                                   .white, // Text colour here
    //                                               width: 2.0, // Underline width
    //                                             ))),
    //                                             child: Icon(
    //                                               FontAwesome.getIconData(
    //                                                   'angle-double-right'),
    //                                               color: podCastColor,
    //                                               size: 18.0,
    //                                             )),
    //                                       ],
    //                                     ))),
    //                           ],
    //                         ));
    //                   },
    //                 ).toList(),
    //               ),
    //             ),
    //           )),
    //     ],
    //   ),
    // );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Color.fromRGBO(200, 214, 229, 1);
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
