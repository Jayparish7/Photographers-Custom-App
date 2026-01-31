import 'package:photomall_flutter/controllers/faces_controller.dart';
import 'package:photomall_flutter/controllers/upsert_folder.dart';
import 'package:photomall_flutter/controllers/without_face_controller.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart';
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:photomall_flutter/driftdb/dao/folder_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_status_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_table_dao.dart';
import 'package:photomall_flutter/ui/folders/folder_photo_selection_model.dart'
    as photoSelectionModel;

import '../../controllers/real_face_controller.dart';
import '../../core/constants/common_constants.dart';

class PhotoSelectionTableUtils {
  insertFolders(PhotoSelectionData photoSelectionData) async {
    PhotoSelectionsDao photoSelectionsDao = PhotoSelectionsDao();
    if (photoSelectionData.photoselection != null) {
      await photoSelectionsDao.insertPhotoSelections(
        code: photoSelectionData.photoselection!.code!,
        published:
            photoSelectionData.photoselection!.published == 1 ? true : false,
        eventCode: photoSelectionData.code!,
        confirmationStatus: null, // initial confirm status sus aka
      ); // removed no use of this last update
    }

    if (photoSelectionData.persons!.isNotEmpty) {
      PersonsController personsController = PersonsController();
      await personsController.upsertPhotoSelectionPersons(
          persons: photoSelectionData.persons!,
          eventCode: photoSelectionData.code!);
    }
    showLog(
        'realPersons photoSelectionData${photoSelectionData.realPersons!}');

    if (photoSelectionData.realPersons!.isNotEmpty) {
      showLog('realPersons photoSelectionData');
      RealPersonsController personsController = RealPersonsController();
      await personsController.upsertPhotoSelectionPersons(
          eventCode: photoSelectionData.code!,
          realPersons: photoSelectionData.realPersons!);
      showLog('photoSelectionData1');
    }

    if (photoSelectionData.imageWithoutPerson != null &&
        photoSelectionData.imageWithoutPerson!.isNotEmpty) {
      WithoutFaceController withoutFaceController = WithoutFaceController();
      await withoutFaceController.upsertWithoutFacePhotoSelection(
          eventCode: photoSelectionData.code!,
          images: photoSelectionData.imageWithoutPerson!);
    }

    if (photoSelectionData.folders!.isNotEmpty) {
      FolderUpsert folderUpsert = FolderUpsert();
      await folderUpsert.upsertFolder(
          eventCode: photoSelectionData.code!,
          folderData: photoSelectionData.folders!);
    }
    }

  void photoSelectionImageUpdatedFunction(
      PhotoSelectionImage existingPhotoSelectionImage,
      photoSelectionModel.PhotoSelectionImage newData) {
    if (existingPhotoSelectionImage.status == newData.status) {
      return;
    } else {
      // get folder status data by newData
      toggleFolderStatus(
          folderCode: existingPhotoSelectionImage.folderCode,
          oldStatus: existingPhotoSelectionImage.status,
          ownFolderStatus: 1,
          newStatus: newData.status!);

      // decrement existing data
      //0->Default1, ->Selected Images,2->Rejected Images, 3->Wait List Images
    }

    // do update the folder status table
    //folderStatusModelDao.insertPhotoSelection()
  }

  Future<void> toggleFolderStatus(
      {required String folderCode,
      required int oldStatus,
      required int ownFolderStatus,
      required int newStatus}) async {
    FolderModelDao folderModelDao = FolderModelDao();
    FolderStatus folderStatusModelDao = FolderStatus();
    if (ownFolderStatus == 1) {
      await folderStatusModelDao.updateFolderStatusFolderCount(
          combined: true,
          folderCode: folderCode,
          newStatus: newStatus,
          oldStatus: oldStatus);
    }
    await folderStatusModelDao.updateFolderStatusFolderCount(
        combined: false,
        folderCode: folderCode,
        newStatus: newStatus,
        oldStatus: oldStatus);
    // get parent folder
    Folder? folder = await folderModelDao.getFolderWhereCode(folderCode);
    if (folder?.parentCode != null) {
      toggleFolderStatus(
          oldStatus: oldStatus,
          newStatus: newStatus,
          folderCode: folder!.parentCode!,
          ownFolderStatus: 0);
    }
  }
}
