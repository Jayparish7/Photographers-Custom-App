// To parse this JSON data, do
//
//     final photoSelectionNotification = photoSelectionNotificationFromJson(jsonString);

import 'dart:convert';

PhotoSelectionNotification photoSelectionNotificationFromJson( str) => PhotoSelectionNotification.fromJson(json.decode(str));

String photoSelectionNotificationToJson(PhotoSelectionNotification data) => json.encode(data.toJson());

class PhotoSelectionNotification {
  PhotoSelectionNotification({
    this.androidDataNotificationCode,
    this.values,
    this.notificationKey,
    this.clickAction,
  });

  String? androidDataNotificationCode;
  Values? values;
  String? notificationKey;
  String? clickAction;

  factory PhotoSelectionNotification.fromJson(Map<String, dynamic> json) => PhotoSelectionNotification(
    androidDataNotificationCode: json["android_data_notification_code"] == null ? null : json["android_data_notification_code"],
    values: json["values"] == null ? null : Values.fromJson(json["values"]),
    notificationKey: json["notification_key"] == null ? null : json["notification_key"],
    clickAction: json["click_action"] == null ? null : json["click_action"],
  );

  Map<String, dynamic> toJson() => {
    "android_data_notification_code": androidDataNotificationCode == null ? null : androidDataNotificationCode,
    "values": values == null ? null : values!.toJson(),
    "notification_key": notificationKey == null ? null : notificationKey,
    "click_action": clickAction == null ? null : clickAction,
  };
}

class Values {
  Values({
    this.eventCode,
    this.confirmedStatus,
    this.photoselectionCode,
  });

  String? eventCode;
  int? confirmedStatus;
  String? photoselectionCode;

  factory Values.fromJson(Map<String, dynamic> json) => Values(
    eventCode: json["event_code "] == null ? null : json["event_code "],
    confirmedStatus: json["confirmed_status "] == null ? null : json["confirmed_status "],
    photoselectionCode: json["photoselection_code "] == null ? null : json["photoselection_code "],
  );

  Map<String, dynamic> toJson() => {
    "event_code ": eventCode == null ? null : eventCode,
    "confirmed_status ": confirmedStatus == null ? null : confirmedStatus,
    "photoselection_code ": photoselectionCode == null ? null : photoselectionCode,
  };
}
