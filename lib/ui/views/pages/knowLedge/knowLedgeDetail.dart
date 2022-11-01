import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/core/models/knowledge.dart';
import 'package:youth/core/models/volunteer_work.dart';
import 'package:youth/ui/components/header-back.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:flutter/rendering.dart';

class KnowLedgeDetail extends StatefulWidget {
  const KnowLedgeDetail({Key? key}) : super(key: key);

  @override
  _KnowLedgeDetailState createState() => _KnowLedgeDetailState();
}

class _KnowLedgeDetailState extends State<KnowLedgeDetail> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class KnowLedgeDetailPage extends StatefulWidget {
  final KnowLedge? item;

  const KnowLedgeDetailPage({
    Key? key,
    this.item,
  }) : super(key: key);

  @override
  _KnowLedgeDetailPageState createState() => _KnowLedgeDetailPageState();
}

class _KnowLedgeDetailPageState extends State<KnowLedgeDetailPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: HeaderBack(
          title: 'Мэдээ Мэдээлэл',
          reversed: true,
          customColor: knowLedgeColor,
          arrawBackColor: knowLedgeColor,
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: knowLedgeColor,
              ),
              child: Text(
                widget.item!.title!,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: bgColor,
                ),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          widget.item!.thumb != null
                              ? Container(
                                  height: 280,
                                  decoration: BoxDecoration(
                                    boxShadow: [shadow],
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: CachedNetworkImage(
                                          imageUrl: baseUrl + widget.item!.thumb!,
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
                                        ),
                                      ),
                                    ],
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
                          SizedBox(height: 10),
                          Container(
                            child: Html(
                              data: widget.item!.description.toString(),
                              style: {
                                "p": Style(
                                  color: kTextColor,
                                  fontSize: FontSize(12),
                                  textAlign: TextAlign.justify,
                                ),
                              },
                            ),
                          ),
                          Container(
                            height: 90,
                            margin: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 30,
                              bottom: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: knowLedgeColor,
                                        size: 14.0,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        widget.item!.createdAt.toString().substring(0, 10),
                                        style: TextStyle(
                                          color: knowLedgeColor,
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
