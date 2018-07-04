import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../config/application.dart';
import '../../config/interface.dart';
import '../../utils/network_util.dart';
import '../../db/token_helper.dart';

import '../../common/message.dart';

class PropertyPage extends StatefulWidget {
  const PropertyPage({Key key}) : super(key: key);

  @override
  PropertyPageState createState() => new PropertyPageState();
}

//排序值枚举
enum propertySortAction { created_time, room_count, province, city }

// TAB切换时，不执行initState() 使用 with AutomaticKeepAliveClientMixin，并设置 bool get wantKeepAlive => true;
class PropertyPageState extends State<PropertyPage> {
  TokenHelper helper = new TokenHelper();
  NetworkUtil util = new NetworkUtil();

  List property = [];

  propertySortAction _sortField = propertySortAction.created_time;

  String _orderType = 'desc';
  String _prevSortField = 'created_time';
  String _sortFieldEx = 'created_time';

  int _page = 1;
  int _total = 1;

  RefreshController _refreshController;

  void addProperty() {
    showMessage(context, '新增物业按钮');
  }

  void searchProperty() {
    showMessage(context, '搜索物业按钮');
  }

  void handleSortAction(propertySortAction action) {
    setState(() {
      switch (action) {
        case propertySortAction.created_time:
          _sortField = propertySortAction.created_time;
          _sortFieldEx = 'created_time';
          break;
        case propertySortAction.room_count:
          _sortField = propertySortAction.room_count;
          _sortFieldEx = 'room_count';
          break;
        case propertySortAction.province:
          _sortField = propertySortAction.province;
          _sortFieldEx = 'province';
          break;
        case propertySortAction.city:
          _sortField = propertySortAction.city;
          _sortFieldEx = 'city';
          break;
      }
    });

    if (_prevSortField == _sortFieldEx) {
      setState(() {
        _orderType = _orderType == 'desc' ? 'asc' : 'desc';
      });
    } else {
      setState(() {
        _orderType = _orderType == 'desc' ? 'desc' : 'asc';
      });
    }

    setState(() {
      property.clear();
    });

    setState(() {
      _prevSortField = _sortFieldEx;
    });

    _refreshController.sendBack(false, RefreshStatus.idle);
    loadData();
  }

  void initState() {
    loadData();
    super.initState();
    _refreshController = new RefreshController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _refreshData() {
    setState(() {
      property.clear();
    });
    loadData();
  }

  void loadData() {
    helper.get().then((res) {
      setState(() {
        _page = 1;
      });

      var body = {
        "order": _orderType,
        "sort": _sortFieldEx,
        "page": _page,
        "token": res.token
      };

      util.post(Interface.getPropertyByConditional(), body, true).then((rs) {
        if (rs.data['success'] == 1) {
          setState(() {
            property = rs.data['res']['item'];
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
        "sort": _sortFieldEx,
        "page": _page,
        "token": res.token
      };

      util.post(Interface.getPropertyByConditional(), body, true).then((rs) {
        if (rs.data['success'] == 1) {
          if (_page <= _total) {
            setState(() {
              property.addAll(rs.data['res']['item']);
            });
          }
        }
      });
    });
  }

  void _navigatorPropertyDetail(index) {
    var params = '{"id": ' +
        property[index]['id'] +
        ', "name": "' +
        property[index]['dev_store_name'] +
        '"}';

    Application.router.navigateTo(context, '/property/detail/$params',
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(appBar: buildAppBar(), body: buildBody());
  }

  Widget buildAppBar() {
    return new AppBar(
        title: new Text('物业'),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.add),
            tooltip: '新增物业',
            onPressed: addProperty,
          ),
          new IconButton(
            icon: const Icon(Icons.search),
            onPressed: searchProperty,
            tooltip: '查找物业',
          ),
          new PopupMenuButton<propertySortAction>(
            onSelected: handleSortAction,
            tooltip: '根据字段对物业排序',
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<propertySortAction>>[
                  const PopupMenuItem(
                    child: const Center(child: const Text('排序')),
                    enabled: false,
                  ),
                  const PopupMenuDivider(),
                  new CheckedPopupMenuItem(
                      value: propertySortAction.created_time,
                      checked: _sortField == propertySortAction.created_time,
                      child: const Text('创建时间')),
                  new CheckedPopupMenuItem(
                      value: propertySortAction.room_count,
                      checked: _sortField == propertySortAction.room_count,
                      child: const Text('房间数')),
                  new CheckedPopupMenuItem(
                      value: propertySortAction.province,
                      checked: _sortField == propertySortAction.province,
                      child: const Text('省份')),
                  new CheckedPopupMenuItem(
                      value: propertySortAction.city,
                      checked: _sortField == propertySortAction.city,
                      child: const Text('城市')),
                ],
          )
        ]);
  }

  Widget buildItem() {
    return new ListView.builder(
      itemCount: property.length,
      itemBuilder: (context, index) {
        String keyName = '';
        if (_sortFieldEx == 'created_time') {
          keyName = property[index]['created_time'];
        } else if (_sortFieldEx == 'room_count') {
          keyName = property[index]['room_count'];
        } else if (_sortFieldEx == 'province') {
          keyName = property[index]['province'];
        } else if (_sortFieldEx == 'city') {
          keyName = property[index]['city'];
        } else {
          keyName = property[index]['address'];
        }

        return new Column(
          children: <Widget>[
            new ListTile(
              title: new Text(property[index]['dev_store_name'],
                  style: new TextStyle(fontSize: 15.0)),
              subtitle: new Text(keyName, style: new TextStyle(fontSize: 12.0)),
              onTap: () {
                _navigatorPropertyDetail(index);
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

  Widget buildBody() {
    return property.length == 0
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
                _refreshData();
              });
            });
  }
}
