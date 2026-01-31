import 'dart:convert';

/// Model class for device register api

DeviceRegisterModel deviceRegisterModelFromJson(str) =>
    DeviceRegisterModel.fromJson(json.decode(str));

String deviceRegisterModelToJson(DeviceRegisterModel data) =>
    json.encode(data.toJson());

class DeviceRegisterModel {
  RegData? data;

  DeviceRegisterModel({
    this.data,
  });

  factory DeviceRegisterModel.fromJson(Map<String, dynamic> json) =>
      new DeviceRegisterModel(
        data: RegData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
      };
}

class RegData {
  int? clientId;
  String? clientSecret;
  String? encryptionKey;

  RegData({
    this.clientId,
    this.clientSecret,
    this.encryptionKey,
  });

  factory RegData.fromJson(Map<String, dynamic> json) => new RegData(
        clientId: json["client_id"],
        clientSecret: json["client_secret"],
    encryptionKey: json["en_key"],
      );

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "client_secret": clientSecret,
    "en_key": encryptionKey
      };
}
