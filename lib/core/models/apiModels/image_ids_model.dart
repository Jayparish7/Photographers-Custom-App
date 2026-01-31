// To parse this JSON data, do
//
//     final imageId = imageIdFromJson(jsonString);

import 'dart:convert';

ImageIdInfo imageIdFromJson(str) => ImageIdInfo.fromJson(json.decode(str));

String imageIdToJson(ImageIdInfo data) => json.encode(data.toJson());

class ImageIdInfo {
  List<ImageId>? imageIds;

  ImageIdInfo({
    this.imageIds,
  });

  factory ImageIdInfo.fromJson(Map<String, dynamic> json) => ImageIdInfo(
    imageIds: List<ImageId>.from(json["image_ids"].map((x) => ImageId.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "image_ids": List<dynamic>.from(imageIds!.map((x) => x.toJson())),
  };
}

class ImageId {
  int ?id;
  int? type;
  String ?imageName;
  String? imageURL;
  int? accessType;

  ImageId({
    this.id,
    this.type,
    this.accessType,
    this.imageName,
    this.imageURL
  });

  factory ImageId.fromJson(Map<String, dynamic> json) => ImageId(
    id: json["id"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
  };
}
