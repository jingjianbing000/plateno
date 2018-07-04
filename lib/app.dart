import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter/foundation.dart';

import 'page/index/list.dart';
import 'page/property/list.dart';
import 'page/investor/list.dart';
import 'page/report/detail.dart';
import 'page/mine/list.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  PageController pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    pageController = new PageController(initialPage: this._page);
  }

  void onTap(int index) {
    onPageChanged(index);

    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    if (this._page != page) {
      setState(() {
        this._page = page;
      });
    }
  }

  changeStatusColor() async {
    try {
      await FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
            title: new Text('提示'),
            content: new Text('确实要退出开店通APP吗？'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('取消'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('确定'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
            body: new PageView(
                children: <Widget>[
                  IndexPage(),
                  PropertyPage(),
                  InvestorPage(),
                  ReportPage(),
                  MinePage()
                ],
                controller: pageController,
                physics: new NeverScrollableScrollPhysics()),
            bottomNavigationBar: _buildBottomNavBar()));
  }

  Widget _buildBottomNavBar() {
    return new BottomNavigationBar(items: <BottomNavigationBarItem>[
      new BottomNavigationBarItem(
        icon: new Icon(Icons.home),
        title: new Text('首页'),
        backgroundColor: Colors.grey,
      ),
      new BottomNavigationBarItem(
        icon: new Icon(Icons.save),
        title: new Text('物业'),
        backgroundColor: Colors.grey,
      ),
      new BottomNavigationBarItem(
        icon: new Icon(Icons.people),
        title: new Text('投资人'),
        backgroundColor: Colors.grey,
      ),
      new BottomNavigationBarItem(
        icon: new Icon(Icons.assessment),
        title: new Text('报表'),
        backgroundColor: Colors.grey,
      ),
      new BottomNavigationBarItem(
        icon: new Icon(Icons.format_list_bulleted),
        title: new Text('更多'),
        backgroundColor: Colors.grey,
      )
    ], type: BottomNavigationBarType.fixed, onTap: onTap, currentIndex: _page);
  }
}
