import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safe/flutter_icons_null_safe.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:youth/ui/styles/_colors.dart' as prefix0;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:table_calendar/table_calendar.dart';
import '../components/header.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with TickerProviderStateMixin {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  final Map<DateTime, List> _holidays = {
    DateTime(2019, 1, 1): ['New Year\'s Day'],
    DateTime(2019, 1, 6): ['Epiphany'],
    DateTime(2019, 2, 14): ['Valentine\'s Day'],
    DateTime(2019, 4, 21): ['Easter Sunday'],
    DateTime(2019, 4, 22): ['Easter Monday'],
  };

  Map<DateTime, List>? _events;
  List? _selectedEvents;
  AnimationController? _animationController;
  // CalendarController? _calendarController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final _selectedDay = DateTime.now();

    _events = {
      _selectedDay.subtract(Duration(days: 30)): ['Event A0', 'Event B0', 'Event C0'],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): ['Event A2', 'Event B2', 'Event C2', 'Event D2'],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
      _selectedDay.subtract(Duration(days: 4)): ['Event A5', 'Event B5', 'Event C5'],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 1)): ['Event A8', 'Event B8', 'Event C8', 'Event D8'],
      _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'],
      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      _selectedDay.add(Duration(days: 17)): ['Event A12', 'Event B12', 'Event C12', 'Event D12'],
      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
    };

    _selectedEvents = _events![_selectedDay] ?? [];

    // _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController?.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    // _calendarController?.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      focusedDay: DateTime.now(),
      firstDay: DateTime.now(),
      lastDay: DateTime.now(),
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
          weekNumberTextStyle: TextStyle(
        color: Colors.blueGrey,
      )),
      headerStyle: HeaderStyle(
        titleTextStyle: TextStyle(color: Colors.grey),
        leftChevronIcon: Icon(
          Ionicons.ios_arrow_back,
          color: Colors.grey,
          size: 15,
        ),
        rightChevronIcon: Icon(
          Ionicons.ios_arrow_forward,
          color: Colors.grey,
          size: 15,
        ),
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white70, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: prefix0.secondaryColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      calendarBuilders: CalendarBuilders(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width / 2;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 0, left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Арга хэмжээ',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: primaryColor.withOpacity(.9),
                    ),
                  ),
                ],
              )),
          Container(
            margin: EdgeInsets.only(top: 60),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 0),
                  margin: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(color: bgColor, border: Border(bottom: BorderSide(color: bgColor))),
                  child: _buildTableCalendar(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(
                        '2019-05-14 өдрийн үйл явдлууд'.toUpperCase(),
                        style: TextStyle(color: primaryColor, fontSize: 16),
                      ),
                    ),
                    GridView.count(
                      padding: EdgeInsets.only(top: 10, bottom: 20, left: 15, right: 15),
                      crossAxisCount: 2,
                      mainAxisSpacing: 13,
                      crossAxisSpacing: 13,
                      childAspectRatio: (itemWidth / 285),
                      controller: new ScrollController(keepScrollOffset: false),
                      shrinkWrap: true,
                      children: [
                        GestureDetector(
                          onTap: null,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width - 20,
                                padding: EdgeInsets.only(left: 0, right: 0),
                                decoration: BoxDecoration(
                                  color: Color(0xfff2f3fa),
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [shadow],
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 166,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                        child: Image.asset(
                                          'assets/images/news/1.jpg',
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Positioned(
                                      left: 0,
                                      top: 10,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: secondaryColor.withOpacity(.7),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(3),
                                              bottomRight: Radius.circular(3),
                                            )),
                                        padding: EdgeInsets.only(left: 5, top: 4, bottom: 3, right: 5),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              // Feather.getIconData('clock'),
                                              Feather.clock,
                                              size: 14,
                                              color: Colors.white70,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "2019-05-14",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(fontSize: 13, color: Colors.white70),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 130,
                                      child: Container(
                                        height: 36,
                                        width: itemWidth,
                                        color: Colors.black38,
                                        padding: EdgeInsets.all(3),
                                        child: Text(
                                          'Залуу хүн апп өдөрлөг',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 170, left: 10, right: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(
                                                // Feather.getIconData('clock'),
                                                Feather.clock,
                                                size: 14,
                                                color: secondaryColor.withOpacity(.8),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "15:00 цаг",
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(fontSize: 13, color: primaryColor.withOpacity(.8)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(
                                                // Feather.getIconData('clock'),
                                                Feather.clock,
                                                size: 14,
                                                color: secondaryColor.withOpacity(.8),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "17:00 цаг",
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(fontSize: 13, color: primaryColor.withOpacity(.8)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Feather.map_pin, size: 14, color: Colors.redAccent),
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    "Улсын драмын театрын 405 тоот",
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(fontSize: 13, color: Color(0xff666666)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: null,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width - 20,
                                padding: EdgeInsets.only(left: 0, right: 0),
                                decoration: BoxDecoration(
                                  color: Color(0xfff2f3fa),
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [shadow],
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 166,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                        child: Image.asset(
                                          'assets/images/news/2.jpg',
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Positioned(
                                      left: 0,
                                      top: 10,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: secondaryColor.withOpacity(.7),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(3),
                                              bottomRight: Radius.circular(3),
                                            )),
                                        padding: EdgeInsets.only(left: 5, top: 4, bottom: 3, right: 5),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              // Feather.getIconData('clock'),
                                              Feather.clock,
                                              size: 14,
                                              color: Colors.white70,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "2019-05-14",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(fontSize: 13, color: Colors.white70),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 130,
                                      child: Container(
                                        height: 36,
                                        width: itemWidth,
                                        color: Colors.black38,
                                        padding: EdgeInsets.all(3),
                                        child: Text(
                                          'Оюутнуудад сургалт орно',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 170, left: 10, right: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(
                                                // Feather.getIconData('clock'),
                                                Feather.clock,
                                                size: 14,
                                                color: secondaryColor.withOpacity(.8),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "15:00 цаг",
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(fontSize: 13, color: primaryColor.withOpacity(.8)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(
                                                Feather.clock,
                                                size: 14,
                                                color: secondaryColor.withOpacity(.8),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "17:00 цаг",
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(fontSize: 13, color: primaryColor.withOpacity(.8)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Feather.map_pin, size: 14, color: Colors.redAccent),
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    "Улсын драмын театрын 405 тоот",
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(fontSize: 13, color: Color(0xff666666)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
