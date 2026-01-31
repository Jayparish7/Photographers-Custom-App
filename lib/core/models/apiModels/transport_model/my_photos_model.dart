// To parse this JSON data, do
//
//     final myPhotos = myPhotosFromJson(jsonString);

import 'dart:convert';

MyPhotos myPhotosFromJson(str) => MyPhotos.fromJson(json.decode(str));

String myPhotosToJson(MyPhotos data) => json.encode(data.toJson());

class MyPhotos {
  String? realPerson;
  String? personCode;

  MyPhotos({
    this.realPerson,
    this.personCode,
  });

  factory MyPhotos.fromJson(Map<String, dynamic> json) => MyPhotos(
        realPerson: json["real_person"],
        personCode: json["person_code"],
      );

  Map<String, dynamic> toJson() => {
        "real_person": realPerson,
        "person_code": personCode,
      };
}
// To parse this JSON data, do
//
//     final userPersonsPhotos = userPersonsPhotosFromJson(jsonString);

UserPersonsPhotos userPersonsPhotosFromJson(str) =>
    UserPersonsPhotos.fromJson(json.decode(str));

String userPersonsPhotosToJson(UserPersonsPhotos data) =>
    json.encode(data.toJson());

class UserPersonsPhotos {
  List<UserPerson>? userPersons;

  UserPersonsPhotos({
    this.userPersons,
  });

  factory UserPersonsPhotos.fromJson(Map<String, dynamic> json) =>
      UserPersonsPhotos(
        userPersons: json["user_persons"] == null
            ? []
            : List<UserPerson>.from(
                json["user_persons"]!.map((x) => UserPerson.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_persons": userPersons == null
            ? []
            : List<dynamic>.from(userPersons!.map((x) => x.toJson())),
      };
}

class UserPerson {
  String? code;
  List<String>? realPersons;

  UserPerson({
    this.code,
    this.realPersons,
  });

  factory UserPerson.fromJson(Map<String, dynamic> json) => UserPerson(
        code: json["code"],
        realPersons: json["real_persons"] == null
            ? []
            : List<String>.from(json["real_persons"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "real_persons": realPersons == null
            ? []
            : List<dynamic>.from(realPersons!.map((x) => x)),
      };
}
