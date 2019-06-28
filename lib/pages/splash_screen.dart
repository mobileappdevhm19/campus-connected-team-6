import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/logos/campus_logo.dart';
import 'package:flutter_campus_connected/root_page.dart';

import 'dashboard.dart';
import 'login_signup_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).push(new MaterialPageRoute(
        //builder: (BuildContext context) => new Dashboard()));
        builder: (BuildContext context) => new LoginSignUpPage()));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //  body: new Stack(fit: StackFit.expand, children: <Widget>[_showLogo()]),
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Container(
            decoration: BoxDecoration(
                color: new Color(0xFFB71C1C),
                gradient: LinearGradient(
                  colors: [new Color(0xFFEF5350), new Color(0xFFEF9A9A)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ))),
        Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround ,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 90.0,
              child: Image.asset('assets/flutter-icon.png'),
              // child: CampusLogo(),
            ),
            Padding(
              // padding: EdgeInsets.only(bottom:10.0),
              padding: EdgeInsetsDirectional.only(bottom: 30.0),
            ),
            Text("CAMPUS Connected",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ))
          ],
        ),
      ]),
    );
  }
}
