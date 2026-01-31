// To parse this JSON data, do
//
//     final folderStatusApiModel = folderStatusApiModelFromJson(jsonString);

import 'dart:convert';

FolderStatusApiModel folderStatusApiModelFromJson( str) => FolderStatusApiModel.fromJson(json.decode(str));

String folderStatusApiModelToJson(FolderStatusApiModel data) => json.encode(data.toJson());

class FolderStatusApiModel {
  FolderStatusApi folderStatus;

  FolderStatusApiModel({
    required this.folderStatus,
  });

  factory FolderStatusApiModel.fromJson(Map<String, dynamic> json) => FolderStatusApiModel(
    folderStatus: FolderStatusApi.fromJson(json["folder_status"]),
  );

  Map<String, dynamic> toJson() => {
    "folder_status": folderStatus.toJson(),
  };
}

class FolderStatusApi {
  String code;
  int selectedImages;
  int rejectedImages;
  int waitListedImages;
  int lastUpdatedAt;

  FolderStatusApi({
    required this.code,
    required this.selectedImages,
    required this.rejectedImages,
    required this.waitListedImages,
    required this.lastUpdatedAt,
  });

  factory FolderStatusApi.fromJson(Map<String, dynamic> json) => FolderStatusApi(
    code: json["code"],
    selectedImages: json["selected_images"],
    rejectedImages: json["rejected_images"],
    waitListedImages: json["wait_listed_images"],
    lastUpdatedAt: json["last_updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "selected_images": selectedImages,
    "rejected_images": rejectedImages,
    "wait_listed_images": waitListedImages,
    "last_updated_at": lastUpdatedAt,
  };
}
