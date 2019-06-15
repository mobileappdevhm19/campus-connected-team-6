// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter_campus_connected/models/event_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final eventModel = new EventModel();
  eventModel.createdBy = "XXPzw4xX8UgRx4JcqQJLFz0oUDl2";
  eventModel.eventName = "My Event";
  eventModel.eventDescription = "A Description";
  eventModel.eventDate = "01.01.01";
  eventModel.eventTime = "10:00AM";
  eventModel.eventLocation = "Campus Lothstrasse";
  eventModel.eventPhotoUrl =
      "https://firebasestorage.googleapis.com/v0/b/campus-connected.appspot.com/o/eventImage-2023-9283-9263.jpg?alt=media&token=1b6c5441-bdb9-4b94-bce8-a0f321576c8d";
  eventModel.eventCategory = "Outdoor";
  eventModel.maximumLimit = 2;

  final Map<String, dynamic> json = {
    "createdBy": "XXPzw4xX8UgRx4JcqQJLFz0oUDl2",
    "eventName": "My Event",
    "eventDescription": "A Description",
    "eventDate": "01.01.01",
    "eventTime": "10:00AM",
    "eventLocation": "Campus Lothstrasse",
    "eventPhotoUrl":
        "https://firebasestorage.googleapis.com/v0/b/campus-connected.appspot.com/o/eventImage-2023-9283-9263.jpg?alt=media&token=1b6c5441-bdb9-4b94-bce8-a0f321576c8d",
    "eventCategory": "Outdoor",
    "maximumLimit": 2
  };

  test("EventModel: parses event model to json", () {
    expect(eventModel.toJson().containsKey("createdBy"), true);
    expect(eventModel.toJson().isNotEmpty, true);
    expect(eventModel.toJson().entries.length, 9);
    expect(eventModel.toJson().isNotEmpty, true);
  });

  test("EventModel: parses json to event model", () {
    expect(EventModel.fromJson(json).createdBy, "XXPzw4xX8UgRx4JcqQJLFz0oUDl2");
    expect(EventModel.fromJson(json).maximumLimit, 2);
  });
}
