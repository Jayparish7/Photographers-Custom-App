import 'dart:convert';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/event_info_controller.dart';
import 'package:photomall_flutter/controllers/faces_controller.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/controllers/real_face_controller.dart';
import 'package:photomall_flutter/controllers/without_face_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/myPhotos_images_response_model.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/event_ai_data.dart';
import 'package:photomall_flutter/driftdb/dao/file_dao.dart';
import 'package:photomall_flutter/driftdb/dao/media_dao.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart'
    as transporter;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/shared_preference_constants.dart';
import '../driftdb/dao/event_dao.dart';

class EventAiDataController {
  transporter.TransporterDao transporterDao = transporter.TransporterDao();
  FileModelDao fileModelDao = FileModelDao();
  var appConfig = TransporterPreference();
  MediaModelDao mediaModelDao = MediaModelDao();
  EventInfoController eventInfoController = EventInfoController();
  EventModelDao eventModelDao = EventModelDao();
  List<EventAiDatumData>? data = [];
  List<MyPhotosImages>? myPhotosData = [];
  List<String>? codes = [];
  Map<String, dynamic>? map = {};

  Future<void> getEventAiData(
      {required List<String> eventsCode,
      int? eventType,
      bool isLastUpdatedNull = false}) async {
    // List<String>? aiEvents = [];
    List<String>? myPhotosEvents = [];
    for (int i = 0; i < eventsCode.length; i++) {
      var res = await eventModelDao.getEventByCode(eventsCode[i]);

      showLog(
          'res Ai event data show${eventsCode[i]} Log ${res?.personStatus}');
      if (res != null) {
        /*if (res.personStatus == true && res.hideMedia == false) {
          aiEvents.add(eventsCode[i]);
        }*/
        if (res.personStatus == true) {
          myPhotosEvents.add(eventsCode[i]);
        }
        showLog('es Ai event dat $myPhotosEvents');
      }
    }

    try {} catch (e) {
      showLog("error in getAiEventData :: $e");
    }
    PhotomallApis apiCall = PhotomallApis(null);

    {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? loggedIn = await prefs.getBool(isUserLoggedInPreferenceKey);
      showLog('lastUpdatedMap $loggedIn is a lastUpdatedMap $myPhotosEvents');
      if (myPhotosEvents.isNotEmpty && loggedIn == true) {
        for (int i = 0; i < myPhotosEvents.length; i++) {
          var value = await getValueForKey(myPhotosEvents[i]);
          showLog('value map is $value');
          var lastUpdatedAt = (value != null && !isLastUpdatedNull) ? value : 0;

          MyPhotosImages? res = await apiCall.myPhotosImagesApi(
              eventCode: myPhotosEvents[i], lastUpdatedAt: lastUpdatedAt);

          //myPhotosData!.add(res!);`

          await fillMyPhotosEventResources(res!, myPhotosEvents[i]);
          map?['${myPhotosEvents[i]}'] = '${res.lastUpdatedAt}';

          showLog('myPhotosEvents fill complete');
        }
      }
      await saveMapToPrefs(map!);
    }
    return null;
  }

// splash screen
  fillEventResources(List<EventAiDatumData>? eventDetaildatas1) async {
    try {
      PersonsController personsController = PersonsController();
      RealPersonsController realPersonsController = RealPersonsController();
      WithoutFaceController withoutFaceController = WithoutFaceController();

      for (int i = 0; i < eventDetaildatas1!.length; i++) {}

      await personsController.upsertAlbumPersons(
          eventAiDetailData: eventDetaildatas1);
      for (int i = 0; i < eventDetaildatas1.length; i++) {
        showLog('messageEventAiDetailData ');

        showLog(
            'realPersonsController succeed ${eventDetaildatas1[i].data?.imageWithoutPerson} \n${eventDetaildatas1[i].data!.realPersons} ');
      }
      await realPersonsController.upsertAlbumRealPersons(
          eventAiDetailData: eventDetaildatas1);
      showLog('realPersonsController1');

      await withoutFaceController.upsertWithoutFaceAlbum(
          eventAiDetailData: eventDetaildatas1);
    } catch (e, s) {
      showLog("Error : in fill event$e $s");
    }
  }

  fillMyPhotosEventResources(
      MyPhotosImages myPhotosData, String? eventCode) async {
    try {
      PersonsController personsController = PersonsController();
      RealPersonsController realPersonsController = RealPersonsController();

      await personsController.upsertMyPhotosAlbumPersons(
          eventCode: eventCode, myPhotosData: myPhotosData);

      await realPersonsController.upsertMyPhotosAlbumRealPersons(
          myPhotosData: myPhotosData, eventCode: eventCode);
    } catch (e, s) {
      showLog("Error : in fill myPhotos event $e $s");
    }
  }

  saveMapToPrefs(Map<String, dynamic> map) async {
    showLog('saveMapToPrefs for my-photos/images $map');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(map); // Convert map to JSON string
    prefs.setString(
        lastUpdatedAtMap, jsonString); // Save JSON string to SharedPreferences
  }

  Future<Map<String, dynamic>> getMapFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(
        lastUpdatedAtMap); // Retrieve JSON string from SharedPreferences
    if (jsonString != null) {
      Map<String, dynamic> map =
          json.decode(jsonString); // Convert JSON string to map
      return map;
    }
    return {}; // Return empty map if no data is found
  }

  Future<dynamic> getValueForKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(
        lastUpdatedAtMap); // Retrieve JSON string from SharedPreferences
    if (jsonString != null) {
      Map<String, dynamic> map =
          json.decode(jsonString); // Convert JSON string to map
      return map[key]; // Retrieve value for the specified key
    }
    return null; // Return null if no data is found or key is not present
  }
}
