import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/event_users_list.dart';

import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

void main() {
  testWidgets("Password Reset Page wird getestet", (WidgetTester tester) async {
    await tester.pumpWidget(TestHelper.buildPage(EventUsersList()));



    final iconArrow = find.byIcon(Icons.arrow_back_ios);
    expect(iconArrow, findsOneWidget);


    final textOne = find.text("Interested People");
    expect(textOne, findsOneWidget);



  });
}