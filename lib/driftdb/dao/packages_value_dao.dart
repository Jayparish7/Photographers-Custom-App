import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/controllers/package_value_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart';
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:photomall_flutter/driftdb/dao/jvt_file_connector_dao.dart';

class PackagesModelValueDao {
  AppDb database = AppDb();

  Future<List<StudioPackageValueData>> getPackageValues() async {
    return await (database.select(database.studioPackageValue).get());
  }

  Future<void> insertPackageValue(PackageValue value, String ableCode) async {
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    jvtFileConnectorModelDao.insertJvtFilesConnectors(
        eventType: packages,
        ableType: TransportDataKeys.packagesValues,
        ableCode: value.code,
        jvtFileConnectors: value.jvtFileConnectors!);

    StudioPackageValueCompanion entity = StudioPackageValueCompanion(
        code: drift.Value(value.code!),
        key: drift.Value(value.key!),
        value: drift.Value(value.value!),
        ableCode: drift.Value(ableCode));
    await (database.into(database.studioPackageValue).insert(entity));
  }

  Future<void> deletePackageByCode(String ableCode) async {
    // get packageValue where code
    StudioPackageValueData? studioPackageValueData =
        await ((database.select(database.studioPackageValue)
              ..where((tbl) => tbl.ableCode.equals(ableCode))
              ..limit(1))
            .getSingleOrNull());
    if (studioPackageValueData != null) {
      JvtFileConnectorModelDao jvtFileConnectorModelDao =
          JvtFileConnectorModelDao();
      await jvtFileConnectorModelDao
          .deleteJvtFileConnectorByAbleCodeAndAbleType(
              studioPackageValueData.code, TransportDataKeys.packagesValues);
    }
    await (database.delete(database.studioPackageValue)
          ..where((tbl) => tbl.ableCode.equals(ableCode)))
        .go();
  }

  Future<void> updateOrInsertPackageValue(
      PackageValue value, String ableCode) async {
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    jvtFileConnectorModelDao.insertJvtFilesConnectors(
        eventType: packages,
        ableType: TransportDataKeys.packagesValues,
        ableCode: value.code,
        jvtFileConnectors: value.jvtFileConnectors!);

    StudioPackageValueCompanion entity = StudioPackageValueCompanion(
        code: drift.Value(value.code!),
        key: drift.Value(value.key!),
        value: drift.Value(value.value!),
        ableCode: drift.Value(ableCode));
    await (database
        .into(database.studioPackageValue)
        .insertOnConflictUpdate(entity));
  }

  Future<List<PackageValueDaoGettingModel>> getPackageValueDetail(
      String code) async {
    var query = await (database.select(database.studioPackageValue)
          ..where((tbl) => tbl.ableCode.equals(code)))
        .join([
      drift.leftOuterJoin(
          database.jvtFileConnectors,
          ((database.jvtFileConnectors.ableCode
                  .equalsExp(database.studioPackageValue.code)) &
              database.jvtFileConnectors.ableType
                  .equals(TransportDataKeys.packagesValues))),
      drift.leftOuterJoin(
          database.jvtFiles,
          database.jvtFiles.code
              .equalsExp(database.jvtFileConnectors.jvtFileCode)),
    ]).get();
    return query.map((rows) {
      return PackageValueDaoGettingModel(
        packageValue: rows.readTableOrNull(database.studioPackageValue),
        file: rows.readTableOrNull(database.jvtFiles),
      );
    }).toList();
  }
}
