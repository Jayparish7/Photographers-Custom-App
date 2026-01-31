// To parse this JSON data, do
//
//     final customNotificationModel = customNotificationModelFromJson(jsonString);

import 'dart:convert';

CustomNotificationModel customNotificationModelFromJson(String str) => CustomNotificationModel.fromJson(json.decode(str));

String customNotificationModelToJson(CustomNotificationModel data) => json.encode(data.toJson());

class CustomNotificationModel {
  String? imgUrl;
  String? title;
  String? content;
  int? customNotification;

  CustomNotificationModel({
    this.imgUrl,
    this.title,
    this.content,
    this.customNotification,
  });

  factory CustomNotificationModel.fromJson(Map<String, dynamic> json) => CustomNotificationModel(
    imgUrl: json["img_url"],
    title: json["title"],
    content: json["content"],
    customNotification: json["custom_notification"],
  );

  Map<String, dynamic> toJson() => {
    "img_url": imgUrl,
    "title": title,
    "content": content,
    "custom_notification": customNotification,
  };
}
