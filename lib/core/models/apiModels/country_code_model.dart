// To parse this JSON data, do
//
//     final countryCodeModel = countryCodeModelFromJson(jsonString);

import 'dart:convert';

CountryCodeModel countryCodeModelFromJson(str) => CountryCodeModel.fromJson(json.decode(str));

String countryCodeModelToJson(CountryCodeModel data) => json.encode(data.toJson());

class CountryCodeModel {
  Data? data;

  CountryCodeModel({
    this.data,
  });

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) => CountryCodeModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class Data {
  List<Country>? countries;

  Data({
    this.countries,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    countries: List<Country>.from(json["countries"].map((x) => Country.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "countries": List<dynamic>.from(countries!.map((x) => x.toJson())),
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
    id: json["id"],
    country: json["country"],
    countryCode: json["country_code"],
    countryShortCode: json["country_short_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country": country,
    "country_code": countryCode,
    "country_short_code": countryShortCode,
  };
}
