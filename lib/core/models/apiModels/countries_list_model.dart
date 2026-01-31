// To parse this JSON data, do
//
//     final countriesListModel = countriesListModelFromJson(jsonString);

import 'dart:convert';

CountriesListModel countriesListModelFromJson(str) => CountriesListModel.fromJson(json.decode(str));

String countriesListModelToJson(CountriesListModel data) => json.encode(data.toJson());

class CountriesListModel {
  Data? data;

  CountriesListModel({
    this.data,
  });

  factory CountriesListModel.fromJson(Map<String, dynamic> json) => CountriesListModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data!.toJson(),
  };
}

class Data {
  List<Country>? countries;

  Data({
    this.countries,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    countries: json["countries"] == null ? null : List<Country>.from(json["countries"].map((x) => Country.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "countries": countries == null ? null : List<dynamic>.from(countries!.map((x) => x.toJson())),
  };
}

class Country {
  int? id;
  String? country;
  String? countryCode;
  String? countryShortCode;

  Country({
    this.id,
    this.country,
    this.countryCode,
    this.countryShortCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"] == null ? null : json["id"],
    country: json["country"] == null ? null : json["country"],
    countryCode: json["country_code"] == null ? null : json["country_code"],
    countryShortCode: json["country_short_code"] == null ? null : json["country_short_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "country": country == null ? null : country,
    "country_code": countryCode == null ? null : countryCode,
    "country_short_code": countryShortCode == null ? null : countryShortCode,
  };
}
