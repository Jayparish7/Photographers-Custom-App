import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart' as api;
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_status_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_images_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_table_dao.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';
import 'package:photomall_flutter/ui/album/photoselection/select/photo_selection_route_view_model.dart';
import 'package:photomall_flutter/ui/folders/folder_photo_selection_model.dart';
import 'package:photomall_flutter/ui/photoselection/model/photo_selection_request_model.dart'
    as request;
import 'package:photomall_flutter/ui/photoselection/model/photo_selection_response_model.dart';

import '../core/constants/studio_config_constants.dart';

class PhotoSelectionImageController {
  List<request.PhotoSelectionImageStatus> updatePhotos = [];
  PhotoSelectionImagesModelDao photoSelectionModelDao =
      PhotoSelectionImagesModelDao();
  EventModelDao eventModelDao = EventModelDao();

  /// photoSelectionImageSelectedStatus = 1;
  ///  photoSelectionImageRejectedStatus = 2;
  ///  photoSelectionImageWaitingStatus = 3;

  Future<void> updatePhotoStatus(
      {BuildContext? context,
      String? direction,
      appDb.PhotoSelectionImage? photoSelectionImage,
      int? status,
      bool? isDemoEvent}) async {
    showLog('the direction ${direction} status ${status}');
    PhotoSelectionImagesModelDao photoSelectionModelDao =
        PhotoSelectionImagesModelDao();
    int? newStatus;
    switch (status) {
      case 1:
        {
          if (direction == 'right') {
            //waiting
            newStatus = photoSelectionImageWaitingStatus;
          } else {
            // rejection
            newStatus = photoSelectionImageRejectedStatus;
          }
        }
        break;
      case 2:
        {
          if (direction == 'right') {
            //select
            newStatus = photoSelectionImageSelectedStatus;
          } else {
            // waiting
            newStatus = photoSelectionImageWaitingStatus;
          }
        }
        break;
      case 3:
        {
          if (direction == 'right') {
            //select
            newStatus = photoSelectionImageSelectedStatus;
          } else {
            // reject
            newStatus = photoSelectionImageRejectedStatus;
          }
        }
        break;
    }
    // get event code for this photo in folder table
    FolderModelDao folderModelDao = FolderModelDao();
    appDb.Folder? folder = await folderModelDao
        .getFolderWhereCode(photoSelectionImage!.folderCode);

    photoSelectionModelDao
        .updatePhotoSelectionImage(appDb.PhotoSelectionImagesCompanion(
      folderCode: drift.Value(photoSelectionImage.folderCode),
      comment: drift.Value(photoSelectionImage.comment),
      lastUpdated: drift.Value(photoSelectionImage.lastUpdated),
      rating: drift.Value(photoSelectionImage.rating),
      code: drift.Value(photoSelectionImage.code),
      synced: drift.Value(false),
      status: drift.Value(newStatus!),
    ));

    // get event by event code
    //appDb.Event? _event = await eventModelDao.getEventByCode(folder!.eventCode);
    // call api for update same event in server
    showLog('the api call initiated .. 1 4 $folder ${updatePhotos.length}');
  }

  checkPhotoSelectionImageStatus(String eventCode) async {
    /* int _eventSelectedImages = 0,
        _eventWaitListedImages = 0,
        _eventRejectedImages = 0;
    bool _validationStatus = true;
    PhotoSelectionImagesModelDao photoSelectionModelDao =
        PhotoSelectionImagesModelDao();
    // get local photo selection images synced false rows
    List<appDb.PhotoSelectionImage?>? photoSelectionImages =
        await photoSelectionModelDao
            .getByEventCode(eventCode);

    showLog('value $eventCode');
    if (photoSelectionImages != null || photoSelectionImages!.isNotEmpty) {
      for (appDb.PhotoSelectionImage? photoSelectionImage
          in photoSelectionImages) {
        showLog('photoSelectionImage Status::${photoSelectionImage!.status}');
        switch (photoSelectionImage!.status) {

          case 1:
            {

              _eventSelectedImages++;
            }
            break;
          case 2:
            {
              _eventRejectedImages++;
            }
            break;
          case 3:
            {
              _eventWaitListedImages++;
            }
            break;
        }
      }
    }
    FolderModelDao folderModelDao = FolderModelDao();
    appDb.Folder? parentFolder =
        await folderModelDao.getFolderByEventAndParentNull(eventCode);
    FolderStatus folderStatus = FolderStatus();
    appDb.FolderStatuse? parentFolderStatus = (await folderStatus
        .getSingleByCombinedByFolderCode(parentFolder!.code));
    showLog('parent folder: $parentFolderStatus');
    if (parentFolderStatus?.waitingListed != _eventWaitListedImages) {
      _validationStatus = false;
    }
    if (parentFolderStatus?.selected != _eventSelectedImages &&
        _validationStatus == true) {
      _validationStatus = false;
    }
    if (parentFolderStatus?.rejected != _eventRejectedImages &&
        _validationStatus == true) {
      _validationStatus = false;
    }
    showLog('validationStatus:$_validationStatus');
*/
    FolderStatus folderStatus = FolderStatus();
    /*if (_validationStatus == false)*/
    {
      /*   List<appDb.FolderStatuse?>? folderStatuses =
          await folderStatus.getByEventCode(eventCode);
      showLog('validationStatus11:$folderStatuses');
      if (folderStatuses != null || folderStatuses!.isNotEmpty) {
        for (appDb.FolderStatuse? folderStatus in folderStatuses) {
          FolderStatus folderStatuses = FolderStatus();
          await folderStatuses.resetById(folderStatus!.id);
        }*/
      {
        List<appDb.PhotoSelectionImage?>? photoSelectionImages =
            await photoSelectionModelDao.getByEventCode(eventCode);
        if (photoSelectionImages != null || photoSelectionImages!.isNotEmpty) {
          showLog('reset worked $photoSelectionImages');
          for (appDb.PhotoSelectionImage? photoSelectionImage
              in photoSelectionImages) {
            showLog('reset worked111$photoSelectionImage');
            await folderStatus.toggleFolderStatus(
                folderCode: photoSelectionImage!.folderCode,
                oldStatus: 0,
                newStatus: photoSelectionImage.status,
                ownFolderStatus: 1);

            showLog('reset worked1$photoSelectionImage');
          }
        }
      }
    }
  }

  Future<void> getSyncWithServer() async {
    List<request.PhotoSelectionImageStatus> _photosTobeSynced = [];
    PhotoSelectionImagesModelDao photoSelectionModelDao =
        PhotoSelectionImagesModelDao();
    // get local photo selection images synced false rows
    List<appDb.PhotoSelectionImage> photoSelectionImages =
        await photoSelectionModelDao.getPhotoSelectionWhereSynced(
      false,
    );

    if (photoSelectionImages.isNotEmpty) {
      FolderModelDao folderModelDao = FolderModelDao();
      EventModelDao eventModelDao = EventModelDao();
      for (appDb.PhotoSelectionImage photoSelectionImage
          in photoSelectionImages) {
        //check thi is demo event
        appDb.Folder? folder = await folderModelDao
            .getFolderWhereCode(photoSelectionImage.folderCode);
        appDb.Event? event =
            await eventModelDao.getSingleEventByCode(folder!.eventCode);
        if (event!.type != demoEvent) {
          FolderModelDao folderModelDao = FolderModelDao();
          appDb.Folder? folder = await folderModelDao
              .getFolderWhereCode(photoSelectionImage.folderCode);

          _photosTobeSynced.add(request.PhotoSelectionImageStatus(
            code: photoSelectionImage.code,
            status: photoSelectionImage.status.toString(),
            comment: photoSelectionImage.comment,
            rating: photoSelectionImage.rating.toString(),
            eventCode: folder!.eventCode,
          ));
        }
      }
    }
    if (_photosTobeSynced.isNotEmpty) {
      try {
        showLog(
            'sync with server api method called >> dataNew ${_photosTobeSynced.length}');

        PhotomallApis photomallApis = PhotomallApis(null);
        showLog('message0');
        PhotoSelectionImagesResponseModel syncedPhotoSelectionImages =
            await photomallApis.callPhotoSelectionUpdate(
          null,
          inputData: _photosTobeSynced,
        );

        if (syncedPhotoSelectionImages.photoSelectionImages != null &&
            syncedPhotoSelectionImages.photoSelectionImages!.isNotEmpty) {
          for (PhotoSelectionImage photoSelectionImage
              in syncedPhotoSelectionImages.photoSelectionImages!) {
            showLog('message1');
            await photoSelectionModelDao.toggleSyncedStatusAndLastUpdate(
              photoSelectionImage.code!,
              photoSelectionImage.lastUpdatedAt!,
              true, //Synced status
            );
          }
        } else {
          await photoSelectionModelDao.toggleSyncedStatusAndLastUpdate(
            '',
            0,
            false, //Synced status
          );
        }
      } catch (e) {
        showLog("getSyncWithServer :: getSyncWithServer $e");
      }
    }
  }

  Future<void> updatePhotoSelection(
      {required String eventCode,
      String? photoSelectionCode,
      bool? lastUpdateFailedStatus}) async {
    EventImageStatusModel photoSelectionImagesResponse;
    PhotoSelectionsDao photoSelectionStatusDao = PhotoSelectionsDao();

    appDb.PhotoSelection? photoSelection =
        await photoSelectionStatusDao.getPhotoSelectionByEventCode(eventCode);

    int? lastUpdatedAt =
        (lastUpdateFailedStatus == true) ? 0 : photoSelection?.lastUpdatedAt??0;
    //showLog('event images api $eventCode,$lastUpdatedAt');
    api.PhotomallApis photomallApis = api.PhotomallApis(null);
    try {
      photoSelectionImagesResponse =
          await photomallApis.eventImageStatus(eventCode, lastUpdatedAt!);

      if (photoSelectionImagesResponse != null) {
        await updatePhotoSelectionImagesByApiResponse(
            lastUpdateFailedStatus, photoSelectionImagesResponse, eventCode);
        await photoSelectionStatusDao.insertOrUpdatePhotoStatus(
            photoSelection == null ? photoSelectionCode! : photoSelection.code!,
            photoSelectionImagesResponse,
            eventCode);
        return;
      }
    } catch (e, s) {
      showLog('try catch $s ');
    }
    //showLog('photosCount2');

    // check any missing image available
    appDb.PhotoSelectionImage? _errorImages = await photoSelectionModelDao
        .getInvalidPhotoSelectionImageWhereEventCode(eventCode);
    if (_errorImages != null) {
      await updatePhotoSelection(
          photoSelectionCode: photoSelectionCode,
          eventCode: eventCode,
          lastUpdateFailedStatus: true);
    }
  }

  Future<void> saveEnteredDataInDb(
      {String? comment,
      int? rating,
      required String photoSelectionCode,
      required bool status}) async {
    PhotoSelectionImagesModelDao photoSelectionModelDao =
        PhotoSelectionImagesModelDao();
    await photoSelectionModelDao.updateCommentAndRatting(
      comment: comment ?? "",
      rating: rating ?? 0,
      status: status,
      photoSelectionCode: photoSelectionCode,
    );
  }

  /*  Stream<appDb.JvtFile>getPhotoCoverFileByPhotoSelectionCode(String PhotoSelectionCode){

    }*/

  Future<void> undoPhotoSelectionByPhotoSelectionCode(
      {PhotoSelectionImagesModel? previousPhotoSelectionData,
      int? status}) async {
    FolderModelDao folderModelDao = FolderModelDao();
    appDb.Folder? folder = await folderModelDao.getFolderWhereCode(
        previousPhotoSelectionData!.photoSelectionImage!.folderCode);

    photoSelectionModelDao
        .updatePhotoSelectionImage(appDb.PhotoSelectionImagesCompanion(
      folderCode: drift.Value(
          previousPhotoSelectionData.photoSelectionImage!.folderCode),
      comment:
          drift.Value(previousPhotoSelectionData.photoSelectionImage!.comment),
      lastUpdated: drift.Value(
          previousPhotoSelectionData.photoSelectionImage!.lastUpdated),
      rating:
          drift.Value(previousPhotoSelectionData.photoSelectionImage!.rating),
      code: drift.Value(previousPhotoSelectionData.photoSelectionImage!.code),
      synced: drift.Value(false),
      status: drift.Value(status!),
    ));

    /* appDb.Event _event = await eventModelDao.getEventByCode(folder.eventCode);
    Future.delayed(Duration(seconds: 5), () async {
      try {
        if (_event.type != demoEvent) {
          getSyncWithServer();
        }
      } catch (e) {
        showLog('PhotoSelectionImage_selection_image_controller$e');
      }
    });*/
  }

  updatePhotoSelectionImagesByApiResponse(
      bool? lastUpdateFailedStatus,
      EventImageStatusModel photoSelectionImagesResponse,
      String eventCode) async {
    List<String> missingImageCodes = [];
    List<appDb.PhotoSelectionImagesCompanion> photoSelectionImagesCompanions =
        [];
    TransporterDao transporterDao = TransporterDao();
    //showLog('PhotoSelectionImageResponse ${photoSelectionImagesResponse.photoSelectionImages!}');
    if (photoSelectionImagesResponse.photoSelectionImages!.isNotEmpty) {
      if (lastUpdateFailedStatus != null && lastUpdateFailedStatus == true) {
        PhotoSelectionImagesModelDao photoSelectionImagesModelDao =
            PhotoSelectionImagesModelDao();
        await photoSelectionImagesModelDao.resetStatusByEventCode(
            eventCode: eventCode);
      }

      for (PhotoSelectionImage newPhotoSelectionImage
          in photoSelectionImagesResponse.photoSelectionImages!) {
        // showLog('PhotoSelectionImage ${newPhotoSelectionImage.status}');

// check lastUpdatedAt

        appDb.PhotoSelectionImage? _localPhotoSelectionImage =
            await photoSelectionModelDao
                .getPhotoSelectionImageWhereCode(newPhotoSelectionImage.code!);

        showLog('_localPhotoSelectionImages## $_localPhotoSelectionImage');
        if (_localPhotoSelectionImage == null) {
          /// means image missing need to update below code was temporarily commented
          /* await transporterDao.insertOrUpdateTransporter(
            tag: TransportDataKeys.photoSelectionData,
            code: photoSelectionImagesResponse.eventCode,
            updateRequiredValue: 1, // need update
          );*/
          showLog("_localPhotoSelectionImage == null $missingImageCodes");
          missingImageCodes.add(newPhotoSelectionImage.code!);
        }
      }
      try {
        if (missingImageCodes.isNotEmpty && missingImageCodes != []) {
          PhotomallApis photomallApis = PhotomallApis(null);
          await photomallApis.callChatNotifier(
            exception: 'PhotoSelection Image missing...',
            errorDetail:
                'Missing Images...in  EventCode ${photoSelectionImagesResponse.eventCode}..\n.... ImageCodes :$missingImageCodes ..... \n APPName : $appName \n App version: $studioVersionConfig',
          );
          missingImageCodes.clear();
        }
      } catch (e) {}
      for (PhotoSelectionImage newPhotoSelectionImage
          in photoSelectionImagesResponse.photoSelectionImages!) {
        appDb.PhotoSelectionImage? _localPhotoSelectionImage =
            await photoSelectionModelDao
                .getPhotoSelectionImageWhereCode(newPhotoSelectionImage.code!);

        //showLog("the new changed photoSelection where \n${newPhotoSelectionImage.code}\n${newPhotoSelectionImage.status}");||(lastUpdateFailedStatus!=null && lastUpdateFailedStatus ==true)
        if ((_localPhotoSelectionImage != null) &&
            ((_localPhotoSelectionImage.lastUpdated <
                newPhotoSelectionImage.lastUpdatedAt!))) {
          showLog('above condition satisfied meant!');
          //for above condition satisfied mean  already up to date so skip this operation at loop
          appDb.PhotoSelectionImagesCompanion photoSelectionImagesCompanion =
              appDb.PhotoSelectionImagesCompanion(
            folderCode: drift.Value(_localPhotoSelectionImage.folderCode),
            originalName: drift.Value(_localPhotoSelectionImage.originalName),
            code: drift.Value(newPhotoSelectionImage.code!),
            lastUpdated: drift.Value(newPhotoSelectionImage.lastUpdatedAt!),
            status: drift.Value(newPhotoSelectionImage.status!),
            synced: drift.Value(true),
            comment: drift.Value(newPhotoSelectionImage.comment ?? ""),
            rating: drift.Value(newPhotoSelectionImage.rating!),
          );
          photoSelectionImagesCompanions.add(photoSelectionImagesCompanion);
        } else {
          showLog("updatePhotoSelectionImage images are up to date ");
        }
      }
      if (photoSelectionImagesCompanions.isNotEmpty) {
        showLog('enter into updatePhotoSelectionBulkImages');
        await photoSelectionModelDao.updatePhotoSelectionBulkImages(
            photoSelectionImagesCompanions, eventCode);
      }
    }
  }
}
