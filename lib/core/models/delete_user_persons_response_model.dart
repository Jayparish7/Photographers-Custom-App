// To parse this JSON data, do
//
//     final userPersonsDeleteResponseModel = userPersonsDeleteResponseModelFromJson(jsonString);

import 'dart:convert';

UserPersonsDeleteResponseModel userPersonsDeleteResponseModelFromJson(str) => UserPersonsDeleteResponseModel.fromJson(json.decode(str));

String userPersonsDeleteResponseModelToJson(UserPersonsDeleteResponseModel data) => json.encode(data.toJson());

class UserPersonsDeleteResponseModel {
  int? status;
  String? message;

  UserPersonsDeleteResponseModel({
    this.status,
    this.message,
  });

  factory UserPersonsDeleteResponseModel.fromJson(Map<String, dynamic> json) => UserPersonsDeleteResponseModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
