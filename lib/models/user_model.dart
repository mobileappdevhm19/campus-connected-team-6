class UserModel {
  String uid;
  String email;
  String displayName;
  String photoUrl;
  String age;
  String faculty;
  String biography;
  bool isEmailVerified;

  UserModel(
      {this.uid,
      this.email,
      this.displayName,
      this.photoUrl,
      this.age,
      this.faculty,
      this.biography,
      this.isEmailVerified});

  UserModel.fromJson(Map<String, String> json) {
    uid = json['uid'];
    email = json['email'];
    displayName = json['displayName'];
    photoUrl = json['photoUrl'];
    age = json['age'];
    faculty = json['faculty'];
    biography = json['biography'];
    isEmailVerified =
        json['isEmailVerified'].toLowerCase() == 'true' ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['email'] = this.email;
    data['displayName'] = this.displayName;
    data['photoUrl'] = this.photoUrl;
    data['age'] = this.age;
    data['faculty'] = this.faculty;
    data['biography'] = this.biography;
    data['isEmailVerified'] = this.isEmailVerified;
    return data;
  }
}
