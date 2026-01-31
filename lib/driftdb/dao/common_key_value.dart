import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart';

const DownloadStatus = "download_status";

class CommonKeyValueDao {
  AppDb database = AppDb();

  Future<List<CommonTableData>> getCommonTable() async {
    return await database.select(database.commonTable).get();
  }

  Future<bool> getDownloadStatus(String eventCode) async {
    try {
      CommonTableData? commonTableData =
          await (database.select(database.commonTable)
                ..where((tbl) {
                  return (tbl.key.equals(DownloadStatus));
                })
                ..limit(1))
              .getSingleOrNull();
      if (commonTableData != null) {
        String value = commonTableData.value;
        if (value == eventCode) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkAnythingDownloading() async {
    try {
      CommonTableData? commonTableData =
          await (database.select(database.commonTable)
                ..where((tbl) {
                  return (tbl.key.equals(DownloadStatus));
                })
                ..limit(1))
              .getSingleOrNull();
      if (commonTableData != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<int> insertCommonTable(String key, String value) async {
    return await database.into(database.commonTable).insertOnConflictUpdate(
        CommonTableCompanion(key: drift.Value(key), value: drift.Value(value)));
  }

  Future<void> deleteAllCommonTable() async {
    await (database.delete(database.commonTable)).go();
  }

  Future<void> deleteCommonTableByEvent(String eventCode) async {
    showLog("Deleting table event code  $eventCode");
    await (database.delete(database.commonTable)
          ..where((tbl) => tbl.value.equals(eventCode)))
        .go();
  }
}
