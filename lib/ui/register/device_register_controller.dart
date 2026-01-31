import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/core/Utils/device_util.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/Utils/snackbar_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/device_register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceRegisterController {
  var prefs;

  Future<bool> getDeviceRegistered(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();

    Map<String, dynamic>? map = await _getDeviceMap();
    if (map == null) {
      return false;
    }
    showLog('device register map: ${map.toString()}');

    try {
      // CALL DEVICE REGISTER API

      var response = await PhotomallApis(context).devRegApiCall(map);
      if (response != null) {
        await _devRegPref(response.data!);
        return true;
      } else {
        customSnackBar(
            context: context,
            title: 'Device Registration Failed',
            message:
                'Device registration failed. Try again later or contact admin');
        return false;
      }
    } catch (e) {
      showLog("Register failed ${e}");
      return false;
    }
  }

  initDevRedApiCall() async {}

  _devRegPref(RegData data) async {
    await PreferenceHelper.setBool('$isDeviceRegisteredPreferenceKey', true);
    await PreferenceHelper.setString(
        '$clientSecretPreferenceKey', data.clientSecret!);
  }

  Future<Map<String, dynamic>?> _getDeviceMap() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic>? deviceMap;
    String deviceId;
    try {
      if (DeviceUtil.isWeb) {
        WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
        showLog('kIsWeb true');
        deviceMap = {
          "app": {
            "device": {
              "name": webBrowserInfo.appName,
              "android_version": webBrowserInfo.appVersion,
              "device_manufacturer": webBrowserInfo.vendor
            }
          },
          "attributes": [
            {"type": "google_ad", "id": "asd"},
            {"type": "android_device", "id": "3"},
            {"type": "notification", "id": "sad"}
          ]
        };
      } else if (Platform.isAndroid) {
        //get android device info
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        await PreferenceHelper.setString(
            deviceIdPreferenceKey, androidInfo.id.toString());
        deviceId = androidInfo.id.toString();
        deviceMap = {
          "app": {
            "device": {
              "name": androidInfo.device.toString(),
              "android_version": androidInfo.version.sdkInt.toString(),
              "device_manufacturer": androidInfo.manufacturer.toString(),
              "android_device": deviceId,
              "fcm_notification_token":
                  await FirebaseMessaging.instance.getToken()
              //await FirebaseMessaging.instance.getToken(),
            }
          },
          "attributes": [
            {"type": "google_ad", "id": "asd"},
            {
              "type": "android_device",
              "id": deviceId,
            },
            //{"type": "notification", "id": "sad"},
            {
              "type": "fcm",
              //"id": await FirebaseMessaging.instance.getToken(),
              "id": "sddf"
            },
          ],
        };
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

        await PreferenceHelper.setString(
            deviceIdPreferenceKey, iosInfo.identifierForVendor.toString());
        deviceId = iosInfo.identifierForVendor.toString();
        deviceMap = {
          "app": {
            "device": {
              "name": iosInfo.name.toString(),
              "android_version": iosInfo.systemVersion.toString(),
              "device_manufacturer": "Apple",
              "android_device": deviceId,
              "fcm_notification_token":
                  await FirebaseMessaging.instance.getToken()
            }
          },
          "attributes": [
            {"type": "google_ad", "id": "asd"},
            {
              "type": "android_device",
              "id": iosInfo.identifierForVendor.toString()
            },
            {"type": "notification", "id": "sad"}
          ]
        };
      } else if (Platform.isLinux) {
        //need to change default to dynamic
        LinuxDeviceInfo linuxDeviceInfo = await deviceInfo.linuxInfo;
        deviceMap = {
          "app": {
            "device": {
              "name": linuxDeviceInfo.name,
              "android_version": linuxDeviceInfo.version,
              "device_manufacturer": "Linux"
            }
          },
          "attributes": [
            {"type": "google_ad", "id": "asd"},
            {"type": "android_device", "id": "2"},
            {"type": "notification", "id": "sad"}
          ]
        };
      } else if (Platform.isWindows) {
        //need to change default to dynamic
        WindowsDeviceInfo windowsDeviceInfo = await deviceInfo.windowsInfo;
        deviceMap = {
          "app": {
            "device": {
              "name": windowsDeviceInfo.computerName,
              "android_version": windowsDeviceInfo.numberOfCores,
              "device_manufacturer": "Windows"
            }
          },
          "attributes": [
            {"type": "google_ad", "id": "asd"},
            {"type": "android_device", "id": "2"},
            {"type": "notification", "id": "sad"}
          ]
        };
      } else if (Platform.isMacOS) {
        //need to change default to dynamic
        MacOsDeviceInfo macDeviceInfo = await deviceInfo.macOsInfo;
        deviceMap = {
          "app": {
            "device": {
              "name": macDeviceInfo.computerName,
              "android_version": macDeviceInfo.osRelease,
              "device_manufacturer": "Mac"
            }
          },
          "attributes": [
            {"type": "google_ad", "id": "asd"},
            {"type": "android_device", "id": "2"},
            {"type": "notification", "id": "sad"}
          ]
        };
      } else {}

      // //Device Register Api request
      // var apiHandler = Provider.of<ApiHelper>(context, listen: false);
      // var response = await apiHandler.apiJsonRequest(
      //     deviceRegisterUrl, deviceMap, context);
      // return compute(deviceRegisterModelFromJson, response);
    } catch (e, s) {
      showLog('exception on device register: $s');
    }
    return deviceMap;
  }
}
