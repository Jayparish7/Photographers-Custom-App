import 'package:photomall_flutter/controllers/event_info_controller.dart';
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/preference/preference_model/event_info_preference_model.dart';

class EventInfoDao {
  AppDb database = AppDb();

  Future<void> insertAll(List<EventInfoCompanion> eventInfoCompanions) async {
    await database.batch((batch) {
      batch.insertAllOnConflictUpdate(database.eventInfo, eventInfoCompanions);
    });
  }

  Future<EventInfoData?> getInfoByCode(String code) async {
    return await (database.select(database.eventInfo)
          ..where((tbl) => tbl.eventCode.equals(code))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> insertEventInfo(EventInfoPreference data) async {
    EventInfoController eventInfoController = EventInfoController();
    String value =
        await eventInfoController.convertEventInfoObjectToString(data);
    EventInfoCompanion entity;
    entity = EventInfoCompanion(
        eventCode: drift.Value(data.eventInfo!.data!.code!),
        value: drift.Value(value));
    return await database.into(database.eventInfo).insert(entity);
  }

  Future<int> deleteEventInfo(String code) async {
    return await (database.delete(database.eventInfo)
          ..where((tbl) => tbl.eventCode.equals(code)))
        .go();
  }
}
