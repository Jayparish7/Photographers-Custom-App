// To parse this JSON data, do
//
//     final imageOriginalUrl = imageOriginalUrlFromJson(jsonString);

import 'dart:convert';

ImageOriginalUrl imageOriginalUrlFromJson(str) => ImageOriginalUrl.fromJson(json.decode(str));

String imageOriginalUrlToJson(ImageOriginalUrl data) => json.encode(data.toJson());

class ImageOriginalUrl {
  ImageOriginalUrlData? data;

  ImageOriginalUrl({
    this.data,
  });

  factory ImageOriginalUrl.fromJson(Map<String, dynamic> json) => ImageOriginalUrl(
    data: json["data"] == null ? null : ImageOriginalUrlData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data!.toJson(),
  };
}

class ImageOriginalUrlData {
  List<ImageValue>? images;

  ImageOriginalUrlData({
    this.images,
  });

  factory ImageOriginalUrlData.fromJson(Map<String, dynamic> json) => ImageOriginalUrlData(
    images: json["images"] == null ? null : List<ImageValue>.from(json["images"].map((x) => ImageValue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "images": images == null ? null : List<dynamic>.from(images!.map((x) => x.toJson())),
  };
}

class ImageValue {
  int? id;
  String? status;
  String? imageName;
  URLDetail? detail;
  int? type;

  ImageValue({
    this.id,
    this.status,
    this.imageName,
    this.detail,
    this.type,
  });

  factory ImageValue.fromJson(Map<String, dynamic> json) => ImageValue(
    id: json["id"] == null ? null : json["id"],
    status: json["status"] == null ? null : json["status"],
    imageName: json["image_name"] == null ? null : json["image_name"],
    detail: json["detail"] == null ? null : URLDetail.fromJson(json["detail"]),
    type: json["type"] == null ? null : json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "status": status == null ? null : status,
    "image_name": imageName == null ? null : imageName,
    "detail": detail == null ? null : detail!.toJson(),
    "type": type == null ? null : type,
  };
}

class URLDetail {
  String? originalUrl;
  String? thumbUrl;

  URLDetail({
    this.originalUrl,
    this.thumbUrl,
  });

  factory URLDetail.fromJson(Map<String, dynamic> json) => URLDetail(
    originalUrl: json["original_url"] == null ? null : json["original_url"],
    thumbUrl: json["thumb_url"] == null ? null : json["thumb_url"],
  );

  Map<String, dynamic> toJson() => {
    "original_url": originalUrl == null ? null : originalUrl,
    "thumb_url": thumbUrl == null ? null : thumbUrl,
  };
}
