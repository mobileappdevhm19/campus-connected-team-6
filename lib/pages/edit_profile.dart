import 'dart:io';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/helper/authentication.dart';
import 'package:flutter_campus_connected/helper/cloud_firestore_helper.dart';
import 'package:flutter_campus_connected/utils/screen_aware_size.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfile extends StatefulWidget {
  final userInfo;
  final photoUrl;
  final displayName;

  EditProfile({this.userInfo, this.photoUrl, this.displayName});

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  var _formState = new GlobalKey<FormState>();
  Auth auth = new Auth();
  File sampleImage;
  String name;
  String imageUrl;

  bool uploadingStatus = false;
  bool imageRequired = false;
  FireCloudStoreHelper cloudStoreHelper = new FireCloudStoreHelper();

  Future getImage() async {
    var connectionStatus = await checkInternetConnection();
    if (connectionStatus == false) {
      _showInternetAlertDialouge();
      return;
    }
    var tempImage = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    setState(() {
      sampleImage = tempImage;
    });
    if (sampleImage != null) {
      uploadImage();
    }
  }

  uploadImage() async {
    setState(() {
      uploadingStatus = true;
    });
    var randomNo1 = Random().nextInt(10000).toString();
    var randomNo2 = Random().nextInt(10000).toString();
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('eventImage-$randomNo1-$randomNo2.jpg');

    final StorageUploadTask task = firebaseStorageRef.putFile(
      sampleImage,
    );

    task.onComplete.then((value) async {
      var getDownloadURL = await value.ref.getDownloadURL();
      setState(() {
        imageUrl = getDownloadURL;
        uploadingStatus = false;
      });
    });
  }

  final formats = {
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("h:mma"),
  };

  void submitForm() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    var connectionStatus = await checkInternetConnection();
    if (connectionStatus == false) {
      _showInternetAlertDialouge();
      return;
    }
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
      await saveForm();
    }
  }

  Future saveForm() async {
    setState(() {
      uploadingStatus = true;
    });
    _formState.currentState.save();
    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = name;
    userUpdateInfo.photoUrl = imageUrl;
    await widget.userInfo.updateProfile(userUpdateInfo);
    await cloudStoreHelper.updateUser(widget.userInfo, name, imageUrl);

    setState(() {
      uploadingStatus = false;
    });
  }

  RaisedButton submitButton(BuildContext context) {
    return RaisedButton(
      key: Key('submitBt'),
      elevation: 10,
      padding: EdgeInsets.only(
          right: screenAwareSize(50, context),
          left: screenAwareSize(50, context)),
      child: Text(
        'Save',
        style: TextStyle(
            color: Colors.white, fontSize: screenAwareSize(20, context)),
      ),
      color: Theme.of(context).primaryColor,
      onPressed: uploadingStatus == false ? submitForm : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = widget.displayName;
    imageUrl = widget.photoUrl;
  }

  void _showInternetAlertDialouge() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return getAlertDialog(context);
        });
  }

  AlertDialog getAlertDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: screenAwareSize(10, context)),
          Text(
            'No Internet ðŸ˜ž',
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
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        uploadingStatus == true ? null : Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: appBar(context),
        body: getBody(context),
      ),
    );
  }

  Stack getBody(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          color: Colors.red,
          child: Center(
            child: SingleChildScrollView(
              child: getForm(context),
            ),
          ),
        ),
        uploadingStatus ? updatingDialog(context) : SizedBox(),
      ],
    );
  }

  Form getForm(BuildContext context) {
    return Form(
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
                  imageField(),
                  imageRequired == true
                      ? Padding(
                    padding:
                    const EdgeInsets.only(top: 12.0),
                    child: Text(
                      'Please Upload  Image',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                      : SizedBox(),
                  SizedBox(
                    height: screenAwareSize(30, context),
                  ),
                  nameTextForm(context),
                  SizedBox(
                    height: screenAwareSize(15, context),
                  ),
                  submitButton(context)
                ],
              ),
            )));
  }

  //appbar
  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red,
      elevation: 0.0,
      leading: new IconButton(
        icon: new Icon(
          Icons.arrow_back_ios,
        ),
        color: const Color(0xFFDDDDDD),
        onPressed: () {
          uploadingStatus == true ? null : Navigator.of(context).pop();
        },
      ),
      title: new Text('Edit Profile'),
    );
  }

  //updating dialog
  Container updatingDialog(BuildContext context) {
    return Container(
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
              'Updating...',
              style: TextStyle(color: Colors.white),
            ),
            padding: EdgeInsets.all(7),
          ),
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        ],
      ),
    );
  }

  //user image
  Stack imageField() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                width: 120,
                height: 120,
                child: Image.asset(
                  'assets/person.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                  width: 120,
                  height: 120,
                  child: Image(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  )),
            )
          ],
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

  //user name
  TextFormField nameTextForm(BuildContext context) {
    return TextFormField(
      initialValue: name,
      decoration: new InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenAwareSize(10, context)),
        ),
        contentPadding: EdgeInsets.all(0.0),
        labelText: 'Name',
        prefixIcon: const Icon(
          Icons.person,
        ),
      ),
      onSaved: (value) {
        name = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Name can\'t be empty';
        }
      },
    );
  }
}
