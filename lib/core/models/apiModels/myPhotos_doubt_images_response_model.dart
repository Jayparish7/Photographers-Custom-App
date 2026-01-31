// To parse this JSON data, do
//
//     final myPhotosDoubtImages = myPhotosDoubtImagesFromJson(jsonString);

import 'dart:convert';

MyPhotosDoubtImages myPhotosDoubtImagesFromJson(str) =>
    MyPhotosDoubtImages.fromJson(json.decode(str));

String myPhotosDoubtImagesToJson(MyPhotosDoubtImages data) =>
    json.encode(data.toJson());

class MyPhotosDoubtImages {
  JvtFile? personJvtFile;
  List<int>? personBox;
  JvtFile? matchPersonJvtFile;
  List<int>? matchPersonBox;
  Person? person;
  Person? matchPerson;

  MyPhotosDoubtImages({
    this.personJvtFile,
    this.personBox,
    this.matchPersonJvtFile,
    this.matchPersonBox,
    this.person,
    this.matchPerson,
  });

  factory MyPhotosDoubtImages.fromJson(Map<String, dynamic> json) =>
      MyPhotosDoubtImages(
        personJvtFile: json["person_jvt_file"] == null
            ? null
            : JvtFile.fromJson(json["person_jvt_file"]),
        personBox: json["person_box"] == null
            ? []
            : List<int>.from(json["person_box"]!.map((x) => x)),
        matchPersonJvtFile: json["match_person_jvt_file"] == null
            ? null
            : JvtFile.fromJson(json["match_person_jvt_file"]),
        matchPersonBox: json["match_person_box"] == null
            ? []
            : List<int>.from(json["match_person_box"]!.map((x) => x)),
        person: json["person"] == null ? null : Person.fromJson(json["person"]),
        matchPerson: json["match_person"] == null
            ? null
            : Person.fromJson(json["match_person"]),
      );

  Map<String, dynamic> toJson() => {
        "person_jvt_file": personJvtFile?.toJson(),
        "person_box": personBox == null
            ? []
            : List<dynamic>.from(personBox!.map((x) => x)),
        "match_person_jvt_file": matchPersonJvtFile?.toJson(),
        "match_person_box": matchPersonBox == null
            ? []
            : List<dynamic>.from(matchPersonBox!.map((x) => x)),
        "person": person?.toJson(),
        "match_person": matchPerson?.toJson(),
      };
}

class Person {
  String? code;
  JvtFileConnectors? jvtFileConnectors;

  Person({
    this.code,
    this.jvtFileConnectors,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        code: json["code"],
        jvtFileConnectors: json["jvt_file_connectors"] == null
            ? null
            : JvtFileConnectors.fromJson(json["jvt_file_connectors"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "jvt_file_connectors": jvtFileConnectors?.toJson(),
      };
}

class JvtFileConnectors {
  String? code;
  String? name;
  int? screenDisplay;
  JvtFile? jvtFile;

  JvtFileConnectors({
    this.code,
    this.name,
    this.screenDisplay,
    this.jvtFile,
  });

  factory JvtFileConnectors.fromJson(Map<String, dynamic> json) =>
      JvtFileConnectors(
        code: json["code"],
        name: json["name"],
        screenDisplay: json["screen_display"],
        jvtFile: json["jvt_file"] == null
            ? null
            : JvtFile.fromJson(json["jvt_file"]),
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
