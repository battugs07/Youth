import 'dart:async';

import 'package:flutter/material.dart';

const Duration _kBottomSheetDuration = const Duration(milliseconds: 200);

class ModalBottomSheetLayout extends SingleChildLayoutDelegate {
  ModalBottomSheetLayout(this.progress, this.bottomInset);

  final double progress;
  final double bottomInset;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return new BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
        minHeight: 0.0,
        maxHeight: constraints.maxHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return new Offset(
        0.0, size.height - bottomInset - childSize.height * progress);
  }

  @override
  bool shouldRelayout(ModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress ||
        bottomInset != oldDelegate.bottomInset;
  }
}

class _ModalBottomSheet<T> extends StatefulWidget {
  const _ModalBottomSheet({Key? key, this.route}) : super(key: key);

  final _ModalBottomSheetRoute<T>? route;

  @override
  _ModalBottomSheetState<T> createState() => new _ModalBottomSheetState<T>();
}

class _ModalBottomSheetState<T> extends State<_ModalBottomSheet<T>> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.route!.dismissOnTap! ? () => Navigator.pop(context) : null,
      child: AnimatedBuilder(
        animation: widget.route!.animation!,
        builder: (BuildContext context, Widget? child) {
          double bottomInset = widget.route!.resizeToAvoidBottomPadding!
              ? MediaQuery.of(context).viewInsets.bottom
              : 0.0;
          return ClipRect(
            child: CustomSingleChildLayout(
              delegate: ModalBottomSheetLayout(
                  widget.route!.animation!.value, bottomInset),
              child: BottomSheet(
                  animationController: widget.route!._animationController,
                  onClosing: () => Navigator.pop(context),
                  elevation: 50,
                  builder: widget.route!.builder!),
            ),
          );
        },
      ),
    );
  }
}

class _ModalBottomSheetRoute<T> extends PopupRoute<T> {
  _ModalBottomSheetRoute({
    this.builder,
    this.theme,
    required this.barrierLabel,
    RouteSettings? settings,
    this.resizeToAvoidBottomPadding,
    this.dismissOnTap,
  }) : super(settings: settings);

  final WidgetBuilder? builder;
  final ThemeData? theme;
  final bool? resizeToAvoidBottomPadding;
  final bool? dismissOnTap;

  @override
  Duration get transitionDuration => _kBottomSheetDuration;

  @override
  bool get barrierDismissible => true;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator!.overlay!);
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget bottomSheet = new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: new _ModalBottomSheet<T>(route: this),
    );
    if (theme != null)
      bottomSheet = new Theme(data: theme!, child: bottomSheet);
    return bottomSheet;
  }
}

Future<T?> showBottomModal<T>({
  BuildContext? context,
  WidgetBuilder? builder,
  bool dismissOnTap: false,
  bool resizeToAvoidBottomPadding: true,
}) {
  assert(context != null);
  assert(builder != null);
  return Navigator.push(
      context!,
      _ModalBottomSheetRoute<T>(
        builder: builder,
        theme: Theme.of(context),
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        resizeToAvoidBottomPadding: resizeToAvoidBottomPadding,
        dismissOnTap: dismissOnTap,
      ));
}
