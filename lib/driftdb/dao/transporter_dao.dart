import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/controllers/design_data_controller.dart';
import 'package:photomall_flutter/controllers/device_data_controller.dart';
import 'package:photomall_flutter/controllers/essential_transporter_data_controller.dart';
import 'package:photomall_flutter/controllers/studio_data_controller.dart';
import 'package:photomall_flutter/controllers/user_data_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:photomall_flutter/traits/common_widgets/photo_selection_data_controller.dart';

class TransporterDao {
  AppDb database = AppDb();

  Future<List<TransportDataData>> getEventTransporterWhereEventType(
      int type) async {
    return await (database.select(database.transportData)
          ..where((tbl) {
            return (tbl.type.equals(type)) &
                (tbl.tag.equals(TransportDataKeys.eventData));
          }))
        .get();
  }

  Future<List<TransportDataData>> getEventTransporter() async {
    return await (database.select(database.transportData)
          ..where((tbl) {
            return (tbl.tag.equals(TransportDataKeys.eventData));
          }))
        .get();
  }

  Future<int> insertTransporter(TransportDataCompanion entity) async {
    return await database.into(database.transportData).insert(entity);
  }

  Future<void> insertAllNewTransporter(
      List<TransportDataCompanion> entity) async {
    await database.batch((batch) {
      return batch.insertAll(database.transportData, entity);
    });
  }

  Stream<List<TransportDataData>> streamEventTransporterWhereEventType(
      int type) {
    return (database.select(database.transportData)
          ..where((tbl) {
            return (tbl.type.equals(type)) &
                (tbl.tag.equals(TransportDataKeys.eventData));
          }))
        .watch();
  }

  Future<TransportDataData?> getPhotoSelectionResourceByCode(
      {required String code}) async {
    try {
      return await (database.select(database.transportData)
            ..where((tbl) {
              return ((tbl.code.equals(code)) &
                  (tbl.tag.equals(TransportDataKeys.photoSelectionData)));
            })
            ..limit(1))
          .getSingleOrNull();
    } catch (e) {
      showLog("the error in :: getPhotoSelectionResourceByCode $e");
    }
    return null;
  }

  Future<TransportDataData?> getSingleTransporterWhereEntity(
      TransportDataData data) async {
    return await (database.select(database.transportData)
          ..where((tbl) {
            return ((tbl.tag.equals(data.tag!)) &
                (tbl.code.equals(data.code!)));
          })
          ..limit(1))
        .getSingleOrNull();
  }

  Future<TransportDataData?> getSingleTransporterWhereEntityForEssentialData(
      TransportDataData data) async {
    return await (database.select(database.transportData)
          ..where((tbl) {
            return (tbl.tag.equals(data.tag!));
          })
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<TransportDataData>> getTransporter() async {
    return await database.select(database.transportData).get();
  }

  Future<List<TransportDataData>> getTransporterWithoutTemporaryUrls() async {
    return await (database.select(database.transportData)
          ..where((tbl) {
            return ((tbl.tag.equals(TransportDataKeys.albums).not()) &
                ((tbl.tag.equals(TransportDataKeys.folders).not())));
          }))
        .get();
  }

  Future<List<TransportDataData>>
      getTransporterWithoutTemporaryUrlsAndEssentialData() async {
    return await (database.select(database.transportData)
          ..where((tbl) {
            return ((tbl.tag.equals(TransportDataKeys.albums).not()) &
                    ((tbl.tag.equals(TransportDataKeys.folders).not())) &
                    ((tbl.tag.equals(TransportDataKeys.userData).not())) &
                    //((tbl.tag.equals(TransportDataKeys.deviceData).not())) &
                    ((tbl.tag.equals(TransportDataKeys.designData).not())) &
                    ((tbl.tag
                        .equals(TransportDataKeys.studioData)
                        .not())) /*&
                ((tbl.tag.equals(TransportDataKeys.photoSelectionData).not()))*/
                );
          }))
        .get();
  }

  Future<TransportDataData?> getTransporterWhereCode(String code) async {
    return await (database.select(database.transportData)
          ..where((tbl) => tbl.code.equals(code))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<TransportDataData>> getTransporterEventsWhereCode(
      String code) async {
    return await (database.select(database.transportData)
          ..where((tbl) {
            return ((tbl.code.equals(code)) &
                (tbl.tag.equals(TransportDataKeys.eventData)));
          }))
        .get();
  }

  Future<TransportDataData?> getTransporterWhereCodeAndTag(
      String code, String tag) async {
    return await (database.select(database.transportData)
          ..where((tbl) {
            return (tbl.code.equals(code) & tbl.tag.equals(tag));
          })
          ..limit(1))
        .getSingleOrNull();
  }

  Future<TransportDataData?> getSingleTransporterWhereTag(String tag) async {
    return await (database.select(database.transportData)
          ..where((tbl) => tbl.tag.equals(tag))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<TransportDataData?> getSingleTransporterWhereTagAndUpdateRequired(
      String tag, int updateRequired) async {
    return await (database.select(database.transportData)
          ..where((tbl) => tbl.tag.equals(tag))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<TransportDataData>> getTransporterWhereTagAndUpdateRequired(
      String tag) async {
    return await (database.select(database.transportData)
          ..where((tbl) {
            return ((tbl.tag.equals(tag)) & (tbl.updateRequired.equals(1)));
          }))
        .get();
  }

  Future<List<TransportDataData>> getTransporterWhereTag(String tag) async {
    return await (database.select(database.transportData)
          ..where((tbl) {
            return ((tbl.tag.equals(tag)));
          }))
        .get();
  }

  Future<int?> updateTransporterWhereTag(
      TransportDataCompanion entity, String compare) async {
    try {
      await (database.update(database.transportData)
            ..where((tbl) => tbl.tag.equals(compare)))
          .write(entity);
    } catch (e) {
      showLog("the problem in transporter dao where \n${e}");
    }
    return null;
  }

  Future<void> updateRequiredToggleByCodeAndLastUpdate(
      int updateRequired, String code, int lastUpdate) async {
    showLog("the last update where ${code} / ${lastUpdate}");
    await (database.update(database.transportData)
          ..where((tbl) => tbl.code.equals(code)))
        .write(TransportDataCompanion(
            lastUpdatedAt: drift.Value(lastUpdate),
            updateRequired: drift.Value(updateRequired)));
  }

  Future<void> updateRequiredToggleAndInsertLastUpdateByCodeAndTag(
      int updateRequired, String code, int lastUpdate, String tag) async {
    showLog("the last update where ${code} / ${lastUpdate}");
    await (database.update(database.transportData)
          ..where((tbl) {
            return (tbl.code.equals(code) & (tbl.tag.equals(tag)));
          }))
        .write(TransportDataCompanion(
            lastUpdatedAt: drift.Value(lastUpdate),
            updateRequired: drift.Value(updateRequired)));
  }

  /// ///////////////
  Future<void> updateRequiredToggleByCode(
      int updateRequired, String code) async {
    await (database.update(database.transportData)
          ..where((tbl) => tbl.code.equals(code)))
        .write(TransportDataCompanion(
            updateRequired: drift.Value(updateRequired)));
  }

  Future<void> updateRequiredToggleByTag(int updateRequired, String tag) async {
    await (database.update(database.transportData)
          ..where((tbl) => tbl.tag.equals(tag)))
        .write(TransportDataCompanion(
            updateRequired: drift.Value(updateRequired)));
  }

  Future<void> updateRequiredToggleByCodeAndTag(
      int updateRequired, String code, String tag) async {
    await (database.update(database.transportData)
          ..where((tbl) {
            return ((tbl.code.equals(code)) & (tbl.tag.equals(tag)));
          }))
        .write(TransportDataCompanion(
            updateRequired: drift.Value(updateRequired)));
  }

  Future<void> updateRequiredLastUpdatedByCodeAndTag(
      int lastUpDated, String? code, String tag) async {
    if (tag == TransportDataKeys.userData ||
        tag == TransportDataKeys.designData ||
        //tag == TransportDataKeys.deviceData ||
        tag == TransportDataKeys.studioUserData ||
        tag == TransportDataKeys.studioData ||
        tag == TransportDataKeys.userEventData ||
        tag == TransportDataKeys.aiData) {
      await (database.update(database.transportData)
            ..where((tbl) {
              return tbl.tag.equals(tag);
            }))
          .write(
              TransportDataCompanion(lastUpdatedAt: drift.Value(lastUpDated)));
    } else {
      await (database.update(database.transportData)
            ..where((tbl) {
              return ((tbl.code.equals(code!)) & ((tbl.tag.equals(tag))));
            }))
          .write(
              TransportDataCompanion(lastUpdatedAt: drift.Value(lastUpDated)));
    }
  }

  Future<void> removeDuplicateInDb(
      List<TransportDataData> dbTransporterObtained) async {
    showLog('Duplicate removed table :: :: ===============================');
    for (TransportDataData transporterObtained in dbTransporterObtained) {
      showLog(
          "Code : ${transporterObtained.code} Tag : ${transporterObtained.tag} ");
      TransportDataData? transportDataData;
      if (transporterObtained.tag == TransportDataKeys.studioData ||
         // transporterObtained.tag == TransportDataKeys.deviceData ||
          transporterObtained.tag == TransportDataKeys.designData ||
          transporterObtained.tag == TransportDataKeys.userData) {
        transportDataData =
            await getSingleTransporterWhereEntityForEssentialData(
                transporterObtained);
      } else {
        transportDataData =
            await getSingleTransporterWhereEntity(transporterObtained);
      }

      if (transportDataData != null) {
        await deleteTransporterByCodeAndTag(
            code: transporterObtained.code!, tag: transporterObtained.tag!);
      }
      await insertOrUpdateTransporter(
          updateRequiredValue: 0,
          tag: transporterObtained.code,
          code: transporterObtained.tag);
    }
  }

  Future<void> insertOrUpdateTransporter({
    int? eventType,
    String? code,
    String? tag,
    bool? isNotification,
    int? updateRequiredValue,
  }) async {
    TransportDataCompanion entity;
    TransportDataData? transportDataData;
    // get transporter row by code

    if (tag == TransportDataKeys.userData ||
        tag == TransportDataKeys.designData ||
        //tag == TransportDataKeys.deviceData ||
        tag == TransportDataKeys.studioUserData ||
        tag == TransportDataKeys.studioData ||
        tag == TransportDataKeys.userEventData) {
      transportDataData = await getSingleTransporterWhereTag(tag!);
    } else {
      transportDataData = await getTransporterWhereCodeAndTag(code!, tag!);
    }

    if (transportDataData == null) {
      entity = TransportDataCompanion(
          code: drift.Value(code),
          tag: drift.Value(tag),
          updateRequired: drift.Value(updateRequiredValue ?? 1),
          lastUpdatedAt: drift.Value(0),
          type: drift.Value(eventType ?? 0));
      await database.into(database.transportData).insert(entity);
    } else {
      entity = TransportDataCompanion(
          code: drift.Value(transportDataData.code),
          tag: drift.Value(transportDataData.tag),
          updateRequired: drift.Value(updateRequiredValue ?? 1),
          lastUpdatedAt: drift.Value(transportDataData.lastUpdatedAt),
          type: drift.Value(transportDataData.type));

      if (tag == TransportDataKeys.userData ||
          tag == TransportDataKeys.designData ||
          //tag == TransportDataKeys.deviceData ||
          tag == TransportDataKeys.studioUserData ||
          tag == TransportDataKeys.studioData ||
          tag == TransportDataKeys.userEventData) {
        await (database.update(database.transportData)
              ..where((tbl) {
                return tbl.tag.equals(tag);
              }))
            .write(entity);
      } else {
        await (database.update(database.transportData)
              ..where((tbl) {
                return tbl.code.equals(transportDataData!.code!) &
                    tbl.tag.equals(tag);
              }))
            .write(entity);
      }
    }

    if (entity.updateRequired.value == 1) {
      switch (entity.tag.value) {
        case TransportDataKeys.designData:
          {
            DesignDataController designDataController = DesignDataController();
            await designDataController.getDesignData();
          }
          break;
       // case TransportDataKeys.deviceData:
        //  {
          //  DeviceDataController deviceDataController = DeviceDataController();
          //  await deviceDataController.getDeviceData();
         // }
          break;
        case TransportDataKeys.studioData:
          {
            StudioDataController studioDataController = StudioDataController();
            await studioDataController.getStudioData();
          }
          break;
        case TransportDataKeys.userData:
          {
            UserDataController userDataController = UserDataController();
            //showLog('getUserData');
            await userDataController.getUserData();
          }
          break;
        case TransportDataKeys.userEventData:
          {
            EssentialTransporterDataController
                essentialTransporterDataController =
                EssentialTransporterDataController();
            await essentialTransporterDataController
                .essentialTransporterDataApiCall(isFromSplashScreen: false);
          }
          break;
        case TransportDataKeys.studioUserData:
          {
            EssentialTransporterDataController
                essentialTransporterDataController =
                EssentialTransporterDataController();
            await essentialTransporterDataController
                .essentialTransporterDataApiCall(isFromSplashScreen: false);
          }
          break;
        case TransportDataKeys.photoSelectionData:
          {
            showLog("======================== 4 ${isNotification}");
            Map<String, dynamic> map = {
              "photoSelectionCode": entity.code.value,
              "eventType": eventType,
              "isNotification": isNotification
            };

            await getPhotoSelectionData(map);
          }
          break;
        default:
          {}
          break;
      }
    }
  }

  Future<int> insertOrUpdateEssentialData(String tag) async {
    TransportDataCompanion entity;
    TransportDataData? transportDataData =
        await getSingleTransporterWhereTag(tag);
    if (transportDataData == null) {
      entity = TransportDataCompanion(
        tag: drift.Value(tag),
        updateRequired: drift.Value(1),
        lastUpdatedAt: drift.Value(0),
      );
      return await database.into(database.transportData).insert(entity);
    } else {
      entity = TransportDataCompanion(
          code: drift.Value(transportDataData.code),
          tag: drift.Value(transportDataData.tag),
          updateRequired: drift.Value(1),
          lastUpdatedAt: drift.Value(transportDataData.lastUpdatedAt),
          type: drift.Value(transportDataData.type));

      return await (database.update(database.transportData)
            ..where((tbl) {
              return tbl.tag.equals(tag);
            }))
          .write(entity);
    }
  }

  Future<List<TransportDataData>>
      getEssentialTransporterDataFromTransporter() async {
    return await (database.select(database.transportData)
          ..where((tbl) {
            return (tbl.updateRequired.equals(1)) &
                ((tbl.tag.equals(TransportDataKeys.designData)) |
                    (tbl.tag.equals(TransportDataKeys.studioData)) |
                    (tbl.tag.equals(TransportDataKeys.userData)) |
                    (tbl.tag.equals(TransportDataKeys.studioUserData)) |
                   // (tbl.tag.equals(TransportDataKeys.deviceData)) |
                    (tbl.tag.equals(TransportDataKeys.userEventData)));
          }))
        .get();
  }

  Future<int> deleteTransporterByCode(String code) async {
    return await (database.delete(database.transportData)
          ..where((tbl) => tbl.code.equals(code)))
        .go();
  }

  Future<TransportDataData?> getSingleTransporterWhereTagUpdateRequiredAndCode(
      String tag, String code) async {
    return await (database.select(database.transportData)
          ..where((tbl) {
            return ((tbl.tag.equals(tag)) &
                (tbl.updateRequired.equals(1)) &
                (tbl.code.equals(code)));
          }))
        .getSingleOrNull();
  }

  Stream<TransportDataData?> streamByEventCode(String code) {
    return (database.select(database.transportData)
          ..where((tbl) {
            return (((tbl.tag.equals(TransportDataKeys.eventData)) &
                (tbl.code.equals(code))));
          }))
        .watchSingleOrNull();
  }

  Future<void> deleteTransporterByCodeAndTag(
      {required String code, required String tag}) async {
    if (tag == TransportDataKeys.studioData ||
      //  tag == TransportDataKeys.deviceData ||
        tag == TransportDataKeys.designData ||
        tag == TransportDataKeys.userData) {
      await (database.delete(database.transportData)
            ..where((tbl) {
              return tbl.tag.equals(tag);
            }))
          .go();
    } else {
      showLog("Deleting ... ${code}  ${tag}");

      await (database.delete(database.transportData)
            ..where((tbl) {
              return tbl.code.equals(code) & tbl.tag.equals(tag);
            }))
          .go();
    }
  }

  Future<int?> deleteTransporterByTag({required String tag}) async {
    try {
      return await (database.delete(database.transportData)
            ..where((tbl) {
              return tbl.tag.equals(tag);
            }))
          .go();
    } catch (e) {
      showLog("can't delete $e");
    }
    return null;
  }

  Future<int?> updateDataByCodeAndTag(
      {String? code,
      String? data,
      String? tag,
      int? eventType,
      int? lastUpdatedAt}) async {
    return await (database.update(database.transportData)
          ..where((tbl) {
            return (tbl.code.equals(code!) & (tbl.tag.equals(tag!)));
          }))
        .write(TransportDataCompanion(
      lastUpdatedAt: drift.Value(lastUpdatedAt!),
      type: drift.Value(eventType),
      updateRequired: drift.Value(1),
      data: drift.Value(data),
    ));
  }

  Future<int> updateFolderDataByCodeAndTag({
    required String code,
    required String data,
    required String tag,
  }) async {
    return await (database.update(database.transportData)
          ..where((tbl) {
            return (tbl.code.equals(code) & (tbl.tag.equals(tag)));
          }))
        .write(TransportDataCompanion(
      data: drift.Value(data),
    ));
  }

  Future<void> updateEventDataByCodeAndTag(
      {required String code,
      required String data,
      required String tag,
      required int lastUpdatedAt}) async {
    try {
      await (database.update(database.transportData)
            ..where((tbl) {
              return (tbl.code.equals(code) & (tbl.tag.equals(tag)));
            }))
          .write(TransportDataCompanion(
        lastUpdatedAt: drift.Value(lastUpdatedAt),
        updateRequired: drift.Value(1),
        data: drift.Value(data),
      ));
    } catch (e) {
      print(e);
    }
  }

  Future<void> flushDataByCodeAndTag({
    required String code,
    String? data,
    required String tag,
  }) async {
    await (database.update(database.transportData)
          ..where((tbl) {
            return (tbl.code.equals(code) & (tbl.tag.equals(tag)));
          }))
        .write(TransportDataCompanion(
      updateRequired: drift.Value(0),
      data: drift.Value(''),
    ));
  }
}
