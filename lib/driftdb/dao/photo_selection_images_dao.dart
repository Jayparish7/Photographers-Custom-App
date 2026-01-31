import 'package:collection/collection.dart';
import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:photomall_flutter/driftdb/dao/folder_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_status_dao.dart';
import 'package:photomall_flutter/driftdb/dao/jvt_file_connector_dao.dart';
import 'package:photomall_flutter/driftdb/dao/jvt_file_dao.dart';
import 'package:photomall_flutter/traits/download_method.dart';
import 'package:photomall_flutter/traits/utils/screen_utils.dart';
import 'package:photomall_flutter/ui/album/photoselection/select/photo_selection_route_view_model.dart';
import 'package:photomall_flutter/ui/folders/folder_photo_selection_model.dart'
    as photoSelectionModel;

import '../../core/constants/shared_preference_constants.dart';

class PhotoSelectionImagesModelDao {
  AppDb database = AppDb();
  List<BatchFolderStatus> batchFolderStatus = [];

  Future<void> updateCommentAndRatting(
      {required String photoSelectionCode,
      String? comment,
      int? rating,
      required bool status}) async {
    await (database.update(database.photoSelectionImages)
          ..where((tbl) {
            return tbl.code.equals(photoSelectionCode);
          }))
        .write(PhotoSelectionImagesCompanion(
      synced: drift.Value(status),
      rating: drift.Value(rating ?? 0),
      comment: drift.Value(comment ?? ''),
    ));
  }

  Future<void> resetStatusByEventCode({required String eventCode}) async {
    FolderModelDao folderModelDao = FolderModelDao();
    List<appDb.Folder> folders =
        await folderModelDao.getFoldersByEvent(eventCode);
    for (Folder folder in folders) {
      await (database.update(database.photoSelectionImages)
            ..where((tbl) {
              return tbl.folderCode.equals(folder.code);
            }))
          .write(PhotoSelectionImagesCompanion(
              status: drift.Value(0), lastUpdated: drift.Value(0)));
    }
  }

  Future<PhotoSelectionImage?> getPhotoSelectionImageWhereCode(
      String code) async {
    try {
      return await (database.select(database.photoSelectionImages)
            ..where((tbl) {
              return (tbl.code.equals(code));
            })
            ..limit(1))
          .getSingleOrNull();
    } catch (e) {
      showLog('the error in this photoSelectionDao ${e}');
      return null;
    }
  }

  Future<PhotoSelectionImagesModel?> getPhotoSelectionImageFileWhereCode(
      String code, int status) async {
    try {
      var query = (database.select(database.photoSelectionImages)
            ..where((tbl) {
              return ((tbl.code.equals(code)) & ((tbl.status.equals(status))));
            }))
          .join([
        drift.innerJoin(
            database.jvtFileConnectors,
            (database.jvtFileConnectors.ableCode
                    .equalsExp(database.photoSelectionImages.code)) &
                (database.jvtFileConnectors.ableType
                    .equals(TransportDataKeys.photoSelectionImages))),
        drift.innerJoin(
            database.jvtFiles,
            (database.jvtFiles.code
                .equalsExp(database.jvtFileConnectors.jvtFileCode))),
      ])
        ..limit(1);

      return query.map((row) {
        return PhotoSelectionImagesModel(
          fileConnector: row.readTableOrNull(database.jvtFileConnectors),
          file: row.readTableOrNull(database.jvtFiles),
          photoSelectionImage:
              row.readTableOrNull(database.photoSelectionImages),
        );
      }).getSingleOrNull();
    } catch (e) {
      showLog('the error in this photoSelectionDao ${e}');
      return null;
    }
  }

  Future<PhotoSelectionImage?> getInvalidPhotoSelectionImageWhereEventCode(
      String eventCode) async {
    try {
      var query = (((database.select(database.folders)
            ..where((tbl) {
              return (tbl.eventCode.equals(eventCode));
            }))
          .join([
        drift.innerJoin(
            database.photoSelectionImages,
            (database.photoSelectionImages.folderCode
                    .equalsExp(database.folders.code)) &
                (database.photoSelectionImages.status.equals(0)))
      ])));
      query.limit(1);
      return query.map((row) {
        return row.readTableOrNull(database.photoSelectionImages);
      }).getSingleOrNull();
    } catch (e) {
      showLog('the error in this photoSelectionDao ${e}');
      return null;
    }
  }

  Future<List<PhotoSelectionImage?>?> getPhotoSelectionImagesWhereEventCode(
      String eventCode) async {
    try {
      var query = (((database.select(database.folders)
            ..where((tbl) {
              return (tbl.eventCode.equals(eventCode));
            }))
          .join([
        drift.innerJoin(
            database.photoSelectionImages,
            (database.photoSelectionImages.folderCode
                    .equalsExp(database.folders.code)) &
                (database.photoSelectionImages.status.equals(0)))
      ])));
      return query.map((row) {
        return row.readTableOrNull(database.photoSelectionImages);
      }).get();
    } catch (e) {
      showLog('the error in this photoSelectionDao ${e}');
      return null;
    }
  }

  Future<List<PhotoSelectionImage?>?> getByEventCode(String eventCode) async {
    try {
      var query = (((database.select(database.folders)
            ..where((tbl) {
              return (tbl.eventCode.equals(eventCode));
            }))
          .join([
        drift.innerJoin(
            database.photoSelectionImages,
            (database.photoSelectionImages.folderCode
                .equalsExp(database.folders.code)))
      ])));
      return query.map((row) {
        return row.readTableOrNull(database.photoSelectionImages);
      }).get();
    } catch (e) {
      showLog('the error in this photoSelectionDao ${e}');
      return null;
    }
  }

  Future<List<PhotoSelectionImage>> getPhotoSelectionWhereSynced(
      bool status) async {
    return await (database.select(database.photoSelectionImages)
          ..where((tbl) {
            return ((tbl.synced.equals(status)) & (tbl.status.equals(0).not()));
          }))
        .get();
  }

  Future<List<PhotoSelectionImage>> getMultiplePhotoSelectionWhereCode(
      String code) async {
    return await (database.select(database.photoSelectionImages)
          ..where((tbl) {
            return (tbl.code.equals(code));
          }))
        .get();
  }

  Future<int?> insertPhotoSelectionImages(
      PhotoSelectionImagesCompanion entity) async {
    try {
      return await database.into(database.photoSelectionImages).insert(entity);
    } catch (e) {
      showLog(
          "the problem in photo selection images :: insertPhotoSelection $e  ");
      return null;
    }
  }

  Future<void> toggleSyncedStatusAndLastUpdate(
      String code, int lastUpdate, bool synced) async {
    await (database.update(database.photoSelectionImages)
          ..where((tbl) {
            return tbl.code.equals(code);
          }))
        .write(PhotoSelectionImagesCompanion(
            synced: drift.Value(synced), lastUpdated: drift.Value(lastUpdate)));
  }

  Future<void> updatePhotoSelectionImage(
      PhotoSelectionImagesCompanion photoSelectionImage) async {
    showLog(
        'AvailablePhotoSelectionImage 1 Last up date ${photoSelectionImage.lastUpdated}');
    // get old data
    PhotoSelectionImage? existingPhotoSelectionImage =
        await getPhotoSelectionImageWhereCode(photoSelectionImage.code.value);

    // insert new data
    await (database.update(database.photoSelectionImages)
          ..where((tbl) {
            return tbl.code.equals(photoSelectionImage.code.value);
          }))
        .write(PhotoSelectionImagesCompanion(
      code: drift.Value(existingPhotoSelectionImage!.code),
      folderCode: drift.Value(existingPhotoSelectionImage.folderCode),
      status: photoSelectionImage.status,
      rating: photoSelectionImage.rating,
      comment: photoSelectionImage.comment,
      originalName: drift.Value(existingPhotoSelectionImage.originalName),
      lastUpdated: drift.Value(existingPhotoSelectionImage.lastUpdated),
      synced: photoSelectionImage.synced,
    ));
    // get inserted new data
    PhotoSelectionImage? newPhotoSelectionImage =
        await getPhotoSelectionImageWhereCode(photoSelectionImage.code.value);

    // showLog("the table data where ${newPhotoSelectionImage.code}");

    await updateFolderStatus(
        existingPhotoSelectionImage,
        photoSelectionModel.PhotoSelectionImage(
            status: newPhotoSelectionImage!.status,
            comment: newPhotoSelectionImage.comment,
            code: newPhotoSelectionImage.code,
            rating: newPhotoSelectionImage.rating,
            lastUpdatedAt: newPhotoSelectionImage.lastUpdated));

    //existingPhotoSelectionImage.folderCode
  }

  Future<void> updatePhotoSelectionBulkImages(
      List<PhotoSelectionImagesCompanion> photoSelectionImages,
      String eventCode) async {
    List<BatchPhotoSelectionImages> batchImages = [];

    // get old data
    for (PhotoSelectionImagesCompanion image in photoSelectionImages) {
      PhotoSelectionImage? existingPhotoSelectionImage =
          await getPhotoSelectionImageWhereCode(image.code.value);
      batchImages.add(
        BatchPhotoSelectionImages(
          folderCode: image.folderCode.value,
          newLastUpdate: image.lastUpdated.value,
          oldLastUpdate: existingPhotoSelectionImage!.lastUpdated,
          newStatus: image.status.value,
          oldStatus: existingPhotoSelectionImage.status,
        ),
      );
    }

    // insert all new data
    await database.batch((batch) {
      return batch.insertAllOnConflictUpdate(
        database.photoSelectionImages,
        photoSelectionImages,
      );
    });

    // get inserted new data
    ///  PhotoSelectionImage newPhotoSelectionImage =
    ///        await getPhotoSelectionWhereCode(photoSelectionImage.code.value);
    // showLog("the table data where ${newPhotoSelectionImage.code}");
    FolderModelDao folderModelDao = FolderModelDao();
    List<Folder> folders =
        await folderModelDao.getFoldersWhereEventCode(eventCode: eventCode);
    FolderStatus folderStatusModelDao = FolderStatus();
    for (Folder folder in folders) {
      List<FolderStatuse> folderStatus = await folderStatusModelDao
          .getFolderStatusWhereFolderCode(folder.code);
      for (FolderStatuse status in folderStatus) {
        batchFolderStatus.add(BatchFolderStatus(folderStatus: status));
      }
    }

    await updateFolderBulkStatus(
      batchImages,
    );

    //existingPhotoSelectionImage.folderCode
  }

  Future<void> updateFolderStatus(
      PhotoSelectionImage existingPhotoSelectionImage,
      photoSelectionModel.PhotoSelectionImage newData) async {
    if (existingPhotoSelectionImage.lastUpdated > newData.lastUpdatedAt!) {
      return;
    } else {
      FolderStatus folderStatus = FolderStatus();
      // get folder status data by newData
      await folderStatus.toggleFolderStatus(
          folderCode: existingPhotoSelectionImage.folderCode,
          oldStatus: existingPhotoSelectionImage.status,
          ownFolderStatus: 1,
          newStatus: newData.status!);

      // decrement existing data
      //0->Default  1->Selected Images,  2->Rejected Images, 3->Wait List Images
    }

    // do update the folder status table
    //folderStatusModelDao.insertPhotoSelection()
  }

  Future<void> updateFolderBulkStatus(
      List<BatchPhotoSelectionImages> batchPhotoSelectionImages) async {
    for (BatchPhotoSelectionImages batchPhotoSelectionImage
        in batchPhotoSelectionImages) {
      if (batchPhotoSelectionImage.oldLastUpdate! <
          batchPhotoSelectionImage.newLastUpdate!) {
        await toggleFolderStatus2(
            folderCode: batchPhotoSelectionImage.folderCode!,
            ownFolderStatus: 1,
            newStatus: batchPhotoSelectionImage.newStatus!,
            oldStatus: batchPhotoSelectionImage.oldStatus!);
      }
    }
    List<FolderStatusesCompanion> folderStatusesCompanion = [];
    for (BatchFolderStatus status in batchFolderStatus) {
      folderStatusesCompanion.add(FolderStatusesCompanion(
          id: drift.Value(status.folderStatus!.id),
          waitingListed: drift.Value(status.folderStatus!.waitingListed),
          selected: drift.Value(status.folderStatus!.selected),
          rejected: drift.Value(status.folderStatus!.rejected),
          folderCode: drift.Value(status.folderStatus!.folderCode),
          combined: drift.Value(status.folderStatus!.combined)));
    }
    database.batch((batch) => batch.insertAllOnConflictUpdate(
        database.folderStatuses, folderStatusesCompanion));
  }

  Future<void> toggleFolderStatus2(
      {required String folderCode,
      required int oldStatus,
      required int ownFolderStatus,
      required int newStatus}) async {
    BatchFolderStatus? _batchFolderStatusTemp;
    if (ownFolderStatus == 1) {
      List<BatchFolderStatus> _folderStatus = // one status combine false
          batchFolderStatus.where((obj) {
        return ((obj.folderStatus!.folderCode == folderCode) &&
            (obj.folderStatus!.combined == false));
      }).toList();

      _batchFolderStatusTemp = updateFolderStatus2(
          oldStatus: oldStatus,
          newStatus: newStatus,
          combined: false,
          batchFolderStatus: _folderStatus[0]);
      batchFolderStatus.removeWhere((obj) {
        return (obj.folderStatus!.combined == false &&
            obj.folderStatus!.folderCode == folderCode);
      });

      if (_batchFolderStatusTemp != null) {
        batchFolderStatus.add(_batchFolderStatusTemp);
      }
    }
    //showLog("folderCode folderCode $folderCode");

    List<BatchFolderStatus> _folderStatus = // one status combine false
        batchFolderStatus.where((obj) {
      return ((obj.folderStatus!.folderCode == folderCode) &&
          (obj.folderStatus!.combined == true));
    }).toList();
    if (_folderStatus.isNotEmpty) {
      _batchFolderStatusTemp = updateFolderStatus2(
          combined: true,
          newStatus: newStatus,
          oldStatus: oldStatus,
          batchFolderStatus: _folderStatus[0]);
      batchFolderStatus.removeWhere((obj) {
        return (obj.folderStatus!.combined == true &&
            obj.folderStatus!.folderCode == folderCode);
      });
    }

    if (_batchFolderStatusTemp != null) {
      batchFolderStatus.add(_batchFolderStatusTemp);
    }
    // get parent folder

    FolderModelDao folderModelDao = FolderModelDao();
    Folder? folder = await folderModelDao.getFolderWhereCode(folderCode);

    if (folder?.parentCode != null) {
      await toggleFolderStatus2(
          oldStatus: oldStatus,
          newStatus: newStatus,
          folderCode: folder!.parentCode!,
          ownFolderStatus: 0);
    }
  }

  BatchFolderStatus? updateFolderStatus2(
      {required bool combined,
      required int oldStatus,
      required int newStatus,
      required BatchFolderStatus batchFolderStatus}) {
    try {
      int selected;
      int rejected;
      int waitingListed;

      if (batchFolderStatus.folderStatus == null) {
        showLog("the folder status is null");
        selected = 0;
        rejected = 0;
        waitingListed = 0;
      } else {
        selected = batchFolderStatus.folderStatus?.selected ?? 0;
        rejected = batchFolderStatus.folderStatus?.rejected ?? 0;
        waitingListed = batchFolderStatus.folderStatus?.waitingListed ?? 0;
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
            showLog("entered into default 1 2 2");
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
          {}
          break;
      }
      return BatchFolderStatus(
          folderStatus: FolderStatuse(
        combined: batchFolderStatus.folderStatus!.combined,
        folderCode: batchFolderStatus.folderStatus!.folderCode,
        id: batchFolderStatus.folderStatus!.id,
        rejected: rejected,
        selected: selected,
        waitingListed: waitingListed,
      ));
    } catch (e) {
      showLog("the problem while folderStatusDao $e");
    }
    return null;
  }

  Future<List<PhotoSelectionImagesModel>> getPhotoSelectionWhereFolderCode(
      String code, status) async {
    var query = (database.select(database.photoSelectionImages)
          ..where((tbl) {
            return (tbl.folderCode.equals(code)) & (tbl.status.equals(status));
          }))
        .join([
      drift.innerJoin(
          database.jvtFileConnectors,
          (database.jvtFileConnectors.ableCode
                  .equalsExp(database.photoSelectionImages.code)) &
              (database.jvtFileConnectors.ableType
                  .equals(TransportDataKeys.photoSelectionImages))),
      drift.innerJoin(
          database.jvtFiles,
          (database.jvtFiles.code
              .equalsExp(database.jvtFileConnectors.jvtFileCode))),
    ]);

    final List<PhotoSelectionImagesModel>  results =await  query.map((row) {
      return PhotoSelectionImagesModel(
        fileConnector: row.readTableOrNull(database.jvtFileConnectors),
        file: row.readTableOrNull(database.jvtFiles),
        photoSelectionImage: row.readTableOrNull(database.photoSelectionImages),
      );
    }).get();
    // ✅ Sort using natural sort on original file name
    results.sort((a, b) => compareNatural(
      a.photoSelectionImage?.originalName ?? '',
      b.photoSelectionImage?.originalName ?? '',
    ));

    return results;
  }

  Future<PhotoSelectionImage?> photoSelectionImageByFolderCode(String code) {
    return ((database.select(database.photoSelectionImages))
          ..where((photoSelection) => photoSelection.folderCode.equals(code))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<PhotoSelectionImage>> MultiplePhotoSelectionImagesByFolderCode(
      String code) {
    return ((database.select(database.photoSelectionImages))
          ..where((photoSelection) => photoSelection.folderCode.equals(code)))
        .get();
  }

  Future<void> deletePhotoSelectionImagesByFolderCode(String folderCode) async {
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    List<PhotoSelectionImage>? photoSelections =
        await getPhotoSelectionImagesWhereFolderCode(folderCode);
    if (photoSelections != null) {
      for (PhotoSelectionImage photoSelectionImage in photoSelections) {
        // delete File Connector
        jvtFileConnectorModelDao.deleteJvtFileConnectorByAbleCodeAndAbleType(
            photoSelectionImage.code, TransportDataKeys.photoSelectionImages);
        // delete photo selection images
        await (database.delete(database.photoSelectionImages)
              ..where((tbl) => tbl.code.equals(photoSelectionImage.code)))
            .go();
      }
    }
  }

  Future<void> deleteWithoutChangingFolderStatus(String code) async {
    showLog('deleter works...001');
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    // delete File Connector
    jvtFileConnectorModelDao.deleteJvtFileConnectorByAbleCodeAndAbleType(
        code, TransportDataKeys.photoSelectionImages);

    // delete photo selection images
    await (database.delete(database.photoSelectionImages)
          ..where((tbl) => tbl.code.equals(code)))
        .go();
    showLog('deleter works...002');
  }

  Future<void> deletePhotoSelectionImages(
      List photoSelectionImagesCodes, String folderCode) async {
    FolderStatus folderStatus = FolderStatus();
    PhotoSelectionImagesModelDao photoSelectionImagesModelDao =
        PhotoSelectionImagesModelDao();
    int selectedCount = 0;
    int rejectedCount = 0;
    int waitingCount = 0;
    showLog('delete works...01');
    /*  for (PhotoSelectionImage photoSelectionImagesCode
        in photoSelectionImagesCodes)*/
    for (int i = 0; i < photoSelectionImagesCodes.length; i++) {
      PhotoSelectionImage? photoSelectionImage =
          await photoSelectionImagesModelDao
              .getPhotoSelectionImageWhereCode(photoSelectionImagesCodes[i]);
      showLog(
          'photoSelectionImage status ${photoSelectionImage!.status},Value is $photoSelectionImage');
      switch (photoSelectionImage.status) {
        case 1:
          {
            // folderStatus selected increment
            selectedCount++;
          }
          break;
        case 2:
          {
            rejectedCount++;
          }
          break;
        case 3:
          {
            waitingCount++;
          }
          break;
        default:
          {
            showLog("entered into default 0");
          }
          break;
      }
      showLog(
          'delete1 works...02 S-$selectedCount,$rejectedCount,$waitingCount');
      await photoSelectionImagesModelDao
          .deleteWithoutChangingFolderStatus(photoSelectionImage.code);

      await folderStatus.toggleForMultipleImages(
          folderCode: folderCode,
          selectedCount: selectedCount,
          rejectedCount: rejectedCount,
          waitingCount: waitingCount,
          action: 'delete',
          ownFolderStatus: 1);
    }
    showLog('delete works...03');
  }

  Future<void> deletePhotoSelectionImagesByCode(String code) async {
    PhotoSelectionImage? photoSelectionImage =
        await getPhotoSelectionImageWhereCode(code);
    FolderStatus folderStatus = FolderStatus();
    showLog(
        'for logout 1 ${await PreferenceHelper.getBool(isUserLoggedInPreferenceKey)}');
    if (await PreferenceHelper.getBool(isUserLoggedInPreferenceKey)) {
      await folderStatus.toggleFolderStatus(
          folderCode: photoSelectionImage!.folderCode,
          oldStatus: photoSelectionImage.status,
          ownFolderStatus: 1,
          newStatus: 0);
    }
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    // delete File Connector
    jvtFileConnectorModelDao.deleteJvtFileConnectorByAbleCodeAndAbleType(
        code, TransportDataKeys.photoSelectionImages);

    // delete photo selection images
    await (database.delete(database.photoSelectionImages)
          ..where((tbl) => tbl.code.equals(code)))
        .go();
  }

  Future<List<PhotoSelectionImage>>? getPhotoSelectionImagesWhereFolderCode(
      String? folderCode) async {
    return await (database.select(database.photoSelectionImages)
          ..where((tbl) {
            return (tbl.folderCode.equals(folderCode!));
          }))
        .get();
  }

  Future<void> insertOrUpdateNewPhotoSelectionImages(
      {required List<transporter.PhotoSelectionImageData> photoSelectionImages,
      required String folderCode,
      String? eventCode}) async {
    List<PhotoSelectionImagesCompanion> photoSelectionImagesCompanion = [];
    //PhotoSelectionImage _photoSelectionImage;
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    List<JvtFileConnectorsCompanion> jvtFilesConnectorsCompanions = [];
    List<JvtFilesCompanion> jvtFilesCompanions = [];
    JvtFileModelDao jvtFileModelDao = JvtFileModelDao();

    try {
      /// availableJvtFileConnectorCodes Begin...
      List<String> availableJvtFileConnectorCodes = [];
      List<JvtFileConnector?>? availableJvtFileConnector =
          await jvtFileConnectorModelDao
              .getPhotoSelectionImagesFileConnectorByFolderCode(folderCode);

      if (availableJvtFileConnector.isNotEmpty) {
        availableJvtFileConnector.forEach((_jvtFileConnector) {
          availableJvtFileConnectorCodes.add(_jvtFileConnector!.code);
        });
      }

      /// availableJvtFileConnectorCodes process End...
      for (transporter.PhotoSelectionImageData photoSelectionImage
          in photoSelectionImages) {
        if (photoSelectionImage.jvtFileConnectors != null) {
          // Prepare Jvt File Connector and File

          if (photoSelectionImage.jvtFileConnectors!.isNotEmpty) {
            for (transporter.JvtFileConnectors jvtFileConnector
                in photoSelectionImage.jvtFileConnectors!) {
              if (!(availableJvtFileConnectorCodes
                      .contains(jvtFileConnector.code)) &&
                  (jvtFileConnector.screenDisplay == currentDevice ||
                      jvtFileConnector.screenDisplay == defaultDevice)) {
                jvtFilesConnectorsCompanions.add(JvtFileConnectorsCompanion(
                  code: drift.Value(jvtFileConnector.code!),
                  tag: drift.Value(jvtFileConnector.name),
                  ableType: drift.Value(TransportDataKeys.photoSelectionImages),
                  ableCode: drift.Value(photoSelectionImage.code!),
                  jvtFileCode: drift.Value(jvtFileConnector.jvtFile!.code!),
                ));
                jvtFilesCompanions.add(JvtFilesCompanion(
                  code: drift.Value(jvtFileConnector.jvtFile!.code!),
                  downloaded: drift.Value(0),
                  extension: drift.Value(jvtFileConnector.jvtFile!.extension!),
                  size: drift.Value(jvtFileConnector.jvtFile!.size!),
                  mode: drift.Value(jvtFileConnector.jvtFile!.mode!),
                  priority: drift.Value(50),
                  attempt: drift.Value(0),
                  name: drift.Value(jvtFileConnector.jvtFile!.name!),
                  isNetworkImage: drift.Value(true),
                ));
              }
            }
          }
        }
        // Prepare NEW PHOTO SELECTION IMAGES
        photoSelectionImagesCompanion.add(PhotoSelectionImagesCompanion(
          folderCode: drift.Value(folderCode),
          code: drift.Value(photoSelectionImage.code!),
          lastUpdated: drift.Value(0),
          status: drift.Value(0),
          synced: drift.Value(false),
          comment: drift.Value(''),
          rating: drift.Value(0),
          originalName: drift.Value(photoSelectionImage.originalFileName),
        ));
      }
      if (photoSelectionImagesCompanion.isNotEmpty) {
        database.batch((batch) {
          return batch.insertAllOnConflictUpdate(
              database.photoSelectionImages, photoSelectionImagesCompanion);
        });
      }
      // not empty checked inside this method
      await jvtFileModelDao.insertAllFile(jvtFilesCompanions);
      await jvtFileConnectorModelDao
          .insertAllFileConnector(jvtFilesConnectorsCompanions);

      // call pm job for photo selection images download removed
    } catch (e) {
      showLog(
          "the problem in photo selection images :: insertPhotoSelection $e");
      return null;
    }
  }

  Future<List<DownloadImageModel>?> getEventPhotoSelectionImages(
      String eventCode) async {
    try {
      var query = (((database.select(database.folders)
            ..where((tbl) {
              return (tbl.eventCode.equals(eventCode));
            }))
          .join([
        drift.innerJoin(
            database.photoSelectionImages,
            database.photoSelectionImages.folderCode
                .equalsExp(database.folders.code)),
        drift.innerJoin(
            database.jvtFileConnectors,
            database.jvtFileConnectors.ableCode
                .equalsExp(database.photoSelectionImages.code)),
        drift.innerJoin(
            database.jvtFiles,
            database.jvtFiles.code
                .equalsExp(database.jvtFileConnectors.jvtFileCode))
      ])));
      return query.map((row) {
        return DownloadImageModel(
            photoSelectionImages:
                row.readTableOrNull(database.photoSelectionImages),
            file: row.readTableOrNull(database.jvtFiles));
      }).get();
    } catch (e) {
      showLog('the error in this photoSelectionDao ${e}');
      return null;
    }
  }
}

class BatchFolderStatus {
  final FolderStatuse? folderStatus;

  BatchFolderStatus({this.folderStatus});
}

class BatchPhotoSelectionImages {
  final int? oldStatus;
  final int? oldLastUpdate;
  final int? newLastUpdate;
  final String? folderCode;
  final int? newStatus;

  BatchPhotoSelectionImages({
    this.newLastUpdate,
    this.folderCode,
    this.newStatus,
    this.oldStatus,
    this.oldLastUpdate,
  });
}
