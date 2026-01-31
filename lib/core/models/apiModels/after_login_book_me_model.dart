// To parse this JSON data, do
//
//     final afterLoginBookMeModel = afterLoginBookMeModelFromJson(jsonString);

import 'dart:convert';

AfterLoginBookMeModel afterLoginBookMeModelFromJson(str) =>
    AfterLoginBookMeModel.fromJson(json.decode(str));

String afterLoginBookMeModelToJson(AfterLoginBookMeModel data) =>
    json.encode(data.toJson());

class AfterLoginBookMeModel {
  bool? status;
  String? successMessage;
  String? errorMessage;

  PhotomallEvent? photomallEvent;

  int? lastUpdatedAt;

  AfterLoginBookMeModel({
    this.status,
    this.successMessage,
    this.errorMessage,
    this.photomallEvent,
    this.lastUpdatedAt,
  });

  factory AfterLoginBookMeModel.fromJson(Map<String, dynamic> json) =>
      AfterLoginBookMeModel(
        status: json["status"],
        successMessage: json["success_message"],
        errorMessage: json["error_message"],
        photomallEvent: json["photomall_event"] == null
            ? null
            : PhotomallEvent.fromJson(json["photomall_event"]),
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success_message": successMessage,
        "error_message": errorMessage,
        "photomall_event":
            photomallEvent == null ? null : photomallEvent!.toJson(),
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
      };
}

class PhotomallEvent {
  int? id;
  List<dynamic>? albums;

  PhotomallEvent({
    this.id,
    this.albums,
  });

  factory PhotomallEvent.fromJson(Map<String, dynamic> json) => PhotomallEvent(
        id: json["id"] == null ? null : json["id"],
        albums: json["albums"] == null
            ? null
            : List<dynamic>.from(json["albums"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "albums":
            albums == null ? null : List<dynamic>.from(albums!.map((x) => x)),
      };
}

/*class PhotomallEvent {
  int id;
  Albums albums;

  PhotomallEvent({
    this.id,
    this.albums,
  });

  factory PhotomallEvent.fromJson(Map<String, dynamic> json) => PhotomallEvent(
    id: json["id"] == null ? null : json["id"],
    albums: json["albums"] == null ? null : Albums.fromJson(json["albums"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "albums": albums == null ? null : albums.toJson(),
  };
}*/

/*class Albums {
  List<dynamic> albums;

  Albums({
    this.albums,
  });

  factory Albums.fromJson(Map<String, dynamic> json) => Albums(
    albums: json["albums"] == null ? null : List<dynamic>.from(json["albums"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "albums": albums == null ? null : List<dynamic>.from(albums.map((x) => x)),
  };
}*/
