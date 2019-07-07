import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/privacy_policy.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

void main() {
  testWidgets("Privacy Plicy Page wird getestet", (WidgetTester tester) async {
    await tester.pumpWidget(TestHelper.buildPage(PrivacyPolicy()));

    final textFAQ = find.text("Privacy Policy");
    expect(textFAQ, findsOneWidget);

    final iconArrowBack = find.byIcon(Icons.arrow_back_ios);
    expect(iconArrowBack, findsOneWidget);

    final container = find.byType(Container);
    expect(container, findsWidgets);

    final safeArea = find.byType(SafeArea);
    expect(safeArea, findsWidgets);

    final appBar = find.byType(AppBar);
    expect(appBar, findsWidgets);
  });
}
