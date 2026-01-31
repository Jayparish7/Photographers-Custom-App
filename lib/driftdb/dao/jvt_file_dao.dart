import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporterModel;
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:photomall_flutter/traits/download_method.dart';

class JvtFileModelDao {
  AppDb database = AppDb();

  /// Get all event method

  Future<List<JvtFile>> getJvtFiles() async {
    return await database.select(database.jvtFiles).get();
  }

  Future<JvtFile?> getJvtFileSingle() async {
    try {
      return await (database.select(database.jvtFiles)..limit(1))
          .getSingleOrNull();
    } catch (e) {}
    return null;
  }

  /// Delete event with code

  Future<int> deleteJvtFileByCode(String code) async {
    return await (database.delete(database.jvtFiles)
          ..where((tbl) => tbl.code.equals(code)))
        .go();
  }

  /// Update event with code

  Future<void> updateJvtFileByCode(
      JvtFilesCompanion entity, String compare) async {
    await (database.update(database.jvtFiles)
          ..where((tbl) => tbl.code.equals(compare)))
        .write(entity);
  }

  /// Insert new entity

  Future<int> insertJvtFiles(JvtFilesCompanion entity) async {
    return await database.into(database.jvtFiles).insert(entity);
  }

/*  Future<int> insertJvtFile(JvtFilesCompanion entity) async {
    return await database.into(database.jvtFiles).insert(entity);
  }*/
  Future<void> insertAllFile(List<JvtFilesCompanion> jvtFilesCompanion) async {
    showLog('the file length where ${jvtFilesCompanion.length}');
    if (jvtFilesCompanion.isNotEmpty) {
      await database.batch((batch) {
        return batch.insertAllOnConflictUpdate(
            database.jvtFiles, jvtFilesCompanion);
      });
    } else {
      return;
    }
  }

  /// InsertOrUpdate new entity

  Future<int?> insertOrUpdateJvtFiles(
      {required transporterModel.JvtFile file,
      int? eventType,
      bool? isGalleryImages,
      bool? isLogo}) async {
    // get local file row for incoming row
    JvtFile? jvtFile = await getFileWhereCode(file.code!);
    if (jvtFile != null) {
      if (jvtFile.downloaded == 1) {
        return null;
      } else {
        int _priority = (eventType == packages)
            ? 50
            : (eventType == studioCarousel || eventType == studioUtils)
                ? 100
                : (eventType == folderType ||
                        eventType == userAlbum ||
                        isGalleryImages == true)
                    ? 0
                    : (eventType == ImageType.eventCoverImage)
                        ? 90
                        : (eventType == albumCover)
                            ? 80
                            : 0;
        JvtFilesCompanion fileEntity = JvtFilesCompanion(
            isNetworkImage: drift.Value(true),
            name: drift.Value(jvtFile.name),
            size: drift.Value(jvtFile.size),
            code: drift.Value(jvtFile.code),
            mode: drift.Value(jvtFile.mode),
            downloaded: drift.Value(jvtFile.downloaded),
            extension: drift.Value(jvtFile.extension),
            priority: _priority.compareTo(jvtFile.priority) < 0
                ? drift.Value(jvtFile.priority)
                : drift.Value(_priority));
        return await database
            .into(database.jvtFiles)
            .insertOnConflictUpdate(fileEntity);
      }
    } else {
      JvtFilesCompanion fileEntity = JvtFilesCompanion(
          isNetworkImage: drift.Value(true),
          name: drift.Value(file.name!),
          size: drift.Value(file.size!),
          code: drift.Value(file.code!),
          mode: drift.Value(file.mode!),
          downloaded: drift.Value(0),
          //  downloaded: drift.Value(isGalleryImages ? 3 : 0),
          extension: drift.Value(file.extension!),
          priority: (isLogo == true)
              ? drift.Value(100)
              : (eventType == packages)
                  ? drift.Value(50)
                  : (eventType == studioCarousel || eventType == studioUtils)
                      ? drift.Value(100)
                      : (eventType == folderType || eventType == userAlbum)
                          ? drift.Value(0)
                          : (eventType == ImageType.eventCoverImage)
                              ? drift.Value(90)
                              : (eventType == albumCover)
                                  ? drift.Value(80)
                                  : drift.Value(0));
      return await database
          .into(database.jvtFiles)
          .insertOnConflictUpdate(fileEntity);
    }
  }

  Future<JvtFile?> getFileWhereCode(String code) async {
    try {
      return await ((((database.select(database.jvtFiles))..where((tbl) => tbl.code.equals(code)))
            ..limit(1))
          .getSingleOrNull());
    } catch (e) {
      showLog('JVT File DAO Error while getting File >> ${code}\n$e');
      return null;
    }
  }

  Future<DownloadImageModel?> getFileWithPhotoSelection(String code) async {
    try {
      /*
      return await ((((database.select(database.jvtFiles))..where((tbl) => tbl.code.equals(code)))
        ..limit(1))
          .getSingleOrNull());*/

      var query = await ((database.select(database.jvtFiles)
            ..where((tbl) {
              return tbl.code.equals(code);
            }))
            ..limit(1))
          .join([
        drift.innerJoin(
            database.jvtFileConnectors,
            database.jvtFileConnectors.jvtFileCode
                .equalsExp(database.jvtFiles.code)),
        drift.innerJoin(
            database.photoSelectionImages,
            database.photoSelectionImages.code
                .equalsExp(database.jvtFileConnectors.ableCode)),
      ]).getSingleOrNull();

      return DownloadImageModel(
        file: query!.readTableOrNull(database.jvtFiles),
        photoSelectionImages:
            query.readTableOrNull(database.photoSelectionImages),
      );
    } catch (e) {
      showLog('JVT File DAO Error while getting File >> ${code}\n$e');
      return null;
    }
  }

  /*Future<Stream<List<drift.TypedResult>>> getGalleryCoverImage() async {
    final joinQuery = (database.select(database.events)
          ..where((tbl) {
            return (tbl.published.equals(true) & tbl.type.equals(2));
          }))
        .join([
      drift.innerJoin(
          database.albums,
          ((database.albums.published.equals(true)) &
              (database.albums.eventCode.equalsExp(database.events.code)))),
    ]);
    joinQuery.join([drift.innerJoin(
      database.orders,
        database.orders.priority.equals(
          await getOrderWhereCode(database.albums.code),
        )
    )]);
     joinQuery.join([drift.innerJoin(
        database.jvtFileConnectors,
        ((database.jvtFileConnectors.ableCode
            .equalsExp(database.orders.code)) &
        (database.jvtFileConnectors.ableType
            .equals(TransportDataKeys.orders)) &
        (database.jvtFileConnectors.tag
            .equals(TransportDataKeys.originalImage)))
    )]);
    joinQuery.join([
    drift.innerJoin(
        database.jvtFiles,
        ((database.jvtFiles.code
            .equalsExp(database.jvtFileConnectors.jvtFileCode)))
    )
    ]);
    joinQuery.orderBy([drift.OrderingTerm.desc(database.albums.priorityScore)]);
    return joinQuery.watch();
  }*/

  /// get downloaded files
  Future<List<JvtFile>> downloadedFiles() async {
    return await (database.select(database.jvtFiles)
          ..where((tbl) {
            return tbl.downloaded.equals(1);
          }))
        .get();
  }

  /// get downloaded file
  Future<JvtFile> downloadedFile() async {
    return await ((database.select(database.jvtFiles)
          ..where((tbl) {
            return tbl.downloaded.equals(1);
          }))
          ..limit(1))
        .getSingle();
  }

/*  Stream<JvtFile?>? SingleFileStream(String code) {
    try {
      return ((((database.select(database.jvtFiles))..where((tbl) => tbl.code.equals(code)))
            ..limit(1))
          .watchSingleOrNull());
    } catch (e) {
      showLog('JVT File DAO Error while getting File >> ${code}\n$e');
      return null;
    }
  }*/
}
