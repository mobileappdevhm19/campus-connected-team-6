import 'package:flutter/material.dart';
import 'package:flutter_login_demo/pages/MyForm.dart';
import 'package:flutter_login_demo/pages/root_page.dart';
import 'package:flutter_login_demo/services/authentication.dart';
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
        home: new RootPage(auth: new Auth()));

  }
}
