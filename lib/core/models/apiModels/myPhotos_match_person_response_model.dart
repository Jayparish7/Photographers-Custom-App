// To parse this JSON data, do
//
//     final myPhotosMatchPerson = myPhotosMatchPersonFromJson(jsonString);

import 'dart:convert';

MyPhotosMatchPerson myPhotosMatchPersonFromJson(str) =>
    MyPhotosMatchPerson.fromJson(json.decode(str));

String myPhotosMatchPersonToJson(MyPhotosMatchPerson data) =>
    json.encode(data.toJson());

class MyPhotosMatchPerson {
  int? status;

  MyPhotosMatchPerson({
    this.status,
  });

  factory MyPhotosMatchPerson.fromJson(Map<String, dynamic> json) =>
      MyPhotosMatchPerson(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
