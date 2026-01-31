import 'dart:async';
import 'package:flutter/material.dart';
import 'package:photomall_flutter/controllers/event_data_controller.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/route_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/main.dart';
import 'package:photomall_flutter/preference/preference_handler/redirection_preference_handler.dart';
import 'package:photomall_flutter/preference/preference_model/redirection_preference_model.dart';
import 'package:photomall_flutter/preference/redirection_route_constant.dart';
import 'package:photomall_flutter/ui/app_side_drawer/side_drawer_constants.dart';
import 'package:photomall_flutter/ui/bottom_navigation/bottom_navigation_constants.dart';
import 'package:photomall_flutter/ui/drawer/side_drawer_model.dart';
import 'package:photomall_flutter/ui/event/booking/book_me_route.dart';
import 'package:photomall_flutter/ui/event/detail/event_details_route.dart';
import 'package:photomall_flutter/ui/event/list/events_list_route.dart';
import 'package:photomall_flutter/ui/gallery/gallery_route.dart';
import 'package:photomall_flutter/ui/login/login_route.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'event_ai_data_controller.dart';

class RedirectionController {
  Future<void> executeRedirection(
      BuildContext context, RedirectionModel redirection,
      {bool? isFromMainPage}) async {
    try {
      if (isFromMainPage == true) {
        await homeContextCompleter.future;
        context = homeContext!;
      }
      ReDirectionPreference().removeRedirection();
      showLog('executeRedirection ${redirection.redirection}');
      SideDrawerModel drawerModel =
          Provider.of<SideDrawerModel>(context, listen: false);
      ReDirectionPreference reDirectionPreference = ReDirectionPreference();
      ToastUtil toastUtil = ToastUtil();
      ToastContext().init(context);
      /*  RedirectionModel redirection =
        await reDirectionPreference.getRedirectionRoute();*/

      var pref = await SharedPreferences.getInstance();
      bool loggedIn = pref.getBool('$isUserLoggedInPreferenceKey') ?? false;
      switch (redirection.redirection!.route) {
        case RedirectionRouteConstant.BookingRoute:
          {
            reDirectionPreference.removeRedirection();
            if (loggedIn == true) {
              drawerModel.setDrawerChild(
                  BookMeRoute(
                    beforeLogin: false,
                  ),
                  S.of(context).eventBooking,
                  SideDrawerConstants.CustomerEventBooking,
                  BottomNavigationConstants.CustomerEventBooking);
            } else {
              drawerModel.setDrawerChild(
                  BookMeRoute(
                    beforeLogin: false,
                  ),
                  S.of(context).eventBooking,
                  SideDrawerConstants.GuestEventBooking,
                  BottomNavigationConstants.GuestEventBooking);

              drawerModel.setDrawerChild(
                  EventsListRoute(
                    arguments: EventsListArguments(isArchivedEven: false),
                  ),
                  S.of(context).events,
                  SideDrawerConstants.GuestEvents,
                  BottomNavigationConstants.GuestEvents);
            }
          }
          break;
        case RedirectionRouteConstant.PackagesListRoute:
          {
            reDirectionPreference.removeRedirection();
            Navigator.pushNamed(context, RoutePaths.StudioPackage);
          }
          break;

        case RedirectionRouteConstant.ContactUs:
          {
            reDirectionPreference.removeRedirection();
            Navigator.pushNamed(context, RoutePaths.ContactUs);
          }
          break;
        case RedirectionRouteConstant.LoginRoute:
          {
            if (loggedIn == true) {
              reDirectionPreference.removeRedirection();
              drawerModel.setDrawerChild(
                  GalleryRoute(),
                  S.of(context).gallery,
                  SideDrawerConstants.CustomerHome,
                  BottomNavigationConstants.CustomerHome);
              ToastUtil toast = ToastUtil();
              ToastContext().init(context);
              toast.showShortToast(context, "Already login");
            } else {
              String number = redirection.redirection!.arguments![0];
              await PreferenceHelper.setString(
                  RedirectionRouteConstant.loginNumber, number);
              reDirectionPreference.removeRedirection();
              drawerModel.setDrawerChild(
                  LoginRoute(true),
                  S.of(context).login,
                  SideDrawerConstants.GuestLogin,
                  BottomNavigationConstants.GuestLogin);
            }
          }
          break;
        case RedirectionRouteConstant.EventDetailsRoute:
          {
            reDirectionPreference.removeRedirection();
            String _eventCode = redirection.redirection!.arguments![0];
            TransporterDao transporterDao = TransporterDao();
            // check for event available in db
            appDb.TransportDataData? transportDataData =
                await transporterDao.getTransporterWhereCode(_eventCode);

            // if null set in transporter and push to event detail
            if (transportDataData == null) {
              await transporterDao.insertOrUpdateTransporter(
                  tag: TransportDataKeys.eventData, code: _eventCode);

              EventDataController eventDataController = EventDataController();
              await eventDataController.prepareAndFillEventData();

              Stream<appDb.TransportDataData?> transporter =
                  transporterDao.streamByEventCode(_eventCode);

              StreamSubscription<appDb.TransportDataData?> stream =
                  transporter.listen((event) {});

              stream.onData((data) async {
                if (data != null) {
                  if (data.updateRequired == 0) {
                    // navigate to event details
                    if (loggedIn == true) {
                      await Navigator.pushNamed(
                          context, RoutePaths.EventDetails,
                          arguments: EventDetailsRouteArguments(
                            eventCode: _eventCode,
                          ));
                    } else {
                      await Navigator.pushNamed(
                          context, RoutePaths.EventDetails,
                          arguments: EventDetailsRouteArguments(
                            eventCode: _eventCode,
                          ));
                    }
                  } else {
                    Future.delayed(const Duration(seconds: 10), () async {
                      // error notification

                      toastUtil.showShortToast(
                          context, S.of(context).eventNotAvailable);
                      drawerModel.setDrawerChild(
                          EventsListRoute(
                            arguments:
                                EventsListArguments(isArchivedEven: false),
                          ),
                          S.of(context).events,
                          // GalleryRoute(),
                          //'${'studio name'}',
                          SideDrawerConstants.CustomerEvents,
                          BottomNavigationConstants.CustomerEvents);
                      stream.cancel();
                    });
                  }
                } else {
                  toastUtil.showShortToast(
                      context, S.of(context).eventNotAvailable);
                  drawerModel.setDrawerChild(
                      EventsListRoute(
                        arguments: EventsListArguments(isArchivedEven: false),
                      ),
                      S.of(context).events,
                      // GalleryRoute(),
                      //'${'studio name'}',
                      SideDrawerConstants.CustomerEvents,
                      BottomNavigationConstants.CustomerEvents);

                  // navigate push to event list route
                  stream.cancel();
                }
              });
            } else {
              //else navigate push to event detailed route
              await Navigator.pushNamed(context, RoutePaths.EventDetails,
                  arguments: EventDetailsRouteArguments(
                    eventCode: _eventCode,
                  ));
            }
          }
          break;
        case RedirectionRouteConstant.EventListRoute:
          {
            if (redirection.redirection!.arguments != null &&
                redirection.redirection!.arguments!.isNotEmpty) {
              TransporterDao transporterDao = TransporterDao();
              transporterDao.insertOrUpdateTransporter(
                  tag: TransportDataKeys.eventData,
                  code: redirection.redirection!.arguments![0],
                  updateRequiredValue: 1,
                  eventType: userEvent);
              List<appDb.TransportDataData> transporters =
                  await transporterDao.getTransporterWhereTagAndUpdateRequired(
                      TransportDataKeys.eventData);
              List<String> events = [];
              EventDataController eventDataController = EventDataController();
              EventAiDataController eventAiDataController =
                  EventAiDataController();
              for (appDb.TransportDataData transporter in transporters) {
                events.add(transporter.code!);
              }
              if (events.isNotEmpty) {
                await eventDataController.getEventData(eventsCode: events);
                await eventAiDataController.getEventAiData(eventsCode: events);
              }
            }
            reDirectionPreference.removeRedirection();
            if (loggedIn == true) {
              EventDataController eventDataController = EventDataController();
              await eventDataController.prepareAndFillEventData();
              drawerModel.setDrawerChild(
                  EventsListRoute(
                    arguments: EventsListArguments(isArchivedEven: false),
                  ),
                  S.of(context).events,
                  SideDrawerConstants.CustomerEvents,
                  BottomNavigationConstants.CustomerEvents);
            } else {
              EventDataController eventDataController = EventDataController();
              await eventDataController.prepareAndFillEventData();
              drawerModel.setDrawerChild(
                  EventsListRoute(
                    arguments: EventsListArguments(isArchivedEven: false),
                  ),
                  S.of(context).events,
                  SideDrawerConstants.GuestEvents,
                  BottomNavigationConstants.GuestEvents);
            }
          }
          break;
        case RedirectionRouteConstant.MyPhotosRoute:
          {
            showLog('RedirectionRouteConstant ');
            reDirectionPreference.removeRedirection();
            if (loggedIn == true) {
              Navigator.pushNamed(context, RoutePaths.MyPhotos,
                  arguments: redirection.redirection!.arguments![0]);
            } else {
              await reDirectionPreference.setReDirectionDetails(
                redirectionConstantFrom: "RedirectionRouteConstant 263",
                  RedirectionModel(
                      redirection: Redirection(
                          arguments: [redirection.redirection!.arguments![0]],
                          route: RedirectionRouteConstant.MyPhotosRoute)));
              drawerModel.setDrawerChild(
                  LoginRoute(true),
                  S.of(context).login,
                  SideDrawerConstants.GuestLogin,
                  BottomNavigationConstants.GuestLogin);
            }
          }
          break;
      }
    } catch (e) {}
  }
}
