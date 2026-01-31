import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/controllers/pm_job_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;
import 'package:photomall_flutter/core/notification/notificationMethods/local_notification_method.dart';
import 'package:photomall_flutter/core/services/image_handler.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/album_dao.dart';
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/dao/media_dao.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';
import 'package:photomall_flutter/driftdb/dao/video_dao.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';

class MediaController {
  MediaModelDao mediaModelDao = MediaModelDao();

  Future<void> upsertMedia({
    required List<transporter.Media> medias,
    required String eventCode,
    int? eventType,
  }) async {
    List<String> notifyMediaAlbum = [];
    List<String> notifyMediaVideo = [];
    DownloadPath? downloadPath;
    if (studioPublicPath != null &&
        appDocumentDirectoryPath != null &&
        studioPrivatePath != null) {
      downloadPath = DownloadPath(
          DocumentPath: appDocumentDirectoryPath,
          public: studioPublicPath,
          private: studioPublicPath);
    } else {
      EssentialUtils essentialUtils = EssentialUtils();
      await essentialUtils.loadAppEssentialData();
      downloadPath = DownloadPath(
          public: studioPublicPath,
          private: studioPrivatePath,
          DocumentPath: appDocumentDirectoryPath);
    }
    List<String> apiMedia = [];
    for (transporter.Media media in medias) {
      apiMedia.add(media.code!);
    }

    List<String> existingMedia = [];
    if (apiMedia.isNotEmpty) {
      List create = []; // insert this event
      List delete = []; // delete this event
      List update = []; // change update required as true
      /// get local event
      List<appDb.MediaData> _medias =
          await mediaModelDao.getMediasByEventCodeByPriority(eventCode);
      if (_medias.isNotEmpty) {
        _medias.forEach((media) {
          existingMedia.add(media.code);
        });
      }
      for (int i = 0; i < apiMedia.length; i++) {
        if (existingMedia.contains(apiMedia[i])) {
          update.add(apiMedia[i]);
        }
        if (!existingMedia.contains(apiMedia[i])) {
          create.add(apiMedia[i]);
        }
      }
      for (int i = 0; i < existingMedia.length; i++) {
        if (!apiMedia.contains(existingMedia[i])) {
          delete.add(existingMedia[i]);
        }
      }

      /// INSERT Media
      if (create.isNotEmpty) {
        List<appDb.TransportDataCompanion> albumTransportDataCompanion = [];
        List<transporter.Media> insertNewMedia = [];
        for (int i = 0; i < create.length; i++) {
          List<transporter.Media> _newMedia =
              medias.where((obj) => obj.code == create[i]).toList();
          insertNewMedia.add(_newMedia.first);
          if (_newMedia.first.mediableType == TransportDataKeys.albums &&
              eventType == userEvent) {
            notifyMediaAlbum.add(_newMedia.first.mediable!.code!);
          }
          if (_newMedia.first.mediableType == TransportDataKeys.videos &&
              eventType == userEvent) {
            showLog(
                "video added notification step 0  ${_newMedia.first.mediable!.code!} ");

            notifyMediaVideo.add(_newMedia.first.mediable!.code!);
          }
          if (_newMedia.first.mediableType == TransportDataKeys.albums &&
              eventType == userEvent) {
            albumTransportDataCompanion.add(appDb.TransportDataCompanion(
              code: drift.Value(_newMedia.first.mediable!.code!),
              lastUpdatedAt: drift.Value(0),
              tag: drift.Value(TransportDataKeys.albums),
              updateRequired: drift.Value(1),
            ));
          }
        }
        await mediaModelDao.insertOrUpdateAllMedia(
          eventCode: eventCode,
          medias: insertNewMedia,
        );
        if (albumTransportDataCompanion.isNotEmpty) {
          TransporterDao transporterDao = TransporterDao();
          showLog('Batch inserting transporter..');
          await transporterDao
              .insertAllNewTransporter(albumTransportDataCompanion);
          showLog('Batch inserted transporter..');
        }
      }

      /// UPDATE Media
      if (update.isNotEmpty) {
        List<transporter.Media> updateNewMedia = [];
        for (int i = 0; i < update.length; i++) {
          List<transporter.Media> _updateMedia =
              medias.where((obj) => obj.code == update[i]).toList();
          appDb.MediaData? _local =
              await mediaModelDao.getMediaByCode(_updateMedia.first.code!);

          showLog(
              "the last update condition ${_local!.lastUpdated < _updateMedia.first.lastUpdatedAt!}");
          showLog("the last update local ${_local.lastUpdated}");
          showLog("the last update api ${_updateMedia.first.lastUpdatedAt}");

          if (_local.lastUpdated < _updateMedia.first.lastUpdatedAt! || true) {
            updateNewMedia.add(_updateMedia.first);
          }
        }
        showLog('Batch updating transporter.. $updateNewMedia $eventCode');
        await mediaModelDao.insertOrUpdateAllMedia(
          eventCode: eventCode,
          medias: updateNewMedia,
        );
      }

      /// DELETE Media
      if (delete.isNotEmpty) {
        for (int i = 0; i < delete.length; i++) {
          // delete media
          await mediaModelDao.deleteMediaByECode(mediaCode: delete[i]);
        }
      }
    }
    if (notifyMediaAlbum.isNotEmpty) {
      LocalNotification localNotification = LocalNotification();
      AlbumModelDao albumModelDao = AlbumModelDao();
      EventModelDao eventModelDao = EventModelDao();
      for (String media in notifyMediaAlbum) {
        // get album
        appDb.Album? album = await albumModelDao.getSingleAlbumWhereCode(media);
        if (album != null) {
          appDb.Event? event =
              await eventModelDao.getEventByCode(album.eventCode);
          String url = '${downloadPath.public}/${album.coverImage}';
          if(event?.published ==false){
            showLog("event?.published ${event?.published}");
            return;
          }
          await localNotification.showLocalNotification(
              url, 'Album added', 'New Album has been added for ${event!.name}',
              payload: await localNotification.getPlayLoad(eventCode));
        }
      }
    }
    if (notifyMediaVideo.isNotEmpty) {
      LocalNotification localNotification = LocalNotification();
      VideoModelDao videoModelDao = VideoModelDao();
      EventModelDao eventModelDao = EventModelDao();
      for (String media in notifyMediaVideo) {
        // get album
        appDb.Video? video = await videoModelDao.getVideoByCode(media);
        if (video != null) {
          appDb.Event? event =
              await eventModelDao.getEventByCode(video.eventCode);
          String url = await getVideoCoverImage(video.url);
          if(event?.published ==false){
            showLog("event?.published ${event?.published}");
            return;
          }
          localNotification.showLocalNotification(
              url, 'Video added', 'New video has been added for ${event!.name}',
              payload: await localNotification.getPlayLoad(eventCode));
        }
      }
    }
  }
}
