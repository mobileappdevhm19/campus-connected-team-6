import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_campus_connected/services/authentication.dart';
import 'package:flutter_campus_connected/helper/cloud_firestore_helper.dart';
import 'package:flutter_campus_connected/models/event_model.dart';
import 'package:flutter_campus_connected/utils/screen_aware_size.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateEvent extends StatefulWidget {
  final FirebaseUser currentUser;

  CreateEvent({this.currentUser});

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  var _formState = new GlobalKey<FormState>();
  Auth auth = new Auth();
  File sampleImage;
  String imageUrl;
  bool uploadingStatus = false;
  bool imageRequired = false;
  EventModel eventModel = new EventModel();
  FireCloudStoreHelper cloudStoreHelper = new FireCloudStoreHelper();

  // Event Dropdown Categories list
  static var _categories = [
    "🎭 Stage & Theatre",
    "🎵 Music & Concerts",
    "🎤 Lectures & Readings",
    "🏋️ Sport & Fitness",
    "🎉 Party & Club",
    "👪 Children & Familiy",
  ]; //TODO add more categories

  //selected dropdown value will be save here
  var dropdownValue;

  // For Checking Internet Connection
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  //Image Pickup from gallery
  Future getImage() async {
    var connectionStatus = await checkInternetConnection();

    if (connectionStatus == false) {
      _showInternetAlertDialogue();
      return;
    }
    var tempImage = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    setState(() {
      sampleImage = tempImage;
    });
    if (sampleImage != null) {
      uploadImage();
    }
  }

//uploading picture on firebase storage.
  uploadImage() async {
    setState(() {
      uploadingStatus = true;
    });
    var randomNo1 = Random().nextInt(10000).toString();
    var randomNo2 = Random().nextInt(10000).toString();
    var randomNo3 = Random().nextInt(10000).toString();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('eventImage-$randomNo1-$randomNo2-$randomNo3.jpg');

    final StorageUploadTask task = firebaseStorageRef.putFile(
      sampleImage,
    );

    task.onComplete.then((value) async {
      var getDownloadURL = await value.ref.getDownloadURL();
      setState(() {
        imageUrl = getDownloadURL;
        uploadingStatus = false;
        eventModel.eventPhotoUrl = imageUrl;
      });
    });
  }

  final formats = {
    InputType.date: DateFormat('dd-MM-yyyy'),
    InputType.time: DateFormat("H:mm"),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        uploadingStatus == true
            ? null
            : Navigator.of(context).pushReplacementNamed('/home');
      },
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.red,
          elevation: 0.0,
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
            ),
            color: Colors.white,
            onPressed: () {
              uploadingStatus == true
                  ? null
                  : Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          title: new Text('Create Event'),
        ),
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.red, Colors.red])),
                child: Center(
                  child: Form(
                      key: _formState,
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)),
                          elevation: 10,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  height: screenAwareSize(20, context),
                                ),
                                selectImageWidget(),
                                imageRequired == true
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: Text(
                                          'Please Upload Event Image',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: screenAwareSize(30, context),
                                ),
                                nameTextForm(context),
                                SizedBox(
                                  height: screenAwareSize(10, context),
                                ),
                                descriptionTextForm(context),
                                SizedBox(
                                  height: screenAwareSize(10, context),
                                ),
                                locationTextForm(context),
                                SizedBox(
                                  height: screenAwareSize(10, context),
                                ),
                                maximumLimitTextForm(context),
                                SizedBox(
                                  height: screenAwareSize(10, context),
                                ),
                                eventCategoryDropdown(),
                                SizedBox(
                                  height: screenAwareSize(10, context),
                                ),
                                eventDatePickerFormField(context),
                                SizedBox(
                                  height: screenAwareSize(10, context),
                                ),
                                eventTimePickerFormField(context),
                                SizedBox(
                                  height: screenAwareSize(10, context),
                                ),
                                submitButton(context)
                              ],
                            ),
                          ))),
                ),
              ),
              uploadingStatus
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black54,
                      ),
                      height: screenAwareSize(100, context),
                      width: screenAwareSize(200, context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            child: Text(
                              'Uploading Image',
                              style: TextStyle(color: Colors.white),
                            ),
                            padding: EdgeInsets.all(7),
                          ),
                          Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        ],
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  //will save value to databse
  void _submitForm() async {
    //check internet connection
    var connectionStatus = await checkInternetConnection();
    if (connectionStatus == false) {
      _showInternetAlertDialogue();
      return;
    }
    //will close the keyboard
    FocusScope.of(context).requestFocus(new FocusNode());
    if (imageUrl == null) {
      setState(() {
        imageRequired = true;
      });
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          imageRequired = false;
        });
      });
    }

    if (_formState.currentState.validate() && imageUrl != null) {
      if (eventModel.eventCategory == null) {
        eventModel.eventCategory = _categories[0];
      }
      _formState.currentState.save();
      eventModel.createdBy = widget.currentUser.uid;
      cloudStoreHelper.addEvents(eventModel);
      Navigator.of(context).pushNamed('/home');
      _formState.currentState.reset();
      _showPopUpMessage();
    }
  }

  //submit Button
  RaisedButton submitButton(BuildContext context) {
    return RaisedButton(
      elevation: 10,
      padding: EdgeInsets.only(
          right: screenAwareSize(50, context),
          left: screenAwareSize(50, context)),
      child: Text(
        'Create',
        style: TextStyle(
            color: Colors.white, fontSize: screenAwareSize(20, context)),
      ),
      color: Theme.of(context).primaryColor,
      onPressed: _submitForm,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  //Event Category dropdown
  eventCategoryDropdown() {
    return FormField<String>(
      validator: (value) {
        if (value == null) {
          return "Select Event Category";
        }
      },
      onSaved: (value) {
        eventModel.eventCategory = value;
      },
      builder: (
        FormFieldState<String> state,
      ) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.grey),
                  borderRadius:
                      BorderRadius.circular(screenAwareSize(10, context))),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(
                    Icons.category,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: screenAwareSize(8, context),
                  ),
                  Expanded(
                    flex: 9,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          hint: Text('Event Category'),
                          isDense: true,
                          value: dropdownValue,
                          items: _categories.map((String item) {
                            return DropdownMenuItem<String>(
                              child: Text(item),
                              value: item,
                            );
                          }).toList(),
                          onChanged: (value) {
                            state.didChange(value);
                            setState(() {
                              dropdownValue = value;
                            });
                          }),
                    ),
                  )
                ],
              ),
            ),
            state.hasError
                ? SizedBox(height: 5.0)
                : Container(
                    height: 0,
                  ),
            state.hasError
                ? Text(
                    state.errorText,
                    style: TextStyle(
                        color: Colors.redAccent.shade700, fontSize: 12.0),
                  )
                : Container(),
          ],
        );
      },
    );
  }

  //image widget
  Stack selectImageWidget() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            width: 120,
            height: 120,
            child: imageUrl == null
                ? Image.asset('assets/gallery.png')
                : CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                          'assets/person.jpg',
                          fit: BoxFit.cover,
                        ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.add_circle,
            size: 42,
            color: Colors.indigo,
          ),
          onPressed: getImage,
        )
      ],
    );
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
                      fontSize: screenAwareSize(26, context)),
                ),
                SizedBox(height: screenAwareSize(10, context)),
                Padding(
                  padding: EdgeInsets.all(screenAwareSize(8.0, context)),
                  child: Text(
                    'Please Check Internet Connection.',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: screenAwareSize(16, context)),
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

  //event Name textFromField
  TextFormField nameTextForm(BuildContext context) {
    return TextFormField(
      decoration: new InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenAwareSize(10, context)),
        ),
        contentPadding: EdgeInsets.all(0.0),
        labelText: 'Event Name',
        prefixIcon: const Icon(
          Icons.event,
        ),
      ),
      onSaved: (value) {
        eventModel.eventName = value;
      },
      maxLength: 30,
      maxLengthEnforced: true,
      validator: (value) {
        if (value.isEmpty) {
          return 'Event Name can\'t be empty';
        }
      },
    );
  }

  //event Description
  TextFormField descriptionTextForm(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      decoration: new InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenAwareSize(10, context)),
        ),
        contentPadding: EdgeInsets.all(0.0),
        labelText: 'Event Description',
        prefixIcon: const Icon(
          Icons.description,
        ),
      ),
      onSaved: (value) {
        eventModel.eventDescription = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Event Description can\'t be empty';
        }
      },
      maxLines: null,
      maxLength: 300,
      maxLengthEnforced: true,
    );
  }

  //event Location
  TextFormField locationTextForm(BuildContext context) {
    return TextFormField(
      decoration: new InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenAwareSize(10, context)),
        ),
        contentPadding: EdgeInsets.all(0.0),
        labelText: 'Event Location',
        prefixIcon: const Icon(
          Icons.location_city,
        ),
      ),
      onSaved: (value) {
        eventModel.eventLocation = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Event location can\'t be empty';
        }
      },
      maxLength: 30,
      maxLengthEnforced: true,
    );
  }

  //event maximum participant allowance
  TextFormField maximumLimitTextForm(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
      ],
      decoration: new InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenAwareSize(10, context)),
        ),
        contentPadding: EdgeInsets.all(0.0),
        labelText: 'Maximum Participant Limit',
        prefixIcon: const Icon(
          Icons.looks,
        ),
      ),
      onSaved: (value) {
        eventModel.maximumLimit = int.parse(value);
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Maximum Participant Limit can\'t be empty';
        } else if (int.parse(value) > 20) {
          return 'Max. Participants can be 20';
        }
      },
    );
  }

  //event date picker
  DateTimePickerFormField eventDatePickerFormField(BuildContext context) {
    var now = new DateTime.now();
    return DateTimePickerFormField(
      inputType: InputType.date,
      format: formats[InputType.date],
      editable: false,
      decoration: new InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenAwareSize(10, context)),
        ),
        contentPadding: EdgeInsets.all(0.0),
        labelText: 'Event Date',
        prefixIcon: const Icon(
          Icons.date_range,
        ),
      ),
      onSaved: (value) {
        var _dates = DateFormat('dd-MM-yyyy').format(value);
        eventModel.eventDate = _dates.toString();
      },
      //TODO: validator not quite working as wanted
      validator: (value) {
        DateTime input =
            DateTime.fromMillisecondsSinceEpoch(value.millisecondsSinceEpoch);
        if (value == null) {
          return 'Event Date can\'t be empty';
        } else if (input.isBefore(now)) {
          return 'Date is not valid. Please choose a date in the future';
        }
      },
    );
  }

  //event time picker
  DateTimePickerFormField eventTimePickerFormField(BuildContext context) {
    return DateTimePickerFormField(
      inputType: InputType.time,
      format: formats[InputType.time],
      editable: false,
      decoration: new InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenAwareSize(10, context)),
        ),
        contentPadding: EdgeInsets.all(0.0),
        labelText: 'Event Time',
        prefixIcon: const Icon(
          Icons.access_time,
        ),
      ),
      onSaved: (value) {
        var _time = DateFormat('H:mm').format(value);
        eventModel.eventTime = _time.toString();
      },
      validator: (value) {
        if (value == null) {
          return 'Event Time can\'t be empty';
        }
      },
    );
  }

  //this function should briefly show a message that you have created an event
  void _showPopUpMessage() {
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
                  'Congratulations🎉',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: screenAwareSize(26, context)),
                ),
                SizedBox(height: screenAwareSize(10, context)),
                Padding(
                  padding: EdgeInsets.all(screenAwareSize(8.0, context)),
                  child: Text(
                    'Yeah, you have successfully created an event. ',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: screenAwareSize(16, context)),
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
                      'OK',
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
