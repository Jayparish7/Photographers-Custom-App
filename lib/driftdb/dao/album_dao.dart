import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:photomall_flutter/driftdb/dao/jvt_file_connector_dao.dart';
import 'package:photomall_flutter/driftdb/dao/jvt_file_dao.dart';

class AlbumModelDao {
  AppDb database = AppDb();

  Future<int?> insertAllAlbum(List<AlbumsCompanion> albumsCompanions) async {
    if (albumsCompanions.isNotEmpty) {
      try {
        database.batch((batch) {
          return batch.insertAllOnConflictUpdate(
              database.albums, albumsCompanions);
        });


      } catch (e) {
        showLog("the error in album insert ${e}");
      }
    }
    return null;
  }

  /// Get all event method

  Future<List<Album>> getAlbum() async {
    return await database.select(database.albums).get();
  }

  Future<List<Album>?> getUpdatedAlbum() async {
    try {
      return await (database.select(database.albums)
            ..where((tbl) {
              return (tbl.oldOrders.isNotNull()) & (tbl.orders.isNotNull());
            }))
          .get();
    } catch (e) {
      return null;
    }
  }

  Future<Album?> getSingleAlbumWhereCode(String code) async {
    try {
      return await (database.select(database.albums)
            ..where((tbl) {
              return (tbl.code.equals(code));
            })
            ..limit(1))
          .getSingle();
    } catch (e) {
      return null;
    }
  }

  Future<List<Album>> getMultipleAlbumWhereCode(String code) async {
    return await (database.select(database.albums)
          ..where((tbl) {
            return (tbl.code.equals(code));
          }))
        .get();
  }
  Future<List<Album>> getMultipleAlbumWhereVisibilityNull(String code) async {
    return await (database.select(database.albums)
          ..where((tbl) {
            return (tbl.eventCode.equals(code) & tbl.visibility.isNull());
          }))
        .get();
  }



  Future<List<Album>> getMultipleAlbumWhereEventCode(String code) async {
    return await (database.select(database.albums)
          ..where((tbl) {
            return (tbl.eventCode.equals(code));
          }))
        .get();
  }

  Future<List<Album>>? getAlbumsWhereEventCode(String eventCode) async {
    return await (database.select(database.albums)
          ..where((tbl) {
            return (tbl.eventCode.equals(eventCode));
          }))
        .get();
  }

  Future<void> debugAlbums(eventCode) async {
    showLog("debugAlbums $eventCode");
    final allAlbums = await database.select(database.albums).get();
    print('All albums count: ${allAlbums.length}');
    for (var album in allAlbums) {
      print('Album ID: ${album.code}, EventCode: ${album.eventCode}');
    }

    final eventAlbums = await (database.select(database.albums)
          ..where((tbl) => tbl.eventCode.equals(eventCode)))
        .get();
    print('Event albums count: ${eventAlbums.length}');
  }

  Future<List<Album>>? getPublishedStatusWhereImages(String image) async {
    return await (database.select(
      database.albums,
    )..where((tbl) {
            return (tbl.coverImage.equals(image));
          }))
        .get();
  }

  /// Delete event with code

  Future<void> deleteAlbumByEventCode(String eventCode) async {
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();

    List<Album>? albums = await getAlbumsWhereEventCode(eventCode);
    if (albums != null && albums.isNotEmpty) {
      for (Album album in albums) {
        //delete orders

        await jvtFileConnectorModelDao
            .deleteJvtFileConnectorByAbleCodeAndAbleType(
                album.code, TransportDataKeys.albums);
      }
      await (database.delete(database.albums)
            ..where((tbl) => tbl.eventCode.equals(eventCode)))
          .go();
    }
  }

  /// Update event with code

  Future<void> updateAlbumByCode(AlbumsCompanion entity, String compare) async {
    await (database.update(database.albums)
          ..where((tbl) => tbl.code.equals(compare)))
        .write(entity);
  }

  Future<void> flushOldOrders(String code) async {
    await (database.update(database.albums)
          ..where((tbl) => tbl.code.equals(code)))
        .write(AlbumsCompanion(oldOrders: drift.Value(null)));
  }

  Future<void> updateAlbumLastSeenIndexByCode(
      String orderCode, String compare) async {
    try {
      await (database.update(database.albums)
            ..where((tbl) => tbl.code.equals(compare)))
          .write(AlbumsCompanion(lastSeenIndex: drift.Value(orderCode)));
    } catch (e) {
      showLog("Exception : in order insert on album table $e");
    }
  }

  /// Insert new entity

  Future<int> insertAlbum(AlbumsCompanion entity) async {
    return await database.into(database.albums).insert(entity);
  }

  /// InsertOrUpdate new entity

  Future<int> insertOrUpdateAlbum(AlbumsCompanion entity) async {
    return await database.into(database.albums).insertOnConflictUpdate(entity);
  }

  Future<List<Album>> getAlbumsByCode(String code) async {
    return await (database.select(database.albums)
          ..where((tbl) => tbl.code.equals(code)))
        .get();
  }

  Future<Album?> getAlbumByCode(String code) async {
    return await (database.select(database.albums)
          ..where((tbl) => tbl.code.equals(code))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Delete album with code

  Future<void> deleteAlbumByCode(String albumCode) async {
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();

    List<Album> albums = await getMultipleAlbumWhereCode(albumCode);
    if (albums.isNotEmpty) {
      for (Album album in albums) {
        //delete orders

        await jvtFileConnectorModelDao
            .deleteJvtFileConnectorByAbleCodeAndAbleType(
                album.code, TransportDataKeys.albums);
      }
      await (database.delete(database.albums)
            ..where((tbl) => tbl.eventCode.equals(albumCode)))
          .go();
    }
  }

  Future<JvtFile?> getAlbumCoverByCode(String albumCode) async {
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    JvtFileModelDao jvtFileModelDao = JvtFileModelDao();
    JvtFileConnector? jvtFileConnector = await jvtFileConnectorModelDao
        .getFileConnectorWhereAbleCodeAndAlbumCover(albumCode);
    if (jvtFileConnector == null) {
      return await jvtFileModelDao
          .getFileWhereCode(jvtFileConnector!.jvtFileCode);
    } else {
      return null;
    }
  }
}
