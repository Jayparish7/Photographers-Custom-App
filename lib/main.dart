import 'dart:async';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:ui';
import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:device_preview/device_preview.dart';
import 'package:face_camera/face_camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/redirection_controller.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/constants/studio_config_constants.dart';
import 'package:photomall_flutter/core/notification/notificationMethods/local_notification_method.dart';
import 'package:photomall_flutter/core/notification/notification_utils.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_table_dao.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart'
    as transporter;
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/media/my_photos_route.dart';
import 'package:photomall_flutter/preference/redirection_route_constant.dart';
import 'package:photomall_flutter/route_setup.dart';
import 'package:photomall_flutter/traits/globals.dart';
import 'package:photomall_flutter/ui/app_side_drawer/side_drawer_constants.dart';
import 'package:photomall_flutter/ui/bottom_navigation/bottom_navigation_constants.dart';
import 'package:photomall_flutter/ui/drawer/side_drawer_model.dart';
import 'package:photomall_flutter/ui/event/booking/book_me_route.dart';
import 'package:photomall_flutter/ui/gallery/gallery_route_view_model.dart';
import 'package:photomall_flutter/ui/login/login_route.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workmanager/workmanager.dart';
import 'controllers/event_ai_data_controller.dart';
import 'controllers/language_controller.dart';
import 'core/constants/route_constants.dart';
import 'core/services/api_helper.dart';
import 'firebase_options.dart';
import 'preference/preference_handler/redirection_preference_handler.dart';
import 'preference/preference_model/redirection_preference_model.dart';

BuildContext? homeContext;
Completer homeContextCompleter = Completer();
BuildContext? mainContext;
Completer mainContextCompleter = Completer();
String? selectedNotificationPayload;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugins =
    FlutterLocalNotificationsPlugin();

/// Callback function for WorkManager
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Initialize local notifications
    //await Future.delayed(const Duration(seconds: 10));
    showLog(
        'Work manager start  $inputData ${task == 'show_birthday_notification'}');

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/notification_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugins.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: notificationTap,
      onDidReceiveBackgroundNotificationResponse: notificationTap,
    );

    if (task == 'show_birthday_notification' ||
        task == 'show_anniversary_notification') {
      LocalNotification localNotification = LocalNotification();

      // Show notification
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'birthday_channel',
        'Birthday Notifications',
        channelDescription: 'This channel is for sending birthday wishes',
        importance: Importance.high,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await PreferenceHelper.setBool(
          task == 'show_anniversary_notification' ? anneWishKey : BDayWishKey,
          true);
      var wishes = await PreferenceHelper.getBool(
          task == 'show_anniversary_notification' ? anneWishKey : BDayWishKey);
      showLog('wishes $task $wishes');
      await flutterLocalNotificationsPlugins.show(
          0, // Notification ID
          task == 'show_anniversary_notification'
              ? 'Happy Anniversary'
              : 'Happy Birthday!', // Title
          inputData?['message'] ?? 'Wishing you a wonderful year ahead!',
          // Message
          platformChannelSpecifics,
          payload: task == 'show_anniversary_notification'
              ? await localNotification.getPlayLoad('anniversary_payload')
              : await localNotification.getPlayLoad('birthday_payload'));
    } else {
      LocalNotification localNotification = LocalNotification();
      String code =
          task.replaceAll('show_photo_selection_reminder_notification_', '');
      showLog('show_photo_selection_reminder_notification_ ===> $code');
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'Photo_selection_reminder_channel',
        'Photo Selection reminder',
        channelDescription:
            'This channel is for sending Photo Selection reminder',
        importance: Importance.high,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugins.show(
          0, // Notification ID
          'Photo Selection Reminder', // Title
          inputData?['message'] ??
              'Photo Selection in the wedding event is yet to be confirmed. Please complete.',
          // Message
          platformChannelSpecifics,
          payload: await localNotification.getPlayLoad(code));
    }

    return Future.value(true); // Indicate task is complete
  });
}

Future<void> main() async {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    showLog('main flutter error details $details');
    //  call api only release mode
    if (!isDeveloperMode) {
      if (!'${details.exception}'.contains('HttpException') &&
          !'${details.exception}'.contains('Exception') &&
          !'${details.exception}'.contains('ClientException') &&
          !'${details.exception}'.contains('HandshakeException') &&
          (!details.exception.toString().contains('Infinity or NaN')) &&
          (!details.exception.toString().contains('Invalid argument')) &&
          (!details.exception
              .toString()
              .contains('Null check operator used on a null value'))) {
        if (details.exception !=
            'HandshakeException: Connection terminated during handshake') {
          PhotomallApis photomallApis = PhotomallApis(null);
          photomallApis.callChatNotifier(
            exception: '${details.exception}',
            errorDetail:
                '${details.stack} \n App version: $studioVersionConfig',
          );
        }
      }
    }
    showLog(
        'Main :: FlutterError.onError :: details :: ${details.exception} => ${details.stack},//// ${details.library}');
  };

  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await FaceCamera.initialize(); //Add this
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  _startApplication();
}

Future<void> _startApplication() async {
  Platform.isIOS
      ? await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        )
      : await Firebase.initializeApp();

  final fcmToken = await FirebaseMessaging.instance.getToken();
  showLog('fcm ios token $fcmToken');
  showLog('notification step 1 :: ');
  await PreferenceHelper.remove(enableScreenShotKey);

  try {
    final dbFolder = await getDatabasesPath();

    File dbFile = File('$dbFolder/photomallFlutter.db');
    if (dbFile.existsSync()) {
      showLog("yes the file is exist >>");
      dbFile.deleteSync();
    } else {
      showLog("yes the file is not exist >>");
    }
  } catch (e) {
    showLog("Cant delete database $e");
  }
  try {
    AppDb database = AppDb();
    await (database.select(database.transportData)..limit(1)).getSingleOrNull();
  } catch (e) {
    showLog('Exception while activate database $e');
  }
  try {
    await initNotificationsInMain();
  } catch (e) {
    showLog('problem while parSe initNotification: $e');
  }

  showLog('notification step 10 :: ');
  if (/*isDeveloperMode*/ 1 == 2) {
    //  runApp(RestartWidget(child: MyApp()));

    runApp(
      DevicePreview(
        enabled: isDeveloperMode,
        builder: (context) => MyApp(), // Wrap your app
      ),
    );
  } else {
    //Crash detail send only work on release mode
    //FirebaseCrashlytics.instance.enableInDevMode = true;
    //need to remove comment
    /*FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runZoned<Future<void>>(() async {
      //exception catcher
      runApp(RestartWidget(child: MyApp()));
    }, onError: FirebaseCrashlytics.instance.recordError);*/
    //need to remove comment
    //  runApp(RestartWidget(child: MyApp()));

    runApp(MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class CustomThemeProvider extends ChangeNotifier {
  updateUI() {
    notifyListeners();
  }
}

class _MyAppState extends State<MyApp> {
  Locale? locale;
  String? title = appName;
  StreamSubscription? _sub;

  /* late final FirebaseAnalytics analytics;
  late final FirebaseAnalyticsObserver observer;*/
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _sub?.cancel();
  }

  @override
  void initState() {
    super.initState();
    /* analytics=FirebaseAnalytics.instance;
    observer=FirebaseAnalyticsObserver(analytics: analytics);*/

    getDefaultLanguage();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainContext = context;
      if (!mainContextCompleter.isCompleted) {
        mainContextCompleter.complete();
      }
      initReferrerDetails();
      _initializeNotifications();
      initNotificationsInMainWidget();
    });
  }

  void _initializeNotifications() async {
    // Check for notification permission (Android 13+)
    if (await Permission.notification.isGranted) {
      showLog('got permission');
    } else {
      showLog('request permission');

      // Request permission if not granted
      await Permission.notification.request();
    }
  }

  initNotificationsInMainWidget() async {
    //initNotificationsInMain();

    bool isUpdateTokenToApi =
        await PreferenceHelper.getBool(isUpdateTokenToApiPreferenceKey);
    bool isDeviceRegister =
        await PreferenceHelper.getBool(isDeviceRegisteredPreferenceKey);
    //  String? token = await FirebaseMessaging.instance.getToken();

    if (isUpdateTokenToApi == false && isDeviceRegister) {
      String? token = await FirebaseMessaging.instance.getToken();
      showLog('token: $token');
      if (token != null && token != 'BLACKLISTED') {
        PhotomallApis(null).callUpdateFcmToken(context, token);
      }
      PreferenceHelper.setBool(isUpdateTokenToApiPreferenceKey, true);
    }
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      PreferenceHelper.getBool(isDeviceRegisteredPreferenceKey).then((value) {
        if (value) {
          if (token != 'BLACKLISTED') {
            PhotomallApis(context).callUpdateFcmToken(context, token);
          }
        }
      });
    });
    String? token = await FirebaseMessaging.instance.getToken();
    showLog('token $token');
    flutterLocalNotificationsPlugin!
        .getNotificationAppLaunchDetails()
        .then((NotificationAppLaunchDetails? notificationAppLaunchDetails) {
      Future.delayed(const Duration(seconds: 8)).then((value) async {
        EventAiDataController aiDataController = EventAiDataController();

        if (notificationAppLaunchDetails?.notificationResponse != null &&
            notificationAppLaunchDetails?.notificationResponse?.payload !=
                null) {
          if (notificationAppLaunchDetails!.notificationResponse!.payload!
              .contains('input_data')) {
            var data = jsonDecode(notificationAppLaunchDetails
                .notificationResponse!.payload!)['input_data'][0];
            if (data['key'] == TransportDataKeys.aiData) {
              await aiDataController
                  .getEventAiData(eventsCode: [data['photomall_event_code']]);
            }
            if (data['key'] == 'my-photos') {
              await mainContextCompleter.future;
              await homeContextCompleter.future;
              BuildContext context = homeContext!;
              var pref = await SharedPreferences.getInstance();
              var login = pref.getBool(isUserLoggedInPreferenceKey) ?? false;
              if (login == true) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyPhotosRoute(
                              eventCode: data['photomall_event_code'],
                            )));
                return;
              } else {
                ReDirectionPreference reDirectionPreference =
                    ReDirectionPreference();
                await reDirectionPreference.setReDirectionDetails(
                    RedirectionModel(
                        redirection: Redirection(
                            route: RedirectionRouteConstant.MyPhotosRoute,
                            arguments: [
                      '${data['photomall_event_code']}',
                      'myPhotos'
                    ])));
                SideDrawerModel drawerModel =
                    Provider.of<SideDrawerModel>(context, listen: false);

                drawerModel.setDrawerChild(
                    LoginRoute(true),
                    S.of(context).login,
                    SideDrawerConstants.GuestLogin,
                    BottomNavigationConstants.GuestLogin);
                return;
              }
            }
          }
          /*showLog(
              'NotificationUtils().navigate${notificationAppLaunchDetails.notificationResponse!.payload!}');
          NotificationUtils().navigate(
              notificationAppLaunchDetails.notificationResponse!.payload!,
              context);*/
        }
      });
    });
  }

  Future<void> getDefaultLanguage([Locale? newLocale]) async {
    var prefs = await SharedPreferences.getInstance();
    var languageSymbol = prefs.getString(languageSymbolPreferenceKey);
    if (languageSymbol == null || languageSymbol == '') {
      languageSymbol = 'en';
    }

    setState(() {
      S.load(Locale(languageSymbol!));
    });
  }

  void setDefaultLanguage([Locale? newLocale]) {
    showLog("new local : $newLocale");
    setState(() {
      locale = newLocale ?? Locale('en_', '');
      showLog("Language locale : $locale");
    });
  }

  //need to remove comment
  //static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  //need to remove comment

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: ApiHelper()),
        //Provider.value(value: PhotomallApis()),
        Provider.value(value: true),
        ChangeNotifierProvider(create: (context) => SideDrawerModel()),
        ChangeNotifierProvider(create: (context) => CustomThemeProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => BookMeProvider()),
        ChangeNotifierProvider(create: (context) => GalleryRouteViewModel()),
      ],
      child: Consumer<CustomThemeProvider>(builder: (context, model, widget) {
        return GetMaterialApp(
          //locale: locale,
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          navigatorKey: navigatorKey2,
          scaffoldMessengerKey: snackbarKey,
          key: navigatorKey,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            S.delegate,
          ],
          supportedLocales: [
            Locale('en', 'US'),
            Locale('bn', 'BD'),
            Locale('fr', 'FR'),
            Locale('gu', 'IN'),
            Locale('hi', 'IN'),
            Locale('kn', 'IN'),
            Locale('ml', 'IN'),
            Locale('mr', 'IN'),
            Locale('ms', 'MY'),
            Locale('ta', 'IN'),
            Locale('te', 'IN'),
          ],
          debugShowCheckedModeBanner: false,
          title: title!,
          theme: ThemeData(
            fontFamily: 'ProductSans',
            textTheme: getTextTheme().apply(
              fontFamily: 'ProductSans',
            ),
          ),
          initialRoute: RoutePaths.SplashScreen,
          onGenerateRoute: CustomRouter.generateRoute,
        );
      }),
    );
  }

  /// Studio theme can be set here color and font properties can be override here
  TextTheme getTextTheme() {
    showLog(
        'the data where design where ${designData?.sideDrawer?.backgroundBegin}');
    if (designData == null) {
      showLog('the If part of design ${designData}');

      return TextTheme(
        bodyLarge: Theme.of(context).textTheme.bodyLarge,
        headlineSmall: Theme.of(context).textTheme.headlineSmall,
        titleLarge: Theme.of(context).textTheme.titleLarge,
        titleMedium: Theme.of(context).textTheme.titleMedium,
        labelLarge: Theme.of(context).textTheme.labelLarge,
        labelMedium: Theme.of(context).textTheme.labelMedium,
        bodyMedium: Theme.of(context).textTheme.bodyMedium,
        bodySmall: Theme.of(context).textTheme.bodySmall,
      );
    } else {
      return TextTheme(
        bodyLarge: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.normal,
            color: Color(
                getColor(designData!.textProperties!.bodyLargeTextColor!))),
        headlineSmall: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: Color(
                getColor(designData!.textProperties!.headLineSmallTextColor!))),
        titleLarge: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Color(
                getColor(designData!.textProperties!.titleLargeTextColor!))),
        titleMedium: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Color(
                getColor(designData!.textProperties!.titleMediumTextColor!))),
        labelLarge: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: Color(int.parse(
                '0xff${designData!.textProperties!.labelLargeTextColor}'))),
        labelMedium: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: Color(
                getColor(designData!.textProperties!.labelMediumTextColor!))),
        bodyMedium: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Color(
                getColor(designData!.textProperties!.bodyMediumTextColor!))),
        bodySmall: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Color(
                getColor(designData!.textProperties!.bodySmallTextColor!))),
        /*  button: Theme.of(context).textTheme.button.copyWith(
                color: Color(int.parse(
                    '0xffFF0000'))),*/
      );
    }
  }

  String getFont() {
    if (designData == null) {
      showLog('designData == null Roboto');
      return 'Roboto';
    } else {
      // showLog('designData != null Roboto ${languages?.first.font}');

      return 'ProductSans';
    }
    // return 'ProductSans';
  }

  int getColor(String color) {
    return int.parse('0xff$color');
  }

  checkReceivedIntentLink() async {
    ReDirectionPreference reDirectionPreference = ReDirectionPreference();
    var link = 'https://elite2-studio.yaljo.in/durations/events/zvdam';
    link = link.replaceAll('https://elite2-studio.yaljo.in/durations/', "");
    showLog('the url got where :: $link');
    List<String> list = link.split('/');
    showLog('the url split 1 :: ${list[0]}');
    showLog('the url split 2 :: ${list[1]}');

    if (list.length == 2) {
      if (list[0] == 'events' && list[1].length >= 5) {
        showLog('The redirection route where ${list[1].length}');

        await reDirectionPreference.setReDirectionDetails(RedirectionModel(
            redirection: Redirection(
                arguments: [list[1]],
                route: RedirectionRouteConstant.EventListRoute)));
      }
    }
  }

  void removeUnwantedRowsFromDatabase() async {
    // this code run only once for a user.Handled by preference key DuplicateRemoved
    // get transporter rows
    // save original source data in a array variable
    // foreach add in obtained variable with condition
    //  and delete all rows one by one
    // insert new duplicate removed array to transporter

    if (await PreferenceHelper.getBool(TransportDataKeys.DuplicateRemoved)) {
      showLog("removed duplicate already");
      return;
    } else {
      showLog("removing duplicate ...");
      try {
        List<appDb.TransportDataData> dbTransporterObtained = [];
        transporter.TransporterDao transporterDao =
            transporter.TransporterDao();
        List<appDb.TransportDataData> dbTransporterSource =
            await transporterDao.getTransporter();
        showLog(
            "removing duplicate original length...${dbTransporterSource.length}");

        // return db if already empty

        if (dbTransporterSource.isEmpty) {
          return;
        }
        showLog(
            "Transporter Table begin \n -----------------------------------------");

        for (appDb.TransportDataData transporter in dbTransporterSource) {
          showLog("Code : ${transporter.code} Tag : ${transporter.tag} ");

          if (transporter.tag == TransportDataKeys.studioData ||
                  transporter.tag == TransportDataKeys.userData ||
                  transporter.tag ==
                      TransportDataKeys
                          .designData /*||
              transporter.tag == TransportDataKeys.deviceData*/
              ) {
            var data = dbTransporterObtained.where((element) {
              return (element.tag == transporter.tag);
            });
            if (data.isEmpty) {
              dbTransporterObtained.add(transporter);
            }
            /* if (!(dbTransporterObtained.contains(transporter.tag))) {
              dbTransporterObtained.add(transporter);
            }*/
          } else {
            var data2 = dbTransporterObtained.where((element) {
              return (element.tag == transporter.tag) &&
                  (element.code == transporter.code);
            });
            if (data2.isEmpty) {
              dbTransporterObtained.add(transporter);
            }
            /*   if (!(dbTransporterObtained.contains(transporter.tag)) &&
                !(dbTransporterObtained.contains(transporter.code))) {
              dbTransporterObtained.add(transporter);
            }*/
          }
        }
        showLog(
            "Transporter Table end \n -----------------------------------------");
        showLog(
            "removing duplicate Obtained length...${dbTransporterObtained.length}");
        await transporterDao.removeDuplicateInDb(dbTransporterObtained);
        await PreferenceHelper.setBool(
            TransportDataKeys.DuplicateRemoved, true);
        // update lastUpdated as 0 in photoselections
        PhotoSelectionsDao photoSelectionsDao = PhotoSelectionsDao();
        List<appDb.PhotoSelection> photoSelections =
            await photoSelectionsDao.getPhotoSelections();
        showLog(
            "photo selection lastUpdate length...${photoSelections.length}");
        if (photoSelections.isNotEmpty) {
          photoSelectionsDao.updateLastUpdate(photoSelections);
        }
      } catch (e) {
        showLog("Error in duplicate removal process \n ${e}");
        await PreferenceHelper.setBool(
            TransportDataKeys.DuplicateRemoved, false);
      }
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initReferrerDetails() async {
    // await PreferenceHelper.setString(referer, 'referrerDetailsStringJay');

    bool isReferer = await PreferenceHelper.getBool(referer);
    showLog('referrerDetailsString initialize $isReferer');

    if (isReferer == false) {
      /// ipiCXirLXVXtM
      showLog('referrerDetailsString initialize');

      String? referrerDetailsString;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        showLog('AndroidPlayInstallReferrer initialize');

        ReferrerDetails referrerDetails =
            await AndroidPlayInstallReferrer.installReferrer;
        showLog('AndroidPlayInstallReferrer $referrerDetails');
        referrerDetailsString = referrerDetails.installReferrer;
        showLog('referrerDetailsString ==> $referrerDetailsString');

        if (referrerDetails.installReferrer != null) {}
      } catch (e) {
        referrerDetailsString = null;
        showLog('referrerDetailsString initialize error $e');
        //  referrerDetailsString = 'Failed to get referrer details: $e';
      }

      if (referrerDetailsString != null && referrerDetailsString.isNotEmpty) {
        ReDirectionPreference reDirectionPreference = ReDirectionPreference();
        List<String> requiredData =
            referrerDetailsString.split('ipiCXirLXVXtM');
        requiredData.removeWhere((element) => element.isEmpty);
        if (requiredData.length == 1) {
          if (requiredData[0].isNotEmpty && requiredData[0].length == 5) {
            await reDirectionPreference.setReDirectionDetails(RedirectionModel(
                redirection: Redirection(
                    arguments: [requiredData[0]],
                    route: RedirectionRouteConstant.EventDetailsRoute)));
          }
        }
        if (requiredData.length == 2) {
          if (requiredData[0].isNotEmpty &&
              requiredData[0].length == 5 &&
              requiredData[1].isNotEmpty) {
            // LoginRoute
            await reDirectionPreference.setReDirectionDetails(RedirectionModel(
                redirection: Redirection(
                    arguments: [requiredData[1]],
                    route: RedirectionRouteConstant.LoginRoute)));
          }
        }
      }
    }
  }

  Future<void> checkForRedirection1() async {
    showLog('checkForRedirection1');
    ReDirectionPreference reDirectionPreference = ReDirectionPreference();
    RedirectionModel? redirection =
        await reDirectionPreference.getRedirectionRoute();
    if (redirection != null &&
        redirection.redirection != null &&
        redirection.redirection!.route != null &&
        redirection.redirection!.route != '') {
      showLog('checkForRedirection1 $redirection');

      RedirectionController redirectionController = RedirectionController();
      redirectionController.executeRedirection(context, redirection,
          isFromMainPage: true);
      return;
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
