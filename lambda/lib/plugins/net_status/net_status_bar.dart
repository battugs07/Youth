import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class NetStatusBar extends StatefulWidget {
  @override
  _NetStatusBarState createState() => _NetStatusBarState();
}

class _NetStatusBarState extends State<NetStatusBar>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Offset>? _offsetFloat;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _offsetFloat = Tween(begin: Offset(0.0, -0.03), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _offsetFloat!.addListener(() {
      setState(() {});
    });

    _controller!.forward();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      debounceDuration: Duration.zero,
      connectivityBuilder: (BuildContext context,
          ConnectivityResult connectivity, Widget child) {
        final bool connected = connectivity != ConnectivityResult.none;
        if (connectivity == ConnectivityResult.none) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AnimatedOpacity(
                opacity: connected ? 0.0 : 1.0,
                duration: Duration(milliseconds: 500),
//                position: _offsetFloat,
                child: Container(
                  width: double.infinity,
                  height: 40,
//                  padding: EdgeInsets.only(top: 44),
                  decoration: BoxDecoration(
                      color: connected ? Color(0xaa00EE44) : Color(0xddEE4400)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Интернэт холболтоо шалгана уу!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        height: 17,
                        width: 17,
                        margin: EdgeInsets.only(left: 10),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          backgroundColor: Color(0xddEE4400),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return child;
      },
      child: Text(''),
    );
  }
}
