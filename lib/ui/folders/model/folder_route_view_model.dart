import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/backgroundCron/cron_util.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/event_controller.dart';
import 'package:photomall_flutter/controllers/folder_controller.dart';
import 'package:photomall_flutter/controllers/folder_rule_controller.dart';
import 'package:photomall_flutter/controllers/photo_selection_image_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporterModel;
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/common_key_value.dart';
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_dao.dart' as folderDao;
import 'package:photomall_flutter/driftdb/dao/folder_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_rule_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_status_dao.dart';
import 'package:photomall_flutter/driftdb/dao/person_photo_selection_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_images_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_table_dao.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';
import 'package:photomall_flutter/driftdb/dao/without_face_photo_selection_dao.dart';
import 'package:photomall_flutter/traits/common_widgets/common_download_button.dart';
import 'package:photomall_flutter/ui/base/base_observer.dart';
import 'package:photomall_flutter/ui/common_response.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/shared_preference_constants.dart';
import '../../../driftdb/dao/real_person_photo_selection_dao.dart';
import '../../../generated/l10n.dart';

class FolderRouteViewModel extends BaseObserver {
  FolderRouteViewModel({
    this.apiHandler,
    this.context,
  }) {
    apiRepo = PhotomallApis(this.context);
  }

  final ValueNotifier<bool> submitLoad = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isSubmit = ValueNotifier<bool>(false);
  BuildContext? context;
  ApiHelper? apiHandler;
  PhotomallApis? apiRepo;
  bool? isParentFolder;
  bool isLoading = false;
  String? eventCode;
  String? eventName;
  String? folderCode;
  bool isPublished = true;
  bool isDemoEvent = false;
  bool selectByPersonAvailable = false;
  bool selectByCommonImageAvailable = false;
  int ownFolderImageCount = 0;
  PersonPhotoSelectionDao faceModelDao = PersonPhotoSelectionDao();
  List<String> realPersonsPS = [];
  var popAnimation = false.obs;

  /// new
  List<appDb.Folder>? subFolder;
  int rejectedCount = 0;
  int waitingCount = 0;
  ValueNotifier<int>? selectedCount = ValueNotifier<int>(0);
  ValueNotifier<bool> showWarning = ValueNotifier<bool>(true);
  ValueNotifier<int?>? minimumCount = ValueNotifier<int?>(0);

  CommonKeyValueDao commonKeyValueDao = CommonKeyValueDao();
  int? maximumCount = 0;
  appDb.Folder? parentFolderData;
  folderDao.FolderModelDao folderModelDao = folderDao.FolderModelDao();

  // new
  FolderRuleController folderRuleController = FolderRuleController();
  PhotoSelectionsDao photoSelectionsDao = PhotoSelectionsDao();
  Directory? documentDirectoryPath;
  bool hasInternet = false;
  BackgroundTasks backgroundTasks = BackgroundTasks();
  bool _hasInitialized = false;
  String? _initializedEventCode;
  String? _initializedFolderCode;
  DateTime? _lastEssentialCallTime;

  @override
  void onInternetConnectionBack() async {
    showLog('event_list_route :: onInternetConnectionBack :: called');
  }

  folderWidgetInitialMethod(
      {String? routeEventCode,
      String? routeFolderCode,
      required bool routeIsDemoEvent}) async {
    showLog('folderWidgetInitialMethod');
    // Fire-and-forget quick connectivity check; don't block init
    //internetStatus(timeout: Duration(milliseconds: 400));
    // Avoid re-initializing if the same context is already set up
    if (_hasInitialized == true &&
        _initializedEventCode == routeEventCode &&
        _initializedFolderCode == routeFolderCode) {
      showLog('folderWidgetInitialMethod: skip re-init');
      // Run background refresh without blocking UI
      // ignore: unawaited_futures
      callEssentialApis();
      setBusy(false);
      return;
    }

    isLoading = true;
    setBusy(false);
    if (routeEventCode != null) {
      eventCode = routeEventCode;
    }
    if (eventCode != null) {
      listenForPublishStatus();
    }
    isDemoEvent = routeIsDemoEvent;

    await getFolderCode(routeEventCode, routeFolderCode);
    //await getOwnFolderImageCount(folderCode);

    //await flutterCompute(callEssentialApis(),true);
    await callEssentialApis();

    if (eventCode != null) {
      await folderStatusVerification(eventCode);
      //await folderStatusVerify(eventCode);
      EventModelDao eventModelDao = EventModelDao();
      appDb.Event? event = await eventModelDao.getEventByCode(eventCode!);
      eventName = event?.name;
      showLog('getEventByCode ${eventName}');
      List<appDb.PersonsPhotoSelection> person =
          await faceModelDao.getFacesByEvent(eventCode: eventCode!);
      await callFolderStatusApi(eventCode);
      if (person.isNotEmpty && event != null && event.personStatus == true) {
        selectByPersonAvailable = true;
        if (selectByPersonAvailable) {
          WithoutPersonPhotoSelectionDao withoutPersonPhotoSelectionDao =
              WithoutPersonPhotoSelectionDao();
          appDb.WithOutPersonsPhotoSelectionData?
              withOutPersonsPhotoSelectionData =
              await withoutPersonPhotoSelectionDao.getWithoutFacesByCode(
                  eventCode: eventCode!);
          if (withOutPersonsPhotoSelectionData != null) {
            selectByCommonImageAvailable = true;
          }
        }
      }
    }
    await setIgnoreValue();
    appDb.PhotoSelection? photoSelection =
        await photoSelectionsDao.getPhotoSelectionByEventCode(eventCode ?? '');
    showLog('photoSelection ---> $photoSelection');
    if (photoSelection != null) {
      isSubmit.value = photoSelection.confirmationStatus;
    }
    initBackgroundTasks();

    isLoading = false;
    setBusy(false);
    _hasInitialized = true;
    _initializedEventCode = eventCode;
    _initializedFolderCode = folderCode;
    //  } catch (e) {
    //    showLog("something went wrong $e}");
    //    isLoading = false;
    //    setBusy(false);
    //  }
  }

  initBackgroundTasks() {
    if (!isSubmit.value) {
      backgroundTasks.schedulePhotoSelectionReminder(
          eventCode ?? 'JAY', eventName ?? '');
    } else {
      showLog('backgroundTasks-- already submitted  ${isSubmit.value}');
    }
  }

  internetStatus({Duration? timeout}) async {
    try {
      final result = await InternetConnectionChecker.instance.hasConnection
          .timeout(timeout ?? Duration(milliseconds: 500));
      hasInternet = result;
    } catch (e) {
      // Keep previous value if timeout or error
      showLog('internetStatus check skipped (timeout or error)');
    }
    notifyListeners();
    showLog('internetStatus hasInternet $hasInternet');
  }

  getRealPersonCodePS(eventCode) async {
    if (eventCode != null) {
      RealPersonPhotoSelectionDao realPersonPhotoSelectionDao =
          RealPersonPhotoSelectionDao();
      List<appDb.RealPersonsPhotoSelection?> personsCode =
          await realPersonPhotoSelectionDao.getFacesByEvent(
              eventCode: eventCode);
      if (personsCode.isNotEmpty) {
        for (int i = 0; i < personsCode.length; i++) {
          realPersonsPS.add(personsCode[i]!.persons);
        }
        showLog('getRealPersonCodePS ${realPersonsPS}');
      }
    }
  }

  Future<void> getFolderCode(
      String? routeEventCode, String? routeFolderCode) async {
    showLog("the folder code where 1$routeFolderCode");
    showLog("the event code where  1$eventCode");
    if (routeFolderCode == null) {
      isParentFolder = true;
      // where event code equal and parent null
      appDb.Folder? folder =
          await folderModelDao.getFolderByEventAndParentNull(routeEventCode!);
      showLog("the folder code where 2 $folder");

      if (folder != null) {
        folderCode = folder.code;
        showLog("the folder code where 2 $folderCode");
      }
    } else {
      isParentFolder = false;
      folderCode = routeFolderCode;
    }
  }

  Stream<appDb.Folder?>? getStream() {
    if (folderCode != null) {
      folderDao.FolderModelDao folderModelDao = folderDao.FolderModelDao();
      Stream<appDb.Folder?>? folderStream =
          folderModelDao.streamRootFolderWhereFolderCode(folderCode!);
      folderStream.listen((folderData) {
        if (folderData != null) {
          buildViewByFolder(folderData);
        }
      });
      return folderStream;
    }
    return null;
  }

  void buildViewByFolder(appDb.Folder data) async {
    showLog('the folder data after stream function ${data}');
    parentFolderData = data;
    FolderRulesDao folderRulesDao = FolderRulesDao();
    FolderStatus folderStatusDao = FolderStatus();
    appDb.FolderRule? folderRule =
        await folderRulesDao.getFolderRuleByFolderCode(parentFolderData!.code);
    if (folderRule?.minimumSelectionImages != null &&
        folderRule?.maximumSelectionImages != null) {
      minimumCount?.value = folderRule!.minimumSelectionImages;
      maximumCount = folderRule!.maximumSelectionImages;
    }
    if (folderRule?.minimumSelectionImages != null &&
        folderRule?.maximumSelectionImages == null) {
      minimumCount?.value = folderRule!.minimumSelectionImages;
      maximumCount = null;
    }
    if (folderRule?.minimumSelectionImages == null &&
        folderRule?.maximumSelectionImages != null) {
      minimumCount?.value = null;
      maximumCount = folderRule!.maximumSelectionImages;
    }
    if (folderRule?.minimumSelectionImages == null &&
        folderRule?.maximumSelectionImages == null) {
      minimumCount?.value = null;
      maximumCount = null;
    }
    // get parent folder selection status
    appDb.FolderStatuse? folderStatus = await folderStatusDao
        .getFolderStatusByFolderCode(parentFolderData!.code);
    if (folderStatus != null) {
      selectedCount?.value = folderStatus.selected;
      waitingCount = folderStatus.waitingListed;
      rejectedCount = folderStatus.rejected;
    }
    return;
  }

  void listenForPublishStatus() {
    Stream<appDb.PhotoSelection?>? photoSelection =
        photoSelectionsDao.streamPhotoSelectionByEventCode(eventCode!);

    photoSelection!.listen((event) {
      if (event != null) {
        if (!event.published) {
          isPublished = false;
        } else {
          isPublished = true;
        }
      }
    });
  }

  Future<void> getSyncedWithServer() async {
    if (isDemoEvent != true) {
      PhotoSelectionImageController photoSelectionController =
          PhotoSelectionImageController();
      await photoSelectionController.getSyncWithServer();
    }
  }

  Future<void> callPhotoSelectionFolderStatusApi() async {
    PhotoSelectionImageController photoSelectionImageController =
        PhotoSelectionImageController();
    {
      if (eventCode != null) {
        await photoSelectionImageController.updatePhotoSelection(
            eventCode: eventCode!);
      } else {
        FolderModelDao folderModelDao = FolderModelDao();
        appDb.Folder? _folder =
            await folderModelDao.getFolderWhereCode(folderCode!);
        await photoSelectionImageController.updatePhotoSelection(
            eventCode: _folder!.eventCode);
      }
    }
    /*else {
      */ /* EventImageStatusModel photoSelectionImagesResponse = ;*/ /*
      List<PhotoSelectionImage> photoSelectionImages = [];
      showLog('the demo event code where 22 ${eventCode}');
      // get photo selection images where event code
      PhotoSelectionImagesModelDao photoSelectionImagesModelDao =
          PhotoSelectionImagesModelDao();
      List<appDb.PhotoSelectionImage?>? images =
          await photoSelectionImagesModelDao
              .getPhotoSelectionImagesWhereEventCode(eventCode!);
      if (images != null) {
        for (appDb.PhotoSelectionImage? image in images) {
          photoSelectionImages.add(PhotoSelectionImage(
              code: image!.code,
              status: image.status == 0 ? 1 : image.status,
              comment: image.comment,
              rating: image.rating,
              lastUpdatedAt: 1));
        }
      }

      photoSelectionImageController.updatePhotoSelectionImagesByApiResponse(
          false,
          EventImageStatusModel(
              lastUpdatedAt: 1,
              eventCode: eventCode!,
              photoSelectionImages: photoSelectionImages,
              confirmedStatus: 0),
          eventCode!);
    }*/
  }

  Widget downloadButton() {
    EventController eventController = EventController();
    return eventCode == null
        ? SizedBox()
        : ValueListenableBuilder<bool>(
            valueListenable: toggleDownload,
            builder: (BuildContext context, bool value, Widget? child) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: FutureBuilder<bool>(
                    future: commonKeyValueDao.getDownloadStatus(eventCode!),
                    // a previously-obtained Future<String> or null
                    builder: (BuildContext context,
                        AsyncSnapshot<bool> isDownloading) {
                      if (isDownloading.connectionState ==
                              ConnectionState.waiting ||
                          isDownloading.hasError) {
                        return SizedBox();
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isParentFolder != true
                              ? SizedBox()
                              : isDownloading.data == true
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(90),
                                        gradient: LinearGradient(
                                            begin: AppColorData
                                                .buttonGradientBegin,
                                            end: AppColorData.buttonGradientEnd,
                                            colors: AppColorData
                                                .buttonBackgroundColors,
                                            stops: AppColorData
                                                .buttonBackgroundStops),
                                        //gradient: LinearGradient(colors: [Colors.blue,Colors.black])
                                      ),
                                      child: FloatingActionButton.extended(
                                        elevation: 0,
                                        onPressed: () async {},
                                        backgroundColor: Colors.transparent,
                                        tooltip: S.of(context).downloading,
                                        label: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                CircularProgressIndicator(
                                                  color: AppColorData
                                                      .buttonTextColors,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                CommonText(
                                                  text:
                                                      S.of(context).downloading,
                                                  isButton: true,
                                                ),
                                              ],
                                            )),
                                      ),
                                    )
                                  : FutureBuilder<appDb.Event?>(
                                      future: eventController
                                          .getEventByFolderCode(folderCode!),
                                      // a previously-obtained Future<String> or null
                                      builder: (BuildContext context,
                                          AsyncSnapshot<appDb.Event?>
                                              snapshot) {
                                        {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CommonCircularProgress();
                                          }
                                          if (snapshot.hasError) {
                                            return SizedBox();
                                          }
                                          if (!snapshot.hasData ||
                                              // snapshot.hasError ||
                                              !snapshot.data!.downloadable) {
                                            return SizedBox();
                                          }
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                  begin: AppColorData
                                                      .buttonGradientBegin,
                                                  end: AppColorData
                                                      .buttonGradientEnd,
                                                  colors: AppColorData
                                                      .buttonBackgroundColors,
                                                  stops: AppColorData
                                                      .buttonBackgroundStops),
                                              //gradient: LinearGradient(colors: [Colors.blue,Colors.black])
                                            ),
                                            child:
                                                FloatingActionButton.extended(
                                              elevation: 0,
                                              onPressed: () {
                                                showLog(
                                                    'the folder code where ${folderCode}');
                                              },
                                              backgroundColor:
                                                  Colors.transparent,
                                              tooltip: "download",
                                              label: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child:
                                                    CommonFolderDownloadButton(
                                                  onPress: () async {
                                                    toggleDownload.value =
                                                        !toggleDownload.value;
                                                    await setIgnoreValue();
                                                  },
                                                  isDownloading: true,
                                                  folderCode: folderCode,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                          SizedBox(
                            height: 5,
                          ),
                          isParentFolder != true
                              ? SizedBox()
                              : FutureBuilder<bool>(
                                  future: commonKeyValueDao
                                      .getDownloadStatus(eventCode!),
                                  // a previously-obtained Future<String> or null
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> snapshot) {
                                    {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CommonCircularProgress();
                                      }
                                      if (snapshot.hasError) {
                                        return SizedBox();
                                      }
                                      if (!snapshot.hasData ||
                                          snapshot.data == false) {
                                        return SizedBox();
                                      }
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          gradient: LinearGradient(
                                              begin: AppColorData
                                                  .buttonGradientBegin,
                                              end: AppColorData
                                                  .buttonGradientEnd,
                                              colors: AppColorData
                                                  .buttonBackgroundColors,
                                              stops: AppColorData
                                                  .buttonBackgroundStops),
                                          //gradient: LinearGradient(colors: [Colors.blue,Colors.black])
                                        ),
                                        child: FloatingActionButton.extended(
                                          elevation: 0,
                                          onPressed: () async {
                                            showLog(
                                                'the folder code where $eventCode');
                                            await commonKeyValueDao
                                                .deleteCommonTableByEvent(
                                                    eventCode!);
                                            toggleDownload.value =
                                                !toggleDownload.value;
                                          },
                                          backgroundColor: Colors.transparent,
                                          tooltip: "download",
                                          label: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.cancel_outlined,
                                                    size: 35,
                                                    color: AppColorData
                                                        .buttonTextColors,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  CommonText(
                                                    text: "Cancel",
                                                    isButton: true,
                                                  ),
                                                ],
                                              )),
                                        ),
                                      );
                                    }
                                  })
                        ],
                      );
                    }),
              );
            });
  }

  Future<void> submit() async {
    try {
      submitLoad.value = true;
      isSubmit.value = true;

      PhotoSelectionsDao photoSelectionsDao = PhotoSelectionsDao();

      appDb.PhotoSelection? photoSelection =
          await photoSelectionsDao.getPhotoSelectionByEventCode(eventCode!);

      // call api move to album
      await callPhotoSelectionFolderStatusApi();
      await getSyncedWithServer();
      PhotomallApis photomallApis = PhotomallApis(context);
      CommonResponse? response = await photomallApis.submitPhotoSelectionAlbum(
          code: photoSelection!.code, status: 1);
      if (response!.status == true) {
        await photoSelectionsDao.updateSubmittedStatusByEventCode(
            eventCode!, 1);
        backgroundTasks.cancelPhotoSelectionReminder(eventCode ?? '');
        popAnimation.value = true;
      }

      submitLoad.value = false;
    } catch (e) {
      submitLoad.value = false;
      showLog("photo selection yes button pressed :: step6 eee \n $e");
    }
  }

  getOwnFolderImageCount(folderCode) async {
    // ownFolderCount;
    PhotoSelectionImagesModelDao photoSelectionImagesModelDao =
        PhotoSelectionImagesModelDao();
    List<appDb.PhotoSelectionImage>? folderImages =
        await photoSelectionImagesModelDao
            .getPhotoSelectionImagesWhereFolderCode(folderCode);
    if (folderImages!.isNotEmpty) {
      ownFolderImageCount = folderImages.length;
    }
    showLog('The folder own images count where $ownFolderImageCount');
  }

  callEssentialApis() async {
    // Debounce repeated calls within a short interval
    final DateTime now = DateTime.now();
    if (_lastEssentialCallTime != null &&
        now.difference(_lastEssentialCallTime!).inSeconds < 3) {
      showLog('callEssentialApis: debounced');
      return;
    }
    _lastEssentialCallTime = now;

    await getSyncedWithServer();
    if (isParentFolder!) {
      await callPhotoSelectionFolderStatusApi();
    }
  }

  folderStatusVerification(eventCode) async {
    //await callFolderStatusApi(eventCode);
    List<String> eventList = [];
    eventList.add(eventCode);
    final currentDate = new DateTime.now().day.toString();
    showLog('eventList $eventList');
    var prefs = await SharedPreferences.getInstance();
    var lastDay = (prefs.getString('$callFoldersApi') ?? '');
    List<String>? listEvents = prefs.getStringList(eventCodeList) ?? [];
    showLog('prefs lastDay $listEvents');
    if (currentDate != lastDay) {
      await prefs.remove(eventCodeList);
      await prefs.setString(callFoldersApi, '$currentDate');
    }

    if (!listEvents.contains(eventCode)) {
      //showLog('event code is present');
      return;
    } else {
      await prefs.setStringList('$eventCodeList', eventList);
      //showLog('prefs Status else $listEvents');
      await callFolderStatusApi(eventCode);
    }
  }

  folderStatusVerify(eventCode) async {
    var prefs = await SharedPreferences.getInstance();
    var lastDay = prefs.getString('$callFoldersApi') ?? '';
    final currentDate = new DateTime.now().toLocal().toString();
    Map<String, dynamic> selectedTimes = {
      eventCode: currentDate,
    };
    String encodedMap = json.encode(selectedTimes);
    showLog('encode $encodedMap $lastDay');
    prefs.setString(callFoldersApi, encodedMap);
    Map<String, dynamic> decodedMap = json.decode(lastDay) ?? {};
    showLog('decodedMap1 ${decodedMap.values}');
    if (decodedMap.keys == eventCode) {
      showLog('decodedMap2${decodedMap.values}');
    } else {
      showLog('folderVerify');
      await callFolderStatusApi(eventCode);
    }
  }

  callFolderStatusApi(eventCode) async {
    if (isDemoEvent != true) {
      FolderStatus folderStatus = FolderStatus();
      await folderStatus.validateParentFolderStatus(eventCode);

      //showLog('folders api$eventCode');
    }
  }

  Future<void> getFilesFromTransporter(folderCode) async {
    // fill fileConnector from transporter resources
    TransporterDao transporterDao = TransporterDao();
    appDb.Folder? folder = await folderModelDao.getFolderWhereCode(folderCode);
    if (folder != null) {
      appDb.TransportDataData? transporter = await transporterDao
          .getPhotoSelectionResourceByCode(code: folder.eventCode);

      if (transporter != null && transporter.data != null) {
        FolderController folderController = FolderController();
        transporterModel.PhotoSelectionData photoSelectionData =
            transporterModel.PhotoSelectionData.fromJson(
                json.decode(transporter.data!));
        await folderController.fillFolderResources(
            photoSelectionData, folderCode);
      }
    }
  }

  Future<void> setIgnoreValue() async {
    if (eventCode != null) {
      bool status = await commonKeyValueDao.checkAnythingDownloading();
      if (status == true) {
        ignoreValue.value = true;
      } else {
        ignoreValue.value = false;
      }
    }
  }
}

final ValueNotifier<bool> ignoreValue = ValueNotifier<bool>(false);
final ValueNotifier<bool> toggleDownload = ValueNotifier<bool>(false);
