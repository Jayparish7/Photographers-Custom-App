import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;
import 'package:photomall_flutter/core/notification/notificationMethods/local_notification_method.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/photo_selection_images_dao.dart';

class PhotoSelectionImagesUpsert {
  PhotoSelectionImagesModelDao photoSelectionImagesModelDao =
      PhotoSelectionImagesModelDao();

  Future<void> upsertPhotoSelectionImages(
      {required List<transporter.PhotoSelectionImageData> photoSelectionImages,
      required String folderCode,
      required String eventCode,
      bool? notification}) async {
    List<String> apiPhotoSelectionImages = [];
    for (transporter.PhotoSelectionImageData photoSelectionImage
        in photoSelectionImages) {
      apiPhotoSelectionImages.add(photoSelectionImage.code!);
    }
    List<String> existingPhotoSelectionImages = [];
    List<String> notify = [];
    //  if (apiPhotoSelectionImages.isNotEmpty) {
    List _createPhotoSelectionImages = []; // insert this event
    List _deletePhotoSelectionImages = []; // delete this event
    showLog('_deletePhotoSelectionImages $_deletePhotoSelectionImages');

    /// get local event
    List<appDb.PhotoSelectionImage>? photoSelectionsImages =
        await photoSelectionImagesModelDao
            .getPhotoSelectionImagesWhereFolderCode(folderCode);
    if (photoSelectionsImages != null && photoSelectionsImages.isNotEmpty) {
      photoSelectionsImages.forEach((_photoSelectionImages) {
        existingPhotoSelectionImages.add(_photoSelectionImages.code);
      });
    }
    for (int i = 0; i < apiPhotoSelectionImages.length; i++) {
      /*   if (existingPhotoSelectionImages.contains(apiPhotoSelectionImages[i])) {
          update.add(apiPhotoSelectionImages[i]);
        }*/
      if (!existingPhotoSelectionImages.contains(apiPhotoSelectionImages[i])) {
        _createPhotoSelectionImages.add(apiPhotoSelectionImages[i]);
        if (notification == true) {
          notify.add(apiPhotoSelectionImages[i]);
        }
      }
    }
    for (int i = 0; i < existingPhotoSelectionImages.length; i++) {
      if (!apiPhotoSelectionImages.contains(existingPhotoSelectionImages[i])) {
        _deletePhotoSelectionImages.add(existingPhotoSelectionImages[i]);
      }
    }

    /// INSERT New PhotoSelectionImages
    if (_createPhotoSelectionImages.isNotEmpty) {
      // List<appDb.TransportDataCompanion> newEventEntity = [];
      for (int i = 0; i < _createPhotoSelectionImages.length; i++) {
        showLog(
            "photo selection image upsert insert...${_createPhotoSelectionImages[i]}");
        List<transporter.PhotoSelectionImageData> _newPhotoSelectionImages =
            photoSelectionImages
                .where((obj) => obj.code == _createPhotoSelectionImages[i])
                .toList();
        showLog('creating photo selection data $folderCode');
        photoSelectionImagesModelDao.insertOrUpdateNewPhotoSelectionImages(
            photoSelectionImages: _newPhotoSelectionImages,
            folderCode: folderCode,
            eventCode: eventCode);
      }
    }

    /// DELETE PhotoSelectionImages NEED TO BE DELETED
    if (_deletePhotoSelectionImages.isNotEmpty) {
      for (int i = 0; i < _deletePhotoSelectionImages.length; i++) {
        showLog(
            '_deletePhotoSelectionImages list ${_deletePhotoSelectionImages[i]}');
      }
      PhotoSelectionImagesModelDao photoSelectionImagesModelDao =
          PhotoSelectionImagesModelDao();
      await photoSelectionImagesModelDao.deletePhotoSelectionImages(
          _deletePhotoSelectionImages, folderCode);
      /*FolderStatus folderStatus = FolderStatus();
        List<appDb.PhotoSelectionImage> photoSelectionImages = [];
        for (int i = 0; i < _deletePhotoSelectionImages.length; i++) {
          photoSelectionImages.addAll(photoSelectionsImages!
              .where((element) => element.code == _deletePhotoSelectionImages[i])
              .toList());
        }
        if (photoSelectionImages.isNotEmpty) {
          showLog('delete...events');
          await folderStatus.deleteFolderStatus(
            ownFolderStatus: 1,
            photoSelectionImages: photoSelectionImages,
            selected: 0,
            rejected: 0,
            waitingListed: 0,
            folderCode: folderCode,
          );

        }*/
      /*   PhotomallApis photomallApis = PhotomallApis(null);
        FolderStatusApiModel? folderStatusApiModel =
        await photomallApis.folderStatusApi(folderCode: folderCode);
        if (folderStatusApiModel?.folderStatus.waitListedImages == 0 &&
            folderStatusApiModel?.folderStatus.selectedImages == 0 &&
            folderStatusApiModel?.folderStatus.rejectedImages == 0) {
          showLog('delete...events 1 worked');


          await folderStatus.deleteFolderStatusBYFolderCode(folderCode);
          showLog('delete...events 2 worked');
        }
        return;*/
    }
    //  }
    if (notify.isNotEmpty) {
      LocalNotification localNotification = LocalNotification();
      localNotification.showNotificationForNewPhotoSelectionImages(
          eventCode, folderCode, notify.length);
    }
  }
}
