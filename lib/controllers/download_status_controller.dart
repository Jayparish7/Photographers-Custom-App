import 'dart:io';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/dao/download_status_dao.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;

class DownloadStatusController {
  Future<bool> isImageDownload(
      {required String filePath,
      required String code,
      required String type}) async {
    DownloadStatusModelDao downloadStatusModelDao = DownloadStatusModelDao();
    appDb.DownloadData? downloadStatu = await downloadStatusModelDao
        .getDownloadStatusWhereAble(ableCode: code, ableType: type);
    if (downloadStatu == null) {
      showLog("image row Not available");
      await downloadStatusModelDao.insertDownloadStatus(code, type, false);
      return false;
    } else {
      showLog("image row available");
      if (downloadStatu.downloadedStatus == true) {
        showLog("image row available and downloaded true");
        bool status = await isImageExist(filePath);
        showLog(
            "image row available and downloaded true and physical exist : $status");

        if (status) {
          return true;
        } else {
          await downloadStatusModelDao.insertDownloadStatus(code, type, false);
          return false;
        }
      } else {
        showLog("image row available and downloaded false");
        return false;
      }
    }
  }

  Future<bool> isImageExist(String path) async {
    return await File(path).exists();
  }
}
