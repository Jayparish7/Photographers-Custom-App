// To parse this JSON data, do
//
//     final screenShot = screenShotFromJson(jsonString);

import 'dart:convert';

ScreenShot screenShotFromJson(str) => ScreenShot.fromJson(json.decode(str));

String screenShotToJson(ScreenShot data) => json.encode(data.toJson());

class ScreenShot {
  Data? data;

  ScreenShot({
    this.data,
  });

  factory ScreenShot.fromJson(Map<String, dynamic> json) => ScreenShot(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class Data {
  String? code;
  int? otp;

  Data({
    this.code,
    this.otp,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    code: json["code"],
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "otp": otp,
  };
}
