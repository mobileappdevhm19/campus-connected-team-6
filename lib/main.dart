import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/splash_screen.dart';

import 'helper/authentication.dart';
import 'pages/create_event.dart';
import 'pages/dashboard.dart';
import 'pages/login_signup_page.dart';
import 'pages/profile.dart';
import 'pages/search_events.dart';
import 'pages/signup_page.dart';
import 'root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Campus Connected',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new LoginSignUpPage(),
        '/dashboard': (BuildContext context) => new Dashboard(),
        '/createevent': (BuildContext context) => new CreateEvent(),
        '/signup': (BuildContext context) => new SignUpPage(),
        '/home': (BuildContext context) => new MyHomePage(),
        '/logout': (BuildContext context) => new LoginSignUpPage(),
      },
      theme: new ThemeData(primarySwatch: Colors.red),
      //home: new Dashboard(),
      home: new RootPage(),
      // home: new SplashScreen(),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  var firebaseUser;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseUser firebaseUser;
  Auth auth = new Auth();
  int currentTab = 0;

  Dashboard dashboard;
  SearchEvent searchEvent;
  CreateEvent createEvent;
  ProfilePage profilePage;
  static List<Widget> pages;
  Widget currentPage;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    auth.getCurrentUser().then((user) {
      setState(() {
        firebaseUser = user;
        dashboard = Dashboard();
        searchEvent = SearchEvent();
        createEvent = CreateEvent(currentUser: firebaseUser);
        // profilePage= ProfilePage(firebaseUser: firebaseUser);
        pages = [dashboard, searchEvent, createEvent];
      });
    });
    pages = [dashboard, searchEvent, createEvent];
    currentPage = dashboard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            title: Text(''),
          ),
        ],
      ),
    );
  }
}
