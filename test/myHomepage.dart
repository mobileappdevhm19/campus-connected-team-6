import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'testHelper.dart';

void main() {
  testWidgets('Myhome Test', (WidgetTester tester) async {
    var myHomePage = MyHomePage();
    var curr = TestHelper.buildPage(myHomePage);
    await tester.pumpWidget(curr);
    await tester.tap(find.byIcon(Icons.home));
    await tester.tap(find.byIcon(Icons.search));
    await tester.tap(find.byIcon(Icons.event));
  });
}
