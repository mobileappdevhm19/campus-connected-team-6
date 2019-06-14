import 'package:flutter_campus_connected/pages/edit_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'testHelper.dart';

void main() {
  testWidgets('edit profile test', (WidgetTester tester) async {
    // https://iirokrankka.com/2018/09/16/image-network-widget-tests/
    provideMockedNetworkImages(() async {
      final String displayName = 'test';
      var editPage = EditProfile(
          photoUrl:
              'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
          displayName: displayName);
      var curr = TestHelper.buildPage(editPage);
      await tester.pumpWidget(curr);

      final test = find.text(displayName);
      expect(test, findsOneWidget);

      final submit = find.text('Save');
      expect(submit, findsOneWidget);
    });
  });
}
