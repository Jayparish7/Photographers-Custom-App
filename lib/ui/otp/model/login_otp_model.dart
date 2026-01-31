import 'dart:convert';

LoginOtpModel loginOtpModelFromJson(str) => LoginOtpModel.fromJson(json.decode(str));

String loginOtpModelToJson(LoginOtpModel data) => json.encode(data.toJson());

class LoginOtpModel {
  LoginOtpModel({
    this.tokenType,
    this.expiresIn,
    this.accessToken,
    this.refreshToken,
    //this.user,
    //this.company,
  });

  String? tokenType;
  int? expiresIn;
  String? accessToken;
  String? refreshToken;
  //UserData user;
  //Company company;

  factory LoginOtpModel.fromJson(Map<String, dynamic> json) => LoginOtpModel(
    tokenType: json["token_type"] == null ? null : json["token_type"],
    expiresIn: json["expires_in"] == null ? null : json["expires_in"],
    accessToken: json["access_token"] == null ? null : json["access_token"],
    refreshToken: json["refresh_token"] == null ? null : json["refresh_token"],
    //user: json["user"] == null ? null : UserData.fromJson(json["user"]),
    //company: json["company"] == null ? null : Company.fromJson(json["company"]),

  );

  Map<String, dynamic> toJson() => {
    "token_type": tokenType == null ? null : tokenType,
    "expires_in": expiresIn == null ? null : expiresIn,
    "access_token": accessToken == null ? null : accessToken,
    "refresh_token": refreshToken == null ? null : refreshToken,
    //"user": user == null ? null : user!.toJson(),
    //"company": company == null ? null : company!.toJson(),

  };
}