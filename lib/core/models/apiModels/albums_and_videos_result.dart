// To parse this JSON data, do
//
//     final albumsAndVideosResult = albumsAndVideosResultFromJson(jsonString);

import 'dart:convert';

AlbumsAndVideosResult albumsAndVideosResultFromJson(str) =>
    AlbumsAndVideosResult.fromJson(json.decode(str));

String albumsAndVideosResultToJson(AlbumsAndVideosResult data) =>
    json.encode(data.toJson());

class AlbumsAndVideosResult {
  AlbumsAndVideosResult({
    this.photomallEvent,
    this.lastUpdatedAt,
  });

  PhotomallEvent? photomallEvent;
  int? lastUpdatedAt;

  factory AlbumsAndVideosResult.fromJson(Map<String, dynamic> json) =>
      AlbumsAndVideosResult(
        photomallEvent: json["photomall_event"] == null
            ? null
            : PhotomallEvent.fromJson(json["photomall_event"]),
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "photomall_event":
            photomallEvent == null ? null : photomallEvent!.toJson(),
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
      };
}

class PhotomallEvent {
  PhotomallEvent({
    this.id,
    this.name,
    this.coverImage,
    this.albums,
    this.durations,
    this.videos,
    this.invitation,
  });

  String? id;
  String? name;
  CoverImage? coverImage;
  List<Album>? albums;
  List<Duration>? durations;
  List<Video>? videos;
  Invitation? invitation;

  factory PhotomallEvent.fromJson(Map<String, dynamic> json) => PhotomallEvent(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        coverImage: json["cover_image"] == null
            ? null
            : CoverImage.fromJson(json["cover_image"]),
        albums: json["albums"] == null
            ? null
            : List<Album>.from(json["albums"].map((x) => Album.fromJson(x))),
        durations: json["durations"] == null
            ? null
            : List<Duration>.from(
                json["durations"].map((x) => Duration.fromJson(x))),
        videos: json["videos"] == null
            ? null
            : List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
        invitation: json["invitation"] == null
            ? null
            : Invitation.fromJson(json["invitation"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "albums": albums == null
            ? null
            : List<dynamic>.from(albums!.map((x) => x.toJson())),
        "durations": durations == null
            ? null
            : List<dynamic>.from(durations!.map((x) => x.toJson())),
        "videos": videos == null
            ? null
            : List<dynamic>.from(videos!.map((x) => x.toJson())),
        "invitation": invitation == null ? null : invitation!.toJson(),
      };
}

class Album {
  Album({
    this.id,
    this.updateStatus,
    this.publish,
    this.data,
  });

  String? id;
  int? updateStatus;
  int? publish;
  AlbumData? data;

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
  AlbumData({
    this.id,
    this.name,
    this.albumType,
    this.music,
    this.albumSize,
    this.coverImage,
  });

  int? id;
  String? name;
  int? albumType;
  List<Music>? music;
  AlbumSize? albumSize;
  CoverImage? coverImage;

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
      };
}

class AlbumSize {
  AlbumSize({
    this.type,
    this.size,
  });

  String? type;
  String? size;

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
  CoverImage({
    this.id,
    this.updateStatus,
    this.data,
  });

  int? id;
  int? updateStatus;
  CoverImageData? data;

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
  CoverImageData(
      {this.id,
      this.resAccessType,
      this.image,
      this.originalSize,
      this.thumbSize,
      this.imageOrder,
      this.accessType});

  int? id;
  String? resAccessType;
  String? image;
  int? originalSize;
  int? thumbSize;
  int? imageOrder;
  int? accessType;

  factory CoverImageData.fromJson(Map<String, dynamic> json) => CoverImageData(
        id: json["id"] == null ? null : json["id"],
        resAccessType: json["access_type"] == null ? null : json["access_type"],
        image: json["image"] == null ? null : json["image"],
        originalSize:
            json["original_size"] == null ? null : json["original_size"],
        thumbSize: json["thumb_size"] == null ? null : json["thumb_size"],
        imageOrder: json["image_order"] == null ? null : json["image_order"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "access_type": resAccessType == null ? null : resAccessType,
        "image": image == null ? null : image,
        "original_size": originalSize == null ? null : originalSize,
        "thumb_size": thumbSize == null ? null : thumbSize,
        "image_order": imageOrder == null ? null : imageOrder,
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

class Duration {
  Duration({
    this.id,
    this.updateStatus,
    this.data,
  });

  int? id;
  int? updateStatus;
  DurationData? data;

  factory Duration.fromJson(Map<String, dynamic> json) => Duration(
        id: json["id"] == null ? null : json["id"],
        updateStatus:
            json["update_status"] == null ? null : json["update_status"],
        data: json["data"] == null ? null : DurationData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "update_status": updateStatus == null ? null : updateStatus,
        "data": data == null ? null : data!.toJson(),
      };
}

class DurationData {
  DurationData({
    this.id,
    this.name,
    this.date,
    this.startTime,
    this.endTime,
    this.addresses,
  });

  int? id;
  String? name;
  String? date;
  String? startTime;
  String? endTime;
  List<Address>? addresses;

  factory DurationData.fromJson(Map<String, dynamic> json) => DurationData(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        //date: json["date"] == null ? null : DateTime.parse(json["date"]),
        date: json["date"] == null ? null : json["date"],
        startTime: json["start_time"] == null ? null : json["start_time"],
        endTime: json["end_time"] == null ? null : json["end_time"],
        addresses: json["addresses"] == null
            ? null
            : List<Address>.from(
                json["addresses"].map((x) => Address.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        //"date": date == null ? null : "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "date": date == null ? null : date,
        "start_time": startTime == null ? null : startTime,
        "end_time": endTime == null ? null : endTime,
        "addresses": addresses == null
            ? null
            : List<dynamic>.from(addresses!.map((x) => x.toJson())),
      };
}

class Address {
  Address({
    this.id,
    this.updateStatus,
    this.data,
  });

  int? id;
  int? updateStatus;
  AddressData? data;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"] == null ? null : json["id"],
        updateStatus:
            json["update_status"] == null ? null : json["update_status"],
        data: json["data"] == null ? null : AddressData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "update_status": updateStatus == null ? null : updateStatus,
        "data": data == null ? null : data!.toJson(),
      };
}

class AddressData {
  AddressData({
    this.id,
    this.street,
    this.locality,
    this.district,
    this.state,
    this.country,
    this.pincode,
  });

  int? id;
  String? street;
  String? locality;
  String? district;
  String? state;
  String? country;
  String? pincode;

  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
        id: json["id"] == null ? null : json["id"],
        street: json["street"] == null ? null : json["street"],
        locality: json["locality"] == null ? null : json["locality"],
        district: json["district"] == null ? null : json["district"],
        state: json["state"] == null ? null : json["state"],
        country: json["country"] == null ? null : json["country"],
        pincode: json["pincode"] == null ? null : json["pincode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "street": street == null ? null : street,
        "locality": locality == null ? null : locality,
        "district": district == null ? null : district,
        "state": state == null ? null : state,
        "country": country == null ? null : country,
        "pincode": pincode == null ? null : pincode,
      };
}

class Invitation {
  Invitation({
    this.id,
    this.name,
    this.type,
    this.updateStatus,
    this.albumImages,
    //this.data,
  });

  int? id;
  String? name;
  int? type;
  int? updateStatus;
  List<CoverImage>? albumImages;

  //InvitationData data;

  factory Invitation.fromJson(Map<String, dynamic> json) => Invitation(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : json["type"],
        updateStatus:
            json["update_status"] == null ? null : json["update_status"],
        albumImages: json["album_images"] == null
            ? null
            : List<CoverImage>.from(
                json["album_images"].map((x) => CoverImage.fromJson(x))),
        //data: json["data"] == null ? null : InvitationData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "type": type == null ? null : type,
        "update_status": updateStatus == null ? null : updateStatus,
        "album_images": albumImages == null
            ? null
            : List<dynamic>.from(albumImages!.map((x) => x.toJson())),
        //"data": data == null ? null : data.toJson(),
      };
}

class InvitationData {
  InvitationData({
    this.name,
    this.type,
    this.albumImages,
  });

  String? name;
  int? type;
  List<CoverImage>? albumImages;

  factory InvitationData.fromJson(Map<String, dynamic> json) => InvitationData(
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : json["type"],
        albumImages: json["album_images"] == null
            ? null
            : List<CoverImage>.from(
                json["album_images"].map((x) => CoverImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "type": type == null ? null : type,
        "album_images": albumImages == null
            ? null
            : List<dynamic>.from(albumImages!.map((x) => x.toJson())),
      };
}

class Video {
  Video({
    this.id,
    this.updateStatus,
    this.publish,
    this.data,
  });

  int? id;
  int? updateStatus;
  int? publish;
  VideoData? data;

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
  VideoData({
    this.id,
    this.name,
    this.url,
  });

  int? id;
  String? name;
  String? url;

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
