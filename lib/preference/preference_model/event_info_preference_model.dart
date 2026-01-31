import 'dart:convert';

import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;

EventInfoPreference eventInfoPreferenceFromJson(str) =>
    EventInfoPreference.fromJson(json.decode(str));

String eventInfoPreferenceToJson(EventInfoPreference data) =>
    json.encode(data.toJson());

class EventInfoPreference {
  EventInfoPreference({
    this.eventInfo,
  });

  EventInfo? eventInfo;

  factory EventInfoPreference.fromJson(Map<String, dynamic> json) =>
      EventInfoPreference(
        eventInfo: json["event_info"] == null
            ? null
            : EventInfo.fromJson(json["event_info"]),
      );

  Map<String, dynamic> toJson() => {
        "event_info": eventInfo == null ? null : eventInfo!.toJson(),
      };
}

class EventInfo {
  EventInfo({
    this.data,
  });

  Data? data;

  factory EventInfo.fromJson(Map<String, dynamic> json) => EventInfo(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.code,
    this.name,
    this.type,
    this.address,
    this.duration,
    this.subevents,
  });

  String? code;
  String? name;
  int? type;
  transporter.Address? address;
  transporter.EventDuration? duration;
  List<transporter.Subevent>? subevents;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : json["type"],
        address: json["address"] == null
            ? null
            : transporter.Address.fromJson(json["address"]),
        duration: json["duration"] == null
            ? null
            : transporter.EventDuration.fromJson(json["duration"]),
        subevents: json["subevents"] == null
            ? null
            : List<transporter.Subevent>.from(
                json["subevents"].map((x) => transporter.Subevent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "type": type == null ? null : type,
        "address": address == null ? null : address!.toJson(),
        "duration": duration == null ? null : duration!.toJson(),
        "subevents": subevents == null
            ? null
            : List<dynamic>.from(subevents!.map((x) => x.toJson())),
      };
}
