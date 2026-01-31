// To parse this JSON data, do
//
//     final unAuthUserProfileStoreApiResponseModel = unAuthUserProfileStoreApiResponseModelFromJson(jsonString);

import 'dart:convert';

UnAuthUserProfileStoreApiResponseModel unAuthUserProfileStoreApiResponseModelFromJson(str) => UnAuthUserProfileStoreApiResponseModel.fromJson(json.decode(str));

String unAuthUserProfileStoreApiResponseModelToJson(UnAuthUserProfileStoreApiResponseModel data) => json.encode(data.toJson());

class UnAuthUserProfileStoreApiResponseModel {
  List<JvtFileConnector>? jvtFileConnectors;

  UnAuthUserProfileStoreApiResponseModel({
    this.jvtFileConnectors,
  });

  factory UnAuthUserProfileStoreApiResponseModel.fromJson(Map<String, dynamic> json) => UnAuthUserProfileStoreApiResponseModel(
    jvtFileConnectors: json["jvt_file_connectors"] == null ? [] : List<JvtFileConnector>.from(json["jvt_file_connectors"]!.map((x) => JvtFileConnector.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "jvt_file_connectors": jvtFileConnectors == null ? [] : List<dynamic>.from(jvtFileConnectors!.map((x) => x.toJson())),
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
