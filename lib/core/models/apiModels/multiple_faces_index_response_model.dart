/*
// To parse this JSON data, do
//
//     final multipleFacesResponseModel = multipleFacesResponseModelFromJson(jsonString);

import 'dart:convert';

MultipleFacesResponseModel multipleFacesResponseModelFromJson(str) => MultipleFacesResponseModel.fromJson(json.decode(str));

String multipleFacesResponseModelToJson(MultipleFacesResponseModel data) => json.encode(data.toJson());

class MultipleFacesResponseModel {
  List<Datum>? data;
  int? lastUpdatedAt;

  MultipleFacesResponseModel({
    this.data,
    this.lastUpdatedAt,
  });

  factory MultipleFacesResponseModel.fromJson(Map<String, dynamic> json) => MultipleFacesResponseModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    lastUpdatedAt: json["last_updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "last_updated_at": lastUpdatedAt,
  };
}

class Datum {
  String? code;
  String? name;
  int? userOwnImage;
  String? relationship;
  List<Image>? images;

  Datum({
    this.code,
    this.name,
    this.userOwnImage,
    this.relationship,
    this.images,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    code: json["code"],
    name: json["name"],
    userOwnImage: json["user_own_image"],
    relationship: json["relationship"],
    images: json["images"] == null ? [] : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "user_own_image": userOwnImage,
    "relationship": relationship,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
  };
}

class Image {
  String? code;
  String? name;
  int? screenDisplay;
  JvtFile? jvtFile;

  Image({
    this.code,
    this.name,
    this.screenDisplay,
    this.jvtFile,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    code: json["code"],
    name: json["name"],
    screenDisplay: json["screen_display"],
    jvtFile: json["jvt_file"] == null ? null : JvtFile.fromJson(json["jvt_file"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "screen_display": screenDisplay,
    "jvt_file": jvtFile?.toJson(),
  };
}

class JvtFile {
  String? code;
  String? name;
  int? mode;
  int? size;
  String? extension;

  JvtFile({
    this.code,
    this.name,
    this.mode,
    this.size,
    this.extension,
  });

  factory JvtFile.fromJson(Map<String, dynamic> json) => JvtFile(
    code: json["code"],
    name: json["name"],
    mode: json["mode"],
    size: json["size"],
    extension: json["extension"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "mode": mode,
    "size": size,
    "extension": extension,
  };
}
*/

// To parse this JSON data, do
//
//     final multipleFacesResponseModel = multipleFacesResponseModelFromJson(jsonString);

import 'dart:convert';

MultipleFacesResponseModel multipleFacesResponseModelFromJson(str) => MultipleFacesResponseModel.fromJson(json.decode(str));

String multipleFacesResponseModelToJson(MultipleFacesResponseModel data) => json.encode(data.toJson());

class MultipleFacesResponseModel {
  List<Datum>? data;
  int? lastUpdatedAt;

  MultipleFacesResponseModel({
    this.data,
    this.lastUpdatedAt,
  });

  factory MultipleFacesResponseModel.fromJson(Map<String, dynamic> json) => MultipleFacesResponseModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    lastUpdatedAt: json["last_updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "last_updated_at": lastUpdatedAt,
  };
}

class Datum {
  String? code;
  String? name;
  int? userOwnImage;
  String? relationship;
  JvtFileConnector? jvtFileConnector;

  Datum({
    this.code,
    this.name,
    this.userOwnImage,
    this.relationship,
    this.jvtFileConnector,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    code: json["code"],
    name: json["name"],
    userOwnImage: json["user_own_image"],
    relationship: json["relationship"],
    jvtFileConnector: json["jvt_file_connector"] == null ? null : JvtFileConnector.fromJson(json["jvt_file_connector"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "user_own_image": userOwnImage,
    "relationship": relationship,
    "jvt_file_connector": jvtFileConnector?.toJson(),
  };
}

class JvtFileConnector {
  String? code;
  String? name;
  int? screenDisplay;
  JvtFile? jvtFile;

  JvtFileConnector({
    this.code,
    this.name,
    this.screenDisplay,
    this.jvtFile,
  });

  factory JvtFileConnector.fromJson(Map<String, dynamic> json) => JvtFileConnector(
    code: json["code"],
    name: json["name"],
    screenDisplay: json["screen_display"],
    jvtFile: json["jvt_file"] == null ? null : JvtFile.fromJson(json["jvt_file"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "screen_display": screenDisplay,
    "jvt_file": jvtFile?.toJson(),
  };
}

class JvtFile {
  String? code;
  String? name;
  int? mode;
  int? size;
  String? extension;

  JvtFile({
    this.code,
    this.name,
    this.mode,
    this.size,
    this.extension,
  });

  factory JvtFile.fromJson(Map<String, dynamic> json) => JvtFile(
    code: json["code"],
    name: json["name"],
    mode: json["mode"],
    size: json["size"],
    extension: json["extension"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "mode": mode,
    "size": size,
    "extension": extension,
  };
}
