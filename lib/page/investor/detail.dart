import 'dart:convert';
import 'package:flutter/material.dart';

class InvestorDetailTabPage extends StatefulWidget {
  String _params;
  InvestorDetailTabPage(this._params);

  @override
  InvestorDetailTabPageState createState() =>
      new InvestorDetailTabPageState(this._params);
}

class InvestorDetailTabPageState extends State<InvestorDetailTabPage> {
  String _params;
  InvestorDetailTabPageState(this._params);

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(child: new Text('投资人详情')),
      persistentFooterButtons: <Widget>[
        new FlatButton(
            onPressed: null, textColor: Colors.blue, child: new Text('编辑投资人')),
      ],
    );
  }
}
