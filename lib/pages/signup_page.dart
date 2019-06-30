import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/helper/authentication.dart';
import 'package:flutter_campus_connected/helper/cloud_firestore_helper.dart';
import 'package:flutter_campus_connected/utils/screen_aware_size.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  Auth auth = new Auth();

  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  FireCloudStoreHelper cloudhelper = new FireCloudStoreHelper();
  String _name;
  String _email;
  String _password;
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@hm.edu$',
  );
  AnimationController _animationController;
  Animation _animation;

  // Initial form is login form
  bool _isLoading;

  //while creating account it will show
  Widget _showCircularProgressIndicator() {
    if (_isLoading) {
      return Container(
        margin: EdgeInsets.all(10),
        width: 25,
        height: 25,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  //for showing response we get from firebase auth
  void _showSnackBar(String msg) {
    SnackBar snackBar = new SnackBar(
      content: new Text(
        msg,
        style: TextStyle(color: Colors.white),
      ),
      duration: new Duration(seconds: 2),
      backgroundColor: Colors.black,
      action: SnackBarAction(
          label: "Undo", textColor: Colors.white, onPressed: () {}),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.red, Colors.redAccent])),
          child: Container(
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Align(
                  child: _showCircularProgressIndicator(),
                  alignment: Alignment.bottomCenter,
                ),
                Positioned(
                    width: MediaQuery.of(context).size.width - 30,
                    top: MediaQuery.of(context).size.height * 0.20,
                    child: _showBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      FocusScope.of(context).requestFocus(new FocusNode()); //keyboard close
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    if (_validateAndSave()) {
      setState(() {
        _isLoading = true;
      });
      FirebaseUser user;
      try {
        user = await auth.signUp(_email, _password);
        auth.sendEmailVerification();
        if (user != null) {
          var userUpdateInfo = new UserUpdateInfo();
          userUpdateInfo.displayName = _name;
          userUpdateInfo.photoUrl =
              'https://fertilitynetworkuk.org/wp-content/uploads/2017/01/Facebook-no-profile-picture-icon-620x389.jpg';
          await user.updateProfile(userUpdateInfo);
          auth.getCurrentUser().then((currentUser) async {
            if (currentUser != null) {
              var result = await cloudhelper.storeNewUser(currentUser);
              if (result) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
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
                              padding:
                                  EdgeInsets.all(screenAwareSize(8.0, context)),
                              child: Text(
                                'Yeah, you have successfully created an account. ',
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
                                  Navigator.of(context)
                                      .pushReplacementNamed('/login');
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
          });
        }
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        if (e.toString().contains('PlatformException')) {
          print('Error: $e');
          setState(() {
            _isLoading = false;
            if (e.toString().contains('ERROR_EMAIL_ALREADY_IN_USE')) {
              _showSnackBar(
                  'The email address is already in use by another account.');
            } else if (e.toString().contains('ERROR_INVALID_EMAIL')) {
              _showSnackBar('The email address is badly formatted.');
            } else {
              _showSnackBar(e.toString());
            }
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _animationController = new AnimationController(
        vsync: this, duration: Duration(microseconds: 1000));
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _showBody() {
    return Container(
        child: new Form(
      key: _formKey,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              child: Text(
                'SIGN UP',
                style: TextStyle(fontSize: screenAwareSize(30, context)),
              ),
              padding: EdgeInsets.all(20),
            ),
            _showNameInput(),
            _showEmailInput(),
            _showPasswordInput(),
            SizedBox(height: screenAwareSize(20, context)),
            _showPrimaryButton(context),
            SizedBox(height: screenAwareSize(20, context)),
            _showSecondaryButton(),
          ],
        ),
      ),
    ));
  }

  //user email
  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 10),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            contentPadding: EdgeInsets.all(0.0),
            filled: true,
            labelText: 'Email',
            fillColor: Colors.white,
            prefixIcon: new Icon(
              Icons.mail,
            )),
        validator: (value) {
          if (value.isEmpty) {
            return 'Email can\'t be empty';
          } else if (!_emailRegExp.hasMatch(value)) {
            return 'Invalid Email. Try "example@hm.edu"';
          }
        },
        onSaved: (value) => _email = value,
      ),
    );
  }

// user name
  Widget _showNameInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 10),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            contentPadding: EdgeInsets.all(0.0),
            filled: true,
            labelText: 'Name',
            fillColor: Colors.white,
            prefixIcon: new Icon(
              Icons.person,
            )),
        validator: (value) {
          if (value.isEmpty) {
            return 'Name can\'t be empty';
          }
        },
        onSaved: (value) => _name = value,
      ),
    );
  }

//  user password
  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            filled: true,
            labelText: 'Password',
            contentPadding: EdgeInsets.all(0.0),
            fillColor: Colors.white,
            prefixIcon: new Icon(
              Icons.lock,
            )),
        validator: (value) {
          if (value.isEmpty) {
            return 'Password can\'t be empty';
          } else if (value.length < 6) {
            return 'Password can\'t be less than 6 character';
          }
        },
        onSaved: (value) => _password = value,
      ),
    );
  }

  //for navigate to login page
  Widget _showSecondaryButton() {
    return Align(
      child: FlatButton(
        child: new Text('Already have an account? Sign in',
            style: new TextStyle(
                fontSize: screenAwareSize(16, context),
                fontWeight: FontWeight.w500,
                color: Colors.black)),
        onPressed: () {
          Navigator.of(context).pushNamed('/login');
        },
      ),
      alignment: Alignment.bottomCenter,
    );
  }

  // submit button
  Widget _showPrimaryButton(context) {
    return SizedBox(
      width: screenAwareSize(200, context),
      height: screenAwareSize(40, context),
      child: RaisedButton(
        elevation: 8.0,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        color: _isLoading == false ? Colors.red : Colors.redAccent,
        child: new Text('CREATE ACCOUNT',
            style: new TextStyle(
                fontSize: screenAwareSize(16, context), color: Colors.white)),
        onPressed: _isLoading == false ? _validateAndSubmit : () {},
      ),
    );
  }
}
