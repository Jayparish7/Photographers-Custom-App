import 'package:photomall_flutter/controllers/package_controller.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/packages_dao.dart';
import 'package:photomall_flutter/driftdb/dao/packages_value_dao.dart';

class PackageValueController {
  Future<List<PackageValueDaoGettingModel>> getStudioPackageValue(String code) {
    PackagesModelValueDao packagesModelValueDao = PackagesModelValueDao();
    return packagesModelValueDao.getPackageValueDetail(code);
  }

  Future<PackageDaoGettingModel?> getCoverDetails(String code) async {
    PackagesModelDao packagesModelDao = PackagesModelDao();
    return await packagesModelDao.getPackagesCover(code);
  }
}

class PackageValueDaoGettingModel {
  final appDb.StudioPackageValueData? packageValue;
  final appDb.JvtFile? file;

  PackageValueDaoGettingModel({
    this.packageValue,
    this.file,
  });
}
