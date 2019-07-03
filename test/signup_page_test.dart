// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/signup_page.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

void main() {
  testWidgets("Signup Page wird getestet", (WidgetTester tester) async {
    await tester.pumpWidget(TestHelper.buildPage(SignUpPage()));

    await tester.pump(new Duration(seconds: 4));

    final findIconLock = find.byIcon(Icons.lock);
    final findIconPerson = find.byIcon(Icons.person);

    expect(findIconLock, findsNWidgets(2));
    expect(findIconPerson, findsOneWidget);

    final boxDecoration =
        tester.firstWidget(find.byType(Container)) as Container;
    expect((boxDecoration.decoration as BoxDecoration).gradient,
        LinearGradient(colors: [Colors.red, Colors.redAccent]));

    //CircularProgressIndicator
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(const Center(
        child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    )));

    expect(tester.getSemantics(find.byType(CircularProgressIndicator)),
        matchesSemantics());
    handle.dispose();

    //FlatButton
    final Finder rawButtonMaterial = find.descendant(
      of: find.byType(FlatButton),
      matching: find.byType(Material),
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: FlatButton(
          onPressed: () {},
          child: new Text(
            'Already have an account? Sign in',
          ),
        ),
      ),
    );

    Material material = tester.widget<Material>(rawButtonMaterial);
    expect(material.textStyle.fontWeight, FontWeight.w500);
    //expect(material.textStyle.color, const Color(0xff000000));
    expect(material.color, null);
    expect(material.borderRadius, null);

    //Raised Button
  });
}
