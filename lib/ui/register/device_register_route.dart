import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:drift/drift.dart' as drift;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/image_server_controller.dart';
import 'package:photomall_flutter/core/Utils/device_util.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/Utils/snackbar_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/route_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/device_register_model.dart';
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';

import 'package:photomall_flutter/ui/shared/LanguageSelector.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';


///Widget have to be under Material app while new route been generated
class DeviceRegister extends StatefulWidget {
  @override
  _DeviceRegisterState createState() => _DeviceRegisterState();
}

class _DeviceRegisterState extends State<DeviceRegister> {
  @override
  Widget build(BuildContext context) {
    return DeviceRegisterImpl();
  }
}

///to use particular widget/route context it has to be outside of material app widget
class DeviceRegisterImpl extends StatefulWidget {
  @override
  _DeviceRegisterImplState createState() => _DeviceRegisterImplState();
}

//ApiHandler apiHandler;

class _DeviceRegisterImplState extends State<DeviceRegisterImpl> {
  var prefs;

  initDevRedApiCall() async {
    TransporterDao transporterDao = TransporterDao();
    prefs = await SharedPreferences.getInstance();

    ///after device register navigate back to home screen

    Map<String, dynamic> map = await _getDeviceMap();

    showLog('device register map: ${map.toString()}');



  //  try {
      // CALL DEVICE REGISTER API

    DeviceRegisterModel? response = await PhotomallApis(context).devRegApiCall(map);
      if (response != null) {

        _devRegPref(response.data!);

        /// get & set  server status
        ImageServer imageServer = ImageServer();
        bool status = await imageServer.getServerStatus();
        await imageServer.setServerStatus(status);

        /// set color in globals
        final initialInputData = [
          TransportDataCompanion(
              code: drift.Value(null),
              tag: drift.Value(
                TransportDataKeys.studioData,
              ),
              lastUpdatedAt: drift.Value(0),
              updateRequired: drift.Value(1)),
          TransportDataCompanion(
              code: drift.Value(null),
              tag: drift.Value(
                TransportDataKeys.designData,
              ),
              lastUpdatedAt: drift.Value(0),
              updateRequired: drift.Value(1)),
          //TransportDataCompanion(
           //   code: drift.Value(null),
             // tag: drift.Value(TransportDataKeys.deviceData),
             // lastUpdatedAt: drift.Value(0),
             // updateRequired: drift.Value(1)),

        ];
       showLog("initial value inserting ....");
        for (int i = 0; i < initialInputData.length; i++) {

          await transporterDao.insertOrUpdateTransporter(
              code: initialInputData[i].code.value,
              tag: initialInputData[i].tag.value
              //  initialInputData[i]
              );
        }
        AppColorData appColorData = AppColorData();

        await appColorData.getColor(context);


        Navigator.pop(context);
        Navigator.pushNamed(context, RoutePaths.Language,arguments: LanguageSelectorArguments(needToShowDoneButton: false));
        //Navigator.pop(context);
      } else {
        _onDeviceRegisterFailed();
      }
   // } catch (e) {
  //    showLog("Register failed ${e}");
  //    _onDeviceRegisterFailed();
   // }
  }

    _onDeviceRegisterFailed() {
      customSnackBar(
          context: context,
          title: 'Authentication',
          message: 'Authentication failed');
      Navigator.pop(context);
    }

  @override
  void initState() {
    super.initState();
    showLog('inside side drawer init state');
    //apiHandler = Provider.of<ApiHandler>(context, listen: false);
    //initDevRedApiCall(apiHandler, context);
    initDevRedApiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [CommonCircularProgress(), Text("Please wait")],
        ),
      ),
    );
  }

  ///set device related preference after successful device register api call
  _devRegPref(RegData data) async {
    prefs.setBool('$isDeviceRegisteredPreferenceKey', true);
    await   PreferenceHelper.setString(clientSecretPreferenceKey, data.clientSecret!);

  }

  Future<Map<String, dynamic>> _getDeviceMap() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic>? deviceMap;
    String deviceId;
    /*try {
      if (Platform.isAndroid) {
        //get android device info
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        prefs.setString('$deviceIdSharedPreferenceKey', androidInfo.androidId.toString());
        //convert details to a map
        deviceMap = {
          deviceIdKey: androidInfo.androidId.toString(),
          deviceManufacturerKey: androidInfo.manufacturer.toString(),
          deviceModelNameKey: androidInfo.model.toString(),
          deviceAndroidVersionKey: androidInfo.version.toString()
        };
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        prefs.setString('$deviceIdSharedPreferenceKey',iosInfo.identifierForVendor.toString());
        deviceMap = {
          deviceIdKey: iosInfo.identifierForVendor.toString(),
          deviceManufacturerKey: 'Apple',
          deviceModelNameKey: iosInfo.model.toString(),
          deviceAndroidVersionKey: iosInfo.systemVersion.toString()
        };
      }
    } catch (e) {
      showLog('exception on device register: $e');
    }*/
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
          /* "attributes": [
            {"type": "google_ad", "id": "asd"},
            {
              "type": "android_device",
              "id": deviceId,
            },
            //{"type": "notification", "id": "sad"},
            {
              "type": "fcm",
              //"id": await FirebaseMessaging.instance.getToken(),
              "id": ""
            },
          ],*/
          //"application_random": "",
        };
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

        await PreferenceHelper.setString(
            deviceIdPreferenceKey, iosInfo.identifierForVendor.toString());
        /*deviceIdPreferenceKey',
            iosInfo.identifierForVendor.toString());*/

        deviceMap = {
          "app": {
            "device": {
              "name": iosInfo.name.toString(),
              "android_version": iosInfo.systemVersion.toString(),
              "device_manufacturer": "Apple"
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
    } catch (e) {
      showLog('exception on device register: $e');

    }
    return deviceMap!;
  }
}
