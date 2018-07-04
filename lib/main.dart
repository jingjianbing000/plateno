import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'splash.dart';

void main() => runApp(new MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
      home: new SplashPage(),
    ));
