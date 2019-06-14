import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/users_profile.dart';
import 'package:flutter_test/flutter_test.dart';

import 'testHelper.dart';

void main() {
  testWidgets('usersProfile test', (WidgetTester tester) async {
    final String searchStr = 'Search...';

    final StatefulWidget usersProfile = UsersProfile();

    var curr = TestHelper.buildPage(usersProfile);
    await tester.pumpWidget(curr);

    //state test

    final UsersProfileState state = tester.state(find.byType(UsersProfile));
    expect(state.widget, equals(usersProfile));

    var resSearch = state.initialSearch('');
    expect(resSearch, equals(null));
    expect(state.tempSearchStore.length, 0);
    expect(state.queryResultSet.length, 0);

    resSearch = state.initialSearch('111');
    expect(resSearch, equals(null));
    expect(state.tempSearchStore.length, 0);
    expect(state.queryResultSet.length, 0);

    var list = state.usersProfileList();
    expect(list != null, true);

    final BuildContext context = tester.element(find.text(searchStr));

    final appBar = state.appBar(context);
    expect(appBar != null, true);

    state.build(context);
    expect(state != null, true);
    try {
      state.streamBuilder(context, null);
    } catch (e) {}

    //widget test
    final search = find.text(searchStr);
    expect(search, findsOneWidget);

    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    final texts = find.byType(Text);
    expect(texts, findsWidgets);

    final box = find.byType(Container);
    expect(box, findsWidgets);

    final bt = find.byType(IconButton);
    expect(bt, findsOneWidget);

    await tester.tap(bt);
    await tester.pump();
  });
}
