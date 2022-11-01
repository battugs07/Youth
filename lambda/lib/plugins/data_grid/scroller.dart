import 'package:flutter/material.dart';
import 'model/scroll_shadow.dart';
import 'package:provider/provider.dart';

class ScrollAbleTable extends StatefulWidget {
  final List<Widget>? headerWidgets;
  final int itemCount;
  final IndexedWidgetBuilder? rowBuilder;
  final Widget rowSeparatorWidget;
  final double elevation;
  final double? width;
  final Color elevationColor;

  const ScrollAbleTable({
    this.headerWidgets,
    this.rowBuilder,
    this.width,
    this.itemCount = 0,
    this.rowSeparatorWidget = const Divider(
      color: Colors.transparent,
      height: 0.0,
      thickness: 0.0,
    ),
    this.elevation = 3.0,
    this.elevationColor = Colors.black54,
  });

  @override
  State<StatefulWidget> createState() {
    return _ScrollAbleTableState();
  }
}

class _ScrollAbleTableState extends State<ScrollAbleTable> {
  ScrollController _leftHandSideListViewScrollController = ScrollController();
  ScrollController _rightHandSideListViewScrollController = ScrollController();
  ScrollController _rightHorizontalScrollController = ScrollController();
  _SyncScrollControllerManager _syncScroller = _SyncScrollControllerManager();
  ScrollShadowModel _scrollShadowModel = ScrollShadowModel();

  @override
  void initState() {
    super.initState();
    _syncScroller
        .registerScrollController(_leftHandSideListViewScrollController);
    _syncScroller
        .registerScrollController(_rightHandSideListViewScrollController);
    _leftHandSideListViewScrollController.addListener(() {
      _scrollShadowModel.verticalOffset =
          _leftHandSideListViewScrollController.offset;
      setState(() {});
    });
    _rightHorizontalScrollController.addListener(() {
      _scrollShadowModel.horizontalOffset =
          _rightHorizontalScrollController.offset;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _syncScroller
        .unregisterScrollController(_leftHandSideListViewScrollController);
    _syncScroller
        .unregisterScrollController(_rightHandSideListViewScrollController);
    _leftHandSideListViewScrollController.dispose();
    _rightHandSideListViewScrollController.dispose();
    _rightHorizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScrollShadowModel>(
        create: (context) => _scrollShadowModel,
        child: SafeArea(child: LayoutBuilder(
          builder: (context, boxConstraint) {
            return _getParallelListView(
                boxConstraint.maxWidth, boxConstraint.maxHeight);
          },
        )));
  }

  Widget _getParallelListView(double width, double height) {
    return SingleChildScrollView(
      controller: _rightHorizontalScrollController,
      child: Container(
        color: Colors.white,
        child: _getRightSideHeaderScrollColumn(),
        width: widget.width,
      ),
      scrollDirection: Axis.horizontal,
    );
  }

  Widget _getRightSideHeaderScrollColumn() {
    List<Widget> widgetList = <Widget>[];
    //headers
    widgetList.add(Selector<ScrollShadowModel, double>(
        selector: (context, scrollShadowModel) {
          return scrollShadowModel.verticalOffset;
        },
        builder: (context, verticalOffset, child) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: widget.elevationColor.withAlpha(
                      (10 * (_getElevation(verticalOffset) / widget.elevation))
                          .toInt()),
                  blurRadius: 0.0,
                  // has the effect of softening the shadow
                  spreadRadius: 0.0,
                  // has the effect of extending the shadow
                  offset: Offset(
                    0.0, // horizontal, move right 10
                    _getElevation(verticalOffset), // vertical, move down 10
                  ),
                )
              ],
            ),
            child: child,
//                elevation: _getElevation(verticalOffset)
          );
        },
        child: Row(children: widget.headerWidgets!)));
    widgetList.add(
      widget.rowSeparatorWidget,
    );
    //ListView
    widgetList.add(Expanded(
      child: _getScrollColumn(_getRightHandSideListView(),
          this._rightHandSideListViewScrollController),
    ));
    return Column(
      children: widgetList,
    );
  }

  Widget _getScrollColumn(Widget child, ScrollController scrollController) {
    return NotificationListener<ScrollNotification>(
      child: child,
      onNotification: (ScrollNotification scrollInfo) {
        _syncScroller.processNotification(scrollInfo, scrollController);
        return false;
      },
    );
  }

  Widget _getRightHandSideListView() {
    return _getListView(_rightHandSideListViewScrollController,
        widget.rowBuilder!, widget.itemCount);
  }

  Widget _getListView(ScrollController scrollController,
      IndexedWidgetBuilder indexedWidgetBuilder, int itemCount) {
    return ListView.separated(
      controller: scrollController,
      itemBuilder: indexedWidgetBuilder,
      itemCount: itemCount,
      separatorBuilder: (context, index) {
        return widget.rowSeparatorWidget;
      },
    );
  }

  double _getElevation(double offset) {
    double elevation = offset > widget.elevation ? widget.elevation : offset;
    if (elevation >= 0) {
      return elevation;
    }
    return 0.0;
  }
}

class _SyncScrollControllerManager {
  List<ScrollController> _registeredScrollControllers = <ScrollController>[];

  ScrollController _scrollingController = ScrollController();
  bool _scrollingActive = false;

  void registerScrollController(ScrollController controller) {
    _registeredScrollControllers.add(controller);
  }

  void unregisterScrollController(ScrollController controller) {
    _registeredScrollControllers.remove(controller);
  }

  void processNotification(
      ScrollNotification notification, ScrollController sender) {
    if (notification is ScrollStartNotification && !_scrollingActive) {
      _scrollingController = sender;
      _scrollingActive = true;
      return;
    }

    if (identical(sender, _scrollingController) && _scrollingActive) {
      if (notification is ScrollEndNotification) {
        _scrollingController = ScrollController();
        _scrollingActive = false;
        return;
      }

      if (notification is ScrollUpdateNotification) {
        _registeredScrollControllers.forEach((controller) {
          if (!identical(_scrollingController, controller)) {
            if (controller.hasClients) {
              controller.jumpTo(_scrollingController.offset);
            } else {}
          }
        });
        return;
      }
    }
  }
}
