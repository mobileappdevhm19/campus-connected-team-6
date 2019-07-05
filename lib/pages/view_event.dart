import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/models/user_model.dart';
import 'package:flutter_campus_connected/services/authentication.dart';
import 'package:flutter_campus_connected/helper/cloud_firestore_helper.dart';
import 'package:flutter_campus_connected/models/event_model.dart';
import 'package:flutter_campus_connected/models/event_user_model.dart';
import 'package:flutter_campus_connected/pages/usersProfileDetails.dart';
import 'package:flutter_campus_connected/utils/screen_aware_size.dart';
import 'package:flutter_campus_connected/utils/text_aware_size.dart';

import 'event_users_list.dart';

class EventView extends StatefulWidget {
  final event;
  final FirebaseUser firebaseUser;

  EventView(this.event, [this.firebaseUser]);

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  String _joinStatusInterested = "I´m Interested";
  String _joinStatusNotInterested = "I´m Not Interested";
  String _deleteButtonText = "Delete Event";

  var totalParticipantCount = 0;
  String currentEventUser = "";
  Auth auth = new Auth();
  EventModel eventModel;
  EventUserModel _eventUserModel = new EventUserModel();
  FireCloudStoreHelper cloudStoreHelper = new FireCloudStoreHelper();

  //bool isLoggedIn = false;
  //bool isJoinedIn = false;

  // For Checking Internet Connection
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  //to check if a user logged in or not , it will call from initState
//  _isLoggedIn() async {
//    auth.getCurrentUser().then((user) {
//      if (user != null) {
//        setState(() {
//          isLoggedIn = true;
//        });
//      } else {
//        setState(() {
//          isLoggedIn = false;
//        });
//      }
//    });
//  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: screenAwareSize(250.0, context),
                floating: false,
                pinned: true,
                flexibleSpace: eventImage(context),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(screenAwareSize(20, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      organizerName(),
                      SizedBox(height: screenAwareSize(10, context)),
                      eventItem(
                          context, widget.event['eventDate'], Icons.date_range),
                      SizedBox(height: screenAwareSize(10, context)),
                      eventItem(context, widget.event['eventTime'],
                          Icons.access_time),
                      SizedBox(height: screenAwareSize(10, context)),
                      eventItem(context, widget.event['eventLocation'],
                          Icons.location_on),
                      SizedBox(height: screenAwareSize(10, context)),
                      eventItem(context, widget.event['eventCategory'],
                          Icons.category),
                      SizedBox(height: screenAwareSize(10, context)),
                      interestedButton(context, widget.event['createdBy']),
                      eventParticipant(),
                      Divider(
                        color: Colors.grey,
                      ),
                      eventDetails(context),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //event Image
  FlexibleSpaceBar eventImage(BuildContext context) {
    return FlexibleSpaceBar(
      title: Text(
        widget.event['eventName'],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Colors.white,
            fontSize: textAwareSize(18, context),
            fontWeight: FontWeight.bold),
      ),
      background: Hero(
        tag: widget.event.documentID,
        child: widget.event['eventPhotoUrl'] == 'assets/gallery.png'
            ? Image(
                image: AssetImage('assets/gallery.png'),
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                imageUrl: widget.event['eventPhotoUrl'],
                colorBlendMode: BlendMode.softLight,
                placeholder: (context, url) => Image.asset(
                      'assets/loadingfailed.png',
                      fit: BoxFit.cover,
                    ),
                errorWidget: (context, url, error) => new Icon(Icons.error),
                fit: BoxFit.fill,
              ),
      ),
    );
  }

  //Event Details
  ListTile eventDetails(BuildContext context) {
    return ListTile(
      title: Text(
        'Details',
        style: TextStyle(
            color: Colors.black87,
            fontSize: textAwareSize(18, context),
            fontWeight: FontWeight.bold),
      ),
      contentPadding: EdgeInsets.all(0.0),
      subtitle: Padding(
          padding: EdgeInsets.only(top: screenAwareSize(8.0, context)),
          child: DescriptionTextWidget(
            text: widget.event['eventDescription'],
          )),
    );
  }

  //Event Participants
  StreamBuilder<QuerySnapshot> eventParticipant() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('eventUsers')
          .where('eventId', isEqualTo: widget.event.documentID)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        totalParticipantCount = snapshot.data.documents.length;
        return !(snapshot.hasData && snapshot.data.documents.length == 0)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenAwareSize(8.0, context),
                        left: screenAwareSize(8.0, context)),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total Participants $totalParticipantCount / ${widget.event['maximumLimit']}',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: textAwareSize(15, context)),
                        ),
                        FlatButton(
                          child: Text(
                            'View all',
                            style: TextStyle(
                                fontSize: textAwareSize(16, context),
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return EventUsersList(
                                eventId: widget.event.documentID,
                                firebaseUser: widget.firebaseUser,
                              );
                            }));
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: screenAwareSize(50, context),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.documents.length > 15
                            ? 15
                            : snapshot.data.documents.length,
                        itemBuilder: (context, ind) {
                          return Padding(
                            padding: EdgeInsets.all(5.0),
                            child: CircleAvatar(
                              child: StreamBuilder(
                                  stream: Firestore.instance
                                      .collection('users')
                                      .where('uid',
                                          isEqualTo: snapshot
                                              .data.documents[ind]['userId'])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container();
                                    }
                                    final entity = UserModel(
                                        displayName: snapshot.data.documents[0]
                                            ['displayName'],
                                        photoUrl: snapshot.data.documents[0]
                                            ['photoUrl'],
                                        email: snapshot.data.documents[0]
                                            ['email'],
                                        age: snapshot.data.documents[0]['age'],
                                        faculty: snapshot.data.documents[0]
                                            ['faculty'],
                                        biography: snapshot.data.documents[0]
                                            ['biography'],
                                        isEmailVerified: snapshot.data
                                            .documents[0]['isEmailVerified'],
                                        uid: snapshot.data.documents[0]['uid']);
                                    return !(snapshot.hasData &&
                                            snapshot.data.documents.length == 0)
                                        ? InkWell(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              child: Container(
                                                width: screenAwareSize(
                                                    37, context),
                                                height: screenAwareSize(
                                                    37, context),
                                                child: CachedNetworkImage(
                                                  imageUrl: entity.photoUrl,
                                                  placeholder: (context, url) =>
                                                      new CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return UsersProfileDetails(
                                                  details: entity,
                                                  firebaseUser:
                                                      widget.firebaseUser,
                                                );
                                              }));
                                            },
                                          )
                                        : Container();
                                  }),
                            ),
                          );
                        }),
                  ),
                ],
              )
            : Container();
      },
    );
  }

  //event interested Button
  StreamBuilder<QuerySnapshot> interestedButton(
      BuildContext context, String organizer) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('eventUsers')
          .where('userId', isEqualTo: widget.firebaseUser.uid)
          .where('eventId', isEqualTo: widget.event.documentID)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        !(snapshot.hasData && snapshot.data.documents.length == 0)
            ? currentEventUser = snapshot.data.documents[0].documentID
            : currentEventUser = "";
        if (widget.firebaseUser.uid == organizer) {
          return Align(
            alignment: Alignment.center,
            child: RaisedButton(
                color: Colors.redAccent,
                padding: EdgeInsets.only(
                    left: screenAwareSize(20, context),
                    right: screenAwareSize(20, context)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: screenAwareSize(16, context),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      _deleteButtonText,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: screenAwareSize(16, context)),
                    )
                  ],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 8.0,
                onPressed: () {
                  _deleteEvent(context);
                }
                //},
                ),
          );
        } else {
          return !(snapshot.hasData && snapshot.data.documents.length == 0)
              ? Align(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    color: Colors.red,
                    padding: EdgeInsets.only(
                        left: screenAwareSize(20, context),
                        right: screenAwareSize(20, context)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: screenAwareSize(16, context),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          _joinStatusNotInterested,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: textAwareSize(16, context)),
                        )
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 8.0,
                    onPressed: _deleteEventUser,
                    //},
                  ),
                )
              : Align(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    color: Colors.red,
                    padding: EdgeInsets.only(
                        left: screenAwareSize(20, context),
                        right: screenAwareSize(20, context)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: screenAwareSize(16, context),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          _joinStatusInterested,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: textAwareSize(16, context)),
                        )
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 8.0,
                    onPressed: () {
                      if (totalParticipantCount <
                          widget.event['maximumLimit']) {
                        _createEventUser();
                      } else {
                        _showAlertDialogue();
                      }
                    },
                    //},
                  ),
                );
        }
      },
    );
  }

  Future<bool> _deleteEvent(BuildContext context) {
    return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text('Do you want to delete this Event?'),
            content: new Text('Deleted Events can not be restored!'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  cloudStoreHelper.deleteEvent(widget.event.documentID);
                  Navigator.of(context).pop(false);
                  Navigator.of(context).pop(false);
                },
                child: new Text('Yes'),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: new Text('No'),
              ),
            ],
          ),
        ) ??
        false;
  }

  //will save participant data in database
  void _createEventUser() async {
    //check internet connection
    var connectionStatus = await checkInternetConnection();
    if (connectionStatus == false) {
      _showInternetAlertDialogue();
      return;
    }
    _eventUserModel.eventId = widget.event.documentID; //changed
    _eventUserModel.userId = widget.firebaseUser.uid;
    await cloudStoreHelper.addEventUser(_eventUserModel);
  }

  //will delete participant data in database
  void _deleteEventUser() async {
    //check internet connection
    var connectionStatus = await checkInternetConnection();
    if (connectionStatus == false) {
      _showInternetAlertDialogue();
      return;
    }
    await cloudStoreHelper.deleteEventUser(currentEventUser);
  }

  //Event Items like date, time , location , category
  Row eventItem(BuildContext context, name, icon) {
    return Row(
      children: <Widget>[
        ClipOval(
          child: Container(
            padding: EdgeInsets.all(screenAwareSize(8.0, context)),
            color: Color.fromARGB(30, 252, 55, 55),
            child: Icon(
              icon,
              color: Colors.red,
            ),
          ),
        ),
        SizedBox(
          width: screenAwareSize(10, context),
        ),
        Text(
          name,
          style: TextStyle(
              color: Colors.black87, fontSize: textAwareSize(16, context)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  //Event Organizer Name
  StreamBuilder<QuerySnapshot> organizerName() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .where('uid', isEqualTo: widget.event['createdBy'])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        final entity = UserModel(
            displayName: snapshot.data.documents[0]['displayName'],
            photoUrl: snapshot.data.documents[0]['photoUrl'],
            email: snapshot.data.documents[0]['email'],
            age: snapshot.data.documents[0]['age'],
            faculty: snapshot.data.documents[0]['faculty'],
            biography: snapshot.data.documents[0]['biography'],
            isEmailVerified: snapshot.data.documents[0]['isEmailVerified'],
            uid: snapshot.data.documents[0]['uid']);

        return !(snapshot.hasData && snapshot.data.documents.length == 0)
            ? InkWell(
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        width: screenAwareSize(37, context),
                        height: screenAwareSize(37, context),
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
                    ),
                    SizedBox(
                      width: screenAwareSize(10, context),
                    ),
                    Text(
                      "Organized by " + entity.displayName,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: textAwareSize(16, context)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return UsersProfileDetails(
                      details: entity,
                      firebaseUser: widget.firebaseUser,
                    );
                  }));
                },
              )
            : Container();
      },
    );
  }

  //this will populate when a user wants to join but already exist the limit
  void _showAlertDialogue() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: screenAwareSize(10, context)),
                Text(
                  'Sorry 😞',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: textAwareSize(26, context)),
                ),
                SizedBox(height: screenAwareSize(10, context)),
                Padding(
                  padding: EdgeInsets.all(screenAwareSize(8.0, context)),
                  child: Text(
                    'We have reached the maximum number of participants. ',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: textAwareSize(16, context)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'CLOSE',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 6.0,
                  ),
                )
              ],
            ),
            contentPadding: EdgeInsets.all(10),
            titlePadding: EdgeInsets.all(20),
          );
        });
  }

  //will popup if there is no internet connection
  void _showInternetAlertDialogue() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: screenAwareSize(10, context)),
                Text(
                  'No Internet 😞',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: textAwareSize(26, context)),
                ),
                SizedBox(height: screenAwareSize(10, context)),
                Padding(
                  padding: EdgeInsets.all(screenAwareSize(8.0, context)),
                  child: Text(
                    'Please Check Internet Connection.',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: textAwareSize(16, context)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'CLOSE',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 6.0,
                  ),
                )
              ],
            ),
            contentPadding: EdgeInsets.all(10),
            titlePadding: EdgeInsets.all(20),
          );
        });
  }
}

// this class is for showing the event details to show more or less text
class DescriptionTextWidget extends StatefulWidget {
  final String text;

  DescriptionTextWidget({@required this.text});

  @override
  _DescriptionTextWidgetState createState() =>
      new _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > 150) {
      firstHalf = widget.text.substring(0, 150);
      secondHalf = widget.text.substring(150, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf.isEmpty
          ? new Text(firstHalf)
          : new Column(
              children: <Widget>[
                new Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf)),
                new InkWell(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text(
                        flag ? "show more" : "show less",
                        style: new TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
