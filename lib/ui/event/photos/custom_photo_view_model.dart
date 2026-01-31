import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/album_controller.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/album_dao.dart';
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/dao/print_status_dao.dart';
import 'package:photomall_flutter/ui/base/base_observer.dart';
import 'package:photomall_flutter/ui/event/photos/custom_photo_view.dart';

import '../../../controllers/print_status_controller.dart';
import '../../../core/constants/shared_preference_constants.dart';

class CustomPhotoViewModel extends BaseObserver {
  final CustomPhotoViewArgument arguments;

  CustomPhotoViewModel({
    this.apiHandler,
    this.context,
    required this.arguments,
  }) {
    apiRepo = PhotomallApis(this.context);
  }

  @override
  void onInternetConnectionBack() async {
    showLog('event_list_route :: onInternetConnectionBack :: called');
  }

  bool loading = false;
  bool loadingPrint = false;
  BuildContext? context;
  ApiHelper? apiHandler;
  PhotomallApis? apiRepo;
  int lastSeenIndex = 0;
  PageController controller = PageController();
  bool viewDownloadButton = false;
  bool printStatus = false;
  String print = 'Print request';
  List<String>? printRequestedList = [];
  List<String>? printRequestedSharedList = [];
  String? orderCode = '';

  initialPhotoViewMethod(
    CustomPhotoViewArgument arguments,
  ) async {
    showLog('initialPhotoViewMethod ${arguments.eventCode}');
    await checkUserOwnEvent(arguments.eventCode);
    if (arguments.albumCode != null && arguments.albumCode!.isNotEmpty) {
      loading = true;
      setBusy(false);

      await getResourcesOfThisAlbum(
          arguments.albumCode!, arguments.data!, arguments.eventCode);

      loading = false;
      setBusy(false);
    } else {
      loading = true;
      setBusy(false);

      await getResources(arguments.eventCode);
      await getPrintUsersApi(arguments.eventCode);
      loading = false;
      setBusy(false);
    }
    await checkUserOwnEvent(arguments.eventCode);
  }

/*  getPrintStatus(List<ImagesViewModel?>? data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    printRequestedSharedList = await prefs.getStringList(printRequest);
    for (int i = 0; i < data!.length; i++) {
      if (printRequestedSharedList!.contains(data[i]?.orderCode)) {
        //print = 'requested';
        printStatus = true;
      } else {
        printStatus = false;
      }
    }
    showLog('printRequestedSharedList $printRequestedSharedList');
  }*/

  checkUserOwnEvent(eventCode) async {
    if (eventCode != null) {
      EventModelDao eventModelDao = EventModelDao();
      appDb.Event? event = await eventModelDao.getEventByCode(eventCode);
      showLog(
          'checkUserOwnEvent ${event?.ownedByUser} and have download permission ${event?.ownerDownload}');
      if (event?.ownedByUser == true && event?.ownerDownload == true) {
        viewDownloadButton = true;
      }
      showLog('checkUserOwnEvent download $viewDownloadButton,,, ,,, ');
      return;
    }
  }

  getPrintStatusApi(
      {String? eventCode,
      String? ableCode,
      int? status,
      isFromCancelPrint = false}) async {
    showLog('getPrintStatus $ableCode');
    if (!isPhotomallApp) {
      try {
        setBusy(true);
        loadingPrint = true;
        var res = await apiRepo?.printStoreApi(
            eventCode: arguments.eventCode, ableCode: ableCode, status: status);
        loadingPrint = false;

        if (res != null && res.status == true) {
          (isFromCancelPrint == false)
              ? ToastUtil.showSnackBarAtCurrentState("Print Requested",
                  seconds: 5)
              : ToastUtil.showSnackBarAtCurrentState(" Print Request canceled ",
                  seconds: 5);
          await getPrintUsersApi(arguments.eventCode);
          setBusy(false);
        }
        //
      } catch (e) {
        showLog('error in getPrintStatus $e');
      }
    }
  }

  getPrintUsersApi(String? eventCode) async {
    var res = await PreferenceHelper.getBool(isUserLoggedInPreferenceKey);
    showLog('getPrintUsersApi $res');
    if (!isPhotomallApp && res) {
      try {
        setBusy(true);
        PrintStatusController printStatusController = PrintStatusController();
        var res1 = await apiRepo?.printUsersApi(eventCode: eventCode);
        showLog('print users $res1');
        await printStatusController.upsertPrintStatus(
            PrintStatusData: res1?.data, eventCode: eventCode);
      } catch (e) {
        showLog('error in getPrintUsersApi $e');
      }
    }
  }

  Future<int?> getPrintStatus(String? ableCode) async {
    int? status;
    try {
      setBusy(true);
      PrintStatusDao printStatusDao = PrintStatusDao();

      List<appDb.PrintTableData> res =
          await printStatusDao.getPrintStatusByAbleCode(ableCode: ableCode!);
      showLog('getPrintStatus $res');
      if (res.first.status == 1) {
        showLog('print Requested');
        return status = 1;
      }
    } catch (e) {
      showLog('error in getPrintStatus $e');
    }
    return status;
  }

  Future<void> updateCurrentIndex(String orderCode, String albumCode) async {
    AlbumModelDao albumModelDao = AlbumModelDao();
    await albumModelDao.updateAlbumLastSeenIndexByCode(orderCode, albumCode);
  }

  Future<void> getResourcesOfThisAlbum(
      String albumCode, List<ImagesViewModel?> data, String? eventCode) async {
    showLog("step 1");

    // album data for code
    EventModelDao eventModelDao = EventModelDao();
    AlbumModelDao albumModelDao = AlbumModelDao();
    appDb.Album? album = await albumModelDao.getSingleAlbumWhereCode(albumCode);

    if (album != null && album.lastSeenIndex != null) {
      showLog("step 2");

      lastSeenIndex = data
          .indexWhere((element) => element!.orderCode == album.lastSeenIndex);
      lastSeenIndex = (lastSeenIndex == -1) ? 0 : lastSeenIndex;
      // controller.jumpToPage(lastSeenIndex);
    }
    showLog("step 31q2");
    if (album != null) {
      showLog("step 3");

      appDb.Event? event = await eventModelDao.getEventByCode(album.eventCode);

      if ((event != null && event.isAlbumDownloadable) &&
          (event.isAlbumDownloadable ||
              event.myPhotosDownloadable &&
                  arguments.title != 'Person' &&
                  arguments.title != 'Other photos')) {
        showLog("step 312 ${event.myPhotosDownloadable}");
        viewDownloadButton = true;
      }
      if ((event != null && event.printStatus == true)) {
        showLog("step print er ${event.printStatus}");
        printStatus = true;
      }
    }
  }

  printMessage({status, eventCode, ableCode}) async {
    if (status == 1) {
      ToastUtil.showSnackBarAtCurrentState(
        "Already requested for Print",
        seconds: 10,
        actions: SnackBarAction(
          label: 'cancel print', // or some operation you would like
          onPressed: () async {
            getPrintStatusApi(
                eventCode: eventCode,
                ableCode: ableCode,
                status: 2,
                isFromCancelPrint: true);
          },
        ),
      );
    } else if (status == 5) {
      ToastUtil.showSnackBarAtCurrentState(
        "Already Send for Print",
        seconds: 10,
      );
    } else if (status == 4) {
      ToastUtil.showSnackBarAtCurrentState(
        "print has been rejected",
        seconds: 10,
      );
    }
  }

  getResources(String? eventCode) async {
    showLog("step 4");

    if (eventCode != null) {
      EventModelDao eventModelDao = EventModelDao();
      appDb.Event? event = await eventModelDao.getEventByCode(eventCode);
      showLog("step print${event!.printStatus} 2122 ${arguments.personCode}");

      if ((event.isAlbumDownloadable ||
          (event.myPhotosDownloadable &&
              arguments.title != 'Person' &&
              arguments.title != 'Other photos'))) {
        showLog(
            "step 31q2${event.isAlbumDownloadable} 21${event.myPhotosDownloadable}");
        viewDownloadButton = true;
      }
      if ((event.printStatus == true)) {
        showLog("step print  re ${event.printStatus}");
        printStatus = true;
      }
    }
  }
}
