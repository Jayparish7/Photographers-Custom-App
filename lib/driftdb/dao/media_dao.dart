import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart' as drift;
import 'package:http/http.dart' as http;
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;
import 'package:photomall_flutter/core/notification/notificationMethods/local_notification_method.dart';
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:photomall_flutter/driftdb/dao/album_dao.dart';
import 'package:photomall_flutter/driftdb/dao/jvt_file_dao.dart';
import 'package:photomall_flutter/driftdb/dao/video_dao.dart';
import 'package:photomall_flutter/traits/utils/screen_utils.dart';

class MediaModelDao {
  AppDb database = AppDb();

  Future<List<MediaData>> getMedias() async {
    return await database.select(database.media).get();
  }

  Future<List<MediaData>> getMediasByEventCode(String code) async {
    return await (database.select(database.media)
          ..where((tbl) {
            return (tbl.eventCode.equals(code));
          }))
        .get();
  }

  // get medias by event code
  Future<MediaData?> getMediaByCode(String code) async {
    return await (database.select(database.media)
          ..where((tbl) {
            return (tbl.code.equals(code));
          })
          ..limit(1))
        .getSingleOrNull();
  }

  Future<MediaData?> getMediaByAbleCode(String ableCode) async {
    return await (database.select(database.media)
          ..where((tbl) {
            return (tbl.ableCode.equals(ableCode));
          })
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<MediaData>> getMediasByCode(String code) async {
    return await (database.select(database.media)
          ..where((tbl) {
            return (tbl.code.equals(code));
          }))
        .get();
  }

  // get medias by event code
  Future<List<MediaData>> getMediasByEventCodeByPriority(
      String eventCode) async {
    return await (database.select(database.media)
          ..where((tbl) {
            return (tbl.eventCode.equals(eventCode));
          })
          ..orderBy([(t) => drift.OrderingTerm.desc(t.priorityScore)]))
        .get();
  }

  Future<int> insertOrUpdateMedia(MediaCompanion entity) async {
    return await database.into(database.media).insertOnConflictUpdate(entity);
  }

  Future<void> deleteMediaByEventCode(String eventCode) async {
    await (database.delete(database.media)
          ..where((tbl) => tbl.eventCode.equals(eventCode)))
        .go();
  }

  Future<void> deleteMediaByCode(String code) async {
    await (database.delete(database.media)
          ..where((tbl) => tbl.code.equals(code)))
        .go();
  }

  Future<void> deleteMediaByECode({required String mediaCode}) async {
    VideoModelDao videoModelDao = VideoModelDao();
    AlbumModelDao albumModelDao = AlbumModelDao();
    // get media by code
    List<MediaData> medias = await getMediasByCode(mediaCode);
    for (MediaData media in medias) {
      // delete media
      await deleteMediaByCode(media.code);
      // delete album
      await albumModelDao.deleteAlbumByCode(media.ableCode);
      // delete videos
      await videoModelDao.deleteVideosByCode(media.ableCode);
    }
  }

  isYouTubeVideoAvailable(String videoId) async {
    try {
      final response = await http
          .get(Uri.parse('https://img.youtube.com/vi/$videoId/0.jpg'));
      showLog('isYouTubeVideoAvailable${response.statusCode}');
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // An error occurred (e.g., network issues)
      showLog('Error checking YouTube video availability: $e');
      return false;
    }
  }

  Future<void> insertOrUpdateAllMedia(
      {required List<transporter.Media> medias,
      required String eventCode}) async {
    try {
      AlbumModelDao albumModelDao = AlbumModelDao();
      VideoModelDao videoModelDao = VideoModelDao();

      JvtFileModelDao jvtFileModelDao = JvtFileModelDao();

      List<MediaCompanion> mediaCompanions = [];
      List<VideosCompanion> videos = [];
      List<AlbumsCompanion> albumsCompanions = [];
      List<JvtFilesCompanion> jvtFileCompanions = [];

      for (transporter.Media media in medias) {
        MediaCompanion entity = MediaCompanion(
          eventCode: drift.Value(eventCode),
          code: drift.Value(media.code!),
          ableType: drift.Value(media.mediableType == TransportDataKeys.albums
              ? TransportDataKeys.albums
              : TransportDataKeys.videos),
          ableCode: drift.Value(media.mediable!.code!),
          published: drift.Value(media.published == 1 ? true : false),
          lastUpdated: drift.Value(media.lastUpdatedAt ?? 0),
          priorityScore: drift.Value(media.priorityScore!),
        );
        mediaCompanions.add(entity);

        switch (media.mediableType) {
          case TransportDataKeys.videos:
            {
              showLog("media.mediable!.baseUrl! ${media.mediable!.baseUrl!}");
              videos.add(VideosCompanion(
                  code: drift.Value(media.mediable!.code!),
                  name: drift.Value(media.mediable!.name!),
                  eventCode: drift.Value(eventCode),
                  published: drift.Value(media.published == 1 ? true : false),
                  url: drift.Value(
                      media.mediable!.baseUrl! + media.mediable!.url!),
                  visibility: drift.Value(media.published),
                  priorityScore: drift.Value(media.priorityScore!)));
            }
            break;
          case TransportDataKeys.albums:
            {
              /// Insert album
              String? cover = await getAlbumCover(
                  media.mediable!.albumCoverImage?.jvtFileConnectors ?? []);
              String? music = getAlbumMusic(media.mediable!.jvtFileConnectors!);
              // get local orders
              Album? localAlbum = await albumModelDao
                  .getSingleAlbumWhereCode(media.mediable!.code!);
              showLog(
                  'the local album  getSingleAlbumWhereCode ${media.published}');
              if (localAlbum != null &&
                  localAlbum.visibility == 1 &&
                  media.published == 1) {
                LocalNotification localNotification = LocalNotification();
                await localNotification.notifyAlbumPublished(localAlbum.name,
                    eventCode, localAlbum.code, localAlbum.coverImage);
              }

              showLog("media.mediable?.orders ${media.mediable?.orders}");
              final rawOrders = media.mediable?.orders;

              if (rawOrders != null) {
                // showLog("Before sorting:");
                // for (final order in rawOrders) {
                //   showLog(order['original_file_name']?.toString() ?? '');
                // }
                rawOrders.sort((a, b) => compareNatural(
                      (a['original_file_name'] ?? '') as String,
                      (b['original_file_name'] ?? '') as String,
                    ));
              }

              // Log after sorting
              // showLog("After sorting:");
              // for (final order in rawOrders!) {
              //   showLog(order['original_file_name']?.toString() ?? '');
              // }
              showLog("Sorted Orders: $rawOrders");

              final encodedOrders = json.encode(rawOrders);

              albumsCompanions.add(AlbumsCompanion(
                  priorityScore: drift.Value(media.priorityScore ?? 0),
                  code: drift.Value(media.mediable!.code!),
                  name: drift.Value(media.mediable!.name!),
                  published: drift.Value(
                      (media.published == 1 || media.published == 2)
                          ? true
                          : false),
                  visibility: drift.Value(media.published ?? 0),
                  eventCode: drift.Value(eventCode),
                  type: drift.Value(media.mediable!.albumType!),
                  size: drift.Value(media.mediable!.albumSize!.size!),
                  coverImage: drift.Value(cover),
                  music: drift.Value(music ?? ""),
                  oldOrders: localAlbum != null
                      ? drift.Value(localAlbum.orders)
                      : drift.Value.absent(),
                  orders: drift.Value(encodedOrders)));
            }
            break;
        }
      }
      // insert all media rows
      await insertAllMediaRows(mediaCompanions);
      await videoModelDao.insertAllVideos(videos);
      await albumModelDao.insertAllAlbum(albumsCompanions);
      await jvtFileModelDao.insertAllFile(jvtFileCompanions);
    } catch (e, s) {
      showLog("Exception in media insert or update Media DAO $e , $s");
    }
  }

  insertAllMediaRows(List<MediaCompanion> mediaCompanions) async {
    if (mediaCompanions.isNotEmpty) {
      await database.batch((batch) {
        return (batch.insertAllOnConflictUpdate(
            database.media, mediaCompanions));
      });
    }
  }

  Future<String?> getAlbumCover(List<dynamic> jvtFileConnectors) async {
    try {
      int? _currentDevice = 0;
      if (currentDevice != null) {
        _currentDevice = currentDevice;
      } else {
        ScreenUtil screenUtil = ScreenUtil();
        await screenUtil.getAndSetCurrentDevice();
        _currentDevice = currentDevice;
      }
      showLog('_currentDevice $_currentDevice');
      // return cover image name
      List<transporter.JvtFileConnectors> jvtFileConnector =
          jvtFileConnectors.map((row) {
        return transporter.JvtFileConnectors.fromJson(
            json.decode(json.encode(row)));
      }).toList();
      transporter.JvtFile? file;
      showLog(
          'the file connector code ${jvtFileConnector.length},current device size $currentDevice');
      for (transporter.JvtFileConnectors image in jvtFileConnector) {
        showLog(
            'the file connector code ${image.code} Api screen size${image.screenDisplay}');
        if (/*image.name == TransportDataKeys.albumCover &&*/
            (image.screenDisplay == currentDevice)) {
          file = image.jvtFile;
          break;
        }
      }
      showLog('image.jvtFile${file!.name}');
      return file.name;
    } catch (e) {
      showLog("the error in getAlbumCover ${e}");
      return null;
    }
  }

  String? getAlbumMusic(List<dynamic> jvtFileConnectors) {
    try {
      // return cover image name
      List<transporter.JvtFileConnectors> jvtFileConnector =
          jvtFileConnectors.map((row) {
        return transporter.JvtFileConnectors.fromJson(
            json.decode(json.encode(row)));
      }).toList();
      transporter.JvtFile? file;
      for (transporter.JvtFileConnectors image in jvtFileConnector) {
        if (image.name == TransportDataKeys.albumMusic &&
            (image.screenDisplay == currentDevice ||
                image.screenDisplay == defaultDevice)) {
          file = image.jvtFile;
          break;
        }
      }
      return file?.name;
    } catch (e) {
      showLog("the exception getAlbumMusic ${e}");
    }
    return null;
  }
}
