import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/view_event.dart';
import 'package:flutter_campus_connected/utils/screen_aware_size.dart';

class SearchEvent extends StatefulWidget {
  final FirebaseUser currentUser;

  SearchEvent({this.currentUser});

  @override
  _SearchEventState createState() => _SearchEventState();
}

class _SearchEventState extends State<SearchEvent> {
  var queryResultSet = [];
  var tempSearchStore = [];
  final CollectionReference collectionReference =
      Firestore.instance.collection("events");

  //first we will fetch data from the firebase and will store in queryResultSet and then we can filterout data from queryResultSet list and store in
  // tempsearchStore list and will show the data from tempsearchstore list
  initialSearch(value) {
    var counter = 0;
    if (value.length == 0) {
      setState(() {
        tempSearchStore = [];
      });
      return;
    }

    tempSearchStore = [];
    queryResultSet.forEach((element) {
      if (element.data['eventName']
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element.data['eventDescription']
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element.data['eventLocation']
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element.data['eventCategory']
              .toLowerCase()
              .contains(value.toLowerCase())) {
        counter++;
        setState(() {
          tempSearchStore.add(element);
        });
      }
    });
    if (counter == 0) {
      setState(() {
        tempSearchStore = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    collectionReference.getDocuments().then((QuerySnapshot docs) {
      for (int i = 0; i < docs.documents.length; i++) {
        queryResultSet.add(docs.documents[i]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      child: Scaffold(
        appBar: AppBar(
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
                hintText: 'Search Events...',
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
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
        ),
        body: Container(
          child: listItem(tempSearchStore),
        ),
      ),
    );
  }

  listItem(snapshot) {
    return ListView.builder(
        itemCount: snapshot.length,
        itemBuilder: (context, index) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            margin: EdgeInsets.all(6.0),
            elevation: 3.0,
            child: ListTile(
              title: Text(
                snapshot[index]['eventName'],
                style: TextStyle(fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  snapshot[index]['eventDescription'],
                  style: TextStyle(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Hero(
                    tag: snapshot[index].documentID,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        width: screenAwareSize(80, context),
                        height: screenAwareSize(60, context),
                        child: snapshot[index]['eventPhotoUrl'] ==
                                'assets/gallery.png'
                            ? Image(
                                image: AssetImage('assets/gallery.png'),
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: snapshot[index]['eventPhotoUrl'],
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
                  return EventView(snapshot[index], widget.currentUser);
                }));
              },
            ),
          );
        });
  }
}
