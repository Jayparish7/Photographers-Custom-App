import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/controllers/photo_selection_image_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:photomall_flutter/driftdb/dao/folder_dao.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';
import 'package:photomall_flutter/ui/folders/folder_photo_selection_model.dart';

class PhotoSelectionsDao {
  AppDb database = AppDb();

  Future<List<PhotoSelection?>?> getAllPhotoSelectionByUserType(
      int type) async {
    showLog("getting empty photo selection call type : $type");
    var query = (database.select(database.events)
          ..where((tbl) {
            return (tbl.type.equals(type));
          }))
        .join([
      drift.innerJoin(database.photoSelections,
          database.photoSelections.eventCode.equalsExp(database.events.code)),
    ]);
    return query.map((row) {
      return row.readTableOrNull(database.photoSelections);
    }).get();
  }

  Future<List<PhotoSelection>> getPhotoSelections() async {
    return await database.select(database.photoSelections).get();
  }

  Future<int?> updateLastUpdate(List<PhotoSelection> data) async {
    for (PhotoSelection datum in data) {
      await (database.update(database.photoSelections)
            ..where((tbl) => tbl.code.equals(datum.code!)))
          .write(PhotoSelectionsCompanion(lastUpdatedAt: drift.Value(0)));
    }
    return null;
  }

/*  Future<void> updatePhotoSelectionTotalImagesWhereEventCode(
      int totalImages,String eventCodes) async {
    showLog('The total images ${totalImages} $eventCodes}');
    try{
      await (database.update(database.photoSelections)
        ..where((tbl) => tbl.eventCode.equals(eventCodes)))
          .write(PhotoSelectionsCompanion(totalImages: drift.Value(totalImages)));
    }catch(e){
      showLog('The total images Failed ${totalImages} $eventCodes}');

    }

  }*/

  Future<int?> insertPhotoSelections({
    required String code,
    required String eventCode,
    required bool published,
    bool? confirmationStatus,
  }) async {
    try {
      showLog('folder view model resource get step 5');

      // get photo selection by code if exist update or insert
      PhotoSelection? photoSelection = await getPhotoSelectionByCode(code);
      if (photoSelection != null) {
        (database.update(database.photoSelections)
              ..where((t) => t.code.equals(photoSelection.code!)))
            .write(PhotoSelectionsCompanion(
          code: drift.Value(code),
          eventCode: drift.Value(eventCode),
          published: drift.Value(published),
          confirmationStatus: drift.Value(confirmationStatus ?? false),
        ));
      } else {
        PhotoSelectionsCompanion photoSelectionsCompanion =
            PhotoSelectionsCompanion(
          code: drift.Value(code),
          eventCode: drift.Value(eventCode),
          published: drift.Value(published),
          confirmationStatus: drift.Value(confirmationStatus ?? false),
          lastUpdatedAt: drift.Value(0),
        );
        return await database
            .into(database.photoSelections)
            .insert(photoSelectionsCompanion);
      }
    } catch (e) {
      showLog("this problem where caused in photo_selection_data \n$e");
      return null;
    }
    return null;
  }

  Future<PhotoSelection?> getPhotoSelectionByCode(String code) async {
    showLog("updatePhotoSelection :: updatePhotoSelection step 4 . 1$code");
    return await (database.select(database.photoSelections)
          ..where((tbl) => tbl.code.equals(code))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<PhotoSelection?> getPhotoSelectionByEventCode(String code) async {
    showLog("updatePhotoSelection :: updatePhotoSelection step 4 . 1");
    return await (database.select(database.photoSelections)
          ..where((tbl) => tbl.eventCode.equals(code))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> resetLastUpdate(String code) async {
    // showLog(' message is eventCode$code');

    //showLog('resetLastUpdate  worked 001 ');
    PhotoSelectionImageController photoSelectionImageController =
        PhotoSelectionImageController();
    await photoSelectionImageController.updatePhotoSelection(
        eventCode: code, lastUpdateFailedStatus: true);
    // showLog('resetLastUpdate  worked 002 ');
  }

  Future<void> updateSubmittedStatusByEventCode(String code, int status) async {
    try {
      showLog('updateSubmittedStatusByEventCode sub $code    $status');
      await (database.update(database.photoSelections)
            ..where((tbl) {
              return tbl.eventCode.equals(code);
            }))
          .write(PhotoSelectionsCompanion(
              confirmationStatus: drift.Value(status == 1 ? true : false)));
    } catch (e) {
      showLog('the data error ${e}');
    }
  }

  Future<int?> insertOrUpdatePhotoStatus(String code,
      EventImageStatusModel eventImageStatusModel, String eventCode) async {
    try {
      PhotoSelectionsCompanion entity = PhotoSelectionsCompanion(
        code: drift.Value(code),
        eventCode: drift.Value(eventCode),
        lastUpdatedAt: drift.Value(eventImageStatusModel.lastUpdatedAt),
        confirmationStatus: drift.Value(
            eventImageStatusModel.confirmedStatus == 1 ? true : false),
      );
      return await database
          .into(database.photoSelections)
          .insertOnConflictUpdate(entity);
    } catch (e) {
      showLog('the error in this photo selection image insert process \n ${e}');
    }
    return null;
  }

  Future<void> deletePhotoSelectionsEventCode(String code) async {
    await (database.delete(database.photoSelections)
          ..where((tbl) => tbl.eventCode.equals(code)))
        .go();
  }

  Stream<PhotoSelection?>? streamPhotoSelectionByEventCode(String? eventCode) {
    if (eventCode == null) {
      return null;
    }
    return (database.select(database.photoSelections)
          ..where(
            (tbl) => tbl.eventCode.equals(eventCode),
          )
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<void> toggleSubmittedStatusByCodes(
      {required String eventCode, required String code, var status}) async {
    await (database.update(database.photoSelections)
          ..where((tbl) {
            return (tbl.eventCode.equals(eventCode)) & (tbl.code.equals(code));
          }))
        .write(PhotoSelectionsCompanion(
            confirmationStatus:
                drift.Value(int.parse(status.toString()) == 1 ? true : false)));
  }

  Future<void> deletePhotoSelectionsFlow(String code) async {
    FolderModelDao folderModelDao = FolderModelDao();
    TransporterDao transporterDao = TransporterDao();

    await transporterDao.deleteTransporterByCodeAndTag(
        code: code, tag: TransportDataKeys.photoSelectionData);
    await folderModelDao.deleteFolderByEventCode(eventCode: code);
    await deletePhotoSelectionsEventCode(code);
    // photo selection images status
  }

  Future<List<PhotoSelection?>?> getPhotoSelectionByTag(
      {required String tag}) async {
    // tag -> 1 : user , 2:gallery
    try {
      var query = await (database.select(database.photoSelections)
            ..where((tbl) => tbl.eventCode.equalsExp(database.events.code))
            ..limit(1))
          .join([
        drift.innerJoin(
            database.events,
            database.events.type.equals(tag == TransportDataKeys.userData
                ? userEvent
                : studioGalleyEvent))
      ]).get();
      return query.map((rows) {
        return rows.readTableOrNull(database.photoSelections);
      }).toList();
    } catch (e) {
      showLog('the problem while get photoSelection status dao $e');
      return null;
    }
  }

  Future<List<PhotoSelection?>?> getUserPhotoSelection(
      {required int eventType}) async {
    // tag -> 1 : user , 2:gallery
    try {
      var query = await (database.select(database.photoSelections)
            ..where((tbl) => tbl.eventCode.equalsExp(database.events.code)))
          .join([
        drift.innerJoin(database.events, database.events.type.equals(eventType))
      ]).get();
      return query.map((rows) {
        return rows.readTableOrNull(database.photoSelections);
      }).toList();
    } catch (e) {
      showLog('the problem while get photoSelection status dao $e');
      return null;
    }
  }

  Future<JvtFile?> getSinglePhotoSelectionCoverImage(String eventCode) async {
    try {
      var query = (database.select(database.photoSelections)
            ..where((tbl) {
              return (tbl.eventCode.equals(eventCode));
            }))
          .join([
        // join file connector for album
        drift.innerJoin(
            database.folders,
            (database.folders.eventCode
                .equalsExp(database.photoSelections.eventCode))),
        drift.innerJoin(
            database.photoSelectionImages,
            (database.photoSelectionImages.folderCode
                .equalsExp(database.folders.code))),
        drift.innerJoin(
            database.jvtFileConnectors,
            ((database.jvtFileConnectors.ableCode
                    .equalsExp(database.photoSelectionImages.code)) &
                (database.jvtFileConnectors.tag
                    .equals(TransportDataKeys.photoSelectionImages)))),
        // join file  for album
        drift.innerJoin(
            database.jvtFiles,
            (database.jvtFiles.code
                .equalsExp(database.jvtFileConnectors.jvtFileCode))),
      ]);
      query.limit(1);
      return query.map((row) {
        return row.readTableOrNull(database.jvtFiles);
      }).getSingleOrNull();
    } catch (e) {
      showLog('the problem while event dao :: $e');
      return null;
    }
  }
}
