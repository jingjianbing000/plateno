import 'dart:convert';

import 'package:flutter/material.dart';

import 'detail.dart';
import '../visit/listByInvestor.dart';

class Choice {
  const Choice({this.title});
  final String title;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '投资人'),
  const Choice(title: '拜访'),
];

class InvestorDetailPage extends StatefulWidget {
  String _params;
  InvestorDetailPage(this._params);
  @override
  InvestorDetailPageState createState() =>
      new InvestorDetailPageState(this._params);
}

class InvestorDetailPageState extends State<InvestorDetailPage> {
  String _params;
  InvestorDetailPageState(this._params);

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    Map detail = JSON.decode(this._params);
    return new DefaultTabController(
        length: choices.length,
        child: new Scaffold(
            appBar: new AppBar(
              title: new Text(
                detail['name'],
                style: new TextStyle(fontSize: 17.0),
              ),
              centerTitle: true,
              leading: new IconButton(
                  icon: new Icon(
                    Icons.chevron_left,
                    size: 30.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              bottom: new TabBar(
                isScrollable: false,
                tabs: choices.map((Choice choice) {
                  return new Tab(text: choice.title);
                }).toList(),
              ),
            ),
            body: _buildBody()));
  }

  Widget _buildBody() {
    return new TabBarView(children: <Widget>[
      new InvestorDetailTabPage(this._params),
      new InvestorVisitTabPage(this._params),
    ], physics: new AlwaysScrollableScrollPhysics());
  }
}
