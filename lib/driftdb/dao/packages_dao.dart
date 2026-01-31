import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/controllers/package_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart';
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:photomall_flutter/driftdb/dao/jvt_file_connector_dao.dart';
import 'package:photomall_flutter/driftdb/dao/packages_value_dao.dart';

class PackagesModelDao {
  AppDb database = AppDb();

  Future<List<StudioPackageData>> getPackages() async {
    return await (database.select(database.studioPackage)).get();
  }

  Future<StudioPackageData?> getPackage(int limit) async {
    return await (database.select(database.studioPackage)..limit(limit))
        .getSingleOrNull();
  }

  Future<List<PackageDaoGettingModel>> getPackagesAndImage() async {
    var query = await (database.select(database.studioPackage)).join([
      drift.leftOuterJoin(
          database.jvtFileConnectors,
          ((database.jvtFileConnectors.ableCode
                  .equalsExp(database.studioPackage.code)) &
              database.jvtFileConnectors.ableType
                  .equals(TransportDataKeys.packages))),
      drift.leftOuterJoin(
          database.jvtFiles,
          database.jvtFiles.code
              .equalsExp(database.jvtFileConnectors.jvtFileCode)),
    ]).get();
    return query.map((rows) {
      return PackageDaoGettingModel(
        package: rows.readTableOrNull(database.studioPackage),
        file: rows.readTableOrNull(database.jvtFiles),
      );
    }).toList();
  }

  Future<void> insertPackage(Package package) async {
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    jvtFileConnectorModelDao.insertJvtFilesConnectors(
        eventType: packages,
        ableType: TransportDataKeys.packages,
        ableCode: package.code,
        jvtFileConnectors: package.jvtFileConnectors!);

    StudioPackageCompanion entity = StudioPackageCompanion(
        description: drift.Value(package.description),
        code: drift.Value(package.code!),
        name: drift.Value(package.name!),
        published: drift.Value(package.published == 1 ? true : false),
        discountTerm: package.discount == null
            ? drift.Value(0)
            : drift.Value(package.discount!.termsOf!),
        discountValue: package.discount == null
            ? drift.Value(null)
            : drift.Value(package.discount!.value!),
        price: drift.Value(package.price));
    await (database.into(database.studioPackage).insert(entity));
    PackagesModelValueDao packagesModelValueDao = PackagesModelValueDao();

    for (PackageValue value in package.packageValues!) {
      packagesModelValueDao.insertPackageValue(value, package.code!);
    }

    // package.packageValues.
  }

  Future<void> deletePackageByCode(String code) async {
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    await jvtFileConnectorModelDao.deleteJvtFileConnectorByAbleCodeAndAbleType(
        code, TransportDataKeys.packages);
    // get package where code

    PackagesModelValueDao packagesModelValueDao = PackagesModelValueDao();
    packagesModelValueDao.deletePackageByCode(code);

    await (database.delete(database.studioPackage)
          ..where((tbl) => tbl.code.equals(code)))
        .go();
  }

  Future<void> updateOrInsertPackage(Package package) async {
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    jvtFileConnectorModelDao.insertJvtFilesConnectors(
        eventType: packages,
        ableType: TransportDataKeys.packages,
        ableCode: package.code,
        jvtFileConnectors: package.jvtFileConnectors!);
    StudioPackageCompanion entity = StudioPackageCompanion(
        description: drift.Value(package.description),
        code: drift.Value(package.code!),
        name: drift.Value(package.name!),
        published: drift.Value(package.published == 1 ? true : false),
        discountTerm: package.discount == null
            ? drift.Value(0)
            : drift.Value(package.discount!.termsOf!),
        discountValue: package.discount == null
            ? drift.Value(null)
            : drift.Value(package.discount!.value!),
        price: drift.Value(package.price));
    await (database
        .into(database.studioPackage)
        .insertOnConflictUpdate(entity));
    PackagesModelValueDao packagesModelValueDao = PackagesModelValueDao();
    for (PackageValue value in package.packageValues!) {
      packagesModelValueDao.updateOrInsertPackageValue(value, package.code!);
    }
    // package.packageValues.
  }

  Future<PackageDaoGettingModel?> getPackagesCover(String code) async {
    var query = await ((database.select(database.studioPackage)..limit(1))
          ..where((tbl) => tbl.code.equals(code)))
        .join([
      drift.leftOuterJoin(
          database.jvtFileConnectors,
          ((database.jvtFileConnectors.ableCode
                  .equalsExp(database.studioPackage.code)) &
              database.jvtFileConnectors.ableType
                  .equals(TransportDataKeys.packages))),
      drift.leftOuterJoin(
          database.jvtFiles,
          database.jvtFiles.code
              .equalsExp(database.jvtFileConnectors.jvtFileCode)),
    ]).getSingleOrNull();
    return PackageDaoGettingModel(
      package: query!.readTableOrNull(database.studioPackage),
      file: query.readTableOrNull(database.jvtFiles),
    );
  }
}
