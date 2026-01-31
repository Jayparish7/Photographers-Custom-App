// To parse this JSON data, do
//
//     final beforeLoginBookMeModel = beforeLoginBookMeModelFromJson(jsonString);

import 'dart:convert';

BeforeLoginBookMeModel beforeLoginBookMeModelFromJson(str) => BeforeLoginBookMeModel.fromJson(json.decode(str));

String beforeLoginBookMeModelToJson(BeforeLoginBookMeModel data) => json.encode(data.toJson());

class BeforeLoginBookMeModel {
  String? userRandomId;
  int? clientId;
  String? successMessage;

  BeforeLoginBookMeModel({
    this.userRandomId,
    this.clientId,
    this.successMessage,
  });

  factory BeforeLoginBookMeModel.fromJson(Map<String, dynamic> json) => BeforeLoginBookMeModel(
    userRandomId: json["user_random_id"] == null ? null : json["user_random_id"],
    clientId: json["client_id"] == null ? null : json["client_id"],
    successMessage: json["success_message"] == null ? null : json["success_message"],
  );

  Map<String, dynamic> toJson() => {
    "user_random_id": userRandomId == null ? null : userRandomId,
    "client_id": clientId == null ? null : clientId,
    "success_message": successMessage == null ? null : successMessage,
  };
}
