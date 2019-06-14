import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/models/event_model.dart';
import 'package:flutter_campus_connected/pages/view_event.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

EventModel eventModel;
var photoUrl =
    'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png';
String eventId = "-LgEuJxy66R6jvCcaPvG";

void main() {
//  eventModel = new EventModel();
//  eventModel.eventName = "dummy name";
//  eventModel.eventDescription = "description";
//  eventModel.eventDate = "01.01.01";
//  eventModel.eventTime = "10:00AM";
//  eventModel.eventLocation = "campus lothstrasse";
//  eventModel.eventPhotoUrl = "abcdefgh123456789";
//  eventModel.eventCategory = "Outdoor";
//  eventModel.maximumLimit = 2;

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
//    await tester.pumpWidget(TestHelper.buildPage(event));
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
