import 'dart:convert';

AppUpdateStatusModel appUpdateStatusModelFromJson(str) => AppUpdateStatusModel.fromJson(json.decode(str));

String appUpdateStatusModelToJson(AppUpdateStatusModel data) => json.encode(data.toJson());

class AppUpdateStatusModel {
  int? appUpdateStatus;

  AppUpdateStatusModel({
    this.appUpdateStatus,
  });

  factory AppUpdateStatusModel.fromJson(Map<String, dynamic> json) => new AppUpdateStatusModel(
    appUpdateStatus: json["app_update_status"] == null ? null : json["app_update_status"],
  );

  Map<String, dynamic> toJson() => {
    "app_update_status": appUpdateStatus == null ? null : appUpdateStatus,
  };
}
