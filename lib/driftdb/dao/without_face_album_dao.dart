import 'package:photomall_flutter/driftdb/app_db.dart';

class WithoutPersonAlbumDao {
  AppDb database = AppDb();

  Future<void> insertAllWithoutFace(
      List<WithOutPersonsAlbumsCompanion> withOutPersonsAlbumsCompanion) async {
    if (withOutPersonsAlbumsCompanion.isNotEmpty) {
      database.batch((batch) {
        return batch.insertAllOnConflictUpdate(
            database.withOutPersonsAlbums, withOutPersonsAlbumsCompanion);
      });
    }
  }

  Future<WithOutPersonsAlbum?> getWithoutFacesByCode(
      {required String eventCode}) async {
    return await (database.select(database.withOutPersonsAlbums)
          ..where((tbl) {
            return tbl.eventCode.equals(eventCode);
          }))
        .getSingleOrNull();
  }
}
