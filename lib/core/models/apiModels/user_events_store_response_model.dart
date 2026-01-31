// To parse this JSON data, do
//
//     final userAbleEventsStoreUrlResponseModel = userAbleEventsStoreUrlResponseModelFromJson(jsonString);

import 'dart:convert';

UserAbleEventsStoreUrlResponseModel userAbleEventsStoreUrlResponseModelFromJson(
        str) =>
    UserAbleEventsStoreUrlResponseModel.fromJson(json.decode(str));

String userAbleEventsStoreUrlResponseModelToJson(
        UserAbleEventsStoreUrlResponseModel data) =>
    json.encode(data.toJson());

class UserAbleEventsStoreUrlResponseModel {
  List<String>? message;

  UserAbleEventsStoreUrlResponseModel({
    this.message,
  });

  factory UserAbleEventsStoreUrlResponseModel.fromJson(
          Map<String, dynamic> json) =>
      UserAbleEventsStoreUrlResponseModel(
        message: json["message"] == null
            ? []
            : List<String>.from(json["message"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "message":
            message == null ? [] : List<dynamic>.from(message!.map((x) => x)),
      };
}
