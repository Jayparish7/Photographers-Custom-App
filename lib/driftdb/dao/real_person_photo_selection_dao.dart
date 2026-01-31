import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/driftdb/app_db.dart';

class RealPersonPhotoSelectionDao {
  AppDb database = AppDb();

  Future<void> insertAllFace(
      List<RealPersonsPhotoSelectionsCompanion>
          realPersonPhotoSelectionCompanions) async {
    if (realPersonPhotoSelectionCompanions.isNotEmpty) {
      database.batch((batch) {
        return batch.insertAllOnConflictUpdate(
            database.realPersonsPhotoSelections,
            realPersonPhotoSelectionCompanions);
      });
    }
  }

  Future<List<RealPersonsPhotoSelection>> getFaces() async {
    return await database.select(database.realPersonsPhotoSelections).get();
  }

  Future<List<RealPersonsPhotoSelection>> getFacesByEvent(
      {required String eventCode}) async {
    return await (database.select(database.realPersonsPhotoSelections)
          ..where((tbl) {
            return ((tbl.eventCode.equals(eventCode)));
          })
          ..orderBy([(t) => drift.OrderingTerm.desc(t.score)]))
        .get();
  }

  Future<RealPersonsPhotoSelection?> getFacesByCode(
      {required String code}) async {
    return await (database.select(database.realPersonsPhotoSelections)
          ..where((tbl) {
            return tbl.code.equals(code);
          }))
        .getSingleOrNull();
  }

  Future<RealPersonsAlbum?> getFacesByPersonCode({required String code}) async {
    return await (database.select(database.realPersonsAlbums)
          ..where((tbl) {
            return tbl.code.equals(code);
          }))
        .getSingleOrNull();
  }

  Future<void> deletePersons({required String code}) async {
    await (database.delete(database.personsPhotoSelections)
          ..where((tbl) => tbl.code.equals(code)))
        .go();
  }
}
