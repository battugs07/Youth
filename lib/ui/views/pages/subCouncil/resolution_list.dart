import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/core/models/resolution.dart';
import 'package:youth/core/viewmodels/resolution_model.dart';
import 'package:youth/ui/components/default_sliver_app_bar.dart';
import 'package:youth/ui/components/empty_items.dart';
import 'package:youth/ui/components/header-back.dart';
import 'package:youth/ui/components/loader.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:youth/ui/views/pages/subCouncil/report_detail.dart';
import 'package:youth/ui/views/pages/subCouncil/resolution_detail.dart';

import '../../../../size_config.dart';
import '../../base_view.dart';

class ResolutionList extends StatefulWidget {
  final int? aimagId;

  const ResolutionList({Key? key, this.aimagId}) : super(key: key);
  @override
  _ResolutionListState createState() => _ResolutionListState();
}

class _ResolutionListState extends State<ResolutionList> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: HeaderBack(
          title: 'Тогтоол',
          reversed: true,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                //borderRadius: BorderRadius.circular(10),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: bgColor,
              ),
              child: BaseView<ResolutionModel>(
                onModelReady: (model) {
                  model.getResolutionList(widget.aimagId!, 63, 1, action: 'refresh');
                },
                builder: (context, model, child) => model.loading
                    ? Loader(
                        loaderColor: Colors.red,
                      )
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
                          await model.getResolutionList(widget.aimagId!, 63, 1, action: "refresh");
                          await Future.delayed(Duration(milliseconds: 1000));
                          _refreshController.refreshCompleted();
                        },
                        onLoading: () async {
                          await model.getResolutionList(widget.aimagId!, 63, model.page + 1, action: "more");
                          await Future.delayed(Duration(milliseconds: 1000));
                          _refreshController.loadComplete();
                        },
                        child: model.resolutionList.length != 0
                            ? ListView(
                                padding: EdgeInsets.only(left: 15, right: 15, bottom: 30),
                                children: model.resolutionList.map((Resolution item) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ResolutionDetail(
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
                                              child: Stack(
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(4),
                                                    child: CachedNetworkImage(
                                                      imageUrl: baseUrl + "/assets/youth/images/bg-legal-togtool.jpg",
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
                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 0,
                                                    top: 20,
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                          color: primaryColor.withOpacity(.7),
                                                          borderRadius: BorderRadius.only(
                                                            bottomRight: Radius.circular(4.0),
                                                            topRight: Radius.circular(4.0),
                                                          ),
                                                        ),
                                                        padding: EdgeInsets.only(top: 3, bottom: 3, right: 10, left: 10),
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
                                                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.white),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                ],
                                              )),
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
                                                  style: TextStyle(fontSize: 13),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            : EmptyItems(),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
