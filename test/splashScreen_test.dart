// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_login_demo/main.dart';

import 'package:flutter_login_demo/pages/splash_screen.dart';

import 'testHelper.dart';

void main() {
  testWidgets("Splash Screen wird getestet", (WidgetTester tester) async {
    await tester.pumpWidget(TestHelper.buildPage(ImageSplashScreen()));

    await tester.pump(new Duration(seconds: 1));

    final widget = find.byType(Image);
    expect(widget, findsOneWidget);
  });
}
