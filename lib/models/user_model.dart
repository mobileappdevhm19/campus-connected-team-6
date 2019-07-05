//TODO: remove if not used
class UserModel {
  String uid;
  String email;
  String displayName;
  String photoUrl;
  String age;
  String faculty;
  String biography;

  UserModel(
      {this.uid,
      this.email,
      this.displayName,
      this.photoUrl,
      this.age,
      this.faculty,
      this.biography});

  UserModel.fromJson(Map<String, String> json) {
    uid = json['uid'];
    email = json['email'];
    displayName = json['displayName'];
    photoUrl = json['photoUrl'];
    age = json['age'];
    faculty = json['faculty'];
    biography = json['biography'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid ='] = this.uid;
    data['email'] = this.email;
    data['displayName'] = this.displayName;
    data['photoUrl'] = this.photoUrl;
    data['age'] = this.age;
    data['faculty'] = this.faculty;
    data['biography'] = this.biography;
    return data;
  }
}
