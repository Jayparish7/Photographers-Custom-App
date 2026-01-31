import 'dart:convert';

CommonErrorMessageModel commonErrorMessageFromJson(str) => CommonErrorMessageModel.fromJson(json.decode(str));

String commonErrorMessageToJson(CommonErrorMessageModel data) => json.encode(data.toJson());

class CommonErrorMessageModel {
  String? errorMessage;

  CommonErrorMessageModel({
    this.errorMessage,
  });

  factory CommonErrorMessageModel.fromJson(Map<String, dynamic> json) => new CommonErrorMessageModel(
    errorMessage: json["error_message"] == null ? null : json["error_message"],
  );

  Map<String, dynamic> toJson() => {
    "error_message": errorMessage == null ? null : errorMessage,
  };
}