import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_campus_connected/services/authentication.dart';
import 'package:flutter_campus_connected/logos/campus_logo.dart';
import 'package:flutter_campus_connected/models/dashboard_item.dart';
import 'package:flutter_campus_connected/models/event_model.dart';
import 'package:flutter_campus_connected/pages/create_event.dart';
import 'package:flutter_campus_connected/pages/profile.dart';
import 'package:flutter_campus_connected/pages/users_profile.dart';
import 'package:flutter_campus_connected/pages/view_event.dart';
import 'package:flutter_campus_connected/utils/screen_aware_size.dart';

import 'faq_page.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  FirebaseUser firebaseUser;
  String email = '';
  Auth auth = new Auth();
  EventModel eventModel;

  bool isLoggedIn = false;

  //to check if a user logged in or not , it will call from initState
  checkIsLoggedIn() async {
    auth.getCurrentUser().then((user) {
      if (user != null) {
        setState(() {
          isLoggedIn = true;
        });
      } else {
        setState(() {
          isLoggedIn = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkIsLoggedIn();
    auth.getCurrentUser().then((user) {
      setState(() {
        firebaseUser = user;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        key: scaffoldKey,
        appBar: appBar(context),
        drawer: getDrawer(context),
        body: getBody(context),
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) {
    return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text('Do you want to exit this application?'),
            content: new Text('We hate to see you leave...'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => SystemNavigator.pop(),
                child: new Text('Yes'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Drawer getDrawer(BuildContext context) {
    return Drawer(
      key: Key("Drawer"),
      child: ListView(
        children: <Widget>[
          appLogo(context),
          isLoggedIn
              ? profileNameAndImage(context, _getUserData())
              : Container(),
          isLoggedIn ? Divider() : Container(),
          isLoggedIn
              ? Container()
              : drawerItem(context, 'Login', Icons.account_circle, 'login'),
          isLoggedIn
              ? drawerItem(context, 'Users', Icons.person, 'users')
              : Container(),
          drawerItem(context, 'Events', Icons.event_available, 'events'),
          drawerItem(context, 'Create Events', Icons.event, 'login'),
          drawerItem(context, 'FAQ', Icons.question_answer, 'faq'),
          isLoggedIn
              ? drawerItem(context, 'Log Out', Icons.exit_to_app, 'logout')
              : Container(),
        ],
      ),
    );
  }

  Container getBody(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder(
        stream: Firestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return eventList(snapshot);
        },
      ),
    );
  }

  //events List
  ListView eventList(AsyncSnapshot snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context, ind) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            margin: EdgeInsets.all(6.0),
            elevation: 3.0,
            child: ListTile(
              title: Text(
                snapshot.data.documents[ind]['eventName'],
                style: TextStyle(fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  snapshot.data.documents[ind]['eventDescription'],
                  style: TextStyle(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Hero(
                    tag: snapshot.data.documents[ind].documentID,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        width: screenAwareSize(80, context),
                        height: screenAwareSize(60, context),
                        //'assets/gallery.png,
                        child: (snapshot.data.documents[ind]['eventPhotoUrl'] ==
                                'assets/gallery.png')
                            ? Image(
                                image: AssetImage('assets/gallery.png'),
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: snapshot.data.documents[ind]
                                    ['eventPhotoUrl'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Image.asset(
                                      'assets/loadingfailed.png',
                                      fit: BoxFit.cover,
                                    ),
                                errorWidget: (context, url, error) =>
                                    new Icon(Icons.error),
                              ),
                      ),
                    )),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (context) {
                  return EventView(
                    snapshot.data.documents[ind],
                    firebaseUser,
                  );
                }));
              },
            ),
          );
        });
  }

  //appBar
  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text('Campus Connected'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {},
        )
      ],
    );
  }

  //appLogo
  Container appLogo(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      height: screenAwareSize(150, context),
      child: Center(
        child: CampusLogo(//size: screenAwareSize(80, context)),
            ),
      ),
    );
  }

  //drawer Item profile name and Image
  Padding profileNameAndImage(
      BuildContext context, Stream<QuerySnapshot> data) {
    return Padding(
      padding: EdgeInsets.only(
          top: screenAwareSize(12.0, context),
          bottom: screenAwareSize(8.0, context)),
      child: StreamBuilder(
        stream: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          final item = DashboardItem(
            snapshot.data.documents[0]['displayName'],
            snapshot.data.documents[0]['photoUrl'],
          );
          return getListItem(
              (snapshot.hasData && snapshot.data.documents.length == 0),
              item,
              context);
        },
      ),
    );
  }

  Stream<QuerySnapshot> _getUserData() {
    return Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: firebaseUser.uid)
        .snapshots();
  }

  StatelessWidget getListItem(
      bool val, DashboardItem item, BuildContext context) {
    return !(val)
        ? ListTile(
            title: Text(
              item.displayName,
              //snapshot.data.documents[0]['displayName'],
              style: TextStyle(fontSize: 18),
              maxLines: 1,
              key: Key('UserName'),
              overflow: TextOverflow.ellipsis,
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Container(
                width: screenAwareSize(50, context),
                height: screenAwareSize(50, context),
                child: CachedNetworkImage(
                  imageUrl: item.photoUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.asset(
                        'assets/person.jpg',
                        fit: BoxFit.cover,
                      ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
            ),
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ProfilePage(
                  firebaseUser: firebaseUser,
                );
              }));
            },
          )
        : Container();
  }

  //drawer Items
  ListTile drawerItem(BuildContext context, String title, IconData icon,
      [String route]) {
    return new ListTile(
      key: Key(title),
      title: Text(title),
      leading: Icon(icon),
      onTap: () {
        if (route == 'logout') {
          Navigator.of(context).pop();
          FirebaseAuth.instance.signOut();
          auth.signOut();
          Navigator.of(context).pushReplacementNamed('/logout');
          checkIsLoggedIn();
        } else if (route == 'events') {
          Navigator.of(context).pop();
        } else if (route == 'login') {
          Navigator.of(context).pop();
          isLoggedIn
              ? Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (BuildContext context) {
                  return CreateEvent(
                    currentUser: firebaseUser,
                  );
                }))
              : Navigator.of(context).pushNamed('/login');
        } else if (route == 'users') {
          Navigator.of(context).pop();
          isLoggedIn
              ? Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (BuildContext context) {
                  return UsersProfile(firebaseUser);
                }))
              : Navigator.of(context).pushNamed('/login');
        } else if (route == 'faq') {
          Navigator.of(context)
              .push(new MaterialPageRoute(builder: (BuildContext context) {
            return FAQPage();
          }));
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
