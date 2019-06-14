import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/usersProfileDetails.dart';
import 'package:flutter_campus_connected/utils/screen_aware_size.dart';

class UsersProfile extends StatefulWidget {
  @override
  UsersProfileState createState() => UsersProfileState();
}

class UsersProfileState extends State<UsersProfile> {
  var queryResultSet = [];
  var tempSearchStore = [];
  final CollectionReference collectionReference =
      Firestore.instance.collection("users");

  var _profileController = new StreamController();

  //for filtering users profile
  initialSearch(value) {
    var counter = 0;
    if (value.length == 0) {
      tempSearchStore = queryResultSet;
      _profileController.add(tempSearchStore);
      return;
    }
    tempSearchStore = [];
    queryResultSet.forEach((element) {
      if (element.data['displayName']
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element.data['email'].toLowerCase().contains(value.toLowerCase())) {
        counter++;
        tempSearchStore.add(element);
      }
    });
    if (counter == 0) {
      tempSearchStore = [];
    }

    _profileController.add(tempSearchStore);
  }

  @override
  void initState() {
    super.initState();
    collectionReference.getDocuments().then((QuerySnapshot docs) {
      for (int i = 0; i < docs.documents.length; i++) {
        queryResultSet.add(docs.documents[i]);
      }
      _profileController.add(queryResultSet);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _profileController?.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: SafeArea(
        top: true,
        child: usersProfileList(),
      ),
    );
  }

  // users profile
  StreamBuilder usersProfileList() {
    return StreamBuilder(
      stream: _profileController.stream,
      builder: streamBuilder,
    );
  }

  Widget streamBuilder(context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    print(snapshot.hasData);
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (context, ind) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            margin: EdgeInsets.all(6.0),
            elevation: 3.0,
            child: ListTile(
              title: Text(
                snapshot.data[ind]['displayName'],
                style: TextStyle(fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                snapshot.data[ind]['email'],
                style: TextStyle(fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  width: screenAwareSize(50, context),
                  height: screenAwareSize(50, context),
                  child: FadeInImage.assetNetwork(
                    image: snapshot.data[ind]['photoUrl'],
                    fit: BoxFit.cover,
                    placeholder: 'assets/person.jpg',
                  ),
                ),
              ),
              contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 15),
              onTap: () async {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return UsersProfileDetails(
                    details: snapshot.data[ind],
                  );
                }));
              },
            ),
          );
        });
  }

//  appbar
  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        margin: EdgeInsets.all(5),
        child: new TextField(
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search),
            border: InputBorder.none,
            hintText: 'Search...',
          ),
          onChanged: (value) {
            initialSearch(value);
          },
        ),
      ),
      leading: new IconButton(
        icon: new Icon(
          Icons.arrow_back_ios,
        ),
        color: Colors.white,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
