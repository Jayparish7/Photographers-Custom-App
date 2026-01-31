import 'dart:convert';

EventIdInfo eventIdFromJson(str) => EventIdInfo.fromJson(json.decode(str));

String eventIdToJson(EventIdInfo data) => json.encode(data.toJson());

class EventIdInfo {
  List<EventId>? eventIds;

  EventIdInfo({
    this.eventIds,
  });

  factory EventIdInfo.fromJson(Map<String, dynamic> json) => EventIdInfo(
    eventIds: List<EventId>.from(json["event_ids"].map((x) => EventId.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "event_ids": List<dynamic>.from(eventIds!.map((x) => x.toJson())),
  };
}

class EventId {
  String? code;
  int? lastUpdatedAt;

  EventId({
    this.code,
    this.lastUpdatedAt
  });

  factory EventId.fromJson(Map<String, dynamic> json) => EventId(
    code: json["id"],
    lastUpdatedAt: json["last_updated_at"]
  );

  Map<String, dynamic> toJson() => {
    "id": code,
    "last_updated_at" : lastUpdatedAt
  };
}
