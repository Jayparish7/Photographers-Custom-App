// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

List<RemoteMessage> messageFromJson(str) => List<RemoteMessage>.from(
    json.decode(str).map((x) => RemoteMessage.fromMap(x)));

String messageToJson(List<RemoteMessage> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));
