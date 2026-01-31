import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart';

class PhotoSelectionCurrentIndex {
  AppDb database = AppDb();

  Future<PhotoSelectionCurrentIndexData?> getCurrentIndex(
      String code, int status) async {
    return await (database.select(database.photoSelectionCurrentIndex)
          ..where((tbl) {
            return ((tbl.folderCode.equals(code)) &
                (tbl.status.equals(status)));
          })
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> updateCurrentIndex(
      {required int status,
      required String photoSelectionCode,
      required String folderCode}) async {
    showLog(">>>>>>>>>> the current index where");

    showLog("$status");
    showLog("$photoSelectionCode");
    showLog("$folderCode");

    showLog(">>>>>>>>>>");

    PhotoSelectionCurrentIndexCompanion entity =
        PhotoSelectionCurrentIndexCompanion(
            status: drift.Value(status),
            photoSelectionCode: drift.Value(photoSelectionCode),
            folderCode: drift.Value(folderCode));
    try {
      await database.into(database.photoSelectionCurrentIndex).insert(
            entity,
            onConflict: drift.DoUpdate((old) => entity, target: [
              database.photoSelectionCurrentIndex.folderCode,
              database.photoSelectionCurrentIndex.status
            ]),
          );
    } catch (e) {
      showLog("the error in this photo selection current index dao\n$e");
    }
  }

  Future<int> deleteCurrentIndex(String code) async {
    return await (database.delete(database.photoSelectionCurrentIndex)
          ..where((tbl) => tbl.folderCode.equals(code)))
        .go();
  }

  /// Insert new entity

  Future<int> insertCurrentIndex(
      {required int status,
      required String photoSelectionCode,
      required String folderCode}) async {
    PhotoSelectionCurrentIndexCompanion entity =
        PhotoSelectionCurrentIndexCompanion(
            status: drift.Value(status),
            photoSelectionCode: drift.Value(photoSelectionCode),
            folderCode: drift.Value(folderCode));
    return await database
        .into(database.photoSelectionCurrentIndex)
        .insert(entity);
  }
/*  Future<void> updateOrderByCode(
      String entity, String compare) async {
    await (database.update(database.orders)
      ..where((tbl) => tbl.code.equals(compare)))
        .write(entity);
  }*/
}
