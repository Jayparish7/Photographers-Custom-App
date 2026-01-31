import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/event_data_controller.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';
import 'package:photomall_flutter/traits/common_widgets/photo_selection_data_controller.dart';
import 'event_ai_data_controller.dart';

List<Country>? allCountries;

class LoginController {
  setCountries() async {
    TransporterPreference transporterPreference = TransporterPreference();
    DesignData? designData = await transporterPreference.getDesignData();
    if (designData != null) {
      final List<Country>? jsonMap =
          designData.data!.countries!.map((e) => Country.fromJson(e)).toList();
      allCountries = jsonMap;
    }
  }

  Country? getObjectByCountryId(int _id) {
    Country foundedCountry;
    for (Country country in allCountries!) {
      int? id = country.id;
      if (_id == id) {
        foundedCountry = country;
        return foundedCountry;
      }
    }
    return null;
  }

  Country? getObjectByCountryCode(String _code) {
    Country foundedCountry;
    for (Country country in allCountries!) {
      String? code = country.shortCode;
      if (_code == code) {
        foundedCountry = country;
        return foundedCountry;
      }
    }
    return null;
  }

  Tuple? separatePhoneAndDialCode(String phoneWithDialCode) {
    Country? foundedCountry;
    for (Country country in allCountries!) {
      String dialCode = country.code.toString();
      if (phoneWithDialCode.contains(dialCode)) {
        foundedCountry = country;
      }
    }

    if (foundedCountry != null) {
      var dialCode = phoneWithDialCode.substring(
        0,
        foundedCountry.code!.length,
      );
      var newPhoneNumber = phoneWithDialCode.substring(
        foundedCountry.code!.length,
      );
      //  return dialCode;
      return Tuple(phoneNumber: newPhoneNumber, object: foundedCountry);
      print('${dialCode}, ${newPhoneNumber}');
    } else {
      print("country code empty");
    }
    return null;
  }

  setUpLoginData() async {
    TransporterDao transporterDao = TransporterDao();
    PhotomallApis apiCall = PhotomallApis(null);
    try {
      showLog("userAbleEventsStoreApi setUpLoginData");
      await apiCall.userAbleEventsStoreApi();
    } catch (e) {
      showLog('userAbleEventsStoreApi error $e');
    }
    //try {
    TransportDataData? transporter = await transporterDao
        .getSingleTransporterWhereTag(TransportDataKeys.userData);
    List<TransportDataCompanion> initialInputData = [];

    if (isPhotomallApp) {
      initialInputData = [
        TransportDataCompanion(
            tag: drift.Value(
              TransportDataKeys.userData,
            ),
            lastUpdatedAt: drift.Value(0),
            updateRequired: drift.Value(1)),
        TransportDataCompanion(
            tag: drift.Value(
              TransportDataKeys.userEventData,
            ),
            lastUpdatedAt: drift.Value(0),
            updateRequired: drift.Value(1)),
      ];
    } else {
      initialInputData = [
        TransportDataCompanion(
            tag: drift.Value(
              TransportDataKeys.userData,
            ),
            lastUpdatedAt: drift.Value(0),
            updateRequired: drift.Value(1)),
        TransportDataCompanion(
            tag: drift.Value(
              TransportDataKeys.studioUserData,
            ),
            lastUpdatedAt: drift.Value(0),
            updateRequired: drift.Value(1)),
      ];
    }

    for (int i = 0; i < initialInputData.length; i++) {
      await transporterDao.insertOrUpdateTransporter(
        code: initialInputData[i].code.value,
        tag: initialInputData[i].tag.value,
        //   initialInputData[i]
      );
    }

    // get event dat where update required 1

    List<appDb.TransportDataData> transporters = await transporterDao
        .getTransporterWhereTagAndUpdateRequired(TransportDataKeys.eventData);

    List<String> events = [];
    EventDataController eventDataController = EventDataController();
    EventAiDataController eventAiDataController = EventAiDataController();
    for (appDb.TransportDataData transporter in transporters) {
      events.add(transporter.code!);
    }
    if (events.isNotEmpty) {
      await eventDataController.getEventData(
          eventsCode: events, isFromLogin: true);
    }
    // fill event  resources
    await eventDataController.fillEventResources();
    //await eventAiDataController.fillEventResources();

    // fill photo selection resources
    PhotoSelectionDataController photoSelectionDataController =
        PhotoSelectionDataController();
    await photoSelectionDataController.fillPhotoSelectionResources3();
    // } catch (e) {
    //   showLog("otp page the app config error${e}");
    // }
    if (events.isNotEmpty) {
      await eventAiDataController.getEventAiData(eventsCode: events);
    }
  }
}

class Tuple {
  final Country? object;
  final String? phoneNumber;

  Tuple({
    this.object,
    this.phoneNumber,
  });
}
