import 'dart:convert';

import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart';
import 'package:photomall_flutter/driftdb/dao/folder_dao.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/jvt_file_connector_dao.dart';
import 'package:photomall_flutter/driftdb/dao/jvt_file_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_images_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_table_dao.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';
import 'package:photomall_flutter/traits/download_method.dart';
import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/traits/utils/screen_utils.dart';

class FolderController {
  FolderModelDao folderModelDao = FolderModelDao();
  PhotoSelectionsDao photoSelectionsDao = PhotoSelectionsDao();

  Future<bool> getFolderSubmitStatus(String code) async {
    appDb.Folder? folder = await folderModelDao.getFolderWhereCode(code);
    // folder.eventCode
    appDb.PhotoSelection? photoSelection = await photoSelectionsDao
        .getPhotoSelectionByEventCode(folder!.eventCode);
    if (photoSelection!.confirmationStatus == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<appDb.JvtFile>> getJvtFilesOfFolderByEvent(
      String eventCode) async {
    List<appDb.JvtFile> fileList = [];
    PhotoSelectionImagesModelDao photoSelectionImagesModelDao =
        PhotoSelectionImagesModelDao();
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    JvtFileModelDao jvtFileModelDao = JvtFileModelDao();
    List<appDb.Folder> folders =
        await folderModelDao.getFoldersByEvent(eventCode);
    for (appDb.Folder folder in folders) {
      List<appDb.PhotoSelectionImage> photoSelectionImages =
          await photoSelectionImagesModelDao
              .MultiplePhotoSelectionImagesByFolderCode(folder.code);
      for (appDb.PhotoSelectionImage photoSelectionImage
          in photoSelectionImages) {
        appDb.JvtFileConnector? _fileConnector =
            await jvtFileConnectorModelDao.getFileConnectorByAbleType(
          photoSelectionImage.code,
          TransportDataKeys.photoSelectionImages,
        );
        if (_fileConnector != null) {
          appDb.JvtFile? _jvtfile = await jvtFileModelDao
              .getFileWhereCode(_fileConnector.jvtFileCode);
          fileList.add(_jvtfile!);
        }
      }
    }
    return fileList;
  }

  Future<List<DownloadImageModel>> getFilesOfFolderByEvent(
      String eventCode) async {
    List<DownloadImageModel> fileList = [];
    PhotoSelectionImagesModelDao photoSelectionImagesModelDao =
        PhotoSelectionImagesModelDao();
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    JvtFileModelDao jvtFileModelDao = JvtFileModelDao();
    List<appDb.Folder> folders =
        await folderModelDao.getFoldersByEvent(eventCode);
    for (appDb.Folder folder in folders) {
      List<appDb.PhotoSelectionImage> photoSelectionImages =
          await photoSelectionImagesModelDao
              .MultiplePhotoSelectionImagesByFolderCode(folder.code);
      for (appDb.PhotoSelectionImage photoSelectionImage
          in photoSelectionImages) {
        appDb.JvtFileConnector? _fileConnector =
            await jvtFileConnectorModelDao.getFileConnectorByAbleType(
          photoSelectionImage.code,
          TransportDataKeys.photoSelectionImages,
        );
        if (_fileConnector != null) {
          DownloadImageModel? data = await jvtFileModelDao
              .getFileWithPhotoSelection(_fileConnector.jvtFileCode);
          fileList.add(data!);
        }
      }
    }
    return fileList;
  }



  Future<List<appDb.JvtFile>> getJvtFileOfFolderByFolderCode(
      String folderCode) async {
    List<appDb.JvtFile> fileList = [];
    PhotoSelectionImagesModelDao photoSelectionImagesModelDao =
        PhotoSelectionImagesModelDao();
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    JvtFileModelDao jvtFileModelDao = JvtFileModelDao();
    List<appDb.PhotoSelectionImage> photoSelectionImages =
        await photoSelectionImagesModelDao
            .MultiplePhotoSelectionImagesByFolderCode(folderCode);
    for (appDb.PhotoSelectionImage photoSelectionImage
        in photoSelectionImages) {
      appDb.JvtFileConnector? _fileConnector =
          await jvtFileConnectorModelDao.getFileConnectorByAbleType(
              photoSelectionImage.code, TransportDataKeys.photoSelectionImages);
      if (_fileConnector != null) {
        appDb.JvtFile? _jvtfile =
            await jvtFileModelDao.getFileWhereCode(_fileConnector.jvtFileCode);
        fileList.add(_jvtfile!);
      }
    }
    return fileList;
  }

  Future<void> fillFolderResources(
      PhotoSelectionData photoSelectionDatas, String folderCode) async {
    try {
      PhotoSelectionData photoSelectionData = photoSelectionDatas;
      JvtFileConnectorModelDao jvtFileConnectorModelDao =
          JvtFileConnectorModelDao();
      TransporterDao transporterDao = TransporterDao();
      // 1) get the event fo the folder
      String eventCode = await folderModelDao
          .getFolderWhereCode(folderCode)
          .then((value) => value!.eventCode);

      List<String> availableJvtFileConnectorCodes = [];
      List<appDb.JvtFileConnector?> availableJvtFileConnector =
          await jvtFileConnectorModelDao
              .getPhotoSelectionImagesFileConnectorByFolderCode(folderCode);
      showLog('available connector length ${availableJvtFileConnector.length}');
      if (availableJvtFileConnector.isNotEmpty) {
        availableJvtFileConnector.forEach((_jvtFileConnector) {
          availableJvtFileConnectorCodes.add(_jvtFileConnector!.code);
        });
      }
      List<appDb.JvtFileConnectorsCompanion> jvtFilesConnectorsCompanions = [];
      List<appDb.JvtFilesCompanion> jvtFilesCompanions = [];
      JvtFileModelDao jvtFileModelDao = JvtFileModelDao();
      if (photoSelectionData.folders!.isNotEmpty) {
        FolderModelDao folderModelDao = FolderModelDao();
        List<FolderData> folderData = photoSelectionData.folders!.where((obj) {
          showLog('Folder condition ${obj.code} $folderCode');
          return obj.code == folderCode;
        }).toList();
        showLog('Folder Length where ${folderData.length}');
        for (FolderData folder in folderData) {
          // check last update for this folder
          appDb.Folder? _localFolder =
              await folderModelDao.getFolderWhereCode(folder.code!);
          //   if (_localFolder != null && _localFolder.lastUpdatedAt < folder.lastUpdatedAt) {
          for (PhotoSelectionImageData photoSelectionImage
              in folder.photoSelectionImages!) {
            if (photoSelectionImage.jvtFileConnectors!.isNotEmpty) {
              for (JvtFileConnectors jvtFileConnector
                  in photoSelectionImage.jvtFileConnectors!) {
                if ((jvtFileConnector.screenDisplay == currentDevice ||
                        jvtFileConnector.screenDisplay == defaultDevice) &&
                    !(availableJvtFileConnectorCodes
                        .contains(jvtFileConnector.code))) {
                  jvtFilesConnectorsCompanions
                      .add(appDb.JvtFileConnectorsCompanion(
                    code: drift.Value(jvtFileConnector.code!),
                    tag: drift.Value(jvtFileConnector.name!),
                    ableType:
                        drift.Value(TransportDataKeys.photoSelectionImages),
                    ableCode: drift.Value(photoSelectionImage.code!),
                    jvtFileCode: drift.Value(jvtFileConnector.jvtFile!.code!),
                  ));
                  jvtFilesCompanions.add(appDb.JvtFilesCompanion(
                    code: drift.Value(jvtFileConnector.jvtFile!.code!),
                    downloaded: drift.Value(0),
                    extension:
                        drift.Value(jvtFileConnector.jvtFile!.extension!),
                    size: drift.Value(jvtFileConnector.jvtFile!.size!),
                    mode: drift.Value(jvtFileConnector.jvtFile!.mode!),
                    priority: drift.Value(50),
                    attempt: drift.Value(0),
                    name: drift.Value(jvtFileConnector.jvtFile!.name!),
                    isNetworkImage: drift.Value(true),
                  ));
                } else {
                  showLog(
                      'File connector already up to date ${jvtFileConnector.code}');
                }
              }
            }
          }
        }

        if (photoSelectionData.folders!.isEmpty) {
          // remove data
          await transporterDao.flushDataByCodeAndTag(
              code: eventCode, tag: TransportDataKeys.photoSelectionData);
        } else {
          // update transporter table
          transporterDao.updateFolderDataByCodeAndTag(
            code: eventCode,
            tag: TransportDataKeys.photoSelectionData,
            data: jsonEncode(photoSelectionData),
          );
        }

        await jvtFileModelDao.insertAllFile(jvtFilesCompanions);
        await jvtFileConnectorModelDao
            .insertAllFileConnector(jvtFilesConnectorsCompanions);
      } else {
        // 2) if folders empty in  the source data at the transporter data should be removed

        /* await transporterDao.flushDataByCodeAndTag(
            code: eventCode, tag: TransportDataKeys.photoSelectionData);*/
      }
    } catch (e) {
      showLog('Exception : fillFolderResources $e');
    }
  }
}
