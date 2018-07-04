import 'package:flutter/material.dart';

class RevenuePage extends StatefulWidget {
  RevenuePage({Key key}) : super(key: key);

  @override
  RevenuePageState createState() => new RevenuePageState();
}

class RevenuePageState extends State<RevenuePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new Text('营收报表内容'),
      ),
    );
  }
}
