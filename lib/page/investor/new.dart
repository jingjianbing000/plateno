import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../config/application.dart';
import '../../config/interface.dart';
import '../../utils/network_util.dart';
import '../../db/token_helper.dart';

class NewInvestor extends StatefulWidget {
  @override
  NewInvestorPageState createState() => new NewInvestorPageState();
}

class NewInvestorPageState extends State<NewInvestor> {
  //投资人集合
  List investors = [];

  String _sortField = 'created_time';
  String _orderType = 'desc';

  //当前页
  int _page = 1;

  //总页数
  int _total = 1;

  RefreshController _refreshController;

  //初始化Token，网络组件
  TokenHelper helper = new TokenHelper();
  NetworkUtil util = new NetworkUtil();

  @override
  void initState() {
    loadData();
    super.initState();
    _refreshController = new RefreshController();
  }

  void loadData() {
    helper.get().then((res) {
      setState(() {
        _page = 1;
      });

      var body = {
        "order": _orderType,
        "sort": _sortField,
        "page": _page,
        "token": res.token,
        "type": 1
      };

      util.post(Interface.getInvestorByType(), body, true).then((rs) {
        if (rs.data['success'] == 1) {
          setState(() {
            investors.clear();
            investors = rs.data['res']['items'];
            _total = rs.data['res']['paginate']['total_page'];
          });
        }
      });
    });
  }

  void loadMore() {
    helper.get().then((res) {
      setState(() {
        _page += 1;
      });

      var body = {
        "order": _orderType,
        "sort": _sortField,
        "page": _page,
        "token": res.token,
        "type": 1
      };

      util.post(Interface.getInvestorByType(), body, true).then((rs) {
        if (rs.data['success'] == 1) {
          if (_page <= _total) {
            setState(() {
              investors.addAll(rs.data['res']['items']);
            });
          }
        }
      });
    });
  }

  void _navigatorInvestorDetail(index) {
    var params = '{"id": ' +
        investors[index]['id'] +
        ', "name": "' +
        investors[index]['inv_name'] +
        '"}';

    Application.router.navigateTo(context, '/investor/detail/$params',
        transition: TransitionType.inFromRight);
  }

  Widget footerCreate(BuildContext context, int mode) {
    return new ClassicIndicator(
      mode: mode,
      idleIcon: new Container(),
      idleText: '',
      refreshingText: '数据加载中...',
      noDataText: '没有更多数据',
    );
  }

  Widget buildItem() {
    return new ListView.builder(
      itemCount: investors.length,
      itemBuilder: (context, index) {
        return new Column(
          children: <Widget>[
            new ListTile(
              title: new Text(investors[index]['inv_name'],
                  style: new TextStyle(fontSize: 15.0)),
              subtitle: new Text(investors[index]['phone'],
                  style: new TextStyle(fontSize: 12.0)),
              onTap: () {
                _navigatorInvestorDetail(index);
              },
              dense: false,
            ),
            new Divider(
              height: 2.0,
            )
          ],
        );
      },
    );
  }

  @override
  build(BuildContext context) {
    return investors.length == 0
        ? new Center(child: new CircularProgressIndicator())
        : new RefreshIndicator(
            child: new SmartRefresher(
                enablePullDown: false,
                enablePullUp: true,
                enableOverScroll: false,
                footerBuilder: footerCreate,
                controller: _refreshController,
                onRefresh: (up) {
                  if (up == false) {
                    new Future.delayed(const Duration(milliseconds: 200))
                        .then((val) {
                      _refreshController.sendBack(
                          false,
                          _page > _total
                              ? RefreshStatus.noMore
                              : RefreshStatus.idle);
                      if (_page <= _total) {
                        loadMore();
                      }
                    });
                  }
                },
                child: buildItem()),
            onRefresh: () {
              return new Future.delayed(const Duration(milliseconds: 200))
                  .then((val) {
                _refreshController.sendBack(false, RefreshStatus.idle);
                loadData();
              });
            });
  }
}
