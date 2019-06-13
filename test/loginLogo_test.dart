// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/logos/login_logo.dart';

import 'package:flutter_test/flutter_test.dart';


import 'testHelper.dart';

void main() {
  testWidgets("Login Logo wird getestet", (WidgetTester tester) async {
    await tester.pumpWidget(TestHelper.buildPage(LoginLogo()));

    await tester.pump(new Duration(seconds: 1));

    final widget = find.byType(Image);
    expect(widget, findsOneWidget);
  });
}
