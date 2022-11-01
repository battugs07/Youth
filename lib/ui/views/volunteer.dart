import 'package:flutter/material.dart';
import 'package:youth/ui/components/navbar.dart';
import 'package:youth/ui/styles/_colors.dart';
import 'package:youth/ui/components/header.dart';

class VolunteerScreen extends StatefulWidget {
  @override
  _VolunteerScreenState createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen> {
  int hentaiCount = 3;
  bool _buttonPressed = false;
  bool _loopActive = false;
  int _counter = 0;
  AnimationController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void _increaseCounterWhilePressed(context) async {
    if (_loopActive) return;
    _loopActive = true;

    while (_buttonPressed) {
      setState(() {
        _counter++;
      });
      await Future.delayed(Duration(milliseconds: 1000));
    }

    _loopActive = false;
  }

  Widget _buildBody() {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(40 * _controller!.value),
            _buildContainer(45 * _controller!.value),
            _buildContainer(50 * _controller!.value),
            Container(
              height: 35,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Color(0xffdd003f))),
              child: Image.asset('lib/apps/animax/assets/images/hentai-icon.png'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red.withOpacity(1 - _controller!.value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Header(
            title: 'Мэдээ',
            reversed: true,
          ),
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[],
                    ),
                  ),
                ],
              ),
            ),
          ),
          DefaultTabController(
            length: 3,
            child: Wrap(
              children: <Widget>[
                Container(
                  height: 36,
                  child: TabBar(
                    labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: primaryColor,
                    unselectedLabelColor: primaryColor.withAlpha(60),
                    isScrollable: true,
                    indicator: MD2Indicator(
                      indicatorHeight: 3.4,
                      indicatorColor: Color(0xfff39c12),
                      indicatorSize: MD2IndicatorSize.tiny,
                    ),
                    tabs: <Widget>[
                      Tab(text: "Шинэ мэдээ"),
                      Tab(text: "Орон нутагт"),
                      Tab(text: "Их уншигдсан"),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  height: MediaQuery.of(context).size.height - 235,
                  child: TabBarView(
                    children: [
                      Text('here1'),
                      Text('here1'),
                      Text('here1'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
