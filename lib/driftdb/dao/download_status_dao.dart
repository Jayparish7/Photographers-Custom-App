import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart';

class DownloadStatusModelDao {
  AppDb database = AppDb();

  Future<DownloadData?> getDownloadStatusWhereAble(
      {required String ableCode, required String ableType}) async {
    return await (database.select(database.download)
          ..where((tbl) {
            return (tbl.ableCode.equals(ableCode) &
                tbl.ableType.equals(ableType));
          })
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int?> insertDownloadStatus(
      String ableCode, String ableType, bool status) async {
    try {
      showLog("ableCode $ableCode ableType $ableType  status $status");
      return await database
          .into(database.download)
          .insertOnConflictUpdate(DownloadCompanion(
            ableCode: drift.Value(ableCode),
            ableType: drift.Value(ableType),
            downloadedStatus: drift.Value(status),
          ));
    } catch (e) {
      showLog("Error : $e");

      return null;
    }
  }
}
