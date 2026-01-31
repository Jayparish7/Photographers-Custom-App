// To parse this JSON data, do
//
//     final imageServerResponseModel = imageServerResponseModelFromJson(jsonString);

import 'dart:convert';

ImageServerResponseModel imageServerResponseModelFromJson(str) => ImageServerResponseModel.fromJson(json.decode(str));

String imageServerResponseModelToJson(ImageServerResponseModel data) => json.encode(data.toJson());

class ImageServerResponseModel {
  ImageServerResponseModel({
    this.imageServerActive,
    this.files,
  });

  int? imageServerActive;
  List<FileElement>? files;

  factory ImageServerResponseModel.fromJson(Map<String, dynamic> json) => ImageServerResponseModel(
    imageServerActive: json["image_server_active"] == null ? null : json["image_server_active"],
    files: json["files"] == null ? null : List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "image_server_active": imageServerActive == null ? null : imageServerActive,
    "files": files == null ? null : List<dynamic>.from(files!.map((x) => x.toJson())),
  };
}

class FileElement {
  FileElement({
    this.code,
    this.status,
  });

  String? code;
  int? status;

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
    code: json["code"] == null ? null : json["code"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "status": status == null ? null : status,
  };
}
