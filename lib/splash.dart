import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'package:flutter/foundation.dart';
import 'package:fluro/fluro.dart';

//加载主题
import 'theme/theme.dart';

//加载路由
import 'config/application.dart';
import 'config/routes.dart';

import 'login.dart';
import 'app.dart';

import 'db/token_helper.dart';
import 'utils/network_util.dart';
import 'config/interface.dart';
import 'common/message.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  //初始化路由
  SplashPageState() {
    final router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  void changeStatusColor() async {
    try {
      await FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    } catch (e) {}
  }

  initState() {
    super.initState();
    changeStatusColor();
    _checkToken();
  }

  void _navigatorLogin() {
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => new LoginPage()),
        (route) => route == null);
  }

  void _navigatorMain() {
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => new MyHomePage()),
        (route) => route == null);
  }

  void _checkToken() async {
    TokenHelper helper = new TokenHelper();
    await helper.get().then((res) {
      if (res == null) {
        _navigatorLogin();
      } else {
        NetworkUtil _netUtil = new NetworkUtil();
        _netUtil
            .post(Interface.checkToken(), {"token": res.token}, true)
            .then((res) {
          if (res.data['success'] == 0) {
            _navigatorLogin();
          } else {
            _navigatorMain();
          }
        }).catchError((e) {
          showMessage(context, e.toString());
        });
      }
    }).catchError((e) {
      showMessage(context, e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kAndroidTheme,
      home: new Scaffold(
          body: new Center(child: new CircularProgressIndicator())),
      onGenerateRoute: Application.router.generator,
    );
  }
}
