import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/users_profile.dart';
import 'package:flutter_test/flutter_test.dart';

import 'testHelper.dart';

void main() {
  testWidgets('usersProfile test1', (WidgetTester tester) async {

    final StatefulWidget usersProfile = UsersProfile();

    var curr = TestHelper.buildPage(usersProfile) ;
    await tester.pumpWidget(curr);

    final UsersProfileState state = tester.state(find.byType(UsersProfile));
    expect(state.widget, equals(usersProfile));

    var resSearch = state.initialSearch('');
    expect (resSearch, equals(null));
    expect(state.tempSearchStore.length, 0);

    final search = find.text('Search...');
    expect(search, findsOneWidget);

    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    final texts = find.byType(Text);
    expect(texts, findsWidgets);

  });
}