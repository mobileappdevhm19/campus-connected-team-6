import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/pages/edit_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'test_helper.dart';

void main() {
  testWidgets('edit profile test', (WidgetTester tester) async {
    //url рисунков не работают в тестах
    //объяснение https://iirokrankka.com/2018/09/16/image-network-widget-tests/
    //используем  пакет "заглушку"
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


      final btFinder = find.byKey(Key('submitBt')) ;
      expect(btFinder, findsOneWidget);

      //state
      final EditProfileState state = tester.state(find.byType(EditProfile));
      expect(state, isNotNull);
      expect(state.widget, equals(editPage));

      final form = state.getForm(context);
      TestHelper.checkWidget<Form>(form);
      expect(form.child is Card, true);

      final checkNet = await state.checkInternetConnection() ;
      expect(checkNet, true);

      await state.getImage();
      expect(state.sampleImage, isNotNull);
      expect(state.uploadingStatus, true);

      await state.uploadImage();
      expect(state.uploadingStatus, true);
      expect(state.sampleImage, isNotNull);

      state.submitForm();

      expect(state.uploadingStatus, false);

      final bt = state.submitButton(context);
      TestHelper.checkWidget<RaisedButton>(bt);

      tester.tap(submit);
      expect(state.submitForm, isNull);

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
      expect(alertDialog.content is Column, true);

      final Column column = alertDialog.content as Column;
      expect(column.children.length>0, true);

      final textChild = column.children[1] as   Text;
      expect(textChild, isNotNull);

      expect(textChild.data =='No Internet 😞', true);

      expect(state.imageUrl == state.widget.photoUrl, true);
      expect(state.name == state.widget.displayName, true);
    });
  });
}