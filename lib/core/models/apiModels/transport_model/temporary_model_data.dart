part of 'transport_model.dart';

class TemporaryUrl {
  TemporaryUrl({
    this.code,
    this.updateRequired,
    this.lastUpdatedAt,
    this.data,
  });

  String? code;
  int? updateRequired;
  int? lastUpdatedAt;
  List<TemporaryDatum>? data;

  factory TemporaryUrl.fromJson(Map<String, dynamic> json) => TemporaryUrl(
    code: json["code"] == null ? null : json["code"],
    updateRequired: json["update_required"] == null ? null : json["update_required"],
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],
    data: json["data"] == null ? null : List<TemporaryDatum>.from(json["data"].map((x) => TemporaryDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "update_required": updateRequired == null ? null : updateRequired,
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class TemporaryDatum {
  TemporaryDatum({
    this.code,
    this.value,
    this.expireAt,
    this.jvtFileCode,
    this.lastUpdatedAt,
  });

  String ?code;
  String? value;
  int? expireAt;
  String? jvtFileCode;
  int? lastUpdatedAt;

  factory TemporaryDatum.fromJson(Map<String, dynamic> json) => TemporaryDatum(
    code: json["code"] == null ? null : json["code"],
    value: json["value"] == null ? null : json["value"],
    expireAt: json["expire_at"] == null ? null : json["expire_at"],
    jvtFileCode: json["jvt_file_code"] == null ? null : json["jvt_file_code"],
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "value": value == null ? null : value,
    "expire_at": expireAt == null ? null : expireAt,
    "jvt_file_code": jvtFileCode == null ? null : jvtFileCode,
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
  };
}
