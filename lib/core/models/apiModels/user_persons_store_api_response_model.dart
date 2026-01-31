// To parse this JSON data, do
//
//     final userPersonsResponse = userPersonsResponseFromJson(jsonString);

import 'dart:convert';

UserPersonsResponse userPersonsResponseFromJson(str) =>
    UserPersonsResponse.fromJson(json.decode(str));

String userPersonsResponseToJson(UserPersonsResponse data) =>
    json.encode(data.toJson());

class UserPersonsResponse {
  int? status;
  UserPerson? userPerson;

  UserPersonsResponse({
    this.status,
    this.userPerson,
  });

  factory UserPersonsResponse.fromJson(Map<String, dynamic> json) =>
      UserPersonsResponse(
        status: json["status"],
        userPerson: json["user_person"] == null
            ? null
            : UserPerson.fromJson(json["user_person"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "user_person": userPerson?.toJson(),
      };
}

class UserPerson {
  String? code;
  String? name;
  int? userOwnImage;
  String? relationship;
  List<dynamic>? images;

  UserPerson({
    this.code,
    this.name,
    this.userOwnImage,
    this.relationship,
    this.images,
  });

  factory UserPerson.fromJson(Map<String, dynamic> json) => UserPerson(
        code: json["code"],
        name: json["name"],
        userOwnImage: json["user_own_image"],
        relationship: json["relationship"],
        images: json["images"] == null
            ? []
            : List<dynamic>.from(json["images"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "user_own_image": userOwnImage,
        "relationship": relationship,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
      };
}
