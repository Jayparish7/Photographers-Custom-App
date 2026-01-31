// To parse this JSON data, do
//
//     final aiDataResponseModel = aiDataResponseModelFromJson(jsonString);

import 'dart:convert';

AiDataResponseModel aiDataResponseModelFromJson(str) => AiDataResponseModel.fromJson(json.decode(str));

String aiDataResponseModelToJson(AiDataResponseModel data) => json.encode(data.toJson());

class AiDataResponseModel {
  List<EventAiDatum>? eventAiData;

  AiDataResponseModel({
    this.eventAiData,
  });

  factory AiDataResponseModel.fromJson(Map<String, dynamic> json) => AiDataResponseModel(
    eventAiData: json["event_ai_data"] == null ? [] : List<EventAiDatum>.from(json["event_ai_data"]!.map((x) => EventAiDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "event_ai_data": eventAiData == null ? [] : List<dynamic>.from(eventAiData!.map((x) => x.toJson())),
  };
}

class EventAiDatum {
  String? code;
  int? updateRequired;
  int? lastUpdatedAt;
  EventAiDatumData? data;

  EventAiDatum({
    this.code,
    this.updateRequired,
    this.lastUpdatedAt,
    this.data,
  });

  factory EventAiDatum.fromJson(Map<String, dynamic> json) => EventAiDatum(
    code: json["code"],
    updateRequired: json["update_required"],
    lastUpdatedAt: json["last_updated_at"],
    data: json["data"] == null ? null : EventAiDatumData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "update_required": updateRequired,
    "last_updated_at": lastUpdatedAt,
    "data": data?.toJson(),
  };
}

class EventAiDatumData {
  String? code;
  int? type;
  int? lastUpdatedAt;
  DataData? data;

  EventAiDatumData({
    this.code,
    this.type,
    this.lastUpdatedAt,
    this.data,
  });

  factory EventAiDatumData.fromJson(Map<String, dynamic> json) => EventAiDatumData(
    code: json["code"],
    type: json["type"],
    lastUpdatedAt: json["last_updated_at"],
    data: json["data"] == null ? null : DataData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "type": type,
    "last_updated_at": lastUpdatedAt,
    "data": data?.toJson(),
  };
}

class DataData {
  List<Person>? persons;
  List<Person>? realPersons;
  List<String>? imageWithoutPerson;

  DataData({
    this.persons,
    this.realPersons,
    this.imageWithoutPerson,
  });

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
    persons: json["persons"] == null ? [] : List<Person>.from(json["persons"]!.map((x) => Person.fromJson(x))),
    realPersons: json["real_persons"] == null ? [] : List<Person>.from(json["real_persons"]!.map((x) => Person.fromJson(x))),
    imageWithoutPerson: json["image_without_person"] == null ? [] : List<String>.from(json["image_without_person"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "persons": persons == null ? [] : List<dynamic>.from(persons!.map((x) => x.toJson())),
    "real_persons": realPersons == null ? [] : List<dynamic>.from(realPersons!.map((x) => x.toJson())),
    "image_without_person": imageWithoutPerson == null ? [] : List<dynamic>.from(imageWithoutPerson!.map((x) => x)),
  };
}

class Person {
  String? code;
  String? imageName;
  int? score;
  List<String>? images;
  List<String>? persons;

  Person({
    this.code,
    this.imageName,
    this.score,
    this.images,
    this.persons,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    code: json["code"],
    imageName: json["image_name"],
    score: json["score"],
    images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    persons: json["persons"] == null ? [] : List<String>.from(json["persons"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "image_name": imageName,
    "score": score,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "persons": persons == null ? [] : List<dynamic>.from(persons!.map((x) => x)),
  };
}
