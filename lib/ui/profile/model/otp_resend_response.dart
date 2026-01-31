/*

import 'dart:convert';

OtpResendResponse otpResendResponseFromJson(str) => OtpResendResponse.fromJson(json.decode(str));

String otpResendResponseToJson(OtpResendResponse data) => json.encode(data.toJson());

class OtpResendResponse {
  OtpResendResponse({
    this.message,
  });

  String message;

  factory OtpResendResponse.fromJson(Map<String, dynamic> json) => OtpResendResponse(
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
  };
}
*/

// To parse this JSON data, do
//
//     final otpResendResponse = otpResendResponseFromJson(jsonString);

import 'dart:convert';

OtpResendResponse otpResendResponseFromJson(str) =>
    OtpResendResponse.fromJson(json.decode(str));

String otpResendResponseToJson(OtpResendResponse data) =>
    json.encode(data.toJson());

class OtpResendResponse {
  OtpResendResponse({this.status, this.message, this.token});

  bool? status;
  String? message;
  String? token;

  factory OtpResendResponse.fromJson(Map<String, dynamic> json) =>
      OtpResendResponse(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        token: json["token"] == null ? null : json["token"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "token": token == null ? null : token,
      };
}
