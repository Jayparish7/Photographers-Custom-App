// To parse this JSON data, do
//
//     final appConfigRequest = appConfigRequestFromJson(jsonString);

import 'dart:convert';

AppConfigRequest appConfigRequestFromJson(String str) => AppConfigRequest.fromJson(json.decode(str));

String appConfigRequestToJson(AppConfigRequest data) => json.encode(data.toJson());

class AppConfigRequest {
  AppConfigRequest({
    this.inputData,

  });

  List<InputData>? inputData;


  factory AppConfigRequest.fromJson(Map<String, dynamic> json) => AppConfigRequest(
    inputData: json["input_data"] == null ? null : List<InputData>.from(json["input_data"].map((x) => InputData.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "input_data": inputData == null ? null : List<dynamic>.from(inputData!.map((x) => x.toJson())),
  };
}

class InputData {
  InputData({
    this.key,
    this.lastUpdatedAt,
    this.events ,
    this.studios ,
    this.folders,
    this.albums,
    this.androidDataNotificationCode,
  });

  String? key;
  int? lastUpdatedAt;
  List<Event>? events;
  List<Studios>? studios;
  List<Folder>? folders;
  List<InputAlbum>? albums;
  String? androidDataNotificationCode;
  factory InputData.fromJson(Map<String, dynamic> json) => InputData(
    key: json["key"] == null ? null : json["key"],
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],
    events: json["events"] == null ? null : List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
    studios: json["studios"] == null ? null : List<Studios>.from(json["studios"].map((x) => Studios.fromJson(x))),
    folders: json["folders"] == null ? null : List<Folder>.from(json["folders"].map((x) => Folder.fromJson(x))),
    albums: json["albums"] == null ? null : List<InputAlbum>.from(json["albums"].map((x) => InputAlbum.fromJson(x))),
    androidDataNotificationCode: json["android_data_notification_code"] == null ? null : json["android_data_notification_code"],
  );

  Map<String, dynamic> toJson() => {
    "key": key == null ? null : key,
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
    "events": events == null ? [] : List<dynamic>.from(events!.map((x) => x.toJson())),
    "studios": studios == null ? [] : List<dynamic>.from(studios!.map((x) => x.toJson())),
    "folders": folders == null ? [] : List<dynamic>.from(folders!.map((x) => x.toJson())),
    "albums": albums == null ? null : List<dynamic>.from(albums!.map((x) => x.toJson())),
    "android_data_notification_code": androidDataNotificationCode == null ? null : androidDataNotificationCode,
  };
}
class Event {
  Event({
    this.code,
    this.lastUpdatedAt,
  });

  String? code;
  int? lastUpdatedAt;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    code: json["code"] == null ? null : json["code"],
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
  };
}
class Studios {
  Studios({
    this.code,
    this.lastUpdatedAt,
  });

  String? code;
  int? lastUpdatedAt;

  factory Studios.fromJson(Map<String, dynamic> json) => Studios(
    code: json["code"] == null ? null : json["code"],
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
  };
}
class Folder {
  Folder({
    this.code,
    this.lastUpdatedAt,
  });

  String? code;
  String? lastUpdatedAt;

  factory Folder.fromJson(Map<String, dynamic> json) => Folder(
    code: json["code"] == null ? null : json["code"],
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],

  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
  };
}
class InputAlbum {
  InputAlbum({
    this.code,
    this.lastUpdatedAt,
  });

  String? code;
  String? lastUpdatedAt;

  factory InputAlbum.fromJson(Map<String, dynamic> json) => InputAlbum(
    code: json["code"] == null ? null : json["code"],
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],

  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
  };
}
