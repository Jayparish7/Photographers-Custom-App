import 'dart:convert';
class UpdateModel{
  UpdateModel({
    this.code,
    this.status,
    this.comment,
    this.importanceLevel,
});
  String? code;
  int? status;
  dynamic comment;
  dynamic importanceLevel;
}
// request model below
// To parse this JSON data, do
//
//     final photoSelectionImagesStatusRequest = photoSelectionImagesStatusRequestFromJson(jsonString);



PhotoSelectionImagesStatusRequest photoSelectionImagesStatusRequestFromJson(str) => PhotoSelectionImagesStatusRequest.fromJson(json.decode(str));

String photoSelectionImagesStatusRequestToJson(PhotoSelectionImagesStatusRequest data) => json.encode(data.toJson());

class PhotoSelectionImagesStatusRequest {
  PhotoSelectionImagesStatusRequest({
    this.photoSelectionImageStatuses,
    this.lastUpdatedAt,
  });

  List<PhotoSelectionImageStatus> ?photoSelectionImageStatuses;
  String? lastUpdatedAt;
  factory PhotoSelectionImagesStatusRequest.fromJson(Map<String, dynamic> json) => PhotoSelectionImagesStatusRequest(

    photoSelectionImageStatuses: json["photo_selection_image_statuses"] == null ? null : List<PhotoSelectionImageStatus>.from(json["photo_selection_image_statuses"].map((x) => PhotoSelectionImageStatus.fromJson(x))),
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "photo_selection_image_statuses": photoSelectionImageStatuses == null ? null : List<dynamic>.from(photoSelectionImageStatuses!.map((x) => x.toJson())),
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
  };
}

class PhotoSelectionImageStatus {
  PhotoSelectionImageStatus({
    this.code,
    this.status,
    this.comment,
    this.rating,
    this.eventCode,
  });

  String ?code;
  String ?status;
  String ?comment;
  String? rating;
  String? eventCode;

  factory PhotoSelectionImageStatus.fromJson(Map<String, dynamic> json) => PhotoSelectionImageStatus(
    code: json["code"] == null ? null : json["code"],
    status: json["status"] == null ? null : json["status"],
    comment: json["comment"] == null ? null : json["comment"],
    rating: json["rating"] == null ? null : json["rating"],
    eventCode: json["event_code"] == null ? null : json["event_code"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "status": status == null ? null : status,
    "comment": comment == null ? null : comment,
    "rating": rating == null ? null : rating,
    "event_code": eventCode == null ? null : eventCode,
  };
}
