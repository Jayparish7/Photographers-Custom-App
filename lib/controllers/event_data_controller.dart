import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/PhotomallController/photomall_studio_data_controller.dart';
import 'package:photomall_flutter/controllers/event_ai_data_controller.dart';
import 'package:photomall_flutter/controllers/event_info_controller.dart';
import 'package:photomall_flutter/controllers/media_controller.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporterModel;
import 'package:photomall_flutter/core/notification/notificationMethods/local_notification_method.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/carousel_properties_dao.dart';
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/dao/file_dao.dart';
import 'package:photomall_flutter/driftdb/dao/jvt_file_connector_dao.dart';
import 'package:photomall_flutter/driftdb/dao/jvt_file_dao.dart';
import 'package:photomall_flutter/driftdb/dao/media_dao.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart'
    as transporter;
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';
import 'package:photomall_flutter/traits/utils/screen_utils.dart';
import 'package:photomall_flutter/ui/app_config_request_model.dart'
    as transporterInputModel;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/shared_preference_constants.dart';
import '../driftdb/dao/album_dao.dart';
import '../driftdb/dao/video_dao.dart';

class EventDataController {
  transporter.TransporterDao transporterDao = transporter.TransporterDao();
  JvtFileConnectorModelDao fileConnectorModelDao = JvtFileConnectorModelDao();
  FileModelDao fileModelDao = FileModelDao();
  CarouselPropertiesDao carouselDao = CarouselPropertiesDao();
  var appConfig = TransporterPreference();
  MediaModelDao mediaModelDao = MediaModelDao();
  EventInfoController eventInfoController = EventInfoController();
  EventAiDataController eventAiDataController = EventAiDataController();

  Future<void> getEventData(
      {required List<String> eventsCode,
      int? eventType,
      bool isFromLogin = false}) async {
    showLog("getEventData isFromLogin $isFromLogin");
    try {} catch (e) {
      showLog("error in getEventData :: $e");
    }
    PhotomallApis apiCall = PhotomallApis(null);
    List<transporterInputModel.Event> apiInputData = [];

    for (String eventCode in eventsCode) {
      appDb.TransportDataData? transportDataData = await transporterDao
          .getSingleTransporterWhereTagUpdateRequiredAndCode(
              TransportDataKeys.eventData, eventCode);
      List<appDb.Album> localMediaNUll =
          await AlbumModelDao().getMultipleAlbumWhereVisibilityNull(eventCode);
      List<appDb.Video> localVideoNUll =
          await VideoModelDao().getVideosWhereVisibilityNull(eventCode);
      showLog(
          "localMediaNUll: $localMediaNUll localVideoNUll: $localVideoNUll");
      if (transportDataData != null) {
        apiInputData.add(transporterInputModel.Event(
            code: eventCode,
            lastUpdatedAt: (isFromLogin == true ||
                    localVideoNUll.isNotEmpty ||
                    localMediaNUll.isNotEmpty)
                ? 0
                : transportDataData.lastUpdatedAt));
      }
    }
    showLog('Add Event step 14');
    var _inputData = [
      transporterInputModel.InputData(
          key: TransportDataKeys.eventData, events: apiInputData)
    ];
    if (_inputData.isNotEmpty) {
      showLog('triggerToFill 7');

      transporterModel.TransportModel? eventDetailsResponse =
          await apiCall.callAppConfiguration(null, inputData: _inputData);
      showLog('triggerToFill 6');
      if (eventDetailsResponse != null &&
          eventDetailsResponse.eventData != null) {
        showLog('triggerToFill 7');

        for (transporterModel.EventData event
            in eventDetailsResponse.eventData!) {
          if (event.updateRequired == 1) {
            await transporterDao.updateEventDataByCodeAndTag(
              lastUpdatedAt: event.lastUpdatedAt!,
              code: event.code!,
              tag: TransportDataKeys.eventData,
              data: jsonEncode(
                event.eventDetailedData,
              ),
            );
            showLog('triggerToFill 8');
          } else {
            await transporterDao.updateRequiredToggleByCodeAndTag(
                0, event.code!, TransportDataKeys.eventData);
          }
        }
      } else {
        // do nothing
        // check last update zero then delete
        //    await transporterDao.deleteTransporterByCode(eventCode);
      }
    }
    return null;
  }

/*  fillEventResourceAtDatabase({
    required String eventCode,
    required transporterModel.EventDetailedData eventDetaildata,
  }) async {
    showLog('the event list prepare step 6');

    if (eventDetaildata != null) {
      showLog('the event list prepare step 7');

      /// insert eventDetaildata in eventDetaildata table
      EventModelDao eventModelDao = EventModelDao();
      showLog('the event list prepare step 8');
      //  if (eventDetaildata.updateRequired != 0) {
      appDb.Event? _localEvent =
          await eventModelDao.getSingleEventByCode(eventDetaildata.code!);

      if (_localEvent != null) {
        showLog('the event list prepare step 9');
        await eventModelDao.insertOrUpdateEventWithCode(
            event: eventDetaildata, isUpdate: true, localEvent: _localEvent);
      } else {
        showLog('the event list prepare step 10');
        await eventModelDao.insertOrUpdateEventWithCode(
            event: eventDetaildata, isUpdate: false);
      }
      showLog('the event list prepare step 11');

      /// Event information
      await eventInfoController.upsertEventInfo(
        eventCode: eventDetaildata.code!,
        eventName: eventDetaildata.categoryName,
        address: eventDetaildata.address,
        duration: eventDetaildata.duration,
        subEvents: eventDetaildata.subevents,
      );
      if (eventDetaildata.medias!.isNotEmpty) {
        MediaController mediaController = MediaController();
        await mediaController.upsertMedia(
          medias: eventDetaildata!.medias!,
          eventCode: eventCode,
          eventType: eventDetaildata.type,
        );
      }

      /// insert fileConnector table
      if (eventDetaildata.jvtFileConnectors!.isNotEmpty) {
        await fileConnectorModelDao.insertJvtFilesConnectors(
          jvtFileConnectors: eventDetaildata.jvtFileConnectors!,
          eventType: ImageType.eventCoverImage,
          ableCode: eventDetaildata.code,
          ableType: TransportDataKeys.events,
        );
      }
    } else {
      showLog('the event list prepare step end of data 2222>');
      return;
    }
  }*/

// splash screen
  fillEventResources() async {
    try {
      List<transporterModel.EventDetailedData> eventDetaildatas = [];
      List<String>? eventCodes = [];
      TransporterDao transporterDao = TransporterDao();
      List<appDb.TransportDataData> transporterValues =
          await transporterDao.getEventTransporter();
      if (transporterValues.isNotEmpty) {
        for (appDb.TransportDataData transporterValue in transporterValues) {
          if (transporterValue.data != null &&
              transporterValue.data!.isNotEmpty) {
            eventDetaildatas.add(transporterModel.EventDetailedData.fromJson(
                json.decode(transporterValue.data!)));
          }
        }
        await insertOrUpdateEventTable(eventDetaildatas);

        for (int i = 0; i < eventDetaildatas.length; i++) {
          eventCodes.add(eventDetaildatas[i].code!);
        }

        /*  await personsController.upsertAlbumPersons(
            eventDetailData: eventDetaildatas);*/

        /* await realPersonsController.upsertAlbumRealPersons(
            eventDetailData: eventDetaildatas);*/

        /*  await withoutFaceController.upsertWithoutFaceAlbum(
            eventDetailData: eventDetaildatas);*/
        await eventInfoController.upsertEventsInformation(
            eventDetaildatas: eventDetaildatas);

        await insertEventFileConnector(eventDetaildatas);

        for (transporterModel.EventDetailedData eventDetaildata
            in eventDetaildatas) {
          showLog("Media upsertEvent code where ${eventDetaildata.code}");
          if (eventDetaildata.medias!.isNotEmpty) {
            showLog("if  ${eventDetaildata.code}");

            MediaController mediaController = MediaController();
            await mediaController.upsertMedia(
              medias: eventDetaildata.medias!,
              eventCode: eventDetaildata.code!,
              eventType: eventDetaildata.type!,
            );
          }
        }
        // flush data and change update required zero
        for (appDb.TransportDataData transporterValue in transporterValues) {
          await transporterDao.flushDataByCodeAndTag(
            code: transporterValue.code!,
            tag: transporterValue.tag!,
          );
        }
      }
    } catch (e, s) {
      showLog("Error : in fill event$e $s");
    }
  }

  Future<void> insertOrUpdateEventTable(
      List<transporterModel.EventDetailedData> eventDetaildatas) async {
    String user = await PreferenceHelper.getString(userId);
    List<appDb.EventsCompanion> eventsCompanions = [];

    List<String> studioCodes = [];

    /// insert eventDetaildata in eventDetaildata table
    EventModelDao eventModelDao = EventModelDao();
    for (transporterModel.EventDetailedData eventDetaildata
        in eventDetaildatas) {
      bool userOwnedEvent = false;
      List<String> _userId = [];
      if (eventDetaildata.aiEmbeddingMethod != null) {
        showLog("aiEmbeddingMethod ${eventDetaildata.aiEmbeddingMethod}");
        Map<String, dynamic> map = {
          eventDetaildata.code ?? "": eventDetaildata.aiEmbeddingMethod
        };
        await PreferenceHelper.saveMapToPrefs(map, aiEmbedKey);
      }
      if (eventDetaildata.corporateEvent != null) {
        showLog("corporateEvent ${eventDetaildata.corporateEvent}");
        Map<String, dynamic> map = {
          eventDetaildata.code ?? "": eventDetaildata.corporateEvent
        };
        await PreferenceHelper.saveMapToPrefs(map, corporateEventKey);
      } if (eventDetaildata.eventPrivateKey != null) {
        showLog("private key ${eventDetaildata.eventPrivateKey}");
        Map<String, dynamic> map = {
          eventDetaildata.code ?? "": eventDetaildata.eventPrivateKey
        };
        await PreferenceHelper.saveMapToPrefs(map, eventPrivatePrefKey);
      }if (eventDetaildata.photoselection != null) {
        showLog("photoselection key ${eventDetaildata.photoselection}");
        Map<String, dynamic> map = {
          eventDetaildata.code ?? "": eventDetaildata.photoselection
        };
        await PreferenceHelper.saveMapToPrefs(map, eventsPhotoselectionPrefKey);
        var res =  await PreferenceHelper.getValueForKey(
            eventDetaildata.code!, eventsPhotoselectionPrefKey);
        showLog("Photoselection $res");

      }
      if (eventDetaildata.clientEvents != null &&
          eventDetaildata.clientEvents!.isNotEmpty) {
        for (int i = 0; i < eventDetaildata.clientEvents!.length; i++) {
          showLog(
              'studio user id ${eventDetaildata.clientEvents?[i].userRandomID ?? ''} ${eventDetaildata.code}');

          _userId.add(eventDetaildata.clientEvents![i].userRandomID ?? '');
        }
        showLog('_userId_userId $_userId .,,,$user');
        if (_userId.contains(user)) {
          userOwnedEvent = true;
          showLog('userOwnedEvent == $userOwnedEvent');
        }
      }
      if (eventDetaildata.waterMarkPosition != null &&
          eventDetaildata.waterMarkOpacity != null &&
          eventDetaildata.waterMarkSize != null) {
        List<String> waterMarkDetails = [];
        showLog(
            'eventDetail data waterMarkPosition ${eventDetaildata.waterMarkPosition}');
        waterMarkDetails.add(eventDetaildata.waterMarkPosition ?? "");
        waterMarkDetails.add(
            (((eventDetaildata.waterMarkOpacity ?? 100) / 100).toString()));
        waterMarkDetails.add(eventDetaildata.waterMarkSize.toString());
        await updateWatermarkDetails(eventDetaildata, eventDetaildata.code!);
      }
      if (eventDetaildata.studioCode != null && isPhotomallApp) {
        studioCodes.add(eventDetaildata.studioCode!);
      }
      appDb.Event? _localEvent =
          await eventModelDao.getSingleEventByCode(eventDetaildata.code!);

      if (_localEvent != null) {
        if (_localEvent.published == false &&
            eventDetaildata.published == 1 &&
            _localEvent.type == userEvent) {
          LocalNotification localNotification = LocalNotification();
          localNotification.notifyEventPublished(
              eventDetaildata.name, eventDetaildata.code!);
        }
        appDb.EventsCompanion eventEntity = appDb.EventsCompanion(
            isAlbumDownloadable: drift.Value(
                eventDetaildata.albumDownloadable == 1 ? true : false),
            myPhotosDownloadable: drift.Value(
                eventDetaildata.myPhotosDownloadable == 1 ? true : false),
            hideMedia:
                drift.Value(eventDetaildata.hideMedia == 1 ? true : false),
            printStatus:
                drift.Value(eventDetaildata.printStatus == 1 ? true : false),
            priorityScore: drift.Value(eventDetaildata.priorityScore),
            code: drift.Value(eventDetaildata.code!),
            published:
                drift.Value(eventDetaildata.published == 1 ? true : false),
            name: drift.Value(eventDetaildata.name!),
            type: drift.Value(eventDetaildata.type!),
            newlyAdded: drift.Value(false),
            loginRequired:
                drift.Value(eventDetaildata.loginRequired == 1 ? true : false),
            categoryName: drift.Value(eventDetaildata.categoryName!),
            archived: drift.Value(_localEvent.archived),
            ownedByUser: drift.Value(userOwnedEvent),
            downloadable:
                drift.Value(eventDetaildata.downloadable == 1 ? true : false),
            withIcon: drift.Value(
                eventDetaildata.downloadWithIcon == 1 ? true : false),
            withWaterMark: drift.Value(
                eventDetaildata.downloadWithWatermark == 1 ? true : false),
            personStatus: drift.Value(
                eventDetaildata.personStatus == true ? true : false),
            studioCode: drift.Value(eventDetaildata.studioCode),
            ownerDownload:
                drift.Value(eventDetaildata.albumDownloadable == 2 ? true : false));
        eventsCompanions.add(eventEntity);
        showLog("eventDetaildata.myPhotosDownloadable $eventsCompanions");
      } else {
        appDb.EventsCompanion eventEntity = appDb.EventsCompanion(
            isAlbumDownloadable: drift.Value(
                eventDetaildata.albumDownloadable == 1 ? true : false),
            myPhotosDownloadable: drift.Value(
                eventDetaildata.myPhotosDownloadable == 1 ? true : false),
            priorityScore: drift.Value(eventDetaildata.priorityScore),
            code: drift.Value(eventDetaildata.code!),
            hideMedia:
                drift.Value(eventDetaildata.hideMedia == 1 ? true : false),
            printStatus:
                drift.Value(eventDetaildata.printStatus == 1 ? true : false),
            published:
                drift.Value(eventDetaildata.published == 1 ? true : false),
            name: drift.Value(eventDetaildata.name!),
            type: drift.Value(eventDetaildata.type!),
            newlyAdded: drift.Value(true),
            loginRequired:
                drift.Value(eventDetaildata.loginRequired == 1 ? true : false),
            categoryName: drift.Value(eventDetaildata.categoryName ?? ""),
            archived: drift.Value(false),
            ownedByUser: drift.Value(userOwnedEvent),
            downloadable:
                drift.Value(eventDetaildata.downloadable == 1 ? true : false),
            withIcon: drift.Value(
                eventDetaildata.downloadWithIcon == 1 ? true : false),
            withWaterMark: drift.Value(
                eventDetaildata.downloadWithWatermark == 1 ? true : false),
            personStatus: drift.Value(
                eventDetaildata.personStatus == true ? true : false),
            studioCode: drift.Value(eventDetaildata.studioCode),
            ownerDownload:
                drift.Value(eventDetaildata.albumDownloadable == 2 ? true : false));

        eventsCompanions.add(eventEntity);
      }
      showLog(
          "eventDetaildata.myPhotosDownloadable1 ${eventDetaildata.code},${eventDetaildata.albumDownloadable}");

      /// insert all event
      if (eventsCompanions.isNotEmpty) {
        await eventModelDao.insertAllEvents(eventsCompanions: eventsCompanions);
      }
      _userId.clear();
    }

    if (studioCodes.isNotEmpty) {
      PhotomallStudioDataController photomallStudioDataController =
          PhotomallStudioDataController();
      await photomallStudioDataController.getStudioData(studioCodes);
    }
  }

  Future<void> updateWatermarkDetails(
      transporterModel.EventDetailedData eventDetaildata,
      String eventCode) async {
    if (eventDetaildata.waterMarkPosition != null &&
        eventDetaildata.waterMarkOpacity != null &&
        eventDetaildata.waterMarkSize != null) {
      // Create a list to hold the new watermark details
      List<String> waterMarkDetails = [
        eventDetaildata.waterMarkPosition ?? "",
        (((eventDetaildata.waterMarkOpacity ?? 100) / 100).toString()),
        eventDetaildata.waterMarkSize.toString()
      ];

      // Access SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Retrieve existing watermark details map (if any)
      String? waterMarkMapString = prefs.getString(waterMarkDetailsKey);
      Map<String, List<String>> waterMarkMap = {};

      if (waterMarkMapString != null) {
        // Decode the JSON string back into a map
        waterMarkMap = Map<String, List<String>>.from(
            jsonDecode(waterMarkMapString)
                .map((key, value) => MapEntry(key, List<String>.from(value))));
      }

      // Update the map with the new watermark details for the given event code
      waterMarkMap[eventCode] = waterMarkDetails;

      // Encode the updated map into a JSON string and save it to SharedPreferences
      await prefs.setString(waterMarkDetailsKey, jsonEncode(waterMarkMap));
    }
  }

  Future<void> insertEventFileConnector(
      List<transporterModel.EventDetailedData> eventDetaildatas) async {
    JvtFileModelDao jvtFileModelDao = JvtFileModelDao();
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    List<appDb.JvtFileConnectorsCompanion> jvtFileConnectorsCompanion = [];
    List<appDb.JvtFilesCompanion> jvtFileCompanion = [];
    for (transporterModel.EventDetailedData eventDetaildata
        in eventDetaildatas) {
      /// insert fileConnector table
      if (eventDetaildata.jvtFileConnectors!.isNotEmpty) {
        if (currentDevice == null) {
          ScreenUtil screenUtil = ScreenUtil();
          await screenUtil.getAndSetCurrentDevice();
        }
        for (transporterModel.JvtFileConnectors jvtFileConnector
            in eventDetaildata.jvtFileConnectors!) {
          if (jvtFileConnector.screenDisplay == currentDevice ||
              jvtFileConnector.screenDisplay == defaultDevice) {
            jvtFileConnectorsCompanion.add(appDb.JvtFileConnectorsCompanion(
              code: drift.Value(jvtFileConnector.code!),
              tag: drift.Value(jvtFileConnector.name!),
              ableCode: drift.Value(eventDetaildata.code!),
              ableType: drift.Value(TransportDataKeys.events),
              jvtFileCode: drift.Value(jvtFileConnector.jvtFile!.code!),
            ));
            jvtFileCompanion.add(appDb.JvtFilesCompanion(
              code: drift.Value(jvtFileConnector.jvtFile!.code!),
              downloaded: drift.Value(0),
              extension: drift.Value(jvtFileConnector.jvtFile!.extension!),
              size: drift.Value(jvtFileConnector.jvtFile!.size!),
              mode: drift.Value(jvtFileConnector.jvtFile!.mode!),
              priority: drift.Value(90),
              // event cover image
              attempt: drift.Value(0),
              name: drift.Value(jvtFileConnector.jvtFile!.name!),
              isNetworkImage: drift.Value(true),
            ));
          }
        }
      }
    }
    //insertAllFileConnector
    await jvtFileModelDao.insertAllFile(jvtFileCompanion);
    await jvtFileConnectorModelDao
        .insertAllFileConnector(jvtFileConnectorsCompanion);
  }

  prepareAndFillEventData() async {
    List<appDb.TransportDataData> transporters = await transporterDao
        .getTransporterWhereTagAndUpdateRequired(TransportDataKeys.eventData);
    List<String> events = [];
    for (appDb.TransportDataData transporter in transporters) {
      events.add(transporter.code!);
    }
    if (events.isNotEmpty) {
      await getEventData(eventsCode: events);
      showLog('Ai data called 1');
      showLog('Ai data completed 2');
    }
    await fillEventResources();
    // await eventAiDataController.fillEventResources();
    if (events.isNotEmpty) {
      await eventAiDataController.getEventAiData(eventsCode: events);
    }
  }
}
