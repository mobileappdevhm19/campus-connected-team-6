import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_demo/pages/home_page.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import './splash_screen.dart';

class WelcomePage extends StatefulWidget {
  @override
  WelcomPageState createState() => new WelcomPageState();
}

class WelcomPageState extends State<WelcomePage> {
  startTime() async {
    var _duration = new Duration(milliseconds: 900);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new HomePage()));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(''), centerTitle: true),
        body: Stack(
          children: <Widget>[
            _showBody(),
          ],
        ));
  }

  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(shrinkWrap: true, children: <Widget>[
            _showLogo(),
            _boxMessage(),
            _iconButton(),
          ]),
        ));
  }

  Widget _showLogo() {
    return new Material(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 100.0,
          child: Image.asset('assets/flutter-icon.png'),
        ),
      ),
    );
  }

  Widget _boxMessage() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
        child: new Container(
          decoration: new BoxDecoration(
            color: Colors.red,
          ),
          padding: new EdgeInsets.all(15.0),
          child: new Text("Nice to see you back, Saif!",
              style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              )),
        ));
  }

  Widget _iconButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
      child: IconButton(
          icon: new Icon(
            Icons.mood,
            color: Colors.red,
            size: 100.0,
          )),
    );
  }
}
