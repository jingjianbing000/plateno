import 'package:flutter/material.dart';

class SearchInvestor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("搜索"),
        centerTitle: true,
      ),
      body: new Center(
        child: new Text(
          "搜索页内容",
          style: new TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }
}
