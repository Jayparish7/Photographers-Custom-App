import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/event_data_controller.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/add_event_model.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/traits/common_widgets/photo_selection_data_controller.dart';
import 'package:photomall_flutter/ui/app_side_drawer/side_drawer_constants.dart';
import 'package:photomall_flutter/ui/base/base_model.dart';
import 'package:photomall_flutter/ui/bottom_navigation/bottom_navigation_constants.dart';
import 'package:photomall_flutter/ui/common_response.dart';
import 'package:photomall_flutter/ui/drawer/side_drawer_model.dart';
import 'package:photomall_flutter/ui/event/list/events_list_route.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../../../controllers/event_ai_data_controller.dart';

class AddEventRouteViewModel extends BaseModel {
  EventModelDao eventModelDao = EventModelDao();
  ApiHelper? apiHandler;
  BuildContext? context;
  bool? loggedIn;
  var eventsDownloadStatus;
  String qrCodeResult = "";
  bool stopStream = false;
  List<File> downloadedImageFile = [];
  PhotomallApis? apiRepo;

  AddEventRouteViewModel({this.apiHandler, this.context}) {
    this.apiRepo = PhotomallApis(this.context);
  }

  //new method to implement
  getDemoEventDetails() async {}

/*  Future scanQr(BuildContext context) async {
    await AddEventHandler(PhotomallApis(context)).scanQr(context);
  }*/
  Future scanQr(BuildContext context, String code) async {
    // await AddEventHandler(PhotomallApis(context)).scanQr(context);
  }

  getAddEventDetails(String eventCode) async {
    setBusy(true);
    ToastContext().init(context!);
    ToastUtil toastUtil = ToastUtil();
    if (eventCode.length == 5) {
      showLog('Add Event step 1');
      SideDrawerModel drawerModel =
          Provider.of<SideDrawerModel>(context!, listen: false);
      TransporterDao transporterDao = TransporterDao();
      appDb.TransportDataData? transportDataData =
          await transporterDao.getTransporterWhereCodeAndTag(
              eventCode, TransportDataKeys.eventData);
      if (transportDataData != null) {
        showLog('Add Event step 2 Get.back()');

        // move to event index route
        setBusy(false);

        drawerModel.setDrawerChild(
            EventsListRoute(
              arguments: EventsListArguments(isArchivedEven: false),
            ),
            S.of(context!).events,
            SideDrawerConstants.CustomerEvents,
            BottomNavigationConstants.CustomerEvents);
        (isPhotomallApp != true) ? Get.back() : null;
      } else {
        showLog('Add Event step 3');

        try {
          List<String> codes = [];

          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
          BaseDeviceInfo androidInfo = (Platform.isAndroid)
              ? await deviceInfo.androidInfo
              : await deviceInfo.iosInfo;
          CommonResponse response = await apiRepo!
              .addEventDetailsApiCall(context!, eventCode, androidInfo);
          if (response.status == true) {
            showLog('Add Event step 4');
            await transporterDao.insertOrUpdateTransporter(
                tag: TransportDataKeys.eventData,
                code: eventCode,
                eventType: userEvent);
            showLog('Add Event step 6');

            // call event data api
            EventDataController eventDataController = EventDataController();
            EventAiDataController eventAiDataController =
                EventAiDataController();
            List<appDb.TransportDataData> transportDataData =
                await transporterDao.getTransporterWhereTagAndUpdateRequired(
                    TransportDataKeys.eventData);
            showLog('Add Event step 7');

            if (transportDataData.isNotEmpty) {
              showLog('Add Event step 8');

              for (appDb.TransportDataData transportData in transportDataData) {
                showLog('Add Event step 9 ${transportData.code}');
                codes.add(transportData.code!);
              }
              showLog('Add Event step 10');

              await eventDataController.getEventData(eventsCode: codes);
            }
            // move to event index route
            await eventDataController.fillEventResources();
            // await eventAiDataController.fillEventResources();
            await eventAiDataController.getEventAiData(eventsCode: codes);
            PhotoSelectionDataController photoSelectionDataController =
                PhotoSelectionDataController();
            await photoSelectionDataController.fillPhotoSelectionResources3();
            setBusy(false);

            drawerModel.setDrawerChild(
                EventsListRoute(
                  arguments: EventsListArguments(isArchivedEven: false),
                ),
                S.of(context!).events,
                SideDrawerConstants.CustomerEvents,
                BottomNavigationConstants.CustomerEvents);
            (isPhotomallApp != true) ? Get.back() : null;
          } else {
            setBusy(false);
            showLog("add event toast:: 5");
            toastUtil.showShortToast(context!, S.of(context!).invalidCode);
          }
        } catch (e, s) {
          setBusy(false);
          showLog("add event toast:: 6");
          toastUtil.showShortToast(context!, S.of(context!).invalidCode);
          showLog("api error on add event book me model :: $s");
        }
      }
    } else {
      setBusy(false);
      showLog("add event toast:: 7");
      toastUtil.showShortToast(context!, S.of(context!).invalidCode);
    }
  }

  insertEventsInDbWhileLogin(UserAndDemoEvent photoMallEventResponse,
      List<String> eventsCheckedList, BuildContext context,
      [popupStatus = false, fromSettingsPage = false]) async {
    showLog("Insert events while login");
    showLog("event checked list $eventsCheckedList}");

    try {
      for (PhotomallEvent photoMallEvent
          in photoMallEventResponse.photomallEvents!) {
        if (eventsCheckedList.contains(photoMallEvent.code)) {
          //showLog('print->>>$i');
          //static add publish status is published, because api response success means published event
          photoMallEvent.publish = PUBLISHED;
        }
      }

      _showUserEventPage(popupStatus, fromSettingsPage);
      popupStatus = false;
    } catch (e) {}
  }

  void _showUserEventPage(popupStatus, fromSettingsPage) {
    showLog("inside events");
    /*  Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeRoute()),
            ModalRoute.withName(RoutePaths.Home));*/
    if (popupStatus == true) {
      Get.back();
      if (fromSettingsPage == false) {
        //if not from setting page need to navigation back second time
        Get.back();
      }
    } else {
      showLog("from popupStatus is false");
      Navigator.of(context!);
    }
    SideDrawerModel drawerChild =
        Provider.of<SideDrawerModel>(context!, listen: false);
    drawerChild.setDrawerChild(
        EventsListRoute(
          arguments: EventsListArguments(),
        ),
        S.of(context!).events,
        SideDrawerConstants.CustomerEvents,
        BottomNavigationConstants.CustomerEvents);
  }

  void cancelTimer(Timer timer) {
    timer.cancel();
    if (timer.isActive) {
      showLog("timer canceling ...");
      cancelTimer(timer);
    } else {
      showLog("timer canceling ...${timer.isActive}");
      return;
    }
  }
}
