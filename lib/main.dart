import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/home_page.dart';
import 'package:flutter_campus_connected/pages/login_signup_page.dart';
import 'package:flutter_campus_connected/pages/signup_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'flutter',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new LoginSignUpPage(),
        '/home': (BuildContext context) => new HomePage(),
        '/signup': (BuildContext context) => new SignUpPage(),
      },
      theme: new ThemeData(primarySwatch: Colors.red),
      home: new LoginSignUpPage(),
    );
  }
}
