import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photomall_flutter/controllers/download_files_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/folder_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_rule_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_status_dao.dart';
import 'package:photomall_flutter/driftdb/dao/jvt_file_connector_dao.dart';
import 'package:photomall_flutter/driftdb/dao/jvt_file_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_images_dao.dart';
import 'package:photomall_flutter/traits/utils/cache_manager_utils.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';
import 'package:photomall_flutter/ui/folders/model/folder_rule_view_model.dart'
    as folderRuleViewModel;
import 'package:photomall_flutter/ui/folders/model/folder_rule_view_model.dart';

class FolderRuleController {
  bool showSubmitButton = false;
  bool buttonStatus = true;
  bool folderRuleAvailable = true;

  Future<void> upsertFolderRule(
      {required transporter.FolderData folderData}) async {
    // get local rule by folder code
    FolderRulesDao folderRulesDao = FolderRulesDao();
    appDb.FolderRule? folderRule =
        await folderRulesDao.getFolderRuleByFolderCode(folderData.code!);
    if (folderData.rule != null) {
      // insert or update with api
      await folderRulesDao.insertOrUpdateFolderRule(
          folderCode: folderData.code!, folderRule: folderData.rule!);
    } else {
      // api null
      if (folderRule != null) {
        // delete the rule
        folderRulesDao.deleteFolderRulesBYFolderCode(folderData.code!);
      }
    }
  }

  Future<List<folderRuleViewModel.FoldersRuleModel>> getFolderRules(
      String folderCode) async {
    List<folderRuleViewModel.FoldersRuleModel> folderRules = [];
    FolderStatus folderStatus = FolderStatus();
    FolderModelDao folderModelDao = FolderModelDao();
    appDb.Folder? folder = await folderModelDao.getFolderWhereCode(folderCode);

    if (folder?.parentCode == null) {
      showSubmitButton = true;
    }
    List<String> codes = await folderModelDao.getChildrenCodes(folderCode, []);

    for (String code in codes) {
      int excess = 0;
      int shortage = 0;
      bool satisfied = false;
      FolderRulesDao folderRulesDao = FolderRulesDao();
      appDb.FolderRule? folderRule =
          await folderRulesDao.getFolderRuleByFolderCode(code);
      if (folderRule != null) {
        appDb.Folder? folder = await folderModelDao.getFolderWhereCode(code);
        Uint8List? file = await folderThumpImage(code);
        appDb.FolderStatuse? folderStatuse =
            await folderStatus.getFolderStatusByFolderCode(code);
        if (folderStatuse != null) {
          if (folderRule.minimumSelectionImages > folderStatuse.selected) {
            shortage =
                folderRule.minimumSelectionImages - folderStatuse.selected;
          } else {
            satisfied = true;
          }
          if (folderRule.maximumSelectionImages < folderStatuse.selected) {
            satisfied = false;
            excess = folderStatuse.selected - folderRule.maximumSelectionImages;
          } else {
            if (shortage == 0) {
              satisfied = true;
            }
          }
          if (satisfied == false) {
            buttonStatus = satisfied;
          }
          folderRules.add(FoldersRuleModel(
            excess: excess,
            shortage: shortage,
            satisfied: satisfied,
            folderName: folder!.name,
            folderRule: folderRule,
            selectedCount: folderStatuse.selected,
            file: file!,
          ));
        }
      } else {
        folderRuleAvailable = false;
      }
    }
    return folderRules;
  }

  Future<Uint8List?> folderThumpImage(String code) async {
    // get image for the  folder
    PhotoSelectionImagesModelDao photoSelectionModelDao =
        PhotoSelectionImagesModelDao();
    appDb.PhotoSelectionImage? photoSelectionImage =
        await photoSelectionModelDao.photoSelectionImageByFolderCode(code);
    if (photoSelectionImage == null) {
      FolderModelDao folderModelDao = FolderModelDao();
      List<appDb.Folder> children =
          await folderModelDao.getSubFolderWhereParentCode(code);
      for (appDb.Folder child in children) {
        return folderThumpImage(child.code);
      }
    } else {
      JvtFileConnectorModelDao jvtFileConnectorModelDao =
          JvtFileConnectorModelDao();
      JvtFileModelDao jvtFileModelDao = JvtFileModelDao();
      appDb.JvtFileConnector? fileConnector =
          await jvtFileConnectorModelDao.getFileConnectorByAble(
              photoSelectionImage.code, TransportDataKeys.photoSelectionImages);

      if (fileConnector != null) {
        appDb.JvtFile? file =
            await jvtFileModelDao.getFileWhereCode(fileConnector.jvtFileCode);

        DownloadFilesController downloadFilesController =
            DownloadFilesController();
        String url = downloadFilesController.createUrl(
            file: file!,
            publicPath: studioPublicPath!,
            privatePath: studioPrivatePath!);

        CacheUtil cacheUtil = CacheUtil();
        return cacheUtil.getCacheFile(
            /* extension: file.extension, name: file.name,*/
            url: url);
      } else {
        showLog('else part 4 >>');
        return null;
        //send error to server
      }
    }
    return null;
  }

  Future<ThumpImageModel?> folderThumpImage2(String code) async {
    String privatePath;
    String publicPath;
    if (studioPublicPath != null &&
        appDocumentDirectoryPath != null &&
        studioPrivatePath != null) {
      publicPath = studioPublicPath!;
      privatePath = studioPrivatePath!;
    } else {
      EssentialUtils essentialUtils = EssentialUtils();
      essentialUtils.loadAppEssentialData();
      publicPath = studioPublicPath!;
      privatePath = studioPrivatePath!;
    }

    // get image for the  folder
    PhotoSelectionImagesModelDao photoSelectionModelDao =
        PhotoSelectionImagesModelDao();
    appDb.PhotoSelectionImage? photoSelectionImage =
        await photoSelectionModelDao.photoSelectionImageByFolderCode(code);
    if (photoSelectionImage == null) {
      FolderModelDao folderModelDao = FolderModelDao();
      List<appDb.Folder> children =
          await folderModelDao.getSubFolderWhereParentCode(code);
      for (appDb.Folder child in children) {
        return folderThumpImage2(child.code);
      }
    } else {
      JvtFileConnectorModelDao jvtFileConnectorModelDao =
          JvtFileConnectorModelDao();
      JvtFileModelDao jvtFileModelDao = JvtFileModelDao();

      appDb.JvtFileConnector? fileConnector =
          await jvtFileConnectorModelDao.getFileConnectorByAble(
              photoSelectionImage.code, TransportDataKeys.photoSelectionImages);
      appDb.JvtFile? file =
          await jvtFileModelDao.getFileWhereCode(fileConnector!.jvtFileCode);
      if (file != null) {
        return ThumpImageModel(
          file: file,
          publicPath: publicPath,
          privatePath: privatePath,
        );
      } else {
        return null;
      }
    }
    return null;
  }
}

class FolderComputeModel {
  final String? Content;
  final Color? color;
  final int? min;
  final int? max;
  final Uint8List? file;

  FolderComputeModel({
    this.Content,
    this.color,
    this.min,
    this.max,
    this.file,
  });
}

class ButtonStatusModel {
  final bool? showSubmitButton;
  final bool? buttonStatus;

  ButtonStatusModel({this.showSubmitButton, this.buttonStatus});
}

class ThumpImageModel {
  final appDb.JvtFile? file;

  final String? publicPath;

  final String? privatePath;

  ThumpImageModel({this.file, this.publicPath, this.privatePath});
}
