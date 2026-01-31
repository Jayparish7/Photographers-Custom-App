import 'package:flutter/material.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/driftdb/dao/person_photo_selection_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_images_dao.dart';
import 'package:photomall_flutter/driftdb/dao/without_face_photo_selection_dao.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';
import 'package:photomall_flutter/ui/base/base_observer.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;

class PersonSelectionViewModel extends BaseObserver {
  PersonSelectionViewModel({
    this.apiHandler,
    this.context,
  }) {
    apiRepo = PhotomallApis(this.context);
  }

  BuildContext? context;
  ApiHelper? apiHandler;
  PhotomallApis? apiRepo;
  bool isLoading = false;
  String? publicPath;
  int selected = 0;
  int rejected = 0;
  int waiting = 0;
  PersonPhotoSelectionDao faceModelDao = PersonPhotoSelectionDao();
  String personImageURl = "";

  @override
  void onInternetConnectionBack() {
    // TODO: implement onInternetConnectionBack
  }

  initialMethod(
    String? personCode,
    String? eventCode,
  ) async {
    isLoading = true;
    setBusy(false);
    getPath();
    if (personCode != null) {
      await getPersonsList(personCode);
    } else {
      await getWithoutPersonsList(eventCode!);
    }
    setBusy(false);
    isLoading = false;
  }

  getPersonsList(String code) async {
    List<String> images = [];
    PhotoSelectionImagesModelDao photoSelectionImagesModelDao =
        PhotoSelectionImagesModelDao();
    selected = 0;
    rejected = 0;
    waiting = 0;
    appDb.PersonsPhotoSelection? person =
        await faceModelDao.getFacesByCode(code: code);
    getPersonImage(person!.image);
    images = person.images.split(',');
    for (String imageCode in images) {
      appDb.PhotoSelectionImage? image = await photoSelectionImagesModelDao
          .getPhotoSelectionImageWhereCode(imageCode);
      if (image != null) {
        switch (image.status) {
          case photoSelectionImageSelectedStatus:
            {
              selected++;
            }
            break;
          case photoSelectionImageRejectedStatus:
            {
              rejected++;
            }
            break;
          case photoSelectionImageWaitingStatus:
            {
              waiting++;
            }
            break;
          default:
            {
              showLog("enter into default some error ");
            }
            break;
        }
      }
    }
  }

  getRealPersonsList(List<String?>? realCode) async {
    List<String> images = [];
    PhotoSelectionImagesModelDao photoSelectionImagesModelDao =
        PhotoSelectionImagesModelDao();
    selected = 0;
    rejected = 0;
    waiting = 0;
    for (int i = 0; i < realCode!.length; i++) {
      appDb.PersonsPhotoSelection? person =
          await faceModelDao.getFacesByCode(code: realCode[i]);
      getPersonImage(person!.image);
      images = person.images.split(',');
    }
    for (String imageCode in images) {
      appDb.PhotoSelectionImage? image = await photoSelectionImagesModelDao
          .getPhotoSelectionImageWhereCode(imageCode);
      if (image != null) {
        switch (image.status) {
          case photoSelectionImageSelectedStatus:
            {
              selected++;
            }
            break;
          case photoSelectionImageRejectedStatus:
            {
              rejected++;
            }
            break;
          case photoSelectionImageWaitingStatus:
            {
              waiting++;
            }
            break;
          default:
            {
              showLog("enter into default some error ");
            }
            break;
        }
      }
    }
  }

  getWithoutPersonsList(String eventCode) async {
    WithoutPersonPhotoSelectionDao withoutPersonPhotoSelectionDao =
        WithoutPersonPhotoSelectionDao();
    List<String> images = [];
    PhotoSelectionImagesModelDao photoSelectionImagesModelDao =
        PhotoSelectionImagesModelDao();
    selected = 0;
    rejected = 0;
    waiting = 0;
    appDb.WithOutPersonsPhotoSelectionData? withoutImages =
        await withoutPersonPhotoSelectionDao.getWithoutFacesByCode(
            eventCode: eventCode);
    if (withoutImages != null) {
      images = withoutImages.images.split(',');
      for (String imageCode in images) {
        appDb.PhotoSelectionImage? image = await photoSelectionImagesModelDao
            .getPhotoSelectionImageWhereCode(imageCode);
        if (image != null) {
          switch (image.status) {
            case photoSelectionImageSelectedStatus:
              {
                selected++;
              }
              break;
            case photoSelectionImageRejectedStatus:
              {
                rejected++;
              }
              break;
            case photoSelectionImageWaitingStatus:
              {
                waiting++;
              }
              break;
            default:
              {
                showLog("enter into default some error ");
              }
              break;
          }
        }
      }
    }
  }

  Future<void> getPath() async {
    if (studioPublicPath == null) {
      EssentialUtils essentialUtils = EssentialUtils();
      await essentialUtils.loadAppEssentialData();
    }
    publicPath = studioPublicPath;
  }

  void getPersonImage(String image) {
    personImageURl = '$publicPath/$image';
  }
}
