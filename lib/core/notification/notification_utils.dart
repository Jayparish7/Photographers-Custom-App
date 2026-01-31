import 'dart:convert';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/deep_link_controller.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/notification/notificationMethods/local_notification_method.dart';
import 'package:photomall_flutter/core/notification/notificationMethods/trigger_api_call_by_notification.dart';
import 'package:photomall_flutter/main.dart';
import 'package:photomall_flutter/media/my_photos_route.dart';
import 'package:photomall_flutter/preference/preference_handler/redirection_preference_handler.dart';
import 'package:photomall_flutter/preference/preference_model/redirection_preference_model.dart';
import 'package:photomall_flutter/preference/redirection_route_constant.dart';
import 'package:photomall_flutter/ui/event/detail/event_details_route.dart';
import 'package:photomall_flutter/ui/login/login_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';
import '../../ui/wishes_screen/wishes_screen_view_route.dart';
import '../constants/shared_preference_constants.dart';
import 'android_notifications_model.dart';

@pragma('vm:entry-point')
Future<void> notificationTap(NotificationResponse notificationResponse) async {
  if (notificationResponse.payload != null &&
      notificationResponse.payload!.isNotEmpty) {
    DeepLinkingController deepLinkingController = DeepLinkingController();
    // List<String> list1 = await deepLinkingController
    // .getAbsoluteLinkData(Uri.parse(notificationResponse.payload!));
    showLog(
        'Notification tap12  {list1.last} .... ${notificationResponse.payload}');
    if (notificationResponse.payload?.split('/').last == 'birthday_payload' ||
        notificationResponse.payload?.split('/').last ==
            'anniversary_payload') {
      await homeContextCompleter.future;
      BuildContext context = homeContext!;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BirthdayWishScreen(
                    userName: '',
                    birthdayWish:
                        notificationResponse.payload?.split('/').last ==
                            'birthday_payload',
                  )));
      return;
    }

    if (notificationResponse.payload?.split('/').first == 'eventsReminder') {
      await homeContextCompleter.future;
      BuildContext context = homeContext!;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventDetailsRoute(
                    arguments: EventDetailsRouteArguments(
                        eventCode:
                            notificationResponse.payload?.split('/').last),
                  )));
      return;
    }
    if (notificationResponse.payload!.contains('input_data')) {
      var data = jsonDecode(notificationResponse.payload!)['input_data'][0];
      if (data['key'] == 'my-photos') {
        await homeContextCompleter.future;
        BuildContext context = homeContext!;
        var pref = await SharedPreferences.getInstance();
        var login = pref.getBool(isUserLoggedInPreferenceKey) ?? false;
        var eventCode = data['photomall_event_code'];
        String? uUCode =
            await PreferenceHelper.getValueForKey(eventCode, unAuthUserKey);
        if (login == true || uUCode != '') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyPhotosRoute(
                        eventCode: data['photomall_event_code'],
                        isFromUnAuth: uUCode != '',
                        personCode: uUCode,
                      )));
          return;
        } else {
          ReDirectionPreference reDirectionPreference = ReDirectionPreference();
          await reDirectionPreference.setReDirectionDetails(RedirectionModel(
              redirection: Redirection(
                  route: RedirectionRouteConstant.MyPhotosRoute,
                  arguments: ['${data['photomall_event_code']}', 'myPhotos'])));
          /*  SideDrawerModel drawerModel =
          Provider.of<SideDrawerModel>(context, listen: false);
         var push = drawerModel.setDrawerChild(
              LoginRoute(true),
              //S.of(context).login,
              'Login',
              SideDrawerConstants.GuestLogin,
              BottomNavigationConstants.GuestLogin);*/
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginRoute(true),
              ));
        }
        return;
      }
    }

    List<String> list = await deepLinkingController
        .getAbsoluteLinkData(Uri.parse(notificationResponse.payload!));
    showLog('getAbsoluteLinkData${notificationResponse.payload!}');
    //deepLinkingController.setDeepLink(null,Uri.parse(notificationResponse.payload!));
    if (list.length == 1) {
      if (list[0] == 'events') {
        return;
      }
      if (Platform.isIOS) {
        showLog(
            'eventDirection ios worked ${notificationResponse.payload?.split('/').last}');
        await homeContextCompleter.future;
        BuildContext context = homeContext!;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventDetailsRoute(
                      arguments: EventDetailsRouteArguments(
                        eventCode:
                            notificationResponse.payload?.split('/').last,
                      ),
                    )));
      }
    }
    if (list.length == 2) {
      if (list[0] == 'events' && list[1].length == 5) {
        showLog(
            'eventDirection worked ${notificationResponse.payload?.split('/').last}');
        await homeContextCompleter.future;
        BuildContext context = homeContext!;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventDetailsRoute(
                      arguments: EventDetailsRouteArguments(eventCode: list[1]),
                    )));

        showLog(" eventDirection worked 3 is ${navigatorKey.currentContext!}");
      }
    }
  }
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  if (notificationResponse.payload != null &&
      notificationResponse.payload!.isNotEmpty) {}
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
  }
}

AndroidNotificationChannel? channel;

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
const String showNotificationsKey = 'ln2v8o7h';
const String hideNotificationsKey = 'cmje5sxz';

ValueNotifier<bool> notificationIndicatorRefreshNotifier = ValueNotifier(false);
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState>? navigatorKey1;
final GlobalKey<NavigatorState> navigatorKey2 = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  //if (notification != null && android != null && !kIsWeb) {
  channel = const AndroidNotificationChannel(
    'app_notifications', // id
    'App notifications', // title
    description: 'This channel is used for get app notifications.',
    // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await _notificationsSettings(flutterLocalNotificationsPlugin!);

  if (message.data['notification_key'] == showNotificationsKey) {
    PreferenceHelper.setBool(isNotificationsAvailablePreferenceKey, true);
    NotificationUtils()
        .getUserNotificationsFromApi(navigatorKey.currentContext!);
  } else if (message.data['notification_key'] == hideNotificationsKey) {
    NotificationUtils().hideNotifications(message);
  }

  await TriggerNotification.triggerNotification(message, isBackGround: true);
}

Future<void> _notificationsSettings(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  /*var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationSubject.add(ReminderNotification(
            id: id, title: title, body: body, payload: payload));
      });*/
  var initializationSettings = const InitializationSettings(
    android: AndroidInitializationSettings('@drawable/notification_icon'),
    iOS: DarwinInitializationSettings(),
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: notificationTap,
    onDidReceiveBackgroundNotificationResponse: notificationTap,
    //    notificationTapBackground,
  );

  /*(String payload) async {
      showLog('notification payload: STEP 1 ');
      await Future.delayed(const Duration(seconds: 1));
      if (payload != null) {
        showLog('notification payload: if ' + payload);
        //ToastUtil.showLongToast(navigatorStateKey.currentContext!, 'notification payload: if ' + payload);
        NotificationUtils().navigate(payload);
      }
    },
  );*/
}

class NotificationUtils {
  int id = 0;

  navigate(String payload, BuildContext context,
      {bool callApiForUpdateSeenStatus = true,
      bool fromNotificationsPage = false}) async {
    var res = payload.split('/').last;
    showLog('navigate res $res');
    if (res == 'birthday_payload' || res == 'anniversary_payload') {
      showLog('navigate if  $res');

      Get.to(() => BirthdayWishScreen(
            userName: '',
            birthdayWish: res == 'birthday_payload',
          ));
      return;
    }

    AndroidNotificationValues values =
        AndroidNotificationValues.fromJson(jsonDecode(payload));
    if (callApiForUpdateSeenStatus) {
      //PhotomallApis(navigatorKey.currentContext, apiHelper: ApiHelper()).callUpdateAndroidNotificationsSeenByUser(navigatorKey.currentContext, values.code);
      PhotomallApis(navigatorKey.currentContext)
          .callUpdateAndroidNotificationsSeenByUser(
              navigatorKey.currentContext!, values.code!);
    }
    if (!fromNotificationsPage) {
      //await NavigationUtil.popUntilHome(navigatorStateKey.currentContext);
      //Navigator.popUntil(context, (route) => route.settings.name == )
      while (Navigator.canPop(navigatorKey.currentContext!)) {
        Navigator.pop(navigatorKey.currentContext!);
      }
      //bottomNavigationChangeStreamController.add(0);
    }
    if (values.values!.redirectionDetail != null) {
      if (values.values!.redirectionDetail!.page == 'purchase_orders') {
        if (values.values!.redirectionDetail!.value != null) {}
      } else if (values.values!.redirectionDetail!.page == 'transactions') {
        if (values.values!.redirectionDetail!.value != null) {}
      } else if (values.values!.redirectionDetail!.page == 'carts') {
        // AppState appState = Provider.of<AppState>(
        //     navigatorKey.currentContext,
        //     listen: false);
        // appState.bottomNavigationCurrentPosition = 2;
        // appState.bottomNavigationLastClicked = 2;
        // NavigationUtil.pop(navigatorKey.currentContext);
        // NavigationUtil.otpScreenToHome(navigatorKey.currentContext);
      } else if (values.values!.redirectionDetail!.page == 'home') {
        while (Navigator.canPop(navigatorKey.currentContext!)) {
          Navigator.pop(navigatorKey.currentContext!);
        }
      }
      //Navigator.push(navigatorStateKey.currentContext!, MaterialPageRoute(builder: (_) => SecondPage()));
    }
  }

  getUserNotificationsFromApi(BuildContext context) {
    //PhotomallApis(navigatorKey.currentContext, apiHelper: ApiHelper())
    PhotomallApis(navigatorKey.currentContext)
        .callGetAndroidNotifications(context)
        .then((value) {
      showLog("unwanted all");
      for (AndroidNotificationValues notificationData
          in value.androidNotifications!) {
        /*showNotification(notificationData.id ?? Random().nextInt(1000),
            notificationData.values.title, notificationData.values.description);*/
        showLog(
            'notificationTest jsonEncode(notificationData.toJson()) :${jsonEncode(notificationData.toJson())}');
        flutterLocalNotificationsPlugin!.show(
          //notification.hashCode + Random().nextInt(1000),
          notificationData.id ?? Random().nextInt(1000),
          notificationData.values!.title,
          notificationData.values!.description,
          NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel!.name,
                channelDescription: channel!.description,
                importance: Importance.high,
              ),
              iOS: DarwinNotificationDetails(

                  //badgeNumber: channel!.,

                  )),
          payload: jsonEncode(notificationData.toJson()),
        );
      }
    });
  }

  hideNotifications(RemoteMessage message) {
    flutterLocalNotificationsPlugin!
        .cancel(int.parse(message.data['seen_notification_id'].toString()));
    if (int.parse(message.data['pending_notifications_count'].toString()) > 0) {
      PreferenceHelper.setBool(isNotificationsAvailablePreferenceKey, true);
    } else {
      PreferenceHelper.setBool(isNotificationsAvailablePreferenceKey, false);
    }
  }

  showNotification(
      int? notificationId, String title, String description, Uint8List? image,
      {String? payload}) async {
    try {
      BigPictureStyleInformation? bigPictureStyleInformation;
      showLog('the push notify step 1');
      /*  var df =
        'https://cdn.pixabay.com/photo/2018/01/21/01/46/architecture-3095716_960_720.jpg';*/
      showLog('the push notify step 2');

      if (image != null) {
        showLog('the push notify step 5');

        bigPictureStyleInformation = BigPictureStyleInformation(
          //FilePathAndroidBitmap(base64Encode(List.from(image.toList()))),
          ByteArrayAndroidBitmap.fromBase64String(base64Encode(image)),
          //DrawableResourceAndroidBitmap("logo_1024_500"),
          largeIcon:
              ByteArrayAndroidBitmap.fromBase64String(base64Encode(image)),
          //largeIcon: FilePathAndroidBitmap(base64Encode(List.from(image.toList()))),
          //largeIcon: DrawableResourceAndroidBitmap("logo_1024_500"),
        );
      }
      showLog('the push notify step 3');

      await flutterLocalNotificationsPlugin?.show(
          notificationId ?? Random().nextInt(1000),
          title,
          description,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel!.id,
              channel!.name,
              channelDescription: channel!.description,
              importance: Importance.high,
              styleInformation: bigPictureStyleInformation,
              largeIcon: const DrawableResourceAndroidBitmap(
                  'notification_large_icon'),
            ),
          ),
          payload: payload);
      showLog('the push notify step 4');
    } catch (e) {
      showLog('Exception in the push notify $e');
    }
  }

  Future<void> showProgressNotification(
      int progressId,
      String title,
      String subTitle,
      int i,
      int maxProgress,
      bool showProgress,
      String eventCode) async {
    LocalNotification localNotification = LocalNotification();
    String playLoad = await localNotification.getPlayLoad(eventCode);
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'progress channel',
      'progress channel',
      channelDescription: 'Downloading Images',
      channelShowBadge: false,
      importance: Importance.max,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: showProgress,
      maxProgress: maxProgress,
      progress: i,
    );
    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin!.show(
      progressId,
      '$title',
      '$subTitle',
      notificationDetails,
      payload: playLoad,
    );
  }

  Future<void> sendNotificationReceivedStatus(String code) async {
    // call notification received api
    PhotomallApis photomallApis = PhotomallApis(null);
    photomallApis.notificationReceivedApiCall(code: code);
  }
}

initNotificationsInMain() async {
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  showLog('notification step 6 d:: ');
  channel = const AndroidNotificationChannel(
    'app_notifications', // id
    'App notifications', // title
    description: 'This channel is used for get app notifications.',
    // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await _notificationsSettings(flutterLocalNotificationsPlugin!);

  // testing /// ****************************************************************
  /* final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin?.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp == true) {
    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.notificationResponse != null &&
        notificationAppLaunchDetails.notificationResponse!.payload != null) {
      if (notificationAppLaunchDetails.notificationResponse!.payload!.contains('input_data')) {
        var data = jsonDecode(notificationAppLaunchDetails.notificationResponse!.payload!)['input_data'][0];
        if (data['key'] == 'my-photos') {
          await mainContextCompleter.future;
          await homeContextCompleter.future;
          BuildContext context = homeContext!;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyPhotosRoute(
                    eventCode: data['photomall_event_code'],
                  )));

        }
      }
      showLog(
          'Payload:${notificationAppLaunchDetails.notificationResponse!.payload}');
      DeepLinkingController deepLinkingController = DeepLinkingController();
      deepLinkingController.setDeepLink(
          null,
          Uri.parse(
              notificationAppLaunchDetails.notificationResponse!.payload!));
    }
  }*/

  // testing /// ***************************************************************
  (Platform.isAndroid)
      ? await flutterLocalNotificationsPlugin!
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel!)
      : await flutterLocalNotificationsPlugin
          ?.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}
