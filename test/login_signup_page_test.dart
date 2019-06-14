// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/login_signup_page.dart';

import 'package:flutter_test/flutter_test.dart';

import 'testHelper.dart';

void main() {
  testWidgets("Login Page wird getestet", (WidgetTester tester) async {
    await tester.pumpWidget(TestHelper.buildPage(LoginSignUpPage()));

    await tester.pump(new Duration(seconds: 1));

    final widget = find.byType(Image);
    expect(widget, findsOneWidget);

    final flatButton = find.byType(FlatButton);
    expect(flatButton, findsOneWidget);

    final textFlatButton = find.text('Create an account');
    expect(textFlatButton, findsOneWidget);

    final raisedButton = find.byType(RaisedButton);
    expect(raisedButton, findsOneWidget);

    final textRaisedButton = find.text('Login');
    expect(textRaisedButton, findsOneWidget);


  });
}
