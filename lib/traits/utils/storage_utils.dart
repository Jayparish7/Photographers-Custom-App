import 'package:drift/drift.dart' as drift;
import 'package:path_provider/path_provider.dart';
import 'package:photomall_flutter/controllers/event_data_controller.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporterModel;
import 'package:photomall_flutter/core/notification/notificationMethods/local_notification_method.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';
import 'package:photomall_flutter/traits/common_widgets/photo_selection_data_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? studioPublicPath;
String? studioPrivatePath;
String? appDocumentDirectoryPath;
String? appStudioName;
String? appStudioShorten;

class EssentialUtils {
  loadAppEssentialData() async {
    appDocumentDirectoryPath = (await getApplicationDocumentsDirectory()).path;
    var appConfig = TransporterPreference();
    transporterModel.TransportModel? studioDetails =
        await appConfig.getAppConfig();
    if (studioDetails != null && studioDetails.studioData!.data != null) {
      studioPublicPath = studioDetails.studioData!.data!.publicStoragePath;
      studioPrivatePath = studioDetails.studioData!.data!.privateStoragePath;
      appStudioName = studioDetails.studioData!.data!.name;
      appStudioShorten = studioDetails.studioData!.data!.shortUrl;
    }
  }

  Future<void> insertEssentialDataAtTransporter() async {
    List<appDb.TransportDataCompanion> initialInputData = [
      appDb.TransportDataCompanion(
          code: drift.Value(null),
          tag: drift.Value(
            TransportDataKeys.designData,
          ),
          lastUpdatedAt: drift.Value(0),
          updateRequired: drift.Value(1)),
      appDb.TransportDataCompanion(
          code: drift.Value(null),
          tag: drift.Value(
            TransportDataKeys.studioData,
          ),
          lastUpdatedAt: drift.Value(0),
          updateRequired: drift.Value(1)),
    ];
    // check login and insert needful data
    var pref = await SharedPreferences.getInstance();
    bool loggedIn = await pref.getBool('$isUserLoggedInPreferenceKey') ?? false;
    if (loggedIn) {
      initialInputData.add(appDb.TransportDataCompanion(
          code: drift.Value(null),
          tag: drift.Value(TransportDataKeys.userData),
          lastUpdatedAt: drift.Value(0),
          updateRequired: drift.Value(1)));
    } else {
      //initialInputData.add(appDb.TransportDataCompanion(
          //code: drift.Value(null),
         // tag: drift.Value(TransportDataKeys.deviceData),
        //  lastUpdatedAt: drift.Value(0),
        //  updateRequired: drift.Value(1)));
    }
    // insert essential in transporter table

    TransporterDao transporterDao = TransporterDao();
    for (appDb.TransportDataCompanion transporter in initialInputData) {
      await transporterDao.insertOrUpdateTransporter(
          code: transporter.code.value, tag: transporter.tag.value);
    }
  }

  Future<void> triggerToFillDataInserted() async {
    try {
      LocalNotification localNotification = LocalNotification();
      showLog('triggerToFill 1');
      EventDataController eventDataController = EventDataController();
      await eventDataController.prepareAndFillEventData();
      showLog('triggerToFill 2');

      // fill photo selection resources
      PhotoSelectionDataController photoSelectionDataController =
          PhotoSelectionDataController();
      showLog('triggerToFill 3');

      await photoSelectionDataController.fillPhotoSelectionResources3();
      showLog('triggerToFill 4');

      await localNotification.showNotificationForNewEntry();
      showLog('triggerToFill 5');
    } catch (e, s) {
      showLog("Error : triggerToFillDataInserted $e $s ");
    }
  }
}
