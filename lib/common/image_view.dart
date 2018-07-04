import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatelessWidget {
  final String imageAddress;

  ImageViewScreen(this.imageAddress);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          leading: new IconButton(
              icon: new Icon(
                Icons.chevron_left,
                size: 30.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Colors.black),
      body: new Container(
          child: new PhotoView(
        imageProvider: new NetworkImage(imageAddress),
        loadingChild: new LoadingText(),
      )),
    );
  }
}

class LoadingText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }
}
