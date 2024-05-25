import 'package:flutter/material.dart';
import 'package:perfect_settings_ui/views/screen/home_screen.dart';

import 'views/widgets/applocalizitions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ru', ''),
        Locale('uz', ''),
      ],
      home: HomeScreen(
        onThemeModeChanged: (_) {},
        onLocaleChanged: _setLocale,
      ),
    );
  }
}
