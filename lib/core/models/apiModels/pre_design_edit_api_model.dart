// To parse this JSON data, do
//
//     final preDesignEditDbModel = preDesignEditDbModelFromJson(jsonString);

import 'dart:convert';

PreDesignEditDbModel preDesignEditDbModelFromJson(String str) => PreDesignEditDbModel.fromJson(json.decode(str));

String preDesignEditDbModelToJson(PreDesignEditDbModel data) => json.encode(data.toJson());

class PreDesignEditDbModel {
  String? albumId;
  List<AlbumImagesStatus>? albumImagesStatus;

  PreDesignEditDbModel({
    this.albumId,
    this.albumImagesStatus,
  });

  factory PreDesignEditDbModel.fromJson(Map<String, dynamic> json) => PreDesignEditDbModel(
    albumId: json["album_id"],
    albumImagesStatus: List<AlbumImagesStatus>.from(json["album_images_status"].map((x) => AlbumImagesStatus.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "album_id": albumId,
    "album_images_status": List<dynamic>.from(albumImagesStatus!.map((x) => x.toJson())),
  };
}

class AlbumImagesStatus {
  String? id;
  String ?status;

  AlbumImagesStatus({
    this.id,
    this.status,
  });

  factory AlbumImagesStatus.fromJson(Map<String, dynamic> json) => AlbumImagesStatus(
    id: json["id"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
  };
}
