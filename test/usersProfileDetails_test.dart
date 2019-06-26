import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/models/event_entity.dart';
import 'package:flutter_campus_connected/models/user_entity.dart';
import 'package:flutter_campus_connected/pages/usersProfileDetails.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_helper.dart';

void main() {
  group('usersProfile test', () {
    test('EventEntity test', () {
      final event = EventEntity('test', 'test desc', 'test.png');
      expect(event, isNotNull);
      expect(event.eventPhotoUrl, isNotEmpty);
      expect(event.eventDescription, isNotEmpty);
      expect(event.eventName, isNotEmpty);

      expect(event.eventName, equals('test'));
      expect(event.eventDescription, equals('test desc'));
      expect(event.eventPhotoUrl, 'test.png');
    });

    testWidgets('UsersProfileDetails test1', (WidgetTester tester) async {
      var userDetails = UsersProfileDetails(details: null);
      var curr = TestHelper.buildPage(userDetails);
      await tester.pumpWidget(curr);

      //widget test
      final myEvents = find.text('My Events');
      expect(myEvents, findsOneWidget);

      final text = find.byType(Text);
      expect(text, findsWidgets);

      final card = find.byType(Card);
      find.descendant(of: card, matching: find.byType(ListTile));

      final BuildContext context = tester.element(myEvents);

      //state test
      final UsersProfileDetailsPageState state =
          tester.state(find.byType(UsersProfileDetails));
      expect(state, isNotNull);
      expect(state.widget, equals(userDetails));

      var top = state.topPart(context);
      expect(top, isNotNull);

      final entity = UserEntity('test', 'test.png', 'test@test.com', null);
      var root = state.getRootTop(entity, context);
      expect(root, isNotNull);
      expect(state, isNotNull);
      expect(root is Column, true);

      final eventEntity = EventEntity('test', 'test', 'test.png');
      expect(eventEntity, isNotNull);

      var item = state.getItemList(eventEntity, 1, context, "myDoc1", null);
      expect(item, isNotNull);

      expect(item is Card, true);

      final clip = state.getClipRRect('test.png');
      expect(clip, isNotNull);
      expect(clip is ClipRRect, true);

      final appBar = state.appBar(context);
      expect(appBar, isNotNull);
      expect(appBar is AppBar, true);

      final topPart = state.topPart(context);
      expect(topPart, isNotNull);
      expect(topPart is Container, true);
    });
  });
}
