// To parse this JSON data, do
//
//     final notificationRequestModel = notificationRequestModelFromJson(jsonString);

import 'dart:convert';

NotificationRequestModel notificationRequestModelFromJson(str) => NotificationRequestModel.fromJson(json.decode(str));

String notificationRequestModelToJson(NotificationRequestModel data) => json.encode(data.toJson());

class NotificationRequestModel {
  NotificationRequestModel({
    this.files,
  });

  List<FileElements>? files;

  factory NotificationRequestModel.fromJson(Map<String, dynamic> json) => NotificationRequestModel(
    files: json["files"] == null ? null : List<FileElements>.from(json["files"].map((x) => FileElements.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "files": files == null ? null : List<dynamic>.from(files!.map((x) => x.toJson())),
  };
}

class FileElements {
  FileElements({
    this.code,
  });

  String? code;

  factory FileElements.fromJson(Map<String, dynamic> json) => FileElements(
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
  };
}
