import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporterModel;
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/file_dao.dart';

class DownloadFilesController {
  FileModelDao fileModelDao = FileModelDao();

  String createUrl({
    transporterModel.JvtFile? transporterFile,
    appDb.JvtFile? file,
    required String privatePath,
    required String publicPath,
  }) {
    if (file == null) {
      String url = "";
      url = '$publicPath/${transporterFile!.name}'; // public url
      showLog("the url where 2 profile > ${url}");
      return url;
    }

    String url = "";
    url = '$publicPath/${file.name}'; // public url
    //showLog("the url where 2 > ${url}");
    return url;
  }
}
