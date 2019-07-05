import 'package:flutter_campus_connected/models/event_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
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
    //FlatButton
    final Finder rawButtonMaterial = find.descendant(
      of: find.byType(FlatButton),
      matching: find.byType(Material),
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: FlatButton(
          onPressed: () {},
          child: new Text(
            'Do you want to delete this Event',
          ),
        ),
      ),
    );

    // Icons Test
    final findArrow_Back_Person = find.byIcon(Icons.arrow_back);
    final findBachIcon = find.byIcon(Icons.arrow_back_ios);
    final find_date_range_Icon = find.byIcon(Icons.date_range);
    final find_access_time_Icon = find.byIcon(Icons.access_time);
    final find_location_on_Icon = find.byIcon(Icons.location_on);
    final find_category_Icon = find.byIcon(Icons.category);
    final find_delete_Icon = find.byIcon(Icons.delete);


    Material material = tester.widget<Material>(rawButtonMaterial);
    expect(material.textStyle.fontWeight, FontWeight.w500);
    //expect(material.textStyle.color, const Color(0xff000000));
    expect(material.color, null);
    expect(material.borderRadius, null);
  });
  testWidgets('IconData object test', (WidgetTester tester) async {
    expect(Icons.account_balance, isNot(equals(Icons.account_box)));
    expect(Icons.account_balance.hashCode, isNot(equals(Icons.account_box.hashCode)));
    expect(Icons.account_balance, hasOneLineDescription);
  });

  testWidgets('Icons specify the material font', (WidgetTester tester) async {
    expect(Icons.clear.fontFamily, 'MaterialIcons');
    expect(Icons.search.fontFamily, 'MaterialIcons');
  });



}
