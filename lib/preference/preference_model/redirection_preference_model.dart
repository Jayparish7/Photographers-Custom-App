// To parse this JSON data, do
//
//     final redirectionModel = redirectionModelFromJson(jsonString);

import 'dart:convert';

RedirectionModel redirectionModelFromJson(String str) =>
    RedirectionModel.fromJson(json.decode(str));

String redirectionModelToJson(RedirectionModel data) =>
    json.encode(data.toJson());

class RedirectionModel {
  RedirectionModel({
    this.redirection,
  });

  Redirection? redirection;

  factory RedirectionModel.fromJson(Map<String, dynamic> json) =>
      RedirectionModel(
        redirection: json["redirection"] == null
            ? null
            : Redirection.fromJson(json["redirection"]),
      );

  Map<String, dynamic> toJson() => {
        "redirection": redirection == null ? null : redirection!.toJson(),
      };
}

class Redirection {
  Redirection({
    this.route,
    this.arguments,
  });

  String? route;
  List<String>? arguments;

  factory Redirection.fromJson(Map<String, dynamic> json) => Redirection(
        route: json["route"] == null ? null : json["route"],
        arguments: json["arguments"] == null
            ? null
            : List<String>.from(json["arguments"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "route": route == null ? null : route,
        "arguments": arguments == null
            ? null
            : List<dynamic>.from(arguments!.map((x) => x)),
      };
}
