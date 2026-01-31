import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/notification/notificationMethods/trigger_api_call_by_notification.dart';
import 'package:photomall_flutter/preference/preference_model/notification_preference_model.dart';

class NotificationPreference {
  // busyNotifyKey;
  // notifyObjectKey;
  Future<void> setNotifyBusy(bool value) async {
    showLog("setting notification block to $value");
    try {
      await PreferenceHelper.setBool(busyNotifyKey, value);
      if (value == false) {
        List<RemoteMessage>? remoteMessages = await getNotifyObject();
        if (remoteMessages != null && remoteMessages.isNotEmpty) {
          for (RemoteMessage remoteMessage in remoteMessages) {
            showLog("notify one by one >> :: ");
            await TriggerNotification.triggerNotification(remoteMessage);
          }
          // trash the notify objects already performed
          await setNotifyObjectAsEmpty();
        }
      }
    } catch (e) {
      showLog('Error : in notify preference 1 $e');
    }
  }

  Future<bool> getNotifyBusy() async {
    return await PreferenceHelper.getBool(busyNotifyKey);
  }

  Future<void> setNotifyObject(RemoteMessage message) async {
    try {
      List<RemoteMessage>? remoteMessage = await getNotifyObject();
      if (remoteMessage == null) {
        List<RemoteMessage> _messages = [];
        _messages.add(message);

        await PreferenceHelper.setString(
            notifyObjectKey, messageToJson(_messages));
      } else {
        List<RemoteMessage> _messages = [];
        _messages.addAll(remoteMessage);
        _messages.add(message);
        await PreferenceHelper.setString(
            notifyObjectKey, messageToJson(_messages));
      }
    } catch (e) {
      showLog('Error : in notify preference 2 $e');
    }
  }

  Future<List<RemoteMessage>?> getNotifyObject() async {
    String encodedMap = await PreferenceHelper.getString(notifyObjectKey);
    if (encodedMap.isNotEmpty) {
      return messageFromJson(encodedMap);
    } else {
      return null;
    }
  }

  Future<void> setNotifyObjectAsEmpty() async {
    await PreferenceHelper.setString(notifyObjectKey, '');
  }
}
