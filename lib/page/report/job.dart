import 'package:flutter/material.dart';

class JobPage extends StatefulWidget {
  JobPage({Key key}) : super(key: key);

  @override
  JobPageState createState() => new JobPageState();
}

class JobPageState extends State<JobPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new Text('工作报表内容'),
      ),
    );
  }
}
