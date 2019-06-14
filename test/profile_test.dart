import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'testHelper.dart';

void main() {
  testWidgets('profile test', (WidgetTester tester) async {

    var profilePage = ProfilePage(firebaseUser: null,);
    var curr = TestHelper.buildPage(profilePage) ;
    await tester.pumpWidget(curr);

    final editText = find.text('Edit');
    expect(editText, findsOneWidget);

    final myEvents = find.text('My Events');
    expect(myEvents, findsOneWidget);

    final testCircle = find.byType(Text);
    expect(testCircle, findsWidgets);

  });
}