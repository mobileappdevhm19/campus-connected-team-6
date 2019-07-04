import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/helper/cloud_firestore_helper.dart';
import 'package:flutter_campus_connected/models/profile_item.dart';
import 'package:flutter_campus_connected/models/user_entity_add.dart';
import 'package:flutter_campus_connected/pages/profil/footer/friend_detail_footer.dart';
import 'package:flutter_campus_connected/pages/profil/friend_detail_body.dart';
import 'package:flutter_campus_connected/pages/profil/header/friend_detail_header.dart';
import 'package:flutter_campus_connected/pages/view_event.dart';
import 'package:flutter_campus_connected/utils/screen_aware_size.dart';
import 'package:flutter_campus_connected/utils/text_aware_size.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {
  final FirebaseUser firebaseUser;

  ProfilePage({this.firebaseUser});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  String photoUrl;
  String displayName;
  UserEntityAdd _userEntity;
  FireCloudStoreHelper cloudStoreHelper = new FireCloudStoreHelper();
  final double ratio = 1.7; //TODO fix ratio for scaling
  List<Tab> _tabs;
  TabController _tabController;
  ScrollController _scrollViewController;

  @override
  void initState() {
    super.initState();
    _tabs = [
      new Tab(
        icon: Icon(
          Icons.event,
        ),
        child: Text(
          "Created Events",
        ),
      ),
      new Tab(
        icon: Icon(
          Icons.event_available,
        ),
        child: Text(
          "Participations",
        ),
      )
    ];
    _tabController = new TabController(
      length: _tabs.length,
      vsync: this,
    );
    _scrollViewController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    var linearGradient = const BoxDecoration(
//      gradient: const LinearGradient(
//        begin: FractionalOffset.centerRight,
//        end: FractionalOffset.bottomLeft,
//        colors: <Color>[
//          const Color(0xFF413070),
//          const Color(0xFF2B264A),
//        ],
//      ),
//    );
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: appBar(context),
          body: TabBarView(
            controller: _tabController,
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
    return AppBar(
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
          height: (MediaQuery.of(context).size.height / ratio) + 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              userProfileTopPart(),
              Spacer(),
              getTabBar(),
            ],
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / ratio + 30),
      ),
    );
  }

  Widget getTabBar() {
    return TabBar(
      controller: _tabController,
      unselectedLabelColor: Colors.grey,
      indicatorWeight: 3,
      indicatorColor: Colors.white,
      tabs: <Widget>[
        Tab(
          icon: Icon(
            Icons.event,
          ),
          text: "Created Events",
        ),
        Tab(
          icon: Icon(
            Icons.event_available,
          ),
          text: "Participations",
        )
      ],
    );
  }

  Column getBodyEvent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        userEvents(),
      ],
    );
  }

  Column getBodyParticipation(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
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
                  child: (item.eventPhotoUrl == 'assets/gallery.png')
                      ? Image(
                          image: AssetImage('assets/gallery.png'),
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: item.eventPhotoUrl,
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
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.deepPurple,
                ),
                onPressed: () {
                  _deleteEvent(context, docId);
                })
          ],
        ),
        onTap: () {},
      ),
    );
  }

  Future<bool> _deleteEvent(BuildContext context, String docId) {
    return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text('Do you want to delete this Event?'),
            content: new Text('Deleted Events can not be restored!'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  cloudStoreHelper.deleteEvent(docId);
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
//          photoUrl = snapshot.data.documents[0]['photoUrl'];
//          displayName = snapshot.data.documents[0]['displayName'];
//          email = snapshot.data.documents[0]['email'];
//          age = snapshot.data.documents[0]['age'];
//          faculty = snapshot.data.documents[0]['faculty'];
//          displayName = snapshot.data.documents[0]['biography'];
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
                borderRadius: BorderRadius.circular(180),
                child: Container(
                  width: 180,
                  height: 180,
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
                    child: new Text(entity.faculty,
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
                    Icons.mail_outline,
                    color: Colors.white,
                    size: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(entity.email,
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
