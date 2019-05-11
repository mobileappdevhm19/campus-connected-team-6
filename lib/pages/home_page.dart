import 'package:flutter/material.dart';
import 'package:flutter_login_demo/models/myevent.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Myevent> _myEventList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();

  StreamSubscription<Event> _onEventAddedSubscription;
  StreamSubscription<Event> _onEventChangedSubscription;

  Query _eventQuery;

  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();

    _checkEmailVerification();

    _myEventList = new List();
    _eventQuery = _database
        .reference()
        .child("myevent")
        .orderByChild("userId")
        .equalTo(widget.userId);

    _onEventAddedSubscription =
        _eventQuery.onChildAdded.listen(_onEntryAddedEvent);
    _onEventChangedSubscription =
        _eventQuery.onChildChanged.listen(_onEntryChangedEvent);
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _onEventAddedSubscription.cancel();
    _onEventChangedSubscription.cancel();
    super.dispose();
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  _onEntryChangedEvent(Event event) {
    var oldEntryevent = _myEventList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      _myEventList[_myEventList.indexOf(oldEntryevent)] =
          Myevent.fromSnapshot(event.snapshot);
    });
  }

  _onEntryAddedEvent(Event event) {
    setState(() {
      _myEventList.add(Myevent.fromSnapshot(event.snapshot));
    });
  }

  _addNewEvent(String eventItem) {
    if (eventItem.length > 0) {
      Myevent myevent =
          new Myevent(eventItem.toString(), "name", widget.userId, 1);
      _database.reference().child("myevent").push().set(myevent.toJson());
    }
  }

  _updateEvent(Myevent myevent) {
    //Toggle completed
    if (myevent != null) {
      _database
          .reference()
          .child("myevent")
          .child(myevent.key)
          .set(myevent.toJson());
    }
  }

  _deleteEvent(String eventId, int index) {
    _database.reference().child("myevent").child(eventId).remove().then((_) {
      print("Delete $eventId successful");
      setState(() {
        _myEventList.removeAt(index);
      });
    });
  }

  _showDialog(BuildContext context) async {
    _textEditingController.clear();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                  controller: _textEditingController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Add new todo',
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Save'),
                  onPressed: () {
                    _addNewEvent(_textEditingController.text.toString());
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  Widget _showEventList() {
    if (_myEventList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _myEventList.length,
          itemBuilder: (BuildContext context, int index) {
            String eventId = _myEventList[index].key;
            String category = _myEventList[index].category;
            String eventname = _myEventList[index].eventname;
            int counter = _myEventList[index].counter;
            String userId = _myEventList[index].userId;
            return Dismissible(
              key: Key(eventId),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                _deleteEvent(eventId, index);
              },
              child: ListTile(
                title: Text(
                  category,
                  style: TextStyle(fontSize: 20.0),
                ),
                trailing: IconButton(
                    icon: (false)
                        ? Icon(
                            Icons.done_outline,
                            color: Colors.green,
                            size: 20.0,
                          )
                        : Icon(Icons.done, color: Colors.grey, size: 20.0),
                    onPressed: () {
                      _updateEvent(_myEventList[index]);
                    }),
              ),
            );
          });
    } else {
      return Center(
          child: Text(
        "Welcome to CC",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Campus-Connected'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: _signOut)
          ],
        ),
        body: _showEventList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showDialog(context);
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ));
  }
}
