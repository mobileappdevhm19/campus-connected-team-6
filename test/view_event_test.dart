import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/models/event_model.dart';
import 'package:flutter_campus_connected/pages/view_event.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

String eventId = "-LgEuJxy66R6jvCcaPvG";

void main() {
  testWidgets("Event view wird getestet", (WidgetTester tester) async {
//    var event = StreamBuilder(
//      stream: Firestore.instance.collection('events').snapshots(),
//      builder: (context, snapshot) {
//        if (snapshot.connectionState == ConnectionState.waiting) {
//          return Container();
//        }
//        return !(snapshot.hasData && snapshot.data.documents.length == 0)
//            ? EventView(snapshot.data.documents[0])
//            : new Container();
//      },
//    );

    var event = new EventModel();
    event.createdBy = "XXPzw4xX8UgRx4JcqQJLFz0oUDl2";
    event.eventName = "My Event";
    event.eventDescription = "A Description";
    event.eventDate = "01.01.01";
    event.eventTime = "10:00AM";
    event.eventLocation = "Campus Lothstrasse";
    event.eventPhotoUrl =
        "https://firebasestorage.googleapis.com/v0/b/campus-connected.appspot.com/o/eventImage-2023-9283-9263.jpg?alt=media&token=1b6c5441-bdb9-4b94-bce8-a0f321576c8d";
    event.eventCategory = "Outdoor";
    event.maximumLimit = 2;

//    await tester.pumpWidget(TestHelper.buildPage(EventView(event, null)));
//
//    await tester.tap(find.byIcon(Icons.favorite_border));
//
//    final totalParticipants = find.text("Total Participants");
//    expect(totalParticipants, findsOneWidget);
//
//    final vieAll = find.text("View all");
//    expect(vieAll, findsOneWidget);
  });
}
