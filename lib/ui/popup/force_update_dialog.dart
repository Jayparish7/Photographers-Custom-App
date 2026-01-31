import 'package:flutter/material.dart';
import 'package:launch_app_store/launch_app_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/generated/l10n.dart';

Widget appForceUpdateStatusDialog(
    BuildContext context, String title, String message) {
//  var _appName = "";
  var _packageName = "";
  // var _versionName = "";
  //var _versionCode = "";
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    //_appName = packageInfo.appName;
    _packageName = packageInfo.packageName;
    // _versionName = packageInfo.version;
    //_versionCode = packageInfo.buildNumber;
  });
  showLog(
      "inside appForceUpdateStatusDialog : error response 426 api version changed");
  return SimpleDialog(
    contentPadding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
    //this right here
    children: <Widget>[
      Container(
        height: 250.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark, fontSize: 20),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(/*color: textColor, */ fontSize: 15),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    if (_packageName.isNotEmpty) {
                      LaunchReview.launch(
                          androidAppId: _packageName, iOSAppId: "");
                    }
                  },
                  child: Text(S.of(context).update_now),
                ),
              ],
            )
          ],
        ),
      ),
    ],
  );
}
