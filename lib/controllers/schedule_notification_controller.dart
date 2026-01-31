import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/generated/l10n.dart';

class DateAndTimeUtils {
  Future<void> setReminder(
      {DateTime? date,
      String? startDate,
      String? endDate,
      title,
      context}) async {
    showLog(
        'the start time and end time where \n start:$startDate \n end:$endDate \n  title: $title');
    DateTime? start;
    DateTime? end;
    try {
      if (startDate != null && startDate.isNotEmpty) {
        start = DateTime.parse(startDate);
      }
      if (endDate != null && endDate.isNotEmpty) {
        end = DateTime.parse(endDate);
      }
    } catch (e) {
      showLog("[ Exception ] : On date time parsing $e");
    }

    PermissionStatus permissionStatus = await Permission.calendar.status;
    if (!permissionStatus.isGranted) {
      PermissionStatus _permissionStatus = await Permission.calendar.request();
      if (!_permissionStatus.isGranted) {
        // toast permission denied
        ToastUtil.showSnackBarAtCurrentState(S.of(context).permissionDenied);
        return;
      }
    }
    try {
      Add2Calendar.addEvent2Cal(Event(
        startDate: start!,
        endDate: end ?? start,
        title: title ?? "",
        description: "",
        iosParams: IOSParams(
          reminder: Duration(minutes: 40),
          url: "",
        ),
        androidParams: AndroidParams(
          emailInvites: [""],
        ),
      ));
    } catch (e) {
      showLog('DateAndTimeUtils :: setReminder :: $e');
    }
  }
}
