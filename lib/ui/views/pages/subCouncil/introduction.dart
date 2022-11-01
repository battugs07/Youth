import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/core/models/national_council.dart';
import 'package:youth/ui/components/default_sliver_app_bar.dart';
import 'package:youth/ui/components/empty_items.dart';
import 'package:youth/ui/components/header-back.dart';
import 'package:youth/ui/styles/_colors.dart';

import '../../../../size_config.dart';

class Introduction extends StatefulWidget {
  final NationalCouncil? item;

  const Introduction({Key? key, this.item}) : super(key: key);
  @override
  _Introduction createState() => _Introduction();
}

class _Introduction extends State<Introduction> {
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: bgColor,
              ),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      getProportionateScreenWidth(15),
                    ),
                    child: widget.item!.introduction != null
                        ? Column(
                            children: [
                              Text(
                                widget.item!.name!,
                                style: TextStyle(fontSize: 18, color: primaryColor),
                                textAlign: TextAlign.center,
                              ),
                              Html(
                                data: widget.item!.introduction.toString(),
                                style: {
                                  "p": Style(
                                    color: kTextColor,
                                    fontSize: FontSize(14),
                                    textAlign: TextAlign.justify,
                                  ),
                                },
                              ),
                            ],
                          )
                        : EmptyItems(),
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
