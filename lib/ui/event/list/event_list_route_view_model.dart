import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/PhotomallController/photomall_studio_data_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/image_ids_model.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/driftdb/dao/event_dao.dart' as eventModel;
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/dao/file_dao.dart' as fileModel;
import 'package:photomall_flutter/driftdb/dao/jvt_file_connector_dao.dart'
    as jvtFileConnectorModel;
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';
import 'package:photomall_flutter/traits/image_processor.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';
import 'package:photomall_flutter/ui/base/base_observer.dart';
import '../../../core/Utils/preference_helper.dart';
import '../../../driftdb/app_db.dart' as appDb;

class EventListRouteViewModel extends BaseObserver {
  BuildContext? context;
  ApiHelper? apiHandler;

  List<File> downloadedImageFile = [];
  List<int> eventIds = [];
  List<ImageId> idList = [];
  List<int> downloadedImageId = [];
  ImageProcessor imageProcessor = ImageProcessor();

  // used variables **************************
  bool isLoading = false;
  var documentDirectory;
  String? publicStoragePath;
  String? privateStoragePath;
  Stream<List<Demo?>?>? demoEventStream;
  Stream<List<Demo?>?>? userEventStream;
  Stream<List<Demo?>?>? archivedEventStream;

//  List<Demo> demoEvent = [];
//  List<Demo> userEvent = [];
//  List<Demo> archivedEvent = [];
  ValueNotifier<List<Demo?>> demoEvent = ValueNotifier<List<Demo>>([]);
  ValueNotifier<List<Demo?>> userEvents = ValueNotifier<List<Demo>>([]);
  ValueNotifier<List<Demo?>> archivedEvent = ValueNotifier<List<Demo>>([]);
  PhotomallApis? apiRepo;
  var eventIdList; //value send to server
  var lastUpdatedAt;

  /*EventListViewType eventListViewType;*/

  jvtFileConnectorModel.JvtFileConnectorModelDao jvtFileConnectorModelDao =
      jvtFileConnectorModel.JvtFileConnectorModelDao();
  eventModel.EventModelDao eventModelDao = eventModel.EventModelDao();
  fileModel.FileModelDao fileModelDao = fileModel.FileModelDao();
  bool showList = false;
  List<DemoModel> demoEventCovers = [];
  List<UserModel> userEventCovers = [];
  ConnectivityResult connectivity = ConnectivityResult.none;
  double borderRadius = 10.0;
  String studioCode = "";

  EventListRouteViewModel({
    this.apiHandler,
    this.context,
    /*this.eventListViewType*/
  }) {
    apiRepo = PhotomallApis(this.context);
  }

  //get event from db
/*  Future<GetEventFromDb> getEventListFromDb() async {
    bool isDemoEventAvailable = await _eventDao.isDemoEventAvailable();
    return await _eventDao.getEventsFromDb(isDemoEventAvailable,
        eventListViewType: eventListViewType);
  }*/

  getView() async {
    String? isSharpEdge = await PreferenceHelper.getString(isSharpEdges);
    showLog('getView event list $isSharpEdge');

    if (isSharpEdge == '0') {
      showLog('isSharpEdge1 event list  $isSharpEdge');
      borderRadius = 0.0;
    } else {
      showLog('isSharpEdge2 event list  $isSharpEdge');

      borderRadius = 10.0;
    }
  }

  //new method
  Future<bool> isPageVisible() async {
    EventModelDao eventModelDao = EventModelDao();
    //GET DEMO AND USER EVENT PUBLISHED
    appDb.Event? event = await eventModelDao.getEventVisibility();
    if (event != null) {
      showList = true;
    } else {
      showList = false;
    }
    return showList;
  }

  //init method to get data
  getEventsDetailsFromDb() async {
    try {
      isLoading = true;
      setBusy(false);
      //  await getAlbumTemporaryUrls();
      isLoading = false;
      setBusy(false);

      demoEvent.addListener(() {
        setBusy(false);
      });
      userEvents.addListener(() {
        setBusy(false);
      });
      archivedEvent.addListener(() {
        setBusy(false);
      });

      await getStoragePaths();
      getEventList();
      // listenMethod();
      listenMethod2();
      await getView();
    } catch (e) {
      showLog('The problem in event list route $e');
      isLoading = false;
      setBusy(false);
    }
    isLoading = false;
  }

  Future<StudioDataGetModel?> getStudioDetails(
      String? _studioCode, String eventCode) async {
    showLog("the event code where pretend : $eventCode");
    studioCode = _studioCode!;
    PhotomallStudioDataController photomallStudioDataController =
        PhotomallStudioDataController();
    StudioDataGetModel? studioDataGetModel =
        await photomallStudioDataController.getStudioRow(studioCode);
    showLog("the studio data1 ${studioDataGetModel?.studioName}");
    return studioDataGetModel;
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

  @override
  void onInternetConnectionBack() async {}

  //Stream<List<Demo>> getStreamDemo() => eventModelDao.getStreamDemoEvent();

  /* Stream<List<Demo>> getStreamDemo2() =>
      eventModelDao.getStreamDemoEvent2();

  Stream<List<Demo>> getStreamUserEvent() =>
      eventModelDao.getStreamUSerEvent();

  Stream<List<Demo>> getStreamArchivedEvent() =>
      eventModelDao.getStreamArchivedEvent();*/
  void getEventList() {
    showLog('the event list updating ...');
    demoEventStream = eventModelDao.getStreamDemoEvent2();
    userEventStream = eventModelDao.getStreamUSerEvent();
    archivedEventStream = eventModelDao.getStreamArchivedEvent();
  }

/*  void listenMethod() {
    if (demoEventStream != null && demoEvent != null) {
      demoEventStream.listen((demo) {
        for (int i = 0; i < demo.length; i++) {
          if (demoEvent.length == demo.length) {
            if ((demoEvent[i].event.toJsonString() !=
                    demo[i].event.toJsonString()) ||
                (demoEvent[i].fileConnector.toJsonString() !=
                    demo[i].fileConnector.toJsonString()) ||
                (demoEvent[i].file.toJsonString() !=
                    demo[i].file.toJsonString())) {
              demoEvent = demo;
              setBusy(false);
            } else {
              if (_counterDemo.value == 1) {
                demoEvent = demo;
                setBusy(false);
              }
            }
          }
        }
        demoEvent = demo;
        _counterDemo.value++;
      });
    }

      userEventStream.listen((user) {
        if (userEventStream != null && userEvent != null){
          for (int i = 0; i < user.length; i++) {
            if (userEvent.length == user.length) {
              if ((userEvent[i].event.toJsonString() !=
                      user[i].event.toJsonString()) ||
                  (userEvent[i].fileConnector.toJsonString() !=
                      user[i].fileConnector.toJsonString()) ||
                  (userEvent[i].file.toJsonString() !=
                      user[i].file.toJsonString())) {
                userEvent = user;
                setBusy(false);
              } else {
                if (_counterUser.value == 1) {
                  userEvent = user;
                  setBusy(false);
                }
              }
            }
          }
          userEvent = user;
          _counterUser.value++;
        }
      });

    if (archivedEventStream != null && archivedEvent != null) {
      archivedEventStream.listen((archived) {
        for (int i = 0; i < archived.length; i++) {
          if (archivedEvent.length == archived.length) {
            if ((archivedEvent[i].event.toJsonString() !=
                    archived[i].event.toJsonString()) ||
                (archivedEvent[i].fileConnector.toJsonString() !=
                    archived[i].fileConnector.toJsonString()) ||
                (archivedEvent[i].file.toJsonString() !=
                    archived[i].file.toJsonString())) {
              archivedEvent = archived;
              setBusy(false);
            } else {
              if (_counterArchived.value == 1) {
                archivedEvent = archived;
                setBusy(false);
              }
            }
          }
        }
        archivedEvent = archived;
        _counterArchived.value++;
      });
    }
  }*/

  void checkConnectivity() {
/*    final MyConnectivity _connectivity = MyConnectivity.instance;
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
        connectivity = source;
        setBusy(false);
    });
  */
  }

  void listenMethod2() {
    demoEventStream!.listen((List<Demo?>? event) {
      if (event != null && event.isNotEmpty) {
        if (event.length == 0) {
          demoEvent.value = [];
        }
        if (event.length != demoEvent.value.length) {
          demoEvent.value = event;
          //      setBusy(false);
        } else {
          // length are equal
          // check those data are changed or same as before
          for (int i = 0; i < event.length; i++) {
            if (event[i]!.event!.toJsonString() !=
                demoEvent.value[i]!.event!.toJsonString()) {
              demoEvent.value = event;
            }
            if (event[i]!.file!.toJsonString() !=
                demoEvent.value[i]!.file!.toJsonString()) {
              demoEvent.value = event;
            }
          }
        }
      }
    });
    userEventStream!.listen((List<Demo?>? event) {
      if (event != null && event.isNotEmpty) {
        if (event.length == 0) {
          userEvents.value = [];
        }
        if (event.length != userEvents.value.length) {
          userEvents.value = event;
          setBusy(false);
        } else {
          // length are equal
          // check those data are changed or same as before
          for (int i = 0; i < event.length; i++) {
            if (event[i]!.event!.toJsonString() !=
                userEvents.value[i]!.event!.toJsonString()) {
              userEvents.value = event;
            } else {}
            if (event[i]!.file!.toJsonString() !=
                userEvents.value[i]!.file!.toJsonString()) {
              userEvents.value = event;
            } else {}
          }
        }
      }
    });
    archivedEventStream!.listen((event) {
      if (event != null && event.isNotEmpty) {
        if (event.length == 0) {
          archivedEvent.value = [];
        }
        if (event.length != archivedEvent.value.length) {
          archivedEvent.value = event;
          setBusy(false);
        } else {
          // length are equal
          // check those data are changed or same as before
          for (int i = 0; i < event.length; i++) {
            if (event[i]!.event!.toJsonString() !=
                archivedEvent.value[i]!.event!.toJsonString()) {
              archivedEvent.value = event;
            }
            if (event[i]!.file!.toJsonString() !=
                archivedEvent.value[i]!.file!.toJsonString()) {
              archivedEvent.value = event;
            }
          }
        }
      }
    });
  }

  getResourcesFromTransporter() async {
    showLog('the event list prepare step 1');
    TransporterDao transporterDao = TransporterDao();
    showLog('the event list prepare step 2');
    List<appDb.TransportDataData> TransporterValues =
        await transporterDao.getEventTransporterWhereEventType(userEvent);
    showLog('the event list prepare step 3');
    if (TransporterValues.isNotEmpty) {
      showLog('the event list prepare step 4');
      for (appDb.TransportDataData TransporterValue in TransporterValues) {
        showLog('the event list prepare step 5');
        if (TransporterValue.data != null &&
            TransporterValue.data!.isNotEmpty) {}
      }

      /// initiate pm job
      /* try {

        Map<String, dynamic> downloadPath;
        if (studioPublicPath != null &&
            appDocumentDirectoryPath != null &&
            studioPrivatePath != null) {
          downloadPath = {
            'private': studioPrivatePath,
            'public': studioPublicPath,
            'DocumentPath': appDocumentDirectoryPath,
          };
        } else {
          EssentialUtils essentialUtils = EssentialUtils();
          await essentialUtils.loadAppEssentialData();
          downloadPath = {
            'private': studioPrivatePath,
            'public': studioPublicPath,
            'DocumentPath': appDocumentDirectoryPath,
          };
        }
        showLog("the pm job method initiated...");

        checkAndSetPmJob(downloadPath: downloadPath);
      } catch (e) {
        showLog("Failure : flutterCompute initiateFileDownload ${e}");
      }*/
      showLog('the event list prepare step end of data event list');
    }
  }

  getAlbumTemporaryUrls() async {
    showLog('the bulk update starts .. ');
    List<String> albums = [];
    TransporterDao transporterDao = TransporterDao();
    List<appDb.TransportDataData> _transportersAlbums = await transporterDao
        .getTransporterWhereTagAndUpdateRequired(TransportDataKeys.albums);
    for (appDb.TransportDataData album in _transportersAlbums) {
      albums.add(album.code!);
    }

   // await transporterDao.deleteTransporterByTag(
      //  tag: TransportDataKeys.deviceData);
  }
}

class DemoModel {
  String? eventName;
  String? eventCategoryName;
  String? eventCode;
  File? coverImage;

  DemoModel({
    this.eventName,
    this.eventCategoryName,
    this.eventCode,
    this.coverImage,
  });
}

class UserModel {
  String? eventName;
  String? eventCategoryName;
  String? eventCode;
  File? coverImage;
  bool? published;
  bool? downloadStatus;

  UserModel(
      {this.eventName,
      this.eventCategoryName,
      this.eventCode,
      this.coverImage,
      this.published,
      this.downloadStatus});
}

class Demo {
  Demo({
    this.event,
    this.fileConnector,
    this.file,
  });

  final appDb.Event? event;
  final appDb.JvtFile? file;
  final appDb.JvtFileConnector? fileConnector;
}
