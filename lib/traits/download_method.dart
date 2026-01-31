import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;

class DownloadImageModel {
  final appDb.JvtFile? file;

  final appDb.PhotoSelectionImage? photoSelectionImages;

  DownloadImageModel({this.file, this.photoSelectionImages});
}
