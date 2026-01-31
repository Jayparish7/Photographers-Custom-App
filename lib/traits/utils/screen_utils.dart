/* 0->default (music),
 1->tiny (thumb) ,
 2->small (mobile) ,
 3->medium (system) ,4->large (television) */
import 'package:flutter/material.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/preference/screen_util_preference_constant.dart';

int? studioMaxScreenSize;
int? currentDevice;
int? defaultDevice = 0;

class ScreenUtil {
  static int other = 0; // use this for mobile
  static int tiny = 1; // use this for mobile
  static int small = 2; // use this for bigger than mobile
  static int medium = 3; // use this for
  static int large = 4; // use this for
  setCurrentDevice(BuildContext context){
    double shortestSide = MediaQuery.of(context).size.shortestSide;
    if (shortestSide <= 600) {
      //
      showLog('the device is mobile // Tiny');
      currentDevice = small;
    } else if (shortestSide > 600 && shortestSide < 800) {
      showLog('the device is Tab // Small');
      currentDevice = small;
    } else if (shortestSide > 800 && shortestSide < 1024) {
      showLog('the device is Tv or desktop // Large');
      currentDevice = small;
    } else {
      currentDevice = small;
    }
    setCurrentDeviceAtPreference(currentDevice!);
  }

  setCurrentDeviceAtPreference(int value) async {
    await PreferenceHelper.setInt(StorageUtil.currentDeviceSizeKey, value);
  }

  getAndSetCurrentDevice() async {
    int value = await PreferenceHelper.getInt(StorageUtil.currentDeviceSizeKey);
    currentDevice = value;
  }

  setScreenSize() async {
    // get from preference and set it to top level
    studioMaxScreenSize =
        await PreferenceHelper.getInt(StorageUtil.studioMaxScreen);
  }

  setStudioScreenAtPreference(int value) async {
    await PreferenceHelper.setInt(StorageUtil.studioMaxScreen, value);
  }
}
