import 'dart:convert';

TemporaryUrl temporaryUrlFromJson(str) => TemporaryUrl.fromJson(json.decode(str));

String temporaryUrlToJson(TemporaryUrl data) => json.encode(data.toJson());

class TemporaryUrl {
  TemporaryUrl({
    this.temporaryUrls,
  });

  List<TemporaryUrlElement>? temporaryUrls;

  factory TemporaryUrl.fromJson(Map<String, dynamic> json) => TemporaryUrl(

    temporaryUrls: json["temporary_urls"] == null ? null : List<TemporaryUrlElement>.from(json["temporary_urls"].map((x) => List<TemporaryUrlElement>.from(x.map((x) => TemporaryUrlElement.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "temporary_urls": temporaryUrls == null ? null : List<dynamic>.from(temporaryUrls!.map((x) => x.toJson())),
  };
}

class TemporaryUrlElement {
  TemporaryUrlElement({
    this.code,
    this.value,
    this.expireAt,
    this.jvtFileCode,
  });

  String? code;
  String? value;
  String ?expireAt;
  String ?jvtFileCode;

  factory TemporaryUrlElement.fromJson(Map<String, dynamic> json) => TemporaryUrlElement(
    code: json["code"] == null ? null : json["code"],
    value: json["value"] == null ? null : json["value"],
    expireAt: json["expire_at"] == null ? null : json["expire_at"],
    jvtFileCode: json["jvt_file_code"] == null ? null : json["jvt_file_code"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "value": value == null ? null : value,
    "expire_at": value == null ? null : expireAt,

    "jvt_file_code": jvtFileCode == null ? null : jvtFileCode,
  };
}
