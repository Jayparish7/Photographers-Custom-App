import 'package:drift/drift.dart' as drift;

import '../app_db.dart';

class RealPersonsDao {
  AppDb database = AppDb();

  Future<void> insertRealAllFaces(
      List<RealPersonsAlbumsCompanion> realPersonAlbumCompanions) async {
    if (realPersonAlbumCompanions.isNotEmpty) {
      database.batch((batch) {
        return batch.insertAllOnConflictUpdate(
            database.realPersonsAlbums, realPersonAlbumCompanions);
      });
    }
  }

  Future<List<RealPersonsAlbum>> getRealFaces() async {
    return await database.select(database.realPersonsAlbums).get();
  }

  Future<List<RealPersonsAlbum>> getRealFacesByEvent(
      {required String eventCode}) async {
    return await (database.select(database.realPersonsAlbums, distinct: true)
          ..where((tbl) {
            return (tbl.eventCode.equals(eventCode));
          })
          ..orderBy([(t) => drift.OrderingTerm.desc(t.score)]))
        .get();
  }

  Future<RealPersonsAlbum?> getRealPersonCodeByCode(
      {required String code}) async {
    return await (database.select(database.realPersonsAlbums)
          ..where((tbl) {
            return tbl.code.equals(code);
          }))
        .getSingleOrNull();
  }

  Future<void> deleteRealPersonsWhereCode({required String code}) async {
    await (database.delete(database.realPersonsAlbums)
          ..where((tbl) => tbl.code.equals(code)))
        .go();
  }
  Future<void> deleteRealPersons() async {
    await (database.delete(database.realPersonsAlbums)
          )
        .go();
  }
}
