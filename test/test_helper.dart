import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestHelper {
  static buildPage(page) {
    return MaterialApp(
      home: page,
    );
  }

  static checkWidget<T>(T param) {
    expect(param, isNotNull);
    expect(param is T, true);
  }
}
