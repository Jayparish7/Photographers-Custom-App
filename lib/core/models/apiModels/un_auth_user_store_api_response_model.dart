// To parse this JSON data, do
//
//     final unAuthUserStoreApiResponseModel = unAuthUserStoreApiResponseModelFromJson(jsonString);

import 'dart:convert';

UnAuthUserStoreApiResponseModel unAuthUserStoreApiResponseModelFromJson(str) => UnAuthUserStoreApiResponseModel.fromJson(json.decode(str));

String unAuthUserStoreApiResponseModelToJson(UnAuthUserStoreApiResponseModel data) => json.encode(data.toJson());

class UnAuthUserStoreApiResponseModel {
  UnauthUser? unauthUser;

  UnAuthUserStoreApiResponseModel({
    this.unauthUser,
  });

  factory UnAuthUserStoreApiResponseModel.fromJson(Map<String, dynamic> json) => UnAuthUserStoreApiResponseModel(
    unauthUser: json["unauth_user"] == null ? null : UnauthUser.fromJson(json["unauth_user"]),
  );

  Map<String, dynamic> toJson() => {
    "unauth_user": unauthUser?.toJson(),
  };
}

class UnauthUser {
  String? code;
  List<UnauthUserPerson>? unauthUserPersons;

  UnauthUser({
    this.code,
    this.unauthUserPersons,
  });

  factory UnauthUser.fromJson(Map<String, dynamic> json) => UnauthUser(
    code: json["code"],
    unauthUserPersons: json["unauth_user_persons"] == null ? [] : List<UnauthUserPerson>.from(json["unauth_user_persons"]!.map((x) => UnauthUserPerson.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "unauth_user_persons": unauthUserPersons == null ? [] : List<dynamic>.from(unauthUserPersons!.map((x) => x.toJson())),
  };
}

class UnauthUserPerson {
  String? code;
  JvtFileConnector? jvtFileConnector;

  UnauthUserPerson({
    this.code,
    this.jvtFileConnector,
  });

  factory UnauthUserPerson.fromJson(Map<String, dynamic> json) => UnauthUserPerson(
    code: json["code"],
    jvtFileConnector: json["jvt_file_connector"] == null ? null : JvtFileConnector.fromJson(json["jvt_file_connector"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
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
