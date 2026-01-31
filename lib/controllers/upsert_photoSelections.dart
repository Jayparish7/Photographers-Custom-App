import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/photo_selection_table_dao.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';

class UpsertPhotoSelectionEvent {
  Future<bool?> upsertPhotoSelections(
      {required List<String> apiEvents, required bool isUser}) async {
    showLog("the new photo selection $apiEvents");
    String transporterTag = TransportDataKeys.photoSelectionData;
    List<String> existingEvents = [];
    TransporterDao transporterDao = TransporterDao();
    PhotoSelectionsDao photoSelectionsDao = PhotoSelectionsDao();
    if (apiEvents.isNotEmpty) {
      List create = []; // insert this event
      List delete = []; // delete this event
      List update = []; // change update required as true
      List<appDb.PhotoSelection?>? events;
      if (isUser == true) {
        events = await photoSelectionsDao.getUserPhotoSelection(
            eventType: userEvent);
      } else {
        events = await photoSelectionsDao.getUserPhotoSelection(
            eventType: demoEvent);
      }
      if (events != null && events.isNotEmpty) {
        events.forEach((localEvent) {
          showLog("the local photo selection ${localEvent!.eventCode}");

          existingEvents.add(localEvent.eventCode);
        });
      }

      /// get local event

      for (int i = 0; i < apiEvents.length; i++) {
        showLog('the api event wheres ${apiEvents[i]}');

        if (existingEvents.contains(apiEvents[i])) {
          showLog("the update photo selection ${apiEvents[i]}");

          update.add(apiEvents[i]);
        }
        if (!existingEvents.contains(apiEvents[i])) {
          showLog("the create photo selection ${apiEvents[i]}");

          create.add(apiEvents[i]);
        }
      }
      for (int i = 0; i < existingEvents.length; i++) {
        if (!apiEvents.contains(existingEvents[i])) {
          showLog("the delete photo selection ${existingEvents[i]}");

          delete.add(existingEvents[i]);
        }
      }

      /// INSERT NEW Photo Selection TO TRANSPORTER API WITH LAST UPDATE AS [0]
      if (create.isNotEmpty) {
        for (int i = 0; i < create.length; i++) {
          showLog("photo selection data entity ${create[i]}");
          await transporterDao.insertOrUpdateTransporter(
              code: create[i], tag: transporterTag);
        }
      }

      /// UPDATE Existing URL TO TRANSPORTER API WITH UPDATE REQUIRED [TRUE]
      if (update.isNotEmpty) {
        for (int i = 0; i < update.length; i++) {
          await transporterDao.insertOrUpdateTransporter(
              isNotification: true,
              code: update[i],
              tag: TransportDataKeys.photoSelectionData);
        }
      }

      /// DELETE EVENT NEED TO BE DELETED
      if (delete.isNotEmpty) {
        PhotoSelectionsDao photoSelectionsDao = PhotoSelectionsDao();
        for (int i = 0; i < delete.length; i++) {
          showLog("the photo selection now deleting ...${delete[i]}");

          await photoSelectionsDao.deletePhotoSelectionsFlow(delete[i]);
          //  eventModelDao.deleteEventByCode(delete[i]);
        }
      }
    } else {
      showLog("yes it is empty");
      PhotoSelectionsDao photoSelectionsDao = PhotoSelectionsDao();
      List<appDb.PhotoSelection?>? photoSelection = [];
      if (isUser) {
        // get user photo selections and delete all
        photoSelection =
            await photoSelectionsDao.getAllPhotoSelectionByUserType(userEvent);
        showLog(
            "the user data photo selection length${photoSelection?.length}");
      } else {
        //get studio photo selections and delete all
        photoSelection = await photoSelectionsDao
            .getAllPhotoSelectionByUserType(studioGalleyEvent);
        showLog(
            "the studio data photo selection length${photoSelection?.length}");
      }
      if (photoSelection != null && photoSelection.isNotEmpty) {
        for (appDb.PhotoSelection? photo in photoSelection) {
          if (photo != null) {
            await photoSelectionsDao.deletePhotoSelectionsFlow(photo.eventCode);
          }
        }
      }
    }
  }
}
