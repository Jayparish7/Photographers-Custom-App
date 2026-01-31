// To parse this JSON data, do
//
//     final accountDeletionStoreResponseModel = accountDeletionStoreResponseModelFromJson(jsonString);

import 'dart:convert';

AccountDeletionStoreResponseModel accountDeletionStoreResponseModelFromJson(str) => AccountDeletionStoreResponseModel.fromJson(json.decode(str));

String accountDeletionStoreResponseModelToJson(AccountDeletionStoreResponseModel data) => json.encode(data.toJson());

class AccountDeletionStoreResponseModel {
  Data data;

  AccountDeletionStoreResponseModel({
    required this.data,
  });

  factory AccountDeletionStoreResponseModel.fromJson(Map<String, dynamic> json) => AccountDeletionStoreResponseModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  String code;
  int daysCount;
  int createdAt;

  Data({
    required this.code,
    required this.daysCount,
    required this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    code: json["code"],
    daysCount: json["days_count"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "days_count": daysCount,
    "created_at": createdAt,
  };
}
