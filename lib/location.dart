// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

LocationModel locationModelFromJson(String str) => LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  LocationModel({
    this.status,
    this.country,
    this.countryCode,
    this.region,
    this.regionName,
    this.city,
    this.zip,
    this.lat,
    this.lon,
    this.timezone,
    this.isp,
    this.org,
    this.locationModelAs,
    this.query,
  });

  String? status;
  String? country;
  String? countryCode;
  String? region;
  String? regionName;
  String? city;
  String? zip;
  double? lat;
  double? lon;
  String? timezone;
  String? isp;
  String? org;
  String? locationModelAs;
  String? query;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    status: json["status"] == null ? null : json["status"],
    country: json["country"] == null ? null : json["country"],
    countryCode: json["countryCode"] == null ? null : json["countryCode"],
    region: json["region"] == null ? null : json["region"],
    regionName: json["regionName"] == null ? null : json["regionName"],
    city: json["city"] == null ? null : json["city"],
    zip: json["zip"] == null ? null : json["zip"],
    lat: json["lat"] == null ? null : json["lat"].toDouble(),
    lon: json["lon"] == null ? null : json["lon"].toDouble(),
    timezone: json["timezone"] == null ? null : json["timezone"],
    isp: json["isp"] == null ? null : json["isp"],
    org: json["org"] == null ? null : json["org"],
    locationModelAs: json["as"] == null ? null : json["as"],
    query: json["query"] == null ? null : json["query"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "country": country == null ? null : country,
    "countryCode": countryCode == null ? null : countryCode,
    "region": region == null ? null : region,
    "regionName": regionName == null ? null : regionName,
    "city": city == null ? null : city,
    "zip": zip == null ? null : zip,
    "lat": lat == null ? null : lat,
    "lon": lon == null ? null : lon,
    "timezone": timezone == null ? null : timezone,
    "isp": isp == null ? null : isp,
    "org": org == null ? null : org,
    "as": locationModelAs == null ? null : locationModelAs,
    "query": query == null ? null : query,
  };
}
