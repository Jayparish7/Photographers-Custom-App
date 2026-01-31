// To parse this JSON data, do
//
//     final myPhotosImages = myPhotosImagesFromJson(jsonString);

import 'dart:convert';

MyPhotosImages myPhotosImagesFromJson(str) =>
    MyPhotosImages.fromJson(json.decode(str));

String myPhotosImagesToJson(MyPhotosImages data) => json.encode(data.toJson());

class MyPhotosImages {
  List<Person>? realPersons;
  List<Person>? persons;
  List<UnauthUserPerson>? unauthUserPersons;

  int? lastUpdatedAt;

  MyPhotosImages({
    this.realPersons,
    this.persons,
    this.unauthUserPersons,
    this.lastUpdatedAt,
  });

  factory MyPhotosImages.fromJson(Map<String, dynamic> json) => MyPhotosImages(
        realPersons: json["real_persons"] == null
            ? []
            : List<Person>.from(
                json["real_persons"]!.map((x) => Person.fromJson(x))),
        persons: json["persons"] == null
            ? []
            : List<Person>.from(
                json["persons"]!.map((x) => Person.fromJson(x))),
        lastUpdatedAt: json["last_updated_at"],
    unauthUserPersons: json["unauth_user_persons"] == null ? [] : List<UnauthUserPerson>.from(json["unauth_user_persons"]!.map((x) => UnauthUserPerson.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
        "real_persons": realPersons == null
            ? []
            : List<dynamic>.from(realPersons!.map((x) => x.toJson())),
        "persons": persons == null
            ? []
            : List<dynamic>.from(persons!.map((x) => x.toJson())),
        "last_updated_at": lastUpdatedAt,
    "unauth_user_persons": unauthUserPersons == null ? [] : List<dynamic>.from(unauthUserPersons!.map((x) => x.toJson())),

  };
}

class Person {
  String? code;
  String? imageName;
  int? score;
  List<String>? images;
  List<String>? persons;

  Person({
    this.code,
    this.imageName,
    this.score,
    this.images,
    this.persons,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        code: json["code"],
        imageName: json["image_name"],
        score: json["score"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        persons: json["persons"] == null
            ? []
            : List<String>.from(json["persons"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "image_name": imageName,
        "score": score,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "persons":
            persons == null ? [] : List<dynamic>.from(persons!.map((x) => x)),
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