import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;
import 'package:drift/drift.dart' as drift;

class FolderRulesDao {
  AppDb database = AppDb();

  insert(FolderRulesCompanion folderRulesCompanion) async {
    return await database
        .into(database.folderRules)
        .insert(folderRulesCompanion);
  }

  Future<FolderRule?> getFolderRuleByFolderCode(String code) async {
    return await (database.select(database.folderRules)
          ..where((tbl) {
            return (tbl.folderCode.equals(code));
          })
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> deleteFolderRulesBYFolderCode(String code) async {
    await (database.delete(database.folderRules)
          ..where((tbl) {
            return tbl.folderCode.equals(code);
          }))
        .go();
  }

  insertOrUpdateFolderRule(
      {required transporter.Rules folderRule,
      required String folderCode}) async {
    showLog('folder rule inserted');
    FolderRulesCompanion folderRulesCompanion = FolderRulesCompanion(
      code: drift.Value(folderRule.code!),
      folderCode: drift.Value(folderCode),
      minimumSelectionImages:
          drift.Value(folderRule.minimumSelectionImages ?? 0),
      maximumSelectionImages:
          drift.Value(folderRule.maximumSelectionImages ?? 0),
      result: drift.Value(0),
    );
    return await database
        .into(database.folderRules)
        .insertOnConflictUpdate(folderRulesCompanion);
  }
}
