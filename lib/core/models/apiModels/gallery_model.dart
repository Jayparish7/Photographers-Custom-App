// To parse this JSON data, do
//
//     final galleryAlbumsAndVideos = galleryAlbumsAndVideosFromJson(jsonString);

import 'dart:convert';

import 'package:photomall_flutter/core/models/apiModels/albums_and_videos_result.dart';

GalleryAlbumsAndVideos galleryAlbumsAndVideosFromJson(str) =>
    GalleryAlbumsAndVideos.fromJson(json.decode(str));

String galleryAlbumsAndVideosToJson(GalleryAlbumsAndVideos data) =>
    json.encode(data.toJson());

class GalleryAlbumsAndVideos {
  List<Datum>? photomallEvents;
  int? lastUpdatedAt;

  GalleryAlbumsAndVideos({
    this.photomallEvents,
    this.lastUpdatedAt,
  });

  factory GalleryAlbumsAndVideos.fromJson(Map<String, dynamic> json) =>
      GalleryAlbumsAndVideos(
        photomallEvents: json["photomall_events"] == null
            ? null
            : List<Datum>.from(
                json["photomall_events"].map((x) => Datum.fromJson(x))),
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "photomall_events": photomallEvents == null
            ? null
            : List<dynamic>.from(photomallEvents!.map((x) => x.toJson())),
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
      };
}

class Datum {
  String? code;
  int? updateStatus;

  int? publish;

  DatumData? data;

  Datum({
    this.code,
    this.updateStatus,
    this.publish,
    this.data,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        code: json["id"] == null ? null : json["id"],
        updateStatus:
            json["update_status"] == null ? null : json["update_status"],
        publish: json["publish"] == null ? null : json["publish"],
        data: json["data"] == null ? null : DatumData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": code == null ? null : code,
        "update_status": updateStatus == null ? null : updateStatus,
        "publish": publish == null ? null : publish,
        "data": data == null ? null : data!.toJson(),
      };
}

class DatumData {
  int? id;
  String? eventCategoryName;
  List<Album>? albums;
  List<Video>? videos;

  DatumData({
    this.id,
    this.eventCategoryName,
    this.albums,
    this.videos,
  });

  factory DatumData.fromJson(Map<String, dynamic> json) => DatumData(
        eventCategoryName: json["event_category_name"] == null
            ? null
            : json["event_category_name"],
        albums: json["albums"] == null
            ? null
            : List<Album>.from(json["albums"].map((x) => Album.fromJson(x))),
        videos: json["videos"] == null
            ? null
            : List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "event_category_name":
            eventCategoryName == null ? null : eventCategoryName,
        "albums": albums == null
            ? null
            : List<dynamic>.from(albums!.map((x) => x.toJson())),
        "videos": videos == null
            ? null
            : List<dynamic>.from(videos!.map((x) => x.toJson())),
      };
}

class Album {
  String? id;
  int? updateStatus;
  int? publish;
  AlbumData? data;

  Album({
    this.id,
    this.updateStatus,
    this.publish,
    this.data,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        id: json["id"] == null ? null : json["id"],
        updateStatus:
            json["update_status"] == null ? null : json["update_status"],
        publish: json["publish"] == null ? null : json["publish"],
        data: json["data"] == null ? null : AlbumData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "update_status": updateStatus == null ? null : updateStatus,
        "publish": publish == null ? null : publish,
        "data": data == null ? null : data!.toJson(),
      };
}

class AlbumData {
  int? id;
  String? name;
  int? albumType;
  List<Music>? music;
  AlbumSize? albumSize;
  CoverImage? coverImage;
  int? lastUpdatedAt;

  AlbumData({
    this.id,
    this.name,
    this.albumType,
    this.music,
    this.albumSize,
    this.coverImage,
    this.lastUpdatedAt,
  });

  factory AlbumData.fromJson(Map<String, dynamic> json) => AlbumData(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        albumType: json["album_type"] == null ? null : json["album_type"],
        music: json["music"] == null
            ? null
            : List<Music>.from(json["music"].map((x) => Music.fromJson(x))),
        albumSize: json["album_size"] == null
            ? null
            : AlbumSize.fromJson(json["album_size"]),
        coverImage: json["cover_image"] == null
            ? null
            : CoverImage.fromJson(json["cover_image"]),
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "album_type": albumType == null ? null : albumType,
        "music": music == null
            ? null
            : List<dynamic>.from(music!.map((x) => x.toJson())),
        "album_size": albumSize == null ? null : albumSize!.toJson(),
        "cover_image": coverImage == null ? null : coverImage!.toJson(),
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
      };
}

class Music {
  Music({
    this.id,
    this.updateStatus,
    this.data,
  });

  int? id;
  int? updateStatus;
  MusicData? data;

  factory Music.fromJson(Map<String, dynamic> json) => Music(
        id: json["id"] == null ? null : json["id"],
        updateStatus:
            json["update_status"] == null ? null : json["update_status"],
        data: json["data"] == null ? null : MusicData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "update_status": updateStatus == null ? null : updateStatus,
        "data": data == null ? null : data!.toJson(),
      };
}

class MusicData {
  MusicData({
    this.id,
    this.resAccessType,
    this.file,
    this.extension,
    this.size,
  });

  int? id;
  String? resAccessType;
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

class AlbumSize {
  String? type;
  String? size;

  AlbumSize({
    this.type,
    this.size,
  });

  factory AlbumSize.fromJson(Map<String, dynamic> json) => AlbumSize(
        type: json["type"] == null ? null : json["type"],
        size: json["size"] == null ? null : json["size"],
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "size": size == null ? null : size,
      };
}

class CoverImage {
  int? id;
  int? updateStatus;
  CoverImageData? data;

  CoverImage({
    this.id,
    this.updateStatus,
    this.data,
  });

  factory CoverImage.fromJson(Map<String, dynamic> json) => CoverImage(
        id: json["id"] == null ? null : json["id"],
        updateStatus:
            json["update_status"] == null ? null : json["update_status"],
        data:
            json["data"] == null ? null : CoverImageData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "update_status": updateStatus == null ? null : updateStatus,
        "data": data == null ? null : data!.toJson(),
      };
}

class CoverImageData {
  int? id;
  String? resAccessType;
  String? image;
  int? originalSize;
  int? thumbSize;
  int? selectedStatus;
  int? imageOrder;

  CoverImageData({
    this.id,
    this.resAccessType,
    this.image,
    this.originalSize,
    this.thumbSize,
    this.selectedStatus,
    this.imageOrder,
  });

  factory CoverImageData.fromJson(Map<String, dynamic> json) => CoverImageData(
        id: json["id"] == null ? null : json["id"],
        resAccessType: json["access_type"] == null ? null : json["access_type"],
        image: json["image"] == null ? null : json["image"],
        originalSize:
            json["original_size"] == null ? null : json["original_size"],
        thumbSize: json["thumb_size"] == null ? null : json["thumb_size"],
        selectedStatus:
            json["selected_status"] == null ? null : json["selected_status"],
        imageOrder: json["image_order"] == null ? null : json["image_order"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "access_type": resAccessType == null ? null : resAccessType,
        "image": image == null ? null : image,
        "original_size": originalSize == null ? null : originalSize,
        "thumb_size": thumbSize == null ? null : thumbSize,
        "selected_status": selectedStatus == null ? null : selectedStatus,
        "image_order": imageOrder == null ? null : imageOrder,
      };
}

class Video {
  int? id;
  int? updateStatus;
  int? publish;
  VideoData? data;

  Video({
    this.id,
    this.updateStatus,
    this.publish,
    this.data,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json["id"] == null ? null : json["id"],
        updateStatus:
            json["update_status"] == null ? null : json["update_status"],
        publish: json["publish"] == null ? null : json["publish"],
        data: json["data"] == null ? null : VideoData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "update_status": updateStatus == null ? null : updateStatus,
        "publish": publish == null ? null : publish,
        "data": data == null ? null : data!.toJson(),
      };
}

class VideoData {
  int? id;
  String? name;
  String? url;

  VideoData({
    this.id,
    this.name,
    this.url,
  });

  factory VideoData.fromJson(Map<String, dynamic> json) => VideoData(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "url": url == null ? null : url,
      };
}
