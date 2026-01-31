import 'package:flutter/material.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/photo_selection_image_controller.dart';
import 'package:photomall_flutter/core/Utils/file_util.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_status_dao.dart';
import 'package:photomall_flutter/driftdb/dao/person_photo_selection_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_current_index_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_images_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_table_dao.dart';
import 'package:photomall_flutter/driftdb/dao/without_face_photo_selection_dao.dart';
import 'package:photomall_flutter/traits/image_processor.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';
import 'package:photomall_flutter/ui/base/base_model.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_image_alert_dialouge.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:toastification/toastification.dart';

import '../../../../driftdb/dao/folder_rule_dao.dart';
import '../../../../driftdb/dao/real_person_photo_selection_dao.dart';
import '../../../../generated/l10n.dart';

class PhotoSelectionRouteViewModel extends BaseModel {
  BuildContext context;
  bool loading = false;
  String downloadUrl = '';
  String downloadImageName = '';
  String downloadOrderCode = '';
  bool downloadEnabled = false;
  PhotomallApis? apiRepo;
  var documentDirectory;
  String? publicStoragePath;
  String? privateStoragePath;
  String? currentIndeximageCode = '';
  bool isDemoEvent = false;
  final ValueNotifier<bool> leftSwipeIndicator = ValueNotifier<bool>(false);
  final ValueNotifier<bool> rightSwipeIndicator = ValueNotifier<bool>(false);
  final ValueNotifier<bool> submitStatus = ValueNotifier<bool>(false);
  final ValueNotifier<bool> undoVisibility = ValueNotifier<bool>(false);
  final ValueNotifier<List<PhotoSelectionImagesModel>> items =
      ValueNotifier<List<PhotoSelectionImagesModel>>([]);
  PhotoSelectionImagesModel? previousPhotoSelectionData;

  List<PhotoSelectionImagesModel> photoSelections = [];

//  List<PhotoSelectionImagesModel> photoSelectionsView = [];
  PhotoSelectionImagesModelDao photoSelectionModelDao =
      PhotoSelectionImagesModelDao();
  ImageProcessor imageProcessor = ImageProcessor();
  FolderModelDao folderModelDao = FolderModelDao();
  int currentIndex = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  PageController itemScrollController = PageController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  FileUtil fileUtil = FileUtil();
  PhotoSelectionImageController photoSelectionImageController =
      PhotoSelectionImageController();
  bool isSubmitted = false;
  List<String> realPersonsPS = [];
  FolderRulesDao folderRulesDao = FolderRulesDao();
  FolderStatus folderStatusDao = FolderStatus();

  /// new method
  Widget? leftSwipeStatus;
  Widget? rightSwipeStatus;

  PhotoSelectionRouteViewModel(this.context) {
    this.apiRepo = PhotomallApis(this.context);
  }

  // init method to implement
  Future<void> getPhotoSelectionImages(
    folderCode,
    status,
    String? personCode,
    String? eventCode,
    String? eventCodeForDownload,
  ) async {
    loading = true;
    setBusy(true);
    // get own folder count
    showLog("the person code where eventCodeForDownload $eventCode ---- $eventCodeForDownload");
    await getStoragePaths();

    await generatePhotoList(folderCode, status, personCode,
        eventCode: eventCode, realPersonsPS: realPersonsPS);

    prepareSwipeStatus(status);

    await checkIsDemoEvent();

    getSubmitStatus(folderCode, callBack: () {
      generatePhotoList(
        folderCode,
        status,
        personCode,
      );
    });
    itemScrollController = PageController(initialPage: currentIndex);
    await checkDownLoadEnabled(eventCode ?? eventCodeForDownload ?? '');
    showLog('photoselectdata${photoSelections.length} ${items.value.length}');
    loading = false;
    setBusy(false);
  }

  checkDownLoadEnabled(String eventCode) async {
    EventModelDao eventModelDao = EventModelDao();
    appDb.Event? event = await eventModelDao.getEventByCode(eventCode);
    showLog('checkDownLoadEnabled $eventCode');
    if (event?.downloadable == true) {
      downloadEnabled = true;
    }
  }

  getAlertToast(String code, int status) async {
    appDb.FolderRule? folderRule =
        await folderRulesDao.getFolderRuleByFolderCode(code);
    appDb.FolderStatuse? folderStatus =
        await folderStatusDao.getFolderStatusByFolderCode(code);
    showLog('getAlertToast  $status $folderRule $code');
    if (folderRule != null &&
        folderStatus != null &&
        (status == 3 || status == 2)) {
     /* int remainingPhotos =
          ((folderRule.maximumSelectionImages) - (folderStatus.selected + 1))
              .toInt();*/
      int maxFolderCondition = folderRule.maximumSelectionImages;
      if (folderRule.maximumSelectionImages.toInt() ==
          folderStatus.selected + 1) {
        ToastUtil.getToastification(
            context,
            '${S.of(context).YouHaveReached} $maxFolderCondition ${S.of(context).Photos}',
            Colors.white,
            ToastificationType.success);
      }
      int exceededCount =
          folderStatus.selected + 1 - folderRule.maximumSelectionImages.toInt();
      if ((exceededCount == 1) ||
          (exceededCount > 0 && exceededCount % 10 == 0)) {
        ToastUtil.getToastification(
            context,
            '${S.of(context).YouHaveExceeded} ${(folderStatus.selected + 1) - (folderRule.maximumSelectionImages.toInt())} ${S.of(context).Photos}.',
            Colors.white,
            ToastificationType.error);
      }
      if ((folderRule.maximumSelectionImages * 0.25).toInt() ==
          folderStatus.selected + 1) {
        /*int roundOff =
            (((folderRule.maximumSelectionImages * 0.25) / 2) == 0) ? 1 : 0;*/

        ToastUtil.getToastification(
            context,
            '${S.of(context).YouHaveSelected} ${(folderRule.maximumSelectionImages * 0.25).toInt()} ${S.of(context).outOf} $maxFolderCondition ${S.of(context).Photos}',
            Colors.white,
            ToastificationType.info);
      }
      if ((folderRule.maximumSelectionImages * 0.5).toInt() ==
          folderStatus.selected + 1) {
        /*int roundOff =
            (((folderRule.maximumSelectionImages * 0.5) / 2) == 0) ? 1 : 0;*/

        ToastUtil.getToastification(
            context,
            '${S.of(context).YouHaveSelected} ${(folderRule.maximumSelectionImages * 0.5).toInt()} ${S.of(context).outOf} $maxFolderCondition ${S.of(context).Photos}.',
            Colors.white,
            ToastificationType.info);
      }
      if ((folderRule.maximumSelectionImages * 0.75).toInt() ==
          folderStatus.selected + 1) {
       /* int roundOff =
            (((folderRule.maximumSelectionImages * 0.75) / 2) == 0) ? 1 : 0;*/

        ToastUtil.getToastification(
            context,
            '${S.of(context).YouHaveSelected} ${(folderRule.maximumSelectionImages * 0.75).toInt()} ${S.of(context).outOf} $maxFolderCondition ${S.of(context).Photos}',
            Colors.white,
            ToastificationType.info);
      }
    }
  }

  Future<void> getStoragePaths() async {
    if (studioPublicPath != null &&
        appDocumentDirectoryPath != null &&
        studioPrivatePath != null) {
      documentDirectory = appDocumentDirectoryPath;
      publicStoragePath = studioPublicPath;
      privateStoragePath = studioPublicPath;
    } else {
      EssentialUtils essentialUtils = EssentialUtils();
      essentialUtils.loadAppEssentialData();
      documentDirectory = appDocumentDirectoryPath;
      publicStoragePath = studioPublicPath;
      privateStoragePath = studioPublicPath;
    }
  }

  updateCurrentIndex(String folderCode, int status,
      {int? index, String? photoSelectionImagesCode}) async {
    PhotoSelectionCurrentIndex photoSelectionCurrentIndex =
        PhotoSelectionCurrentIndex();
    await photoSelectionCurrentIndex.updateCurrentIndex(
        folderCode: folderCode,
        photoSelectionCode: photoSelectionImagesCode ??
            photoSelections[index!].photoSelectionImage!.code,
        status: status);
  }

  Future<void> getCurrentIndex({folderCode, status}) async {
    if (folderCode.isEmpty) {
      currentIndex = 0;
      return;
    }
    PhotoSelectionCurrentIndex photoSelectionCurrentIndex =
        PhotoSelectionCurrentIndex();
    // check photo selection current index available
    //if available check the code in this list
    // if available pass that index as initial index
    // else 0 as initial index
    appDb.PhotoSelectionCurrentIndexData? photoSelectionCurrentIndexData =
        await photoSelectionCurrentIndex.getCurrentIndex(folderCode, status);
    if (photoSelectionCurrentIndexData != null) {
      String currentIndexCode =
          photoSelectionCurrentIndexData.photoSelectionCode;
      showLog('the getted code where ${currentIndexCode}');
      currentIndex = photoSelections.indexWhere((element) {
        return element.photoSelectionImage!.code == currentIndexCode;
      });

      if (currentIndex == -1) {
        currentIndex = 0;
      }
    } else {
      // insert new
      if (photoSelections.isNotEmpty) {
        await photoSelectionCurrentIndex.insertCurrentIndex(
            status: status,
            photoSelectionCode: photoSelections[0].photoSelectionImage!.code,
            folderCode: folderCode);
      }
      currentIndex = 0;
    }
  }

  getRealPersonCodePS(eventCode) async {
    if (eventCode != null) {
      RealPersonPhotoSelectionDao realPersonPhotoSelectionDao =
          RealPersonPhotoSelectionDao();
      List<appDb.RealPersonsPhotoSelection?> personsCode =
          await realPersonPhotoSelectionDao.getFacesByEvent(
              eventCode: eventCode);
      if (personsCode.isNotEmpty) {
        for (int i = 0; i < personsCode.length; i++) {
          realPersonsPS.add(personsCode[i]!.persons);
        }
        showLog('getRealPersonCodePS ${realPersonsPS}');
      }
    }
  }

  Future<void> getPhotoSelectionList(
      String folderCode,
      int status,
      String? personCode,
      String? eventCode,
      List<String?>? realPersonsCode) async {
    photoSelections.clear();
    showLog('getPhotoSelectionList  here1 $realPersonsCode $eventCode');

    if (folderCode.isEmpty) {
      List<String> personImagesCodes = [];
      PersonPhotoSelectionDao faceModelDao = PersonPhotoSelectionDao();
      if (personCode != null && personCode.isNotEmpty) {
        appDb.PersonsPhotoSelection? person =
            await faceModelDao.getFacesByCode(code: personCode);
        personImagesCodes = person!.images.split(",");
      }
      /*else if(realPersonsCode !=null && realPersonsCode.isNotEmpty){
        showLog('else if $realPersonsCode');

        for(int i= 0;i<realPersonsCode.length;i++){
          appDb.PersonsPhotoSelection? person =
          await faceModelDao.getFacesByCode(code: realPersonsCode[i]);
          personImagesCodes = person!.images.split(",");
        }
     }*/
      else {
        WithoutPersonPhotoSelectionDao withoutPersonPhotoSelectionDao =
            WithoutPersonPhotoSelectionDao();
        appDb.WithOutPersonsPhotoSelectionData? data =
            await withoutPersonPhotoSelectionDao.getWithoutFacesByCode(
                eventCode: eventCode!);
        personImagesCodes = data!.images.split(",");
      }

      for (String personImagesCode in personImagesCodes) {
        PhotoSelectionImagesModel? image = await photoSelectionModelDao
            .getPhotoSelectionImageFileWhereCode(personImagesCode, status);
        if (image != null) {
          photoSelections.add(image);
        }
      }

      return;
    }
    List<String> codes = await folderModelDao.getChildrenCodes(folderCode, []);

    for (String code in codes) {
      List<PhotoSelectionImagesModel> photoSelection =
          await photoSelectionModelDao.getPhotoSelectionWhereFolderCode(
              code, status);
      showLog(
          'photoSelection is an ${photoSelection.length} code is $code status$status');
      photoSelection.forEach((element) {
        showLog('the length of the photoSelections.length whereas ${element.photoSelectionImage?.originalName}');

        photoSelections.add(element);
      });

      //  preparePhotosForListing();
    }
  }

  void prepareSwipeStatus(status) {
    // photoSelectionImageSelectedStatus = 1;
    //  photoSelectionImageRejectedStatus = 2;
    //  photoSelectionImageWaitingStatus = 3;
    if (status == 1) {
      showLog(
          "Selection status is >>  ${status} and its rejected or Undecided");
      leftSwipeStatus = swipeStatusCard(
        cardColor: AppColorData.selectionStatusRejectedCard,
        textChild: CommonText(
          isRejectedTitle: true,
          text: S.of(context).rejected,
        ),
        iconChild: Icon(
          Icons.cancel_outlined,
          color: AppColorData.selectionStatusCardRejectedText,
          size: 30,
        ),
      );

      rightSwipeStatus = swipeStatusCard(
        cardColor: AppColorData.selectionStatusUndecidedCard,
        textChild: CommonText(
          isUndecidedTitle: true,
          text: S.of(context).undecided,
        ),
        iconChild: Icon(
          Icons.timer,
          color: AppColorData.selectionStatusCardUndecidedText,
          size: 30,
        ),
      );
    }
    if (status == 3) {
      leftSwipeStatus = swipeStatusCard(
        cardColor: AppColorData.selectionStatusRejectedCard,
        textChild: CommonText(
          isRejectedTitle: true,
          text: S.of(context).rejected,
        ),
        iconChild: Icon(
          Icons.cancel_outlined,
          color: AppColorData.selectionStatusCardRejectedText,
          size: 30,
        ),
      );

      rightSwipeStatus = swipeStatusCard(
        cardColor: AppColorData.selectionStatusSelectedCard,
        textChild: CommonText(
          isSelectedTitle: true,
          text: S.of(context).selected,
        ),
        iconChild: Icon(
          Icons.check,
          size: 30,
          color: AppColorData.selectionStatusCardSelectedText,
        ),
      );
    }
    if (status == 2) {
      leftSwipeStatus = swipeStatusCard(
        cardColor: AppColorData.selectionStatusUndecidedCard,
        textChild: CommonText(
          isUndecidedTitle: true,
          text: S.of(context).undecided,
        ),
        iconChild: Icon(
          Icons.timer,
          color: AppColorData.selectionStatusCardUndecidedText,
          size: 30,
        ),
      );

      rightSwipeStatus = swipeStatusCard(
        cardColor: AppColorData.selectionStatusSelectedCard,
        textChild: CommonText(
          isSelectedTitle: true,
          text: S.of(context).selected,
        ),
        iconChild: Icon(
          Icons.check,
          size: 30,
          color: AppColorData.selectionStatusCardSelectedText,
        ),
      );
    }
  }

  Widget swipeStatusCard({
    required Color cardColor,
    required Widget textChild,
    required Widget iconChild,
  }) {
    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: iconChild,
            ),
            Padding(padding: const EdgeInsets.all(3), child: textChild),
          ],
        ),
      ),
    );
  }

  void getSubmitStatus(folderCode, {required Function callBack}) async {
    FolderModelDao folderModelDao = FolderModelDao();
    PhotoSelectionsDao photoSelectionsDao = PhotoSelectionsDao();
    appDb.Folder? folder = await folderModelDao.getFolderWhereCode(folderCode);
    Stream<appDb.PhotoSelection?>? photoSelection =
        photoSelectionsDao.streamPhotoSelectionByEventCode(folder?.eventCode);
    photoSelection?.listen((photo) {
      if (photo!.confirmationStatus) {
        callBack();
        submitStatus.value = true;
      } else {
        submitStatus.value = false;
      }
    });
  }

  Future<Object?> zoomImageMode(PhotoSelectionImagesModel item) async {
    showLog('the zoom mode is on');
    return await showGeneralDialog(
        context: context,
        pageBuilder: (_, __, ___) => Container(
          color: Colors.black,
              child: imageDialog(item, context,
                  privateStoragePath: privateStoragePath!,
                  publicStoragePath: publicStoragePath!),
            ));
  }

  getCountOfImages(status, folderCode) {
    if (folderCode.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Center(
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(width: 3.0, color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(
                      50.0) //                 <--- border radius here
                  ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: CommonText(
                text: " ${photoSelections.length}",
                isAppBar: true,
                //style: Theme.of(context).textTheme.headlineSmall.copyWith(color: AppColorData.appBarTitleColor,)
              ),
            ),
          ),
        ),
      );
    }
    FolderStatus folderStatus = FolderStatus();
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(width: 3.0, color: Colors.white),
            borderRadius: BorderRadius.all(
                Radius.circular(50.0) //                 <--- border radius here
                ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: StreamBuilder<appDb.FolderStatuse?>(
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
                        return Text(" ${snapshot.data!.selected}",
                            style: TextStyle(fontSize: 18, color: Colors.white)
                            //isAppBar: true,
                            //style: Theme.of(context).textTheme.headlineSmall.copyWith(color: AppColorData.appBarTitleColor,)
                            );
                      }
                    case 2:
                      {
                        return Text(" ${snapshot.data!.rejected}",
                            style: TextStyle(fontSize: 18, color: Colors.white)
                            //isAppBar: true,
                            //style: Theme.of(context).textTheme.headlineSmall.copyWith(color: AppColorData.appBarTitleColor,)
                            );
                      }
                    case 3:
                      {
                        return Text("${snapshot.data!.waitingListed}",
                            style: TextStyle(fontSize: 18, color: Colors.white)
                            //isAppBar: true,
                            //style: Theme.of(context).textTheme.headlineSmall.copyWith(color: AppColorData.appBarTitleColor,)
                            );
                      }
                      break;
                    default:
                      {
                        return UniqueText(
                          text: "",
                        );
                      }
                  }
                }),
          ),
        ),
      ),
    );
  }

  getAppBarTitle(status, folderCode) {
    switch (status) {
      case 1:
        {
          return Text(
            "${S.of(context).selectedPhotos}",
            style: TextStyle(fontSize: 18, color: Colors.white),
            // isAppBar: true,
            //style: Theme.of(context).textTheme.headlineSmall.copyWith(color: AppColorData.appBarTitleColor,)
          );
        }
      case 2:
        {
          return Text("${S.of(context).rejectedPhotos}",
              style: TextStyle(fontSize: 18, color: Colors.white)
              //isAppBar: true,
              //style: Theme.of(context).textTheme.headlineSmall.copyWith(color: AppColorData.appBarTitleColor,)
              );
        }
      case 3:
        {
          return Text("${S.of(context).undecidedPhotos}",
              style: TextStyle(fontSize: 18, color: Colors.white)
              //isAppBar: true,
              //style: Theme.of(context).textTheme.headlineSmall.copyWith(color: AppColorData.appBarTitleColor,)
              );
        }
      default:
        {
          return UniqueText(
            text: "",
          );
        }
    }
  }

  Future<void> checkIsDemoEvent() async {
    if ( photoSelections.isNotEmpty) {
      EventModelDao eventModelDao = EventModelDao();
      appDb.Event? event = await eventModelDao.getEventByPhotoSelectionCode(
          photoSelections[0].photoSelectionImage!.code);
      if (event == null) {
        isDemoEvent = false;
      } else {
        if (event.type == 6) {
          isDemoEvent = true;
        } else {
          isDemoEvent = false;
        }
      }
    }
  }

  Future<void> undoPhotoSelection(
      String folderCode, int status, String? personCode,
      {String? eventCode}) async {
    if (previousPhotoSelectionData != null) {
      PhotoSelectionImageController photoSelectionImageController =
          PhotoSelectionImageController();
      await photoSelectionImageController
          .undoPhotoSelectionByPhotoSelectionCode(
              previousPhotoSelectionData: previousPhotoSelectionData,
              status: status);
      generatePhotoList(
        folderCode,
        status,
        personCode,
      );
    } else {
      ToastUtil.showSnackBarAtCurrentState(S.of(context).noMorePreviousAction);
    }
    previousPhotoSelectionData = null;
  }

  Future<void> generatePhotoList(
      String folderCode, int status, String? personCode,
      {String? eventCode, List<String>? realPersonsPS}) async {
    //await getRealPersonCodePS(eventCode);
    await getPhotoSelectionList(
        folderCode, status, personCode, eventCode, realPersonsPS);
    await getCurrentIndex(folderCode: folderCode, status: status);
    await generateViewList();
  }

  generateViewList() {
    showLog('list generating again ... step 1');
    items.value = List<PhotoSelectionImagesModel>.generate(
        photoSelections.length, (int index) {
      return photoSelections[index];
    });
  }
}

class PhotoSelectionImagesModel {
  final appDb.JvtFile? file;
  final appDb.JvtFileConnector? fileConnector;
  final appDb.PhotoSelectionImage? photoSelectionImage;

  PhotoSelectionImagesModel({
    this.fileConnector,
    this.photoSelectionImage,
    this.file,
  });
}
