import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/models/user_entity.dart';
import 'package:flutter_campus_connected/pages/usersProfileDetails.dart';
import 'package:flutter_campus_connected/utils/screen_aware_size.dart';

class EventUsersList extends StatelessWidget {
  final eventId;
  final FirebaseUser firebaseUser;

  EventUsersList({this.eventId, this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('eventUsers')
            .where('eventId', isEqualTo: eventId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          return Container(
            child: ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, ind) {
                  String userId = snapshot.data.documents[ind]['userId'];
                  return Card(
                    margin: EdgeInsets.all(2.0),
                    elevation: 1.0,
                    child: listItem(userId, ind, context),
                  );
                }),
          );
        },
      ),
    );
  }

  //participant list
  StreamBuilder<QuerySnapshot> listItem(
      String userId, int ind, BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .where('uid', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        final entity = UserEntity(
            snapshot.data.documents[0]['displayName'],
            snapshot.data.documents[0]['photoUrl'],
            snapshot.data.documents[0]['email'],
            snapshot.data.documents[0]);
        return !(snapshot.hasData && snapshot.data.documents.length == 0)
            ? ListTile(
                title: Text(
                  entity.displayName,
                  style: TextStyle(fontSize: screenAwareSize(20, context)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      width: screenAwareSize(50, context),
                      height: screenAwareSize(50, context),
                      child: FadeInImage.assetNetwork(
                        image: entity.photoUrl,
                        fit: BoxFit.cover,
                        placeholder: 'assets/person.jpg',
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  tapOnItem(context, entity);
                },
              )
            : Container();
      },
    );
  }

  void tapOnItem(BuildContext context, UserEntity entity) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return UsersProfileDetails(
        details: entity.data,
        firebaseUser: firebaseUser,
      );
    }));
  }

  //app bar
  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red,
      elevation: 0.0,
      /*
      leading: new IconButton(
        icon: new Icon(
          Icons.arrow_back_ios,
        ),
        color: const Color(0xFFDDDDDD),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      */
      title: new Text('Interested People'),
    );
  }

  //for showign user information on dialog
  void _showAlertDialouge(name, email, context) {
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
                  'Participant Information',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: screenAwareSize(20, context)),
                ),
                SizedBox(height: screenAwareSize(10, context)),
                Padding(
                  padding: EdgeInsets.all(screenAwareSize(8.0, context)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: screenAwareSize(10, context),
                      ),
                      Text(
                        name,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: screenAwareSize(16, context)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(screenAwareSize(8.0, context)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Icon(
                        Icons.email,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: screenAwareSize(10, context),
                      ),
                      Text(
                        email,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: screenAwareSize(16, context)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: screenAwareSize(10, context),
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
