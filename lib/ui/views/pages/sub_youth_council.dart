import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:youth/core/models/youth_council.dart';
import 'package:youth/ui/components/default_sliver_app_bar.dart';
import 'package:youth/ui/components/sub_button.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:youth/ui/views/pages/subYouthCouncil/youth_introduction.dart';
import 'package:youth/ui/views/pages/subYouthCouncil/youth_plan.dart';
import 'package:youth/ui/views/pages/subYouthCouncil/youth_tips.dart';
import 'package:youth/ui/views/pages/subYouthCouncil/youth_volunteer.dart';
import 'package:youth/ui/views/pages/subCouncil/news_list.dart';
import 'package:youth/ui/views/pages/subCouncil/report_list.dart';
import 'package:youth/ui/views/pages/subYouthCouncil/youth_event.dart';
import 'package:youth/ui/views/pages/subCouncil/staff_list.dart';

import 'subYouthCouncil/youth_staff_list.dart';

class SubYouthCouncil extends StatefulWidget {
  final YouthCouncil? item;

  const SubYouthCouncil({Key? key, this.item}) : super(key: key);
  @override
  _SubCouncilState createState() => _SubCouncilState();
}

class _SubCouncilState extends State<SubYouthCouncil> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg-wh.jpg"),
            alignment: Alignment.topRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 180,
              padding: EdgeInsets.only(top: 40, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        icon: Icon(
                          Icons.arrow_back,
                          color: primaryColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.item!.name!,
                          style: TextStyle(
                            fontSize: 16,
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: QrImage(
                          backgroundColor: Colors.white,
                          data: widget.item!.qr!,
                          version: QrVersions.auto,
                          size: 70.0,
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: bgColor,
                  //color: Colors.white,
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SubButton(
                              title: "Танилцуулга",
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Introduction(
                                      item: widget.item,
                                    ),
                                  ),
                                );
                              },
                              icon: FontAwesomeIcons.addressBook,
                            ),
                            SubButton(
                              title: "Гишүүд",
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => YouthStaffList(
                                      aimagId: widget.item!.id,
                                    ),
                                  ),
                                );
                              },
                              icon: FontAwesomeIcons.users,
                            ),
                            SubButton(
                              title: "Мэдээ",
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewsList(
                                      aimagId: widget.item!.id,
                                    ),
                                  ),
                                );
                              },
                              icon: FontAwesomeIcons.newspaper,
                            ),
                            SubButton(
                              title: "Эвэнт",
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => YouthEventPage(
                                      aimagId: widget.item!.id,
                                    ),
                                  ),
                                );
                              },
                              icon: FontAwesomeIcons.calendarPlus,
                            ),
                            SubButton(
                              title: "Сайн дурын ажил",
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => YouthVolunteerWorks(
                                      aimagId: widget.item!.id,
                                    ),
                                  ),
                                );
                              },
                              icon: FontAwesomeIcons.handshake,
                            ),
                            SubButton(
                              title: "Төлөвлөгөө",
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => YouthPlan(
                                      aimagId: widget.item!.id,
                                    ),
                                  ),
                                );
                              },
                              icon: FontAwesomeIcons.clipboardList,
                            ),
                            SubButton(
                              title: "Зөвлөмж",
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => YouthTips(
                                      aimagId: widget.item!.id,
                                    ),
                                  ),
                                );
                              },
                              icon: FontAwesomeIcons.solidNewspaper,
                            ),
                            SubButton(
                              title: "Тайлан",
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReportList(
                                      aimagId: widget.item!.id,
                                    ),
                                  ),
                                );
                              },
                              icon: FontAwesomeIcons.copy,
                            ),
                          ],
                        ),
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
