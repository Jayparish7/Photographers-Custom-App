import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/driftdb/app_db.dart';

class PersonPhotoSelectionDao {
  AppDb database = AppDb();

  Future<void> insertAllFace(
      List<PersonsPhotoSelectionsCompanion>
          personPhotoSelectionCompanions) async {
    if (personPhotoSelectionCompanions.isNotEmpty) {
      database.batch((batch) {
        return batch.insertAllOnConflictUpdate(
            database.personsPhotoSelections, personPhotoSelectionCompanions);
      });
    }
  }

  Future<List<PersonsPhotoSelection>> getFaces() async {
    return await database.select(database.personsPhotoSelections).get();
  }

  Future<List<PersonsPhotoSelection>> getFacesByEvent(
      {required String eventCode}) async {
    return await (database.select(database.personsPhotoSelections)
          ..where((tbl) {
            return ((tbl.eventCode.equals(eventCode)));
          })
          ..orderBy([(t) => drift.OrderingTerm.desc(t.score)]))
        .get();
  }

  Future<PersonsPhotoSelection?> getFacesByCode({required String? code}) async {
    return await (database.select(database.personsPhotoSelections)
          ..where((tbl) {
            return tbl.code.equals(code!);
          }))
        .getSingleOrNull();
  }

  Future<PersonsAlbum?> getFacesByPersonCode({required String code}) async {
    return await (database.select(database.personsAlbums)
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
