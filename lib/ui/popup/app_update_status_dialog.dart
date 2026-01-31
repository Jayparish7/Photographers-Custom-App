import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launch_app_store/launch_app_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_alert_dialog.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_button.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text_button.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';

appUpdateStatusDialog(BuildContext context, String title, String message,
    {required Function onPop}) {
  var _packageName = "";
/*var _appName = "";
  var _versionName = "";
  var _versionCode = "";*/
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    _packageName = packageInfo.packageName;
/*    _appName = packageInfo.appName;
    _versionName = packageInfo.version;
    _versionCode = packageInfo.buildNumber;
*/
  });
  return /*CommonAlertDialog(
    title: title,
    content: message,
    actions: [
      CommonTextButton(buttonText: S.of(context).later, onPressCall: onPop
          */ /*() {
          showLog("appUpdateStatusDialog later is pressed");
          Navigator.pop(context);
        },*/ /*
          ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.01,
      ),
      CommonButton(
        buttonText: S.of(context).update,
        onPressCall: () {
          LaunchReview.launch(androidAppId: _packageName, iOSAppId: "");
        },
      ),
    ],
  )*/
      showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    isDismissible: false,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UniqueText(
                  text: title,
                ),
              ],
            ),
            Image.asset('assets/images/playStore.png'),
            SizedBox(height: 10),
            CommonText(
              style: TextStyle(
                  color: AppColorData.cardHighlightedTextColour,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              text: message,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CommonTextButton(
                  buttonText: S.of(context).later,
                  onPressCall: onPop,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                ElevatedButton(
                  child: CommonText(
                    text: S.of(context).update,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppColorData.buttonBackgroundColors.last,
                    foregroundColor: AppColorData.buttonTextColors,
                  ),
                  onPressed: () {
                    LaunchReview.launch(
                        androidAppId: _packageName, iOSAppId: "");
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future<Widget> appForceUpdateStatusDialog(
  BuildContext context,
  String title,
  String message,
) async {
  var _packageName = "";
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    _packageName = packageInfo.packageName;
  });
  return await CommonAlertDialog(
    canPop: false,
    title: title,
    content: message,
    actions: [
      CommonTextButton(
        buttonText: S.of(context).later,
        onPressCall: () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.01,
      ),
      CommonButton(
        buttonText: S.of(context).update,
        onPressCall: () {
          LaunchReview.launch(androidAppId: _packageName, iOSAppId: "");
        },
      ),
    ],
  );
}

Future<Widget> appExpiredDialog(
    BuildContext context, String title, String message) async {
  return await CommonAlertDialog(
    canPop: false,
    title: title,
    content: message,
    actions: [
      CommonTextButton(
        buttonText: S.of(context).close,
        onPressCall: () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
      ),
    ],
  );
}
