// To parse this JSON data, do
//
//     final photoSelectionImagesResponseModel = photoSelectionImagesResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:photomall_flutter/ui/folders/folder_photo_selection_model.dart';

PhotoSelectionImagesResponseModel photoSelectionImagesResponseModelFromJson(str) => PhotoSelectionImagesResponseModel.fromJson(json.decode(str));

String photoSelectionImagesResponseModelToJson(PhotoSelectionImagesResponseModel data) => json.encode(data.toJson());

class PhotoSelectionImagesResponseModel {
  PhotoSelectionImagesResponseModel({
    this.photoSelectionImages,
    this.lastUpdatedAt,
  });

  List<PhotoSelectionImage>? photoSelectionImages;
  int? lastUpdatedAt;

  factory PhotoSelectionImagesResponseModel.fromJson(Map<String, dynamic> json) => PhotoSelectionImagesResponseModel(
    photoSelectionImages: json["photo_selection_images"] == null ? null : List<PhotoSelectionImage>.from(json["photo_selection_images"].map((x) => PhotoSelectionImage.fromJson(x))),
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "photo_selection_images": photoSelectionImages == null ? null : List<dynamic>.from(photoSelectionImages!.map((x) => x.toJson())),
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
  };
}


