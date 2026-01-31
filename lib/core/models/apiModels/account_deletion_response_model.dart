// To parse this JSON data, do
//
//     final accountDeletionResponseModel = accountDeletionResponseModelFromJson(jsonString);

import 'dart:convert';

AccountDeletionResponseModel accountDeletionResponseModelFromJson( str) => AccountDeletionResponseModel.fromJson(json.decode(str));

String accountDeletionResponseModelToJson(AccountDeletionResponseModel data) => json.encode(data.toJson());

class AccountDeletionResponseModel {
  String status;

  AccountDeletionResponseModel({
    required this.status,
  });

  factory AccountDeletionResponseModel.fromJson(Map<String, dynamic> json) => AccountDeletionResponseModel(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
