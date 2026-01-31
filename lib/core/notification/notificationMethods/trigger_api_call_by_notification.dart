import 'dart:convert';

import 'package:firebase_messaging_platform_interface/src/remote_message.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/event_ai_data_controller.dart';
import 'package:photomall_flutter/controllers/image_server_controller.dart';
import 'package:photomall_flutter/controllers/pm_job_controller.dart';
import 'package:photomall_flutter/controllers/transporter_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/notification_constants.dart';
import 'package:photomall_flutter/core/notification/notificationMethods/local_notification_method.dart';
import 'package:photomall_flutter/core/notification/notification_utils.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_table_dao.dart';
import 'package:photomall_flutter/notification/custom_notification_model.dart';
import 'package:photomall_flutter/notification/photo_selection_incomplete_model.dart';
import 'package:photomall_flutter/preference/preference_handler/notification_preference.dart';
import 'package:photomall_flutter/ui/app_config_request_model.dart';

import '../../../driftdb/dao/person_album_dao.dart';
import '../../Utils/preference_helper.dart';
import '../../constants/shared_preference_constants.dart';
import '../../models/apiModels/myPhotos_images_response_model.dart';

class TriggerNotification {
  static Future<void> triggerNotification(RemoteMessage message,
      {bool? isBackGround}) async {
    try {
      if (isBackGround != true) {
        NotificationPreference notificationPreference =
            NotificationPreference();
        bool status = await notificationPreference.getNotifyBusy();
        if (status == true) {
          await notificationPreference.setNotifyObject(message);
          return;
        }
      }
      TransporterController transporterController = TransporterController();
      if (message.data['notification_key'] ==
          NotificationConstant.transporter) {
        // up date transporter table by given value

        await transporterController.updateTransporterByNotification(
            appConfigRequestFromJson(
                (json.decode(jsonEncode(message.data['values'])))),
            (json.decode(
                jsonEncode(message.data['android_data_notification_code']))));
      } else if (message.data['notification_key'] ==
          NotificationConstant.photoSelectionConfirmation) {
        showLog(
            "Photo selection submitted info notification::>>${message.data['values']}");

        /// call api to inform notification received
        NotificationUtils notificationUtils = NotificationUtils();
        notificationUtils.sendNotificationReceivedStatus(
            message.data['android_data_notification_code']);
        // up date transporter table by given value
        String data = json.decode(jsonEncode(message.data['values']));
        String eventCode = "${json.decode(data)['event_code']}";
        String photoSelectionCode =
            "${json.decode(data)['photoselection_code']}";
        String confirmedStatus = "${json.decode(data)['confirmed_status']}";
        PhotoSelectionsDao photoSelectionsDao = PhotoSelectionsDao();
        photoSelectionsDao.toggleSubmittedStatusByCodes(
            code: photoSelectionCode,
            eventCode: eventCode,
            status: confirmedStatus);
      } else if (message.data['notification_key'] ==
          NotificationConstant.imageServer) {
        /// call api to inform notification received
        NotificationUtils notificationUtils = NotificationUtils();
        notificationUtils.sendNotificationReceivedStatus(
            message.data['android_data_notification_code']);
        showLog(
            'image server  status changed to ${(json.decode(jsonEncode(message.data['values']["image_server_status"])))}');
        ImageServer imageServer = ImageServer();
        bool status = (json
            .decode(jsonEncode(message.data['values']["image_server_active"])));
        imageServer.setServerStatus(status);
        List<appDb.JvtFile>? files = await imageServer.getFailedImages();
        if (files != null) {
          //  imageServer.initiateReDownload(files);
        }
      } else if (message.data['notification_key'] ==
          NotificationConstant.customNotification) {
        showLog('customNotification received1');

        /// call api to inform notification received
        NotificationUtils notificationUtils = NotificationUtils();
        notificationUtils.sendNotificationReceivedStatus(
            message.data['android_data_notification_code']);
        CustomNotificationModel? data = customNotificationModelFromJson(
            (json.decode(jsonEncode(message.data['values']))));
        LocalNotification localNotification = LocalNotification();
        PersonAlbumDao personAlbumDao = PersonAlbumDao();

        final values = jsonDecode(message.data['values']);
        var eventCode = values['input_data'][0]['photomall_event_code'];
        var images = await personAlbumDao.getMultipleImagesWhereEvent(
            eventCode: eventCode);
        await getUnAuthUserMyPhotosImagesFromApi(eventCode: eventCode);
        var imagesAfterUpdate = await personAlbumDao
            .getMultipleImagesWhereEvent(eventCode: eventCode);
        showLog("getMultipleImagesWhereEvent ${images.length}");
        if (images.length != imagesAfterUpdate.length) {
          await localNotification.showLocalNotification(data. imgUrl,
              data.title ?? "My Photos", data.content ?? "Click to continue",
              payload: (json.decode(jsonEncode(message.data['values']))));
        }
        return;
      } else if (message.data['notification_key'] ==
          NotificationConstant.incompletePhotoSelection) {
        showLog('customNotification received');

        /// call api to inform notification received
        NotificationUtils notificationUtils = NotificationUtils();
        notificationUtils.sendNotificationReceivedStatus(
            message.data['android_data_notification_code']);
        PendingNotificationModel? data = pendingNotificationModelFromJson(
            (json.decode(jsonEncode(message.data['values']))));
        LocalNotification localNotification = LocalNotification();
        String? eventCoed = data.eventCode;
        String? imageURL;
        if (eventCoed != null) {
          DownloadPath? downloadPath =
              await localNotification.getDownloadPath();
          EventModelDao eventModelDao = EventModelDao();
          appDb.JvtFile? file =
              await eventModelDao.getEventCoverByCode(eventCoed);
          imageURL = "${downloadPath.public}/${file!.name}";
        }
        String playLoad1 = await localNotification.getPlayLoad(eventCoed);
        await localNotification.showLocalNotification(
            imageURL,
            data.title ?? "Photo selection complete",
            data.message ?? "Have a nice day",
            payload: playLoad1);
        return;
      }
    } catch (e, s) {
      showLog("error on notification $e");
      showLog("error on notification $s");
    }
  }

  static getUnAuthUserMyPhotosImagesFromApi({required String eventCode}) async {
    String? uUCode =
        await PreferenceHelper.getValueForKey(eventCode!, unAuthUserKey);
    bool isLoggedIn =
        await PreferenceHelper.getBool(isUserLoggedInPreferenceKey);

    try {
      PhotomallApis apiRepo = PhotomallApis(null);
      MyPhotosImages? response =
          (isLoggedIn != true && uUCode != '' && uUCode != null)
              ? await apiRepo.unAuthUserMyPhotosApi(uUCode: uUCode)
              : await apiRepo.myPhotosImagesApi(
                  eventCode: eventCode, lastUpdatedAt: 0);

      if (response != null) {
        EventAiDataController eventAiDataController = EventAiDataController();
        await eventAiDataController.fillMyPhotosEventResources(
            response, eventCode);
      }
    } catch (e) {
      showLog("exception in getUnAuthUserMyPhotosImages $e");
    }
  }
}
