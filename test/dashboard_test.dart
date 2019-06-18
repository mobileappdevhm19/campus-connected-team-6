import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/models/dashboard_item.dart';
import 'package:flutter_campus_connected/pages/dashboard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_helper.dart';

void main() {

  checkListTitle(ListTile item, String title)   {
    expect(item.title is Text, true);
    final Text text = item.title as Text;
    expect(text.data == title, true);
  }
  group('Dashboard test', () {

    test('Dashboard_item test', () {
      final entity =  DashbaoardItem('test', 'test.png');
      expect(entity, isNotNull);
      expect(entity.photoUrl, isNotEmpty);
      expect(entity.displayName, isNotEmpty);

      expect(entity.displayName, equals('test'));
      expect(entity.photoUrl, 'test.png');
    });

    testWidgets('Dashboard widget test', (WidgetTester tester) async {

      final StatefulWidget dashboard = Dashboard();
      final curr = TestHelper.buildPage(dashboard) ;
      await tester.pumpWidget(curr);
      //state
      final DashboardState state = tester.state(find.byType(Dashboard));
      expect(state, isNotNull);
      expect(state.widget, equals(dashboard));
      final text = find.text('Campus Connected');

      final BuildContext context = tester.element(text);
      expect(context, isNotNull);

      final appBar = state.appBar(context);
      TestHelper.checkWidget<AppBar>(appBar);

      final logo =state.appLogo(context);
      TestHelper.checkWidget<Container>(logo);

      //final profile = state.profileNameAndImage(context);
      //TestHelper.checkWidget<Padding>(profile);

      final entity =  DashbaoardItem('test', 'test.png');
      expect(entity, isNotNull);
      final item = state.getListItem(false, entity, context);
      TestHelper.checkWidget<ListTile>(item);

      final item1 = state.getListItem(true, entity, context);
      TestHelper.checkWidget<Container>(item1);

      final login = state.drawerItem(context, 'Login', Icons.account_circle, 'login');
      TestHelper.checkWidget<ListTile>(login);
      checkListTitle(login, 'Login');

      final users = state.drawerItem(context, 'Users', Icons.person, 'users');
      TestHelper.checkWidget<ListTile>(users);
      checkListTitle(users, 'Users');

      final events = state.drawerItem(context, 'Events', Icons.event_available, 'events');
      TestHelper.checkWidget<ListTile>(events);
      checkListTitle(events, 'Events');

      final crEvents = state.drawerItem(context, 'Create Events', Icons.event, 'login');
      TestHelper.checkWidget<ListTile>(crEvents);
      checkListTitle(crEvents, 'Create Events');

      final logout = state.drawerItem(context, 'Log Out', Icons.exit_to_app, 'logout');
      TestHelper.checkWidget<ListTile>(logout);
      checkListTitle(logout, 'Log Out');

      final body = state.getBody(context);
      TestHelper.checkWidget<Container>(body);

      final rootDrawer = state.getDrawer(context);
      TestHelper.checkWidget<Drawer>(rootDrawer);

      //widget
      final  drawer = find.byTooltip('Open navigation menu');
      expect(drawer, findsWidgets);
      tester.tap(drawer) ;

    });
  });


}