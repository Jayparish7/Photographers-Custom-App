import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporterModel;
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:photomall_flutter/driftdb/dao/jvt_file_dao.dart';
import 'package:photomall_flutter/traits/utils/screen_utils.dart';

class JvtFileConnectorModelDao {
  ScreenUtil screenUtil = ScreenUtil();
  AppDb database = AppDb();

  /// Get all  method

/*  Future<List<JvtFileConnector>> getJvtFileConnectors() async {
    return await database.select(database.jvtFileConnectors).get();
  }*/

  Future<List<JvtFileConnector>> getMultipleFileConnectorsWhereAbleCode(
      String code) async {
    return await (database.select(database.jvtFileConnectors)
          ..where((tbl) {
            return (tbl.ableCode.equals(code));
          }))
        .get();
  }

/*  Future<List<JvtFileConnector>> getFileConnectorsByName(String tag) async {
    return await (database.select(database.jvtFileConnectors)
          ..where((tbl) {
            return (tbl.tag.equals(tag));
          }))
        .get();
  }*/

/*  Future<List<JvtFileConnector>> getMultipleFileConnectorsWhereAbleCodeAndTag(
      String code, String tag) async {
    return await (database.select(database.jvtFileConnectors)
          ..where((tbl) {
            return (tbl.ableCode.equals(code)) & (tbl.tag.equals(tag));
          }))
        .get();
  }*/

  /// Delete  with code

  Future<int?> deleteJvtFileConnectorByAbleCodeAndAbleType(
      String ableCode, String ableType) async {
  List<JvtFileConnector> availableConnectors=
  await getFileConnectorsByAble(ableCode, ableType);
 if(availableConnectors.isNotEmpty){

   return await (database.delete(database.jvtFileConnectors)
     ..where((tbl) {
       return tbl.ableCode.equals(ableCode) &
       tbl.ableType.equals(ableType);
     }))
       .go();
 }
 return null;

  }
Future<int?> deleteProfileImage() async {


   return await (database.delete(database.jvtFileConnectors)
     ..where((tbl) {
       return tbl.tag.equals('user-profile') ;
     }))
       .go();


  }



  /// Update  with code

/*  Future<void> updateJvtFileConnectorByCode(
      JvtFileConnectorsCompanion entity, String compare) async {
    await (database.update(database.jvtFileConnectors)
          ..where((tbl) => tbl.code.equals(compare)))
        .write(entity);
  }*/

  /// Insert new entity

  Future<int?> insertJvtFilesConnector(JvtFileConnectorsCompanion entity,
      {required int device}) async {
    showLog("screen display $device ${currentDevice}");
    if (currentDevice == device || device == 0) {
      try {
        await database
            .into(database.jvtFileConnectors)
            .insertOnConflictUpdate(entity);
      } catch (e) {
        showLog(
            "1) Problem while insert file connector File connector where   \n$e");
      }
    }
    return null;
  }

  Future<void> insertAllFileConnector(
      List<JvtFileConnectorsCompanion> jvtFileConnectorsCompanion) async {
    showLog('the file connectors length where ${jvtFileConnectorsCompanion.length}');
    if (jvtFileConnectorsCompanion.isNotEmpty) {
      await database.batch((batch) {
        return batch.insertAllOnConflictUpdate(
            database.jvtFileConnectors, jvtFileConnectorsCompanion);
      });
    }else{
      return;
    }

  }

  Future<int?> insertJvtFilesConnectors(
      {required List<transporterModel.JvtFileConnectors> jvtFileConnectors,
      String? ableCode,
      int? eventType,
      String? ableType , bool? isProfile}) async {
    showLog("the file  ${ableCode}  ${eventType}  ${ableType}");

    try {
      List<JvtFileConnectorsCompanion> fileConnectorEntitiesUpdate = [];

      if (currentDevice == null) {
        ScreenUtil screenUtil = ScreenUtil();
        await screenUtil.getAndSetCurrentDevice();
      }

      for (transporterModel.JvtFileConnectors jvtFileConnector
          in jvtFileConnectors) {
        showLog("the screen display ${jvtFileConnector.screenDisplay}");

        if (currentDevice == jvtFileConnector.screenDisplay ||
            jvtFileConnector.screenDisplay == defaultDevice) {
          showLog("the screen display ${jvtFileConnector.screenDisplay}");
          JvtFileConnector? localConnector =
              await getJvtFileConnectorByCode(jvtFileConnector.code!);
          JvtFileConnectorsCompanion fileConnectorEntity =
              JvtFileConnectorsCompanion(
            jvtFileCode: drift.Value(jvtFileConnector.jvtFile!.code!),
            ableType: drift.Value(ableType ?? ""),
            ableCode: drift.Value(ableCode ?? ""),
            tag: drift.Value(jvtFileConnector.name!),
            code: drift.Value(jvtFileConnector.code!),
          );
          if (localConnector == null) {
            fileConnectorEntitiesUpdate.add(fileConnectorEntity);
            /* await database
                 .into(database.jvtFileConnectors)
                 .insertOnConflictUpdate(fileConnectorEntity);*/
          } else {

          }
          if(isProfile == true){
            fileConnectorEntitiesUpdate.add(fileConnectorEntity);
          }

          JvtFileModelDao jvtFileModelDao = JvtFileModelDao();
          await jvtFileModelDao.insertOrUpdateJvtFiles(
              isLogo: jvtFileConnector.name == ImageType.studioCover,
              file: jvtFileConnector.jvtFile!,

              eventType: eventType ?? 0 ,
              isGalleryImages: ((ableType == TransportDataKeys.orders) &&
                      (eventType == studioGalleyEvent)
                  ? true
                  : false));
        }
      }
      if (fileConnectorEntitiesUpdate.isNotEmpty) {
        database.batch((batch) {
          return batch.insertAllOnConflictUpdate(
              database.jvtFileConnectors, fileConnectorEntitiesUpdate);
        });
      }
    } catch (e) {
      showLog(
          "2) Problem while insert file connector FileConnector where   \n$e");
    }
    return null;
  }



  Future<JvtFile?> getUserProfilePicture(String code) async {
   try {
      showLog('user code while get profile  $code');

      JvtFileConnector? jvtFileConnector =
          await (database.select(database.jvtFileConnectors)
                ..where((tbl) {
                  return ((tbl.ableType.equals(TransportDataKeys.users)) &
                      (tbl.ableCode.equals(code)));
                })
                ..limit(1))
              .getSingleOrNull();
      JvtFileModelDao jvtFileModelDao = JvtFileModelDao();
      if(jvtFileConnector!=null){
        JvtFile? jvtFile =
        await jvtFileModelDao.getFileWhereCode(jvtFileConnector.jvtFileCode);

        return jvtFile;
      }else{
        return null;

      }

    } catch (e) {showLog('Error in user profile  dao ${e}');
      return null;
  }
  }


  Future<JvtFile?> getUserProfile(String code) async {
    try {
      showLog('user code while get profile  $code');

      JvtFileConnector? jvtFileConnector =
      await (database.select(database.jvtFileConnectors)
        ..where((tbl) {
          return ((tbl.ableType.equals(TransportDataKeys.users)) &
          (tbl.ableCode.equals(code)));
        })
        ..limit(1))
          .getSingleOrNull();
      JvtFileModelDao jvtFileModelDao = JvtFileModelDao();
      if(jvtFileConnector!=null){
        JvtFile? jvtFile =
        await jvtFileModelDao.getFileWhereCode(jvtFileConnector.jvtFileCode);

        return jvtFile;
      }else{
        return null;

      }

    } catch (e) {showLog('Error in user profile dao ${e}');
    return null;
    }
  }



  Future<JvtFileConnector?> getFileConnectorWhereFileCode(String code) async {
    try {
      return await (database.select(database.jvtFileConnectors)
            ..where((tbl) {
              return (tbl.jvtFileCode.equals(code));
            })
            ..limit(1))
          .getSingleOrNull();
    } catch (e) {
      showLog("the problem while file connector getting $e");
    }
    return null;
  }

  Future<drift.TypedResult> getJvtFileConnectorByFileCode() async {
    return await (((database.select(database.jvtFileConnectors)).join([
      drift.innerJoin(
          database.jvtFiles,
          ((database.jvtFiles.downloaded.equals(1)) &
              (database.jvtFileConnectors.jvtFileCode
                  .equalsExp(database.jvtFiles.code)))),
    ]))
          ..limit(1))
        .getSingle();
  }

  Future<JvtFileConnector?> getJvtFileConnectorByCode(String code) async {
    return await (((database.select(database.jvtFileConnectors))..where((tbl) => tbl.code.equals(code)))
          ..limit(1))
        .getSingleOrNull();
  } Future<JvtFileConnector?> getJvtFileConnector() async {
    return await (((database.select(database.jvtFileConnectors))..where((tbl) => tbl.tag.equals('user-profile')))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<JvtFileConnector?> getFileConnectorWhereAbleCodeAndAlbumCover(
      String ableCode) async {
    return await (database.select(database.jvtFileConnectors)
          ..where((tbl) {
            return (tbl.ableCode.equals(ableCode)) &
                (tbl.tag.equals(TransportDataKeys.albumCover));
          })
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<JvtFileConnector>> getFileConnectorsWhereAbleCodeAndEventCover(
      String ableCode) async {
    return await (database.select(database.jvtFileConnectors)
          ..where((tbl) {
            return (tbl.ableCode.equals(ableCode)) &
                (tbl.tag.equals(TransportDataKeys.eventCover));
          }))
        .get();
  }

  Future<List<JvtFileConnector?>>
      getPhotoSelectionImagesFileConnectorByFolderCode(
          String folderCode) async {
    var query = await (database.select(database.photoSelectionImages)..where((tbl) {
      return (tbl.folderCode.equals(folderCode));
    })).join([drift.innerJoin(
        database.jvtFileConnectors,(
        (database.jvtFileConnectors.ableCode.equalsExp(
            database.photoSelectionImages.code) &
        (database.jvtFileConnectors.ableType.equals(
            TransportDataKeys.photoSelectionImages)
        ))
    ))]).get();

     return query.map((e) {
       return e.readTableOrNull(database.jvtFileConnectors);
     }).toList();
  }

  Future<JvtFileConnector?> getFileConnectorByAble(
      String ableCode, String ableType) async {
    return await (database.select(database.jvtFileConnectors)
          ..where((tbl) {
            return (tbl.ableCode.equals(ableCode)) &
                (tbl.ableType.equals(ableType));
          })
          ..limit(1))
        .getSingleOrNull();
  }

  Future<JvtFileConnector?> getFileConnectorByAbleType(
      String ableCode, String ableType) async {
    return await (database.select(database.jvtFileConnectors)
          ..where((tbl) {
            return (tbl.ableCode.equals(ableCode)) &
                (tbl.ableType.equals(ableType));
          })
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<JvtFileConnector>> getFileConnectorsByAble(
      String ableCode, String ableType) async {
    return await (database.select(database.jvtFileConnectors)
          ..where((tbl) {
            return (tbl.ableCode.equals(ableCode)) &
                (tbl.ableType.equals(ableType));
          }))
        .get();
  }

  Future<List<JvtFileConnector>> getFileConnectorsByAbleCode(
      String ableCode) async {
    return await (database.select(database.jvtFileConnectors)
          ..where((tbl) {
            return (tbl.ableCode.equals(ableCode));
          }))
        .get();
  }

  Future<JvtFileConnector?> getEventCoverSingle(String ableCode) async {
    return await (database.select(database.jvtFileConnectors)
          ..where((tbl) {
            return (tbl.ableCode.equals(ableCode)) &
                (tbl.tag.equals(TransportDataKeys.eventCover));
          })
          ..limit(1))
        .getSingleOrNull();
  }

  Future<JvtFileConnector?> getJvtFileConnectorByFileCodeForDelete(
      String code) async {
    return await ((((database.select(database.jvtFileConnectors)
          ..where((tbl) {
            return tbl.jvtFileCode.equals(code);
          })))
          ..limit(1)))
        .getSingleOrNull();
  }
}
