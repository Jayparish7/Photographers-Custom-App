// To parse this JSON data, do
//
//     final inputData = inputDataFromJson(jsonString);

import 'dart:convert';

eventInputData inputDataFromJson(str) => eventInputData.fromJson(json.decode(str));

String inputDataToJson(eventInputData data) => json.encode(data.toJson());

class eventInputData {
  eventInputData({
    this.eventData,
  });

  List<EventData>? eventData;

  factory eventInputData.fromJson(Map<String, dynamic> json) => eventInputData(
    eventData: json["event_data "] == null ? null : List<EventData>.from(json["event_data "].map((x) => EventData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "event_data ": eventData == null ? null : List<dynamic>.from(eventData!.map((x) => x.toJson())),
  };
}

class EventData {
  EventData({
    this.id,
    this.data,
  });

  int ?id;
  Data? data;

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
    id: json["id"] == null ? null : json["id"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "data": data == null ? null : data!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.lastUpdatedAt,
    this.name,
    this.eventCategoryName,
    this.publish,
    this.coverImage,
    this.photomallEventUrl,
    this.albums,
    this.videos,
  });

  int ?id;
  int? lastUpdatedAt;
  String ?name;
  String ?eventCategoryName;
  int ?publish;
  CoverImage ?coverImage;
  String ?photomallEventUrl;
  List<Album> ?albums;
  List<Video> ?videos;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],
    name: json["name"] == null ? null : json["name"],
    eventCategoryName: json["event_category_name"] == null ? null : json["event_category_name"],
    publish: json["publish"] == null ? null : json["publish"],
    coverImage: json["cover_image"] == null ? null : CoverImage.fromJson(json["cover_image"]),
    photomallEventUrl: json["photomall_event_url"] == null ? null : json["photomall_event_url"],
    albums: json["albums"] == null ? null : List<Album>.from(json["albums"].map((x) => Album.fromJson(x))),
    videos: json["videos"] == null ? null : List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
    "name": name == null ? null : name,
    "event_category_name": eventCategoryName == null ? null : eventCategoryName,
    "publish": publish == null ? null : publish,
    "cover_image": coverImage == null ? null : coverImage!.toJson(),
    "photomall_event_url": photomallEventUrl == null ? null : photomallEventUrl,
    "albums": albums == null ? null : List<dynamic>.from(albums!.map((x) => x.toJson())),
    "videos": videos == null ? null : List<dynamic>.from(videos!.map((x) => x.toJson())),
  };
}

class Album {
  Album({
    this.id,
    this.publish,
    this.name,
    this.albumType,
    this.albumSize,
    this.priorityScore,
    this.coverImage,
  });

  int? id;
  int? publish;
  String ?name;
  int ?albumType;
  AlbumSize ?albumSize;
  int ?priorityScore;
  dynamic coverImage;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    id: json["id"] == null ? null : json["id"],
    publish: json["publish"] == null ? null : json["publish"],
    name: json["name"] == null ? null : json["name"],
    albumType: json["album_type"] == null ? null : json["album_type"],
    albumSize: json["album_size"] == null ? null : AlbumSize.fromJson(json["album_size"]),
    priorityScore: json["priority_score"] == null ? null : json["priority_score"],
    coverImage: json["cover_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "publish": publish == null ? null : publish,
    "name": name == null ? null : name,
    "album_type": albumType == null ? null : albumType,
    "album_size": albumSize == null ? null : albumSize!.toJson(),
    "priority_score": priorityScore == null ? null : priorityScore,
    "cover_image": coverImage,
  };
}

class AlbumSize {
  AlbumSize({
    this.type,
    this.size,
  });

  String ?type;
  String ?size;

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
    this.name,
    this.mode,
    this.size,
  });

  int? id;
  String? name;
  String ?mode;
  int? size;

  factory CoverImage.fromJson(Map<String, dynamic> json) => CoverImage(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    mode: json["mode"] == null ? null : json["mode"],
    size: json["size"] == null ? null : json["size"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "mode": mode == null ? null : mode,
    "size": size == null ? null : size,
  };
}

class Video {
  Video({
    this.id,
    this.publish,
    this.name,
    this.url,
    this.priorityScore,
  });

  int? id;
  int ?publish;
  String ?name;
  String ?url;
  int? priorityScore;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: json["id"] == null ? null : json["id"],
    publish: json["publish"] == null ? null : json["publish"],
    name: json["name"] == null ? null : json["name"],
    url: json["url"] == null ? null : json["url"],
    priorityScore: json["priority_score"] == null ? null : json["priority_score"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "publish": publish == null ? null : publish,
    "name": name == null ? null : name,
    "url": url == null ? null : url,
    "priority_score": priorityScore == null ? null : priorityScore,
  };
}
