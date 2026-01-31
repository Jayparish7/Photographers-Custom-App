// To parse this JSON data, do
//
//     final statusAndMessageModel = statusAndMessageModelFromJson(jsonString);

import 'dart:convert';

StatusAndMessageModel statusAndMessageModelFromJson(str) =>
    StatusAndMessageModel.fromJson(json.decode(str));

String statusAndMessageModelToJson(StatusAndMessageModel data) =>
    json.encode(data.toJson());

class StatusAndMessageModel {
  StatusAndMessageModel({
    this.status,
    this.token,
    this.message,
  });

  bool? status;
  String? token;
  String? message;

  factory StatusAndMessageModel.fromJson(Map<String, dynamic> json) =>
      StatusAndMessageModel(
        status: json["status"] == null ? null : json["status"],
        token: json["token"] == null ? null : json["token"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
      };
}
