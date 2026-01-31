import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:workmanager/workmanager.dart';
import '../core/Utils/preference_helper.dart';
import '../core/constants/shared_preference_constants.dart';

class BackgroundTasks {
  @pragma('vm:entry-point')
  Future<void> scheduleBirthdayWish(DateTime birthdayTime, String userName,
      {isAnniversary = false}) async {
    Duration initialDelay = birthdayTime.difference(DateTime.now());
    showLog('scheduleBirthdayWish $initialDelay');
    if (!initialDelay.isNegative) {
      isAnniversary
          ? await PreferenceHelper.setBool(anneWishKey, true)
          : await PreferenceHelper.setBool(BDayWishKey, true);

      Workmanager().registerOneOffTask(
        isAnniversary ? 'Anniversary_task' : 'birthday_wish_task',
        isAnniversary
            ? 'show_anniversary_notification'
            : 'show_birthday_notification',
        inputData: {
          'message': isAnniversary
              ? "Wish you many more years of love and happiness together. Happy wedding anniversary!"
              : 'Wishing you a day filled with love, happiness, and unforgettable moments. Happy birthday ${userName} 🎉'
        },
        // Customizable message
        initialDelay:
            initialDelay > Duration.zero ? initialDelay : Duration.zero,
      );
    } else {
      initialDelay = initialDelay * -1;
      showLog('scheduleBirthdayWish $initialDelay isNegative');
    }
  }

  /* Future<void> scheduleBirthdayWish(DateTime birthdayTime, String userName) async {
    // Ensure the birthday time is in the future
    final now = DateTime.now();
    final DateTime nextBirthdayTime = (birthdayTime.isBefore(now))
        ? DateTime(now.year + 1, birthdayTime.month, birthdayTime.day, birthdayTime.hour, birthdayTime.minute)
        : birthdayTime;

    final Duration initialDelay = nextBirthdayTime.difference(now);
    showLog('scheduleBirthdayWish 1 $initialDelay');

    await PreferenceHelper.setBool(BDayWishKey, true);

    Workmanager().registerOneOffTask(
      'birthday_wish_task',
      'show_birthday_notification',
      inputData: {'message': 'Happy Birthday, ${userName} 🎉'}, // Customizable message
      initialDelay: initialDelay > Duration.zero ? initialDelay : Duration.zero,
    );
  }
*/
  void schedulePhotoSelectionReminder(String eventCode, String eventName) {
    showLog('schedulePhotoSelectionReminder $eventCode , $eventName');
    Workmanager().registerPeriodicTask(
        'photo_selection_reminder_task_$eventCode',
        'show_photo_selection_reminder_notification_$eventCode',
        inputData: {
          'message':
              'Photo Selection in the event : $eventName is yet to be confirmed. Please complete.'
        }, // Customizable message
        initialDelay: Duration(days: 2),
        frequency: Duration(days: 2));
  }

  void cancelPhotoSelectionReminder(String eventCode) {
    Workmanager()
        .cancelByUniqueName('photo_selection_reminder_task_$eventCode');
  }

  void cancelBackgroundTasks() {
    showLog('cancelBackgroundTasks');
    Workmanager().cancelAll();
  }
}
