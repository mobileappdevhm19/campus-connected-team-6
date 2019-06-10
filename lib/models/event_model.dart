class EventModel {
  String eventName;
  String eventDescription;
  String eventDate;
  String eventTime;
  String eventLocation;
  String eventPhotoUrl;
  String createdBy;
  String eventCategory;
  int maximumLimit;

  EventModel(
      {this.eventName,
      this.eventDescription,
      this.eventDate,
      this.eventTime,
      this.eventLocation,
      this.eventPhotoUrl,
      this.createdBy,
      this.eventCategory,
      this.maximumLimit});

  EventModel.fromJson(Map<String, dynamic> json) {
    eventName = json['eventName'];
    eventDescription = json['eventDescription'];
    eventDate = json['eventDate'];
    eventLocation = json['eventLocation'];
    eventPhotoUrl = json['eventPhotoUrl'];
    createdBy = json['createdBy'];
    eventTime = json['eventTime'];
    eventCategory = json['eventCategory'];
    maximumLimit = json['maximumLimit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventName'] = this.eventName;
    data['eventDescription'] = this.eventDescription;
    data['eventDate'] = this.eventDate;
    data['eventLocation'] = this.eventLocation;
    data['eventPhotoUrl'] = this.eventPhotoUrl;
    data['createdBy'] = this.createdBy;
    data['eventTime'] = this.eventTime;
    data['eventCategory'] = this.eventCategory;
    data['maximumLimit'] = this.maximumLimit;
    return data;
  }
}
