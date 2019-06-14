import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/users_profile.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

void main() {
  testWidgets('usersProfile test', (WidgetTester tester) async {
    var usersProfile = UsersProfile();
    var curr = TestHelper.buildPage(usersProfile);
    await tester.pumpWidget(curr);

    final search = find.text('Search...');
    expect(search, findsOneWidget);

    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    final texts = find.byType(Text);
    expect(texts, findsWidgets);
  });
}
