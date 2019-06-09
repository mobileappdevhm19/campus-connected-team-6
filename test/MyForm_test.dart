//import 'package:flutter/material.dart';
//
//import 'package:flutter_login_demo/pages/MyForm.dart';
//import 'package:flutter_test/flutter_test.dart';
//import 'testHelper.dart';
//
//void main() {
//  testWidgets('Passes textAlign to underlying TextField', (WidgetTester tester) async {
//    const TextAlign alignment = TextAlign.center;
//
//    await tester.pumpWidget(
//      MaterialApp(
//        home: Material(
//          child: Center(
//            child: TextFormField(
//              textAlign: alignment,
//            ),
//          ),
//        ),
//      ),
//    );
//
//    final Finder textFieldFinder = find.byType(TextField);
//    expect(textFieldFinder, findsOneWidget);
//
//    final TextField textFieldWidget = tester.widget(textFieldFinder);
//    expect(textFieldWidget.textAlign, alignment);
//  });
//
//  testWidgets('Passes textInputAction to underlying TextField', (WidgetTester tester) async {
//    await tester.pumpWidget(
//      MaterialApp(
//        home: Material(
//          child: Center(
//            child: TextFormField(
//              textInputAction: TextInputAction.next,
//            ),
//          ),
//        ),
//      ),
//    );
//
//    final Finder textFieldFinder = find.byType(TextField);
//    expect(textFieldFinder, findsOneWidget);
//
//    final TextField textFieldWidget = tester.widget(textFieldFinder);
//    expect(textFieldWidget.textInputAction, TextInputAction.next);
//  });
//
//  testWidgets('Passes onEditingComplete to underlying TextField', (WidgetTester tester) async {
//    final VoidCallback onEditingComplete = () { };
//
//    await tester.pumpWidget(
//      MaterialApp(
//        home: Material(
//          child: Center(
//            child: TextFormField(
//              onEditingComplete: onEditingComplete,
//            ),
//          ),
//        ),
//      ),
//    );
//
//    final Finder textFieldFinder = find.byType(TextField);
//    expect(textFieldFinder, findsOneWidget);
//
//    final TextField textFieldWidget = tester.widget(textFieldFinder);
//    expect(textFieldWidget.onEditingComplete, onEditingComplete);
//  });
//
//  testWidgets('Passes cursor attributes to underlying TextField', (WidgetTester tester) async {
//    const double cursorWidth = 3.14;
//    const Radius cursorRadius = Radius.circular(4);
//    const Color cursorColor = Colors.purple;
//
//    await tester.pumpWidget(
//      MaterialApp(
//        home: Material(
//          child: Center(
//            child: TextFormField(
//              cursorWidth: cursorWidth,
//              cursorRadius: cursorRadius,
//              cursorColor: cursorColor,
//            ),
//          ),
//        ),
//      ),
//    );
//
//    final Finder textFieldFinder = find.byType(TextField);
//    expect(textFieldFinder, findsOneWidget);
//
//    final TextField textFieldWidget = tester.widget(textFieldFinder);
//    expect(textFieldWidget.cursorWidth, cursorWidth);
//    expect(textFieldWidget.cursorRadius, cursorRadius);
//    expect(textFieldWidget.cursorColor, cursorColor);
//  });
//
//  testWidgets('onFieldSubmit callbacks are called', (WidgetTester tester) async {
//    bool _called = false;
//
//    await tester.pumpWidget(
//      MaterialApp(
//        home: Material(
//          child: Center(
//            child: TextFormField(
//              onFieldSubmitted: (String value) { _called = true; },
//            ),
//          ),
//        ),
//      ),
//    );
//
//    await tester.showKeyboard(find.byType(TextField));
//    await tester.testTextInput.receiveAction(TextInputAction.done);
//    await tester.pump();
//    expect(_called, true);
//  });
//
//  testWidgets('autovalidate is passed to super', (WidgetTester tester) async {
//    int _validateCalled = 0;
//
//    await tester.pumpWidget(
//      MaterialApp(
//        home: Material(
//          child: Center(
//            child: TextFormField(
//              autovalidate: true,
//              validator: (String value) { _validateCalled++; return null; },
//            ),
//          ),
//        ),
//      ),
//    );
//
//    expect(_validateCalled, 1);
//    await tester.showKeyboard(find.byType(TextField));
//    await tester.enterText(find.byType(TextField), 'a');
//    await tester.pump();
//    expect(_validateCalled, 2);
//  });
//
//  testWidgets('validate is not called if widget is disabled', (WidgetTester tester) async {
//    int _validateCalled = 0;
//
//    await tester.pumpWidget(
//      MaterialApp(
//        home: Material(
//          child: Center(
//            child: TextFormField(
//              enabled: false,
//              autovalidate: true,
//              validator: (String value) { _validateCalled += 1; return null; },
//            ),
//          ),
//        ),
//      ),
//    );
//
//    expect(_validateCalled, 0);
//    await tester.showKeyboard(find.byType(TextField));
//    await tester.enterText(find.byType(TextField), 'a');
//    await tester.pump();
//    expect(_validateCalled, 0);
//  });
//
//  testWidgets('validate is called if widget is enabled', (WidgetTester tester) async {
//    int _validateCalled = 0;
//
//    await tester.pumpWidget(
//      MaterialApp(
//        home: Material(
//          child: Center(
//            child: TextFormField(
//              enabled: true,
//              autovalidate: true,
//              validator: (String value) { _validateCalled += 1; return null; },
//            ),
//          ),
//        ),
//      ),
//    );
//
//    expect(_validateCalled, 1);
//    await tester.showKeyboard(find.byType(TextField));
//    await tester.enterText(find.byType(TextField), 'a');
//    await tester.pump();
//    expect(_validateCalled, 2);
//  });
//
//  testWidgets('passing a buildCounter shows returned widget', (WidgetTester tester) async {
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: Center(
//          child: TextFormField(
//            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) {
//              return Text('${currentLength.toString()} of ${maxLength.toString()}');
//            },
//            maxLength: 10,
//          ),
//        ),
//      ),
//    ),
//    );
//
//    expect(find.text('0 of 10'), findsOneWidget);
//
//    await tester.enterText(find.byType(TextField), '01234');
//    await tester.pump();
//
//    expect(find.text('5 of 10'), findsOneWidget);
//  });
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//  testWidgets("MyForm wird getestet", (WidgetTester tester) async {
//    await tester.pumpWidget(TestHelper.buildPage(MyForm()));
//
//
//    final firstName = find.text('First Name:');
//    expect(firstName, findsOneWidget);
//    final lastName = find.text('Last Name:');
//    expect(lastName, findsOneWidget);
//    final gender = find.text('Gender:');
//    expect(gender, findsOneWidget);
//    final faculty = find.text('Faculty:');
//    expect(faculty, findsOneWidget);
//    final hobby = find.text('Hobby:');
//    expect(hobby, findsOneWidget);
//    final agree = find.text('I agree to the terms and condition.');
//    expect(agree, findsOneWidget);
//
//
//    final raisedButton = find.byType(RaisedButton);
//    expect(raisedButton, findsOneWidget);
//
//
//
//
//  });
//  testWidgets('SizedBox wird getestet', (WidgetTester tester) async {
//    await tester.pumpWidget(TestHelper.buildPage(MyForm()));
//    const SizedBox a = SizedBox();
//    expect(a.width, isNull);
//    expect(a.height, isNull);
//
//    const SizedBox b = SizedBox(width: 5.0);
//    expect(b.width, 5.0);
//    expect(b.height, isNull);
//
//    const SizedBox c = SizedBox(width: 5.0, height: 10.0);
//    expect(c.width, 5.0);
//    expect(c.height, 10.0);
//
//    final SizedBox d = SizedBox.fromSize();
//    expect(d.width, isNull);
//    expect(d.height, isNull);
//
//    final SizedBox e = SizedBox.fromSize(size: const Size(5.0, 10.0));
//    expect(e.width, 5.0);
//    expect(e.height, 10.0);
//
//    const SizedBox f = SizedBox.expand();
//    expect(f.width, double.infinity);
//    expect(f.height, double.infinity);
//
//    const SizedBox g = SizedBox.shrink();
//    expect(g.width, 0.0);
//    expect(g.height, 0.0);
//  });
//  testWidgets('SizedBox - no child', (WidgetTester tester) async {
//    final GlobalKey patient = GlobalKey();
//
//    await tester.pumpWidget(
//        Center(
//          child: SizedBox(
//            key: patient,
//          ),
//        )
//    );
//    expect(patient.currentContext.size, equals(const Size(0.0, 0.0)));
//
//    await tester.pumpWidget(
//        Center(
//          child: SizedBox(
//            key: patient,
//            height: 0.0,
//          ),
//        )
//    );
//    expect(patient.currentContext.size, equals(const Size(0.0, 0.0)));
//
//    await tester.pumpWidget(
//        Center(
//          child: SizedBox(
//            key: patient,
//            width: 0.0,
//            height: 0.0,
//          ),
//        )
//    );
//    expect(patient.currentContext.size, equals(const Size(0.0, 0.0)));
//
//    await tester.pumpWidget(
//        Center(
//          child: SizedBox(
//            key: patient,
//            width: 100.0,
//            height: 100.0,
//          ),
//        )
//    );
//    expect(patient.currentContext.size, equals(const Size(100.0, 100.0)));
//
//    await tester.pumpWidget(
//        Center(
//          child: SizedBox(
//            key: patient,
//            width: 1000.0,
//            height: 1000.0,
//          ),
//        )
//    );
//    expect(patient.currentContext.size, equals(const Size(800.0, 600.0)));
//
//    await tester.pumpWidget(
//        Center(
//          child: SizedBox.expand(
//            key: patient,
//          ),
//        )
//    );
//    expect(patient.currentContext.size, equals(const Size(800.0, 600.0)));
//
//    await tester.pumpWidget(
//        Center(
//          child: SizedBox.shrink(
//            key: patient,
//          ),
//        )
//    );
//    expect(patient.currentContext.size, equals(const Size(0.0, 0.0)));
//  });
//
//  testWidgets('SizedBox - container child', (WidgetTester tester) async {
//    final GlobalKey patient = GlobalKey();
//
//    await tester.pumpWidget(
//        Center(
//          child: SizedBox(
//            key: patient,
//            child: Container(),
//          ),
//        )
//    );
//    expect(patient.currentContext.size, equals(const Size(800.0, 600.0)));
//
//    await tester.pumpWidget(
//        Center(
//          child: SizedBox(
//            key: patient,
//            height: 0.0,
//            child: Container(),
//          ),
//        )
//    );
//    expect(patient.currentContext.size, equals(const Size(800.0, 0.0)));
//
//    await tester.pumpWidget(
//        Center(
//          child: SizedBox(
//            key: patient,
//            width: 0.0,
//            height: 0.0,
//            child: Container(),
//          ),
//        )
//    );
//    expect(patient.currentContext.size, equals(const Size(0.0, 0.0)));
//
//    await tester.pumpWidget(
//        Center(
//          child: SizedBox(
//            key: patient,
//            width: 100.0,
//            height: 100.0,
//            child: Container(),
//          ),
//        )
//    );
//    expect(patient.currentContext.size, equals(const Size(100.0, 100.0)));
//
//    await tester.pumpWidget(
//        Center(
//          child: SizedBox(
//            key: patient,
//            width: 1000.0,
//            height: 1000.0,
//            child: Container(),
//          ),
//        )
//    );
//    expect(patient.currentContext.size, equals(const Size(800.0, 600.0)));
//
//    await tester.pumpWidget(
//        Center(
//          child: SizedBox.expand(
//            key: patient,
//            child: Container(),
//          ),
//        )
//    );
//    expect(patient.currentContext.size, equals(const Size(800.0, 600.0)));
//
//    await tester.pumpWidget(
//        Center(
//          child: SizedBox.shrink(
//            key: patient,
//            child: Container(),
//          ),
//        )
//    );
//    expect(patient.currentContext.size, equals(const Size(0.0, 0.0)));
//  });
//  testWidgets('runApp inside onPressed does not throw', (WidgetTester tester) async {
//    await tester.pumpWidget(
//        Directionality(
//          textDirection: TextDirection.ltr,
//          child: Material(
//            child: RaisedButton(
//              onPressed: () {
//                runApp(const Center(child: Text('Done', textDirection: TextDirection.ltr,)));
//              },
//              child: const Text('GO'),
//            ),
//          ),
//        )
//    );
//    await tester.tap(find.text('GO'));
//    expect(find.text('Done'), findsOneWidget);
//  });
//}
