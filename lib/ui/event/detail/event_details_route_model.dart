import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/PhotomallController/photomall_studio_data_controller.dart';
import 'package:photomall_flutter/controllers/login_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/dao/file_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_dao.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart'
    as transporter;
import 'package:photomall_flutter/ui/base/base_observer.dart';
import 'package:photomall_flutter/ui/event/photos/custom_photo_view.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/upsert_photoSelections.dart';
import '../../../core/Utils/preference_helper.dart';
import '../../../core/Utils/toast_util.dart';
import '../../../driftdb/app_db.dart' as appDb;
import '../../../traits/common_widgets/photo_selection_data_controller.dart';
import '../../shared_widgets/common_text.dart';
import 'event_details_route.dart';

class EventDetailsRouteModel extends BaseObserver {
  ApiHelper? apiHandler;
  BuildContext? context;
  bool isInfoPage = false;

  PhotomallApis? apiRepo;
  String? imageUrl;
  bool? isPhotoSelectionAvailable = false;
  transporter.TransporterDao transporterDao = transporter.TransporterDao();

  var eventId;
  bool isFromPrivateKey;
  String? eventCode;

  bool showShare = false;

  EventDetailsRouteModel(
      {this.apiHandler,
      this.context,
      this.eventId,
      this.isFromPrivateKey = false}) {
    this.apiRepo = PhotomallApis(this.context);
  }

  var eventKey;

  var eventType;

  var eventName;

  String? studioCode;
  var lastUpdatedAt;
  var documentDirectory;
  bool showImageProgress = false;
  bool isDemoEvent = false;

  //variable to control tabs recreate
  bool isUpdated = true;
  FileModelDao fileModelDao = FileModelDao();
  EventModelDao eventModelDao = EventModelDao();
  FolderModelDao folderModelDao = FolderModelDao();

  callGetEventDetailsFromDb(String code) async {
    try {
      setBusy(true);
      //  getDataFromDb();
      isFromPrivateKey = await checkUserPrivateKey(code);
      eventCode = code;
      showLog("the data where isFromPrivateKey  $isFromPrivateKey $code");
      appDb.TransportDataData? transporter =
          await transporterDao.getPhotoSelectionResourceByCode(code: code);
      showLog("the data where photo selection ${(transporter != null)}");
      String? userPrivateKey = await PreferenceHelper.getValueForKey(
          eventCode!, userInputPrivatePrefKey);
      showLog("checkUsedPrivateKey init: $userPrivateKey");
      if (isFromPrivateKey == false && (userPrivateKey == ''|| userPrivateKey==null)) {
        isPhotoSelectionAvailable = (transporter != null) ? true : false;
      }

      var res = await PreferenceHelper.getValueForKey(
          eventCode!, eventsPhotoselectionPrefKey);
      showLog("eventsPhotoselectionPrefKey ${res["code"]} $isFromPrivateKey");

      if (isFromPrivateKey != false && res["code"] != '') {
        showLog("isFromPrivateKey if: $isFromPrivateKey");

        isPhotoSelectionAvailable = true;
        UpsertPhotoSelectionEvent upsertPhotoSelectionEvent =
            UpsertPhotoSelectionEvent();
        await upsertPhotoSelectionEvent.upsertPhotoSelections(
          isUser: true,
          apiEvents: [code],
        );
        PhotoSelectionDataController photoSelectionDataController =
            PhotoSelectionDataController();
        photoSelectionDataController.fillPhotoSelectionResources3();
      }
      await getEventDatumByCode();
      documentDirectory = (await getApplicationDocumentsDirectory()).path;

      setBusy(false);
    } catch (e, s) {
      showLog("something went wrong at event list $e, $s");
      setBusy(false);
    }
  }

  @override
  void onInternetConnectionBack() async {}

  // stream cover image of this event
  Stream<appDb.JvtFileConnector> getCoverEventImage() {
    Stream<appDb.JvtFileConnector> jvtFileConnector =
        fileModelDao.streamEventCoverImage(eventCode!);
    return jvtFileConnector;
  }

  void isInfoPageCheck(int index) {
    if (index == 2) {
      isInfoPage = true;
    } else {
      isInfoPage = false;
    }
    notifyListeners();
  }

  Future<bool> checkUserPrivateKey(String eventCode) async {
    String? userPrivateKey = await PreferenceHelper.getValueForKey(
        eventCode!, userInputPrivatePrefKey);
    showLog("checkUsedPrivateKey: $userPrivateKey");
    String apiPrivateKey =
        await PreferenceHelper.getValueForKey(eventCode!, eventPrivatePrefKey);
    if (userPrivateKey == apiPrivateKey) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkUserEnteredKey(String eventCode) async {
    String? userPrivateKey = await PreferenceHelper.getValueForKey(
        eventCode, userInputPrivatePrefKey);
    showLog("checkUsedPrivateKey: $userPrivateKey");
    if (userPrivateKey != '' && userPrivateKey != null) {
      return true;
    } else {
      return false;
    }
  }

  saveAndValidatePrivateKeyFromUser(
      BuildContext context, String privateKey) async {
    String userPrivateKey = privateKey.toString();
    String apiPrivateKey =
        await PreferenceHelper.getValueForKey(eventCode!, eventPrivatePrefKey);
    showLog('saveAndValidatePrivateKeyFromUser $userPrivateKey $apiPrivateKey');

    if (userPrivateKey == apiPrivateKey) {
      Map<String, dynamic> map = {eventCode ?? "": privateKey};
      await PreferenceHelper.saveMapToPrefs(map, userInputPrivatePrefKey);
      Navigator.pop(context); // closes bottom sheet

      // Refresh current screen state instead of pushing a new route
      isFromPrivateKey = true;
      await callGetEventDetailsFromDb(eventCode!);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: UniqueText(
            text: "Invalid Key",
            fontSize: 25,
          ),
          content: Text(
            "The key you entered is incorrect. Please try again.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            CommonButton(
              onPressCall: () => Navigator.pop(context),
              buttonText: "   OK   ",
            ),
          ],
        ),
      );
    }
  }

  Future<appDb.Event?> getEventDatumByCode() async {
    showLog('The current date is 22  ');

    appDb.Event? _event = await eventModelDao.getSingleEventByCode(eventCode!);
    if (_event != null) {
      showLog('The current date is 222');

      if (_event.type == 6) {
        isDemoEvent = true;
      } else {
        isDemoEvent = false;
      }
      // uncomment any doubt in below method
      //DateTime tableDate =    DateTime.parse('2023-05-15 00:00:00.000');
      //DateTime currentDate =    DateTime.parse('2023-05-15 00:00:00.000');
      //showLog("the dialogue should be shown ${currentDate.isAfter(tableDate)}");
      if (isDemoEvent == false) {
        if (_event.shareDate != null) {
          DateTime tableDate = DateTime.parse(_event.shareDate!);
          DateTime currentDate = DateUtils.dateOnly(DateTime.now());
          if (currentDate.isAfter(tableDate)) {
            showShare = true;
          } else {
            showShare = false;
          }
        } else {
          showShare = true;
          eventModelDao.updateShareDate(eventCode!);
        }
      }
      // find photo selection available by getting folders table
      /*List<appDb.Folder> folder =
          await folderModelDao.getMultiFoldersWhereEventCode(eventCode!);*/

      // isPhotoSelectionAvailable = folder.isNotEmpty ? true : false;
      eventName = _event.name;
      studioCode = _event.studioCode;
    }
    return null;
  }

  Future<void> getDataFromDb() async {
    var pref = await SharedPreferences.getInstance();
    bool loggedIn = await pref.getBool('$isUserLoggedInPreferenceKey') ?? false;
    if (loggedIn) {
      LoginController loginController = LoginController();
      await loginController.setUpLoginData();
    }
  }

  Future<void> sharePhotomallEvent() async {
    try {
      PhotomallStudioDataController photomallStudioDataController =
          PhotomallStudioDataController();
      StudioDataGetModel? studioDataGetModel =
          await photomallStudioDataController.getStudioRow(studioCode!);
      String? ShortUrl = studioDataGetModel?.studioData?.data?.shortUrl;
      String? ptmlDomain = studioDataGetModel?.studioData?.data?.ptmlDomain;
      await Share.share(
        "${await studioDataController.getStudioName()} has shared $eventName with you. Click the link "
        "$ptmlDomain/$ShortUrl/$eventCode to view",
      );
    } catch (e) {
      showLog("Error : while share $e");
    }
  }
}

//method to remove
/*
checkInternetConnection(
    int eventId, Directory documentDirectory, int lastUpdatedAt) async {
  //var connectionStatus = Provider.of<ConnectivityStatus>(context);

  //if (connectionStatus == ConnectivityStatus.WiFi ||
  //    connectionStatus == ConnectivityStatus.Cellular) {
  showLog("LastUpdatedAt -- ${lastUpdatedAt}");

  */
/*  if (lastUpdatedAt == 0) {
      // show progress
      await callApiForEventsDetails(lastUpdatedAt, eventId)
          .then((response) async {
        */ /*
 */
/*List<Album> albums = response.data.photomallEvent.data.albums;
          List<Duration> durations = response.data.photomallEvent.data
              .durations;
          Invitation invitations = response.data.photomallEvent.data.invitation;
          List<Video> videos = response.data.photomallEvent.data.videos;
          var albumSize = 0;
          for (int i = 0; i < albums.length; i++) {
            if (albums[i].status == insert || albums[i].status == userEvent) {
              if (albums[i].data.coverImage.status == insert ||
                  albums[i].data.coverImage.status == update) {
                albumSize += albums[i].data.coverImage.data.originalSize;
              }
            }
          }

          if (invitations.status == insert || invitations.status == update) {
            for (int i = 0; i < invitations.data.albumImages.length; i++) {
              if (invitations.data.albumImages[i].status == insert ||
                  invitations.data.albumImages[i].status == update) {
                albumSize += invitations.data.albumImages[i].data.originalSize;
              }
            }
          }*/ /*
 */
/*

        //if (Others().isAvailableExternalMemorySize(context, albumSize)) {
        if (true) {
          showLog("callApiForEventsDetails1 --- ${response}");
          await updateEvent(response, context, documentDirectory);
          notifyListeners();
        }
      });
    } else {*/ /*

}
*/
//method to remove

class EventDetails {
  appDb.JvtFile? jvtFile;
  appDb.Event? events;

  EventDetails({this.events, this.jvtFile});
}
