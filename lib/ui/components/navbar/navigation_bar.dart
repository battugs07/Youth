import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'navigation_bar_item.dart';

// ignore: must_be_immutable
class TitledBottomNavigationBar extends StatefulWidget {
  final bool? reverse;
  final Curve? curve;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? indicatorColor;
  final int? initialIndex;
  final BuildContext? ctx;
  int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavigationBarItem> items;

  TitledBottomNavigationBar({
    required Key key,
    this.reverse = true,
    this.curve = Curves.linear,
    required this.onTap,
    required this.items,
    this.activeColor,
    this.inactiveColor,
    this.indicatorColor,
    this.initialIndex = 0,
    required this.currentIndex,
    this.ctx,
  }) : super(key: key) {
    assert(items != null);
    assert(items.length >= 2 && items.length <= 6);
    assert(onTap != null);
    assert(initialIndex != null);
  }

  @override
  State createState() => _TitledBottomNavigationBarState();
}

class _TitledBottomNavigationBarState extends State<TitledBottomNavigationBar> with SingleTickerProviderStateMixin {
  static const double BAR_HEIGHT = 55;
  static const double INDICATOR_HEIGHT = 1.5;

  bool get reverse => widget.reverse!;

  Curve get curve => widget.curve!;

  List<NavigationBarItem> get items => widget.items;

  double width = 0;
  late Color activeColor;
  Duration duration = Duration(milliseconds: 250);

  @override
  void initState() {
    // select a default item
    widget.currentIndex = widget.currentIndex ?? widget.initialIndex!;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _select(widget.currentIndex);
    });

    super.initState();
  }

  double _getIndicatorPosition(int index) {
    return (-1 + (2 / (items.length - 1) * index));
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    activeColor = widget.activeColor ?? Theme.of(context).indicatorColor;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: .2,
            color: Color(0x001E3142),
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: BAR_HEIGHT,
          width: width,
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Stack(
            // overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                top: INDICATOR_HEIGHT,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: items.map((item) {
                    var index = items.indexOf(item);
                    return GestureDetector(
                      onTap: () => _select(index),
                      child: _buildItemWidget(item, index == widget.currentIndex),
                    );
                  }).toList(),
                ),
              ),
              Positioned(
                top: 0,
                width: width,
                child: AnimatedAlign(
                  alignment: Alignment(_getIndicatorPosition(widget.currentIndex), 0),
                  curve: curve,
                  duration: duration,
                  child: Container(
                    width: width / items.length - 20,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: INDICATOR_HEIGHT,
                    decoration: BoxDecoration(
                      color: widget.indicatorColor ?? activeColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _select(int index) {
    widget.currentIndex = index;
    widget.onTap(widget.currentIndex);

    setState(() {});
  }

  Widget _buildIcon(NavigationBarItem item, bool isSelected) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Icon(
          item.icon,
          size: 23,
          color: isSelected ? activeColor : widget.inactiveColor,
        )
      ],
    );
  }

  Widget _buildIconWithText(NavigationBarItem item, bool isSelected) {
    if (item.floating != null && item.floating == true) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 4,
          ),
          Container(
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.1, 0.9],
                  colors: [Color(0xff005fc2), Color(0xff0074F1)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x44005fc2),
                    blurRadius: 8.0,
                    spreadRadius: .7,
                    offset: Offset(1.0, 1.0),
                  )
                ],
              ),
              height: 36,
              width: 60,
              child: Text(
                '+',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300, color: Colors.white),
              ))
        ],
      );
    } else {
      return Column(children: <Widget>[
        SizedBox(
          height: 8,
        ),
        Icon(
          item.icon,
          size: 24,
          color: isSelected ? activeColor : widget.inactiveColor,
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          item.title!.toUpperCase(),
          style: TextStyle(color: isSelected ? activeColor : widget.inactiveColor, fontWeight: FontWeight.w700, fontSize: 10.3),
        )
      ]);
    }
  }

  Widget _buildItemWidget(NavigationBarItem item, bool isSelected) {
    return Container(
      color: item.backgroundColor,
      height: BAR_HEIGHT,
      width: width / items.length,
      child: AnimatedOpacity(
        opacity: isSelected ? 1.0 : 1.0,
        duration: duration,
        curve: curve,
        child: _buildIconWithText(item, isSelected),
      ),
    );
  }
}
