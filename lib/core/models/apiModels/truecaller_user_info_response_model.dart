// To parse this JSON data, do
//
//     final tcSdkUserInfoResponseModel = tcSdkUserInfoResponseModelFromJson(jsonString);

import 'dart:convert';

TcSdkUserInfoResponseModel tcSdkUserInfoResponseModelFromJson( str) => TcSdkUserInfoResponseModel.fromJson(json.decode(str));

String tcSdkUserInfoResponseModelToJson(TcSdkUserInfoResponseModel data) => json.encode(data.toJson());

class TcSdkUserInfoResponseModel {
  String? sub;
  String? givenName;
  String? familyName;
  String? phoneNumber;
  bool? phoneNumberVerified;
  String? phoneNumberCountryCode;

  TcSdkUserInfoResponseModel({
    this.sub,
    this.givenName,
    this.familyName,
    this.phoneNumber,
    this.phoneNumberVerified,
    this.phoneNumberCountryCode,
  });

  factory TcSdkUserInfoResponseModel.fromJson(Map<String, dynamic> json) => TcSdkUserInfoResponseModel(
    sub: json["sub"],
    givenName: json["given_name"],
    familyName: json["family_name"],
    phoneNumber: json["phone_number"],
    phoneNumberVerified: json["phone_number_verified"],
    phoneNumberCountryCode: json["phone_number_country_code"],
  );

  Map<String, dynamic> toJson() => {
    "sub": sub,
    "given_name": givenName,
    "family_name": familyName,
    "phone_number": phoneNumber,
    "phone_number_verified": phoneNumberVerified,
    "phone_number_country_code": phoneNumberCountryCode,
  };
}
