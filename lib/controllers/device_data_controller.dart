/*
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporterModel;
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart'
    as transporter;
import 'package:photomall_flutter/controllers/upsert_events.dart';
import 'package:photomall_flutter/ui/app_config_request_model.dart'
    as transporterInputModel;

class DeviceDataController {
  transporter.TransporterDao transporterDao = transporter.TransporterDao();

  Future<void> getDeviceData() async {
    PhotomallApis apiCall = PhotomallApis(null);
    List<appDb.TransportDataData> transportDataData = await transporterDao
        .getTransporterWhereTagAndUpdateRequired(TransportDataKeys.deviceData);
    if (transportDataData.isNotEmpty) {
      /// prepare input for api
      List<transporterInputModel.InputData> inputData = [];
      inputData.add(transporterInputModel.InputData(
          key: TransportDataKeys.deviceData,
          lastUpdatedAt: transportDataData[0].lastUpdatedAt));

      /// call transporter api
      transporterModel.TransportModel? transporterResponse =
          await apiCall.callAppConfiguration(null, inputData: inputData);

      /// Update deviceData
      if (transporterResponse != null &&
      transporterResponse.deviceAppData != null &&
          transporterResponse.deviceAppData!.updateRequired == 1 &&
          transporterResponse.deviceAppData!.data != null) {
        await fillDeviceAppDataResources(transporterResponse);
      } else {
        appDb.TransportDataCompanion _deviceEntity =
            appDb.TransportDataCompanion(
                tag: drift.Value(TransportDataKeys.deviceData),
                code: drift.Value(transportDataData[0].code),
                lastUpdatedAt: drift.Value(
                    transporterResponse!.deviceAppData!.lastUpdatedAt!),
                updateRequired: drift.Value(0));
        await transporterDao.updateTransporterWhereTag(
            _deviceEntity, TransportDataKeys.deviceData);
      }
    }
  }

  fillDeviceAppDataResources(
      transporterModel.TransportModel? transporterResponse) async {
   if(transporterResponse != null) {
      UpsertEvent updateEvents = UpsertEvent();
      await updateEvents.upsertEventInDatabase(
          apiEvents: transporterResponse.deviceAppData!.data!.events!,
          transporterTag: TransportDataKeys.studioData,
          eventType: userEvent);
      appDb.TransportDataCompanion _deviceEntity = appDb.TransportDataCompanion(
          tag: drift.Value(TransportDataKeys.deviceData),
          code: drift.Value(transporterResponse.deviceAppData!.data!.code!),
          lastUpdatedAt:
              drift.Value(transporterResponse.deviceAppData!.lastUpdatedAt!),
          updateRequired: drift.Value(0));
      await transporterDao.updateTransporterWhereTag(
          _deviceEntity, TransportDataKeys.deviceData);
    }
  }
}
*/
