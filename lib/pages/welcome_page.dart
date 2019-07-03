import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  final String firebaseUser;

  WelcomePage({this.firebaseUser});

  @override
  WelcomePageState createState() => new WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  String _welcomeText;

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      _welcomeText = "NICE TO SEE YOU BACK";
    } else {
      prefs.setBool('seen', true);
      _welcomeText = "WELCOME";
    }
  }

  startTime() async {
    var _duration = new Duration(milliseconds: 900);
    await checkFirstSeen();
    return new Timer(_duration, navigationPage);
  }

  navigationPage() {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new MyHomePage()));
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
              padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
            ),
            _boxMessage(context),
          ],
        ),
      ]),
    );
  }

//
  Widget _boxMessage(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: widget.firebaseUser)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          return !(snapshot.hasData && snapshot.data.documents.length == 0)
              ? new Container(
                  padding: new EdgeInsets.all(30.0),
                  child: new Text(
                    _welcomeText +
                        "\n${snapshot.data.documents[0]['displayName']}!"
                            .toUpperCase(),
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      //color: Colors.white,
                      color: new Color(0xFFFFCDD2),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : new Container();
        },
      ),
    );
  }
}
