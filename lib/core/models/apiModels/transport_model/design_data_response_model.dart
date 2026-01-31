part of 'transport_model.dart';
class DesignData {
  DesignData({
    this.updateRequired,
    this.lastUpdatedAt,
    this.data,
  });

  int? updateRequired;
  int? lastUpdatedAt;
  DesignDataData? data;

  factory DesignData.fromJson(Map<String, dynamic> json) => DesignData(
    updateRequired: json["update_required"] == null ? null : json["update_required"],
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],
    data: json["data"] == null ? null : DesignDataData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "update_required": updateRequired == null ? null : updateRequired,
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
    "data": data == null ? null : data!.toJson(),
  };
}

class DesignDataData {
  DesignDataData({
  //  this.appColors,
  //  this.designProperties,
    this.countries,
    this.appDesignKeys,
    this.studioLanguages,
  });

 // List<AppColor> appColors;
 // List<DesignProperty> designProperties;
  List<dynamic>? countries;
  Map<String, dynamic>? appDesignKeys;
  List<dynamic>? studioLanguages;

  factory DesignDataData.fromJson(Map<String, dynamic> json) => DesignDataData(
    countries: json["countries"] == null ? null : json["countries"],
  //  appColors: json["app_colors"] == null ? null : List<AppColor>.from(json["app_colors"].map((x) => AppColor.fromJson(x))),
  //  designProperties: json["design_properties"] == null ? null : List<DesignProperty>.from(json["design_properties"].map((x) => DesignProperty.fromJson(x))),
    appDesignKeys: json["app_design_keys"] == null ? null : json["app_design_keys"],
    studioLanguages: json["studio_languages"] == null ? null : json["studio_languages"],
  );
//x
  Map<String, dynamic> toJson() => {
   "countries": countries,
  //  "app_colors": appColors == null ? null : List<dynamic>.from(appColors.map((x) => x.toJson())),
  //  "design_properties": designProperties == null ? null : List<dynamic>.from(designProperties.map((x) => x.toJson())),
    "app_design_keys": appDesignKeys == null ? null : appDesignKeys,
    "studio_languages": studioLanguages == null ? null : studioLanguages,
  };
}


class Country {
  Country({
    this.id,
    this.code,
    this.name,
    this.shortCode,
  });

  int ?id;
  String? code;
  String? name;
  String? shortCode;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"] == null ? null : json["id"],
    code: json["code"] == null ? null : json["code"],
    name: json["name"] == null ? null : json["name"],
    shortCode: json["short_code"] == null ? null : json["short_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "code": code == null ? null : code,
    "name": name == null ? null : name,
    "short_code": shortCode == null ? null : shortCode,
  };
}
