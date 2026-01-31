// To parse this JSON data, do
//
//     final photoSelectionAlbumListModel = photoSelectionAlbumListModelFromJson(jsonString);

import 'dart:convert';

PhotoSelectionAlbumListModel photoSelectionAlbumListModelFromJson(str) =>
    PhotoSelectionAlbumListModel.fromJson(json.decode(str));

String photoSelectionAlbumListModelToJson(PhotoSelectionAlbumListModel data) =>
    json.encode(data.toJson());

class PhotoSelectionAlbumListModel {
  //PhotoSelectionAlbumListModelData data;

  List<Album>? albums;
  int? lastUpdatedAt;

  PhotoSelectionAlbumListModel({
    this.albums,
    this.lastUpdatedAt,
  });

  factory PhotoSelectionAlbumListModel.fromJson(Map<String, dynamic> json) =>
      PhotoSelectionAlbumListModel(
        albums: json["albums"] == null
            ? null
            : List<Album>.from(json["albums"].map((x) => Album.fromJson(x))),
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "albums": albums == null
            ? null
            : List<dynamic>.from(albums!.map((x) => x.toJson())),
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
      };

/* factory PhotoSelectionAlbumListModel.fromJson(Map<String, dynamic> json) =>
      PhotoSelectionAlbumListModel(
        data: json["data"] == null
            ? null
            : PhotoSelectionAlbumListModelData.fromJson(json["data"]),
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "albums": data == null ? null : data.toJson(),
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
      };*/
}

class PhotoSelectionAlbumListModelData {
  List<Album>? albums;

  PhotoSelectionAlbumListModelData({
    this.albums,
  });

  factory PhotoSelectionAlbumListModelData.fromJson(
          Map<String, dynamic> json) =>
      PhotoSelectionAlbumListModelData(
        albums: json["albums"] == null
            ? null
            : List<Album>.from(json["albums"].map((x) => Album.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "albums": albums == null
            ? null
            : List<dynamic>.from(albums!.map((x) => x.toJson())),
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
  String? albumName;
  int? albumType;
  List<AlbumImage>? albumImages;
  PhotomallEvent? photomallEvent;
  int? albumMovedStatus;

  AlbumData({
    this.id,
    this.albumName,
    this.albumType,
    this.albumImages,
    this.photomallEvent,
    this.albumMovedStatus,
  });

  factory AlbumData.fromJson(Map<String, dynamic> json) => AlbumData(
        id: json["id"] == null ? null : json["id"],
        albumName: json["album_name"] == null ? null : json["album_name"],
        albumType: json["album_type"] == null ? null : json["album_type"],
        albumImages: json["image"] == null
            ? null
            : List<AlbumImage>.from(
                json["image"].map((x) => AlbumImage.fromJson(x))),
        photomallEvent: json["photomall_event"] == null
            ? null
            : PhotomallEvent.fromJson(json["photomall_event"]),
        albumMovedStatus: json["album_moved_status"] == null
            ? null
            : json["album_moved_status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "album_name": albumName == null ? null : albumName,
        "album_type": albumType == null ? null : albumType,
        "image": albumImages == null
            ? null
            : List<dynamic>.from(albumImages!.map((x) => x.toJson())),
        "photomall_event":
            photomallEvent == null ? null : photomallEvent!.toJson(),
        "album_moved_status":
            albumMovedStatus == null ? null : albumMovedStatus,
      };
}

class AlbumImage {
  int? id;
  int? updateStatus;
  AlbumImageData? data;

  AlbumImage({
    this.id,
    this.updateStatus,
    this.data,
  });

  factory AlbumImage.fromJson(Map<String, dynamic> json) => AlbumImage(
        id: json["id"] == null ? null : json["id"],
        updateStatus:
            json["update_status"] == null ? null : json["update_status"],
        data:
            json["data"] == null ? null : AlbumImageData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "update_status": updateStatus == null ? null : updateStatus,
        "data": data == null ? null : data!.toJson(),
      };
}

class AlbumImageData {
  int? id;
  String? name;
  String? resAccessType;
  String? image;
  int? originalSize;
  int? thumbSize;
  int? selectedStatus;
  String? comment;
  int? importanceLevel;

  AlbumImageData(
      {this.id,
      this.name,
      this.resAccessType,
      this.image,
      this.originalSize,
      this.thumbSize,
      this.selectedStatus,
      this.comment,
      this.importanceLevel});

  factory AlbumImageData.fromJson(Map<String, dynamic> json) => AlbumImageData(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        resAccessType: json["access_type"] == null ? null : json["access_type"],
        image: json["image"] == null ? null : json["image"],
        originalSize:
            json["original_size"] == null ? null : json["original_size"],
        thumbSize: json["thumb_size"] == null ? null : json["thumb_size"],
        selectedStatus:
            json["selected_status"] == null ? null : json["selected_status"],
        comment: json["comment"] == null ? null : json["comment"],
        importanceLevel:
            json["importance_level"] == null ? null : json["importance_level"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "access_type": resAccessType == null ? null : resAccessType,
        "image": image == null ? null : image,
        "original_size": originalSize == null ? null : originalSize,
        "thumb_size": thumbSize == null ? null : thumbSize,
        "selected_status": selectedStatus == null ? null : selectedStatus,
        "comment": comment == null ? null : comment,
        "importance_level": importanceLevel == null ? null : importanceLevel,
      };
}

class PhotomallEvent {
  int? id;
  Studio? studio;
  String? eventType;
  String? date;
  String? name;

  PhotomallEvent({
    this.id,
    this.studio,
    this.eventType,
    this.date,
    this.name,
  });

  factory PhotomallEvent.fromJson(Map<String, dynamic> json) => PhotomallEvent(
        id: json["id"] == null ? null : json["id"],
        studio: json["studio"] == null ? null : Studio.fromJson(json["studio"]),
        eventType: json["event_type"] == null ? null : json["event_type"],
        date: json["date"] == null ? null : json["date"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "studio": studio == null ? null : studio!.toJson(),
        "event_type": eventType == null ? null : eventType,
        "date": date == null ? null : date,
        "name": name == null ? null : name,
      };
}

class Studio {
  int? id;
  String? name;
  String? district;
  Logo? logo;
  String? randomUrl;
  String? studioRandomId;

  Studio({
    this.id,
    this.name,
    this.district,
    this.logo,
    this.randomUrl,
    this.studioRandomId,
  });

  factory Studio.fromJson(Map<String, dynamic> json) => Studio(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        district: json["district"] == null ? null : json["district"],
        logo: json["logo"] == null ? null : Logo.fromJson(json["logo"]),
        randomUrl: json["random_url"] == null ? null : json["random_url"],
        studioRandomId:
            json["studio_random_id"] == null ? null : json["studio_random_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "district": district == null ? null : district,
        "logo": logo == null ? null : logo!.toJson(),
        "random_url": randomUrl == null ? null : randomUrl,
        "studio_random_id": studioRandomId == null ? null : studioRandomId,
      };
}

class Logo {
  int? id;
  String? name;
  String? image;

  Logo({
    this.id,
    this.name,
    this.image,
  });

  factory Logo.fromJson(Map<String, dynamic> json) => Logo(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "image": image == null ? null : image,
      };
}
