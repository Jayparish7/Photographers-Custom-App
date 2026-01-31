// To parse this JSON data, do
//
//     final tcSdkAccessTokenResponseModel = tcSdkAccessTokenResponseModelFromJson(jsonString);

import 'dart:convert';

TcSdkAccessTokenResponseModel tcSdkAccessTokenResponseModelFromJson( str) => TcSdkAccessTokenResponseModel.fromJson(json.decode(str));

String tcSdkAccessTokenResponseModelToJson(TcSdkAccessTokenResponseModel data) => json.encode(data.toJson());

class TcSdkAccessTokenResponseModel {
  String? accessToken;
  int? expiresIn;
  String? tokenType;

  TcSdkAccessTokenResponseModel({
    this.accessToken,
    this.expiresIn,
    this.tokenType,
  });

  factory TcSdkAccessTokenResponseModel.fromJson(Map<String, dynamic> json) => TcSdkAccessTokenResponseModel(
    accessToken: json["access_token"],
    expiresIn: json["expires_in"],
    tokenType: json["token_type"],
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "expires_in": expiresIn,
    "token_type": tokenType,
  };
}
