import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/notification/notification_utils.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';
import 'package:photomall_flutter/ui/app_config_request_model.dart';

class TransporterController {
  TransporterDao transporterDao = TransporterDao();

  updateTransporterByNotification(
      AppConfigRequest data, String notificationCode) async {
    // insert or update process for transporter
    NotificationUtils notificationUtils = NotificationUtils();
    notificationUtils.sendNotificationReceivedStatus(notificationCode);
    if (data.inputData!.first.key == TransportDataKeys.userData) {
      // user data
      await transporterDao.insertOrUpdateTransporter(
          isNotification: true, code: null, tag: data.inputData!.first.key);
    } else if (data.inputData!.first.key == TransportDataKeys.designData) {
      await transporterDao.insertOrUpdateTransporter(
          isNotification: true, code: null, tag: data.inputData!.first.key);
    } //else if (data.inputData!.first.key == TransportDataKeys.deviceData) {
     // await transporterDao.insertOrUpdateTransporter(
       //   isNotification: true, code: null, tag: data.inputData!.first.key);}
    else if (data.inputData!.first.key == TransportDataKeys.eventData) {
      String code = data.inputData!.first.events!.first.code!;
      String? tag = data.inputData!.first.key;
      await transporterDao.insertOrUpdateTransporter(
          isNotification: true, code: code, tag: tag);
    } else if (data.inputData!.first.key ==
        TransportDataKeys.photoSelectionData) {
      String code = data.inputData!.first.events!.first.code!;
      await transporterDao.insertOrUpdateTransporter(
          isNotification: true, code: code, tag: data.inputData!.first.key);
    }
    if (data.inputData!.first.key == TransportDataKeys.studioData) {
      await transporterDao.insertOrUpdateTransporter(
          isNotification: true, code: null, tag: data.inputData!.first.key);
    }

    EssentialUtils essentialUtils = EssentialUtils();
    await essentialUtils.triggerToFillDataInserted();
  }
}
