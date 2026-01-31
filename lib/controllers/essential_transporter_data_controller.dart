import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/design_data_controller.dart';
import 'package:photomall_flutter/controllers/device_data_controller.dart';
import 'package:photomall_flutter/controllers/studio_data_controller.dart';
import 'package:photomall_flutter/controllers/user_data_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/ui/app_config_request_model.dart'
as transporterInputModel;
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
as transporterModel;

import '../driftdb/dao/event_dao.dart';

/// designData, studioData, userData, deviceData

class EssentialTransporterDataController {
  /*Future<transporterModel.TransportModel?> userDataApiCall() async {
    PhotomallApis data = await PhotomallApis(null);
    transporterModel.TransportModel response = await data.userDataApi();
    showLog('userDataApiCall  EssentialTransporterDataController${response.userData}');
    return response;
  }*/
  Future<void> essentialTransporterDataApiCall(
      {bool? isFromSplashScreen}) async {
    TransporterDao transporterDao = TransporterDao();
    PhotomallApis apiCall = PhotomallApis(null);
    List<transporterInputModel.InputData> inputData = [];


    if (isFromSplashScreen != false) {
      UserDataController userDataController = UserDataController();
      showLog('getUserData isFromSplashScreen');
      await userDataController.getUserData();
    }

    // Toggle all data to update required one
    if (isFromSplashScreen == true) {
      await essentialTransporterDataToggle();
    }else{

    }

    List<appDb.TransportDataData> transporters =
    await transporterDao.getEssentialTransporterDataFromTransporter();

    transporters.forEach((transporter) {
      if (transporter.tag != 'user_data') {
        inputData.add(transporterInputModel.InputData(
            key: transporter.tag!, lastUpdatedAt: transporter.lastUpdatedAt));
      }
    });

    if (inputData.isNotEmpty) {
      transporterModel.TransportModel? transporterResponse =
      await apiCall.callAppConfiguration(null, inputData: inputData);
      if (transporterResponse != null) {
        /// Update Design Data
        if (transporterResponse.designData != null &&
            transporterResponse.designData!.data != null &&
            transporterResponse.designData!.updateRequired == 1) {
          DesignDataController designDataController = DesignDataController();
          await designDataController
              .fillDesignDataResources(transporterResponse);
        } else {
          // insert last up date as same in local so only  toggle update not required
          await transporterDao.updateRequiredToggleByTag(
              0, TransportDataKeys.designData);
        }

        /// UPDATE STUDIO DATA
        if (transporterResponse.studioData != null &&
            transporterResponse.studioData!.updateRequired == 1 &&
            transporterResponse.studioData!.data != null) {
          StudioDataController studioDataController = StudioDataController();
          await studioDataController.fillStudioResources(transporterResponse);
        } else {
          // insert last up date as same in local so only  toggle update not required
          await transporterDao.updateRequiredToggleByTag(
              0, TransportDataKeys.studioData);
        }
        /*transporterModel.TransportModel?
        userDataResponse =  await userDataApiCall();
        showLog('userDataResponse $userDataResponse');
        /// Update User Data
        if (userDataResponse?.userData != null &&
            userDataResponse?.userData!.userDataData != null &&
            userDataResponse?.userData!.updateRequired == 1) {
          UserDataController userDataController = UserDataController();
          await userDataController.fillUserdataResources(userDataResponse!);
        } else {
          // insert last up date as same in local so only  toggle update not required
          await transporterDao.updateRequiredToggleByTag(
              0, TransportDataKeys.userData);
        }
*/
        if (transporterResponse.studioUserData != null &&
            transporterResponse.studioUserData!.updateRequired == 1) {
          UserDataController userDataController = UserDataController();
          await userDataController.fillStudioUserData(transporterResponse);
        } else {
          // insert last up date as same in local so only  toggle update not required
          await transporterDao.updateRequiredToggleByTag(
              0, TransportDataKeys.studioUserData);
        }
        if (transporterResponse.userEventData != null &&
            transporterResponse.userEventData!.updateRequired == 1) {
          UserDataController userDataController = UserDataController();
          await userDataController.fillUserEventData(transporterResponse);
        } else {
          // insert last up date as same in local so only  toggle update not required
          await transporterDao.updateRequiredToggleByTag(
              0, TransportDataKeys.studioUserData);
        }

        /// Update deviceApp Data
        /*  if (transporterResponse.deviceAppData != null &&
            transporterResponse.deviceAppData!.updateRequired == 1 &&
            transporterResponse.deviceAppData!.data != null) {
          DeviceDataController deviceDataController = DeviceDataController();
          await deviceDataController
              .fillDeviceAppDataResources(transporterResponse);
        } else {
          // insert last up date as same in local so only  toggle update not required
          await transporterDao.updateRequiredToggleByTag(
              0, TransportDataKeys.deviceData);
        }*/
      }
    }
  }

  Future<void> essentialTransporterDataToggle() async {
    TransporterDao transporterDao = TransporterDao();
    List<String> tags;
    var pref = await SharedPreferences.getInstance();
    bool loggedIn = pref.getBool('$isUserLoggedInPreferenceKey') ?? false;
    if (loggedIn) {
      if (isPhotomallApp) {
        tags = [
          TransportDataKeys.designData,
          TransportDataKeys.studioData,
          TransportDataKeys.userEventData,
          // TransportDataKeys.studioUserData
        ];
      } else {
        tags = [
          TransportDataKeys.designData,
          TransportDataKeys.studioData,
          TransportDataKeys.userData,
          TransportDataKeys.studioUserData
        ];
      }
    } else {
      tags = [
        TransportDataKeys.designData,
        TransportDataKeys.studioData,
        //TransportDataKeys.deviceData
      ];
    }
    // toggle update required one
    for (String tag in tags) {
      int data = await transporterDao.insertOrUpdateEssentialData(tag);
      showLog("the return data where ${data}");
    }
  }
}
