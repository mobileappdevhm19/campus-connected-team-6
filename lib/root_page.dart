import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'pages/login_signup_page.dart';
import 'pages/splash_screen.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState != ConnectionState.none) {
            return new SplashScreen();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildWaitingScreen();
          }
          if (snapshot.hasData) {
            return MyHomePage();
          } else {
            return LoginSignUpPage();
          }
        });
  }
}

Widget _buildWaitingScreen() {
  return Scaffold(
    body: Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    ),
  );
}
