// To parse this JSON data, do
//
//     final appDetailsModel = appDetailsModelFromJson(jsonString);

import 'dart:convert';

AppDetailsModel appDetailsModelFromJson(String str) =>
    AppDetailsModel.fromJson(json.decode(str));

String appDetailsModelToJson(AppDetailsModel data) =>
    json.encode(data.toJson());

class AppDetailsModel {
  AppDetailsModel({
    this.data,
  });

  Data? data;

  factory AppDetailsModel.fromJson(Map<String, dynamic> json) =>
      AppDetailsModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.applicationCode,
    this.appName,
    this.playStoreAppId,
    this.firebaseAppId,
    this.truecallerKey,
    this.keyAliasName,
    this.storePassword,
    this.keyPassword,
    this.releaseMode,
    this.appVersion,
    this.appVersionId,
    this.domain,
    this.randomUrl,
    this.firebaseProjectId,
    this.playConsoleApiCredential,
    this.appIconBackground,
    this.ownPlayStore,
  });

  String? applicationCode;
  String? appName;
  String? playStoreAppId;
  String? firebaseAppId;
  String? truecallerKey;
  String? keyAliasName;
  String? storePassword;
  String? keyPassword;
  int? releaseMode;
  String? appVersion;
  int? appVersionId;
  String? domain;
  String? randomUrl;
  String? firebaseProjectId;

  //PlayConsoleApiCredential playConsoleApiCredential;
  String? playConsoleApiCredential;
  String? appIconBackground;
  int? ownPlayStore;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      applicationCode:
          json["application_code"] == null ? null : json["application_code"],
      appName: json["app_name"] == null ? null : json["app_name"],
      // appName: json["app_name"],
      playStoreAppId:
          json["play_store_app_id"] == null ? null : json["play_store_app_id"],
      firebaseAppId:
          json["firebase_app_id"] == null ? null : json["firebase_app_id"],
      truecallerKey:
          json["truecaller_key"] == null ? null : json["truecaller_key"],
      keyAliasName:
          json["key_alias_name"] == null ? null : json["key_alias_name"],
      storePassword:
          json["store_password"] == null ? null : json["store_password"],
      keyPassword: json["key_password"] == null ? null : json["key_password"],
      releaseMode: json["release_mode"] == null ? null : json["release_mode"],
      appVersion: json["app_version"] == null ? null : json["app_version"],
      appVersionId:
          json["app_version_id"] == null ? null : json["app_version_id"],
      domain: json["domain"] == null ? null : json["domain"],
      randomUrl: json["random_url"] == null ? null : json["random_url"],
      firebaseProjectId: json["firebase_project_id"] == null
          ? null
          : json["firebase_project_id"],
      //playConsoleApiCredential: json["play_console_api_credential"] == null ? null : PlayConsoleApiCredential.fromJson(json["play_console_api_credential"]),
      playConsoleApiCredential: json["play_console_api_credential"] == null
          ? null
          : jsonEncode(json["play_console_api_credential"]),
      appIconBackground: json["app_icon_background"] == null
          ? null
          : json["app_icon_background"],
      ownPlayStore:
          json["own_play_store"] == null ? null : json["own_play_store"]);

  Map<String, dynamic> toJson() => {
        "application_code": applicationCode == null ? null : applicationCode,
        "app_name": appName,
        "play_store_app_id": playStoreAppId == null ? null : playStoreAppId,
        "firebase_app_id": firebaseAppId == null ? null : firebaseAppId,
        "truecaller_key": truecallerKey == null ? null : truecallerKey,
        "key_alias_name": keyAliasName == null ? null : keyAliasName,
        "store_password": storePassword == null ? null : storePassword,
        "key_password": keyPassword == null ? null : keyPassword,
        "release_mode": releaseMode == null ? null : releaseMode,
        "app_version": appVersion == null ? null : appVersion,
        "app_version_id": appVersionId == null ? null : appVersionId,
        "domain": domain,
        "random_url": randomUrl == null ? null : randomUrl,
        "app_icon_background":
            appIconBackground == null ? null : appIconBackground,
        "firebase_project_id": firebaseProjectId,
        //"play_console_api_credential": playConsoleApiCredential == null ? null : playConsoleApiCredential.toJson(),
        "play_console_api_credential": playConsoleApiCredential,
        "own_play_store": ownPlayStore,
      };
}

class PlayConsoleApiCredential {
  PlayConsoleApiCredential({
    this.type,
    this.authUri,
    this.clientId,
    this.tokenUri,
    this.projectId,
    this.privateKey,
    this.clientEmail,
    this.privateKeyId,
    this.clientX509CertUrl,
    this.authProviderX509CertUrl,
  });

  String? type;
  String? authUri;
  String? clientId;
  String? tokenUri;
  String? projectId;
  String? privateKey;
  String? clientEmail;
  String? privateKeyId;
  String? clientX509CertUrl;
  String? authProviderX509CertUrl;

  factory PlayConsoleApiCredential.fromJson(Map<String, dynamic> json) =>
      PlayConsoleApiCredential(
        type: json["type"] == null ? null : json["type"],
        authUri: json["auth_uri"] == null ? null : json["auth_uri"],
        clientId: json["client_id"] == null ? null : json["client_id"],
        tokenUri: json["token_uri"] == null ? null : json["token_uri"],
        projectId: json["project_id"] == null ? null : json["project_id"],
        privateKey: json["private_key"] == null ? null : json["private_key"],
        clientEmail: json["client_email"] == null ? null : json["client_email"],
        privateKeyId:
            json["private_key_id"] == null ? null : json["private_key_id"],
        clientX509CertUrl: json["client_x509_cert_url"] == null
            ? null
            : json["client_x509_cert_url"],
        authProviderX509CertUrl: json["auth_provider_x509_cert_url"] == null
            ? null
            : json["auth_provider_x509_cert_url"],
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "auth_uri": authUri == null ? null : authUri,
        "client_id": clientId == null ? null : clientId,
        "token_uri": tokenUri == null ? null : tokenUri,
        "project_id": projectId == null ? null : projectId,
        "private_key": privateKey == null ? null : privateKey,
        "client_email": clientEmail == null ? null : clientEmail,
        "private_key_id": privateKeyId == null ? null : privateKeyId,
        "client_x509_cert_url":
            clientX509CertUrl == null ? null : clientX509CertUrl,
        "auth_provider_x509_cert_url":
            authProviderX509CertUrl == null ? null : authProviderX509CertUrl,
      };
}
