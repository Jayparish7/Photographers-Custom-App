import 'package:drift/drift.dart' as drift;
import '../../core/constants/common_constants.dart';
import '../app_db.dart';

class UserPersonsDao {
  AppDb database = AppDb();

  Future<void> insertUserPersons(
      List<UserPersonsCompanion> userPersonCompanion) async {
    if (userPersonCompanion.isNotEmpty) {
      database.batch((batch) {
        return batch.insertAllOnConflictUpdate(
            database.userPersons, userPersonCompanion);
      });
    }
  }

  Future<List<UserPerson>> getUserPersons() async {
    return await database.select(database.userPersons).get();
  }

  Stream<List<UserPerson>> getUserPersonsStream() {
    return database.select(database.userPersons).watch();
  }

  updateUserPersonImages({required String code, required String images}) async {
    showLog('the folder inserting function called${images}');
    return await (database.update(database.userPersons)
          ..where((tbl) => tbl.code.equals(code)))
        .write(UserPersonsCompanion(images: drift.Value(images)));
  }

  Future<void> deleteUserPersons({required String code}) async {
    await (database.delete(database.userPersons)
          ..where((tbl) => tbl.code.equals(code)))
        .go();
    showLog('deleteUserPersons Succeed');
  }

  Future<void> deleteUserPersonsForLogOut() async {
    await (database.delete(database.userPersons)).go();
  }
}
