import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/core/models/law.dart';
import 'package:youth/core/viewmodels/law_model.dart';
import 'package:youth/ui/components/default_sliver_app_bar.dart';
import 'package:youth/ui/components/empty_items.dart';
import 'package:youth/ui/components/loader.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:youth/ui/views/pages/lawPage/lawDetail.dart';

import '../../../../size_config.dart';
import '../../base_view.dart';

class LawPage extends StatefulWidget {
  final title;

  const LawPage({Key? key, this.title}) : super(key: key);

  @override
  LawPageState createState() => LawPageState();
}

class LawPageState extends State<LawPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  // final DateFormat formatter = DateFormat('yyyy-MM-dd');

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            DefaultSliverAppBar(
              title: widget.title,
              color: lawColor,
              svgData: "assets/images/svg/page-heading-law.svg",
            ),
          ];
        },
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(10),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: bgColor,
                ),
                child: BaseView<LawModel>(
                  onModelReady: (model) {
                    model.getLawModelList(1, action: "refresh");
                  },
                  builder: (context, model, child) => model.loading
                      ? Loader(loaderColor: lawColor)
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
                            await model.getLawModelList(1, action: "refresh");
                            await Future.delayed(Duration(milliseconds: 1000));
                            _refreshController.refreshCompleted();
                          },
                          onLoading: () async {
                            await model.getLawModelList(model.page + 1, action: "more");
                            await Future.delayed(Duration(milliseconds: 1000));
                            _refreshController.loadComplete();
                          },
                          child: model.lawList.length > 0
                              ? ListView(
                                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 30),
                                  children: model.lawList.map(
                                    (Law item) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LawDetailPage(
                                                item: item,
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
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: 136,
                                                decoration: BoxDecoration(
                                                  boxShadow: [shadow],
                                                ),
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
                                                              errorWidget: (context, url, error) => Image.network(
                                                                baseUrl + "/assets/youth/images/noImage.jpg",
                                                                width: double.infinity,
                                                                fit: BoxFit.fitWidth,
                                                              ),
                                                            )
                                                          : Container(
                                                              height: 136,
                                                              child: Image.network(
                                                                baseUrl + "/assets/youth/images/noImage.jpg",
                                                                width: double.infinity,
                                                                fit: BoxFit.fitWidth,
                                                              ),
                                                            ),
                                                    ),
                                                    Positioned(
                                                      left: 0,
                                                      top: 20,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: lawColor.withOpacity(.7),
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
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      item.title!.length > 75
                                                          ? item.title!.toUpperCase().substring(0, 75) + "..."
                                                          : item.title!.toUpperCase(),
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                      ),
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
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   body: NestedScrollView(
    //     headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //       return <Widget>[
    //         SliverAppBar(
    //           expandedHeight: 200.0,
    //           floating: false,
    //           pinned: true,
    //           backgroundColor: lawColor,
    //           flexibleSpace: FlexibleSpaceBar(
    //             titlePadding: EdgeInsets.only(right: 90),
    //             centerTitle: true,
    //             title: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: <Widget>[
    //                 Flexible(
    //                   flex: 3,
    //                   child: Container(),
    //                 ),
    //                 Flexible(
    //                   flex: 2,
    //                   child: Text(
    //                     widget.title.toUpperCase(),
    //                     textAlign: TextAlign.center,
    //                   ),
    //                 ),
    //                 Flexible(
    //                   flex: 1,
    //                   child: Container(),
    //                 ),
    //               ],
    //             ),
    //             background: Stack(
    //               children: [
    //                 Positioned(
    //                   left: -300,
    //                   bottom: 40,
    //                   child: SvgPicture.asset(
    //                     "assets/images/svg/page-heading-law.svg",
    //                     width: size.width,
    //                     height: size.height * .20,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ];
    //     },
    //     body: Container(
    //       height: size.height * 0.7,
    //       child: SmartRefresher(
    //         enablePullDown: true,
    //         enablePullUp: true,
    //         header: WaterDropHeader(
    //           complete: Container(),
    //           completeDuration: Duration(milliseconds: 100),
    //           waterDropColor: secondaryColor,
    //         ),
    //         footer: ClassicFooter(
    //           idleText: "Цааш үзэх",
    //           loadingText: "Түр хүлээнэ үү",
    //           noDataText: "Цааш мэдээлэл байхгүй",
    //           textStyle: TextStyle(color: Color(0xff666666)),
    //         ),
    //         controller: _refreshController,
    //         onRefresh: () async {
    //           setState(() {
    //             this.page = 1;
    //             this.jobs = new List();
    //           });
    //           await this.getItemList();
    //           await Future.delayed(Duration(milliseconds: 1000));
    //           _refreshController.refreshCompleted();
    //         },
    //         onLoading: () async {
    //           setState(() {
    //             this.page = this.page + 1;
    //           });
    //           await this.getItemList();
    //           await Future.delayed(Duration(milliseconds: 1000));
    //           _refreshController.loadComplete();
    //         },
    //         child: ListView(
    //           shrinkWrap: true,
    //           children: jobs.map(
    //             (item) {
    //               index = index + 1;
    //               return GestureDetector(
    //                 onTap: () {
    //                   Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (context) => LawDetailPage(
    //                         title: item['title'],
    //                         thumb: item['thumb'],
    //                         body: item['body'],
    //                         link: item['link'],
    //                         type: item['type'],
    //                         views: item['views'],
    //                         created_at: item['created_at'],
    //                       ),
    //                     ),
    //                   );
    //                 },
    //                 child: Container(
    //                   width: size.width - 40,
    //                   margin:
    //                       EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    //                   decoration: BoxDecoration(
    //                     border: Border.all(
    //                       color: lawColor.withOpacity(0.3),
    //                       width: 1,
    //                       style: BorderStyle.solid,
    //                     ),
    //                     borderRadius: BorderRadius.circular(8),
    //                   ),
    //                   child: Stack(
    //                     children: [
    //                       Column(
    //                         children: [
    //                           Container(
    //                             width: size.width - 40,
    //                             height: 150,
    //                             decoration: BoxDecoration(
    //                               border: Border(
    //                                 bottom: BorderSide(
    //                                   color: Color.fromRGBO(67, 35, 167, 0.3),
    //                                   width: 1,
    //                                 ),
    //                               ),
    //                             ),
    //                             child: ClipRRect(
    //                               borderRadius: BorderRadius.only(
    //                                 topRight: Radius.circular(8),
    //                                 topLeft: Radius.circular(8),
    //                               ),
    //                               // child: Image.network(
    //                               //   item['thumb'] == null
    //                               //       ? baseUrl +
    //                               //           "/assets/youth/images/noImage.jpg"
    //                               //       : baseUrl + item['thumb'].toString(),
    //                               //   height: MediaQuery.of(context).size.height,
    //                               //   width: size.width,
    //                               //   fit: BoxFit.fitWidth,
    //                               // ),
    //                               child: Container(
    //                                 child: Column(
    //                                   children: [
    //                                     item['image'] != null
    //                                         ? Container(
    //                                             height: 90,
    //                                             child: CachedNetworkImage(
    //                                               imageUrl: item['thumb'],
    //                                               imageBuilder: (context,
    //                                                       imageProvider) =>
    //                                                   Container(
    //                                                 decoration: BoxDecoration(
    //                                                   image: DecorationImage(
    //                                                     image: imageProvider,
    //                                                     fit: BoxFit.cover,
    //                                                   ),
    //                                                   borderRadius:
    //                                                       BorderRadius.circular(
    //                                                           15),
    //                                                 ),
    //                                               ),
    //                                               placeholder: (context, url) =>
    //                                                   Container(
    //                                                 child: Center(
    //                                                   child:
    //                                                       CircularProgressIndicator(
    //                                                           strokeWidth: 2),
    //                                                 ),
    //                                               ),
    //                                               errorWidget:
    //                                                   (context, url, error) =>
    //                                                       Image.network(
    //                                                 baseUrl +
    //                                                     "/assets/youth/images/noImage.jpg",
    //                                                 width: 200,
    //                                                 fit: BoxFit.fitWidth,
    //                                               ),
    //                                             ),
    //                                           )
    //                                         : Container(
    //                                             margin:
    //                                                 EdgeInsets.only(top: 30),
    //                                             height: 90,
    //                                             child: Image.network(
    //                                               baseUrl +
    //                                                   "/assets/youth/images/noImage.jpg",
    //                                               width: 200,
    //                                               fit: BoxFit.fitWidth,
    //                                             ),
    //                                           ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                           Container(
    //                             width: size.width - 40,
    //                             height: 165,
    //                             decoration: BoxDecoration(
    //                               color: Colors.white,
    //                               borderRadius: BorderRadius.only(
    //                                 bottomRight: Radius.circular(8),
    //                                 bottomLeft: Radius.circular(8),
    //                               ),
    //                             ),
    //                             child: Column(
    //                               children: [
    //                                 Container(
    //                                   padding: EdgeInsets.only(
    //                                     left: 10,
    //                                     top: 10,
    //                                     right: 10,
    //                                   ),
    //                                   alignment: Alignment.centerLeft,
    //                                   child: Flex(
    //                                     direction: Axis.horizontal,
    //                                     children: [
    //                                       Flexible(
    //                                         child: Text(
    //                                           item['title'] == null
    //                                               ? ''
    //                                               : item['title'],
    //                                           overflow: TextOverflow.ellipsis,
    //                                           maxLines: 1,
    //                                           softWrap: false,
    //                                           style: TextStyle(
    //                                             color: lawColor,
    //                                             fontWeight: FontWeight.bold,
    //                                             fontSize: 18,
    //                                           ),
    //                                         ),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                                 Container(
    //                                   height: 90,
    //                                   margin: EdgeInsets.only(
    //                                     left: 10,
    //                                     right: 10,
    //                                     top: 30,
    //                                     bottom: 10,
    //                                   ),
    //                                   decoration: BoxDecoration(
    //                                     border: Border(
    //                                       top: BorderSide(
    //                                         color: Colors.grey,
    //                                         width: 1,
    //                                       ),
    //                                     ),
    //                                   ),
    //                                   child: Column(
    //                                     children: [
    //                                       Container(
    //                                         padding: EdgeInsets.only(
    //                                             top: 10, bottom: 10),
    //                                         width: MediaQuery.of(context)
    //                                                 .size
    //                                                 .width -
    //                                             25,
    //                                         child: Row(
    //                                           children: [
    //                                             Icon(
    //                                               Icons.calendar_today,
    //                                               color: lawColor,
    //                                               size: 14.0,
    //                                             ),
    //                                             SizedBox(width: 5),
    //                                             Text(
    //                                               'Хуулийн төрөл: ',
    //                                               style: TextStyle(
    //                                                 color: Colors.black54,
    //                                                 fontWeight: FontWeight.w500,
    //                                                 fontSize: 14,
    //                                               ),
    //                                             ),
    //                                             Text(
    //                                               item['type'] == null
    //                                                   ? ''
    //                                                   : item['type'].toString(),
    //                                               style: TextStyle(
    //                                                 color: lawColor,
    //                                                 fontWeight: FontWeight.w500,
    //                                                 fontSize: 14,
    //                                               ),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                       Container(
    //                                         padding: EdgeInsets.only(
    //                                             top: 0, bottom: 10),
    //                                         width: MediaQuery.of(context)
    //                                                 .size
    //                                                 .width -
    //                                             25,
    //                                         child: Row(
    //                                           children: [
    //                                             Icon(Icons.access_time,
    //                                                 color: lawColor,
    //                                                 size: 14.0),
    //                                             SizedBox(width: 5),
    //                                             Text(
    //                                               'Нэмсэн огноо: ',
    //                                               style: TextStyle(
    //                                                 color: Colors.black54,
    //                                                 fontWeight: FontWeight.w500,
    //                                                 fontSize: 14,
    //                                               ),
    //                                             ),
    //                                             Text(
    //                                               item['created_at'] == null
    //                                                   ? ''
    //                                                   : DateFormat("y/MM/dd")
    //                                                       .format(
    //                                                         DateTime.parse(
    //                                                           item[
    //                                                               'created_at'],
    //                                                         ),
    //                                                       )
    //                                                       .toString(),
    //                                               style: TextStyle(
    //                                                 color: lawColor,
    //                                                 fontWeight: FontWeight.w500,
    //                                                 fontSize: 14,
    //                                               ),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                       Container(
    //                                         padding: EdgeInsets.only(
    //                                           top: 0,
    //                                           bottom: 5,
    //                                         ),
    //                                         width: MediaQuery.of(context)
    //                                                 .size
    //                                                 .width -
    //                                             25,
    //                                         child: Row(
    //                                           children: [
    //                                             Icon(
    //                                               Icons.supervised_user_circle,
    //                                               color: lawColor,
    //                                               size: 14.0,
    //                                             ),
    //                                             SizedBox(width: 5),
    //                                             Text(
    //                                               'Үзсэн тоо: ',
    //                                               style: TextStyle(
    //                                                 color: Colors.black54,
    //                                                 fontWeight: FontWeight.w500,
    //                                                 fontSize: 14,
    //                                               ),
    //                                             ),
    //                                             Text(
    //                                               item['views'] == null
    //                                                   ? '__'
    //                                                   : item['views']
    //                                                       .toString(),
    //                                               style: TextStyle(
    //                                                 color: lawColor,
    //                                                 fontWeight: FontWeight.w500,
    //                                                 fontSize: 14,
    //                                               ),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               );
    //             },
    //           ).toList(),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Color.fromRGBO(179, 56, 56, 1);
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
