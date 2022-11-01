import 'package:flutter/material.dart' hide Router;
import 'package:flutter/services.dart';
import 'package:lambda/modules/gcm/notify.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:lambda/modules/agent/agent_state.dart';
import 'package:provider/provider.dart';
import 'core/constants/values.dart';
import 'core/viewmodels/user_model.dart';
import 'locator.dart';
import 'router.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Notify fcm = new Notify();
  late BuildContext ctx;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setupLocator();

    NetworkUtil network = locator<NetworkUtil>();
    network.initNetwork(baseUrl);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // fcm.getPermission(baseUrl, ctx);
      // fcm.configFcm();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      ctx = context;
    });
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserModel()),
        ChangeNotifierProvider(create: (_) => AgentState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ZEUS Signal',
        theme: ThemeData(
          fontFamily: "Nunito",
          //fontFamily: "Roboto-Condensed",
          canvasColor: Color(0xfff2f3fa),
        ),
        initialRoute: '/',
        routes: Router.routes,
      ),
    );
  }
}
