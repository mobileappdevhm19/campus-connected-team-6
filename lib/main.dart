import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/create_event.dart';
import 'package:flutter_campus_connected/pages/dashboard.dart';
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
        '/dashboard': (BuildContext context) => new Dashboard(),
        '/createevent': (BuildContext context) => new CreateEvent(),
        '/signup': (BuildContext context) => new SignUpPage(),
      },
      theme: new ThemeData(primarySwatch: Colors.red),
      home: new LoginSignUpPage(),
    );
  }
}
