import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 90.0,
              child: Image.asset('assets/flutter-icon.png'),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(bottom: 30.0),
            ),
            Text("CAMPUS Connected",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.03,
          left: MediaQuery.of(context).size.height * 0.06,
          right: MediaQuery.of(context).size.height * 0.06,
          child: Text("Copyright © 2019 Campus Connected. All Rights Reserved",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
              )),
        ),
      ]),
    );
  }
}
