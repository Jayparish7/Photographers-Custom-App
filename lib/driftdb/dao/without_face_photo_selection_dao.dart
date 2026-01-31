import 'package:photomall_flutter/driftdb/app_db.dart';

class WithoutPersonPhotoSelectionDao {
  AppDb database = AppDb();

  Future<void> insertAllWithoutFace(
      WithOutPersonsPhotoSelectionCompanion
          withOutPersonsPhotoSelectionsCompanion) async {
    database
        .into(database.withOutPersonsPhotoSelection)
        .insertOnConflictUpdate(withOutPersonsPhotoSelectionsCompanion);
  }

  Future<WithOutPersonsPhotoSelectionData?> getWithoutFacesByCode(
      {required String eventCode}) async {
    return await (database.select(database.withOutPersonsPhotoSelection)
          ..where((tbl) {
            return tbl.eventCode.equals(eventCode);
          }))
        .getSingleOrNull();
  }
}
