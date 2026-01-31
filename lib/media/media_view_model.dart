import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/pm_job_controller.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/my_photos_model.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/core/services/image_handler.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/event_dao.dart' as eventDao;
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/dao/person_album_dao.dart';
import 'package:photomall_flutter/driftdb/dao/without_face_album_dao.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';
import 'package:photomall_flutter/ui/base/base_observer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/PhotomallController/photomall_studio_data_controller.dart';
import '../controllers/event_ai_data_controller.dart';
import '../controllers/studio_data_controller.dart';
import '../core/Utils/toast_util.dart';
import '../core/constants/shared_preference_constants.dart';
import '../core/models/apiModels/multiple_face_delete_response_model.dart';
import '../core/models/apiModels/myPhotos_images_response_model.dart';
import '../core/models/apiModels/un_auth_user_profile_store.dart';
import '../core/models/delete_user_persons_response_model.dart';
import '../driftdb/dao/jvt_file_connector_dao.dart';
import '../driftdb/dao/real_person_dao.dart';
import '../driftdb/dao/user_persons_dao.dart';
import '../ui/gallery/gallery_route_view_model.dart';
import 'my_photos_route.dart';

class MediaRouteViewModel extends BaseObserver {
  MediaRouteViewModel({
    this.apiHandler,
    this.context,
  }) {
    apiRepo = PhotomallApis(this.context);
  }

  @override
  void onInternetConnectionBack() async {
    showLog('event_list_route :: onInternetConnectionBack :: called');
  }

  appDb.JvtFile? profileJvtFile;
  String category = '';
  int? selectedCategoryIndex;
  bool showCategory = false;
  var usercode = "";
  String currentTokenForEmail = '';
  var userName = "";
  var userPhoneNumber = "";
  var userEmailAddress = "";
  int emailStatus = 0;
  var imageName;
  File? downloadedImageFile;
  final ValueNotifier<bool> isConnected = ValueNotifier<bool>(false);
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  bool? loading = false;
  bool? unAuthLoading = false;
  BuildContext? context;
  ApiHelper? apiHandler;
  PhotomallApis? apiRepo;
  DownloadPath? downloadPath;
  UserPersonsPhotos? myPhotos;
  var documentDirectory;
  String? publicStoragePath;
  String? privateStoragePath;
  Stream<List<Media>?>? mediasStream;
  List<Media>? medias;
  int? counter = 0;
  bool showPersonTile = false;
  bool myPhotosTile = false;
  bool showWithoutPersonTile = false;
  bool isUploadProfileImage = false;
  List<String>? apiRealPersonCode = [];
  List<String>? realPerson = [];
  bool isPartyApp = false;
  bool isGalleryAvailable = false;
  List<UnauthUserPerson> unAuthUserPersons = [];
  eventDao.EventModelDao eventModelDao = eventDao.EventModelDao();
  StudioDataController studioDataController = StudioDataController();
  var eventName = "";
  var studioCode = "";

  // List<Media>  media1 = [];
  ValueNotifier<List<Media>> localMedia = ValueNotifier<List<Media>>([]);

  /*ValueNotifier<List<Media>> localMediaView = ValueNotifier<List<Media>>([]);*/
  int initialCounter = 0;
  bool clientEvent = false;
  bool doubtImages = false;
  bool isFromPrivateKey = false;
  String? doubtImageUrl = 'default-event-cover-image-8si4xeoq';
  String? myPhotosImageUrl = 'default-event-cover-image-8si4xeoq';
  String? apiDoubtPersonCode = '';
  String? apiMatchPersonCode = '';
  List<String>? box = [];
  List<String>? boxValues = [];
  double borderRadius = 10.0;
  EventAiDataController eventAiDataController = EventAiDataController();
  RealPersonsDao realPersonsDao = RealPersonsDao();
  appDb.Event? event;

  getInitialMediaData(String? eventCode, String? personCode,
      {DownloadPath? storagePath}) async {
    try {
      isFromPrivateKey = await checkUserPrivateKey(eventCode ?? "");
      showLog("isFromPrivateKey $storagePath media $isFromPrivateKey");
      if (storagePath == null) {
        await getStoragePaths();
      } else {
        downloadPath = DownloadPath(
            public: storagePath.public,
            private: storagePath.private,
            DocumentPath: storagePath.DocumentPath);
      }
      localMedia.addListener(() {
        setBusy(false);
        //     }
      });
      await getFaceSelectionTilesEvent(eventCode);
      await getMediaList(eventCode);

      showLog('testing:');
      await getUserDetails();
      showLog('testing 1:');
      listenMethod(event: eventCode);
      // await getHideMediaValue(eventCode);
      //await checkUserOwnEvent(eventCode);
      //await checkGallery(eventCode);
      await getStudioType();
      await getGalleryAvailability();
      await getView();
      event = await EventModelDao().getEventByCode(eventCode ?? "");

      showLog('localMedia localMedia ${localMedia.value.length}');
      eventName = event?.name ?? "";
      studioCode = event?.studioCode ?? "";
    } catch (e, s) {
      showLog('the problem while get gallery view model :: $s');
    }
  }

  Future<bool> checkUserPrivateKey(String eventCode) async {
    try {
      String? userPrivateKey = await PreferenceHelper.getValueForKey(
          eventCode!, userInputPrivatePrefKey);
      showLog("checkUsedPrivateKey: $userPrivateKey");
      String? apiPrivateKey = await PreferenceHelper.getValueForKey(
          eventCode!, eventPrivatePrefKey);
      if (userPrivateKey == apiPrivateKey) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
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
        "$ptmlDomain/$ShortUrl/${event?.code} to view",
      );
    } catch (e) {
      showLog("Error : while share $e");
    }
  }

  getMultipleFaceDeleteApi(int index, {required String code}) async {
    unAuthLoading = true;
    notifyListeners();
    try {
      UserPersonsDao usersDao = UserPersonsDao();

      UserPersonsDeleteResponseModel? response = await PhotomallApis(context)
          .unAuthUserDeleteApi(userPersonCode: code);
      showLog('getMultipleFaceDeleteApi u ${response!.status}');
      if (response.status == 1) {
        // updateMultipleFacesForView(index);
        await unAuthUserPersons.removeAt(index);
        await ToastUtil.showSnackBarAtCurrentState(
            'Picture deleted Successfully',
            seconds: 5);
      }
      //isLoading.value = false;
      unAuthLoading = false;

      notifyListeners();
    } catch (e) {
      // isLoading.value = false;
      unAuthLoading = false;

      notifyListeners();
    }
  }

  changeCategory(String categoryText) {
    if (category != categoryText) {
      category = categoryText;
    } else {
      category = '';
    }
    notifyListeners();
  }

  changeSelectedCategoryIndex(int index) {
    if (selectedCategoryIndex != index) {
      selectedCategoryIndex = index;
    } else {
      selectedCategoryIndex = null;
    }
    notifyListeners();
  }

  getView() async {
    String? isSharpEdge = await PreferenceHelper.getString(isSharpEdges);
    showLog('getView $isSharpEdge');

    if (isSharpEdge == '0') {
      showLog('isSharpEdge1 $isSharpEdge');
      borderRadius = 0.0;
    } else {
      showLog('isSharpEdge2 $isSharpEdge');

      borderRadius = 10.0;
    }
  }

  Future<void> getStoragePaths() async {
    if (studioPublicPath != null &&
        appDocumentDirectoryPath != null &&
        studioPrivatePath != null) {
      downloadPath = DownloadPath(
          DocumentPath: appDocumentDirectoryPath,
          public: studioPublicPath,
          private: studioPublicPath);
    } else {
      EssentialUtils essentialUtils = EssentialUtils();
      essentialUtils.loadAppEssentialData();
      downloadPath = DownloadPath(
          public: studioPublicPath,
          private: studioPrivatePath,
          DocumentPath: appDocumentDirectoryPath);
    }
  }

  getMediaList(String? eventCode) {
    showLog('the data');
    eventDao.EventModelDao eventModelDao = eventDao.EventModelDao();
    if (eventCode != null) {
      mediasStream = eventModelDao.getStreamSingleEvent(eventCode);
    } else {
      mediasStream = eventModelDao.getStreamGalleryEventWithMedia();
    }
  }

  void stopStreaming() {
    mediasStream = null;
  }

  void listenMethod({String? event}) {
    mediasStream?.listen((media) {
      if (media != null) {
        showLog('the media length where ${media.length}');
        if (media.length == 0) {
          localMedia.value = [];
        }
        for (int i = 0; i < media.length; i++) {
          if (media.length != localMedia.value.length) {
            // length is not equal
            localMedia.value = media;
            setBusy(false);
            break;
          } else {
            // length are equal
            if (media[i].media!.ableType == TransportDataKeys.albums) {
              getAlbumChangesStatus(media, i);
            }
            if (media[i].media!.ableType == TransportDataKeys.videos) {
              getVideoChangesStatus(media, i);
            }
          }
        }
      } else {
        localMedia.value = [];
      }
    });
  }

  getAlbumChangesStatus(List<Media> media, int i) {
    if (localMedia.value[i].albums != null) {
      if (media[i].albums != null &&
          media[i].albums!.toJsonString() !=
              localMedia.value[i].albums!.toJsonString()) {
        localMedia.value = media;
      }
    } else {
      localMedia.value = media;
    }
    if (localMedia.value[i].file != null) {
      if (media[i].file != null &&
          media[i].file!.toJsonString() !=
              localMedia.value[i].file!.toJsonString()) {
        localMedia.value = media;
      }
    } else {
      localMedia.value = media;
    }
  }

  void getVideoChangesStatus(List<Media> media, int i) {
    if (localMedia.value[i].videos != null) {
      if (media[i].videos != null &&
          media[i].videos!.toJsonString() !=
              localMedia.value[i].videos!.toJsonString()) {
        localMedia.value = media;
      }
    } else {
      localMedia.value = media;
    }
  }

  // getHideMediaValue(eventCode) async {
  //   if (eventCode != null) {
  //     EventModelDao eventModelDao = EventModelDao();
  //     appDb.Event? event = await eventModelDao.getEventByCode(eventCode);
  //     if (event != null && event.hideMedia == true) {
  //       hideMedia = true;
  //     }
  //     return;
  //   }
  // }

  // checkUserOwnEvent(eventCode) async {
  //   if (eventCode != null) {
  //     EventModelDao eventModelDao = EventModelDao();
  //     appDb.Event? event = await eventModelDao.getEventByCode(eventCode);
  //     showLog('checkUserOwnEvent 0 hideMedia');
  //     if (event?.ownedByUser == true) {
  //       hideMedia = false;
  //     }
  //     showLog('checkUserOwnEvent $hideMedia,,, ,,, ');
  //     return;
  //   }
  // }

  checkGallery(eventCode) async {
    showLog('medias?.length ${medias?.length},$eventCode');

    if ((eventCode == null && medias != null && medias?.length != 0)) {
      showLog('medias?.length ${medias?.length},$eventCode');
      await PreferenceHelper.setBool(galleryKey, true);
    } else {
      await PreferenceHelper.setBool(galleryKey, false);
    }
  }

  getStudioType() async {
    var pref = await SharedPreferences.getInstance();
    var party = pref.getString('$studioTypeKey') ?? '';
    if (party == 'Party') {
      showLog('getStudioType $party');

      isPartyApp = true;
    }
  }

  getGalleryAvailability() async {
    var gallery = await PreferenceHelper.getBool(galleryKey);
    var carousel = await PreferenceHelper.getBool(carouselKey);
    if (gallery == true || carousel == true) {
      showLog('getGalleryAvailability $gallery $carousel');
      isGalleryAvailable = true;
    }
    showLog('getGalleryAvailability $gallery $carousel $isGalleryAvailable');
  }

  Future<bool> getMediaResources(String mediaCode) async {
    try {
      // await albumController.updateAlbumResources(mediaCode);
      return true;
    } catch (e) {
      return false;
    }
  }

  getFaceSelectionTilesEvent(String? eventCode) async {
    if (eventCode != null) {
      eventDao.EventModelDao eventModelDao = eventDao.EventModelDao();
      appDb.Event? event = await eventModelDao.getEventByCode(eventCode);

      if (event!.personStatus == true) {
        myPhotosTile = true;
        PersonAlbumDao personAlbumDao = PersonAlbumDao();
        WithoutPersonAlbumDao withoutPersonAlbumDao = WithoutPersonAlbumDao();
        List<appDb.PersonsAlbum> personAlbum =
            await personAlbumDao.getFacesByEvent(eventCode: eventCode);
        appDb.WithOutPersonsAlbum? withoutFace = await withoutPersonAlbumDao
            .getWithoutFacesByCode(eventCode: eventCode);
        if (withoutFace != null) {
          showWithoutPersonTile = true;
        }
        if (personAlbum.isNotEmpty) {
          showPersonTile = true;
        } else {
          showPersonTile = false;
        }
      } else {
        showPersonTile = false;
      }
    } else {
      showPersonTile = false;
    }
  }

  getUserDetails() async {
    // try {
    await getStoragePaths();
    var documentDirectory = await getApplicationDocumentsDirectory();
    var appConfigRef = TransporterPreference();
    transporter.UserData? userData = await appConfigRef.getUserData();

    if (userData != null) {
      if (userData.userDataData!.accountData!.emails!.isNotEmpty) {
        currentTokenForEmail =
            userData.userDataData!.accountData!.emails![0].token!;

        emailStatus = userData.userDataData!.accountData!.emails![0].verify!;

        userEmailAddress =
            userData.userDataData?.accountData?.emails?[0] == null
                ? ""
                : userData.userDataData!.accountData!.emails![0].address!;
      }
      userPhoneNumber = userData.userDataData?.accountData?.phoneNumber == null
          ? ""
          : userData.userDataData!.accountData!.phoneNumber!;
      userName = userData.userDataData!.accountData!.name == null
          ? ""
          : userData.userDataData!.accountData!.name ?? "";
      usercode = userData.userDataData!.accountData!.code ?? "";
      currentTokenForEmail = userData.userDataData!.accountData!.emails!.isEmpty
          ? ""
          : userData.userDataData!.accountData!.emails![0].token ?? "";
      if (imageName != null) {
        downloadedImageFile = File(
            '${documentDirectory.path}/${getImageWithExtension(imageName)}');
      }
    } else {}
    profileJvtFile = await getUserProfilePicture();
    showLog('profileJvtFile $profileJvtFile');
    if ((profileJvtFile != null) && (profileJvtFile!.code.isNotEmpty)) {
      showLog('profileJvtFile getUserProfilePicture $profileJvtFile');

      await PreferenceHelper.setBool(profileKey, true);
    }

    checkConnectivity();
    setBusy(false);
    //  } catch (e) {
    //    showLog("the problem while parse data for profile view where \n $e");
    //   }
  }

  Future<bool> changeProfileImage(
      String imageInBase64, File croppedFile) async {
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    try {
      isUploadProfileImage = true;
      //setState(ViewState.Idle);
      var response = (await PhotomallApis(context).callFileStore(
          context!, 'data:image/png;base64,' + imageInBase64, 'users',
          userCode: usercode));
      isUploadProfileImage = true;
      // downloading response image
      await jvtFileConnectorModelDao.insertJvtFilesConnectors(
          jvtFileConnectors: response.jvtFileConnectors!,
          ableType: TransportDataKeys.users,
          ableCode: usercode,
          isProfile: true);

      return true;
    } catch (e) {
      print("error while upload :: ${e}");
      return false;
    }
  }

  Future<appDb.JvtFile?> getUserProfilePicture() async {
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();

    return await jvtFileConnectorModelDao.getUserProfilePicture(usercode);
  }

  Widget checkConnectivity({Widget? child}) {
    InternetConnectionChecker.instance.onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.connected) {
        isConnected.value = true;
      } else {
        isConnected.value = false;
      }
    });
    return FutureBuilder<InternetConnectionStatus>(
        future: InternetConnectionChecker.instance.connectionStatus,
        builder: (BuildContext context,
            AsyncSnapshot<InternetConnectionStatus> snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return SizedBox();
          }
          if (snapshot.data == InternetConnectionStatus.connected) {
            return child ?? SizedBox();
          } else {
            return SizedBox();
          }
        });
  }

  Future<void> getStoragePath() async {
    if (studioPublicPath != null &&
        appDocumentDirectoryPath != null &&
        studioPrivatePath != null) {
      publicStoragePath = studioPublicPath;
      documentDirectory = appDocumentDirectoryPath;
      privateStoragePath = studioPrivatePath;
    } else {
      EssentialUtils essentialUtils = EssentialUtils();
      essentialUtils.loadAppEssentialData();
      publicStoragePath = studioPublicPath;
      documentDirectory = appDocumentDirectoryPath;
      privateStoragePath = studioPrivatePath;
    }
  }

  getPersonCode(String? eventCode, {bool isLastUpdatedNull = false}) async {
    // await myPhotosDoubtImageApiCall(eventCode);
    showLog("doubtImages() MyCart :$doubtImages: ");

    try {
      if (eventCode != null) {
        showLog('getEventAiData in event ${[eventCode]}');
        await eventAiDataController.getEventAiData(
            eventsCode: [eventCode], isLastUpdatedNull: isLastUpdatedNull);
      }
      PhotomallApis photomallApis = PhotomallApis(context);
      List<appDb.RealPersonsAlbum> codes = await realPersonsDao.getRealFaces();
      //var myPhotos1 = await photomallApis.myPhotosApiCall(eventCode: eventCode);

      showLog("getPersonCodeFromApi() MyCart :$doubtImages: myPhotos1");
      // myPhotos = myPhotos1;
      if (codes.isNotEmpty) {
        /* for (int i = 0; i < myPhotos1!.userPersons!.length; i++) {
          for (int j = 0;
              j < myPhotos1.userPersons![i].realPersons!.length;
              j++) {
            apiRealPersonCode?.add(myPhotos1.userPersons![i].realPersons![j]);
          }
        }*/
        for (appDb.RealPersonsAlbum code in codes) {
          apiRealPersonCode?.add(code.code);
        }

        showLog("user person images apiRealPersonCode $apiRealPersonCode");
        for (int i = 0; i < apiRealPersonCode!.length; i++) {
          await getRealPersonCode(apiRealPersonCode![i]);
        }
      }

      setBusy(false);
    } catch (e) {
      print("error while upload :: ${e}");
      return false;
    }
  }

  getUnAuthUserMyPhotosImagesFromApi(
      {required String uuCode, required String eventCode}) async {
    bool isLoggedIn =
        await PreferenceHelper.getBool(isUserLoggedInPreferenceKey);
    if (isLoggedIn != true) {
      try {
        unAuthLoading = true;
        notifyListeners();
        MyPhotosImages? response =
            await apiRepo?.unAuthUserMyPhotosApi(uUCode: uuCode);

        if (response != null) {
          unAuthUserPersons = response.unauthUserPersons ?? [];
          showLog(
              "getUnAuthUserMyPhotosImagesFromApi ${unAuthUserPersons.length}");
          await eventAiDataController.fillMyPhotosEventResources(
              response, eventCode);
        }
      } catch (e) {
        showLog("exception in getUnAuthUserMyPhotosImages $e");
        unAuthLoading = false;
        notifyListeners();
      }
      unAuthLoading = false;
      notifyListeners();
    } else {
      showLog("getUnAuthUserMyPhotosImagesFromApi login :$isLoggedIn");
    }
  }

  uploadProfileImageForUnAuthUser(
      {required String uUcode,
      required String image,
      required String eventCode}) async {
    try {
      unAuthLoading = true;
      notifyListeners();

      UnAuthUserProfileStoreApiResponseModel? response = await apiRepo
          ?.unAuthUserProfileStoreApi(ableCode: uUcode, imageInBase64: image);
      if (response != null) {
        showLog("uploadProfileImageForUnAuthUser response $response");
        unAuthUserPersons.clear();
        await getUnAuthUserMyPhotosImagesFromApi(
            uuCode: uUcode, eventCode: eventCode);
      }
    } catch (e) {
      showLog("exception in uploadProfileImageForUnAuthUser $e");
      unAuthLoading = false;
      notifyListeners();
    }
    unAuthLoading = false;

    notifyListeners();
  }

  getRealPersonCode(String apiRealPersonCode) async {
    RealPersonsDao realFaceModelDao = RealPersonsDao();
    appDb.RealPersonsAlbum? folders =
        await realFaceModelDao.getRealPersonCodeByCode(
      code: apiRealPersonCode,
    );

    if (folders != null) {
      List<String> realPersonCode = folders.persons.split(',');
      for (int i = 0; i < realPersonCode.length; i++) {
        realPerson?.add(realPersonCode[i]);
      }
    }
    showLog('realPersonGetRealPersonCode $realPerson');
  }

  myPhotosDoubtImageApiCall(eventCode) async {
    try {
      setBusy(true);

      PhotomallApis photomallApis = PhotomallApis(context);

      var doubtImage = await photomallApis.doubtImagesApi(eventCode: eventCode);
      if (doubtImage != null && doubtImage.matchPersonJvtFile?.name != null) {
        var prefs = await SharedPreferences.getInstance();
        showLog(
            'myPhotosDoubtImageApiCall ${doubtImage.matchPersonJvtFile?.name} ');
        doubtImages = true;
        await PreferenceHelper.setString(
            doubtImagesUrl, '${doubtImage.matchPersonJvtFile?.name}');
        await PreferenceHelper.setString(
            myPhotosImage, '${doubtImage.personJvtFile?.name}');
        await PreferenceHelper.setString(
            personCodeKey, '${doubtImage.person?.code}');
        await PreferenceHelper.setString(
            matchPersonCodeKey, '${doubtImage.matchPerson?.code}');
        if (doubtImage.matchPersonBox != null &&
            doubtImage.matchPersonBox!.isNotEmpty) {
          for (int i = 0; i < doubtImage.personBox!.length; i++) {
            box?.add(doubtImage.personBox![i].toString());
          }
        }
        await prefs.setStringList(doubtImageBoxKey, box!);
      } else {
        doubtImages = false;
      }

      setBusy(false);
    } catch (e) {
      showLog("error while myPhotosDoubtImageApiCall :: ${e}");
      return false;
    }
  }

  myPhotosMatchPersonApiCall(
      {matchPersonCode,
      personCode,
      status,
      eventCode,
      appBarTitle,
      required BuildContext context}) async {
    try {
      setBusy(true);

      PhotomallApis photomallApis = PhotomallApis(context);

      var matchPerson = await photomallApis.matchPersonApi(
          matchPersonCode: matchPersonCode,
          personCode: personCode,
          status: status);

      showLog('myPhotosMatchPersonApiCall $matchPerson');
      if (matchPerson?.status == 1) {
        showLog('MyPhotosRoute pC qw ${personCode}');
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyPhotosRoute(
                      eventCode: eventCode,
                      appBarTitle: appBarTitle,
                    ),
                //myPhotosGrid(myPhotos),
                maintainState: false));
      }
      setBusy(false);
    } catch (e) {
      print("error while myPhotosMatchPersonApiCall :: ${e}");
      return false;
    }
  }

  getDoubtImageUrl() async {
    setBusy(true);
    var prefs = await SharedPreferences.getInstance();
    doubtImageUrl = await PreferenceHelper.getString(doubtImagesUrl);
    myPhotosImageUrl = await PreferenceHelper.getString(myPhotosImage);
    apiDoubtPersonCode = await PreferenceHelper.getString(personCodeKey);
    apiMatchPersonCode = await PreferenceHelper.getString(matchPersonCodeKey);
    boxValues = await prefs.getStringList(doubtImageBoxKey);

    await getUserDetails();

    setBusy(false);
  }
}

class DummyMedia {
  String? type;
  List<Image>? image;
  String? networkImage;
  String? videoUrl;

  DummyMedia({this.image, this.networkImage, this.videoUrl, this.type});
}
