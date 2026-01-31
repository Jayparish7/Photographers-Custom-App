// To parse this JSON data, do
//
//     final appConfigurationModel = appConfigurationModelFromJson(jsonString);

import 'dart:convert';

part 'design_data_response_model.dart';
part 'device_data_response_model.dart';

part 'event_data.dart';
part 'photo_selection_model.dart';
part 'studio_data_model.dart';
part 'temporary_model_data.dart';
part 'user_data_model.dart';

TransportModel transportModelFromJson(str) =>
    TransportModel.fromJson(json.decode(str));

String transportModelToJson(TransportModel data) => json.encode(data.toJson());

class TransportModel {
  TransportModel({
    this.deviceAppData,
    this.designData,
    this.studioData,
    this.studiosData,
    this.studioUserData,
    this.userData,
    this.userEventData,
    this.eventData,
    this.photoSelectionData,
    this.temporaryUrls,
    //this.albums,
    //this.folders
  });
  DeviceAppData? deviceAppData;
  DesignData? designData;
  //Map<String, dynamic> designData;
  StudioData? studioData;
  StudioUserData? studioUserData;
  UserData? userData;
  StudioUserData? userEventData;
  List<PhotoSelectionModel>? photoSelectionData;
  List<EventData>? eventData;
  List<StudioData>? studiosData;
  List<TemporaryUrl>? temporaryUrls;

  factory TransportModel.fromJson(Map<String, dynamic> json) => TransportModel(
        deviceAppData: json["device_app_data"] == null
            ? null
            : DeviceAppData.fromJson(json["device_app_data"]),
        studioUserData: json["studio_user_data"] == null
            ? null
            : StudioUserData.fromJson(json["studio_user_data"]),
        designData: json["design_data"] == null
            ? null
            : DesignData.fromJson(json["design_data"]),
        // eventData: json["event_data"] == null ? null : json["event_data"],
        temporaryUrls: json["temporary_urls"] == null
            ? null
            : List<TemporaryUrl>.from(
                json["temporary_urls"].map((x) => TemporaryUrl.fromJson(x))),
        studioData: json["studio_data"] == null
            ? null
            : StudioData.fromJson(json["studio_data"]),
        userData: json["user_data"] == null
            ? null
            : UserData.fromJson(json["user_data"]),
        userEventData: json["user_event_data"] == null
            ? null
            : StudioUserData.fromJson(json["user_event_data"]),
        photoSelectionData: json["photo_selection_data"] == null
            ? null
            : List<PhotoSelectionModel>.from(json["photo_selection_data"]
                .map((x) => PhotoSelectionModel.fromJson(x))),
        eventData: json["event_data"] == null
            ? null
            : List<EventData>.from(
                json["event_data"].map((x) => EventData.fromJson(x))),

        studiosData: json["studios_data"] == null
            ? null
            : List<StudioData>.from(
                json["studios_data"].map((x) => StudioData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "device_app_data":
            deviceAppData == null ? null : deviceAppData!.toJson(),
        "studio_user_data":
            studioUserData == null ? null : studioUserData!.toJson(),
        "design_data": designData == null ? null : designData!.toJson(),
        "temporary_urls": temporaryUrls == null
            ? null
            : List<dynamic>.from(temporaryUrls!.map((x) => x.toJson())),
        "event_data": eventData == null
            ? null
            : List<dynamic>.from(eventData!.map((x) => x.toJson())),

        "studios_data": studiosData == null
            ? null
            : List<dynamic>.from(studiosData!.map((x) => x.toJson())),
        "studio_data": studioData == null ? null : studioData!.toJson(),
        "user_data": userData == null ? null : userData!.toJson(),
        "user_event_data":
            userEventData == null ? null : userEventData!.toJson(),
        "photo_selection_data": photoSelectionData == null
            ? null
            : List<dynamic>.from(photoSelectionData!.map((x) => x.toJson())),
      };
}

class ImageData {
  ImageData({
    this.id,
    this.downloadStatus,
    this.mode,
    this.name,
    this.size,
  });

  int? id;
  int? downloadStatus;
  String? mode;
  String? name;
  int? size;

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
        id: json["id"] == null ? null : json["id"],
        downloadStatus:
            json["downloadStatus"] == null ? null : json["downloadStatus"],
        mode: json["mode"] == null ? null : json["mode"],
        name: json["name"] == null ? null : json["name"],
        size: json["size"] == null ? null : json["size"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "downloadStatus": downloadStatus == null ? null : downloadStatus,
        "mode": mode == null ? null : mode,
        "name": name == null ? null : name,
        "size": size == null ? null : size,
      };
}
