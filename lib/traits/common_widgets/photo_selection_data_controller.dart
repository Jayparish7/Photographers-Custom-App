import 'dart:convert';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/folder_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_notification_dao.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart'
    as transporter;
import 'package:photomall_flutter/driftdb/utils/folder_dao_utils.dart';
import 'package:photomall_flutter/ui/app_config_request_model.dart'
    as transporterInputModel;

//@pragma('vm:entry-point')
Future<void> getPhotoSelectionData(Map<String, dynamic> map) async {
  try {
    showLog("getPhotoSelectionData ===================== 5 ${map}");

    String photoSelectionCode = map['photoSelectionCode'];

    int? eventType = map['eventType'];

    transporter.TransporterDao transporterDao = transporter.TransporterDao();
    PhotomallApis apiCall = PhotomallApis(null);
    // get photo selection data
    List<transporterInputModel.Event> apiInputData = [];
    appDb.TransportDataData? transportDataData =
        await transporterDao.getSingleTransporterWhereTagUpdateRequiredAndCode(
            TransportDataKeys.photoSelectionData, photoSelectionCode);

    if (transportDataData == null) {
      showLog("getPhotoSelectionData called :: step 0 ::");

      //   port.send("photoSelection step 2 ");

      return;
    }
    showLog("getPhotoSelectionData called :: step 1 ::");
    apiInputData.add(transporterInputModel.Event(
        code: photoSelectionCode,
        lastUpdatedAt: transportDataData.lastUpdatedAt));
    var _inputData = [
      transporterInputModel.InputData(
          key: TransportDataKeys.photoSelectionData, events: apiInputData)
    ];
    if ( _inputData.isNotEmpty) {
      showLog("getPhotoSelectionData called :: step 1 ::");

      var photoSelectionResponse =
          await apiCall.callAppConfiguration(null, inputData: _inputData);
      if (photoSelectionResponse != null &&
          photoSelectionResponse.photoSelectionData != null &&
          photoSelectionResponse.photoSelectionData!.isNotEmpty) {
        showLog("getPhotoSelectionData called :: step 1 ::");

        if (photoSelectionResponse.photoSelectionData![0].updateRequired == 1) {
          await transporterDao.updateDataByCodeAndTag(
            lastUpdatedAt:
                photoSelectionResponse.photoSelectionData![0].lastUpdatedAt,
            eventType: eventType,
            // it can be any type need change (studioGalleyEvent)
            code: photoSelectionCode,
            tag: TransportDataKeys.photoSelectionData,
            data:
                jsonEncode(photoSelectionResponse.photoSelectionData![0].data),
          );


            // insert folder codes to notify
            await notifyFolderCode(
                jsonEncode(photoSelectionResponse.photoSelectionData![0].data),
                photoSelectionCode);


        } else {
          await transporterDao.updateRequiredToggleByCodeAndTag(
              0,
              photoSelectionResponse.photoSelectionData![0].code!,
              TransportDataKeys.photoSelectionData);

        }
      }
    }
  } catch (e) {
    showLog('Exception in getPhotoSelectionData $e');
  }

}

Future<void> notifyFolderCode(
    String? jsonEncodeData, String photoSelectionCode) async {

  FolderModelDao folderModelDao = FolderModelDao();
  List<String> folderCodes = [];
  List<String> oldFolderCodes = [];
  if (jsonEncodeData != null && jsonEncodeData.isNotEmpty) {
    PhotoSelectionData photoSelectionData =
        PhotoSelectionData.fromJson(json.decode(jsonEncodeData));
    List<appDb.Folder> oldFolders = await folderModelDao
        .getFoldersWhereEventCode(eventCode: photoSelectionCode);
    for (appDb.Folder oldFolder in oldFolders) {
      oldFolderCodes.add(oldFolder.code);
    }
    for (FolderData? folder in photoSelectionData.folders!) {
      if (folder != null) {
        folderCodes.add(folder.code!);
      }
    }
    if (folderCodes.isNotEmpty && oldFolderCodes.isNotEmpty) {
      String _folders = folderCodes.join(',');
      String _oldFolders = oldFolderCodes.join(',');
      FolderNotificationDao folderNotificationDao = FolderNotificationDao();
      await folderNotificationDao.insertFolderNotification(
          photoSelectionCode, _folders, _oldFolders);
    }
  }
}

class PhotoSelectionDataController {
  transporter.TransporterDao transporterDao = transporter.TransporterDao();

  Future<void> fillPhotoSelectionResources3() async {
    transporter.TransporterDao _transporterDao = transporter.TransporterDao();
    List<appDb.TransportDataData> _transporters = await _transporterDao
        .getTransporterWhereTag(TransportDataKeys.photoSelectionData);

    for (appDb.TransportDataData photoSelectionData in _transporters) {
      try {
        transporter.TransporterDao transporterDao =
            transporter.TransporterDao();
        PhotoSelectionTableUtils photoSelectionTableUtils =
            PhotoSelectionTableUtils();
        if (photoSelectionData.data != null &&
            photoSelectionData.data!.isNotEmpty) {
          await photoSelectionTableUtils.insertFolders(
            PhotoSelectionData.fromJson(json.decode(photoSelectionData.data!)),
          );
        }

        // flush the data at transporter
        await transporterDao.flushDataByCodeAndTag(
          code: photoSelectionData.code!,
          tag: TransportDataKeys.photoSelectionData,
        );
      } catch (e) {
        showLog('Exception folder view model resource get step 3\n $e');
      }
    }
  }

  Future<void> getPhotoSelectionData(
      {required String photoSelectionCode, bool? isNotification}) async {
    transporter.TransporterDao transporterDao = transporter.TransporterDao();
    PhotomallApis apiCall = PhotomallApis(null);
    // get photo selection data
    List<transporterInputModel.Event> apiInputData = [];
    appDb.TransportDataData? transportDataData =
        await transporterDao.getSingleTransporterWhereTagUpdateRequiredAndCode(
            TransportDataKeys.photoSelectionData, photoSelectionCode);
    if (transportDataData == null) {
      return;
    }
    showLog("getPhotoSelectionData called :: step 1 ::");
    apiInputData.add(transporterInputModel.Event(
        code: photoSelectionCode,
        lastUpdatedAt: transportDataData.lastUpdatedAt));
    var _inputData = [
      transporterInputModel.InputData(
          key: TransportDataKeys.photoSelectionData, events: apiInputData)
    ];
    if ( _inputData.isNotEmpty) {
      showLog("getPhotoSelectionData called :: step 1 ::");

      var eventDetailsResponse =
          await apiCall.callAppConfiguration(null, inputData: _inputData);
      if (eventDetailsResponse != null &&
          eventDetailsResponse.photoSelectionData != null) {
        showLog("getPhotoSelectionData called :: step 1 ::");

        /*       await photoSelectionTableUtils.insertFolders(
            eventDetailsResponse.photoSelectionData, isNotification);*/
      }
    }
  }

}
