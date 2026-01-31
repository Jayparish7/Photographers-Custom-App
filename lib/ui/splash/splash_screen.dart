import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/essential_transporter_data_controller.dart';
import 'package:photomall_flutter/controllers/image_server_controller.dart';
import 'package:photomall_flutter/controllers/language_controller.dart';
import 'package:photomall_flutter/controllers/login_controller.dart';
import 'package:photomall_flutter/core/Utils/snackbar_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/route_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/constants/studio_config_constants.dart';
import 'package:photomall_flutter/core/services/Database/db_statics.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/common_key_value.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/preference/preference_handler/notification_preference.dart';
import 'package:photomall_flutter/traits/utils/screen_utils.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';
import 'package:photomall_flutter/ui/popup/app_update_status_dialog.dart';
import 'package:photomall_flutter/ui/register/device_register_controller.dart';
import 'package:photomall_flutter/ui/routes/app_update_status.dart';
import 'package:photomall_flutter/ui/shared/LanguageSelector.dart';
import 'package:provider/provider.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/Utils/preference_helper.dart';
import '../../driftdb/dao/carousel_properties_dao.dart';

SplashScreenState? splashScreenState;

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    splashScreenState = SplashScreenState();
    return splashScreenState!;
  }
}

ApiHelper? apiHandler;
AppUpdateStatus? appUpdateStatus;
DbStatics? dbStatics;

class SplashScreenState extends State<SplashScreen> {
  final ValueNotifier<bool> showProgress = ValueNotifier<bool>(false);
  bool ownPlayStoreOrNot = false;

  @override
  void initState() {
    super.initState();
    apiHandler = Provider.of<ApiHelper>(context, listen: false);
    _checkIfAbleToOpen();
    checkOwnPlayStoreAccountOrNot();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAppEssentials(context);
      checkGallery();
    });
    showLog("timer starts now ${DateTime.now()}");
  }

  _checkIfAbleToOpen() async {
    await restrictScreenShot();
    bool? isRunningOnEmulator = false;
    if (!isDeveloperMode) {
      /*    bool? isDeveloperModeEnabled =
          await NativeMethodChannel().isDeveloperModeEnabled();*/
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      if (Platform.isIOS) {
        var iosInfo = await deviceInfo.iosInfo;
        if (!iosInfo.isPhysicalDevice) {
          isRunningOnEmulator = true;
        }
      }
      if (Platform.isAndroid) {
        var androidInfo = await deviceInfo.androidInfo;
        if (!androidInfo.isPhysicalDevice) {
          isRunningOnEmulator = true;
        }
      }

      /*  bool? isRunningOnEmulator =
          await NativeMethodChannel().isRunningOnEmulator();*/
      if (isRunningOnEmulator) {
        customSnackBar(
            context: context,
            title: S.of(context).unsafeDevice,
            message: S.of(context).deviceIsRootedOrMayAppRunningOnEmulator);
        Future.delayed(Duration(milliseconds: 5500), () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        });
      } else {
        _initApiCalls();
      }
    } else {
      _initApiCalls();
    }
  }

  checkGallery() async {
    CarouselPropertiesDao carouselPropertiesDao = CarouselPropertiesDao();
    List<appDb.CarouselProperty>? files =
        await carouselPropertiesDao.getCarouselsProperties();
    showLog('getCarouselsProperties56 splash ${files}');

    if (files != null) {
      showLog('getCarouselsProperties78 splash ${files}');

      for (appDb.CarouselProperty file in files) {
        if (file.image != null) {
          showLog('getCarouselsProperties88  splash ${file.ableCode}');

          await PreferenceHelper.setBool(carouselKey, true);
          showLog('carousel splash ');
        } else {
          await PreferenceHelper.setBool(carouselKey, false);
        }
      }
    }
  }

  bool isColorLight(Color color) {
    // Convert the color to its RGB components
    double red = color.red / 255.0;
    double green = color.green / 255.0;
    double blue = color.blue / 255.0;

    // Calculate luminance
    double luminance = 0.2126 * red + 0.7152 * green + 0.0722 * blue;

    // Determine if the color is light or dark
    return luminance > 0.5;
  }

  checkOwnPlayStoreAccountOrNot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await prefs.getString(ownPlayStoreKey);
    showLog('checkOwnPlayStoreAccountOrNot $res');
    if (res == '1') {
      setState(() {
        ownPlayStoreOrNot = true;
      });
      showLog('checkOwnPlayStoreAccountOrNot1111 $ownPlayStoreOrNot');
    }
  }

  @override
  Widget build(BuildContext context) {
    final buffer = StringBuffer();
    if (splashBackgroundColorCode.length == 6 ||
        splashBackgroundColorCode.length == 7) buffer.write('ff');
    buffer.write(splashBackgroundColorCode.replaceFirst('#', ''));
    var isLight = isColorLight(Color(int.parse(buffer.toString(), radix: 16)));
    Color splashColor = Color(int.parse(buffer.toString(), radix: 16));
    showLog('isDark----> ${!isLight}');
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(int.parse(buffer.toString(), radix: 16)),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  Expanded(
                    child: Image.asset(
                      "assets/images/splash_logo.png",
                    )
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(
                            duration: Duration(milliseconds: 2500),
                            color: splashColor)
                        .animate() // this wraps the previous Animate in another Animate
                        .fadeIn(
                            duration: Duration(milliseconds: 2500),
                            curve: Curves.easeIn),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  (ownPlayStore == '0')
                      ? Image.asset(
                          height: 280,
                          "assets/images/splash_photomall_logo.png",
                          color: isLight ? Colors.black : Colors.white,
                        )
                      : SizedBox(),
                  ValueListenableBuilder<bool>(
                      valueListenable: showProgress,
                      builder:
                          (BuildContext context, bool value, Widget? child) {
                        return value
                            ? Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80),
                                  //set border radius more than 50% of height and width to make circle
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                          child: Stack(
                                        children: [
                                          LoadingAnimationWidget
                                              .threeArchedCircle(
                                            key: GlobalKey(),
                                            color: splashColor,
                                            size: 30,
                                          ),
                                          Positioned.fill(
                                            child: Image.asset(
                                              'assets/images/splash_logo.png',
                                              color: splashColor,
                                            ),
                                          )
                                        ],
                                      )),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(S.of(context).pleaseWait,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.start),
                                            SizedBox(
                                              height: 3,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox();
                      }),
                  /* Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                       Text(
                          S.of(context).poweredBy,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        Image.asset(
                          "assets/images/photomall_logo.png",
                          height: MediaQuery.of(context).size.height * 0.06,
                        ),
                      ],
                    ),
                  ),*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /*splashScreenNavigation() async{
    Navigator.pushNamed(context, RoutePaths.DeviceRegister);
  }*/
  splashScreenNavigation() async {
    showProgress.value = true;
    bool navigateToLanguagePage = false;
    // Navigator.pop(context);
    var prefs = await SharedPreferences.getInstance();
    showLog("the data available screen shot ${prefs.getBool("screen_shot")}");

    var devRegStatus =
        prefs.getBool('$isDeviceRegisteredPreferenceKey') ?? false;
    if (Platform.isAndroid) {
      NotificationPreference notificationPreference = NotificationPreference();
      await notificationPreference.setNotifyBusy(false);
    }
    if (!devRegStatus) {
      DeviceRegisterController deviceRegisterController =
          DeviceRegisterController();
      bool status = await deviceRegisterController.getDeviceRegistered(context);
      bool isNetworkAvailable = await InternetConnectionChecker.instance.hasConnection;
      if (isNetworkAvailable) {
        if (status) {
          navigateToLanguagePage = true;
        } else {
          showProgress.value = false;
          _onDeviceRegisterFailed();
          return;
        }
      } else {
        showProgress.value = false;
        _splashScreenNetConnectionFailed();
        return;
      }
    }

    try {
      /// insert essential transporter data
      EssentialTransporterDataController essentialTransporterDataController =
          EssentialTransporterDataController();
      await essentialTransporterDataController.essentialTransporterDataApiCall(
          isFromSplashScreen: true);

      /// re-do transporter api call for all entry it will update all data
      /// get transported data and toggle all update not required [0] to update required [1] exception for [2]
      TransporterDao transporterDao = TransporterDao();
      List<appDb.TransportDataData> _transporterData = await transporterDao
          .getTransporterWithoutTemporaryUrlsAndEssentialData();

      if (_transporterData.isNotEmpty) {
        for (appDb.TransportDataData transportDataData in _transporterData) {
          showLog(
              "the code : ${transportDataData.code} and tag : ${transportDataData.tag}");
          // toggle update required to 1
          await transporterDao.insertOrUpdateTransporter(
              code: transportDataData.code,
              tag: transportDataData.tag,
              updateRequiredValue: 1,
              eventType: transportDataData.type);
        }
      }
      EssentialUtils essentialUtils = EssentialUtils();
      await essentialUtils.triggerToFillDataInserted();
      CommonKeyValueDao commonKeyValueDao = CommonKeyValueDao();
      await commonKeyValueDao.deleteAllCommonTable();
    } catch (e, s) {
      showProgress.value = false;
      showLog(" exception in transporter data in splash screen page\n${s},$e");
    }

    /// get the color of this app
    AppColorData appColorData = AppColorData();
    await appColorData.getColor(context);

    /// check for force update
    await AppUpdateStatus(context).checkAppUpdate(
        context: context,
        onUpdate: () async {
          /* await _showAppUpdate(context);*/
        },
        onForceUpdate: () async {
          showLog("checkUpdateAvailable :: Context $context");
          await _showAppForceUpdate(context: context);
        },
        onAppExpired: () async {
          await _showAppExpired(context: context);
        });

    /// set device max screen status
    ScreenUtil screenUtil = ScreenUtil();
    await screenUtil.setScreenSize();

    /// get & set  server status
    ImageServer imageServer = ImageServer();
    bool status = await imageServer.getServerStatus();
    await imageServer.setServerStatus(status);

    /// get country code for login
    LoginController loginController = LoginController();
    await loginController.setCountries();

    /// get the language of this app
    DeviceLanguage deviceLanguage =DeviceLanguage();
    //AppLanguage appLanguage = AppLanguage();
    // await appLanguage.getLanguages();
    //await deviceLanguage.updateLocale();

    if (navigateToLanguagePage) {
      await deviceLanguage.updateLocale();
    }
    showProgress.value = false;
    Navigator.pushReplacementNamed(context, RoutePaths.Home);
  }

  _initApiCalls() async {
    //internet available

    showLog('Data connection is available.');
    splashScreenNavigation();
  }

  getAppEssentials(BuildContext context) async {
    ScreenUtil screenUtil = ScreenUtil();
    screenUtil.setCurrentDevice(context);
    // get essential static variables
    EssentialUtils storageUtils = EssentialUtils();
    await storageUtils.loadAppEssentialData();
  }

  _onDeviceRegisterFailed() {
    customSnackBar(
        context: context,
        title: 'Device Register Failed',
        message: 'Device register failed please try after some time');
    Future.delayed(Duration(milliseconds: 5500), () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });
    // Navigator.pop(context);
  }

  _splashScreenNetConnectionFailed() {
    customSnackBar(
        context: context,
        title: 'You are offline',
        message: 'Please check your data connection');
    Future.delayed(Duration(milliseconds: 5500), () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });
    // Navigator.pop(context);
  }

  /* _showAppUpdate(BuildContext context) async {
    showLog("showAppUpdate 1");
    var prefs = await SharedPreferences.getInstance();
    final currentTime = DateTime.now();
    DateTime resetTime;
    String time = prefs.getString("time");
    if (time != null) {
      resetTime = DateTime.parse(time);
    }
    CommonAlertDialog _appUpdateDialog = appUpdateStatusDialog(
        context,
        S.of(context).update,
        "$appStudioName ${S.of(context).recommendsThatYouUpdateToTheLatestVersion}",
    onPop:(){ Navigator.pop(context);});
    if (resetTime != null && !compareDate(currentTime, resetTime)) {
      prefs.setBool("one_time_show", true);
      showLog("one_time_show is  true");
    }
    if (prefs.getBool("one_time_show") == null ||
        prefs.getBool("one_time_show")) {
      showLog("Once in a day");
      if (prefs.getBool(appUpdateOrNotPreferenceKey)) {
        showLog("if");
        //prefs.setBool('$appUpdateOrNot', false);
       return showDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) => _appUpdateDialog);
      } else {
        showLog("else");
      }
      prefs.setBool("one_time_show", false);
      prefs.setString("time", currentTime.toString());
      //splashScreenNavigation();
    }
  }

  bool compareDate(DateTime current, DateTime reset) {
    if (reset != null) {
      return  // current.minute == reset.minute;
        current.year == reset.year &&
            current.month == reset.month &&
            current.day == reset.day;
    } else {
      return true;
    }
  }*/

  _showAppForceUpdate({required BuildContext context}) async {
    showLog("force 1");
    var prefs = await SharedPreferences.getInstance();
    showLog("force 2");

    Widget _appForceUpdateDialog = await appForceUpdateStatusDialog(
        context,
        S.of(context).you_are_using_outdated_app,
        S.of(context).kindly_update_to_the_latest_version);
    showLog("force 3");

    if ((prefs.getBool(appUpdateOrNotPreferenceKey)!)) {
      showLog("force 4");
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return _appForceUpdateDialog;
          });
    } else {
      showLog("else");
      //splashScreenNavigation();
    }
  }

  _showAppExpired({required BuildContext context}) async {
    var prefs = await SharedPreferences.getInstance();
    Widget _appForceUpdateDialog = await appExpiredDialog(
        context,
        S.of(context).outOfService,
        S.of(context).apologiesForAnyInconvenienceButTheServiceYouAreTrying);
    if ((prefs.getBool(appUpdateOrNotPreferenceKey)!)) {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return _appForceUpdateDialog;
          });
    } else {
      showLog("else");
      //splashScreenNavigation();
    }
  }

  restrictScreenShot() async {
    await ScreenProtector.preventScreenshotOn();
  }
}

class SecondRoute extends StatefulWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  @override
  Widget build(BuildContext context) {
    showLog("Second screen is showing");
    return Scaffold(
        body: Container(
      color: Colors.yellow,
    ));
  }
}

class EventModel {
  final String? code;
  final int? lastUpdated;

  EventModel({this.code, this.lastUpdated});
}
