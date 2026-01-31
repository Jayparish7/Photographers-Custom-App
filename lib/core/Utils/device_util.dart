import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

class DeviceUtil {
  static bool get isDesktop => !isWeb && (isWindows || isLinux || isMacOS);

  static bool get isMobile => !isWeb && (isAndroid || isIOS);

  static bool get isWeb => kIsWeb;

  static bool get isWindows => Platform.isWindows;

  static bool get isLinux => Platform.isLinux;

  static bool get isMacOS => Platform.isMacOS;

  static bool get isAndroid => Platform.isAndroid;

  static bool get isFuchsia => Platform.isFuchsia;

  static bool get isIOS => Platform.isIOS;

  static bool isLandscape(BuildContext c) =>
      MediaQuery.of(c).orientation == Orientation.landscape;

  static Size size(BuildContext c) => MediaQuery.of(c).size;

  static double width(BuildContext c) => size(c).width;

  static double height(BuildContext c) => size(c).height;

/*  static bool isSmallScreen(BuildContext context) {
    showLog("device util context where ${context}");
    String prefix = bootstrapPrefixBasedOnWidth(DeviceUtil.width(context));
    return (isMobile || prefix == 'sm' || prefix == '');
  }*/

/*  static bool isAppBarRequired(BuildContext context){
    String prefix = bootstrapPrefixBasedOnWidth(DeviceUtil.width(context));
    return (prefix != 'lg' || prefix != 'xl');
  }*/
}
