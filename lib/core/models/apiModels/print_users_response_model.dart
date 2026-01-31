// To parse this JSON data, do
//
//     final printUsers = printUsersFromJson(jsonString);

import 'dart:convert';

PrintUsers printUsersFromJson(str) => PrintUsers.fromJson(json.decode(str));

String printUsersToJson(PrintUsers data) => json.encode(data.toJson());

class PrintUsers {
  List<Datum>? data;

  PrintUsers({
    this.data,
  });

  factory PrintUsers.fromJson(Map<String, dynamic> json) => PrintUsers(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? code;
  String? ableType;
  String? ableCode;
  int? status;

  Datum({
    this.code,
    this.ableType,
    this.ableCode,
    this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        code: json["code"],
        ableType: json["able_type"],
        ableCode: json["able_code"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "able_type": ableType,
        "able_code": ableCode,
        "status": status,
      };
}
