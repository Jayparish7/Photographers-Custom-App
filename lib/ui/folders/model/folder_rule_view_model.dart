import 'dart:typed_data';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;

class FoldersRuleModel {
  FoldersRuleModel({
    this.folderRule,
    this.folderName,
    this.file,
    this.selectedCount,
    this.satisfied,
    this.shortage,
    this.excess,
  });
  final appDb.FolderRule? folderRule;
  final String? folderName;
  final int? selectedCount;
  final Uint8List? file;
  final int? excess;
  final int? shortage;
  final bool? satisfied;
}
