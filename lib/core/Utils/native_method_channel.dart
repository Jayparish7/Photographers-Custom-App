import 'package:flutter/services.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/studio_config_constants.dart';
import 'package:photomall_flutter/traits/utils/screen_utils.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';

import '../constants/shared_preference_constants.dart';

class NativeMethodChannel {
  static const platform = const MethodChannel('photomallNative');

  Future showAlbum(String albumCode) async {
    bool enableScreenShot= await PreferenceHelper.getBool(enableScreenShotKey);
    try {
      String publicPath;
      if (studioPublicPath == null) {
        EssentialUtils essentialUtils = EssentialUtils();
        await essentialUtils.loadAppEssentialData();
        publicPath = studioPublicPath!;
      } else {
        publicPath = studioPublicPath!;
      }
      Map<String, dynamic> map =
        {
          'albumCode': '$albumCode',

          'studioId': studioIdConfig,
          'public_path': publicPath,
          'screen_display': currentDevice,
          'album_view_background_color': AppColorData.backgroundColorsKotlin,

          'icon_color': AppColorData.sideDrawerBackgroundColorKotlin,

          'icon_background_color':
              AppColorData.sideDrawerUnselectedTextColorKotlin,

          'studio_logo_background_color':
              AppColorData.sideDrawerBackgroundColorKotlin,
          'progress_bar_color': '000000'
        };
 showLog("the map object passed$enableScreenShot \n $map");
      await platform.invokeMethod('showCurlAlbum', {
        'albumCode': '$albumCode',
        // 'key': await EncryptAndDecryptFiles.key,
        'studioId': studioIdConfig,
        'public_path': publicPath,
        'screen_display': currentDevice,
        'album_view_background_color': AppColorData.backgroundColorsKotlin,
        // ['123','123']
        'icon_color': AppColorData.sideDrawerBackgroundColorKotlin,
        // "123"
        'icon_background_color':
            AppColorData.sideDrawerUnselectedTextColorKotlin,
        // "123"
        'studio_logo_background_color':
            AppColorData.sideDrawerBackgroundColorKotlin,
        // "123"
        'progress_bar_color': '000000',
        'can_take_screenshot': enableScreenShot
      });
    } catch (e) {
      showLog("the album view error $e");
    }
  }

  Future<bool?> isDeveloperModeEnabled() async {
    return await platform.invokeMethod<bool>('isDeveloperModeEnabled');
  }

  Future<bool?> isRunningOnEmulator() async {
    return await platform.invokeMethod<bool>('isRunningOnEmulator');
  }
}
