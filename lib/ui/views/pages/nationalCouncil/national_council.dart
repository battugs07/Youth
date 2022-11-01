import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/core/models/aimag.dart';
import 'package:youth/core/models/national_council.dart';
import 'package:youth/core/models/soum.dart';
import 'package:youth/core/viewmodels/aimag_model.dart';
import 'package:youth/core/viewmodels/national_council_model.dart';
import 'package:youth/core/viewmodels/soum_model.dart';
import 'package:youth/size_config.dart';
import 'package:youth/ui/components/default_sliver_app_bar.dart';
import 'package:youth/ui/components/loader.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:youth/ui/views/pages/sub_council.dart';

import '../../base_view.dart';

class NationalCouncilPage extends StatefulWidget {
  final title;

  const NationalCouncilPage({Key? key, this.title}) : super(key: key);

  @override
  _NationalCouncilPageState createState() => _NationalCouncilPageState();
}

class _NationalCouncilPageState extends State<NationalCouncilPage> {
  TextEditingController? _editingController;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  int? aimagId;
  int? soumtId;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SizeConfig().init(context);
    // TODO: implement build
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor,
          image: DecorationImage(
            image: AssetImage("assets/images/bg-blue.jpg"),
            alignment: Alignment.topRight,
            //fit: BoxFit.fitWidth,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 180,
              padding: EdgeInsets.only(top: 60, right: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.title.toUpperCase(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
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
                child: BaseView<NationalCouncilModel>(
                  onModelReady: (model) {
                    model.getNationalList(0, 0);
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
                            await model.getNationalList(0, 0, action: "refresh");
                            await Future.delayed(Duration(milliseconds: 1000));
                            _refreshController.refreshCompleted();
                          },
                          onLoading: () async {
                            await model.getNationalList(0, 0, action: "more");
                            await Future.delayed(Duration(milliseconds: 1000));
                            _refreshController.loadComplete();
                          },
                          child: ListView(
                            // <-- this will disable scroll
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 20, top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: getProportionateScreenWidth(245),
                                      height: getProportionateScreenWidth(45),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [shadow],
                                      ),
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 5,
                                      ),
                                      child: Container(
                                        child: TextField(
                                          controller: _editingController,
                                          onChanged: model.searchCouncil,
                                          decoration: InputDecoration(
                                            hintText: 'Хайх',
                                            hintStyle: TextStyle(
                                              color: primaryColor,
                                            ),
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        buildShowModalBottomSheet(context, model);
                                      },
                                      padding: EdgeInsets.all(getProportionateScreenWidth(14)),
                                      color: Colors.white,
                                      child: Text(
                                        'Байршил',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              model.nationalCouncilList.length == 0
                                  ? Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.all(15),
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [shadow],
                                      ),
                                      child: Text('Үр дүн олдсонгүй'),
                                    )
                                  : Column(
                                      children: model.nationalCouncilList.map(
                                        (NationalCouncil item) {
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: getProportionateScreenWidth(
                                                    15,
                                                  ),
                                                  vertical: getProportionateScreenHeight(
                                                    10,
                                                  ),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [shadow],
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: MaterialButton(
                                                    padding: EdgeInsets.all(
                                                      getProportionateScreenWidth(
                                                        20,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => SubCouncil(item: item),
                                                        ),
                                                      );
                                                    },
                                                    child: Row(
                                                      children: [
                                                        item.logo != null
                                                            ? Container(
                                                                child: CachedNetworkImage(
                                                                  imageUrl: baseUrl + item.logo!,
                                                                  width: 64,
                                                                  height: 64,
                                                                  placeholder: (context, url) => CircularProgressIndicator(),
                                                                  errorWidget: (context, url, error) => Image.network(
                                                                    baseUrl + "/assets/youth/images/noImage.jpg",
                                                                    width: 64,
                                                                  ),
                                                                ),
                                                              )
                                                            : Image.network(
                                                                baseUrl + "/assets/youth/images/noImage.jpg",
                                                                width: 64,
                                                              ),
                                                        SizedBox(width: 15),
                                                        Expanded(
                                                          child: Text(item.name!),
                                                        ),
                                                        Icon(
                                                          Icons.arrow_forward_ios,
                                                          color: primaryColor,
                                                          size: 15,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ).toList(),
                                    )
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context, NationalCouncilModel nModel) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text('Аймаг сонгох'),
            ),
            Expanded(
              child: BaseView<AimagModel>(
                onModelReady: (model) {
                  model.getAimagModelList();
                },
                builder: (context, model, child) => model.loading
                    ? Loader(
                        loaderColor: Colors.red,
                      )
                    : ListView(
                        children: model.aimagList.map(
                          (Aimag aimag) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                buildShowModalSoumBottomSheet(context, aimag.id, nModel);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [shadow],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(aimag.ner!),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF000000).withOpacity(.5),
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> buildShowModalSoumBottomSheet(BuildContext context, aimagId, NationalCouncilModel nModel) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text('Сум сонгох'),
            ),
            Expanded(
              child: BaseView<SoumModel>(
                onModelReady: (model) {
                  model.getSoumModelList(aimagId);
                },
                builder: (context, model, child) => model.loading
                    ? Loader(
                        loaderColor: Colors.red,
                      )
                    : ListView(
                        children: model.soumList.map(
                          (Soum soum) {
                            return GestureDetector(
                              onTap: () {
                                nModel.getNationalList(aimagId, soum.id!, action: 'selected');
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [shadow],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(soum.ner!),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF000000).withOpacity(.5),
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
