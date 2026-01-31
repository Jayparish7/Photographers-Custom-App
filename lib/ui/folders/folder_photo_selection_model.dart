// To parse this JSON data, do
//
//     final photoSelectionImages = photoSelectionImagesFromJson(jsonString);

import 'dart:convert';

EventImageStatusModel photoSelectionImagesFromJson(str) =>
    EventImageStatusModel.fromJson(json.decode(str));

String photoSelectionImagesToJson(EventImageStatusModel data) =>
    json.encode(data.toJson());

class EventImageStatusModel {
  EventImageStatusModel({
    this.eventCode,
    this.confirmedStatus,
    this.photoSelectionImages,
    this.lastUpdatedAt,
  });

  String? eventCode;
  int? confirmedStatus;
  List<PhotoSelectionImage>? photoSelectionImages;
  int? lastUpdatedAt;

  factory EventImageStatusModel.fromJson(Map<String, dynamic> json) =>
      EventImageStatusModel(
        eventCode: json["event_code"] == null ? null : json["event_code"],
        confirmedStatus:
            json["confirmed_status"] == null ? null : json["confirmed_status"],
        photoSelectionImages: json["photo_selection_images"] == null
            ? null
            : List<PhotoSelectionImage>.from(json["photo_selection_images"]
                .map((x) => PhotoSelectionImage.fromJson(x))),
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "event_code": eventCode == null ? null : eventCode,
        "confirmed_status": confirmedStatus == null ? null : confirmedStatus,
        "photo_selection_images": photoSelectionImages == null
            ? null
            : List<dynamic>.from(photoSelectionImages!.map((x) => x.toJson())),
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
      };
}

class PhotoSelectionImage {
  PhotoSelectionImage({
    this.code,
    this.status,
    this.comment,
    this.rating,
    this.lastUpdatedAt,
  });

  String? code;
  int? status;
  dynamic comment;
  int? rating;
  int? lastUpdatedAt;

  factory PhotoSelectionImage.fromJson(Map<String, dynamic> json) =>
      PhotoSelectionImage(
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        comment: json["comment"],
        rating: json["rating"] == null ? null : json["rating"],
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "comment": comment,
        "rating": rating == null ? null : rating,
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
      };
}
