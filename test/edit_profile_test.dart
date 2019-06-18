import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/edit_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'test_helper.dart';

void main() {
  testWidgets('edit profile test', (WidgetTester tester) async {
    //https://iirokrankka.com/2018/09/16/image-network-widget-tests/
    provideMockedNetworkImages(() async {

      final String displayName = 'test';
      var editPage = EditProfile(photoUrl: 'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
          displayName: displayName);
      var curr = TestHelper.buildPage(editPage) ;
      await tester.pumpWidget(curr);

      final test = find.text(displayName);
      expect(test, findsOneWidget);

      final submit = find.text('Save');
      expect(submit, findsOneWidget);
      final BuildContext context = tester.element(submit);

      //state
      final EditProfileState state = tester.state(find.byType(EditProfile));
      expect(state, isNotNull);
      expect(state.widget, equals(editPage));

      await state.getImage();
      await state.uploadImage();
      state.submitForm();

      final bt = state.submitButton(context);
      TestHelper.checkWidget<RaisedButton>(bt);

      final check = await state.checkInternetConnection();
      expect(check, true);

      final body = state.getBody(context);
      TestHelper.checkWidget<Stack>(body);

      final appBar = state.appBar(context);
      TestHelper.checkWidget<AppBar>(appBar);

      final updatingDialog = state.updatingDialog(context);
      TestHelper.checkWidget<Container>(updatingDialog);

      final imageField = state.imageField();
      TestHelper.checkWidget<Stack>(imageField);

      final nameTextForm = state.nameTextForm(context);
      TestHelper.checkWidget<TextFormField>(nameTextForm);

      final alertDialog = state.getAlertDialog(context);
      TestHelper.checkWidget<AlertDialog>(alertDialog);
    });
  });
}