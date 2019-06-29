import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/helper/authentication.dart';
import 'package:flutter_campus_connected/logos/login_logo.dart';
import 'package:flutter_campus_connected/pages/welcome_page.dart';
import 'package:flutter_campus_connected/utils/screen_aware_size.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  Auth auth = new Auth();

  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@hm.edu$',
  );
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  //it will show when procesing to login
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

  //for showing response we will from the firebase
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
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Align(
                child: _showCircularProgressIndicator(),
                alignment: Alignment.bottomCenter,
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.12,
                  child: _showLogo()),
              Positioned(
                  width: MediaQuery.of(context).size.width - 30,
                  top: MediaQuery.of(context).size.height * 0.35,
                  child: _showBody()),
            ],
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

  // Perform login
  void _validateAndSubmit() async {
    if (_validateAndSave()) {
      setState(() {
        _isLoading = true;
      });
      String userId = "";
      try {
        if (_email.isNotEmpty) {
          await auth.sendPasswordResetEmail(_email);
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
                        'Password Reset',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: screenAwareSize(26, context)),
                      ),
                      SizedBox(height: screenAwareSize(10, context)),
                      Padding(
                        padding: EdgeInsets.all(screenAwareSize(8.0, context)),
                        child: Text(
                          'A Link has been sent to your email adress with further instructions',
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
                                .popUntil(ModalRoute.withName('/login'));
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
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {}
      } catch (e) {
        if (e.toString().contains('PlatformException')) {
          print('Error: $e');
          setState(() {
            _isLoading = false;
            if (e.toString().contains('ERROR_USER_NOT_FOUND')) {
              _showSnackBar('Email adress or password is invalid');
            } else {
              _showSnackBar(e.toString());
            }
          });
        }
      }
    }
  }

  //White Card
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
            SizedBox(height: screenAwareSize(20, context)),
            _showEmailInput(),
            SizedBox(height: screenAwareSize(20, context)),
            _showPrimaryButton(context),
            SizedBox(height: screenAwareSize(20, context)),
            _showSecondaryButton(),
          ],
        ),
      ),
    ));
  }

  //app Logo
  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: LoginLogo(
        size: screenAwareSize(100, context),
      ),
    );
  }

//user email
  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 10),
      child: TextFormField(
        key: Key("Email"),
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
            return 'Invalid Email. Try example@hm.edu';
          }
        },
        onSaved: (value) => _email = value,
      ),
    );
  }

//login button
  Widget _showPrimaryButton(context) {
    return SizedBox(
      width: screenAwareSize(200, context),
      height: screenAwareSize(40, context),
      child: RaisedButton(
        key: Key("reset_password"),
        elevation: 8.0,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        color: _isLoading == false ? Colors.red : Colors.redAccent,
        child: new Text('Reset Password',
            style: new TextStyle(
                fontSize: screenAwareSize(18, context), color: Colors.white)),
        onPressed: _isLoading == false ? _validateAndSubmit : null,
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
}
