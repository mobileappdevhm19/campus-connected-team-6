import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/helper/cloud_firestore_helper.dart';
import 'package:flutter_campus_connected/models/profile_item.dart';
import 'package:flutter_campus_connected/models/user_entity_add.dart';
import 'package:flutter_campus_connected/pages/view_event.dart';
import 'package:flutter_campus_connected/utils/screen_aware_size.dart';
import 'package:flutter_campus_connected/utils/text_aware_size.dart';

import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {
  final FirebaseUser firebaseUser;

  ProfilePage({this.firebaseUser});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String photoUrl;
  String displayName;
  UserEntityAdd _userEntity;
  FireCloudStoreHelper cloudStoreHelper = new FireCloudStoreHelper();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: appBar(context),
          body: TabBarView(
            children: <Widget>[
              getBodyEvent(context),
              getBodyParticipation(context),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return new AppBar(
      title: Text("My Profile"),
      centerTitle: true,
      textTheme: TextTheme(
        title: TextStyle(
            color: Colors.white,
            fontSize: textAwareSize(20, context),
            fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.red,
      elevation: 0.0,
      leading: new IconButton(
        icon: new Icon(
          Icons.arrow_back_ios,
        ),
        color: Colors.white,
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/home');
        },
      ),
      actions: <Widget>[
        getButtonEdit(context),
      ],
      bottom: PreferredSize(
        child: Container(
          color: Colors.red,
          height: MediaQuery.of(context).size.height / 2.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              userProfileTopPart(),
              TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.event, color: Colors.white),
                    text: "Created Events",
                  ),
                  Tab(
                    icon: Icon(Icons.event_available, color: Colors.white),
                    text: "Participations",
                  )
                ],
              ),
            ],
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / 2.3),
      ),
    );
  }

  Column getBodyEvent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(),
        userEvents(),
      ],
    );
  }

  Column getBodyParticipation(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(),
        userJoinedEvents(),
      ],
    );
  }

  FlatButton getButtonEdit(BuildContext context) {
    return new FlatButton(
      child: Text(
        'Edit',
        style: TextStyle(
            color: Colors.white,
            fontSize: screenAwareSize(20, context),
            fontWeight: FontWeight.bold,
            letterSpacing: 1),
      ),
      color: Colors.red,
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          _userEntity.displayName = displayName;
          _userEntity.photoUrl = photoUrl;
          return EditProfile(
              userInfo: widget.firebaseUser,
              userEntity: _userEntity,
              cloudStoreHelper: new FireCloudStoreHelper());
        }));
      },
    );
  }

  String _getUid() {
    return (widget.firebaseUser != null) ? widget.firebaseUser.uid : '123';
  }

  // events that hosted by the user
  Expanded userEvents() {
    return Expanded(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('events')
            .where('createdBy', isEqualTo: _getUid())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, ind) {
                final item = ProfileItem(
                    snapshot.data.documents[ind]['eventName'],
                    snapshot.data.documents[ind]['eventDescription'],
                    snapshot.data.documents[ind]['eventPhotoUrl']);
                return getItem(
                    item,
                    ind,
                    context,
                    snapshot.data.documents[ind].documentID,
                    snapshot.data.documents[ind]);
              });
        },
      ),
    );
  }

  Card getItem(ProfileItem item, int ind, BuildContext context, String docId,
      dynamic data) {
    return Card(
      margin: EdgeInsets.all(6.0),
      elevation: 3.0,
      child: ListTile(
        title: Text(
          item.eventName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(item.eventDescription,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16)),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Hero(
              tag: docId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: screenAwareSize(80, context),
                  height: screenAwareSize(60, context),
                  child: CachedNetworkImage(
                    imageUrl: item.eventPhotoUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                          'assets/loadingfailed.png',
                          fit: BoxFit.cover,
                        ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
              )),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.visibility,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (context) {
                    return EventView(
                      data,
                      widget.firebaseUser,
                    );
                  }));
                }),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.deepPurple,
                ),
                onPressed: () {
                  cloudStoreHelper.deleteEvent(docId);
                })
          ],
        ),
        onTap: () {},
      ),
    );
  }

  Expanded userJoinedEvents() {
    return Expanded(
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('eventUsers')
              .where('userId', isEqualTo: _getUid())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, ind) {
                String userEventId = snapshot.data.documents[ind]['eventId'];
                return StreamBuilder(
                  stream: Firestore.instance
                      .collection('events')
                      //.where('documentId', isEqualTo: userEventId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    //TODO: not showing the correct participations
                    //TODO: start
                    return Card(
                      margin: EdgeInsets.all(6.0),
                      elevation: 3.0,
                      child: ListTile(
                        title: Text(
                          snapshot.data.documents[ind]['eventName'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                              snapshot.data.documents[ind]['eventDescription'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16)),
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
                                  child: CachedNetworkImage(
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.visibility,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                      new MaterialPageRoute(builder: (context) {
                                    return EventView(
                                      snapshot.data.documents[ind],
                                      widget.firebaseUser,
                                    );
                                  }));
                                }),
                          ],
                        ),
                        onTap: () {},
                      ),
                    );

                    //TODO: end
                  },
                );
              },
            );
          }),
    );
  }

  // user profile pic , name ,email
  StreamBuilder<QuerySnapshot> userProfileTopPart() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .where('uid', isEqualTo: _getUid())
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        if (!(snapshot.hasData && snapshot.data.documents.length == 0)) {
          photoUrl = snapshot.data.documents[0]['photoUrl'];
          displayName = snapshot.data.documents[0]['displayName'];
        } else {
          return Container();
        }
        _userEntity = UserEntityAdd(
            snapshot.data.documents[0]['displayName'],
            snapshot.data.documents[0]['photoUrl'],
            snapshot.data.documents[0]['email'],
            snapshot.data.documents[0]['age'],
            snapshot.data.documents[0]['faculty'],
            snapshot.data.documents[0]['hobby']);
        return getProfileItem(_userEntity, context);
      },
    );
  }

  Column getProfileItem(UserEntityAdd entity, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Age: ${entity.age}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: screenAwareSize(18, context)),
                    ),
                    Text(
                      'Faculty: ${entity.faculty}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: screenAwareSize(18, context)),
                    ),
                  ],
                ),
              ),
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      width: 120,
                      height: 120,
                      child: Image.asset(
                        'assets/person.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      width: 120,
                      height: 120,
                      child: CachedNetworkImage(
                        imageUrl: entity.photoUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                              'assets/person.jpg',
                              fit: BoxFit.cover,
                            ),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                    ),
                  )
                ],
              ),
            ]),
        Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              entity.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: screenAwareSize(20, context),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1),
            )),
        Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              entity.email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white, fontSize: screenAwareSize(18, context)),
            )),
        Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              'Hobby: ${entity.hobby}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white, fontSize: screenAwareSize(18, context)),
            ))
      ],
    );
  }
}
