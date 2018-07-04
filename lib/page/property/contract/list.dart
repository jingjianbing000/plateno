import 'package:flutter/material.dart';

class ContractListPage extends StatefulWidget {
  @override
  ContractListPageState createState() => new ContractListPageState();
}

class ContractListPageState extends State<ContractListPage> {
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(child: new Text('合同列表')),
    );
  }
}
