import 'package:flutter/material.dart';

import 'package:flutter_campus_connected/pages/password_reset.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

void main() {
  testWidgets("Password Reset Page wird getestet", (WidgetTester tester) async {
    await tester.pumpWidget(TestHelper.buildPage(PasswordResetPage()));

    final background = tester.firstWidget(find.byType(Container)) as Container;
    expect((background.decoration as BoxDecoration).gradient,
        LinearGradient(colors: [Colors.red, Colors.redAccent]));

    final Finder rawButtonMaterial = find.descendant(
      of: find.byType(FlatButton),
      matching: find.byType(Material),
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: FlatButton(
          onPressed: () {},
          child: new Text(
            'Already have an account? Sign in',
          ),
        ),
      ),
    );

    Material material = tester.widget<Material>(rawButtonMaterial);
    expect(material.textStyle.color, Color(0xdd000000));
    expect(material.textStyle.fontWeight, FontWeight.w500);

    final Finder raisedButtonMaterial = find.descendant(
      of: find.byType(RaisedButton),
      matching: find.byType(Material),
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RaisedButton(
          onPressed: () {},
          child: new Text(
            'Reset Password',
          ),
        ),
      ),
    );

    Material materialRaised = tester.widget<Material>(raisedButtonMaterial);
    expect(material.elevation, 0.0);
    expect(material.shape,
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)));

    final Finder secondRaisedButtonMaterial = find.descendant(
      of: find.byType(RaisedButton),
      matching: find.byType(Material),
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RaisedButton(
          onPressed: () {},
          child: new Text(
            'OK',
          ),
        ),
      ),
    );

    Material materialSecondRaised = tester.widget<Material>(secondRaisedButtonMaterial);
    expect(materialSecondRaised.textStyle.color, Color(0xdd000000));
    expect(materialSecondRaised.color, Color(0xffe0e0e0));
    expect(materialSecondRaised.elevation, 2.0);
    expect(materialSecondRaised.shape, RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)));


    String msg;
    final findText = find.text(msg);
    expect(findText,findsOneWidget);


  });
}
