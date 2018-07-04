import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import 'theme/theme.dart';

import 'app.dart';
import 'config/interface.dart';
import 'utils/network_util.dart';
import 'common/message.dart';

import 'common/location_info.dart';
import 'common/app_info.dart';
import 'common/device_info.dart';

import 'db/token_helper.dart';
import 'models/token.dart';

import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  //初始化APP，设备，位置
  AppInfo app;
  DeviceInfo device;
  Position position;

  //定义登录
  var loginObj = {};

  //是否加载
  bool _isLoading = false;

  initState() {
    super.initState();
    _getAppInfo();
    _getDeviceInfo();
    _getLocationInfo();
  }

  void _getAppInfo() async {
    app = await AppInfo.getAppInfo();
  }

  void _getDeviceInfo() async {
    device = await DeviceInfo.getDevInfo();
  }

  void _getLocationInfo() async {
    await new Location().getLocation.then((res) async {
      position = await Position.getAddressByLngAndLat(
          res['longitude'], res['latitude']);
    }).catchError((e) {
      throw new Exception(e.toString());
    });
  }

  //提交登录
  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _performLogin();
    }
  }

  void _navigatorMain() {
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => new MyHomePage()),
        (route) => route == null);
  }

  //登录处理流程
  void _performLogin() async {
    NetworkUtil _netUtil = new NetworkUtil();

    var body = {
      "account": loginObj['cardNumber'],
      "password": loginObj['password'],
      "timestamp": new DateTime.now().millisecondsSinceEpoch.toString()
    };

    var _app = {"appid": app.appName, "version": app.version};

    var _extra = {
      "model": device.model,
      "vendor": device.manufacturer,
      "os": device.os,
      "version": device.version,
    };

    var _position = {};

    if (!position.address.isEmpty) {
      _position = {
        "address": position.address,
        "country": position.country,
        "province": position.province,
        "city": position.city,
        "district": position.district,
        'direction': position.direction,
        'latitude': position.loc.lat,
        'longitude': position.loc.lng,
      };
    }

    body['app'] = _app;
    body['extra'] = _extra;
    body['position'] = _position;

    body['sign'] = md5
        .convert(utf8.encode(body['timestamp'] +
            body['account'] +
            body['password'] +
            _app['appid']))
        .toString();

    await _netUtil.post(Interface.login(), body, true).then((res) {
      setState(() => _isLoading = false);
      if (res.data['success'] == 0) {
        showMessage(context, res.data['message']);
      } else {
        TokenHelper helper = new TokenHelper();

        var g = {
          'account': res.data['res']['account'],
          'name': res.data['res']['name'],
          'token': res.data['res']['token'],
          'identity': res.data['res']['identity'],
        };

        helper.save(new Token.map(g)).then((flag) {
          if (flag > 0) {
            _navigatorMain();
          } else {
            showMessage(context, '登录失败，请稍后重试');
          }
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
          key: scaffoldKey,
          appBar: new AppBar(
              title: new Center(
            child: new Text('登录'),
          )),
          body: new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Form(
              key: formKey,
              child: new Column(
                children: [
                  const SizedBox(height: 20.0),
                  new TextFormField(
                      decoration: new InputDecoration(
                          icon: new Icon(Icons.account_circle),
                          labelText: '卡号',
                          hintText: '请输入卡号'),
                      keyboardType: TextInputType.number,
                      validator: (val) => val.isEmpty ? '卡号不能为空' : null,
                      onSaved: (val) => loginObj['cardNumber'] = val),
                  const SizedBox(height: 20.0),
                  new TextFormField(
                    decoration: new InputDecoration(
                        icon: new Icon(Icons.lock_outline),
                        labelText: '密码',
                        hintText: '请输入密码'),
                    validator: (val) => val.isEmpty ? '密码不能为空' : null,
                    onSaved: (val) => loginObj['password'] = val,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24.0),
                  _isLoading
                      ? new CircularProgressIndicator()
                      : new Container(
                          width: MediaQuery.of(context).size.width,
                          height: 38.0,
                          margin:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: new RaisedButton(
                            onPressed: _submit,
                            child: new Text(
                              '登录',
                              style: new TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ));
  }
}
