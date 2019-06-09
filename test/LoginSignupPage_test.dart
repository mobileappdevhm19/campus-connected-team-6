import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/login_signup_page.dart';
import 'package:flutter_test/flutter_test.dart';

import 'testHelper.dart';

void main() {
  testWidgets("Login wird getestet", (WidgetTester tester) async {
    await tester.pumpWidget(TestHelper.buildPage(LoginSignUpPage()));

    //await tester.pump(new Duration(seconds: 1));

    final widget = find.byType(Image);
    expect(widget, findsOneWidget);

    final textLogin = find.text('Campus-Connected login');
    expect(textLogin, findsOneWidget);

    //final findIcon = find.byIcon(InputDecoration);

    final testCircle = find.byType(CircleAvatar);
    expect(testCircle, findsOneWidget);

    final buttonFlat = find.byType(FlatButton);
    expect(buttonFlat, findsOneWidget);

    final buttonRaised = find.byType(RaisedButton);
    expect(buttonRaised, findsOneWidget);

    final testHero = find.byType(Hero);
    expect(testHero, findsOneWidget);
  });
}
