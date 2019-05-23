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
  List _categorys = ["Sport", "Education"];
  List<Color> _bottomNavlist = [

  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCategory;
  String selectedCategory;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();
  final _textEditingDescription = TextEditingController();
  final _textEditingLocation = TextEditingController();

  StreamSubscription<Event> _onEventAddedSubscription;
  StreamSubscription<Event> _onEventChangedSubscription;

  Query _eventQuery;

  bool _isEmailVerified = false;
  String _valuedate = '';
  String _valuetime = '';
  String date;
  int _currentIndexnav=0;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCategory = _dropDownMenuItems[0].value;

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

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String category in _categorys) {
      items.add(new DropdownMenuItem(
          value: category,
          child: new Text(category)
      ));
    }
    return items;
  }

  void changedDropDownItem(String selectedCategory) {
    print("Selected contry $selectedCategory, we are going to refresh the UI");
    setState(() {
      _currentCategory = selectedCategory;
    });
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

  _addNewEvent(String eventItem, String description, String category,
      String date, String location) {
    if (eventItem.length > 0) {
      Myevent myevent = new Myevent(
          eventItem.toString(), description, category, widget.userId, date,
          location);

      _database.reference().child("myevent").push().set(myevent.toJson());
    }
  }

  // ignore: unused_element
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


  // ignore: unused_element
  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2019),
        lastDate: new DateTime(2021)
    );

    TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: new TimeOfDay.now(),
    );
    if (picked != null) setState(() =>
    _valuedate = picked.toLocal().toString());
    if (pickedTime != null) setState(() => _valuetime = pickedTime.toString());
    var _value = _valuedate + _valuetime;

    date = _value;
  }

  _showDialog(BuildContext context) async {
    _textEditingController.clear();
    _textEditingDescription.clear();
    _textEditingLocation.clear();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: Column(
                    children: <Widget>[

                      new TextField(

                        controller: _textEditingController,
                        autofocus: true,
                        decoration: new InputDecoration(
                          labelText: 'Add new Event',
                        ),
                      ),

                      new Row(
                        children: <Widget>[
                          //   new Text("Category: "),
                          // new Container(
                          //  padding: new EdgeInsets.all(16.0),
                          //),
                          new Container(
                            width: 120.0,
                            /*
                            child :TextField(
                            onSubmitted: changedDropDownItem,
                              //controller: _currentCategory,
                              autofocus: true,
                              decoration: new InputDecoration(
                                labelText: 'Category',
                              ),
                            ),
                            */
                            child: Text('choose Category:'),

                          ),


                          new DropdownButton(
                            value: _currentCategory,
                            items: _dropDownMenuItems,
                            onChanged: changedDropDownItem,
                          )

                        ],
                      ),

                      new TextField(
                        controller: _textEditingDescription,
                        autofocus: true,
                        decoration: new InputDecoration(
                          labelText: 'Description',
                        ),
                      ),
                      new TextField(
                        controller: _textEditingLocation,
                        autofocus: true,
                        decoration: new InputDecoration(
                          labelText: 'Location',
                        ),
                      ),
                      new TextField(
                        onTap: _selectDate,
                        // controller: _textEditingLocation,
                        autofocus: true,
                        decoration: new InputDecoration(
                          labelText: 'Date',
                        ),
                      ),
/*
                      new Column(
                        children: <Widget>[
                          //new Text(_value),
                          new RaisedButton(onPressed: _selectDate, child: new Text('Click me'),),

                        ],


                      ),
*/


                    ],
                  ),
                )
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
                    _addNewEvent(
                        _currentCategory,
                        _textEditingController.text.toString(),
                        _textEditingDescription.text.toString(),

                        date,
                        _textEditingLocation.text.toString());
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndexnav = index;
      print("Selected index $_currentIndexnav,");
    });
  }

  Widget _bottomNavbar(){
    return BottomNavigationBar(

      currentIndex: 0, // this will be set when a new tab is tapped
      // new

      items: [
        BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: new Text('Home'),


        ),

        BottomNavigationBarItem(


          icon: new Icon(Icons.mail,color:Colors.red),
          title: new Text('Messages'),

        ),




        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile')
        )
      ],
      onTap: onTabTapped,


    );
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
            String userId = _myEventList[index].userId;
            String date = _myEventList[index].date;
            String location = _myEventList[index].location;

            return Dismissible(
                key: Key(eventId),
                background: Container(color: Colors.red),
                onDismissed: (direction) async {
                  _deleteEvent(eventId, index);
                },

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Column(
                    children: <Widget>[
                      new Card(
                          child: new Row(
                            children: <Widget>[
                              new Container(
                                child: Icon(Icons.category),
                                width: 68.0,
                                height: 68.0,
                              ),
                              Center(
                                child: Container(
                                  child: new Column(
                                    children: <Widget>[
                                      Text(
                                        category,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 25.0),
                                      ),
                                      Text(eventname,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 20.0)),
                                      Text(location,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 20.0)),
                                      Text(date.substring(0,10),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 20.0)),

                                    ],
                                  ),
                                ),),

                            ],
                          )),
                    ],
                  ),
                )

              /*
              child: ListTile(
                title: Text(
                  category,
                  style: TextStyle(fontSize: 20.0),
                ),
                */

              /*
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
                    */

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
      bottomNavigationBar: _bottomNavbar(),
      body: _showEventList(),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),

    );
  }
}
