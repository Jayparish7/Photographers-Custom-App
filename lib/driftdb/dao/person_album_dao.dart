import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/driftdb/app_db.dart';

class PersonAlbumDao {
  AppDb database = AppDb();

  Future<void> insertAllFace(
      List<PersonsAlbumsCompanion> personAlbumCompanions) async {
    if (personAlbumCompanions.isNotEmpty) {
      database.batch((batch) {
        return batch.insertAllOnConflictUpdate(
            database.personsAlbums, personAlbumCompanions);
      });
    }
  }

  Future<List<PersonsAlbum>> getFaces() async {
    return await database.select(database.personsAlbums).get();
  }

  Future<List<PersonsAlbum>> getFacesByEvent(
      {required String eventCode}) async {
    return await (database.select(database.personsAlbums, distinct: true)
          ..where((tbl) {
            return (tbl.eventCode.equals(eventCode));
          })
          ..orderBy([(t) => drift.OrderingTerm.desc(t.score)]))
        .get();
  }

  Future<List<String>> getMultipleImagesWhereEvent({
    required String eventCode,
  }) async {
    final query = database.selectOnly(database.personsAlbums, distinct: true)
      ..addColumns([database.personsAlbums.images])
      ..where(database.personsAlbums.eventCode.equals(eventCode));

    final rows = await query.get();

    return rows
        .map((row) => row.read(database.personsAlbums.images)!)
        .expand((e) => e.split(',')) // Split comma-separated strings
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<PersonsAlbum?> getFacesByCode({required String code}) async {
    return await (database.select(database.personsAlbums)
          ..where((tbl) {
            return tbl.code.equals(code);
          }))
        .getSingleOrNull();
  }

  Future<void> deletePersons({required String code}) async {
    await (database.delete(database.personsAlbums)
          ..where((tbl) => tbl.code.equals(code)))
        .go();
  }
}
