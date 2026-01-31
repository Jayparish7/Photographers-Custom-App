import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/album_dao.dart';
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_dao.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';
import 'package:photomall_flutter/ui/common_response.dart';

class EventController {
  EventModelDao eventModelDao = EventModelDao();
  AlbumModelDao albumModelDao = AlbumModelDao();
  FolderModelDao folderModelDao = FolderModelDao();

  Future<bool> eventArchiveOrUnArchive(
      {required String eventCode, required bool archiveStatus}) async {
    // toggle event archive status by event code
    try {
      PhotomallApis photomallApis = PhotomallApis(null);
      CommonResponse response = await photomallApis.eventArchiveOrUnaArchive(
          eventCode: eventCode, archived: archiveStatus);
      if (response.status) {
        await eventModelDao.toggleEventArchiveStatus(eventCode, archiveStatus);
        if (archiveStatus) {
          // remove from transporter table
        } else {
          TransporterDao transporterDao = TransporterDao();
          // get transporter event
          appDb.TransportDataData? transportDataData =
              await transporterDao.getTransporterWhereCode(eventCode);
          // toggle transporter update required
          if (transportDataData != null) {
            await transporterDao.insertOrUpdateTransporter(
                tag: transportDataData.tag, code: transportDataData.code);
          }
        }
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      showLog("the error in EVENT CONTROLLER while archive event \n${s}");
      return false;
    }
  }

  Future<bool> deleteEvent(String eventCode) async {
    // delete this event
    try {
      await eventModelDao.deleteEventByCode(eventCode);
      return true;
    } catch (e, s) {
      showLog("the error in EVENT CONTROLLER while deleting event \n${s}");
      return false;
    }
  }

  Future<List<ArchivedModel>> getArchivedEvent() async {
    List<ArchivedModel> archivedEvents = [];
    List<appDb.Event> events = await eventModelDao.getArchivedEvent();
    if (events.isNotEmpty) {
      for (appDb.Event event in events) {
        archivedEvents
            .add(ArchivedModel(code: event.code, name: event.categoryName));
      }
    }
    return archivedEvents;
  }

  Future<appDb.Event?> getEventByAlbumCode(String albumCode) async {
    appDb.Album? album = await albumModelDao.getSingleAlbumWhereCode(albumCode);
    return await eventModelDao.getEventByCode(album!.eventCode);
  }

  Future<appDb.Event?> getEventByFolderCode(String folderCode) async {
    appDb.Folder? folder = await folderModelDao.getFolderWhereCode(folderCode);
    return await eventModelDao.getEventByCode(folder!.eventCode);
  }

  toggleEventViewed({required String eventCode, required bool status}) async {
    await eventModelDao.toggleEventSeenStatus(eventCode, status);
  }
}

class ArchivedModel {
  final String? code;
  final String? name;

  ArchivedModel({
    this.code,
    this.name,
  });
}
