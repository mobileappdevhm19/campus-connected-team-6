import 'package:firebase_database/firebase_database.dart';

class Myevent {
  String key;
  String category;
  String eventname;
  String userId;
  String description;
  String date;
  String location;

  Myevent(this.category, this.eventname, this.description,this.userId, this.date, this.location);

  Myevent.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        userId = snapshot.value["userId"],
        eventname = snapshot.value["eventname"],
        description = snapshot.value["description"],
        category = snapshot.value["category"],
        date= snapshot.value["date"],
        location=snapshot.value["location"];

  toJson() {
    return {
      "key": key,
      "userId": userId,
      "eventname": eventname,
      "description":description,
      "category": category,
      "date": date,
      "location": location,
    };
  }
}