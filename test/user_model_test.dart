import 'package:flutter_campus_connected/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final userModel = UserModel(
    displayName: 'test',
    photoUrl: 'test.png',
    email: 'test@test.com',
    age: '25',
    faculty: 'FK 07',
    biography: 'HM Student living in Munich',
    isEmailVerified: true,
    uid: '3MqjmE8YmjMeOZJpsWgRtUeSdx41',
  );

  final Map<String, dynamic> json = {
    "displayName": "test",
    "photoUrl": "test.png",
    "email": "test@test.com",
    "age": "25",
    "faculty": "FK 07",
    "biography": "HM Student living in Munich",
    "isEmailVerified": true,
    "uid": "3MqjmE8YmjMeOZJpsWgRtUeSdx41",
  };

  test("UserModel: parses user model to json", () {
    expect(userModel.toJson().containsKey("displayName"), true);
    expect(userModel.toJson().isNotEmpty, true);
    expect(userModel.toJson().entries.length, 8);
    expect(userModel.toJson().isNotEmpty, true);
  });

  test("UserModel: parses json to user model", () {
    expect(
        UserModel.fromJson({
          "displayName": "test",
          "photoUrl": "test.png",
          "email": "test@test.com",
          "age": "25",
          "faculty": "FK 07",
          "biography": "HM Student living in Munich",
          "isEmailVerified": 'true',
          "uid": "3MqjmE8YmjMeOZJpsWgRtUeSdx41",
        }).displayName,
        "test");
    expect(
        UserModel.fromJson({
          "displayName": "test",
          "photoUrl": "test.png",
          "email": "test@test.com",
          "age": "25",
          "faculty": "FK 07",
          "biography": "HM Student living in Munich",
          "isEmailVerified": 'true',
          "uid": "3MqjmE8YmjMeOZJpsWgRtUeSdx41",
        }).faculty,
        "FK 07");
    expect(
        UserModel.fromJson({
          "displayName": "test",
          "photoUrl": "test.png",
          "email": "test@test.com",
          "age": "25",
          "faculty": "FK 07",
          "biography": "HM Student living in Munich",
          "isEmailVerified": 'true',
          "uid": "3MqjmE8YmjMeOZJpsWgRtUeSdx41",
        }).isEmailVerified,
        true);
  });
}
