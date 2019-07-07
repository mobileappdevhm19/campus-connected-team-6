import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/models/user_model.dart';
import 'package:flutter_campus_connected/services/authentication.dart';
import 'package:flutter_campus_connected/helper/cloud_firestore_helper.dart';
import 'package:flutter_campus_connected/utils/screen_aware_size.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
  final String _photoUrl =
      'https://fertilitynetworkuk.org/wp-content/uploads/2017/01/Facebook-no-profile-picture-icon-620x389.jpg';
  String _email;
  String _password;
  String _age;
  String _faculty;
  String _confirmPassword; //only for compare purpose
  bool isChecked = false;
  bool _termsChecked = false;

  UserModel _userModel;
  Widget _md;

  final String _termsAndConditionMarkdownData = """## Terms & Conditions

By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy, or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages, or make derivative versions. The app itself, and all the trade marks, copyright, database rights and other intellectual property rights related to it, still belong to Junior Contreras, Saif Sliti, Nihan Danis, Tamara Isaeva.

Junior Contreras, Saif Sliti, Nihan Danis, Tamara Isaeva is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for.

The Campus Connected app stores and processes personal data that you have provided to us, in order to provide my Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the Campus Connected app won’t work properly or at all.

You should be aware that there are certain things that Junior Contreras, Saif Sliti, Nihan Danis, Tamara Isaeva will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi, or provided by your mobile network provider, but Junior Contreras, Saif Sliti, Nihan Danis, Tamara Isaeva cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left.

If you’re using the app outside of an area with Wi-Fi, you should remember that your terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be aware that we assume that you have received permission from the bill payer for using the app.

Along the same lines, Junior Contreras, Saif Sliti, Nihan Danis, Tamara Isaeva cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you can’t turn it on to avail the Service, Junior Contreras, Saif Sliti, Nihan Danis, Tamara Isaeva cannot accept responsibility.

With respect to Junior Contreras, Saif Sliti, Nihan Danis, Tamara Isaeva’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavour to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. Junior Contreras, Saif Sliti, Nihan Danis, Tamara Isaeva accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app.

At some point, we may wish to update the app. The app is currently available on Android & iOS – the requirements for both systems (and for any additional systems we decide to extend the availability of the app to) may change, and you’ll need to download the updates if you want to keep using the app. Junior Contreras, Saif Sliti, Nihan Danis, Tamara Isaeva does not promise that it will always update the app so that it is relevant to you and/or works with the Android & iOS version that you have installed on your device. However, you promise to always accept updates to the application when offered to you, We may also wish to stop providing the app, and may terminate use of it at any time without giving notice of termination to you. Unless we tell you otherwise, upon any termination, (a) the rights and licenses granted to you in these terms will end; (b) you must stop using the app, and (if needed) delete it from your device.

**Changes to This Terms and Conditions**

I may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Terms and Conditions on this page. These changes are effective immediately after they are posted on this page.

**Contact Us**

If you have any questions or suggestions about my Terms and Conditions, do not hesitate to contact me at campus.connected.hm@hm.edu.

This Terms and Conditions page was generated by [App Privacy Policy Generator](https://app-privacy-policy-generator.firebaseapp.com/)""";

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
      duration: new Duration(seconds: 5),
      backgroundColor: Colors.black,
      action: SnackBarAction(
          label: "OK",
          textColor: Colors.white,
          onPressed: () {
            _scaffoldKey.currentState.hideCurrentSnackBar();
          }),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Theme(
          data: ThemeData(
            primaryColor: Theme.of(context).primaryColor,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.red, Colors.redAccent])),
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
      ),
    );
  }

  // Check if form is valid before perform signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate() && _termsChecked) {
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
          userUpdateInfo.photoUrl = _photoUrl;
          await user.updateProfile(userUpdateInfo);
          auth.getCurrentUser().then((currentUser) async {
            if (currentUser != null) {
              _userModel = UserModel(
                  photoUrl: _photoUrl,
                  faculty: _faculty,
                  email: _email,
                  displayName: _name,
                  biography: "",
                  age: _age,
                  uid: currentUser.uid,
                  isEmailVerified: currentUser.isEmailVerified);

              var result = await cloudhelper.storeNewUser(_userModel);
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
                                'You have successfully created an account.',
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
              } else {
                _showSnackBar('Uknown Error by Account Registration');
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
    _md = Markdown(
      data: _termsAndConditionMarkdownData,
    );
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
            _showAgeInput(),
            _showFacultyCategoryDropdownInput(),
            _showEmailInput(),
            _showPasswordInput(),
            _showConfirmPasswordInput(),
            _showTermsAndConditionCheckbox(),
            _showTermsAndConditionButton(),
            SizedBox(height: screenAwareSize(20, context)),
            _showPrimaryButton(context),
            SizedBox(height: screenAwareSize(20, context)),
            _showSecondaryButton(),
          ],
        ),
      ),
    ));
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
        maxLength: 30,
        maxLengthEnforced: true,
        onSaved: (value) => _name = value.trim(),
      ),
    );
  }

  // user faculty
  Widget _showFacultyCategoryDropdownInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 10),
      child: FormField<String>(
        validator: (value) {
          if (value == null) {
            return "Select Event Category";
          }
        },
        onSaved: (value) => _faculty = value,
        builder: (
          FormFieldState<String> state,
        ) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: new Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
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
                            hint: Text("eg. FK 07"),
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
      ),
    );
  }

  // user age
  Widget _showAgeInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 10),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: new InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            contentPadding: EdgeInsets.all(0.0),
            filled: true,
            labelText: 'Age',
            fillColor: Colors.white,
            prefixIcon: new Icon(
              Icons.person,
            )),
        validator: (value) {
          if (value.isEmpty) {
            return 'Age can\'t be empty';
          } else if (value.contains(".")) {
            return "Only whole numbers allowed";
          }
          if (int.parse(value) > 100 || int.parse(value) < 16) {
            return 'Age should be over 16 years of old';
          }
        },
        onSaved: (value) => _age = value.trim(),
      ),
    );
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
        maxLength: 30,
        maxLengthEnforced: true,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  // user password
  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14, bottom: 10),
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
          _password = value; //for comparison with comfirmation password
        },
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _showConfirmPasswordInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            filled: true,
            labelText: 'Confirm Password',
            contentPadding: EdgeInsets.all(0.0),
            fillColor: Colors.white,
            prefixIcon: new Icon(
              Icons.lock,
            )),
        validator: (value) {
          if (value != _password) {
            return 'Please enter the same value again';
          } else if (value.isEmpty) {
            return 'Password can\'t be empty';
          } else if (value.length < 6) {
            return 'Password can\'t be less than 6 character';
          }
        },
        onSaved: (value) => _confirmPassword = value,
      ),
    );
  }

  Widget _showTermsAndConditionCheckbox() {
    return Container(
      child: CheckboxListTile(
        activeColor: Colors.red,
        title: Text(
          "I agree to the Terms and Conditions",
          style: TextStyle(fontSize: 12),
        ),
        value: _termsChecked,
        onChanged: (bool value) => setState(() => _termsChecked = value),
        subtitle: !_termsChecked
            ? Padding(
                padding: EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                child: Text(
                  'Required field',
                  style: TextStyle(color: Color(0xFFe53935), fontSize: 12),
                ),
              )
            : null,
      ),
    );
  }

  Widget _showTermsAndConditionButton() {
    return FlatButton(
        child: Text(
          "Read Terms and Conditions",
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
        onPressed: () {
          _showInternetAlertDialogue();
        });
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

  void _showInternetAlertDialogue() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return getAlertDialog(context);
        });
  }

  SingleChildScrollView getAlertDialog(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        content: Column(
          children: <Widget>[
            Text(_termsAndConditionMarkdownData),
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
      ),
    );
  }
}
