import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/album_controller.dart';
import 'package:photomall_flutter/controllers/download_files_controller.dart';
import 'package:photomall_flutter/controllers/pm_job_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/notification/notification_utils.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/album_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_status_dao.dart';
import 'package:photomall_flutter/driftdb/dao/person_photo_selection_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_images_dao.dart';
import 'package:photomall_flutter/driftdb/dao/without_face_photo_selection_dao.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/traits/image_processor.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';
import 'package:photomall_flutter/ui/album/photoselection/select/photo_selection_route_view_model.dart';
import 'package:photomall_flutter/ui/base/base_observer.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import '../../../controllers/photo_selection_image_controller.dart';
import '../../../controllers/user_person_controller.dart';
import '../../../core/Utils/preference_helper.dart';
import '../../../core/constants/shared_preference_constants.dart';
import '../../../driftdb/dao/event_dao.dart';
import '../../../driftdb/dao/person_album_dao.dart';
import '../../../driftdb/dao/user_persons_dao.dart';
import '../../../traits/utils/save_to_gallery.dart';

class PhotoGridViewModel extends BaseObserver {
  bool loading = false;
  BuildContext? context;
  ApiHelper? apiHandler;
  PhotomallApis? apiRepo;
  String? documentDirectory;
  String? publicStoragePath;
  String? privateStoragePath;
  ImageProcessor imageProcessor = ImageProcessor();
  NotificationUtils notificationUtils = NotificationUtils();
  final ValueNotifier<List<ImagesViewModel?>?> photosList =
      ValueNotifier<List<ImagesViewModel>>([]);
  var photosListLength = 0.obs;

  List<String> urls = [];
  String? personImage;
  List<String>? personImageForUserPersons = [];
  bool isScrolling = false;
  String? publicPath;
  bool showPersonTile = false;
  final ValueNotifier<List<ImagesViewModel>> localPhotosList =
      ValueNotifier<List<ImagesViewModel>>([]);
  ScrollController scrollController = ScrollController();
  List<String> musicUrl = [];
  List<String> images = [];
  String profileUrl = '';

  ValueNotifier<List<JvtFileConnectors>> userPersonsNotifier =
      ValueNotifier<List<JvtFileConnectors>>([]);
  ValueNotifier<List<appDb.UserPerson>> userPersonsCode =
      ValueNotifier<List<appDb.UserPerson>>([]);
  ScrollOffsetManager scrollOffsetManager = ScrollOffsetManager();
  ScrollIndexManager scrollIndexManager = ScrollIndexManager();
  Set<int> selectedIndices = {}; // Track selected items
  List<PhotoSelectionImagesModel> photoSelections = [];
  List<PhotoSelectionImagesModel> multiplePhotoSelections = [];
  bool isSelectionMode = false;
  PhotoSelectionImageController photoSelectionImageController =
      PhotoSelectionImageController();
  bool viewDownloadButton = false;
  var isLoading = false.obs;

  @override
  void onInternetConnectionBack() {
    // TODO: implement onInternetConnectionBack
  }

  PhotoGridViewModel({
    this.apiHandler,
    this.context,
  }) {
    apiRepo = PhotomallApis(this.context);
  }

  update(){
    notifyListeners();
  }

  getInitialData(String? albumCode,
      {DownloadPath? storagePath,
      String? folderCode,
      String? personCode,
      String? eventCode,
      List<String>? realPersons,
      required int? status,
      required bool isWithoutFace,
      List<PhotoSelectionImagesModel>? photoSelectionsData,
      bool isFromUnAuth = false}) async {
    localPhotosList.value.clear();

showLog("getInitialData eventCode $eventCode");
    if (folderCode != null &&
        photoSelectionsData!.isNotEmpty &&
        photoSelectionsData.isNotEmpty) {
      photoSelections = photoSelectionsData;
    }
    publicPath = studioPublicPath;
    try {
      loading = true;
      if (storagePath == null) {
        await getStoragePaths();
      } else {
        documentDirectory = storagePath.DocumentPath;
        publicStoragePath = storagePath.public;
        privateStoragePath = storagePath.private;
      }

      setBusy(false);
      if (!isWithoutFace) {
        if (albumCode == null && folderCode != null && status != null) {
          // its person photo selection
          await getPhotos(folderCode, status, personCode);
        }
        if (albumCode != null && folderCode == null) {
          // its album persons

          await getImages(albumCode, personCode);
        }

        if (albumCode == null && folderCode == null) {
          if (personCode != null &&
              personCode.isNotEmpty &&
              eventCode != null) {
            AlbumController albumController = AlbumController();
            photosList.value = await albumController.getAlbumPersonImages(
                personCode, eventCode);
            PersonAlbumDao faceModelDao = PersonAlbumDao();
            appDb.PersonsAlbum? person =
                await faceModelDao.getFacesByCode(code: personCode);
            personImage = person!.image;
            showLog('personImage:${person.image}');
          }
          if (realPersons != null &&
              realPersons.isNotEmpty &&
              eventCode != null) {
            showLog('real persons photo grid ${realPersons.length}');
            AlbumController albumController = AlbumController();
            for (int i = 0; i < realPersons.length; i++) {
              var res = await albumController.getAlbumPersonImages(
                      realPersons[i], eventCode) ??
                  [];
              showLog('res : photo grid ${res.length}');

              for (int i = 0; i < res.length; i++) {
                if (!photosList.value!.contains(res[i]) &&
                    !urls.contains(res[i]?.originalName)) {
                  photosList.value?.add(res[i]);
                  urls.add(res[i]!.originalName!);

                  showLog('user Persons photosList i ${res[i]?.originalName}');
                } else {
                  showLog('else part duplicate values} ');
                }
              }
              showLog(
                  'realPersons photosList ${realPersons[i]} 12 {photosList.value}');

              PersonAlbumDao faceModelDao = PersonAlbumDao();
              appDb.PersonsAlbum? person =
                  await faceModelDao.getFacesByCode(code: realPersons[i]);
              //if (isFromUnAuth == false) {
                showLog('realPersons 1 ${person!.image}');

                personImageForUserPersons?.add(person.image);
            //  }
            }
            showLog(
                'personImageForUserPersons last $personImageForUserPersons');
          }
        }
      } else {
        showLog("the status is ${status}");
        if (status != null) {
          await getPhotos('', status, personCode, eventCode: eventCode);
        } else {
          AlbumController albumController = AlbumController();
          photosList.value =
              await albumController.getAlbumWithoutPersonImages(eventCode!);
        }
        //await getPerson(personCode!);
        getPath();
      }
      double threshold = 200.0;
      scrollController.addListener(() async {
        isScrolling = true;
        showLog('scrolling... saving offset');

        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          showLog("End of list");
          addPhotosToList();
        }
        if (scrollController.position.maxScrollExtent -
                scrollController.position.pixels <=
            threshold) {
          showLog("Near end of list");
          addPhotosToList();
        }
      });
      int index = await scrollIndexManager
              .getScrollIndex(folderCode ?? albumCode ?? eventCode ?? '') ??
          0;
      showLog("index getInt $index");

      int comparison = photosList.value!.length >= 15
          ? index + 15
          : photosList.value!.length;
      showLog("index comparison before $comparison");

      comparison = (comparison > photosList.value!.length)
          ? photosList.value!.length
          : comparison;
      showLog("index comparison after $comparison");

      for (int i = 0; i < comparison; i++) {
        localPhotosList.value.add(photosList.value![i]!);
      }
      await getEAlbumMp3(eventCode);
      await addImagesForCarousel(localPhotosList.value);
      await getUserPersons();
      loading = false;
      setBusy(false);

/*      if(photosList.value != null && photosList.value!.isNotEmpty){
        for (int i=0; i<photosList.value!.length; i++) {
          if(photosList.value?[i] != null){
            await cacheUtil.getCacheFile(
              url: photosList.value![i]!.url!,
            );
          }

        }
      }*/
    } catch (e, s) {
      showLog("the exception in photo grid \n $s");
    }
    photosListLength.value = photosList.value!.length;
    showLog('photosListLength ${photosListLength.value} value jay');
    await getResources(eventCode);
    await checkUserOwnEvent(eventCode);
  }

  checkUserOwnEvent(eventCode) async {
    if (eventCode != null) {
      EventModelDao eventModelDao = EventModelDao();
      appDb.Event? event = await eventModelDao.getEventByCode(eventCode);
      showLog(
          'checkUserOwnEvent ${event?.ownedByUser} and have download permission ${event?.ownerDownload}');
      if (event?.ownedByUser == true && event?.ownerDownload == true) {
        viewDownloadButton = true;
      }
      showLog('checkUserOwnEvent download $viewDownloadButton,,, ,,, ');
      return;
    }
  }

  getResources(String? eventCode) async {
    if (eventCode != null) {
      EventModelDao eventModelDao = EventModelDao();
      appDb.Event? event = await eventModelDao.getEventByCode(eventCode);

      if ((event != null && event.isAlbumDownloadable ||
          (event != null && event.myPhotosDownloadable))) {
        showLog(
            "step 31q2${event.isAlbumDownloadable} 21${event.myPhotosDownloadable}");
        viewDownloadButton = true;
      }
    }
  }

  void toggleSelection(int index) {
    showLog('toggleSelection ${photoSelections.length}');
    isSelectionMode = true;
    if (selectedIndices.contains(index)) {
      selectedIndices.remove(index);
      multiplePhotoSelections.remove(index);
    } else {
      selectedIndices.add(index);
      multiplePhotoSelections.add(photoSelections[index]);
    }
    showLog('multiplePhotoSelections ${multiplePhotoSelections.length}');
    notifyListeners();
  }

  void clearSelection() {
    isSelectionMode = false;
    selectedIndices.clear();
    notifyListeners();
  }

  updateUI() {
    List<int> indicesToRemove = selectedIndices.toList()
      ..sort((a, b) => b.compareTo(a));

    // Remove each index from the highest to lowest
    for (int index in indicesToRemove) {
      showLog(' model.photosList.value ${photosList.value?.length}');

      photosList.value?.removeAt(index);
      localPhotosList.value.removeAt(index);

      showLog(' model.photosList.value after ${photosList.value?.length}');
      photosListLength.value = photosList.value!.length;
    }

    notifyListeners();
  }

  getUserPersons() async {
    UserPersonsDao users = UserPersonsDao();
    List<appDb.UserPerson> entities = await users.getUserPersons();
    profileUrl = await PreferenceHelper.getString(profileUrlKey);
    showLog('entity my photos route ${entities}');
    if (entities.isNotEmpty) {
      for (appDb.UserPerson entity in entities) {
        List<dynamic> decodedJson = json.decode(entity.images);
        JvtFileConnectors jvtFileConnectors =
            JvtFileConnectors.fromJson(decodedJson);
        userPersonsNotifier.value.add(jvtFileConnectors);
        userPersonsCode.value.add(entity);
      }
    }
  }

  addImagesForCarousel(List<ImagesViewModel> carouselList) async {
    for (int i = 0; i < carouselList.length; i++) {
      images.add(carouselList[i].url!);
    }
    showLog('addImagesForCarousel $images');
  }

  getEAlbumMp3(eventCode) async {
    showLog('getEAlbumMp3 $eventCode');
    if (eventCode != null) {
      AlbumModelDao albumModelDao = AlbumModelDao();
      List<appDb.Album>? albums =
          await albumModelDao.getAlbumsWhereEventCode(eventCode);
      for (appDb.Album album in albums!) {
        if (album.music!.contains('studio-music')) {
          musicUrl.add(album.music!);
        }
      }
      showLog('musicUrl... $musicUrl');
    }
  }

  Future<void> getStoragePaths() async {
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

  getImages(String albumCode, String? personCode) async {
    AlbumModelDao albumModelDao = AlbumModelDao();
    appDb.Album? album = await albumModelDao.getAlbumByCode(albumCode);
    AlbumController albumController = AlbumController();
    photosList.value = await albumController.getAlbumImages(album!.orders!);
  }

  getPerson(String code) async {
    PersonAlbumDao personAlbumDao = PersonAlbumDao();
    appDb.PersonsAlbum? _person = await personAlbumDao.getFacesByCode(
      code: code,
    );
    if (_person != null) {
      // personView = PersonView(_person.code, _person.image, _person.images);
    }
  }

  Future<void> getPath() async {
    if (studioPublicPath == null) {
      EssentialUtils essentialUtils = EssentialUtils();
      await essentialUtils.loadAppEssentialData();
    }
  }

  getPhotos(String folderCode, int status, String? personCode,
      {String? eventCode}) async {
    List<String> personImagesCodes = [];
    DownloadFilesController downloadFilesController = DownloadFilesController();
    photosList.value?.clear();
    FolderModelDao folderModelDao = FolderModelDao();
    PhotoSelectionImagesModelDao photoSelectionModelDao =
        PhotoSelectionImagesModelDao();
    if (folderCode.isEmpty) {
      PersonPhotoSelectionDao faceModelDao = PersonPhotoSelectionDao();
      if (personCode != null) {
        appDb.PersonsPhotoSelection? person =
            await faceModelDao.getFacesByCode(code: personCode);
        personImagesCodes = person!.images.split(",");
        personImage = person.image;
      } else {
        WithoutPersonPhotoSelectionDao faceModelDao =
            WithoutPersonPhotoSelectionDao();
        appDb.WithOutPersonsPhotoSelectionData? person =
            await faceModelDao.getWithoutFacesByCode(eventCode: eventCode!);
        personImagesCodes = person!.images.split(",");
      }

      for (String personImagesCode in personImagesCodes) {
        PhotoSelectionImagesModel? image = await photoSelectionModelDao
            .getPhotoSelectionImageFileWhereCode(personImagesCode, status);
        if (image != null) {
          photosList.value?.add(ImagesViewModel(
              url: downloadFilesController.createUrl(
                  file: image.file!,
                  privatePath: privateStoragePath!,
                  publicPath: publicStoragePath!),
              orderCode: ""));
        }
      }
      return;
    } else {
      List<String> codes =
          await folderModelDao.getChildrenCodes(folderCode, []);
      for (String code in codes) {
        List<PhotoSelectionImagesModel> photoSelections =
            await photoSelectionModelDao.getPhotoSelectionWhereFolderCode(
                code, status);
        photoSelections.forEach((element) {
          showLog("fff $code,$status");
          photosList.value?.add(ImagesViewModel(
            url: downloadFilesController.createUrl(
                file: element.file!,
                privatePath: privateStoragePath!,
                publicPath: publicStoragePath!),
          ));
        });
      }
    }
  }

  getAppBarTitle(status, folderCode) {
    FolderStatus folderStatus = FolderStatus();
    return StreamBuilder<appDb.FolderStatuse?>(
        stream: folderStatus.streamFolderStatus(folderCode),
        builder: (BuildContext context,
            AsyncSnapshot<appDb.FolderStatuse?> snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          }
          if (snapshot.hasError) {
            return SizedBox();
          }
          switch (status) {
            case 1:
              {
                return UniqueText(
                  text: "${S.of(context).selectedPhotos}",
                  //isAppBar: true,
                  //style: Theme.of(context).textTheme.headlineSmall.copyWith(color: AppColorData.appBarTitleColor,)
                );
              }
            case 2:
              {
                return UniqueText(
                  text: "${S.of(context).rejectedPhotos}",
                );
              }
            case 3:
              {
                return UniqueText(
                  text: "${S.of(context).undecidedPhotos}",
                );
              }
            default:
              {
                return UniqueText(
                  text: "",
                );
              }
          }
        });
  }

  void addPhotosToList() {
    int previousLength = localPhotosList.value.length;
    int counter = 0;
    if (photosList.value != null) {
      for (ImagesViewModel? photos in photosList.value!) {
        if (counter == 5) {
          break;
        }
        if (!localPhotosList.value.contains(photos)) {
          showLog("add images $counter");
          localPhotosList.value.add(photos!);
          counter++;
        }
      }
      if (previousLength < localPhotosList.value.length) {
        showLog("more image added..");
        setBusy(false);
      }
    }
  }

  getTitle(String appBarTitle) {
    if (appBarTitle.contains("&amp;")) {
      appBarTitle = appBarTitle.replaceAll("&amp;", "&");
    }
    return appBarTitle;
  }
}
