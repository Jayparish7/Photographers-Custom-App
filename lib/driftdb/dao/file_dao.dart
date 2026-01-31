import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:drift/drift.dart' as drift;

class FileModelDao {
  AppDb database = AppDb();

  Future<JvtFile?> getStudioLogo() async {
    JvtFileConnector? jvtFileConnector =
        await (database.select(database.jvtFileConnectors)
              ..where((tbl) {
                return tbl.tag.equals(ImageType.studioLogo);
              })
              ..limit(1))
            .getSingleOrNull();
    if (jvtFileConnector == null) {
      showLog("file connector null");
      return null;
    }
    String _jvtFileCode = jvtFileConnector.jvtFileCode;
    return await (database.select(database.jvtFiles)
          ..where((tbl) {
            return ((tbl.code.equals(_jvtFileCode)));
          }))
        .getSingleOrNull();
  }

  Future<JvtFile?> getStudioBanner() async {
    JvtFileConnector? jvtFileConnector =
        await (database.select(database.jvtFileConnectors)
              ..where((tbl) {
                return tbl.tag.equals(ImageType.studioCover);
              })
              ..limit(1))
            .getSingleOrNull();
    if (jvtFileConnector == null) {
      return null;
    }
    String _jvtFileCode = jvtFileConnector.jvtFileCode;
    return await (database.select(database.jvtFiles)
          ..where((tbl) {
            return ((tbl.code.equals(_jvtFileCode)));
          }))
        .getSingleOrNull();
  }

  Future<JvtFile?> getStudioIcon() async {
    JvtFileConnector? jvtFileConnector =
        await (database.select(database.jvtFileConnectors)
              ..where((tbl) {
                return tbl.tag.equals(ImageType.studioIcon);
              })
              ..limit(1))
            .getSingleOrNull();
    if (jvtFileConnector == null) {
      return null;
    }
    String _jvtFileCode = jvtFileConnector.jvtFileCode;
    return await (database.select(database.jvtFiles)
          ..where((tbl) {
            return ((tbl.code.equals(_jvtFileCode)));
          }))
        .getSingleOrNull();
  }

  Future<JvtFile?> getWaterMarkIcon(String eventCode) async {
    JvtFileConnector? jvtFileConnector =
        await (database.select(database.jvtFileConnectors)
              ..where((tbl) {
                return (tbl.tag.equals(ImageType.waterMarkIcon) &
                    tbl.ableCode.equals(eventCode));
              })
              ..limit(1))
            .getSingleOrNull();
    if (jvtFileConnector == null) {
      return null;
    }
    String _jvtFileCode = jvtFileConnector.jvtFileCode;
    return await (database.select(database.jvtFiles)
          ..where((tbl) {
            return ((tbl.code.equals(_jvtFileCode)));
          }))
        .getSingleOrNull();
  }

  Future<JvtFile?> getEventQr(String eventCode) async {
    JvtFileConnector? jvtFileConnector =
        await (database.select(database.jvtFileConnectors)
              ..where((tbl) {
                return (tbl.tag.equals(ImageType.qrCode) &
                    tbl.ableCode.equals(eventCode));
              })
              ..limit(1))
            .getSingleOrNull();
    if (jvtFileConnector == null) {
      return null;
    }
    String _jvtFileCode = jvtFileConnector.jvtFileCode;
    return await (database.select(database.jvtFiles)
          ..where((tbl) {
            return ((tbl.code.equals(_jvtFileCode)));
          }))
        .getSingleOrNull();
  }

  /// Get all file method
  Future<List<JvtFile>> getJvtFile() async {
    return await database.select(database.jvtFiles).get();
  }

  Future<double> getSumOfSizeJvtFile() async {
    double sum = 0;
    List<JvtFile> jvtFiles = await (database.select(database.jvtFiles)).get();
    for (JvtFile jvtFile in jvtFiles) {
      sum = sum + jvtFile.size;
    }
    return sum;
  }

  Future<List<JvtFile>> getJvtFileWhereMode(int mode) async {
    return await (database.select(database.jvtFiles)
          ..where((tbl) => tbl.mode.equals(mode)))
        .get();
  }

  /// Update file with code
  Future<void> updateFileByCode(
      JvtFilesCompanion entity, String compare) async {
    await (database.update(database.jvtFiles)
          ..where((tbl) => tbl.code.equals(compare)))
        .write(entity);
  }

  Future<void> updateFileAttemptByCode(int attempt, String code) async {
    await (database.update(database.jvtFiles)
          ..where((tbl) => tbl.code.equals(code)))
        .write(JvtFilesCompanion(attempt: drift.Value(attempt)));
  }

  Future<void> updateFileAttemptAndNetworkByCode(
      int attempt, String code) async {
    try {
      await (database.update(database.jvtFiles)
            ..where((tbl) => tbl.code.equals(code)))
          .write(JvtFilesCompanion(
              isNetworkImage: drift.Value(true),
              attempt: drift.Value(attempt)));
    } catch (e) {
      showLog("the problem @ updateFileAttemptAndNetworkByCode : \n $e");
    }
  }

  /// Insert file entity
  Future<int> insertFile(JvtFilesCompanion entity) async {
    return await database.into(database.jvtFiles).insert(entity);
  }

  /// InsertOrUpdate new entity
  Future<int> insertOrUpdateFile(JvtFilesCompanion entity) async {
    return await database
        .into(database.jvtFiles)
        .insertOnConflictUpdate(entity);
  }

  Future<void> downloadedStatusToggleByCode(
      int downloadStatus, String code) async {
    try {
      showLog("the problem where @ file dao 10 00 $code");
      await (database.update(database.jvtFiles)
            ..where((tbl) => tbl.code.equals(code)))
          .write(JvtFilesCompanion(
        downloaded: drift.Value(downloadStatus),
      ));
    } catch (e) {
      showLog("the problem where @ file dao 1 $e");
    }
  }

  Future<JvtFile> getFileWhereTDownloadFalse() async {
    return await (database.select(database.jvtFiles)
          ..where((tbl) {
            return (tbl.downloaded.equals(0));
          })
          ..limit(1))
        .getSingle();
  }

  Future<JvtFile?> getFileWhereTDownloadFalseAndAttemptNotEqualToThree() async {
    try {
      return await (database.select(database.jvtFiles)
            ..where((tbl) {
              return ((tbl.downloaded.equals(0)) &
                  ((tbl.attempt.equals(3)).not()) &
                  ((tbl.downloaded.equals(2)).not()) &
                  ((tbl.priority.equals(0)).not()));
            })
            ..limit(1)
            ..orderBy([
              (t) => drift.OrderingTerm(
                  expression: t.priority, mode: drift.OrderingMode.desc)
            ]))
          .getSingleOrNull();
    } catch (e) {
      showLog('the file dao problem is $e');
      return null;
    }
  }

  Future<JvtFile?> getFileWhereCode(String code) async {
    try {
      showLog("the file code try to getting where {$code}");
      return await (database.select(database.jvtFiles)
            ..where((tbl) {
              return (tbl.code.equals(code));
            })
            ..limit(1))
          .getSingleOrNull();
    } catch (e) {
      showLog("the problem in file dao getFileWhereCode :: \n $e");
      return null;
    }
  }

  Stream<JvtFileConnector> streamEventCoverImage(String code) {
    var query = (database.select(database.jvtFileConnectors)
      ..where((tbl) {
        return (tbl.ableCode.equals(code)) &
            (tbl.tag.equals(TransportDataKeys.eventCover));
      }));
    query..limit(1);
    return query.watchSingle().map((rows) {
      return JvtFileConnector(
          jvtFileCode: rows.jvtFileCode,
          tag: rows.tag,
          ableType: rows.ableType,
          ableCode: rows.ableCode,
          code: rows.code);
    });
  }

  Future<List<JvtFile>> getJvtFileWhereAttemptNotZero() async {
    return await (database.select(database.jvtFiles)
          ..where((tbl) {
            return (tbl.attempt.equals(3)) &
                (tbl.downloaded.equals(3).not()) &
                (tbl.isNetworkImage.equals(false));
          }))
        .get();
  }

  Future<void> downloadedStatusToggleAndAttemptByCode(
      int downloadStatus, String code, int attempt) async {
    try {
      await (database.update(database.jvtFiles)
            ..where((tbl) => tbl.code.equals(code)))
          .write(JvtFilesCompanion(
        downloaded: drift.Value(downloadStatus),
        attempt: drift.Value(attempt),
      ));
    } catch (e) {
      showLog("the problem where @ file dao 2 $e");
    }
  }

  Future<JvtFile?> getImageWhereFolderCode(String folderCode) async {
    var query = ((database.select(database.photoSelectionImages)
          ..where((tbl) {
            return tbl.folderCode.equals(folderCode);
          }))
        .join([
      drift.innerJoin(
          database.jvtFileConnectors,
          (database.jvtFileConnectors.ableCode
                  .equalsExp(database.photoSelectionImages.code)) &
              (database.jvtFileConnectors.ableType
                  .equals(TransportDataKeys.photoSelectionImages))),
      drift.innerJoin(
          database.jvtFiles,
          (database.jvtFiles.code
                  .equalsExp(database.jvtFileConnectors.jvtFileCode)) &
              (database.jvtFiles.downloaded.equals(0)) &
              (database.jvtFiles.isNetworkImage.equals(true).not()))
    ])
      ..limit(1));
    return query.map((row) {
      return row.readTableOrNull(database.jvtFiles);
    }).getSingleOrNull();
  }
}
