import 'package:flutter/material.dart';
import './pages/splash_screen.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Campus-Connected',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.red,
        ),
        home: new ImageSplashScreen()
    );
  }
}
