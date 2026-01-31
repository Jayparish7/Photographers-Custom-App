// To parse this JSON data, do
//
//     final bookMeEventTypesModel = bookMeEventTypesModelFromJson(jsonString);

import 'dart:convert';

BookMeEventTypesModel bookMeEventTypesModelFromJson(str) => BookMeEventTypesModel.fromJson(json.decode(str));

String bookMeEventTypesModelToJson(BookMeEventTypesModel data) => json.encode(data.toJson());

class BookMeEventTypesModel {
  Data? data;
  int? lastUpdatedAt;
  String? successMessage;

  BookMeEventTypesModel({
    this.data,
    this.lastUpdatedAt,
    this.successMessage,
  });

  factory BookMeEventTypesModel.fromJson(Map<String, dynamic> json) => BookMeEventTypesModel(
    data: Data.fromJson(json["data"]),
    lastUpdatedAt: json["last_updated_at"],
    successMessage: json["success_message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
    "last_updated_at": lastUpdatedAt,
    "success_message": successMessage,
  };
}

class Data {
  List<EventType>? eventTypes;

  Data({
    this.eventTypes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    eventTypes: List<EventType>.from(json["event_types"].map((x) => EventType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "event_types": List<dynamic>.from(eventTypes!.map((x) => x.toJson())),
  };
}

class EventType {
  String? code;
  String? name;
  List<SubCategory>? subCategory;

  EventType({
    this.code,
    this.name,
    this.subCategory,
  });

  factory EventType.fromJson(Map<String, dynamic> json) => EventType(
    code: json["id"],
    name: json["name"],
    subCategory: List<SubCategory>.from(json["sub_category"].map((x) => SubCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": code,
    "name": name,
    "sub_category": List<dynamic>.from(subCategory!.map((x) => x.toJson())),
  };
}

class SubCategory {
  int? id;
  String? name;

  SubCategory({
    this.id,
    this.name,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
