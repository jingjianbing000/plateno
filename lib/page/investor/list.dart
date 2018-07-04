import 'package:flutter/material.dart';

import 'search.dart';
import 'new.dart';
import 'old.dart';

class Choice {
  const Choice({this.title});
  final String title;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '新投资人'),
  const Choice(title: '老投资人'),
];

class InvestorPage extends StatefulWidget {
  @override
  InvestorPageState createState() => new InvestorPageState();
}

class InvestorPageState extends State<InvestorPage> {
  @override
  void initState() {
    super.initState();
  }

  void _searchInvestor() {
    Navigator.of(context).push(new PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
      return new SearchInvestor();
    }));
  }

  void _addInvestor() {}

  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: choices.length,
        child: new Scaffold(
            appBar: new AppBar(
              title: const Text('投资人'),
              centerTitle: true,
              actions: <Widget>[
                new IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addInvestor,
                  tooltip: '新增',
                ),
                new IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _searchInvestor,
                    tooltip: '搜索'),
              ],
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
        children: <Widget>[new NewInvestor(), new OldInvestor()],
        physics: new AlwaysScrollableScrollPhysics());
  }
}
