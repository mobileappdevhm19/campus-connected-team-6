import 'package:flutter/material.dart';

import 'package:flutter_campus_connected/pages/password_reset.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

void main() {
  testWidgets("Splash Screen wird getestet", (WidgetTester tester)
  async {
    await tester.pumpWidget(TestHelper.buildPage(PasswordResetPage()));




    
  });
}