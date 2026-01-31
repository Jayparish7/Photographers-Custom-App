// To parse this JSON data, do
//
//     final multipleFacesDeleteResponseModel = multipleFacesDeleteResponseModelFromJson(jsonString);

import 'dart:convert';

MultipleFacesDeleteResponseModel multipleFacesDeleteResponseModelFromJson(str) => MultipleFacesDeleteResponseModel.fromJson(json.decode(str));

String multipleFacesDeleteResponseModelToJson(MultipleFacesDeleteResponseModel data) => json.encode(data.toJson());

class MultipleFacesDeleteResponseModel {
  int? status;
  String? message;

  MultipleFacesDeleteResponseModel({
    this.status,
    this.message,
  });

  factory MultipleFacesDeleteResponseModel.fromJson(Map<String, dynamic> json) => MultipleFacesDeleteResponseModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
