import 'package:flutter/material.dart';

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.deepOrange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kAndroidTheme = new ThemeData(
  primaryIconTheme: const IconThemeData(color: Colors.white),
  primarySwatch: Colors.deepOrange,
  primaryColor: Colors.deepOrange,
  primaryColorBrightness: Brightness.dark,
  buttonColor: Colors.deepOrange,
);
