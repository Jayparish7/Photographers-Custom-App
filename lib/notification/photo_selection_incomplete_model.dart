// To parse this JSON data, do
//
//     final pendingNotificationModel = pendingNotificationModelFromJson(jsonString);

import 'dart:convert';

PendingNotificationModel pendingNotificationModelFromJson(str) => PendingNotificationModel.fromJson(json.decode(str));

String pendingNotificationModelToJson(PendingNotificationModel data) => json.encode(data.toJson());

class PendingNotificationModel {
  String? message;
  String? title;
  String? eventCode;
  String? photoselectionCode;
  int? incompleteConfirmedStatus;

  PendingNotificationModel({
    this.message,
    this.title,
    this.eventCode,
    this.photoselectionCode,
    this.incompleteConfirmedStatus,
  });

  factory PendingNotificationModel.fromJson(Map<String, dynamic> json) => PendingNotificationModel(
    message: json["message"],
    title: json["title"],
    eventCode: json["event_code"],
    photoselectionCode: json["photoselection_code"],
    incompleteConfirmedStatus: json["incomplete_confirmed_status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "title": title,
    "event_code": eventCode,
    "photoselection_code": photoselectionCode,
    "incomplete_confirmed_status": incompleteConfirmedStatus,
  };
}
