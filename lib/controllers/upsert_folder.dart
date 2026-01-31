import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/folder_dao.dart';

class FolderUpsert {
  FolderModelDao folderModelDao = FolderModelDao();

  Future<void> upsertFolder({
    required List<transporter.FolderData> folderData,
    required String eventCode,
  }) async {
    showLog('folder view model resource get step 8');

    List<String> apiFolders = [];
    for (transporter.FolderData folder in folderData) {
      apiFolders.add(folder.code!);
    }

    List<String> existingFolders = [];
    if (apiFolders.isNotEmpty) {
      List create = []; // insert this event
      List delete = []; // delete this event
      List update = []; // change update required as true
      /// get local event

      List<appDb.Folder> folders =
          await folderModelDao.getFoldersWhereEventCode(eventCode: eventCode);

      if (folders.isNotEmpty) {
        folders.forEach((_folder) {
          existingFolders.add(_folder.code);
        });
      }
      for (int i = 0; i < apiFolders.length; i++) {
        if (existingFolders.contains(apiFolders[i])) {
          update.add(apiFolders[i]);
        }
        if (!existingFolders.contains(apiFolders[i])) {
          create.add(apiFolders[i]);
        }
      }
      for (int i = 0; i < existingFolders.length; i++) {
        if (!apiFolders.contains(existingFolders[i])) {
          delete.add(existingFolders[i]);
        }
      }

      /// INSERT New Folder
      if (create.isNotEmpty) {
        for (int i = 0; i < create.length; i++) {
          List<transporter.FolderData> _newFolders =
              folderData.where((obj) => obj.code == create[i]).toList();
          await folderModelDao.insertNewFolder(
              folderData: _newFolders.first, eventCode: eventCode);
        }
      }

      /// UPDATE Existing Folder
      if (update.isNotEmpty) {
        for (int i = 0; i < update.length; i++) {
          List<transporter.FolderData> _updateFolder =
              folderData.where((obj) => obj.code == update[i]).toList();
          showLog(
              'folder view model resource get step folder code update ${update[i]}');
          // get folder and check for lastUpdatedAt
          appDb.Folder? _localFolder = await folderModelDao
              .getFolderWhereCode(_updateFolder.first.code!);

          if (_localFolder!.lastUpdatedAt <
              _updateFolder.first.lastUpdatedAt!) {
            await folderModelDao.updateExistingFolder(
                folderData: _updateFolder.first,
                eventCode: eventCode,
                notification: true);
          } else {
            showLog("folder updating .. Failed up to date already");
          }
        }
      }

      /// DELETE Folder NEED TO BE DELETED
      if (delete.isNotEmpty) {
        for (int i = 0; i < delete.length; i++) {
          showLog('the folder where deleting ...${delete[i]}');
          await folderModelDao.deleteFolderByFolderCode(folderCode: delete[i]);
        }
      }
    }
  }
}
