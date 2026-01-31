import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/folder_status_model.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:photomall_flutter/driftdb/dao/folder_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_images_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_table_dao.dart';
import '../../api/repository/photomall_apis.dart';

class FolderStatus {
  AppDb database = AppDb();

  Future<FolderStatuse?> getFolderStatusByFolderCode(String code) async {
    return await (database.select(database.folderStatuses)
          ..where((tbl) {
            return (tbl.folderCode.equals(code));
          })
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<FolderStatuse?>?> getByEventCode(String eventCode) async {
    try {
      var query = (((database.select(database.folders)
            ..where((tbl) {
              return (tbl.eventCode.equals(eventCode));
            }))
          .join([
        drift.innerJoin(
            database.folderStatuses,
            (database.folderStatuses.folderCode
                .equalsExp(database.folders.code)))
      ])));
      return query.map((row) {
        return row.readTableOrNull(database.folderStatuses);
      }).get();
    } catch (e) {
      showLog('the error in this photoSelectionDao ${e}');
      return null;
    }
  }

  Future<void> toggleForMultipleImages({
    required String folderCode,
    required int selectedCount,
    required int rejectedCount,
    required int waitingCount,
    required String action,
    required int ownFolderStatus,
  }) async {
    showLog(
        'deleted method --2 S-$selectedCount ,R-$rejectedCount, W-$waitingCount');
    //FolderStatus folderStatusModelDao = FolderStatus();
    if (ownFolderStatus == 1) {
      showLog('deleted method --1');
      await updateForMultipleImages(
        combined: false,
        folderCode: folderCode,
        action: action,
        rejectedCount: rejectedCount,
        selectedCount: selectedCount,
        waitingCount: waitingCount,
      );
    }
    await updateForMultipleImages(
        combined: true,
        folderCode: folderCode,
        action: action,
        rejectedCount: rejectedCount,
        selectedCount: selectedCount,
        waitingCount: waitingCount);

    // get parent folder
    FolderModelDao folderModelDao = FolderModelDao();
    Folder? folder = await folderModelDao.getFolderWhereCode(folderCode);

    if (folder!.parentCode != null) {
      showLog(
          'deleted method --2 S-$selectedCount ,R-$rejectedCount, W-$waitingCount');
      await toggleForMultipleImages(
          action: action,
          selectedCount: selectedCount,
          rejectedCount: rejectedCount,
          waitingCount: waitingCount,
          folderCode: folder.parentCode!,
          ownFolderStatus: 0);
    }
    showLog('deleted method --3');
  }

  Future<void> toggleFolderStatus(
      {required String folderCode,
      required int oldStatus,
      required int ownFolderStatus,
      required int newStatus}) async {
    if (ownFolderStatus == 1) {
      await updateFolderStatusFolderCount(
          combined: false,
          folderCode: folderCode,
          newStatus: newStatus,
          oldStatus: oldStatus);
    }

    await updateFolderStatusFolderCount(
        combined: true,
        folderCode: folderCode,
        newStatus: newStatus,
        oldStatus: oldStatus);

    // get parent folder
    FolderModelDao folderModelDao = FolderModelDao();
    Folder? folder = await folderModelDao.getFolderWhereCode(folderCode);

    if (folder != null && folder.parentCode != null) {
      await toggleFolderStatus(
          oldStatus: oldStatus,
          newStatus: newStatus,
          folderCode: folder.parentCode!,
          ownFolderStatus: 0);
    }
  }

  Future<void> updateForMultipleImages({
    required String folderCode,
    required int selectedCount,
    required int rejectedCount,
    required int waitingCount,
    required String action,
    required bool combined,
  }) async {
    int resultSelectedCount = 0;
    int resultRejectedCount = 0;
    int resultWaitingCount = 0;
    showLog(
        'New Status Value S -$selectedCount,W-$waitingCount,R-$rejectedCount');
    try {
      var folderStatus = await (database.select(database.folderStatuses)
            ..where((tbl) {
              return (tbl.folderCode.equals(folderCode)) &
                  (tbl.combined.equals(combined));
            })
            ..limit(1))
          .getSingleOrNull();
      showLog('folderCode-- $folderCode,Combined-- $combined');
      showLog(
          'old status Value S -${folderStatus!.selected},W-${folderStatus.waitingListed},R-${folderStatus.rejected}');
      switch (action) {
        case ('_create'):
          resultSelectedCount = folderStatus.selected + selectedCount;
          resultRejectedCount = folderStatus.rejected + rejectedCount;
          resultWaitingCount = folderStatus.waitingListed + waitingCount;

          break;
        case ('_delete'):
          showLog('switch delete case worked$action');
          resultSelectedCount = folderStatus.selected - selectedCount;
          resultRejectedCount = folderStatus.rejected - rejectedCount;
          resultWaitingCount = folderStatus.waitingListed - waitingCount;

          break;
      }
      showLog(
          'result Counts S-$resultSelectedCount, W-$resultWaitingCount, R -$resultRejectedCount');
      await updateFolderStatusTable(folderStatus.id, resultSelectedCount,
          resultRejectedCount, resultWaitingCount);
    } catch (e) {
      showLog("the problem while updateForMultipleImages $e");
    }
  }

  Future<void> updateFolderStatusFolderCount(
      {required String? folderCode,
      required bool? combined,
      required int? oldStatus,
      required int? newStatus}) async {
    //  showLog('updateFolderStatusFolderCount initiated');
    try {
      var folderStatus = await (database.select(database.folderStatuses)
            ..where((tbl) {
              return (tbl.folderCode.equals(folderCode!)) &
                  (tbl.combined.equals(combined!));
            })
            ..limit(1))
          .getSingleOrNull();
      int selected;
      int rejected;
      int waitingListed;
      if (folderStatus == null) {
        showLog("the folder status is null");
        selected = 0;
        rejected = 0;
        waitingListed = 0;
      } else {
        selected = folderStatus.selected;
        rejected = folderStatus.rejected;
        waitingListed = folderStatus.waitingListed;
      }

      switch (oldStatus) {
        case 1:
          {
            // folderStatus selected decrement
            selected--;
          }
          break;
        case 2:
          {
            rejected--;
          }
          break;
        case 3:
          {
            waitingListed--;
          }
          break;
        default:
          {
            showLog("entered into default 1 1");
          }
          break;
      }
      switch (newStatus) {
        case 1:
          {
            // folderStatus selected increment
            selected++;
          }
          break;
        case 2:
          {
            rejected++;
          }
          break;
        case 3:
          {
            waitingListed++;
          }
          break;
        default:
          {
            showLog("entered into default 2");
          }
          break;
      }

      await (database.update(database.folderStatuses)
            ..where((tbl) {
              return tbl.id.equals(folderStatus!.id);
            }))
          .write(FolderStatusesCompanion(
              selected: drift.Value(selected),
              rejected: drift.Value(rejected),
              waitingListed: drift.Value(waitingListed)));
    } catch (e) {
      showLog("the problem while folderStatusDao11 $e");
    }
  }

  Future<void> resetById(int id) async {
    await (database.update(database.folderStatuses)
          ..where((tbl) {
            return tbl.id.equals(id);
          }))
        .write(FolderStatusesCompanion(
            selected: drift.Value(0),
            rejected: drift.Value(0),
            waitingListed: drift.Value(0)));
  }

  Future<int?> insertNewFolderStatus(FolderStatusesCompanion entity) async {
    try {
      showLog('the folder status inserted :: >> ${entity.folderCode}');
      return await database
          .into(database.folderStatuses)
          .insertOnConflictUpdate(entity);
    } catch (e) {
      showLog('problem while inserting folder status ${e}');
    }
    return null;
  }

  Future<int?> updateFolderStatus(FolderStatusesCompanion entity) async {
    try {
      showLog('the folder status inserted ${entity.folderCode}');
      return await (database.update(database.folderStatuses)
            ..where((tbl) {
              return (tbl.combined.equals(entity.combined.value)) &
                  (tbl.folderCode.equals(entity.folderCode.value));
            }))
          .write(entity);
    } catch (e) {
      showLog('problem while inserting folder status ${e}');
    }
    return null;
  }

  Future<void> deleteFolderStatusBYFolderCode(String code) async {
    await (database.delete(database.folderStatuses)
          ..where((tbl) {
            return tbl.folderCode.equals(code);
          }))
        .go();
  }

  Stream<FolderStatuse?> streamFolderStatus(String folderCode) {
    showLog('The folder code of this data where ${folderCode}');
    return (database.select(database.folderStatuses)
          ..where((tbl) {
            return (tbl.folderCode.equals(folderCode) &
                tbl.combined.equals(true));
          })
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<void> deleteFolderStatusById(int id) async {
    showLog("the id don't want to be deleted where [7]  now deleting $id");
    await (database.delete(database.folderStatuses)
          ..where((tbl) {
            return tbl.id.equals(id);
          }))
        .go();
  }

  Future<void> deleteFolderStatus(
      // 1 - > selected , 2-> rejected , 3-> waitingListed
      {required String folderCode,
      required int selected,
      required int rejected,
      required int waitingListed,
      List<PhotoSelectionImage>? photoSelectionImages,
      required int ownFolderStatus}) async {
    PhotoSelectionImagesModelDao photoSelectionImagesModelDao =
        PhotoSelectionImagesModelDao();
    if (ownFolderStatus == 1) {
      if (photoSelectionImages == null || photoSelectionImages.isEmpty) {
        photoSelectionImages = await photoSelectionImagesModelDao
            .getPhotoSelectionImagesWhereFolderCode(folderCode);
      }
      if (photoSelectionImages != null || photoSelectionImages!.isNotEmpty) {
        for (PhotoSelectionImage photoSelectionImage in photoSelectionImages) {
          switch (photoSelectionImage.status) {
            case 1:
              {
                // folderStatus selected increment
                selected++;
              }
              break;
            case 2:
              {
                rejected++;
              }
              break;
            case 3:
              {
                waitingListed++;
              }
              break;
            default:
              {
                showLog("entered into default 2");
              }
              break;
          }
          await photoSelectionImagesModelDao
              .deletePhotoSelectionImagesByCode(photoSelectionImage.code);
        }

        List<FolderStatuse> folderStatuses =
            await getFolderStatusWhereFolderCode(folderCode);
        for (FolderStatuse folderStatus in folderStatuses) {
          int _newSelected = folderStatus.selected - selected;
          int _newRejected = folderStatus.rejected - rejected;
          int _newWaitListed = folderStatus.waitingListed - waitingListed;
          if (_newWaitListed == 0 && _newRejected == 0 && _newSelected == 0) {
            await deleteFolderStatusById(folderStatus.id);
          } else {
            await updateFolderStatusTable(
                folderStatus.id, _newSelected, _newRejected, _newWaitListed);
          }
        }
      }
    } else {
      List<FolderStatuse> folderStatuses =
          await getCombinedFolderStatusWhereFolderCode(folderCode);
      for (FolderStatuse folderStatus in folderStatuses) {
        int _newSelected = folderStatus.selected - selected;
        int _newRejected = folderStatus.rejected - rejected;
        int _newWaitListed = folderStatus.waitingListed - waitingListed;
        FolderModelDao folderModelDao = FolderModelDao();
        Folder? _folder = await folderModelDao.getFolderWhereCode(folderCode);
        if (_newWaitListed == 0 &&
            _newRejected == 0 &&
            _newSelected == 0 &&
            _folder?.parentCode != null) {
          await deleteFolderStatusById(folderStatus.id);
        } else {
          await updateFolderStatusTable(
              folderStatus.id, _newSelected, _newRejected, _newWaitListed);
        }
      }
    }
    FolderModelDao folderModelDao = FolderModelDao();
    Folder? folder = await folderModelDao.getFolderWhereCode(folderCode);
    if (folder != null && folder.parentCode != null) {
      deleteFolderStatus(
          folderCode: folder.parentCode!,
          selected: selected,
          rejected: rejected,
          waitingListed: waitingListed,
          ownFolderStatus: 0);
    }
  }

  Future<void> validateParentFolderStatus(String code) async {
    bool _validationStatus = true;
    FolderModelDao folderModelDao = FolderModelDao();
    Folder? folder = await folderModelDao.getFolderByEventAndParentNull(code);
    PhotomallApis photomallApis = PhotomallApis(null);
    //await photomallApis.folderStatusApi(folderCode: folder?.code);
    FolderStatuse? _localFolderStatus =
        await getSingleByCombinedByFolderCode(folder!.code);
    // showLog('_localFolderStatus $_localFolderStatus');

    FolderStatusApiModel? folderStatusApiModel =
        await photomallApis.folderStatusApi(folderCode: folder.code);
    //showLog('validate status $_validationStatus');
    if (folderStatusApiModel?.folderStatus.waitListedImages !=
        _localFolderStatus?.waitingListed) {
      _validationStatus = false;
      // showLog('wait list $_validationStatus');
      //  showLog(
      //  'wait listCount ${folderStatusApiModel?.folderStatus.waitListedImages}');
      // showLog('wait listCount1 ${_localFolderStatus?.waitingListed}');
    }
    if (folderStatusApiModel?.folderStatus.selectedImages !=
            _localFolderStatus?.selected &&
        _validationStatus == true) {
      _validationStatus = false;
      // showLog('selected list $_validationStatus');
    }
    if (folderStatusApiModel?.folderStatus.rejectedImages !=
            _localFolderStatus?.rejected &&
        _validationStatus == true) {
      _validationStatus = false;
      // showLog('rejected list $_validationStatus');
    }
    /* if (_validationStatus == true) {
      int _eventSelectedImages = 0,
          _eventWaitListedImages = 0,
          _eventRejectedImages = 0;
     // bool _validationStatus = true;
      PhotoSelectionImagesModelDao photoSelectionModelDao =
          PhotoSelectionImagesModelDao();
      // get local photo selection images synced false rows
      List<appDb.PhotoSelectionImage?>? photoSelectionImages =
          await photoSelectionModelDao.getByEventCode(code);

     // showLog('value $code');
      if (photoSelectionImages != null || photoSelectionImages!.isNotEmpty) {
        for (appDb.PhotoSelectionImage? photoSelectionImage
            in photoSelectionImages) {
          //showLog('photoSelectionImage Status::${photoSelectionImage!.status}');
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

      if (_localFolderStatus?.waitingListed != _eventWaitListedImages) {
        _validationStatus = false;
      }
      if (_localFolderStatus?.selected != _eventSelectedImages &&
          _validationStatus == true) {
        _validationStatus = false;
      }
      if (_localFolderStatus?.rejected != _eventRejectedImages &&
          _validationStatus == true) {
        _validationStatus = false;
      }
     // showLog('validationStatus123:$_validationStatus');
    }*/
    if (_validationStatus == false) {
      FolderStatus folderState = FolderStatus();
      List<appDb.FolderStatuse?>? folderStatuses =
          await folderState.getByEventCode(code);
      if (folderStatuses != null || folderStatuses!.isNotEmpty) {
        for (appDb.FolderStatuse? folderStatus in folderStatuses) {
          await folderState.resetById(folderStatus!.id);
        }
      }
      PhotoSelectionsDao photoSelectionsDao = PhotoSelectionsDao();
      await photoSelectionsDao.resetLastUpdate(code);
    }
  }

  Future<List<FolderStatuse>> getFolderStatusWhereFolderCode(
      String code) async {
    return await (database.select(database.folderStatuses)
          ..where((tbl) {
            return (tbl.folderCode.equals(code));
          }))
        .get();
  }

  Future<List<FolderStatuse>> getCombinedFolderStatusWhereFolderCode(
      String code) async {
    return await (database.select(database.folderStatuses)
          ..where((tbl) {
            return (tbl.folderCode.equals(code)) & (tbl.combined.equals(true));
          }))
        .get();
  }

  Future<FolderStatuse?> getSingleByCombinedByFolderCode(String code) async {
    /*await (database.select(database.folderStatuses)
      ..where((tbl) {
        return (tbl.folderCode.equals(code)) & (tbl.combined.equals(true));
      }))
        .getSingle();*/

    return await (database.select(database.folderStatuses)
          ..where((tbl) =>
              tbl.folderCode.equals(code) & (tbl.combined.equals(true)))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> updateFolderStatusTable(
      int id, int selected, int rejected, int waitingListed) async {
    await (database.update(database.folderStatuses)
          ..where((tbl) {
            return tbl.id.equals(id);
          }))
        .write(FolderStatusesCompanion(
            selected: drift.Value(selected),
            rejected: drift.Value(rejected),
            waitingListed: drift.Value(waitingListed)));
  }
}
