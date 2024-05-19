class Event {
  String? eventId;
  String? userId;
  String? messageType;
  String? title;
  String? description;
  String? eventDate;

  Event(
      {this.eventId,
      this.userId,
      this.messageType,
      this.title,
      this.description,
      this.eventDate});

  Event.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    userId = json['user_id'];
    messageType = json['message_type'];
    title = json['title'];
    description = json['description'];
    eventDate = json['event_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event_id'] = eventId;
    data['user_id'] = userId;
    data['message_type'] = messageType;
    data['title'] = title;
    data['description'] = description;
    data['event_date'] = eventDate;
    return data;
  }
}
