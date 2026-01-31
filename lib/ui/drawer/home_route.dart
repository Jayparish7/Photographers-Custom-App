import 'dart:convert';
import 'package:connectivity_watcher/core/service/zo_connectivity_watcher_service.dart';
import 'package:connectivity_watcher/screens/zo_connectivity_watcher_warpper.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/deep_link_controller.dart';
import 'package:photomall_flutter/controllers/redirection_controller.dart';
import 'package:photomall_flutter/controllers/studio_data_controller.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/constants/studio_config_constants.dart';
import 'package:photomall_flutter/core/notification/notificationMethods/trigger_api_call_by_notification.dart';
import 'package:photomall_flutter/core/notification/notification_utils.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/main.dart';
import 'package:photomall_flutter/media/my_photos_route.dart';
import 'package:photomall_flutter/preference/preference_handler/redirection_preference_handler.dart';
import 'package:photomall_flutter/preference/preference_model/redirection_preference_model.dart';
import 'package:photomall_flutter/preference/redirection_route_constant.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';
import 'package:photomall_flutter/ui/app_side_drawer/side_drawer_constants.dart';
import 'package:photomall_flutter/ui/bottom_navigation/bottom_navigation.dart';
import 'package:photomall_flutter/ui/bottom_navigation/bottom_navigation_constants.dart';
import 'package:photomall_flutter/ui/drawer/side_drawer_model.dart';
import 'package:photomall_flutter/ui/event/detail/event_details_route.dart';
import 'package:photomall_flutter/ui/login/login_route.dart';
import 'package:photomall_flutter/ui/popup/app_update_status_dialog.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_links/app_links.dart';

import '../../controllers/event_ai_data_controller.dart';
import '../../core/constants/route_constants.dart';
import '../../driftdb/dao/event_dao.dart';
import '../event/add/add_event_route.dart';
import '../menu_button.dart';
import '../routes/Tutorial_route.dart';
import '../shared_widgets/common_text.dart';

ApiHelper? apiHandler;

class HomeRoute extends StatefulWidget {
  @override
  HomeRouteState createState() {
    return HomeRouteState();
  }
}

class HomeRouteState extends State<HomeRoute> {
  int lastBottomIndex = 0;
  String studioName = '';
  StudioDataController studioDataController = StudioDataController();
  final ValueNotifier<bool> isConnected = ValueNotifier<bool>(false);
  bool isPartyApp = false;
  bool isGalleryAvailable = false;
  String shortcut = 'no action set';
  final appLinks = AppLinks();
  Future<void> getInitialDeepLink() async {
    DeepLinkingController deepLinkingController = DeepLinkingController();
    final link = await appLinks.getInitialLink();
    showLog('$link getInitialDeepLink ');
    if (link != null) {

      showLog('getInitialDeepLink $link');

      await deepLinkingController.setDeepLink(context, link);
      checkForRedirection1();
    }
    appLinks.uriLinkStream.listen((Uri? uri) async {
      showLog('$uri getInitialDeepLink uri ');

      if (uri != null) {
        /*http.Response response = await http.get(
            Uri.parse(image));
        NotificationUtils notificationUtils = NotificationUtils();
        await notificationUtils.showNotification(null, uri.toString() ,uri.toString(), response.bodyBytes);*/
        await deepLinkingController.setDeepLink(context, uri);
        checkForRedirection1();
      }
    }, onError: (err) {});
  }

  initialNotification() async {
    EventAiDataController aiDataController = EventAiDataController();
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin
            ?.getNotificationAppLaunchDetails();
    showLog(
        'initialNotification ${notificationAppLaunchDetails?.notificationResponse}');

    if (notificationAppLaunchDetails?.didNotificationLaunchApp == true) {
      if (notificationAppLaunchDetails != null &&
          notificationAppLaunchDetails.notificationResponse != null &&
          notificationAppLaunchDetails.notificationResponse!.payload != null) {
        if (notificationAppLaunchDetails.notificationResponse!.payload!
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
                redirectionConstantFrom: "home route :132",
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

        showLog(
            'payLoad:${notificationAppLaunchDetails.notificationResponse!.payload}');
        DeepLinkingController deepLinkingController = DeepLinkingController();
        deepLinkingController.setDeepLink(
            null,
            Uri.parse(
                notificationAppLaunchDetails.notificationResponse!.payload!));
      }

      DeepLinkingController deepLinkingController = DeepLinkingController();
      List<String> list = await deepLinkingController.getAbsoluteLinkData(
          Uri.parse(
              notificationAppLaunchDetails!.notificationResponse!.payload!));
      //deepLinkingController.setDeepLink(null,Uri.parse(notificationResponse.payload!));
      if (list.length == 1) {
        if (list[0] == 'events') {
          return;
        }
      }
      if (list.length == 2) {
        if (list[0] == 'events' && list[1].length == 5) {
          await homeContextCompleter.future;
          BuildContext context = homeContext!;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventDetailsRoute(
                        arguments: EventDetailsRouteArguments(
                          eventCode: list[1],
                        ),
                      )));

          showLog("3 is ${navigatorKey.currentContext!}");
          return;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initialNotification();
    getInitialDeepLink();
    navigateFromNotificationPayLoad();
    // checkInternetConnectivity();
    // netConnection();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeContext = context;
      if (!homeContextCompleter.isCompleted) {
        homeContextCompleter.complete();
      }
      _showAppUpdate(context);
      checkGalleryEvents();
      getStudioType();
      getGalleryAvailability();
      checkForRedirection();
      checkForRedirection1();
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      Map<String, dynamic> map = message.toMap();
      String encodedMap = json.encode(map);
      showLog('Home route :: initState onMessage :: 1 ${encodedMap}');
      showLog('Home route :: initState onMessage data :: ${message.data}');
      if (message.data['notification_key'] == showNotificationsKey) {
        PreferenceHelper.setBool(isNotificationsAvailablePreferenceKey, true);
        notificationIndicatorRefreshNotifier.value =
            !notificationIndicatorRefreshNotifier.value;
        NotificationUtils().getUserNotificationsFromApi(context);
      } else if (message.data['notification_key'] == hideNotificationsKey) {
        NotificationUtils().hideNotifications(message);
        notificationIndicatorRefreshNotifier.value =
            !notificationIndicatorRefreshNotifier.value;
      }

      TriggerNotification.triggerNotification(message);
    });

    // getDeletedStatus();
    Future.delayed(Duration(microseconds: 200)).then((value) async {
      var prefs = await SharedPreferences.getInstance();
      bool tutorKey = (prefs.getBool("$tutorialKey") ?? false);
      showLog('tutorKey $tutorKey');
      (tutorKey != true)
          ? {
              await prefs.setBool(tutorialKey, true),
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TutorialPage()))
            }
          : null;
    });

    //quickActions
    const QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) async {
      setState(() {
        shortcut = shortcutType;
      });
      if (shortcut == 'action_one') {
        navigatorKey2.currentState?.push(
          MaterialPageRoute(builder: (context) => AddEvent()),
        );
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      // NOTE: This first action icon will only work on iOS.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(
        type: 'action_one',
        localizedTitle: 'Add Event',
        icon: 'notification_large_icon',
      ),
      // NOTE: This second action icon will only work on Android.
      // In a real world project keep the same file name for both platforms.
      /* const ShortcutItem(
          type: 'action_two',
          localizedTitle: 'Action two',
          icon: 'ic_launcher'),*/
    ]).then((void _) {
      showLog('message from quick actions::::----> $shortcut');
      setState(() {
        if (shortcut == 'no action set') {
          shortcut = 'actions ready';
        }
      });
    });
  }

  navigateFromNotificationPayLoad() {
    flutterLocalNotificationsPlugin!
        .getNotificationAppLaunchDetails()
        .then((NotificationAppLaunchDetails? notificationAppLaunchDetails) {
      Future.delayed(const Duration(seconds: 0)).then((value) async {});
      showLog('navigateFromNotificationPayLoad');
      if (notificationAppLaunchDetails?.notificationResponse != null &&
          notificationAppLaunchDetails?.notificationResponse?.payload !=
              null) {
        showLog(
            'NotificationUtils().navigate${notificationAppLaunchDetails?.notificationResponse!.payload!}');
        NotificationUtils().navigate(
            notificationAppLaunchDetails!.notificationResponse!.payload!,
            context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigation bottomNavigation = BottomNavigation();
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: SafeArea(
        top: false,
        left: false,
        right: false,
        child: Consumer<SideDrawerModel>(
          builder: (context, model, child) {
            model.getStudioType();
            showLog(
                'menuPosition menuPosition is ${AppColorData.menuPosition}');
            return ZoConnectivityWrapper(
                navigationKey: navigatorKey2,
                connectivityStyle: NoConnectivityStyle.SNACKBAR,
                builder: (context, connectionKey) {
                  return Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: AppColorData.backgroundGradientBegin,
                            end: AppColorData.backgroundGradientEnd,
                            colors: AppColorData.backgroundColors,
                            stops: AppColorData.appBackgroundStops)),
                    child: Scaffold(
                      extendBodyBehindAppBar: true,
                      onDrawerChanged: (a) {
                        //Provider.of<LoginProvider>(context, listen: false).unFocusLogin();
                      },
                      //drawer: InkWell(onTap: () {}, child: AppDrawer()),
                      backgroundColor: Colors.transparent,
                      /*appBar: CommonAppBar(
                      actions: [
                        IconButton(
                          splashRadius: 18,
                          onPressed: () async {
                            await Navigator.pushNamed(context, RoutePaths.AddEvent);
                          },
                          icon: Icon(
                            Icons.qr_code_scanner,
                            size: 28,
                            color: AppColorData.appBarIconColor,
                          ),
                        ),
                        MenuButton(),
                      ],
                      isMainPage: true,
                      title: model.bottomNavigationIndex == 0
                          ? appStudioName ?? "null"
                          : model.drawerChildName,
                    ),*/
                      appBar: (model.bottomNavigationIndex == 0 &&
                              !isPhotomallApp)
                          ? (!model.isPartyApp)
                              ? PreferredSize(
                                  preferredSize: Size(150, 85),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 19,
                                      ),
                                      AppBar(
                                        backgroundColor: Colors.transparent,
                                        automaticallyImplyLeading: false,
                                        surfaceTintColor: Colors.transparent,
                                        iconTheme: IconThemeData(
                                            color: AppColorData.bgIconColor),
                                        flexibleSpace: Container(
                                            decoration: BoxDecoration(
                                                /* gradient: LinearGradient(
                                                        begin: AppColorData.appBarGradientBegin,
                                                        end: AppColorData.appBarGradientEnd,
                                                        colors: AppColorData.appBarBackgroundColors),*/
                                                )),
                                        title: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              (AppColorData.menuPosition ==
                                                      true)
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10.0),
                                                      child: MenuButton(),
                                                    )
                                                  : SizedBox(),
                                              UniqueText(
                                                text: appStudioName ?? "",
                                                isBold: false,

                                                //letterSpacing: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        centerTitle: false,
                                        actions: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: IconButton(
                                              splashRadius: 18,
                                              onPressed: () async {
                                                await Navigator.pushNamed(
                                                    context,
                                                    RoutePaths.AddEvent);
                                              },
                                              icon: Icon(
                                                Icons.qr_code_scanner,
                                                size: 28,
                                                color: AppColorData
                                                    .appBarTextColor,
                                              ),
                                            ),
                                          ),
                                          (AppColorData.menuPosition != true)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 18.0),
                                                  child: MenuButton(),
                                                )
                                              : SizedBox(),
                                          // getPopUpMenu(context,widget.eventCode,widget.personCode,widget.folderCode,widget.isWithOutPersonSelection)
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : PreferredSize(
                                  preferredSize: Size(150, 75),
                                  child: SizedBox(
                                    height: 55,
                                  ))
                          : PreferredSize(
                              preferredSize: Size(150, 75),
                              child: SizedBox(
                                height: 55,
                              )),

                      body: DoubleBackToCloseApp(
                        snackBar: const SnackBar(
                          content:
                              Text('Press back again to exit the $appName app'),
                        ),
                        child: Stack(
                          children: [
                            /*   model.bottomNavigationIndex == 0
                              ? Padding(
                            padding: const EdgeInsets.only(top:50,left: 9.0,right: 9),
                            child: Row(mainAxisSize: MainAxisSize.max,
                              children: [
                                UniqueText(text: appStudioName ?? "null"),
                                Spacer(),
                                IconButton(
                                  splashRadius: 18,
                                  onPressed: () async {
                                    await Navigator.pushNamed(context, RoutePaths.AddEvent);
                                  },
                                  icon: Icon(
                                    Icons.qr_code_scanner,
                                    size: 28,
                                    color: AppColorData.appBarBackgroundColors.first,
                                  ),
                                ),
                                MenuButton(),
                              ],
                            ),
                          ):SizedBox(),*/
                            FutureBuilder<bool>(
                                future: bottomNavigation.isLoggedIn(),
                                builder: (ctx, AsyncSnapshot<bool> snapshot) {
                                  if (!snapshot.hasData || snapshot.hasError) {
                                    return CommonCircularProgress();
                                  }
                                  if ((isPartyApp == true)) {
                                    return isGalleryAvailable == true
                                        ? model.partyGalleryDrawerChild
                                        : model.partyDrawerChild;
                                  } else {
                                    return model.drawerChild;
                                  }
                                }),
                          ],
                        ),
                      ),
                      bottomNavigationBar: BottomNavigation(),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  /*_onBottomNavigationTap(int position) async {
    lastBottomIndex = position;
    var pref = await SharedPreferences.getInstance();
    var isUserLogin = pref.getBool('$isUserLoggedIn') ?? false;
    if (isUserLogin) {
      _bottomNavigationTapAfterLogin(position);
    } else {
      _bottomNavigationTapBeforeLogin(position);
    }
  }*/

  /* _bottomNavigationTapBeforeLogin(int position) async {
    SideDrawerModel drawerChild =
        Provider.of<SideDrawerModel>(context, listen: false);
    switch (position) {
      case 0:
        drawerChild.setDrawerChild(GalleryRoute(), "Home", 0);
        break;
      case 1:
        drawerChild.setDrawerChild(EventsListRoute(), "Events", 1);
        break;
      case 2:
        drawerChild.setDrawerChild(
            PhotoSelectionListRoute(), "Photo Selection", 2);
        break;
      case 3:
        drawerChild.setDrawerChild(
            BookMeRoute(
              beforeLogin: false,
            ),
            "Event Booking",
            3);
        break;
      case 4:
        drawerChild.setDrawerChild(LoginRoute(true), "Login", 4);
        break;
    }
  }

  _bottomNavigationTapAfterLogin(int position) async {
    SideDrawerModel drawerChild =
        Provider.of<SideDrawerModel>(context, listen: false);
    switch (position) {
      case 0:
        drawerChild.setDrawerChild(GalleryRoute(), "Home", 0);
        break;
      case 1:
        drawerChild.setDrawerChild(EventsListRoute(), "Events", 1);
        break;
      case 2:
        drawerChild.setDrawerChild(
            PhotoSelectionListRoute(), "Photo Selection", 2);
        break;
      case 3:
        drawerChild.setDrawerChild(
            BookMeRoute(
              beforeLogin: true,
            ),
            "Event Booking",
            3);
        break;
      case 4:
        drawerChild.setDrawerChild(ProfileViewRoute(), "Profile", 4);
        break;
    }
  }*/

  checkGalleryEvents() async {
    EventModelDao eventModelDao = EventModelDao();
    var gallery = await eventModelDao.getAllGalleryEvent();
    showLog('checkGalleryEvents99 ${gallery} ');

    for (int i = 0; i < gallery.length; i++) {
      showLog(
          'checkGalleryEvents99 ${gallery[i].code} ${gallery[i].published}');
      if (gallery[i].published == true) {
        await PreferenceHelper.setBool(galleryKey, true);
      } else {
        await PreferenceHelper.setBool(galleryKey, false);
      }
    }
  }

  getStudioType() async {
    var pref = await SharedPreferences.getInstance();
    var party = pref.getString('$studioTypeKey') ?? '';
    if (party == 'Party') {
      showLog('getStudioType $party');

      isPartyApp = true;
    }
  }

  getGalleryAvailability() async {
    var gallery = await PreferenceHelper.getBool(galleryKey);
    var carousel = await PreferenceHelper.getBool(carouselKey);
    if (gallery == true || carousel == true) {
      showLog('getGalleryAvailability $gallery $carousel');
      isGalleryAvailable = true;
    }
    showLog('getGalleryAvailability $gallery $carousel $isGalleryAvailable');
  }

  /// App update method
  _showAppUpdate(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    int? status = await prefs.getInt(appUpdateStatusKey);
    showLog("the update status where $status");
    if (status == 1) {
      final currentTime = DateTime.now();
      DateTime? resetTime;
      String? time = prefs.getString("time");
      if (time != null) {
        resetTime = DateTime.parse(time);
      }

      if (resetTime != null && !compareDate(currentTime, resetTime)) {
        prefs.setBool("one_time_show", true);
        showLog("one_time_show is  true");
      }
      if (prefs.getBool("one_time_show") == null ||
          prefs.getBool("one_time_show")!) {
        showLog("Once in a day");
        /*showDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) => _appUpdateDialog);*/
        appUpdateStatusDialog(context, S.of(context).update,
            "$appStudioName ${S.of(context).recommendsThatYouUpdateToTheLatestVersion}",
            onPop: () {
          Navigator.pop(context);
        });

        prefs.setBool("one_time_show", false);
        prefs.setString("time", currentTime.toString());
        //splashScreenNavigation();
      }
    }
  }

  bool compareDate(DateTime current, DateTime reset) {
    return current.year == reset.year &&
        current.month == reset.month &&
        current.day == reset.day;
  }

  ///

  Future<String?> preferStudioName() async {
    try {
      if (appStudioName == null) {
        EssentialUtils essentialUtils = EssentialUtils();
        essentialUtils.loadAppEssentialData();
      }
    } catch (e) {
      showLog("Studio name Error:$e");
      return null;
    }
    return null;
  }

  void checkInternetConnectivity() {
    InternetConnectionChecker.instance
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      /*Flushbar(
             // title: (InternetConnectionStatus.connected == status) ? "title" :"Connected",
              duration: (InternetConnectionStatus.connected == status)? Duration(seconds: 4): Duration(minutes: 1),
              message: (InternetConnectionStatus.connected == status) ? "online":"offline" ,
              icon: Icon((InternetConnectionStatus.connected == status)? Icons.done_outline_rounded : Icons.info_outline ,
                size: 28,
                color: Theme.of(context).primaryColor,
              ),
             // leftBarIndicatorColor: Theme.of(context).primaryColor,
              // duration: Duration(seconds: 5),
              flushbarPosition: FlushbarPosition.TOP,
              margin: EdgeInsets.only(top: 50),
            )..show(context);*/
      switch (status) {
        case InternetConnectionStatus.connected:
          isConnected.value = true;
          showLog("main data :: ${isConnected.value} :: $status");
          break;
        case InternetConnectionStatus.disconnected:
          isConnected.value = false;
          /* Flushbar(
              title: title,
              message: message,
              icon: Icon(
                Icons.info_outline,
                size: 28,
                color: Theme.of(context).primaryColor,
              ),
              leftBarIndicatorColor: Theme.of(context).primaryColor,
             // duration: Duration(seconds: 5),
              flushbarPosition: FlushbarPosition.TOP,
              margin: EdgeInsets.only(top: 50),
            )..show(context);*/
          break;
        case InternetConnectionStatus.slow:
          // TODO: Handle this case.
          //throw UnimplementedError();
      }
    });
  }

  Future<void> checkForRedirection() async {
    showLog('Navigating to re-directing  page');
    ReDirectionPreference reDirectionPreference = ReDirectionPreference();
    RedirectionModel? redirection =
        await reDirectionPreference.getRedirectionRoute();

    // debug
    bool isReferer = await PreferenceHelper.getBool(referer);
    if (isReferer == false) {
      await PreferenceHelper.setBool(referer, true);
      if (redirection != null &&
          redirection.redirection != null &&
          redirection.redirection!.route != null &&
          redirection.redirection!.route != '') {
        RedirectionController redirectionController = RedirectionController();
        redirectionController.executeRedirection(context, redirection);
        return;
      }
    }
  }

  Future<void> checkForRedirection1() async {
    bool isReferer = await PreferenceHelper.getBool(referer);
    bool isFromEvent = await PreferenceHelper.getBool(isFromEvents);
    if (isReferer && !isFromEvent) {
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
    } else {
      await PreferenceHelper.setBool(isFromEvents, false);
    }
  }
}
