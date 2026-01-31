import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/app_update_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUpdateStatus {
  BuildContext? context;
  PhotomallApis? apiRepo;

  AppUpdateStatus(this.context) {
    if (context == null) {
      showLog("AppUpdateStatus constrctor STEP 1");
    } else {
      showLog("AppUpdateStatus constrctor STEP 2");
    }
    this.apiRepo = PhotomallApis(this.context);
  }

  checkAppUpdate(
      {required Function onUpdate,
      required Function onForceUpdate,
      required Function onAppExpired,
      BuildContext? context}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var prefs = await SharedPreferences.getInstance();
    String _versionCode = packageInfo.buildNumber; //App version code
    try {
      AppUpdateStatusModel response =
          await apiRepo!.appUpdateStatusApiCall(_versionCode);
      showLog("response :: Context $context");
      if (response.appUpdateStatus != null) {
        // set app update status in preference
        await prefs.setInt(appUpdateStatusKey, response.appUpdateStatus!);
        switch (response.appUpdateStatus) {
          case 1:
            {
              await prefs.setBool(appUpdateOrNotPreferenceKey, true);
              //update available
              await onUpdate();
            }
            break;
          case 2:
            {
              await prefs.setBool(appUpdateOrNotPreferenceKey, true);

              await onForceUpdate();
            }
            break;
          case 3:
            {
              await prefs.setBool(appUpdateOrNotPreferenceKey, true);

              await onAppExpired();
            }
            break;
          default:
            {
              await prefs.setBool(appUpdateOrNotPreferenceKey, false);

              //update not required
              return;
            }
        }
      }
    } catch (e) {
      showLog('The Update error is $e');
    }
  }
}
