import 'dart:convert';

EventsIndexModel eventsIndexModelFromJson(str) => EventsIndexModel.fromJson(json.decode(str));

String eventsIndexModelToJson(EventsIndexModel data) => json.encode(data.toJson());

class EventsIndexModel {
  //EventsIndexModelData data;
  List<PhotomallEvent>? photomallEvents;
  int? lastUpdatedAt;

  EventsIndexModel({
    this.photomallEvents,
    this.lastUpdatedAt
  });

  factory EventsIndexModel.fromJson(Map<String, dynamic> json) => EventsIndexModel(
    photomallEvents: json["photomall_events"] == null ? null : List<PhotomallEvent>.from(json["photomall_events"].map((x) => PhotomallEvent.fromJson(x))),
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "photomall_events": photomallEvents == null ? null : List<dynamic>.from(photomallEvents!.map((x) => x.toJson())),
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
  };

  /*EventsIndexModel({
    this.data,
    this.lastUpdatedAt,
  });*/

  /*factory EventsIndexModel.fromJson(Map<String, dynamic> json) => EventsIndexModel(
    data: json["photomall_events"] == null ? null : EventsIndexModelData.fromJson(json["photomall_events"]),
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "photomall_events": data == null ? null : data.toJson(),
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
  };*/
}

class EventsIndexModelData {
  List<PhotomallEvent>? photomallEvents;

  EventsIndexModelData({
    this.photomallEvents,
  });

  factory EventsIndexModelData.fromJson(Map<String, dynamic> json) => EventsIndexModelData(
    photomallEvents: json["photomall_events"] == null ? null : List<PhotomallEvent>.from(json["photomall_events"].map((x) => PhotomallEvent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "photomall_events": photomallEvents == null ? null : List<dynamic>.from(photomallEvents!.map((x) => x.toJson())),
  };
}

class PhotomallEvent {
  String? code;
  int? updateStatus;
  int? publish;
  int? eventType;
  PhotomallEventData? data;

  PhotomallEvent({
    this.code,
    this.updateStatus,
    this.publish,
    this.eventType,
    this.data,
  });

  factory PhotomallEvent.fromJson(Map<String, dynamic> json) => PhotomallEvent(
    code: json["id"] == null ? null : json["id"],
    updateStatus: json["update_status"] == null ? null : json["update_status"],
    publish: json["publish"] == null ? null : json["publish"],
    eventType: json["event_type"] == null ? null : json["event_type"],
    data: json["data"] == null ? null : PhotomallEventData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "id": code == null ? null : code,
    "update_status": updateStatus == null ? null : updateStatus,
    "publish": publish == null ? null : publish,
    "event_type": eventType == null ? null : eventType,
    "data": data == null ? null : data!.toJson(),
  };
}

class PhotomallEventData {
  int? id;
  String ?name;
  String? eventCategoryName;
  //List<CoverImage> coverImage;
  CoverImage? coverImage;
  int? loginRequired;
  int? visibilityCount;
  String? photomallEventUrl;


  PhotomallEventData({
    this.id,
    this.name,
    this.eventCategoryName,
    this.coverImage,
    this.loginRequired,
    this.visibilityCount,
    this.photomallEventUrl,
  });

  factory PhotomallEventData.fromJson(Map<String, dynamic> json) => PhotomallEventData(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    eventCategoryName: json["event_category_name"] == null ? null : json["event_category_name"],
    //coverImage: json["cover_image"] == null ? null : List<CoverImage>.from(json["cover_image"].map((x) => CoverImage.fromJson(x))),
    coverImage: json["cover_image"] == null ? null : CoverImage.fromJson(json["cover_image"]),
    loginRequired: json["login_required"] == null ? null : json["login_required"],
    visibilityCount: json["visibility_count"] == null ? null : json["visibility_count"],
    photomallEventUrl: json["photomall_event_url"] == null ? null : json["photomall_event_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "event_category_name": eventCategoryName == null ? null : eventCategoryName,
    //"cover_image": coverImage == null ? null : List<dynamic>.from(coverImage.map((x) => x.toJson())),
    "cover_image": coverImage == null ? null : coverImage,
    "login_required": loginRequired == null ? null : loginRequired,
    "visibility_count": visibilityCount == null ? null : visibilityCount,
    "photomall_event_url": photomallEventUrl == null ? null : photomallEventUrl,
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
    updateStatus: json["update_status"] == null ? null : json["update_status"],
    data: json["data"] == null ? null : CoverImageData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "update_status": updateStatus == null ? null : updateStatus,
    "data": data == null ? null : data!.toJson(),
  };
}

class CoverImageData {
  int? id;
  String? name;
  String? image;
  int? originalSize;
  int? thumbSize;
  int? selectedOrNot;
  String? resAccessType;


  CoverImageData({
    this.id,
    this.name,
    this.image,
    this.originalSize,
    this.thumbSize,
    this.selectedOrNot,
    this.resAccessType
  });

  factory CoverImageData.fromJson(Map<String, dynamic> json) => CoverImageData(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
    originalSize: json["original_size"] == null ? null : json["original_size"],
    thumbSize: json["thumb_size"] == null ? null : json["thumb_size"],
    selectedOrNot: json["selected_or_not"] == null ? null : json["selected_or_not"],
    resAccessType: json["access_type"] == null ? null : json["access_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "image": image == null ? null : image,
    "original_size": originalSize == null ? null : originalSize,
    "thumb_size": thumbSize == null ? null : thumbSize,
    "selected_or_not": selectedOrNot == null ? null : selectedOrNot,
    "access_type": resAccessType == null ? null : resAccessType,
  };
}
