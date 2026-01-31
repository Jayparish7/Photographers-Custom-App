import 'dart:typed_data';
import 'package:photomall_flutter/controllers/compare_List_controller.dart';
import 'package:photomall_flutter/controllers/pm_job_controller.dart';
import 'package:photomall_flutter/controllers/studio_data_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/core/notification/notification_utils.dart';
import 'package:http/http.dart' as http;
import 'package:photomall_flutter/driftdb/dao/album_dao.dart';
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_notification_dao.dart';
import 'package:photomall_flutter/media/order_model.dart' as order;
import 'package:photomall_flutter/traits/utils/storage_utils.dart';

class LocalNotification {
  Future<void> showLocalNotification(
      String? imageURL, String title, String subTitle,
      {String? payload}) async {
    Uint8List? image;
    NotificationUtils notificationUtils = NotificationUtils();
    try {
      if (imageURL != null) {
        http.Response response = await http.get(
          Uri.parse(imageURL),
        );
        image = response.bodyBytes;
      }
    } catch (e) {
      image = null;
      showLog('Error : in notify method $e');
    }

    await notificationUtils.showNotification(null, title, subTitle, image,
        payload: payload);
  }

  Future<void> notifyEventPublished(String? eventName, String eventCode) async {
    DownloadPath? downloadPath = await getDownloadPath();
    EventModelDao eventModelDao = EventModelDao();
    appDb.JvtFile? file = await eventModelDao.getEventCoverByCode(eventCode);
    showLocalNotification("${downloadPath.public}/${file!.name}", "Event added",
        '${eventName ?? 'event'} has been published',
        payload: await getPlayLoad(eventCode));
  }

  Future<void> notifyAlbumPublished(String? albumName, String eventCode,
      String albumCode, String? coverImage) async {
    EventModelDao eventModelDao =EventModelDao();
    DownloadPath? downloadPath = await getDownloadPath();
    String url = '${downloadPath.public}/${coverImage}';
    appDb.Event? event =
    await eventModelDao.getEventByCode(eventCode);
    if(event?.published ==false){
      showLog("event?.published ${event?.published}");
      return;
    }
    showLocalNotification(
        "$url", "Album added", '${albumName ?? 'album'} has been published',
        payload: await getPlayLoad(eventCode));
  }

  Future<void> showNotificationForNewEntry() async {
    CompareListController compare = CompareListController();
    EventModelDao eventModelDao = EventModelDao();
    FolderNotificationDao folderNotificationDao = FolderNotificationDao();
    DownloadPath? downloadPath = await getDownloadPath();

    showLog("the notification update begin");

    List<appDb.Album> albums = await prepareNewOrdersUpdateAtAlbums();
    if (albums.isNotEmpty) {
      for (appDb.Album album in albums) {
        CompareListStatus orderStatus = compare.compareOrder(
            newOrders: order.orderFromJson(album.orders),
            oldOrders: order.orderFromJson(album.oldOrders));
        if (orderStatus.status == true) {
          appDb.Event? event =
              await eventModelDao.getEventByCode(album.eventCode);
          String url = '${downloadPath.public}/${album.coverImage}';
          showLocalNotification(url, "Photos added",
              '${orderStatus.count} photos have been added to the album in ${event!.name}');
        }
        // flush old order in this album
        await flushAlbumOldOrder(album.code);
      }
    }

    List<appDb.FolderNotificationData> folders =
        await folderNotificationDao.getFolderNotification();

    if (folders.isNotEmpty) {
      for (appDb.FolderNotificationData folder in folders) {
        CompareListStatus data = compare.compareFolder(
            newFolder: folder.folderCodes, oldFolder: folder.oldFolderCodes);
        if (data.status == true) {
          // get event
          appDb.Event? event =
              await eventModelDao.getEventByCode(folder.eventCode);
          appDb.JvtFile? file =
              await eventModelDao.getEventCoverByCode(folder.eventCode);
          showLocalNotification(
              "${downloadPath.public}/${file!.name}",
              "Folder added for Photo selection",
              '${data.count} folder added for Photo selection in ${event!.name}',
              payload: await getPlayLoad(folder.eventCode));
          await folderNotificationDao.flushFolderNotifiedRow(folder.eventCode);
        }
      }
    }
  }

  Future<DownloadPath> getDownloadPath() async {
    if (studioPublicPath != null &&
        appDocumentDirectoryPath != null &&
        studioPrivatePath != null) {
      return DownloadPath(
          DocumentPath: appDocumentDirectoryPath,
          public: studioPublicPath,
          private: studioPublicPath);
    } else {
      EssentialUtils essentialUtils = EssentialUtils();
      await essentialUtils.loadAppEssentialData();
      return DownloadPath(
          public: studioPublicPath,
          private: studioPrivatePath,
          DocumentPath: appDocumentDirectoryPath);
    }
  }

  Future<List<appDb.Album>> prepareNewOrdersUpdateAtAlbums() async {
    List<appDb.Album>? updatedAlbums = [];
    AlbumModelDao albumModelDao = AlbumModelDao();
    List<appDb.Album>? albums = await albumModelDao.getUpdatedAlbum();
    if (albums != null) {
      for (appDb.Album album in albums) {
        if (album.orders!.isNotEmpty) {
          updatedAlbums.add(album);
        }
      }
    }
    return updatedAlbums;
  }

  Future<void> showNotificationForNewPhotoSelectionImages(
      String eventCode, String folderCode, int imageCount) async {
    String? imageURL;
    String? folderName;
    EventModelDao eventModelDao = EventModelDao();
    FolderModelDao folderModelDao = FolderModelDao();
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
      essentialUtils.loadAppEssentialData();
      downloadPath = DownloadPath(
          public: studioPublicPath,
          private: studioPrivatePath,
          DocumentPath: appDocumentDirectoryPath);
    }
    // get event cover
    appDb.JvtFile? file = await eventModelDao.getEventCoverByCode(eventCode);
    if (file != null) {
      imageURL = '${downloadPath.public}/${file.name}';
    } else {
      // no image
    }

    // get folder detail
    appDb.Folder? folder = await folderModelDao.getFolderWhereCode(folderCode);
    if (folder != null) {
      folderName = folder.name;
    }
    // show notification
    showLocalNotification(imageURL, "Photos added for Photo selection",
        "$imageCount photos have been added to the folder $folderName for photo selection",
        payload: await getPlayLoad(eventCode));
  }

  flushAlbumOldOrder(String code) async {
    AlbumModelDao albumModelDao = AlbumModelDao();
    await albumModelDao.flushOldOrders(code);
  }

  Future<String> getPlayLoad(String? eventCode) async {
    if (eventCode == null) {
      return "";
    }
    StudioDataController studioDataController = StudioDataController();
    String sourceLink =
        "${await studioDataController.getWebLink()}/en/events/$eventCode";
    return sourceLink;
  }
}
