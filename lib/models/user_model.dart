class UserModel {
  String uid;
  String email;
  String displayName;
  String photoUrl;

  UserModel({this.uid, this.email, this.displayName, this.photoUrl});

  UserModel.fromJson(Map<String, String> json) {
    uid = json['uid'];
    email = json['email'];
    displayName = json['displayName'];
    photoUrl = json['photoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid ='] = this.uid;
    data['email'] = this.email;
    data['displayName'] = this.displayName;
    data['photoUrl'] = this.photoUrl;
    return data;
  }
}
