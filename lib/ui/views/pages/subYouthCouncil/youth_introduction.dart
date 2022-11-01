import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/core/models/youth_council.dart';
import 'package:youth/ui/components/default_sliver_app_bar.dart';
import 'package:youth/ui/components/empty_items.dart';
import 'package:youth/ui/components/header-back.dart';
import 'package:youth/ui/components/header.dart';
import 'package:youth/ui/styles/_colors.dart';

import '../../../../size_config.dart';

class Introduction extends StatefulWidget {
  final YouthCouncil? item;

  const Introduction({Key? key, this.item}) : super(key: key);
  @override
  _Introduction createState() => _Introduction();
}

class _Introduction extends State<Introduction> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: HeaderBack(
          title: 'Танилцуулга',
          reversed: true,
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Text(
              widget.item!.name!,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      child: widget.item!.introduction != null
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Html(
                                    data: widget.item!.introduction.toString(),
                                    style: {
                                      "p": Style(
                                        color: kTextColor,
                                        fontSize: FontSize(14),
                                        textAlign: TextAlign.justify,
                                      ),
                                    },
                                  ),
                                ),
                              ],
                            )
                          : EmptyItems(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
