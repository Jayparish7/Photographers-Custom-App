import 'package:photomall_flutter/driftdb/app_db.dart';

class PhotomallStudioInfoDao {
  AppDb database = AppDb();

  Future<List<PhotomallStudioInfoData>> getStudioInfo() async {
    return await database.select(database.photomallStudioInfo).get();
  }

  Future<List<PhotomallStudioInfoData>> getStudioInfosByCode(
      String studioCode) async {
    return await (database.select(database.photomallStudioInfo)
          ..where((tbl) => tbl.code.equals(studioCode)))
        .get();
  }

  Future<PhotomallStudioInfoData?> getStudioInfoByCode(String code) async {
    return await (database.select(database.photomallStudioInfo)
          ..where((tbl) => tbl.code.equals(code))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Delete video with code

  Future<int> deleteStudioInfoByCode(String code) async {
    return await (database.delete(database.photomallStudioInfo)
          ..where((tbl) => tbl.code.equals(code)))
        .go();
  }

  /// Update event with code

  /// Insert new entity

  Future<int> insertStudioInfo(PhotomallStudioInfoCompanion entity) async {
    return await database
        .into(database.photomallStudioInfo)
        .insertOnConflictUpdate(entity);
  }

  Future<void> insertAllStudioInfo(
      {required List<PhotomallStudioInfoCompanion> infoCompanions}) async {
    await database.batch((batch) {
      return batch.insertAllOnConflictUpdate(
          database.photomallStudioInfo, infoCompanions);
    });
  }
}
