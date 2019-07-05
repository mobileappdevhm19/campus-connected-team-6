import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/models/user_model.dart';
import 'package:flutter_campus_connected/services/authentication.dart';
import 'package:flutter_campus_connected/helper/cloud_firestore_helper.dart';
import 'package:flutter_campus_connected/utils/screen_aware_size.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final userInfo;
  final UserModel userEntity;

  //final photoUrl;
  //final displayName;
  final FireCloudStoreHelper cloudStoreHelper;

  EditProfile({
    this.userInfo,
    this.userEntity,
    this.cloudStoreHelper,
  });

  @override
  EditProfileState createState() => EditProfileState(cloudStoreHelper);
}

class EditProfileState extends State<EditProfile> {
  var _formState = new GlobalKey<FormState>();
  Auth auth = new Auth();
  File sampleImage;
  UserModel entity;

  bool uploadingStatus = false;
  bool imageRequired = false;

  // Event Dropdown Categories list
  static var _categories = [
    "FK 01",
    "FK 02",
    "FK 03",
    "FK 04",
    "FK 05",
    "FK 06",
    "FK 07",
    "FK 08",
    "FK 09",
    "FK 10",
    "FK 11",
    "FK 12",
    "FK 13",
    "FK 14",
  ];

  //selected dropdown value will be save here
  var dropdownValue;

  final FireCloudStoreHelper cloudStoreHelper;

  EditProfileState(this.cloudStoreHelper);

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
        entity.photoUrl = getDownloadURL;
        uploadingStatus = false;
      });
    });
  }

  void submitForm() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    var connectionStatus = await checkInternetConnection();
    if (connectionStatus == false) {
      _showInternetAlertDialogue();
      return;
    }
    if (entity.photoUrl == null) {
      setState(() {
        imageRequired = true;
      });
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          imageRequired = false;
        });
      });
    }

    if (_formState.currentState.validate() && entity.photoUrl != null) {
      await saveForm();
      Navigator.of(context).pop();
    }
    //Navigator.pop(context);
  }

  Future saveForm() async {
    setState(() {
      uploadingStatus = true;
    });
    _formState.currentState.save();
    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = entity.displayName;
    userUpdateInfo.photoUrl = entity.photoUrl;
    await widget.userInfo.updateProfile(userUpdateInfo);
    await cloudStoreHelper.updateUser(widget.userInfo, entity);

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
    super.initState();
    entity = widget.userEntity;
  }

  void _showInternetAlertDialogue() {
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
                color: Colors.black87, fontSize: screenAwareSize(26, context)),
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
          //color: Colors.red,
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
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
                          padding: const EdgeInsets.only(top: 12.0),
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
                  ageTextForm(context),
                  SizedBox(
                    height: screenAwareSize(15, context),
                  ),
                  //facultyTextForm(context),
                  facultyCategoryDropdown(),
                  SizedBox(
                    height: screenAwareSize(15, context),
                  ),
                  biographyTextForm(context),
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
      //backgroundColor: Colors.red,
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
      title: Text('Edit Profile'),
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
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            width: 120,
            height: 120,
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
      initialValue: entity.displayName,
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
        entity.displayName = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Name can\'t be empty';
        }
      },
      maxLength: 30,
      maxLengthEnforced: true,
    );
  }

  //TODO: change to dropdown? or a picker like date and time?
  TextFormField ageTextForm(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      initialValue: entity.age,
      decoration: new InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenAwareSize(10, context)),
        ),
        contentPadding: EdgeInsets.all(0.0),
        labelText: 'Age',
        prefixIcon: const Icon(
          Icons.confirmation_number,
        ),
      ),
      onSaved: (value) {
        entity.age = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Age can\'t be empty';
        } else if (int.parse(value) <= 0) {
          return 'Invalid Age. Please choose a valid Age';
        }
      },
      maxLength: 2,
      maxLengthEnforced: true,
    );
  }

  FormField facultyCategoryDropdown() {
    return FormField<String>(
      initialValue: entity.faculty.isEmpty ? null : entity.faculty,
      validator: (value) {
        if (value == null) {
          return "Select Event Category";
        }
      },
      onSaved: (value) {
        entity.faculty = value;
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
                    Icons.school,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: screenAwareSize(8, context),
                  ),
                  Expanded(
                    flex: 9,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          iconEnabledColor: Colors.red,
                          hint: Text(entity.faculty),
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

  TextFormField biographyTextForm(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      initialValue: entity.biography,
      decoration: new InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenAwareSize(10, context)),
          ),
          contentPadding: EdgeInsets.all(10.0),
          labelText: 'My Biography',
          prefixIcon: const Icon(
            Icons.library_books,
          ),
          alignLabelWithHint: true),
      onSaved: (value) {
        entity.biography = value;
      },
      validator: (value) {},
      maxLengthEnforced: true,
      maxLength: 100,
      maxLines: null,
    );
  }
}
