import 'package:firebase_database/firebase_database.dart';

class Myevent {
  String key;
  String category;
  String eventname;
  int counter;
  String userId;

  Myevent(this.category,this.eventname, this.userId, this.counter);

  Myevent.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    userId = snapshot.value["userId"],
    category = snapshot.value["category"],
    eventname = snapshot.value["eventname"],
    counter = snapshot.value["counter"];

  toJson() {
    return {
      "userId": userId,
      "category": category,
      "eventname": eventname,
      "counter": counter,

    };
  }
}