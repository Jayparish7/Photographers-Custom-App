import 'dart:convert';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/download_files_controller.dart';
import 'package:photomall_flutter/controllers/pm_job_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart';
import 'package:photomall_flutter/driftdb/dao/photomall_studio_info_dao.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/traits/utils/storage_utils.dart';
import 'package:photomall_flutter/ui/app_config_request_model.dart'
    as transporterInputModel;

class PhotomallStudioDataController {
  void insertPhotomallStudioValue(TransportModel? transportModel) async {
    if (transportModel != null) {
      PhotomallStudioInfoDao photomallStudioInfoDao = PhotomallStudioInfoDao();
      await photomallStudioInfoDao.insertStudioInfo(
          appDb.PhotomallStudioInfoCompanion(
              code: drift.Value(transportModel.studioData!.data!.code!),
              value: drift.Value(jsonEncode(transportModel.toJson()))));
    }
  }

  Future<StudioDataGetModel?> getStudioRow(String studioCode) async {
    StudioData? data;
    String image = "";
    DownloadPath path;
    if (studioPublicPath != null &&
        appDocumentDirectoryPath != null &&
        studioPrivatePath != null) {
      path = DownloadPath(
        DocumentPath: appDocumentDirectoryPath,
        public: studioPublicPath,
        private: studioPrivatePath,
      );
    }
    else {
      EssentialUtils essentialUtils = EssentialUtils();
      essentialUtils.loadAppEssentialData();
      path = DownloadPath(
        DocumentPath: appDocumentDirectoryPath,
        public: studioPublicPath,
        private: studioPrivatePath,
      );
    }
    // get from table
    PhotomallStudioInfoDao photomallStudioInfoDao = PhotomallStudioInfoDao();
    appDb.PhotomallStudioInfoData? photomallStudioInfoData =
        await photomallStudioInfoDao.getStudioInfoByCode(studioCode);

    if (photomallStudioInfoData != null) {
      try{
        Map<String, dynamic> jsonMap =
        jsonDecode(photomallStudioInfoData.value) as Map<String, dynamic>;
        data = StudioData.fromJson(jsonMap);
        for(JvtFileConnectors jvtFileConnector in data.data!.jvtFileConnectors!){
          if(jvtFileConnector.name == ImageType.studioLogo){
            DownloadFilesController downloadFilesController
            =  DownloadFilesController();
            image =   downloadFilesController.createUrl(
                transporterFile:jvtFileConnector.jvtFile,
                privatePath: path.private!,
                publicPath: path.public!);
          }
        }
        return StudioDataGetModel(
            studioData: data,
            studioName: data.data!.name!,
            image: image);
      }catch(e){
        showLog("the studio data error $e");
        return null;
      }

    } else {
      return null;
    }
  }

  getStudioData(List<String> studioCodes) async {
    PhotomallStudioInfoDao photomallStudioInfoDao = PhotomallStudioInfoDao();
    PhotomallApis apiCall = PhotomallApis(null);
    List<transporterInputModel.InputData> inputData = [];
    List<transporterInputModel.Studios> studios = [];
    // remove duplicate studio codes
    List<String> codes = studioCodes.toSet().toList();
    for (String code in codes) {
      // get local data from db
      appDb.PhotomallStudioInfoData? localData =
          await photomallStudioInfoDao.getStudioInfoByCode(code);
      // if available last update assign to api
      int lastUpdate = 0;
      if (localData != null) {
        lastUpdate = localData.lastUpdatedAt;
      }
      studios.add(transporterInputModel.Studios(
        code: code,
        lastUpdatedAt: lastUpdate,
      ));
    }
    inputData = [
      (transporterInputModel.InputData(
          key: TransportDataKeys.studiosData, studios: studios))
    ];
    TransportModel? transporterResponse =
        await apiCall.callAppConfiguration(null, inputData: inputData);
    if (transporterResponse != null &&
        transporterResponse.studiosData != null &&
        transporterResponse.studiosData!.isNotEmpty) {
      await upsertStudiosData(transporterResponse.studiosData!);

    }
    return;
  }

  Future<void> upsertStudiosData(List<StudioData> studiosData) async {
    PhotomallStudioInfoDao photomallStudioInfoDao = PhotomallStudioInfoDao();
    List<String> apiData = [];
    for (StudioData studio in studiosData) {
      if (studio.data != null && studio.updateRequired == 1) {
        apiData.add(studio.data!.code!);
      }
    }
    List<String> existingStudioInfo = [];
    if (apiData.isNotEmpty) {
      List create = []; // insert this event
      List delete = []; // delete this event
      List update = []; // change update required as true
      /// get local event

      List<appDb.PhotomallStudioInfoData>? studioInfo =
          await photomallStudioInfoDao.getStudioInfo();
      if (studioInfo.isNotEmpty) {
        studioInfo.forEach((_studio) {
          showLog('the carousel want to be deleted 6 ${_studio.code} ');
          existingStudioInfo.add(
              _studio.code
          );
        });
      }
      for (int i = 0; i < apiData.length; i++) {
        if (existingStudioInfo.contains(apiData[i])) {
          showLog('the carousel want to be deleted 6 ${apiData[i]} ');

          update.add(apiData[i]);
        }
        if (!existingStudioInfo.contains(apiData[i])) {
          create.add(apiData[i]);
        }
      }
      for (int i = 0; i < existingStudioInfo.length; i++) {
        if (!apiData.contains(existingStudioInfo[i])) {
          delete.add(existingStudioInfo[i]);
        }
      }
      //   List<transporterModel.Order> _ordersNew =
      //   Orders.where((obj) => obj.code == create[i]).toList();
      /// INSERT New Carousel properties
      if (create.isNotEmpty) {
        List<appDb.PhotomallStudioInfoCompanion> newInfo = [];
        for (int i = 0; i < create.length; i++) {
          List<StudioData> _newStudioInfo =
              studiosData.where((obj) => obj.data?.code == create[i]).toList();
          newInfo.add(appDb.PhotomallStudioInfoCompanion(
            code: drift.Value(_newStudioInfo.first.data!.code!),
            value: drift.Value(jsonEncode(_newStudioInfo.first.toJson())),
            lastUpdatedAt: drift.Value(_newStudioInfo.first.lastUpdatedAt!),
          ));
        }
        await photomallStudioInfoDao.insertAllStudioInfo(
            infoCompanions: newInfo);
      }

      /// UPDATE Existing Carousel carousel properties
      if (update.isNotEmpty) {
        List<appDb.PhotomallStudioInfoCompanion> updateInfo = [];
        for (int i = 0; i < update.length; i++) {
          List<StudioData> _updateStudio =
              studiosData.where((obj) => obj.data!.code == update[i]).toList();
          updateInfo.add(appDb.PhotomallStudioInfoCompanion(
            code: drift.Value(_updateStudio.first.data!.code!),
            value: drift.Value(_updateStudio.first.toJson().toString()),
            lastUpdatedAt: drift.Value(_updateStudio.first.lastUpdatedAt!),
          ));
        }
        await photomallStudioInfoDao.insertAllStudioInfo(
            infoCompanions: updateInfo);
      }

      /// DELETE Carousel At Carousel Properties NEED TO BE DELETED
      if (delete.isNotEmpty) {
        for (int i = 0; i < delete.length; i++) {
          showLog('the carousel want to be deleted${delete[i]}');
          await photomallStudioInfoDao.deleteStudioInfoByCode(delete[i]);
        }
      }
    }
  }
}

class StudioDataGetModel {
  final StudioData? studioData;
  final String studioName;
  final String image;

  StudioDataGetModel(
      {this.studioData, required this.studioName, required this.image});
}
