import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/helper/cloud_firestore_helper.dart';
import 'package:flutter_campus_connected/models/event_entity.dart';
import 'package:flutter_campus_connected/models/user_entity.dart';
import 'package:flutter_campus_connected/models/user_entity_add.dart';
import 'package:flutter_campus_connected/pages/view_event.dart';
import 'package:flutter_campus_connected/utils/screen_aware_size.dart';
import 'package:flutter_campus_connected/utils/text_aware_size.dart';

class UsersProfileDetails extends StatefulWidget {
  final details;
  final firebaseUser;

  UsersProfileDetails({this.details, this.firebaseUser});

  @override
  UsersProfileDetailsPageState createState() => UsersProfileDetailsPageState();
}

class UsersProfileDetailsPageState extends State<UsersProfileDetails> {
  String photoUrl;
  String displayName;
  String age;
  String faculty;
  String biography;

  UserEntityAdd _userEntity;

  FireCloudStoreHelper cloudStoreHelper = new FireCloudStoreHelper();
  final double ratio = 2.3;

  Container get getTopPart => topPart(context);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
      },
      child: Scaffold(
        appBar: appBar(context),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            //topPart(context),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.event,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(7),
                      child: Text(
                        'My Events',
                        style: textTheme.subtitle
                            .copyWith(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomEventListPart()
          ],
        ),
      ),
    );
  }

  //for testing purpose
  String _getUid() {
    return (widget.details != null) ? widget.details['uid'] : '123';
  }

  // organized Event List by the user
  Expanded bottomEventListPart() {
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
                final entity = EventEntity(
                    snapshot.data.documents[ind]['eventName'],
                    snapshot.data.documents[ind]['eventDescription'],
                    snapshot.data.documents[ind]['eventPhotoUrl']);

                return getItemList(
                    entity,
                    ind,
                    context,
                    snapshot.data.documents[ind].documentID,
                    snapshot.data.documents[ind]);
              });
        },
      ),
    );
  }

  Card getItemList(EventEntity entity, int ind, BuildContext context,
      String docId, dynamic data) {
    return Card(
      margin: EdgeInsets.all(6.0),
      elevation: 3.0,
      child: ListTile(
        title: Text(
          entity.eventName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(entity.eventDescription,
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
                  child: (entity.eventPhotoUrl == 'assets/gallery.png')
                      ? Image(
                          image: AssetImage('assets/gallery.png'),
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: entity.eventPhotoUrl,
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
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (context) {
                    return EventView(
                      data,
                      widget.firebaseUser,
                    );
                  }));
                }),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  //users's photo, name , email
  Container topPart(BuildContext context) {
    return Container(
      color: Colors.red,
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: StreamBuilder(
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
            final entity = UserEntity(
                snapshot.data.documents[0]['displayName'],
                snapshot.data.documents[0]['photoUrl'],
                snapshot.data.documents[0]['email'],
                snapshot.data.documents[0]['age'],
                snapshot.data.documents[0]['faculty'],
                snapshot.data.documents[0]['biography'],
                null);
            return getRootTop(entity, context);
          },
        ),
      ),
    );
  }

  Column getRootTop(UserEntity entity, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            getClipRRect('assets/person.jpg', false),
            getClipRRect(entity.photoUrl, true)
          ],
        ),
        Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              //snapshot.data.documents[0]['displayName'],
              entity.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: screenAwareSize(20, context),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1),
            )),
      ],
    );
  }

  ClipRRect getClipRRect(String image, isNetwork) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
          width: 120,
          height: 120,
          child: isNetwork
              ? CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.asset(
                        'assets/person.jpg',
                        fit: BoxFit.cover,
                      ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                )
              : Image.asset(
                  image,
                  fit: BoxFit.cover,
                )),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text("Profile"),
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
          Navigator.of(context).pop();
        },
      ),
      bottom: PreferredSize(
        child: Container(
          color: Colors.red,
          height: (MediaQuery.of(context).size.height / ratio) - 14,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              userProfileTopPart(),
              Spacer(),
            ],
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / ratio + 10),
      ),
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
          displayName = snapshot.data.documents[0]['displayName'];
          photoUrl = snapshot.data.documents[0]['photoUrl'];

          age = snapshot.data.documents[0]['age'];
          faculty = snapshot.data.documents[0]['faculty'];
          biography = snapshot.data.documents[0]['biography'];
        } else {
          return Container();
        }
        _userEntity = UserEntityAdd(
            snapshot.data.documents[0]['displayName'],
            snapshot.data.documents[0]['photoUrl'],
            snapshot.data.documents[0]['email'],
            snapshot.data.documents[0]['age'],
            snapshot.data.documents[0]['faculty'],
            snapshot.data.documents[0]['biography']);
        return getProfileItem(_userEntity, context);
      },
    );
  }

  Column getProfileItem(UserEntityAdd entity, BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(140),
                child: Container(
                  width: 140,
                  height: 140,
                  child: CachedNetworkImage(
                    useOldImageOnUrlChange: true,
                    imageUrl: entity.photoUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                          'assets/person.jpg',
                          fit: BoxFit.cover,
                        ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
              ),
            ]),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                entity.displayName,
                style: textTheme.headline.copyWith(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 8.0),
              child: Row(
                children: <Widget>[
                  new Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 16.0,
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: new Text(
                        entity.faculty == null || entity.faculty.isEmpty
                            ? "Unknown Faculty..."
                            : entity.faculty,
                        style: textTheme.subhead.copyWith(color: Colors.white)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  new Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Text(
                        entity.biography.isEmpty
                            ? 'This user has no Biography...'
                            : entity.biography,
                        style: textTheme.body1.copyWith(
                            color: Colors.white,
                            fontSize: textAwareSize(15.0, context)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
