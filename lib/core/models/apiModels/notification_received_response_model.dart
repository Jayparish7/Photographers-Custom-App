// To parse this JSON data, do
//
//     final notificationReceived = notificationReceivedFromJson(jsonString);

import 'dart:convert';

NotificationReceived notificationReceivedFromJson(str) => NotificationReceived.fromJson(json.decode(str));

String notificationReceivedToJson(NotificationReceived data) => json.encode(data.toJson());

class NotificationReceived {
  NotificationReceived({
    this.status,
    this.message,
  });

  bool? status;
  String? message;

  factory NotificationReceived.fromJson(Map<String, dynamic> json) => NotificationReceived(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}
