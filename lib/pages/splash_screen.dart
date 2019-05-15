import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import './root_page.dart';

class ImageSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<ImageSplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new RootPage(auth: new Auth())));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[new Image.asset('assets/flutter-icon.png')],
      ),
    );
  }
}
