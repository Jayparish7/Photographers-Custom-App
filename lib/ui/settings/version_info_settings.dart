import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:launch_app_store/launch_app_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/studio_data_controller.dart';
import 'package:photomall_flutter/core/Utils/file_util.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/route_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/screenshot_response_model.dart';
import 'package:photomall_flutter/driftdb/dao/file_dao.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/traits/common_widgets/custom_transition_widget.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';
import 'package:photomall_flutter/ui/shared/LanguageSelector.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_alert_dialog.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_button.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:provider/provider.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart' as autoPin;

import '../../controllers/user_data_controller.dart';
import '../../core/constants/shared_preference_constants.dart';
import '../app_side_drawer/side_drawer_constants.dart';
import '../bottom_navigation/bottom_navigation_constants.dart';
import '../drawer/side_drawer_model.dart';
import '../event/list/events_list_route.dart';
import '../login/login_route.dart';
import '../routes/account_delete_route.dart';

class VersionInfoRoute extends StatefulWidget {
  @override
  _VersionInfoRouteState createState() => _VersionInfoRouteState();
}

class _VersionInfoRouteState extends State<VersionInfoRoute> {
  var photomallInfoVisibility = false;

  // var appUpdateAvailable = false;
  final ValueNotifier<bool> appUpdateAvailable = ValueNotifier<bool>(false);
  final ValueNotifier<String> appVersionCode = ValueNotifier<String>("1");
  final ValueNotifier<bool> screenSecureStatus = ValueNotifier<bool>(false);
  final ValueNotifier<bool> showScreenSecure = ValueNotifier<bool>(false);

  //var appVersionCode = '1.0.0';
  var innerContainerWidth = 180.0;
  var innerContainerHeight = 180.0;
  var containerHeight = 450.0;
  var documentDirectory;
  String? publicStoragePath;
  String? privateStoragePath;
  bool? login;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    getStoragePaths();
    super.initState();
    _checkAppUpdateStatus();
  }

  _checkAppUpdateStatus() async {
    login = await PreferenceHelper.getBool(isUserLoggedInPreferenceKey);

    var prefs = await SharedPreferences.getInstance();
    int? status = await prefs.getInt(appUpdateStatusKey);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersionCode.value = packageInfo.buildNumber;
    if (status == 1) {
      appUpdateAvailable.value = true;
    }
    bool enableScreenShot =
        await PreferenceHelper.getBool(screenShotPreferenceKey);
    if (enableScreenShot) {
      showScreenSecure.value = true;
    } else {
      showScreenSecure.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 50),
        children: [_setVersionInfoCard(context)]);
  }

  _setVersionInfoCard(BuildContext context) {
    double height = MediaQuery.of(context).size.height * .02;
    StudioDataController studioDataController = StudioDataController();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_sharp,
                  color: AppColorData.appBarTextColor,
                )),
            UniqueText(text: S.of(context).settings)
          ],
        ),

        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: LinearGradient(
                      begin: AppColorData.sideDrawerBackgroundBegin,
                      end: AppColorData.sideDrawerBackgroundEnd,
                      colors: AppColorData.sideDrawerBackgroundColors,
                      stops: AppColorData.sideDrawerStops)),
              child: studioDataController.getStudioLogo(context,
                  documentPath: documentDirectory,
                  publicStoragePath: publicStoragePath!),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),

        CustomItemTransition(
          delay: itemTransitionDelay + 200,
          duration: itemTransitionDuration,
          child: listItem(
              context, FontAwesomeIcons.language, S.of(context).language),
        ),
        SizedBox(
          height: height,
        ),
        isPhotomallApp
            ? SizedBox()
            : CustomItemTransition(
                delay: itemTransitionDelay + 300,
                duration: itemTransitionDuration,
                child: listItem(context, Icons.share, S.of(context).share_app)),
        SizedBox(
          height: height,
        ),
        CustomItemTransition(
            delay: itemTransitionDelay + 400,
            duration: itemTransitionDuration,
            child: listItem(
                context, Icons.star, S.of(context).rate_us_on_google_play)),
        SizedBox(
          height: height,
        ),
        FutureBuilder<bool>(
            future: PreferenceHelper.getBool(isUserLoggedInPreferenceKey),
            builder: (ctx, snapshot) {
              if (!snapshot.hasData || !snapshot.data! || snapshot.hasError) {}
              return CustomItemTransition(
                  delay: itemTransitionDelay + 500,
                  duration: itemTransitionDuration,
                  child: ValueListenableBuilder<bool>(
                      valueListenable: screenSecureStatus,
                      builder:
                          (BuildContext context, bool value, Widget? child) {
                        return listItem(
                            context,
                            Icons.screenshot,
                            screenSecureStatus.value
                                ? S.of(context).disableScreenshot
                                : S.of(context).enableScreenshot,
                            itemIndex: 4,
                            switchEnabled: true);
                      }));
            }),
        SizedBox(
          height: height,
        ),

        Stack(
          children: [
            Positioned(
              left: 15,
              top: 12,
              child: Icon(
                Icons.security_update,
                color: AppColorData.bgIconColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: CustomItemTransition(
                delay: itemTransitionDelay + 500,
                duration: itemTransitionDuration,
                child: ValueListenableBuilder<bool>(
                    valueListenable: appUpdateAvailable,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return ListTile(
                        title: ValueListenableBuilder<String>(
                            valueListenable: appVersionCode,
                            builder: (BuildContext context, String buildNumber,
                                Widget? child) {
                              return CommonText(
                                isCard: true,
                                isHighlightedCard: true,
                                text:
                                    " ${S.of(context).app_version}  $buildNumber",
                                style: Theme.of(context).textTheme.titleLarge,
                              );
                            }),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Visibility(
                                visible: !value,
                                child: CommonText(
                                  isCard: true,
                                  text:
                                      '${S.of(context).updated_version_is_already_installed}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Visibility(
                                  visible: value,
                                  child: CommonButton(
                                    buttonText: S.of(context).update_available,
                                    onPressCall: () {
                                      LaunchReview.launch();
                                    },
                                  )),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
        SizedBox(
          height: height,
        ),
        (login == true)
            ? CustomItemTransition(
                delay: itemTransitionDelay + 400,
                duration: itemTransitionDuration,
                child: InkWell(
                    onTap: () {
                      showLog('Account delete api called');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeleteRoute()));
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.delete,
                        color: AppColorData.bgIconColor,
                      ),
                      title: CommonText(
                          isHighlightedCard: true,
                          isCard: true,
                          text: S.of(context).delete_account),
                    )))
            : SizedBox(),

        //    listItem(context, Icons.help, S.of(context).technical_support),
      ],
    );
  }

  removeValues(BuildContext context, {bool? deletePhotos}) async {
    UserDataController userDataController = UserDataController();
    await userDataController.deleteUserProfile();
    await userDataController.deleteUserEventsFromDb();
    var prefs = await SharedPreferences.getInstance();
    showLog("refresh token : ${prefs.getString(refreshTokenPreferenceKey)}");
    showLog("access token : ${prefs.getString(accessTokenPreferenceKey)}");
    prefs.remove(isUserLoggedInPreferenceKey);
    prefs.remove(registeredPreferenceKey);
    prefs.remove(accessTokenPreferenceKey);
    prefs.remove(refreshTokenPreferenceKey);
    prefs.remove(eventKeyPreferenceKey);
    prefs.remove(userNameSharedPreferenceKey);
    prefs.remove(userDataKey);
    prefs.remove(screenShotPreferenceKey);
    prefs.remove(profileImage);
    prefs.remove(redirectionConstant);
    prefs.remove(isNotificationsAvailablePreferenceKey);
    prefs.remove(callFoldersApi);
    prefs.remove(callOnceKey);
    prefs.remove(profileKey);
    prefs.remove(userMobileNumberPreferenceKey);

// get user events and delete all records

    /* dbHelper.deleteRecordsAddedAfterLogin(eventDownloadStatus,user_event,DbStatics.tableAlbums);
  dbHelper.deleteRecordsAddedAfterLogin(eventDownloadStatus,user_event,DbStatics.tableImages);
  dbHelper.deleteRecordsAddedAfterLogin(eventDownloadStatus,user_event,DbStatics.tableStudioDetails);
  dbHelper.deleteRecordsAddedAfterLogin(eventDownloadStatus,user_event,DbStatics.tableLastUpdatedAt);*/
    if (isPhotomallApp == false) {
      Navigator.pop(context);
      SideDrawerModel drawerChild =
          Provider.of<SideDrawerModel>(context, listen: false);
      drawerChild.setDrawerChild(LoginRoute(false), S.of(context).login,
          SideDrawerConstants.GuestLogin, BottomNavigationConstants.GuestLogin);
    } else {
      Navigator.pop(context);
      SideDrawerModel drawerModel =
          Provider.of<SideDrawerModel>(context, listen: false);
      drawerModel.setDrawerChild(
          EventsListRoute(
            arguments: EventsListArguments(isArchivedEven: false),
          ),
          S.of(context).events,
          0,
          0);
    }
  }

  FileUtil fileUtil = FileUtil();
  FileModelDao fileModelDao = FileModelDao();

  setNormalUserSettings(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          //listItem(context, Icons.person, "User Profile"),
        ],
      ),
    );
  }

  Widget listItem(BuildContext context, IconData icon, String settingName,
      {int? itemIndex, bool switchEnabled = false}) {
    StudioDataController studioDataController = StudioDataController();
    return InkWell(
      onTap: () async {
        if (settingName == S.of(context).language) {
          showModalBottomSheet(
                  context: context,
                  isScrollControlled: true, // Allows full-screen height if needed
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (context) {
                    return LanguageSelector();
                  })
              .then((bool) => Navigator.pushReplacement(context,
                  CustomPageTransitionRoute(page: Material(child: VersionInfoRoute()))));
        }
        if (settingName == S.of(context).share_app) {
          Share.share(
            "${await studioDataController.getStudioName()} ${S.of(context).appHasCoolFeaturesISuggestYouToCheckoutThis}\n "
            "${await studioDataController.getPtmlDomin()}/${await studioDataController.getShortUrl()}/app-download",
            //    'I am on $appName App, suggest you to checkout this awesome app'
          );
        } else if (settingName == S.of(context).rate_us_on_google_play) {
          LaunchReview.launch();
        }
        if (itemIndex == 4) {}
      },
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
                  isCard: true,
                  isHighlightedCard: true,
                  textAlign: TextAlign.left,
                  text: settingName,
                  color: AppColorData.normalTextColor,
                  fontWeight: FontWeight.normal,
                  //fontSize: TextProperty.p1,
                ),
              ),
            ),
            switchEnabled
                ? Switch(
                    activeColor: Colors.white,
                    activeTrackColor: AppColorData.bgIconColor,
                    inactiveTrackColor:
                        AppColorData.buttonBackgroundColors.first,
                    inactiveThumbColor: Colors.white,
                    value: screenSecureStatus.value,
                    onChanged: (l) async {
                      screenSecureStatus.value = !screenSecureStatus.value;
                      if (screenSecureStatus.value) {
                        PhotomallApis photomallApis = PhotomallApis(context);
                        ScreenShot? screenShot =
                            await photomallApis.screenShotRequestApiCall();
                        if (screenShot != null &&
                            screenShot.data != null &&
                            screenShot.data!.otp != null) {
                          int otp = screenShot.data!.otp!;
                          bool status = await showOtpPopup(otp);
                          if (status) {
                            await ScreenProtector.preventScreenshotOff();
                            await PreferenceHelper.setBool(
                                enableScreenShotKey, true);
                          } else {
                            screenSecureStatus.value = false;
                            await PreferenceHelper.remove(enableScreenShotKey);
                          }
                        }
                      } else {
                        await ScreenProtector.preventScreenshotOn();
                        await PreferenceHelper.remove(enableScreenShotKey);
                      }
                      String message = screenSecureStatus.value
                          ? "Screen shot enabled"
                          : "Screen shot disabled";
                      ToastUtil.showSnackBarAtCurrentState(message);
                      return;
                    })
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> getStoragePaths() async {
    if (studioPublicPath != null &&
        appDocumentDirectoryPath != null &&
        studioPrivatePath != null) {
      publicStoragePath = studioPublicPath;
      documentDirectory = appDocumentDirectoryPath;
      privateStoragePath = studioPrivatePath;
    } else {
      EssentialUtils essentialUtils = EssentialUtils();
      essentialUtils.loadAppEssentialData();
      publicStoragePath = studioPublicPath;
      documentDirectory = appDocumentDirectoryPath;
      privateStoragePath = studioPrivatePath;
    }
  }

  showOtpPopup(int otp) async {
    bool status = false;
    await showDialog(
        context: context,
        builder: (context) {
          return CommonAlertDialog(
            titleWidget: Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 10),
              child: CommonText(
                  text: S.of(context).enterOtp,
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            canPop: true,
            actions: [],
            contentWidget: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: S.of(context).ContactStudioOwnerToGetOTP,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  autoPin.PinFieldAutoFill(
                    autoFocus: true,
                    decoration: autoPin.UnderlineDecoration(
                      colorBuilder: autoPin.FixedColorBuilder(
                          AppColorData.iconSelectedColor),
                      textStyle: Theme.of(context).textTheme.titleLarge,
                    ),
                    currentCode: '',
                    onCodeChanged: ((val) async {
                      if (val != null && val.length == otpLength) {
                        if (val == otp.toString()) {
                          status = true;
                          Navigator.pop(context);
                        }
                      }
                    }),
                    onCodeSubmitted: ((val) {}),
                    codeLength: otpLength,
                  ),
                ],
              ),
            ),
          );
        });
    return status;
  }
}
