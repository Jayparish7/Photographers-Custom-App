import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';

class UpsertEvent {
  Future<void> upsertEventInDatabase(
      {List<String>? apiEvents, String? transporterTag, int? eventType}) async {
    List<String> notifyEvent = [];
    showLog('event upsert called    $transporterTag');

    //  List<String> localEvent=[];
    List<String> _existingEvents = [];
    TransporterDao transporterDao = TransporterDao();
    EventModelDao eventModelDao = EventModelDao();
    if (apiEvents != null && apiEvents.isNotEmpty) {
      List _create = []; // insert this event
      List _delete = []; // delete this event
      List _update = []; // change update required as true
      List<appDb.Event>? _localEvents =
          await eventModelDao.getEventsByTag(transporterTag!);
      if (_localEvents != null && _localEvents.isNotEmpty) {
        _localEvents.forEach((_localEvent) {
          showLog("Existing event ${_localEvent.code} >");
          _existingEvents.add(_localEvent.code);
        });
      }

      /// get local event

      for (int i = 0; i < apiEvents.length; i++) {
        if (_existingEvents.contains(apiEvents[i])) {
          _update.add(apiEvents[i]);
        }
        if (!_existingEvents.contains(apiEvents[i])) {
          showLog("new events adding code ${apiEvents[i]}");
          _create.add(apiEvents[i]);
        }
      }
      for (int i = 0; i < _existingEvents.length; i++) {
        if (!apiEvents.contains(_existingEvents[i])) {
          showLog('need to delete this }');
          _delete.add(_existingEvents[i]);
        }
      }

      /// INSERT NEW EVENT URL TO TRANSPORTER API WITH LAST UPDATE AS [0]
      if (_create.isNotEmpty) {
        for (int i = 0; i < _create.length; i++) {
          notifyEvent.add(apiEvents[i]);
          await transporterDao.insertOrUpdateTransporter(
              eventType: eventType,
              code: _create[i],
              tag: TransportDataKeys.eventData);
        }
      }

      /// UPDATE Existing URL TO TRANSPORTER API WITH UPDATE REQUIRED [TRUE]
      if (_update.isNotEmpty) {
        for (int i = 0; i < _update.length; i++) {
          showLog('the event updateInfo ,,,');
          transporterDao.insertOrUpdateTransporter(
            eventType: eventType,
            code: _update[i],
            tag: TransportDataKeys.eventData,
          );
        }
      }

      /// DELETE EVENT NEED TO BE DELETED
      if (_delete.isNotEmpty) {
        showLog('delete method called');
        for (int i = 0; i < _delete.length; i++) {
          eventModelDao.deleteEventByCode(_delete[i]);
        }
      }
    } else {
      List<appDb.Event> event = [];
      if (eventType == userEvent) {
        event = await eventModelDao.getUserEvent();
      }
      if (eventType == studioGalleyEvent) {
        event = await eventModelDao.getAllGalleryEvent();
      }
      if (event.isNotEmpty) {
        for (int i = 0; i < event.length; i++) {
          await eventModelDao.deleteEventByCode(event[i].code);
        }
      }
    }
    /*  if (notifyEvent.isNotEmpty && isNotification == true) {
      showLog("new events notifications ${notifyEvent}");
      newEventCallBack(notifyEvent);
      notifyEvent.clear();
    }*/
  }
}
