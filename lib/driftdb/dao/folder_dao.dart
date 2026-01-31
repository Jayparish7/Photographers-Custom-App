import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/controllers/folder_rule_controller.dart';
import 'package:photomall_flutter/controllers/upsert_photoselection_image.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:photomall_flutter/driftdb/dao/folder_rule_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_status_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_current_index_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_images_dao.dart';

import '../../core/Utils/preference_helper.dart';
import '../../core/constants/shared_preference_constants.dart';

class FolderModelDao {
  AppDb database = AppDb();

  insert(FoldersCompanion folder) async {
    try {
      showLog('the folder inserting function called');
      return await database.into(database.folders).insert(folder);
    } catch (e) {
      showLog("problem in folder dao :: insert :: \n$e");
    }
  }

  Future<Folder?> getFolderWhereCode(String code) async {
    try {
      return await (database.select(database.folders)
            ..where((tbl) {
              return (tbl.code.equals(code));
            })
            ..limit(1))
          .getSingleOrNull();
    } catch (e) {
      showLog("problem in folder dao getFolderWhereCode $e");
      return null;
    }
  }

  /// need to delete
  Stream<Folder?> streamRootFolderWhereFolderCode(String code) {
    return (database.select(database.folders)
          ..where((tbl) {
            return (tbl.code.equals(code));
          })
          ..limit(1))
        .watchSingleOrNull();
  }

  /// need to delete
  Future<List<Folder>> getSubFolderWhereParentCode(String code) async {
    return await (database.select(database.folders)
          ..where((tbl) {
            return (tbl.parentCode.equals(code));
          }))
        .get();
  }

  /// need to delete
  Stream<List<Folder>> streamSubFolderWhereParentCode(String code) {
    return (database.select(database.folders)
          ..where((tbl) {
            return (tbl.parentCode.equals(code));
          }))
        .watch();
  }

  Future<List<Folder>> getFoldersByEvent(
    String code,
  ) async {
    List<Folder> folders = await (database.select(database.folders)
          ..where((tbl) {
            return (tbl.eventCode.equals(code));
          }))
        .get();
    return folders;
  }

  Future<Folder?> getFolderByEventAndParentNull(
    String code,
  ) async {
    Folder? folder = await (database.select(database.folders)
          ..where((tbl) {
            return ((tbl.eventCode.equals(code)) & (tbl.parentCode.isNull()));
          }))
        .getSingleOrNull();
    return folder;
  }

  Future<Folder?>
      getFolderByEventAndParentNullTestingForTwoParentFolderCreationIssue(
    String code,
  ) async {
    final folders = await (database.select(database.folders)
          ..where((tbl) =>
              (tbl.eventCode.equals(code)) & (tbl.parentCode.isNull())))
        .get();

    // Log the number of results
    showLog('Number of folders: ${folders.length}');

    // Handle the case where multiple results are returned
    if (folders.isEmpty) {
      return null;
    } else if (folders.length == 1) {
      return folders.first;
    } else {
      // Log a warning or handle the case where multiple results exist
      showLog(
          'Warning: Multiple folders found, returning the first one.${folders}');
      return folders.first; // Or throw an exception if that's more appropriate
    }
  }

  /// need to delete
  Future<List<Folder>> getMultiFoldersWhereCode(String code) async {
    return await (database.select(database.folders)
          ..where((tbl) {
            return (tbl.code.equals(code));
          }))
        .get();
  }

  Future<List<Folder>> getMultiFoldersWhereEventCode(String code) async {
    return await (database.select(database.folders)
          ..where((tbl) {
            return (tbl.eventCode.equals(code));
          }))
        .get();
  }

  Future<List<String>> getChildrenCodes(String code, List<String> codes) async {
    codes.add(code);
    List<Folder> folders = await getSubFolderWhereParentCode(code);
    if (folders.isNotEmpty) {
      for (Folder folder in folders) {
        showLog('child :: ${folder.code} ');
        await getChildrenCodes(folder.code, codes);
      }
    }
    return codes;
  }

  Future<void> deleteFolderByEventCode({required String eventCode}) async {
    // get folders by event code
    List<Folder> folders = await getFoldersWhereEventCode(eventCode: eventCode);
    if (folders.isNotEmpty) {
      for (Folder folder in folders) {
        await deleteFolderByFolderCode(folderCode: folder.code);
      }
    }
  }

  Future<List<Folder>> getFoldersWhereEventCode(
      {required String eventCode}) async {
    return await (database.select(database.folders)
          ..where((tbl) {
            return (tbl.eventCode.equals(eventCode));
          }))
        .get();
  }

  insertNewFolder(
      {required transporter.FolderData folderData,
      required String eventCode}) async {
    showLog('the folder code where ${folderData.code}');
    FolderStatus folderStatus = FolderStatus();
    // insert folder data in db
    FoldersCompanion foldersCompanion = FoldersCompanion(
        eventCode: drift.Value(eventCode),
        code: drift.Value(folderData.code!),
        name: drift.Value(folderData.name!),
        published: drift.Value(folderData.publish),
        parentCode: drift.Value(folderData.parentCode),
        submitted: drift.Value(false),
        lastUpdatedAt: drift.Value(folderData.lastUpdatedAt!));
    await database.into(database.folders).insert(foldersCompanion);
    // INSERT folder status

    FolderStatusesCompanion entityOne = FolderStatusesCompanion(
      folderCode: drift.Value(folderData.code!),
      combined: drift.Value(true),
      waitingListed: drift.Value(0),
      selected: drift.Value(0),
      rejected: drift.Value(0),
    );
    FolderStatusesCompanion entityOneTwo = FolderStatusesCompanion(
      folderCode: drift.Value(folderData.code!),
      combined: drift.Value(false),
      waitingListed: drift.Value(0),
      selected: drift.Value(0),
      rejected: drift.Value(0),
    );
    await folderStatus.insertNewFolderStatus(entityOne);
    await folderStatus.insertNewFolderStatus(entityOneTwo);

    /* if() {
      PhotomallApis photomallApis = PhotomallApis(null);
      FolderStatusApiModel? folderStatusApiModel =
          await photomallApis.folderStatusApi(folderCode: (folderData.code!));
      if (folderStatusApiModel?.folderStatus.waitListedImages != 0 &&
          folderStatusApiModel?.folderStatus.selectedImages == 0 &&
          folderStatusApiModel?.folderStatus.rejectedImages == 0) {
        showLog('create...events 1 worked');
        FolderStatusesCompanion entityOne = FolderStatusesCompanion(
          folderCode: drift.Value(folderData.code!),
          combined: drift.Value(true),
          waitingListed:
              drift.Value(folderStatusApiModel!.folderStatus.waitListedImages),
          selected:
              drift.Value(folderStatusApiModel!.folderStatus.selectedImages),
          rejected:
              drift.Value(folderStatusApiModel!.folderStatus.rejectedImages),
        );
        FolderStatusesCompanion entityOneTwo = FolderStatusesCompanion(
          folderCode: drift.Value(folderData.code!),
          combined: drift.Value(false),
          waitingListed:
              drift.Value(folderStatusApiModel!.folderStatus.waitListedImages),
          selected:
              drift.Value(folderStatusApiModel!.folderStatus.selectedImages),
          rejected:
              drift.Value(folderStatusApiModel!.folderStatus.rejectedImages),
        );
         await folderStatus.insertNewFolderStatus(entityOne);
        await folderStatus.insertNewFolderStatus(entityOneTwo);

        showLog('create...events 2 worked');
      }
    }*/

    // INSERT New FOLDER RULES
    if (folderData.rule != null) {
      FolderRulesDao folderRulesDao = FolderRulesDao();
      await folderRulesDao.insertOrUpdateFolderRule(
          folderCode: folderData.code!, folderRule: folderData.rule!);
    }
    // INSERT NEW PHOTO SELECTION IMAGES
    if (folderData.photoSelectionImages!.isNotEmpty) {
      PhotoSelectionImagesModelDao photoSelectionImagesModelDao =
          PhotoSelectionImagesModelDao();
      await photoSelectionImagesModelDao.insertOrUpdateNewPhotoSelectionImages(
          photoSelectionImages: folderData.photoSelectionImages!,
          folderCode: folderData.code!,
          eventCode: eventCode);
    }
  }

  updateExistingFolder(
      {required transporter.FolderData folderData,
      required String eventCode,
      bool? notification}) async {
    try {
      FoldersCompanion foldersCompanion = FoldersCompanion(
          eventCode: drift.Value(eventCode),
          code: drift.Value(folderData.code!),
          name: drift.Value(folderData.name!),
          published: drift.Value(folderData.publish),
          parentCode: drift.Value(folderData.parentCode),
          submitted: drift.Value(false),
          lastUpdatedAt: drift.Value(folderData.lastUpdatedAt!));

      await (database.update(database.folders)
            ..where((tbl) => tbl.code.equals(folderData.code!)))
          .write(foldersCompanion);
      // folder status no need to update on folder update

      FolderRuleController folderRuleController = FolderRuleController();
      // upsert folder rule
      folderRuleController.upsertFolderRule(
        folderData: folderData,
      );
      showLog("photo selection image upsert begin...${folderData}");

      // UPSERT PHOTO SELECTION IMAGES
      PhotoSelectionImagesUpsert photoSelectionImagesUpsert =
          PhotoSelectionImagesUpsert();
      photoSelectionImagesUpsert.upsertPhotoSelectionImages(
          notification: notification,
          photoSelectionImages: folderData.photoSelectionImages!,
          folderCode: folderData.code!,
          eventCode: eventCode);
    } catch (e) {
      showLog("Exception : folder updating .. Failed due to $e");
    }
  }

  deleteFolderByFolderCode({required String folderCode}) async {
    FolderStatus folderStatus = FolderStatus();
    FolderRulesDao folderRulesDao = FolderRulesDao();
    PhotoSelectionCurrentIndex photoSelectionCurrentIndex =
        PhotoSelectionCurrentIndex();
    showLog(
        'for logout 2 ${await PreferenceHelper.getBool(isUserLoggedInPreferenceKey)}');

    if (await PreferenceHelper.getBool(isUserLoggedInPreferenceKey)) {
      await folderStatus.deleteFolderStatus(
          folderCode: folderCode,
          waitingListed: 0,
          rejected: 0,
          selected: 0,
          ownFolderStatus: 1);
    }

    // delete folder rules
    await folderRulesDao.deleteFolderRulesBYFolderCode(folderCode);

    // delete photo selection current index images
    await photoSelectionCurrentIndex.deleteCurrentIndex(folderCode);
    //delete folder
    await (database.delete(database.folders)
          ..where((tbl) {
            return tbl.code.equals(folderCode);
          }))
        .go();
  }
}
