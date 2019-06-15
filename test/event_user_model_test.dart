// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter_campus_connected/models/event_user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final eventUserModel = new EventUserModel();
  eventUserModel.userId = "XXPzw4xX8UgRx4JcqQJLFz0oUDl2";
  eventUserModel.eventId = "My Event";

  final Map<String, dynamic> json = {
    "userId": "XXPzw4xX8UgRx4JcqQJLFz0oUDl2",
    "eventId": "My Event"
  };

  test("EventUserModel: parses event model to json", () {
    expect(eventUserModel.toJson().containsKey("eventId"), true);
    expect(eventUserModel.toJson().isNotEmpty, true);
    expect(eventUserModel.toJson().entries.length, 2);
    expect(eventUserModel.toJson().isNotEmpty, true);
  });

  test("EventUserModel: parses json to event model", () {
    expect(
        EventUserModel.fromJson({
          "userId": "XXPzw4xX8UgRx4JcqQJLFz0oUDl2",
          "eventId": "My Event"
        }).userId,
        "XXPzw4xX8UgRx4JcqQJLFz0oUDl2");
    expect(
        EventUserModel.fromJson({
          "userId": "XXPzw4xX8UgRx4JcqQJLFz0oUDl2",
          "eventId": "My Event"
        }).eventId,
        "My Event");
  });
}
