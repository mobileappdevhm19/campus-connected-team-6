import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/models/profile_item.dart';
import 'package:flutter_campus_connected/models/user_entity_add.dart';
import 'package:flutter_campus_connected/pages/profile.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

void main() {
  group('profile test', () {
    test('profileItem test', () {
      final entity = ProfileItem('test', 'test', 'test.png');
      expect(entity, isNotNull);
      expect(entity.eventDescription, isNotEmpty);
      expect(entity.eventName, isNotEmpty);
      expect(entity.eventPhotoUrl, isNotEmpty);

      expect(entity.eventName, equals('test'));
      expect(entity.eventPhotoUrl, equals('test.png'));
      expect(entity.eventDescription, 'test');
    });

    testWidgets('profile widget test', (WidgetTester tester) async {
      var profilePage = ProfilePage(firebaseUser: null);
      var curr = TestHelper.buildPage(profilePage);
      await tester.pumpWidget(curr);

      final editText = find.text('Edit');
      expect(editText, findsOneWidget);

      final myEvents = find.text('My Events');
      expect(myEvents, findsOneWidget);

      final testCircle = find.byType(Text);
      expect(testCircle, findsWidgets);

      final BuildContext context = tester.element(editText);

      //state
      final ProfilePageState state = tester.state(find.byType(ProfilePage));
      expect(state, isNotNull);
      expect(state.widget, equals(profilePage));

      final btEdit = state.getBtEdit(context);
      TestHelper.checkWidget<FlatButton>(btEdit);

      final body = state.getBody(context);
      TestHelper.checkWidget<Column>(body);

      final appBar = state.appBar(context);
      TestHelper.checkWidget<AppBar>(appBar);

      final userJ = state.userEvents();
      TestHelper.checkWidget<Expanded>(userJ);

      final entity = ProfileItem('test', 'test', 'test.png');
      var item = state.getItem(entity, 1, context, '1', null);

      TestHelper.checkWidget<Card>(item);

      UserEntityAdd entityAdd = UserEntityAdd(
          'test', 'test.png', 'test@test.com', '19', 'IT', 'sport');
      var userItem = state.getProfileItem(entityAdd, context);
      TestHelper.checkWidget<Column>(userItem);
    });
  });
}
