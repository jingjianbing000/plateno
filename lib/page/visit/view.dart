import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../config/interface.dart';
import '../../utils/network_util.dart';
import '../../db/token_helper.dart';

import '../../common/image_view.dart';

class viewVisit extends StatefulWidget {
  String _params;
  viewVisit(this._params);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new viewVisitState(this._params);
  }
}

class viewVisitState extends State<viewVisit> {
  String _params;
  viewVisitState(this._params);

  //保存路由传递过来的参数
  Map params;

  //保存拜访详情
  Map detail;

  List images = [];
  int imageLimit = 6;

  TokenHelper helper = new TokenHelper();
  NetworkUtil util = new NetworkUtil();

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  void loadData() {
    params = JSON.decode(this._params);
    helper.get().then((res) {
      util
          .post(Interface.getVisitDetail(),
              {"token": res.token, "id": params['id']}, true)
          .then((json) {
        if (json.data['success'] == 1) {
          setState(() {
            detail = json.data['res'];
            images = json.data['res']['images'];
          });
        }
      });
    });
  }

  void previewImage(String imgUrl) {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new ImageViewScreen(imgUrl)),
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('拜访详情'),
          centerTitle: true,
          leading: new IconButton(
              icon: new Icon(
                Icons.chevron_left,
                size: 30.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: buildVisitDetail());
  }

  Widget buildVisitDetail() {
    if (detail != null) {
      return new Container(
        child: new ListView(
          children: <Widget>[
            buildVisitAddress(),
            buildVisitBody(),
            buildImageText(),
            buildImages(),
            new Container(
              padding: const EdgeInsets.only(bottom: 15.0),
            )
          ],
        ),
      );
    }
  }

  Widget buildVisitAddress() {
    return new Container(
      color: Colors.grey[300],
      child: new ListTile(
        title: new Text(
          '拜访地址：' + detail['address'],
          style: new TextStyle(fontSize: 13.0),
        ),
      ),
    );
  }

  Widget buildVisitBody() {
    String name = detail['category'] == 1
        ? detail['object']['dev_store_name']
        : detail['object']['inv_name'];

    return new Container(
        child: new Column(children: <Widget>[
      buildVisitBodyWidget('客户名称', name),
      new Divider(),
      buildCustomerBody(),
      buildVisitBodyWidget('拜访方式', detail['typeOfVisit']),
      new Divider(),
      buildVisitBodyWidget('拜访内容', detail['content']),
      new Divider(),
      buildVisitBodyWidget('开发阶段', detail['stepName']),
      new Divider(),
      buildVisitBodyWidget('备注', detail['remark']),
      new Divider(),
      buildVisitBodyWidget('拜访状态', detail['visitStatus']),
      new Divider(),
      buildVisitBodyWidget('拜访时间', detail['visited_date']),
      buildDelimiter(),
    ]));
  }

  Widget buildImageText() {
    return new Container(
        child: new Column(children: <Widget>[
      new Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 15.0),
          padding: const EdgeInsets.only(top: 14.0),
          height: 35.0,
          child: new Text(
              '图片 （' +
                  images.length.toString() +
                  ' / ' +
                  imageLimit.toString() +
                  '）',
              style: new TextStyle(fontSize: 13.0),
              textAlign: TextAlign.start)),
      new Divider(),
    ]));
  }

  Widget buildImages() {
    return new Container(
        child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 10.0,
            shrinkWrap: true,
            children: List.generate(images.length, (index) {
              return GestureDetector(
                child: CachedNetworkImage(
                  width: 100.0,
                  height: 100.0,
                  imageUrl: images[index]['url'],
                  placeholder: new CircularProgressIndicator(),
                  fadeOutDuration: new Duration(seconds: 1),
                  fadeInDuration: new Duration(seconds: 3),
                ),
                onTap: () {
                  previewImage(images[index]['url']);
                },
              );
            })));
  }

  Widget buildVisitBodyWidget(String key, String name) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 15.0),
        padding: const EdgeInsets.only(top: 5.0),
        height: 30.0,
        child: new Text(key + '：' + name,
            style: new TextStyle(fontSize: 13.0),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.start));
  }

  Widget buildCustomerBody() {
    if (detail['category'] == 2) {
      return new Container(
          child: new Column(
        children: <Widget>[
          buildVisitBodyWidget('客户级别', detail['object']['customerLevelName']),
          new Divider(),
        ],
      ));
    } else {
      return new Container();
    }
  }

  Widget buildDelimiter() {
    return new Container(
      // padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
      margin: const EdgeInsets.only(top: 10.0),
      height: 9.0,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[300],
    );
  }
}
