import 'package:flutter/material.dart';

void showMessage(BuildContext context, String text) {
  showDialog<Null>(
      context: context,
      barrierDismissible: false, //是否可以点击遮罩区外关闭对话框
      child: new AlertDialog(
          title: new Text("提示"),
          content: new Text(text),
          actions: <Widget>[
            new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('确定'))
          ])); //
}
