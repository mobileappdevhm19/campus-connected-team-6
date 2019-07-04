import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/models/user_entity.dart';
import 'package:flutter_campus_connected/pages/users_profile.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

void main() {
  group('usersProfile test', () {
    test('UserEntity test', () {
      final entity = UserEntity('test', 'test.png', 'test@test.com', '25',
          'FK 07', 'HM Student living in Munich', null);
      expect(entity, isNotNull);
      expect(entity.photoUrl, isNotEmpty);
      expect(entity.email, isNotEmpty);
      expect(entity.displayName, isNotEmpty);
      expect(entity.data, isNull);
    });

    testWidgets('widgets test', (WidgetTester tester) async {
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

      var findListView = find.ancestor(
          of: find.byType(StreamBuilder), matching: find.byType(ListView));
      expect(findListView, findsNothing);

      final entity = UserEntity('test', 'test.png', 'test@test.com', '25',
          'FK 07', 'HM Student living in Munich', null);
      var item = state.getItemList(entity, 1, context);
      expect(item != null, true);

      state.tapOnItem(context, entity);
      expect(state != null, true);

      var wait = state.getWaiting();
      expect(wait, isNotNull);

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
  });
}
