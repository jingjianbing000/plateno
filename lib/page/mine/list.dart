import 'package:flutter/material.dart';

import '../../login.dart';
import '../../common/message.dart';
import '../../db/token_helper.dart';

import '../../theme/theme.dart';

class MinePage extends StatefulWidget {
  @override
  MinePageState createState() => new MinePageState();
}

class MinePageState extends State<MinePage> {
  //初始化Token
  TokenHelper helper = new TokenHelper();

  String _name;

  @override
  void initState() {
    super.initState();
    getLoginInfo();
  }

  void getLoginInfo() {
    helper.get().then((res) {
      setState(() {
        _name = res.name;
      });
    });
  }

  @override
  void _logout() {
    TokenHelper helper = new TokenHelper();
    helper.delete().then((flag) {
      if (flag > 0) {
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => new LoginPage()),
            (route) => route == null);
      } else {
        showMessage(context, '退出时发生未知错误，请稍后重试');
      }
    });
  }

  void _navigationToPage(int f) {
    showMessage(context, f.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('更多'),
          centerTitle: true,
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return new ListView(
      children: [
        _buildUserInfo(),
        _buildDelimiter(),
        _buildFeedBack(),
        _buildDelimiter(),
        _buildHelp(),
        _buildDelimiter(),
        _buildVersion(),
        _buildDelimiter(),
        _buildUpdate(),
        _buildDelimiter(),
        _buildExit()
      ],
    );
  }

  Widget _buildDelimiter() {
    return new Container(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      height: 9.0,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[300],
    );
  }

  Widget _buildUserInfo() {
    return new ListTile(
        leading: new Icon(
          Icons.account_circle,
          color: Colors.blue,
        ),
        title: new Container(
            child: _name == null
                ? new Text('获取中...')
                : new Text(_name, style: new TextStyle(color: Colors.grey))),
        onTap: () => _navigationToPage(0),
        trailing: new Icon(
          Icons.build,
          size: 17.0,
        ));
  }

  Widget _buildFeedBack() {
    return new ListTile(
        leading: new Icon(Icons.feedback),
        title: new Text('意见反馈',
            style: new TextStyle(fontSize: 16.0, color: Colors.grey)),
        onTap: () => _navigationToPage(1),
        trailing: new Icon(Icons.chevron_right, size: 18.0));
  }

  Widget _buildHelp() {
    return new ListTile(
        leading: new Icon(Icons.help),
        title: new Text('使用帮助',
            style: new TextStyle(fontSize: 16.0, color: Colors.grey)),
        onTap: () => _navigationToPage(2),
        trailing: new Icon(Icons.chevron_right, size: 18.0));
  }

  Widget _buildVersion() {
    return new ListTile(
        leading: new Icon(Icons.update),
        title: new Text('当前版本',
            style: new TextStyle(fontSize: 16.0, color: Colors.grey)),
        onTap: () => _navigationToPage(3),
        trailing: new Icon(Icons.chevron_right, size: 18.0));
  }

  Widget _buildUpdate() {
    return new ListTile(
        leading: new Icon(Icons.cloud_upload),
        title: new Text('更新记录',
            style: new TextStyle(fontSize: 16.0, color: Colors.grey)),
        onTap: () => _navigationToPage(4),
        trailing: new Icon(Icons.chevron_right, size: 18.0));
  }

  Widget _buildExit() {
    return new Container(
      margin: const EdgeInsets.only(top: 40.0, left: 30.0, right: 30.0),
      height: 40.0,
      child: new RaisedButton(
        onPressed: _logout,
        color: kAndroidTheme.primaryColor,
        child: new Text('退出登录', style: new TextStyle(color: Colors.white)),
      ),
    );
  }
}
