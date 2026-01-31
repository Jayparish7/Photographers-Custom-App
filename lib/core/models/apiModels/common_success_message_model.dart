import 'dart:convert';

  CommonSuccessMessageModel commonSuccessMessageModelFromJson(str) => CommonSuccessMessageModel.fromJson(json.decode(str));

String commonSuccessMessageModelToJson(CommonSuccessMessageModel data) => json.encode(data.toJson());

class CommonSuccessMessageModel {
  String? successMessage;

  CommonSuccessMessageModel({
    this.successMessage,
  });

  factory CommonSuccessMessageModel.fromJson(Map<String, dynamic> json) => new CommonSuccessMessageModel(
    successMessage: json["success_message"] == null ? null : json["success_message"],
  );

  Map<String, dynamic> toJson() => {
    "success_message": successMessage == null ? null : successMessage,
  };
}
