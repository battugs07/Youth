import 'package:flutter/material.dart';

class DynamicFlexibleSpaceBarTitle extends StatefulWidget {
  /// this widget changing bottom padding of title according scrollposition of flexible space

  /// child which will be displayed as title
  @required
  final Widget? child;

  DynamicFlexibleSpaceBarTitle({this.child});

  @override
  State<StatefulWidget> createState() => _DynamicFlexibleSpaceBarTitleState();
}

class _DynamicFlexibleSpaceBarTitleState extends State<DynamicFlexibleSpaceBarTitle> {
  ScrollPosition? _position;
  double _leftPadding = 30;

  /// default padding
  double _bottomPadding = 0;

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _removeListener();
    _addListener();
    super.didChangeDependencies();
  }

  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() => _position?.removeListener(_positionListener);

  void _positionListener() {
    /// when scroll position changes widget will be rebuilt
    final FlexibleSpaceBarSettings? settings = context.dependOnInheritedWidgetOfExactType();
    setState(() {
      _leftPadding = getPadding(settings!.minExtent.toInt(), settings.maxExtent.toInt(), settings.currentExtent.toInt());
      _bottomPadding = getPaddingBottom(settings.minExtent.toInt(), settings.maxExtent.toInt(), settings.currentExtent.toInt());
    });
  }

  double getPadding(int minExtent, int maxExtent, int currentExtent) {
    double onePaddingExtent = (maxExtent - minExtent) / 31;

    /// onePaddingExtent stands for 1 logical pixel of padding, 17 = count of numbers in range from 0 to 16
    /// when currentExtent changes the padding smoothly change
    if (currentExtent >= minExtent && currentExtent <= minExtent + (1 * onePaddingExtent))
      return 29;
    else if (currentExtent > minExtent + (1 * onePaddingExtent) && currentExtent <= minExtent + (2 * onePaddingExtent))
      return 28;
    else if (currentExtent > minExtent + (2 * onePaddingExtent) && currentExtent <= minExtent + (3 * onePaddingExtent))
      return 27;
    else if (currentExtent > minExtent + (3 * onePaddingExtent) && currentExtent <= minExtent + (4 * onePaddingExtent))
      return 26;
    else if (currentExtent > minExtent + (4 * onePaddingExtent) && currentExtent <= minExtent + (5 * onePaddingExtent))
      return 25;
    else if (currentExtent > minExtent + (5 * onePaddingExtent) && currentExtent <= minExtent + (6 * onePaddingExtent))
      return 24;
    else if (currentExtent > minExtent + (6 * onePaddingExtent) && currentExtent <= minExtent + (7 * onePaddingExtent))
      return 23;
    else if (currentExtent > minExtent + (7 * onePaddingExtent) && currentExtent <= minExtent + (8 * onePaddingExtent))
      return 22;
    else if (currentExtent > minExtent + (8 * onePaddingExtent) && currentExtent <= minExtent + (9 * onePaddingExtent))
      return 21;
    else if (currentExtent > minExtent + (9 * onePaddingExtent) && currentExtent <= minExtent + (10 * onePaddingExtent))
      return 20;
    else if (currentExtent > minExtent + (10 * onePaddingExtent) && currentExtent <= minExtent + (11 * onePaddingExtent))
      return 19;
    else if (currentExtent > minExtent + (11 * onePaddingExtent) && currentExtent <= minExtent + (12 * onePaddingExtent))
      return 18;
    else if (currentExtent > minExtent + (12 * onePaddingExtent) && currentExtent <= minExtent + (13 * onePaddingExtent))
      return 17;
    else if (currentExtent > minExtent + (13 * onePaddingExtent) && currentExtent <= minExtent + (14 * onePaddingExtent))
      return 16;
    else if (currentExtent > minExtent + (14 * onePaddingExtent) && currentExtent <= minExtent + (15 * onePaddingExtent))
      return 15;
    else if (currentExtent > minExtent + (15 * onePaddingExtent) && currentExtent <= minExtent + (16 * onePaddingExtent))
      return 14;
    else if (currentExtent > minExtent + (16 * onePaddingExtent) && currentExtent <= minExtent + (17 * onePaddingExtent))
      return 13;
    else if (currentExtent > minExtent + (17 * onePaddingExtent) && currentExtent <= minExtent + (18 * onePaddingExtent))
      return 12;
    else if (currentExtent > minExtent + (18 * onePaddingExtent) && currentExtent <= minExtent + (19 * onePaddingExtent))
      return 11;
    else if (currentExtent > minExtent + (19 * onePaddingExtent) && currentExtent <= minExtent + (20 * onePaddingExtent))
      return 10;
    else if (currentExtent > minExtent + (20 * onePaddingExtent) && currentExtent <= minExtent + (21 * onePaddingExtent))
      return 9;
    else if (currentExtent > minExtent + (21 * onePaddingExtent) && currentExtent <= minExtent + (22 * onePaddingExtent))
      return 8;
    else if (currentExtent > minExtent + (22 * onePaddingExtent) && currentExtent <= minExtent + (23 * onePaddingExtent))
      return 7;
    else if (currentExtent > minExtent + (23 * onePaddingExtent) && currentExtent <= minExtent + (24 * onePaddingExtent))
      return 6;
    else if (currentExtent > minExtent + (24 * onePaddingExtent) && currentExtent <= minExtent + (25 * onePaddingExtent))
      return 5;
    else if (currentExtent > minExtent + (25 * onePaddingExtent) && currentExtent <= minExtent + (26 * onePaddingExtent))
      return 4;
    else if (currentExtent > minExtent + (26 * onePaddingExtent) && currentExtent <= minExtent + (27 * onePaddingExtent))
      return 3;
    else if (currentExtent > minExtent + (27 * onePaddingExtent) && currentExtent <= minExtent + (28 * onePaddingExtent))
      return 2;
    else if (currentExtent > minExtent + (28 * onePaddingExtent) && currentExtent <= minExtent + (29 * onePaddingExtent))
      return 1;
    else if (currentExtent > minExtent + (29 * onePaddingExtent) && currentExtent <= minExtent + (30 * onePaddingExtent))
      return 0;
    else
      return 0;
  }

  double getPaddingBottom(int minExtent, int maxExtent, int currentExtent) {
    double onePaddingExtent = (maxExtent - minExtent) / 20;

    /// onePaddingExtent stands for 1 logical pixel of padding, 17 = count of numbers in range from 0 to 16
    /// when currentExtent changes the padding smoothly change
    if (currentExtent >= minExtent && currentExtent <= minExtent + (1 * onePaddingExtent))
      return 4;
    else if (currentExtent > minExtent + (1 * onePaddingExtent) && currentExtent <= minExtent + (2 * onePaddingExtent))
      return 5;
    else if (currentExtent > minExtent + (2 * onePaddingExtent) && currentExtent <= minExtent + (3 * onePaddingExtent))
      return 6;
    else if (currentExtent > minExtent + (3 * onePaddingExtent) && currentExtent <= minExtent + (4 * onePaddingExtent))
      return 7;
    else if (currentExtent > minExtent + (4 * onePaddingExtent) && currentExtent <= minExtent + (5 * onePaddingExtent))
      return 8;
    else if (currentExtent > minExtent + (5 * onePaddingExtent) && currentExtent <= minExtent + (6 * onePaddingExtent))
      return 9;
    else if (currentExtent > minExtent + (6 * onePaddingExtent) && currentExtent <= minExtent + (7 * onePaddingExtent))
      return 10;
    else if (currentExtent > minExtent + (7 * onePaddingExtent) && currentExtent <= minExtent + (8 * onePaddingExtent))
      return 11;
    else if (currentExtent > minExtent + (8 * onePaddingExtent) && currentExtent <= minExtent + (9 * onePaddingExtent))
      return 12;
    else if (currentExtent > minExtent + (9 * onePaddingExtent) && currentExtent <= minExtent + (10 * onePaddingExtent))
      return 13;
    else if (currentExtent > minExtent + (10 * onePaddingExtent) && currentExtent <= minExtent + (11 * onePaddingExtent))
      return 14;
    else if (currentExtent > minExtent + (11 * onePaddingExtent) && currentExtent <= minExtent + (12 * onePaddingExtent))
      return 15;
    else if (currentExtent > minExtent + (12 * onePaddingExtent) && currentExtent <= minExtent + (13 * onePaddingExtent))
      return 16;
    else if (currentExtent > minExtent + (13 * onePaddingExtent) && currentExtent <= minExtent + (14 * onePaddingExtent))
      return 17;
    else if (currentExtent > minExtent + (14 * onePaddingExtent) && currentExtent <= minExtent + (15 * onePaddingExtent))
      return 18;
    else if (currentExtent > minExtent + (15 * onePaddingExtent) && currentExtent <= minExtent + (16 * onePaddingExtent))
      return 19;
    else if (currentExtent > minExtent + (16 * onePaddingExtent) && currentExtent <= minExtent + (17 * onePaddingExtent))
      return 20;
    else
      return 20;
  }

  @override
  Widget build(BuildContext context) => Padding(padding: EdgeInsets.only(left: _leftPadding, bottom: _bottomPadding), child: widget.child);
}
