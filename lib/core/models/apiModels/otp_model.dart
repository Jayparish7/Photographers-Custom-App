// To parse this JSON data, do
//
//     final otpModel = otpModelFromJson(jsonString);

import 'dart:convert';

OtpModel otpModelFromJson(str) => OtpModel.fromJson(json.decode(str));

String otpModelToJson(OtpModel data) => json.encode(data.toJson());

class OtpModel {
  String? tokenType;
  int? expiresIn;
  String? accessToken;
  String? refreshToken;
  String? userName;
  int? preDesignedAlbums;
  int? completedAlbums;
  String? userRandomId;
  bool? screenShot;

  OtpModel({
    this.screenShot,
    this.tokenType,
    this.expiresIn,
    this.accessToken,
    this.refreshToken,
    this.userName,
    this.preDesignedAlbums,
    this.completedAlbums,
    this.userRandomId,
  });

  factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        userName: json["user_name"],
        preDesignedAlbums: json["pre_designed_albums"],
        completedAlbums: json["completed_albums"],
        userRandomId:
            json["user_random_id"] == null ? null : json["user_random_id"],

        screenShot: json["screen_shot"],
      );

  Map<String, dynamic> toJson() => {
        "token_type": tokenType,
        "expires_in": expiresIn,
        "access_token": accessToken,
        "refresh_token": refreshToken,
        "user_name": userName,
        "pre_designed_albums": preDesignedAlbums,
        "completed_albums": completedAlbums,
        "user_random_id": userRandomId == null ? null : userRandomId,
        "screen_shot": screenShot,
      };
}
