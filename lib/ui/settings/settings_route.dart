import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/ui/drawer/side_drawer_model.dart';
import 'package:photomall_flutter/ui/popup/logout_dialog.dart';
import 'package:photomall_flutter/ui/settings/version_info_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  final SideDrawerEssential? sideDrawerEssential;
  final SettingsArguments? arguments;

  Settings({Key? key, this.sideDrawerEssential, this.arguments})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => SettingsState();
}

showLogoutDialog(BuildContext context) async {
  Widget _logoutDialog = logoutDialog(context);
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => _logoutDialog);
}

class SettingsState extends State<Settings> {
  bool visibilityForLogoutAndExistingEvents = false;
  bool registeredStatus = false;
  bool loggedInStatus = false;
  String? deviceId;
  String appName = "Your Studio";

  @override
  void initState() {
    super.initState();

    logoutVisibilityStatus();
  }

  logoutVisibilityStatus() async {
    var prefs = await SharedPreferences.getInstance();
    deviceId = (prefs.getString("$deviceIdPreferenceKey") ?? "");
    setState(() {
      registeredStatus = prefs.getBool(registeredPreferenceKey) ?? false;
      loggedInStatus = prefs.getBool(isUserLoggedInPreferenceKey) ?? false;
    });
    showLog("Registered status : $registeredStatus");
    showLog("Logged In status : $loggedInStatus");
    if ((registeredStatus == true) || (loggedInStatus == true)) {
      visibilityForLogoutAndExistingEvents = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        !isPhotomallApp ? Navigator.pop(context) : null;
        return true;
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: AppColorData.backgroundGradientBegin,
                end: AppColorData.backgroundGradientEnd,
                colors: AppColorData.backgroundColors,
                stops: AppColorData.appBackgroundStops)),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          // appBar: CommonAppBar(title: S.of(context).settings),
          backgroundColor: Colors.transparent,
          body: VersionInfoRoute(),
        ),
      ),
    );
  }
/*
  Widget listItem(BuildContext context, IconData icon, String settingName) {
    return InkWell(
      onTap: () async {
        if (settingName == S.of(context).language) {
          showLog("Language item clicked");
          await Navigator.pushNamed(context, RoutePaths.Language,
              arguments: LanguageSelectorArguments(
                  needToShowDoneButton: false, isFromSetting: true));
          */
/*Navigator.push(
              context,CustomPageTransitionRoute(
            page:  LanguageSelector(needToShowDoneButton: false)
          ),
          );*/
/*

          setState(() {});
        }
        if (settingName == S.of(context).existing_events) {
          getEventsIdFromDb(deviceId, context, true);

        } else if (settingName == S.of(context).share_app) {
          Share.share(
            "'$appName'${S.of(context).appHasCoolFeaturesISuggestYouToCheckoutThis}",
            //    'I am on $appName App, suggest you to checkout this awesome app'
          );
        } else if (settingName == S.of(context).restore_events) {
          showLog("Restore Events Clicked");
          getEventsIdForRestore(context);
        } else if (settingName == S.of(context).rate_us_on_google_play) {
          LaunchReview.launch();
        } else if (settingName == S.of(context).logout) {
          showLogoutDialog(context);
        } else if (settingName == S.of(context).version_info) {
          Navigator.pushNamed(context, RoutePaths.VersionInfo);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Opacity(
          opacity: 1,
          child: CommonCard(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColorData.bgIconBackgroundColor,
                          begin: AppColorData.bgIconGradientBegin,
                          end: AppColorData.bgIconGradientEnd,
                          stops: AppColorData.bgIconStops,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        icon,
                        color: AppColorData.bgIconColor,
                        size: 25,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: CommonText(
                          textAlign: TextAlign.left,
                          text: settingName,
                          color: AppColorData.normalTextColor,
                          fontWeight: FontWeight.normal,
                          style: Theme.of(context).textTheme.titleMedium
                          //fontSize: TextProperty.p1,
                          ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }*/
}

class EventDetails {
  String code;
  String name;

  EventDetails(this.code, this.name);
}

class SettingsArguments {
  SideDrawerEssential? sideDrawerEssential;

  SettingsArguments({this.sideDrawerEssential});
}
