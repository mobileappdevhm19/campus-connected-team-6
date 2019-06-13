// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/splash_screen.dart';

import 'package:flutter_test/flutter_test.dart';



import 'testHelper.dart';

void main() {
  testWidgets("Splash Screen wird getestet", (WidgetTester tester) async {

    await tester.pumpWidget(TestHelper.buildPage(SplashScreen()));

    await tester.pump(new Duration(seconds: 4));

    final widget = find.byType(Image);
    expect(widget, findsOneWidget);

    final circleAva = find.byType(CircleAvatar);
    expect (circleAva, findsOneWidget);

    final textCampus = find.text("CAMPUS Connected");
    expect(textCampus, findsOneWidget);


    final background = tester.firstWidget(find.byType(Container)) as Container;
    expect((background.decoration as BoxDecoration).color, Color(0xFFB71C1C));






  });
}
