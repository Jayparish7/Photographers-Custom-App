// To parse this JSON data, do
//
//     final addAlbumImagesModel = addAlbumImagesModelFromJson(jsonString);

import 'dart:convert';

AddAlbumImagesModel addAlbumImagesModelFromJson(str) => AddAlbumImagesModel.fromJson(json.decode(str));

String addAlbumImagesModelToJson(AddAlbumImagesModel data) => json.encode(data.toJson());

class AddAlbumImagesModel {

  Album? album;
  int? lastUpdatedAt;

  AddAlbumImagesModel({
    this.album,
    this.lastUpdatedAt
  });

  factory AddAlbumImagesModel.fromJson(Map<String, dynamic> json) => AddAlbumImagesModel(
    album: json["album"] == null ? null : Album.fromJson(json["album"]),
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],

  );

  Map<String, dynamic> toJson() => {
    "album": album == null ? null : album!.toJson(),
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
  };
}

class AddAlbumImagesModelData {
  Album? album;

  AddAlbumImagesModelData({
    this.album,
  });

  factory AddAlbumImagesModelData.fromJson(Map<String, dynamic> json) => AddAlbumImagesModelData(
    album: json["album"] == null ? null : Album.fromJson(json["album"]),
  );

  Map<String, dynamic> toJson() => {
    "album": album == null ? null : album!.toJson(),
  };
}

class Album {
  String? id;
  String? name;
  MusicData? musicData;
  List<Image>? images;
  int? lastUpdatedAt;

  Album({
    this.id,
    this.name,
    this.musicData,
    this.images,
    this.lastUpdatedAt,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    musicData: json["music"] == null ? null : MusicData.fromJson(json["music"]),
    images: json["images"] == null ? null : List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "music": musicData == null ? null : musicData!.toJson(),
    "images": images == null ? null : List<dynamic>.from(images!.map((x) => x.toJson())),
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
  };
}

class MusicData {
  MusicData({
    this.id,
    this.resAccessType,
    //this.accessType,
    this.file,
    this.extension,
    this.size,
  });

  int? id;
  String? resAccessType;
  //String? accessType;
  String? file;
  String? extension;
  int? size;

  factory MusicData.fromJson(Map<String, dynamic> json) => MusicData(
    id: json["id"] == null ? null : json["id"],
    resAccessType: json["access_type"] == null ? null : json["access_type"],
    file: json["file"] == null ? null : json["file"],
    extension: json["extension"] == null ? null : json["extension"],
    size: json["size"] == null ? null : json["size"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "access_type": resAccessType == null ? null : resAccessType,
    "file": file == null ? null : file,
    "extension": extension == null ? null : extension,
    "size": size == null ? null : size,
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
  //String? name;
  String? image;
  int? originalSize;
  int? thumbSize;
  int? selectedStatus;
  int? imageOrder;
  int? accessType;
  String? resAccessType;

  ImageData({
    this.id,
    //this.name,
    this.image,
    this.originalSize,
    this.thumbSize,
    this.selectedStatus,
    this.imageOrder,
    this.accessType,
    this.resAccessType
  });

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
    id: json["id"] == null ? null : json["id"],
    //name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
    originalSize: json["original_size"] == null ? null : json["original_size"],
    thumbSize: json["thumb_size"] == null ? null : json["thumb_size"],
    selectedStatus: json["selected_status"] == null ? null : json["selected_status"],
    imageOrder: json["image_order"] == null ? null : json["image_order"],
    resAccessType: json["access_type"] == null ? null : json["access_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    //"name": name == null ? null : name,
    "image": image == null ? null : image,
    "original_size": originalSize == null ? null : originalSize,
    "thumb_size": thumbSize == null ? null : thumbSize,
    "selected_status": selectedStatus == null ? null : selectedStatus,
    "image_order": imageOrder == null ? null : imageOrder,
    "access_type": resAccessType == null ? null : resAccessType,
  };
}