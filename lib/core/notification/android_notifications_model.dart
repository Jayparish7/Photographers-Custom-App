// To parse this JSON data, do
//
//     final androidNotificationsModel = androidNotificationsModelFromJson(jsonString);

import 'dart:convert';

AndroidNotificationsModel androidNotificationsModelFromJson(str) => AndroidNotificationsModel.fromJson(json.decode(str));

String androidNotificationsModelToJson(AndroidNotificationsModel data) => json.encode(data.toJson());

class AndroidNotificationsModel {
  AndroidNotificationsModel({
    this.androidNotifications,
  });

  List<AndroidNotificationValues>? androidNotifications;

  factory AndroidNotificationsModel.fromJson(Map<String, dynamic> json) => AndroidNotificationsModel(
    androidNotifications: json["android_notifications"] == null ? null : List<AndroidNotificationValues>.from(json["android_notifications"].map((x) => AndroidNotificationValues.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "android_notifications": androidNotifications == null ? null : List<dynamic>.from(androidNotifications!.map((x) => x.toJson())),
  };
}

class AndroidNotificationValues {
  AndroidNotificationValues({
    this.id,
    this.code,
    this.values,
    this.eCommerceType,
    this.companyDetail,
  });

  int? id;
  String? code;
  NotificationValues? values;
  int? eCommerceType;
  CompanyDetail? companyDetail;

  factory AndroidNotificationValues.fromJson(Map<String, dynamic> json) => AndroidNotificationValues(
    id: json["id"] == null ? null : json["id"],
    code: json["code"] == null ? null : json["code"],
    values: json["values"] == null ? null : NotificationValues.fromJson(json["values"]),
    eCommerceType: json["ecommerce_type"] == null ? null : json["ecommerce_type"],
    companyDetail: json["company"] == null ? null : CompanyDetail.fromJson(json["company"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "code": code == null ? null : code,
    "values": values == null ? null : values!.toJson(),
    "ecommerce_type": eCommerceType == null ? null : eCommerceType,
    "company": companyDetail == null ? null : companyDetail!.toJson(),
  };
}

class NotificationValues {
  NotificationValues({
    this.title,
    this.description,
    this.redirectionDetail,
  });

  String? title;
  String? description;
  RedirectionDetail? redirectionDetail;

  factory NotificationValues.fromJson(Map<String, dynamic> json) => NotificationValues(
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    redirectionDetail: json["redirection_detail"] == null ? null : RedirectionDetail.fromJson(json["redirection_detail"]),
  );

  Map<String, dynamic> toJson() => {
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "redirection_detail": redirectionDetail == null ? null : redirectionDetail!.toJson(),
  };
}

class RedirectionDetail {
  RedirectionDetail({
    this.page,
    this.value,
  });

  String? page;
  String? value;

  factory RedirectionDetail.fromJson(Map<String, dynamic> json) => RedirectionDetail(
    page: json["page"] == null ? null : json["page"],
    value: json["value"] == null ? null : json["value"],
  );

  Map<String, dynamic> toJson() => {
    "page": page == null ? null : page,
    "value": value == null ? null : value,
  };
}

class CompanyDetail {
  CompanyDetail({
    this.code,
    this.name,
  });

  String? code;
  String? name;

  factory CompanyDetail.fromJson(Map<String, dynamic> json) => CompanyDetail(
    code: json["code"] == null ? null : json["code"],
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "name": name == null ? null : name,
  };
}
