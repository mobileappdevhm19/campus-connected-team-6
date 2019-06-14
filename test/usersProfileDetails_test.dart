import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/usersProfileDetails.dart';
import 'package:flutter_test/flutter_test.dart';
import 'testHelper.dart';

void main() {
  testWidgets('UsersProfileDetails test', (WidgetTester tester) async {
    var editPage = UsersProfileDetails(details: null);
    var curr = TestHelper.buildPage(editPage);
    await tester.pumpWidget(curr);

    final myEvents = find.text('My Events') ;
    expect(myEvents, findsOneWidget);

    final text = find.byType(Text);
    expect(text, findsWidgets);

  });
}