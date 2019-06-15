import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/models/event_model.dart';
import 'package:flutter_campus_connected/pages/create_event.dart';
import 'package:flutter_campus_connected/pages/search_events.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_helper.dart';

void main() {
  var photoUrl =
      'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png';

  EventModel eventModel = new EventModel();
  eventModel.eventName = "dummy name";
  eventModel.eventDescription = "description";
  eventModel.eventDate = "01.01.01";
  eventModel.eventTime = "10:00AM";
  eventModel.eventLocation = "campus lothstrasse";
  eventModel.eventPhotoUrl = photoUrl;
  eventModel.eventCategory = "Outdoor";
  eventModel.maximumLimit = 2;

  testWidgets("Search Events Page wird getestet", (WidgetTester tester) async {
    await tester.pumpWidget(TestHelper.buildPage(SearchEvent()));

    final totalParticipants = find.text("Search...");
    expect(totalParticipants, findsOneWidget);

    final findEventTime = find.byIcon(Icons.search);
    expect(findEventTime, findsOneWidget);

    final createButton = find.byType(TextField);
    expect(createButton, findsOneWidget);

    await tester.tap(find.byIcon(Icons.search));
    await tester.enterText(find.byType(TextField), "Kino");
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
  });
}
