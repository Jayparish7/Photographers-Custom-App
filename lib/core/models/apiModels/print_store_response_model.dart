// To parse this JSON data, do
//
//     final printStore = printStoreFromJson(jsonString);

import 'dart:convert';

PrintStore printStoreFromJson(str) => PrintStore.fromJson(json.decode(str));

String printStoreToJson(PrintStore data) => json.encode(data.toJson());

class PrintStore {
  bool? status;
  String? message;

  PrintStore({
    this.status,
    this.message,
  });

  factory PrintStore.fromJson(Map<String, dynamic> json) => PrintStore(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
