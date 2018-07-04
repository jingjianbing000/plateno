import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import '../../config/application.dart';
import '../../config/interface.dart';
import '../../utils/network_util.dart';
import '../../db/token_helper.dart';

enum visitSortAction {
  wait,
  finish,
  expired,
}

class InvestorVisitTabPage extends StatefulWidget {
  String _params;
  InvestorVisitTabPage(this._params);

  @override
  InvestorVisitTabPageState createState() =>
      new InvestorVisitTabPageState(this._params);
}

class InvestorVisitTabPageState extends State<InvestorVisitTabPage> {
  //接收上页参数
  String _params;
  InvestorVisitTabPageState(this._params);

  Map detail;

  visitSortAction _sortField = visitSortAction.wait;
  String _sortFieldEx = 'wait';

  //初始化网络请求组件
  TokenHelper helper = new TokenHelper();
  NetworkUtil util = new NetworkUtil();

  List visits = [];

  @override
  void initState() {
    detail = JSON.decode(this._params);
    loadData();
    super.initState();
  }

  void loadData() {
    helper.get().then((res) {
      util
          .post(
              Interface.getAssociatedVisit(),
              {
                "investorId": detail['id'],
                "token": res.token,
                "status": _sortFieldEx,
              },
              true)
          .then((rs) {
        if (rs.data['success'] == 1) {
          setState(() {
            visits.clear();
            visits = rs.data['res'];
          });
        }
      });
    });
  }

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    setState(() {
      visits.clear();
    });

    new Timer(const Duration(seconds: 1), () {
      completer.complete(null);
    });
    return completer.future.then((_) {
      loadData();
    });
  }

  void handleSortAction(visitSortAction action) {
    setState(() {
      switch (action) {
        case visitSortAction.wait:
          _sortField = visitSortAction.wait;
          _sortFieldEx = 'wait';
          break;
        case visitSortAction.finish:
          _sortField = visitSortAction.finish;
          _sortFieldEx = 'finish';
          break;
        case visitSortAction.expired:
          _sortField = visitSortAction.expired;
          _sortFieldEx = 'expired';
          break;
      }
    });

    visits.clear();
    loadData();
  }

  void goToVisit(visit) {
    var params =
        '{"id": ' + visit['id'] + ', "name": "' + visit['inv_name'] + '"}';

    String url;

    if (visit['flag'] == 1) {
      url = '/visit/finish/$params';
    } else {
      url = '/visit/detail/$params';
    }

    Application.router
        .navigateTo(context, url, transition: TransitionType.inFromRight);
  }

  void addVisit(int flag) {
    var params = '{"id": ' +
        detail['id'].toString() +
        ',"name":"' +
        detail['name'] +
        '","type":2}';

    String url;

    if (flag == 1) {
      url = '/visit/plan/$params';
    } else {
      url = '/visit/add/$params';
    }

    Application.router
        .navigateTo(context, url, transition: TransitionType.inFromRight);
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      body: new RefreshIndicator(
        child: new ListView.builder(
          itemCount: visits.length,
          itemBuilder: (context, index) {
            String _stepName = visits[index]['stepName'];
            if (_stepName == null) {
              _stepName = '';
            }
            return new Column(children: <Widget>[
              new ListTile(
                  onTap: () {
                    goToVisit(visits[index]);
                  },
                  isThreeLine: false,
                  title: new Text(visits[index]['visitTypeName'],
                      style: new TextStyle(fontSize: 14.0)),
                  subtitle: new Text(
                    visits[index]['actualDate'],
                    style: new TextStyle(fontSize: 12.0),
                  ),
                  trailing: new Text(_stepName,
                      style: new TextStyle(fontSize: 12.0))),
              new Divider(
                height: 2.0,
              )
            ]);
          },
        ),
        onRefresh: _handleRefresh,
      ),
      persistentFooterButtons: <Widget>[
        new FlatButton(
            onPressed: () {
              addVisit(1);
            },
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: new Text('新增计划')),
        new FlatButton(
            onPressed: () {
              addVisit(2);
            },
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: new Text('临时拜访')),
        new PopupMenuButton<visitSortAction>(
          onSelected: handleSortAction,
          icon: new Icon(Icons.format_list_numbered, color: Colors.blue),
          itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<visitSortAction>>[
                const PopupMenuItem(
                  child: const Center(child: const Text('拜访状态')),
                  enabled: false,
                ),
                const PopupMenuDivider(),
                new CheckedPopupMenuItem(
                    value: visitSortAction.wait,
                    checked: _sortField == visitSortAction.wait,
                    child: const Text('待拜访')),
                new CheckedPopupMenuItem(
                    value: visitSortAction.finish,
                    checked: _sortField == visitSortAction.finish,
                    child: const Text('已完成')),
                new CheckedPopupMenuItem(
                    value: visitSortAction.expired,
                    checked: _sortField == visitSortAction.expired,
                    child: const Text('过期未拜访')),
              ],
        )
      ],
    );
  }
}
