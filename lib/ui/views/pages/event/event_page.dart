import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/core/models/event.dart';
import 'package:youth/core/viewmodels/event_model.dart';
import 'package:youth/ui/components/default_sliver_app_bar.dart';
import 'package:youth/ui/components/empty_items.dart';
import 'package:youth/ui/components/loader.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:youth/ui/views/pages/event/event_detail.dart';

import '../../../../size_config.dart';
import '../../base_view.dart';

class EventPage extends StatefulWidget {
  final String? title;

  const EventPage({Key? key, this.title}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
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
              title: widget.title!,
              color: eventColor,
              svgData: "assets/images/svg/page-heading-event.svg",
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
                child: BaseView<EventModel>(
                  onModelReady: (model) {
                    model.getEventList(22, 1, action: "refresh");
                  },
                  builder: (context, model, child) => model.loading
                      ? Loader(loaderColor: eventColor)
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
                            await model.getEventList(22, 1, action: "refresh");
                            await Future.delayed(Duration(milliseconds: 1000));
                            _refreshController.refreshCompleted();
                          },
                          onLoading: () async {
                            await model.getEventList(22, model.page + 1, action: "more");
                            await Future.delayed(Duration(milliseconds: 1000));
                            _refreshController.loadComplete();
                          },
                          child: model.eventList.length > 0
                              ? ListView(
                                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 30),
                                  children: model.eventList.map(
                                    (Event item) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EventDetailPage(item: item),
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
                                                      child: item.banner != null
                                                          ? CachedNetworkImage(
                                                              imageUrl: baseUrl + item.banner!,
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
                                                          color: eventColor.withOpacity(.7),
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
            ),
          ],
        ),
      ),
    );
  }
}
