import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/models/event_model.dart';
import 'package:flutter_campus_connected/pages/create_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_helper.dart';

void main() {
  EventModel eventModel;

  var photoUrl =
      'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png';

  eventModel = new EventModel();
  eventModel.eventName = "dummy name";
  eventModel.eventDescription = "description";
  eventModel.eventDate = "01.01.01";
  eventModel.eventTime = "10:00AM";
  eventModel.eventLocation = "campus lothstrasse";
  eventModel.eventPhotoUrl = photoUrl;
  eventModel.eventCategory = "Outdoor";
  eventModel.maximumLimit = 2;

  testWidgets("Create Event wird getestet", (WidgetTester tester) async {
    //provideMockedNetworkImages(() async {
    await tester.pumpWidget(TestHelper.buildPage(CreateEvent()));

    final joinButtonText = find.text("Event Name");
    expect(joinButtonText, findsOneWidget);

    final totalParticipants = find.text("Event Description");
    expect(totalParticipants, findsOneWidget);

    final vieAll = find.text("Event Location");
    expect(vieAll, findsOneWidget);

    final findEventIcon = find.byIcon(Icons.event);
    expect(findEventIcon, findsOneWidget);

    final findEventDescriptionIcon = find.byIcon(Icons.description);
    expect(findEventDescriptionIcon, findsOneWidget);

    final findEventLocation = find.byIcon(Icons.location_city);
    expect(findEventLocation, findsOneWidget);

    final findEventCategory = find.byIcon(Icons.category);
    expect(findEventCategory, findsOneWidget);

    final findEventEventDate = find.byIcon(Icons.date_range);
    expect(findEventEventDate, findsOneWidget);

    final findEventTime = find.byIcon(Icons.access_time);
    expect(findEventTime, findsOneWidget);
    //});
  });
}
