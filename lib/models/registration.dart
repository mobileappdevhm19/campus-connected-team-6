import 'package:firebase_database/firebase_database.dart';

class Registration {
  String key;
  String userId;
  String firstname;
  String lastname;
  String faculty;
  String hobby;

  Registration(this.userId, this.firstname,this.lastname, this.faculty, this.hobby);

  Registration.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        userId = snapshot.value["userId"],
        firstname = snapshot.value["firstname"],
        lastname = snapshot.value["lastname"],
        faculty = snapshot.value["faculty"],
        hobby = snapshot.value["hobby"];

  toJson() {
    return {
      "key": key,
      "userId": userId,
      "firstname": firstname,
      "lastname": lastname,
      "faculty": faculty,
      "hobby": hobby,
    };
  }
}