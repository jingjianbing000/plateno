import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'job.dart';
import 'revenue.dart';

class ReportPage extends StatefulWidget {
  ReportPage({Key key}) : super(key: key);

  @override
  ReportPageState createState() => new ReportPageState();
}

class Choice {
  const Choice({this.title});
  final String title;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '营收报表'),
  const Choice(title: '工作报表'),
];

class ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: choices.length,
        child: new Scaffold(
            appBar: new AppBar(
              title: const Text('报表'),
              centerTitle: true,
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
    return new TabBarView(
      children: <Widget>[new RevenuePage(), new JobPage()],
      physics: new AlwaysScrollableScrollPhysics(),
    );
  }
}
