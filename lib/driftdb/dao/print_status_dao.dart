import '../app_db.dart';

class PrintStatusDao {
  AppDb database = AppDb();

  Future<void> insertPrintStatus(
      List<PrintTableCompanion> printTableCompanion) async {
    if (printTableCompanion.isNotEmpty) {
      database.batch((batch) {
        return batch.insertAllOnConflictUpdate(
            database.printTable, printTableCompanion);
      });
    }
  }

  Future<List<PrintTableData>> getPrintStatus() async {
    return await database.select(database.printTable).get();
  }

  Future<List<PrintTableData>> getPrintStatusByAbleCode(
      {required String ableCode}) async {
    return await (database.select(database.printTable, distinct: true)
          ..where((tbl) {
            return (tbl.ableCode.equals(ableCode));
          }))
        .get();
  }

  Future<List<PrintTableData>> getPrintStatusByEventCode(
      {required String eventCode}) async {
    return await (database.select(database.printTable, distinct: true)
          ..where((tbl) {
            return (tbl.eventCode.equals(eventCode));
          }))
        .get();
  }

  /*Future<PrintTableData?> getRealPersonCodeByCode({required String code}) async {
    return await (database.select(database.realPersonsAlbums)
      ..where((tbl) {
        return tbl.code.equals(code);
      }))
        .getSingleOrNull();
  }*/

  Future<void> deletePrintStatus({required String code}) async {
    await (database.delete(database.printTable)
          ..where((tbl) => tbl.ableCode.equals(code)))
        .go();
  }
}
