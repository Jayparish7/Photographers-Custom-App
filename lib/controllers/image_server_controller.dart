import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/file_dao.dart';

class ImageServer {
  static bool? serverStatusUp;

  Future<void> setServerStatus(bool status) async {
    showLog("the server status set where $status");
    await PreferenceHelper.setBool(servetStatusKey, status);
    serverStatusUp = status;
  }

  Future<bool> getServerStatus() async {
    // try{
    return await PreferenceHelper.getBool2(servetStatusKey);
    // }catch(e){
    //   showLog(e);
    //   return true;
    // }
  }

  Future<List<appDb.JvtFile>?> getFailedImages() async {
    try {
      FileModelDao fileModelDao = FileModelDao();
      // get all failed images
      List<appDb.JvtFile> files =
          await fileModelDao.getJvtFileWhereAttemptNotZero();
      return files;
    } catch (e) {
      showLog("problem in image server file ${e}");
      return null;
    }
  }
}
