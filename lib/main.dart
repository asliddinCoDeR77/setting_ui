import 'package:flutter/material.dart';
import 'package:perfect_settings_ui/views/screen/home_screen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomeScreen(
              onThemeModeChanged: (_) {},
            ),
      },
    );
  }
}
