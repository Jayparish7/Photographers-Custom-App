import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/packages_dao.dart';

class PackageController {
  PackagesModelDao packagesModelDao = PackagesModelDao();

  Future<void> upsertPackages(List<Package> packages) async {
    List<String> apiPackages = [];
    List<String> existingPackages = [];
    // prepare api event list of code
    packages.forEach((package) {
      apiPackages.add(package.code!);
    });

    List create = []; // insert this event
    List delete = []; // delete this event
    List update = [];
    // prepare existing event list of code
    List<appDb.StudioPackageData> _packages =
        await packagesModelDao.getPackages();
    if (_packages.isNotEmpty) {
      _packages.forEach((_package) {
        existingPackages.add(_package.code);
      });
    }
    for (int i = 0; i < apiPackages.length; i++) {
      if (existingPackages.contains(apiPackages[i])) {
        update.add(apiPackages[i]);
      }
      if (!existingPackages.contains(apiPackages[i])) {
        create.add(apiPackages[i]);
      }
    }
    for (int i = 0; i < existingPackages.length; i++) {
      if (!apiPackages.contains(existingPackages[i])) {
        delete.add(existingPackages[i]);
      }
    }

    /// INSERT NEW Package URL TO Package
    if (create.isNotEmpty) {
      for (int i = 0; i < create.length; i++) {
        List<Package> _newPackages =
            packages.where((obj) => obj.code == create[i]).toList();
        await packagesModelDao.insertPackage(_newPackages.first);
      }
    }

    /// UPDATE Existing URL TO Package
    if (update.isNotEmpty) {
      for (int i = 0; i < update.length; i++) {
        List<Package> _updatePackages =
            packages.where((obj) => obj.code == update[i]).toList();
        packagesModelDao.updateOrInsertPackage(_updatePackages.first);
      }
    }

    /// DELETE Package NEED TO BE DELETED
    if (delete.isNotEmpty) {
      for (int i = 0; i < delete.length; i++) {
        await packagesModelDao.deletePackageByCode(delete[i]);
      }
    }
  }

  Future<List<PackageDaoGettingModel>> getPackageList() async {
    return await packagesModelDao.getPackagesAndImage();
  }
}

class PackageDaoGettingModel {
  final appDb.StudioPackageData? package;
  final appDb.JvtFile? file;

  PackageDaoGettingModel({
    this.package,
    this.file,
  });
}
