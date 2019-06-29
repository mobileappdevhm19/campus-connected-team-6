import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/faq_page.dart';

import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

void main() {
  testWidgets("Welcome Page wird getestet", (WidgetTester tester) async {
    await tester.pumpWidget(TestHelper.buildPage(FAQPage()));

    final textFAQ = find.text("FAQ");
    expect(textFAQ, findsOneWidget);

    final iconArrowBack = find.byIcon(Icons.arrow_back_ios);
    expect(iconArrowBack, findsOneWidget);

    final box = find.byType(Container);
    expect(box, findsWidgets);





  });
}
