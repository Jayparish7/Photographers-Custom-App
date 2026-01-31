// To parse this JSON data, do
//
//     final albumModel = albumModelFromJson(jsonString);

import 'dart:convert';

AlbumModel albumModelFromJson(str) => AlbumModel.fromJson(json.decode(str));

String albumModelToJson(AlbumModel data) => json.encode(data.toJson());

class AlbumModel {
  AlbumModelData? data;
  int? lastUpdatedAt;

  AlbumModel({
    this.data,
    this.lastUpdatedAt
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) => AlbumModel(
    data: json["album"] == null ? null : AlbumModelData.fromJson(json["album"]),
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "album": data == null ? null : data!.toJson(),
    "last_updated_at" : lastUpdatedAt == null ? null : lastUpdatedAt,
  };
}

class AlbumModelData {
  /*Album album;

  AlbumModelData({
    this.album,
  });

  factory AlbumModelData.fromJson(Map<String, dynamic> json) => AlbumModelData(
    album: json["album"] == null ? null : Album.fromJson(json["album"]),
  );

  Map<String, dynamic> toJson() => {
    "album": album == null ? null : album.toJson(),
  };*/

  String? id;
  String? name;
  List<Image>? images;
  //int lastUpdatedAt;

  AlbumModelData({
    this.id,
    this.name,
    this.images,
    //this.lastUpdatedAt,
  });

  factory AlbumModelData.fromJson(Map<String, dynamic> json) => AlbumModelData(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    images: json["images"] == null ? null : List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    //lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "images": images == null ? null : List<dynamic>.from(images!.map((x) => x.toJson())),
    //"last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
  };
}

class Album {
  int? id;
  String? name;
  List<Image>? images;
  int? lastUpdatedAt;

  Album({
    this.id,
    this.name,
    this.images,
    this.lastUpdatedAt,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    images: json["images"] == null ? null : List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "images": images == null ? null : List<dynamic>.from(images!.map((x) => x.toJson())),
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
  };
}

class Image {
  int? id;
  int? updateStatus;
  ImageData? data;

  Image({
    this.id,
    this.updateStatus,
    this.data,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    id: json["id"] == null ? null : json["id"],
    updateStatus: json["update_status"] == null ? null : json["update_status"],
    data: json["data"] == null ? null : ImageData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "update_status": updateStatus == null ? null : updateStatus,
    "data": data == null ? null : data!.toJson(),
  };
}

class ImageData {
  int? id;
  String? resAccessType;
  //String name;
  String ?image;
  int? originalSize;
  int? thumbSize;
  int? selectedStatus;
  int? imageOrder;
  String ?comment;
  int ?importantLevel;

  ImageData({
    this.id,
    this.resAccessType,
    //this.name,
    this.image,
    this.originalSize,
    this.thumbSize,
    this.selectedStatus,
    this.imageOrder,
    this.comment,
    this.importantLevel
  });

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
    id: json["id"] == null ? null : json["id"],
    resAccessType: json["access_type"] == null ? null : json["access_type"],
    //name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
    originalSize: json["original_size"] == null ? null : json["original_size"],
    thumbSize: json["thumb_size"] == null ? null : json["thumb_size"],
    selectedStatus: json["selected_status"] == null ? null : json["selected_status"],
    imageOrder: json["image_order"] == null ? null : json["image_order"],
    comment: json["comment"] == null ? null : json["comment"],
    importantLevel: json["importance_level"] == null ? null : json["importance_level"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "access_type": resAccessType == null ? null : resAccessType,
    //"name": name == null ? null : name,
    "image": image == null ? null : image,
    "original_size": originalSize == null ? null : originalSize,
    "thumb_size": thumbSize == null ? null : thumbSize,
    "selected_status": selectedStatus == null ? null : selectedStatus,
    "image_order": imageOrder == null ? null : imageOrder,
    "comment": comment == null ? null : comment,
    "importance_level": importantLevel == null ? null : importantLevel,
  };
}
