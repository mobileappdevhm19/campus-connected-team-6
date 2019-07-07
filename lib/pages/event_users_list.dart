import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/models/user_model.dart';
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
                ),
                onTap: () async {
                  tapOnItem(context, entity);
                },
              )
            : Container();
      },
    );
  }

  void tapOnItem(BuildContext context, UserModel entity) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return UsersProfileDetails(
        details: entity,
        firebaseUser: firebaseUser,
      );
    }));
  }

  //app bar
  AppBar appBar(BuildContext context) {
    return AppBar(
      //backgroundColor: Colors.red,
      elevation: 0.0,
      leading: new IconButton(
        icon: new Icon(
          Icons.arrow_back_ios,
        ),
        color: Colors.white,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: new Text('Interested People'),
    );
  }
}
