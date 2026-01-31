import 'package:flutter/material.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/core/constants/page_constants.dart';

class SendNotification {
  BuildContext? context;
  PhotomallApis? apiRepo;

  SendNotification(this.context) {
    this.apiRepo = PhotomallApis(this.context);
  }

  send(int fromPage, int imageOrFileId) async{
    var notificationMap;
    if (fromPage == PageConstants.EVENT_LIST ||
        fromPage == PageConstants.PROFILE ||
        fromPage == PageConstants.AUDIO) {
      notificationMap = {
        PageConstants.TYPE: PageConstants.ERROR_403_WHILE_FILE_DOWNLOAD,
        PageConstants.FILE_ID_DATA: imageOrFileId,
      };
    } else if (fromPage == PageConstants.ALBUM_IMAGE_API) {
      notificationMap = {
        PageConstants.TYPE: PageConstants.ERROR_FAILED_FROM_IMAGE_RESPONSE,
        PageConstants.IMAGE_ID_DATA: imageOrFileId,
      };
    } else if (fromPage == PageConstants.AUDIO) {
      notificationMap = {
        PageConstants.TYPE: PageConstants.ERROR_FAILED_FROM_FILE_RESPONSE,
        PageConstants.FILE_ID_DATA: imageOrFileId,
      };
    } else {
      notificationMap = {
        PageConstants.TYPE: PageConstants.ERROR_403_WHILE_IMAGE_DOWNLOAD,
        PageConstants.IMAGE_ID_DATA: imageOrFileId,
      };
    }
    await apiRepo!.notificationCall(notificationMap);
  }
}
