import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/dashboard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'testHelper.dart';

void main() {
  testWidgets('profile test', (WidgetTester tester) async {
    var profilePage = Dashboard();
    var curr = TestHelper.buildPage(profilePage);
    await tester.pumpWidget(curr);

    final drawer = find.byTooltip('Open navigation menu');
    expect(drawer, findsWidgets);
  });
}
