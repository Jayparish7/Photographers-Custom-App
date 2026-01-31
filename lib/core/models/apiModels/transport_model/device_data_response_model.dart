part of 'transport_model.dart';
class DeviceAppData {
  DeviceAppData({
    this.updateRequired,
    this.lastUpdatedAt,
    this.data,
  });

  int?  updateRequired;
  int?  lastUpdatedAt;
  DeviceApp? data;


  factory DeviceAppData.fromJson(Map<String, dynamic> json) => DeviceAppData(
    updateRequired: json["update_required"] == null ? null : json["update_required"],
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],
    data: json["data"] == null ? null : DeviceApp.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "update_required": updateRequired == null ? null : updateRequired,
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
    "data": data == null ? null : data!.toJson(),
  };
}

class DeviceApp {
  DeviceApp({
    this.events,
    this.code,
    this.language,
  });

  List<String>? events;
  String? code;
  Language? language;

  factory DeviceApp.fromJson(Map<String, dynamic> json) => DeviceApp(
    events: json["events"] == null ? null : List<String>.from(json["events"].map((x) => x)),
    code: json["code"] == null ? null : json["code"],
    language: json["language"] == null ? null : Language.fromJson(json["language"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "events": events == null ? null : List<dynamic>.from(events!.map((x) => x)),
    "language": language == null ? null : language!.toJson(),
  };
}



class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
