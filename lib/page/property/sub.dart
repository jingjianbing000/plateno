import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'detail.dart';
import 'visit/list.dart';
import 'contract/list.dart';
import 'funds/list.dart';
import 'license/list.dart';
import 'build/detail.dart';

import '../../theme/theme.dart';
import 'choice.dart';

class PropertySub extends StatefulWidget {
  String _params;
  PropertySub(this._params);
  @override
  PropertySubState createState() => new PropertySubState(this._params);
}

class PropertySubState extends State<PropertySub> {
  String _params;
  PropertySubState(this._params);

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
      new PropertyDetail(),
      new VisitListPage(),
      new ContractListPage(),
      new FundsListPage(),
      new LicenseListPage(),
      new BuildDetailPage()
    ], physics: new AlwaysScrollableScrollPhysics());
  }
}
