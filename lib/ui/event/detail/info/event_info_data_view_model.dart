import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:photomall_flutter/controllers/PhotomallController/photomall_studio_data_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/image_ids_model.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/dao/file_dao.dart';
import 'package:photomall_flutter/traits/utils/network_util.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';
import 'package:photomall_flutter/ui/base/base_model.dart';
import 'package:photomall_flutter/ui/event/photos/custom_photo_view.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../driftdb/app_db.dart' as appDb;

class EventInfoDataViewModel extends BaseModel {
  ApiHelper? apiHandler;
  BuildContext? context;
  String privateStoragePath = "";
  String publicStoragePath = "";
  String? documentDirectory;
  String eventName = "";
  String eventCode = "";
  String? studioCode = "";
  Map connectivity = {ConnectivityResult.none: false};

  EventInfoDataViewModel({this.apiHandler, this.context});

  bool isDemoEvent = false;

  List<File> downloadedImageFile = [];
  List<ImageId> idList = [];
  List<int> downloadedImageId = [];

  bool isOwenEvent = false;

  // Stream<appDb.JvtFile>
  var imageSize = 0.0;
  FileModelDao fileModelDao = FileModelDao();

  //new method to implement
  getInvitationDetailsFromDb(String eventCode) async {
    showLog(' the event code where 11 $eventCode');
    setBusy(true);
    checkEventIsDemoAndOwnEvent(eventCode);
    checkConnectivity();
    getStoragePaths();
    //  getEventInvitationImage(eventCode);
    setBusy(false);
    // get invitation cover images
  }

  Future<void> getStoragePaths() async {
    if (studioPublicPath != null &&
        appDocumentDirectoryPath != null &&
        studioPrivatePath != null) {
      publicStoragePath = studioPublicPath!;
      documentDirectory = appDocumentDirectoryPath;
      privateStoragePath = studioPrivatePath!;
    } else {
      EssentialUtils essentialUtils = EssentialUtils();
      essentialUtils.loadAppEssentialData();
      publicStoragePath = studioPublicPath!;
      documentDirectory = appDocumentDirectoryPath;
      privateStoragePath = studioPrivatePath!;
    }
  }

  Future<void> sharePhotomallEvent() async {
    try {
      PhotomallStudioDataController photomallStudioDataController =
          PhotomallStudioDataController();
      StudioDataGetModel? studioDataGetModel =
          await photomallStudioDataController.getStudioRow(studioCode!);
      String? ShortUrl = studioDataGetModel?.studioData?.data?.shortUrl;
      String? ptmlDomain = studioDataGetModel?.studioData?.data?.ptmlDomain;
      await Share.share(
        "${await studioDataController.getStudioName()} has shared $eventName with you. Click the link "
        "$ptmlDomain/$ShortUrl/$eventCode to view",
      );
    } catch (e) {
      showLog("Error : while share $e");
    }
  }

  Future<bool?> getMobileDataStatus() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
    return null;
  }

  void checkConnectivity() {
    final MyConnectivity _connectivity = MyConnectivity.instance;
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      connectivity = source;
      setBusy(false);
    });
  }

  Future<void> checkEventIsDemoAndOwnEvent(String eventCode) async {
    EventModelDao eventModelDao = EventModelDao();
    appDb.Event? event = await eventModelDao.getEventByCode(eventCode);
    eventName = event?.name ?? "";
    studioCode = event?.studioCode;

    isOwenEvent = (event!.ownedByUser) == true ? true : false;
    if (event.type == demoEvent) {
      isDemoEvent = true;
    }
  }
//previous working method
}

class ImagesModel {
  ImagesModel( {this.file,});
  final appDb.JvtFile? file;
}
