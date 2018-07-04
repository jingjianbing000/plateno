import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../config/interface.dart';
import '../../utils/network_util.dart';
import '../../db/token_helper.dart';

import '../../theme/theme.dart';
import '../../common/message.dart';

class planVisitPage extends StatefulWidget {
  String _params;
  planVisitPage(this._params);

  @override
  State<StatefulWidget> createState() {
    return new planVisitPageState(this._params);
  }
}

class planVisitPageState extends State<planVisitPage> {
  String _params;
  planVisitPageState(this._params);

  Map params;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _visitType;
  DateTime _dateTime;
  String _content;

  bool _isLoading = false;

  TokenHelper helper = new TokenHelper();
  NetworkUtil util = new NetworkUtil();

  @override
  void initState() {
    super.initState();
  }

  Future<Null> _selectDate() async {
    final DateTime _picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now().add(new Duration(days: 1)),
      firstDate: new DateTime.now().subtract(new Duration(days: 0)),
      lastDate: new DateTime.now().add(new Duration(days: 90)),
    );

    if (_picked != null) {
      setState(() {
        _dateTime = _picked;
      });
    }
  }

  void submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      save();
    }
  }

  void save() {
    setState(() {
      _isLoading = false;
    });

    if (_visitType == null) {
      showMessage(context, '拜访方式未选择');
    } else if (_dateTime == null) {
      showMessage(context, '拜访日期未选择');
    } else if (_content.length == 0) {
      showMessage(context, '拜访内容未填写');
    } else {
      helper.get().then((res) {
        util
            .post(
                Interface.postVisit(),
                {
                  "token": res.token,
                  "visit_time": _dateTime.toString().substring(0, 10),
                  "content": _content,
                  "object_id": params['id'],
                  "category": params['type'],
                  "step_id": 0,
                  "visit_type": 1,
                  "type_of_visit": 1,
                },
                true)
            .then((rs) {
          if (rs.data['success'] == 1) {
            Navigator.pop(context);
          } else {
            showMessage(context, rs.data['message']);
          }
        });
      });
    }
  }

  Widget build(BuildContext context) {
    params = JSON.decode(this._params);

    return new MaterialApp(
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kAndroidTheme,
      key: scaffoldKey,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('新增计划'),
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
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return new Container(
      child: new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Container(
                  color: Colors.grey[300],
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 35.0, top: 15.0),
                  height: 50.0,
                  child: new Text('客户名称：' + params['name'],
                      style: new TextStyle(fontSize: 13.0),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.start)),
              new Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 35.0, top: 10.0),
                  height: 40.0,
                  child: new Row(
                    children: <Widget>[
                      new Text(
                        '拜访方式：',
                        textAlign: TextAlign.start,
                      ),
                      new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                        value: _visitType,
                        hint: const Text('选择'),
                        style:
                            new TextStyle(fontSize: 13.0, color: Colors.black),
                        onChanged: (String newValue) {
                          setState(() {
                            _visitType = newValue;
                          });
                        },
                        items: <String>['见面拜访', '电话拜访', '微信拜访', '其他拜访']
                            .map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                      ))
                    ],
                  )),
              new Divider(),
              new Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 35.0),
                  height: 35.0,
                  child: new Row(children: <Widget>[
                    new Text(
                      '拜访日期：',
                      textAlign: TextAlign.start,
                    ),
                    new Container(
                      child: new Row(
                        children: <Widget>[
                          _dateTime == null
                              ? new Text('')
                              : new Text(_dateTime.toString().substring(0, 10)),
                          new IconButton(
                              padding: const EdgeInsets.only(bottom: 3.0),
                              icon: new Icon(Icons.date_range),
                              onPressed: _selectDate)
                        ],
                      ),
                    )
                  ])),
              new Divider(),
              new Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 35.0),
                height: 90.0,
                child: new Row(
                  children: <Widget>[
                    new Text(
                      '拜访内容：',
                      textAlign: TextAlign.start,
                    ),
                    new Container(
                      width: MediaQuery.of(context).size.width / 1.6,
                      padding: const EdgeInsets.only(top: 5.0),
                      height: 90.0,
                      child: new Column(
                        children: <Widget>[
                          new TextFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            maxLines: 4,
                            onSaved: (val) {
                              setState(() {
                                _content = val;
                              });
                            },
                            style: new TextStyle(
                                fontSize: 13.0, color: Colors.black),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              new Divider(),
              _isLoading == false
                  ? new Container(
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 30.0, right: 30.0),
                      width: MediaQuery.of(context).size.width,
                      child: new RaisedButton(
                        onPressed: submit,
                        color: kAndroidTheme.primaryColor,
                        child: new Text('提交计划',
                            style: new TextStyle(color: Colors.white)),
                      ),
                    )
                  : new CircularProgressIndicator(),
            ],
          )),
    );
  }
}
