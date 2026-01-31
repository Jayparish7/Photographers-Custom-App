// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.status,
    this.ableType,
    this.token,
    this.errorMessage,
  });

  int? status;
  String? ableType;
  String? token;
  String? errorMessage;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    status: json["status"] == null ? null : json["status"],
    ableType: json["able_type"] == null ? null : json["able_type"],
    token: json["token"] == null ? null : json["token"],
    errorMessage: json["error_message"] == null ? null : json["error_message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "able_type": ableType == null ? null : ableType,
    "token": token == null ? null : token,
    "error_message": errorMessage == null ? null : errorMessage,
  };
}
