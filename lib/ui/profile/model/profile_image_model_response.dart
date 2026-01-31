// To parse this JSON data, do
//
//     final userProfileImage = userProfileImageFromJson(jsonString);

import 'dart:convert';

import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart';

UserProfileImage userProfileImageFromJson(str) =>
    UserProfileImage.fromJson(json.decode(str));

String userProfileImageToJson(UserProfileImage data) =>
    json.encode(data.toJson());

class UserProfileImage {
  UserProfileImage({
    this.jvtFileConnectors,
  });

  List<JvtFileConnectors>? jvtFileConnectors;

  factory UserProfileImage.fromJson(Map<String, dynamic> json) =>
      UserProfileImage(
        jvtFileConnectors: json["jvt_file_connectors"] == null
            ? null
            : List<JvtFileConnectors>.from(json["jvt_file_connectors"]
                .map((x) => JvtFileConnectors.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "jvt_file_connectors": jvtFileConnectors == null
            ? null
            : List<dynamic>.from(jvtFileConnectors!.map((x) => x.toJson())),
      };
}
