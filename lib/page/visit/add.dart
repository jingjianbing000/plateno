import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import '../../config/application.dart';
import '../../config/interface.dart';
import '../../utils/network_util.dart';
import '../../db/token_helper.dart';

class addVisitPage extends StatefulWidget {
  String _params;
  addVisitPage(this._params);

  @override
  State<StatefulWidget> createState() {
    return new addVisitPageState(this._params);
  }
}

class addVisitPageState extends State<addVisitPage> {
  String _params;
  addVisitPageState(this._params);

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text('临时拜访'),
      ),
    );
  }
}
