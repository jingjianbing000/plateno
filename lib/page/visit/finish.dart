import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import '../../config/application.dart';
import '../../config/interface.dart';
import '../../utils/network_util.dart';
import '../../db/token_helper.dart';

class finishVisit extends StatefulWidget {
  String _params;
  finishVisit(this._params);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new finishVisitState(this._params);
  }
}

class finishVisitState extends State<finishVisit> {
  String _params;
  finishVisitState(this._params);

  //保存路由传递过来的参数
  Map params;

  //保存拜访详情
  List detail = [];

  TokenHelper helper = new TokenHelper();
  NetworkUtil util = new NetworkUtil();

  @override
  void initState() {
    super.initState();
    params = JSON.decode(this._params);
  }

  void loadData() {
    helper.get().then((res) {
      util
          .post(Interface.getVisitDetail(),
              {"token": res.token, "id": params['id']}, true)
          .then((json) {
        if (json.data['success'] == 1) {
          setState(() {
            detail = json.data['res'];
          });
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Center(
      child: new Text('完成拜访'),
    ));
  }
}
