import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/event_controller.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/controllers/upsert_events.dart';
import 'package:photomall_flutter/controllers/upsert_photoSelections.dart';
import 'package:photomall_flutter/controllers/user_person_controller.dart'
    as user;
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporterModel;
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/dao/file_dao.dart';
import 'package:photomall_flutter/driftdb/dao/jvt_file_connector_dao.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart'
    as transporter;
import '../core/Utils/preference_helper.dart';
import '../core/constants/shared_preference_constants.dart';
import '../core/models/apiModels/transport_model/transport_model.dart';
import '../driftdb/dao/transporter_dao.dart';

class UserDataController {
  PhotomallApis apiCall = PhotomallApis(null);
  transporter.TransporterDao transporterDao = transporter.TransporterDao();
  JvtFileConnectorModelDao fileConnectorModelDao = JvtFileConnectorModelDao();
  FileModelDao fileModelDao = FileModelDao();

  Future<transporterModel.TransportModel?> userDataApiCall(
      int lastUpdated) async {
    PhotomallApis data = await PhotomallApis(null);
    TransportModel? response = await data.userDataApi(lastUpdated);
    if (response != null &&
        response.userData!.userDataData != null &&
        response.userData!.userDataData!.accountData!.jvtFileConnectors!
            .isNotEmpty) {
      showLog('userDataApi in condition${response.userData!.userDataData}');

      await PreferenceHelper.setString(
          profileUrlKey,
          response.userData!.userDataData!.accountData!.jvtFileConnectors!.first
              .jvtFile!.name!);
    }
    return response;
  }

  Future<bool> getUserData({isLastUpdatedNull = false}) async {
    /*if (transportDataData != null && transportDataData.isNotEmpty) */
    {
      /// prepare input for api
      /*List<transporterInputModel.InputData> inputData = [];
      inputData.add(transporterInputModel.InputData(
          key: TransportDataKeys.userData,
          lastUpdatedAt: transportDataData[0].lastUpdatedAt));
      showLog('getUserData 1 ${transportDataData}');*/
      String lastUpdated = isLastUpdatedNull
          ? "0"
          : await PreferenceHelper.getString(userDataLastUpdatedKey);
      showLog('fillUserdata lastUpdated $lastUpdated');

      /// call transporter api
      transporterModel.TransportModel? userDataResponse =
          await userDataApiCall(lastUpdated != '' ? int.parse(lastUpdated) : 0);

      /*await apiCall.callAppConfiguration(null, inputData: inputData);*/
      if (userDataResponse != null) {
        if (userDataResponse.userData != null &&
            userDataResponse.userData!.userDataData != null &&
            userDataResponse.userData!.updateRequired == 1) {
          await PreferenceHelper.setString(userDataLastUpdatedKey,
              userDataResponse.userData!.lastUpdatedAt!.toString());
          await fillUserdataResources(userDataResponse);
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }

  /*getUserDataForMultiFaces() async {
    showLog('getUserDataForMultiFaces');
    List<transporterInputModel.InputData> inputData = [];
    inputData.add(transporterInputModel.InputData(
        key: TransportDataKeys.userData,
        lastUpdatedAt: 0));
    transporterModel.TransportModel? transporterResponse =
        await apiCall.callAppConfiguration(null, inputData:inputData );
    if (transporterResponse!.userData != null &&
        transporterResponse.userData!.userDataData != null &&
        transporterResponse.userData!.updateRequired == 1) {
      showLog('getUserDataForMultiFaces1');

      await fillUserdataResources(transporterResponse);
    }
  }*/

  Future<void> deleteUserProfile() async {
    try {
      // get user code
      var appConfigRef = TransporterPreference();
      transporter.UserData? userData = await appConfigRef.getUserData();
      String _userCode = userData!.userDataData!.accountData!.code!;
      fileConnectorModelDao.deleteJvtFileConnectorByAbleCodeAndAbleType(
          _userCode, TransportDataKeys.users);
    } catch (e) {
      showLog(
          "Problem while deleting user profile images :: UserDataController \n ${e}");
    }
  }

  Future<void> deleteUserEventsFromDb() async {
    try {
      showLog("user events deleting...");
      EventModelDao eventModelDao = EventModelDao();
      EventController eventController = EventController();
      TransporterDao transporterDao = TransporterDao();

      // get transporter and delete user data from table
      await transporterDao.deleteTransporterByTag(
          tag: TransportDataKeys.userData);
      await transporterDao.deleteTransporterByTag(
          tag: TransportDataKeys.studioUserData);
      await transporterDao.deleteTransporterByTag(
          tag: TransportDataKeys.albums);
      await transporterDao.deleteTransporterByTag(
          tag: TransportDataKeys.folders);

      List<appDb.Event> events = await eventModelDao.getUserEvent();
      if (events.isNotEmpty) {
        for (appDb.Event event in events) {
          await eventController.deleteEvent(event.code);
        }
      }
      showLog("user events deleted.");
    } catch (e) {
      showLog(
          "Problem while deleting user events :: UserDataController \n ${e}");
    }
  }

  Future<void> fillUserdataResources(
      transporterModel.TransportModel transporterResponse) async {
    // user data save to preference
    user.UserPersonsController userPersonsController =
        user.UserPersonsController();

    showLog('saving user data to preference');
    var appConfigRef = TransporterPreference();
    await appConfigRef.setAppConfigUserData(transporterResponse.userData!);

    if (transporterResponse.userData!.userDataData != null) {
      if (transporterResponse.userData!.userDataData!.studioUserData != null) {
        // await fillStudioUserData(transporterResponse);
      }
      if (transporterResponse.userData!.userDataData!.accountData != null) {
        await PreferenceHelper.setString(userId,
            transporterResponse.userData!.userDataData!.accountData!.code!);
        await PreferenceHelper.setStringList(userMaritalDetailsKey, [
          transporterResponse
                  .userData!.userDataData!.accountData!.dateOfBirth ??
              '',
          transporterResponse.userData!.userDataData!.accountData!.maritalStatus
              .toString(),
          transporterResponse
                  .userData!.userDataData!.accountData!.anniversary ??
              "",
        ]);
        var res = await PreferenceHelper.getString(userId);
        showLog('saved user code ----> $res');
      }
      if (transporterResponse
              .userData!.userDataData!.accountData!.userPersons !=
          null) {
        userPersonsController.upsertUserPerson(
            UserPersonData: transporterResponse
                .userData!.userDataData!.accountData!.userPersons!);
      }

      for (transporterModel.JvtFileConnectors jvtFileConnector
          in transporterResponse
              .userData!.userDataData!.accountData!.jvtFileConnectors!) {
        appDb.JvtFileConnectorsCompanion _fileConnectorEntity =
            appDb.JvtFileConnectorsCompanion(
                code: drift.Value(jvtFileConnector.code!),
                ableCode: drift.Value(transporterResponse
                    .userData!.userDataData!.accountData!.code!),
                ableType: drift.Value(TransportDataKeys.users),
                jvtFileCode: drift.Value(jvtFileConnector.jvtFile!.code!),
                tag: drift.Value(jvtFileConnector.name!));
        await fileConnectorModelDao.insertJvtFilesConnector(
            _fileConnectorEntity,
            device: jvtFileConnector.screenDisplay!);
        appDb.JvtFilesCompanion fileEntity = appDb.JvtFilesCompanion(
          code: drift.Value(jvtFileConnector.jvtFile!.code!),
          size: drift.Value(jvtFileConnector.jvtFile!.size!),
          name: drift.Value(jvtFileConnector.jvtFile!.name!),
          mode: drift.Value(jvtFileConnector.jvtFile!.mode!),
          downloaded: drift.Value(0),
          extension: drift.Value(jvtFileConnector.jvtFile!.extension!),
        );
        fileModelDao.insertOrUpdateFile(fileEntity);
      }

      appDb.TransportDataCompanion _userDataEntity =
          appDb.TransportDataCompanion(
              tag: drift.Value(TransportDataKeys.userData),
              code: drift.Value(
                  transporterResponse
                      .userData!.userDataData!.accountData!.code!),
              lastUpdatedAt:
                  drift.Value(transporterResponse.userData!.lastUpdatedAt!),
              updateRequired: drift.Value(0));
      await transporterDao.updateTransporterWhereTag(
          _userDataEntity, TransportDataKeys.userData);
    }
  }

  fillStudioUserData(
      transporterModel.TransportModel transporterResponse) async {
    TransporterDao transporterDao = TransporterDao();
    if (transporterResponse
            .studioUserData!.studioUserDataDetail!.photoSelections !=
        null) {
      UpsertPhotoSelectionEvent upsertPhotoSelectionEvent =
          UpsertPhotoSelectionEvent();
      await upsertPhotoSelectionEvent.upsertPhotoSelections(
        isUser: true,
        apiEvents: transporterResponse
            .studioUserData!.studioUserDataDetail!.photoSelections!,
      );
    }

    if (transporterResponse
        .studioUserData!.studioUserDataDetail!.archivedEvents!.isNotEmpty) {
      showLog('transporterResponse.studioUserData1');
      EventModelDao eventModelDao = EventModelDao();
      for (String archivedEvent in transporterResponse
          .studioUserData!.studioUserDataDetail!.archivedEvents!) {
        // update in event table archived as true
        await eventModelDao.toggleArchived(true, archivedEvent);
      }
    }

    if (transporterResponse.studioUserData!.studioUserDataDetail!.events !=
        null) {
      showLog(
          'transporterResponse.studioUserData2${transporterResponse.studioUserData!.studioUserDataDetail!.deletion?.code}');
      if (transporterResponse.studioUserData!.studioUserDataDetail!.deletion !=
          null) {
        showLog(
            'accountDeletionStoreApiCallLogin${transporterResponse.studioUserData!.studioUserDataDetail!.deletion?.daysCount}');
        Map<String?, String> deletedData = {
          transporterResponse
                  .studioUserData!.studioUserDataDetail!.deletion?.code:
              transporterResponse
                  .studioUserData!.studioUserDataDetail!.deletion!.daysCount
                  .toString()
        };
        String encodedMap = json.encode(deletedData);
        await PreferenceHelper.setString(isDeletedDataKey, encodedMap);
        await PreferenceHelper.setBool(isDeletedKey, true);
      }

      UpsertEvent updateEvents = UpsertEvent();
      await updateEvents.upsertEventInDatabase(
        eventType: userEvent,
        apiEvents:
            transporterResponse.studioUserData!.studioUserDataDetail!.events,
        transporterTag: TransportDataKeys.userData,
      );
    }

    await transporterDao.updateRequiredLastUpdatedByCodeAndTag(
        transporterResponse.studioUserData!.lastUpdatedAt!,
        null,
        TransportDataKeys.studioUserData);
  }

  fillUserEventData(transporterModel.TransportModel transporterResponse) async {
    TransporterDao transporterDao = TransporterDao();
    if (transporterResponse
        .userEventData!.studioUserDataDetail!.photoSelections!.isNotEmpty) {
      UpsertPhotoSelectionEvent upsertPhotoSelectionEvent =
          UpsertPhotoSelectionEvent();
      await upsertPhotoSelectionEvent.upsertPhotoSelections(
        isUser: true,
        apiEvents: transporterResponse
            .userEventData!.studioUserDataDetail!.photoSelections!,
      );
    }

    if (transporterResponse
        .userEventData!.studioUserDataDetail!.archivedEvents!.isNotEmpty) {
      EventModelDao eventModelDao = EventModelDao();
      for (String archivedEvent in transporterResponse
          .userEventData!.studioUserDataDetail!.archivedEvents!) {
        // update in event table archived as true
        await eventModelDao.toggleArchived(true, archivedEvent);
      }
    }

    if (transporterResponse
        .userEventData!.studioUserDataDetail!.events!.isNotEmpty) {
      UpsertEvent updateEvents = UpsertEvent();
      await updateEvents.upsertEventInDatabase(
        eventType: userEvent,
        apiEvents:
            transporterResponse.userEventData!.studioUserDataDetail!.events,
        transporterTag: TransportDataKeys.userData,
      );
    }

    await transporterDao.updateRequiredLastUpdatedByCodeAndTag(
        transporterResponse.userEventData!.lastUpdatedAt!,
        null,
        TransportDataKeys.userEventData);
  }
}
