import 'package:flutter/material.dart';

import '../../common/message.dart';

class PropertyDetail extends StatefulWidget {
  @override
  PropertyDetailState createState() => new PropertyDetailState();
}

class PropertyDetailState extends State<PropertyDetail> {
  void initState() {
    super.initState();
  }

  void _showMsg() {
    showMessage(super.context, '12222222');
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(child: new Text('物业详细内容')),
      floatingActionButton: new FloatingActionButton(onPressed: (() {
        return _showMsg();
      })),
    );
  }
}
