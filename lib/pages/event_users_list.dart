import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/utils/screen_aware_size.dart';

class EventUsersList extends StatelessWidget {
  final eventId;
  String user = "test";

  EventUsersList({this.eventId});

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
                  return Card(
                    margin: EdgeInsets.all(2.0),
                    elevation: 1.0,
                    child: listItem(snapshot, ind, context),
                  );
                }),
          );
        },
      ),
    );
  }

  //participant list
  ListTile listItem(AsyncSnapshot snapshot, int ind, BuildContext context) {
    Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: snapshot.data.documents[ind]['userId'])
        .getDocuments()
        .then((data) => user = data.documents[ind]['displayName']);
    return ListTile(
      title: Text(
        user,
        style: TextStyle(fontSize: screenAwareSize(20, context)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: CircleAvatar(
        child: Text(
          snapshot.data.documents[ind]['userId']
              .toString()
              .toUpperCase()
              .substring(0, 1)
              .toUpperCase(),
          style: TextStyle(fontSize: screenAwareSize(20, context)),
        ),
      ),
      /* onTap: () {
        //_showAlertDialouge(snapshot.data.documents[ind]['name'],
        //  snapshot.data.documents[ind]['email'], context);
      },
      */
    );
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
