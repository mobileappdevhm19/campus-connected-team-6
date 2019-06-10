class EventUserModel {
  String userId;
  String eventId;

  EventUserModel({this.userId, this.eventId});

  EventUserModel.fromJson(Map<String, String> json) {
    userId = json['userId'];
    eventId = json['eventId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['eventId'] = this.eventId;
    return data;
  }
}
