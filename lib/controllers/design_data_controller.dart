import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/language_controller.dart';
import 'package:photomall_flutter/controllers/login_controller.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporterModel;
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart'
    as transporter;
import 'package:photomall_flutter/ui/app_config_request_model.dart'
    as transporterInputModel;

class DesignDataController {
  transporter.TransporterDao transporterDao = transporter.TransporterDao();
  TransporterPreference transporterPreference = TransporterPreference();

  ///   [1] get design data details from Database
  Future<dynamic> getDesignData() async {
    showLog('design data step 1');
    PhotomallApis apiCall = PhotomallApis(null);
    showLog('design data step 2');

    List<appDb.TransportDataData> transportDataData = await transporterDao
        .getTransporterWhereTagAndUpdateRequired(TransportDataKeys.designData);

    showLog('design data step 3 ${transportDataData.length} ');

    if (transportDataData.isNotEmpty) {
      showLog('design data step 4');

      /// prepare input for api
      List<transporterInputModel.InputData> inputData = [];
      showLog('design data step 5');

      inputData.add(transporterInputModel.InputData(
          key: TransportDataKeys.designData,
          lastUpdatedAt: transportDataData[0].lastUpdatedAt));
      showLog('design data step 6');

      /// call transporter api
      transporterModel.TransportModel? transporterResponse =
          await apiCall.callAppConfiguration(null, inputData: inputData);
      showLog('design data step 7');
      if (transporterResponse != null &&
          transporterResponse.designData != null &&
          transporterResponse.designData!.data != null &&
          transporterResponse.designData!.updateRequired == 1) {
        await fillDesignDataResources(transporterResponse);
      } else {
        /// toggle last updated at and update required
        appDb.TransportDataCompanion _designEntity =
            appDb.TransportDataCompanion(
                tag: drift.Value(TransportDataKeys.designData),
                lastUpdatedAt: drift.Value(
                    transporterResponse!.designData!.lastUpdatedAt!),
                updateRequired: drift.Value(0));
        await transporterDao.updateTransporterWhereTag(
            _designEntity, TransportDataKeys.designData);
      }
    }
  }

  fillDesignDataResources(
      transporterModel.TransportModel? transporterResponse) async {
    if (transporterResponse != null) {
      /// set app countries
      if (transporterResponse.designData!.data!.countries!.isNotEmpty) {
        await transporterPreference
            .setDesignData(transporterResponse.designData!);
        LoginController loginController = LoginController();
        await loginController.setCountries();
      }

      /// set app color in preference
      if (transporterResponse.designData!.data!.appDesignKeys != null) {
        Map<String, dynamic> appDesignKeys =
            transporterResponse.designData!.data!.appDesignKeys!;
        await transporterPreference.setColour(colorDatum: appDesignKeys);
      }

      /// languages
      if (transporterResponse.designData!.data!.studioLanguages != null) {
        List<dynamic> language =
            transporterResponse.designData!.data!.studioLanguages!;
        await transporterPreference.setLanguages(languageData: language);
        AppLanguage appLanguage = AppLanguage();
        await appLanguage.getLanguages();
      }

      /// toggle last updated at and update required

      appDb.TransportDataCompanion _designEntity = appDb.TransportDataCompanion(
          tag: drift.Value(TransportDataKeys.designData),
          lastUpdatedAt:
              drift.Value(transporterResponse.designData!.lastUpdatedAt!),
          updateRequired: drift.Value(0));
      await transporterDao.updateTransporterWhereTag(
          _designEntity, TransportDataKeys.designData);
    }
  }
}

class CountryDropDownValue {
  final int? id;
  final String? code;

  CountryDropDownValue({this.id, this.code});
}
