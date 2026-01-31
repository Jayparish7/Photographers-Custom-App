import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/driftdb/app_db.dart';

class FolderNotificationDao {
  AppDb database = AppDb();

  Future<List<FolderNotificationData>> getFolderNotification() async {
    return await (database.select(database.folderNotification)).get();
  }

  Future<int> insertFolderNotification(
      String eventCode, String folders, String oldFolders) async {
    return await database
        .into(database.folderNotification)
        .insertOnConflictUpdate(FolderNotificationCompanion(
          eventCode: drift.Value(eventCode),
          folderCodes: drift.Value(folders),
          oldFolderCodes: drift.Value(oldFolders),
        ));
  }

  Future<int> flushFolderNotifiedRow(String eventCode) async {
    return await (database.delete(database.folderNotification)
          ..where((tbl) => tbl.eventCode.equals(eventCode)))
        .go();
  }
}
