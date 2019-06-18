import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Dashboard', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    /*test('Open drawer', () async {
      final  drawer = find.byTooltip('Open navigation menu');
      await driver.tap(drawer);
    });*/

    test('login', () async {
      final email = find.byValueKey('Email');
      await driver.waitFor(email);
      await driver.tap(email);
      await driver.enterText('isaeva@hm.edu');

      final pass = find.byValueKey('Password');
      await driver.waitFor(pass);
      await driver.tap(pass);
      await driver.enterText('123456');

      final loginBt = find.byValueKey('Login');
      await driver.waitFor(loginBt);
      await driver.tap(loginBt);

      final drawer = find.byTooltip('Open navigation menu');
      await driver.waitFor(drawer);
      await driver.tap(drawer);

      final login = find.byValueKey('UserName');
      await driver.waitFor(login);
      await driver.tap(login);

      /*final back = find.byTooltip('Back');
      await driver.waitFor(back);
      driver.tap(back);*/
    });
  });
}
