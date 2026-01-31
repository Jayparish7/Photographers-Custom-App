import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/package_controller.dart';
import 'package:photomall_flutter/controllers/package_value_controller.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporterModel;
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/traits/image_processor.dart';
import 'package:photomall_flutter/ui/base/base_observer.dart';
import 'package:photomall_flutter/ui/studioPackages/common_methods.dart';
import 'package:photomall_flutter/ui/studioPackages/listRoute/studio_package_list_view_model.dart';

class StudioPackageDetailViewModel extends BaseObserver {
  bool loading = false;
  BuildContext? context;
  ApiHelper? apiHandler;
  PhotomallApis? apiRepo;
  List<PackageValueDaoGettingModel> packageValue = [];
  String documentDirectory = "";
  String publicStoragePath = "";
  String privateStoragePath = "";
  String packageName = "";
  Widget? coverImage;
  PackageListView? packageDetail;

  PackageValueController packageValueController = PackageValueController();
  ImageProcessor imageProcessor = ImageProcessor();
  String? description;

  StudioPackageDetailViewModel({
    this.apiHandler,
    this.context,
  }) {
    apiRepo = PhotomallApis(this.context);
  }

  @override
  void onInternetConnectionBack() {
    // TODO: implement onInternetConnectionBack
  }

  initPackagesDetailView(String code) async {
    showLog('the code is ${code}');
    loading = true;
    await getStoragePaths();
    await getPackageValues(code);
    await getCoverDetail(code);
    loading = false;
    setBusy(false);
  }

  getPackageValues(String code) async {
    packageValue = await packageValueController.getStudioPackageValue(code);
    showLog("package detail Value is:::$packageValue");
  }

  getCoverDetail(String code) async {
    PackageDaoGettingModel? packageDaoGettingModel =
        await packageValueController.getCoverDetails(code);
    if (packageDaoGettingModel != null &&
        packageDaoGettingModel.package!.description != null) {
      description = packageDaoGettingModel.package!.description;
    }
    if (packageDaoGettingModel?.package?.discountValue == null) {
      packageDetail = (PackageListView(
          code: packageDaoGettingModel!.package!.code,
          file: packageDaoGettingModel.file,
          name: packageDaoGettingModel.package!.name!,
          actualPrice: packageDaoGettingModel.package!.price == null
              ? null
              : (packageDaoGettingModel.package!.price! / 100).toString(),
          discount: null,
          discountedPrice: null,
          discountedTerm: null));
    } else {
      //  terms_of - 1->percentage,2->amount
      if (packageDaoGettingModel!.package!.discountTerm == 1) {
        if (packageDaoGettingModel.package!.price != null) {
          double _discountedAmount = getDiscountByPercentage(
              packageDaoGettingModel.package!.discountValue!,
              packageDaoGettingModel.package!.price!);
          packageDetail = (PackageListView(
            code: packageDaoGettingModel.package!.code,
            file: packageDaoGettingModel.file,
            discountedTerm: packageDaoGettingModel.package!.discountTerm,
            name: packageDaoGettingModel.package!.name!,
            actualPrice:
                (packageDaoGettingModel.package!.price! / 100).toString(),
            discount: (packageDaoGettingModel.package!.discountValue! / 100)
                .toString(),
            discountedPrice: _discountedAmount.toString(),
          ));
        } else {
          packageDetail = (PackageListView(
            code: packageDaoGettingModel.package!.code,
            file: packageDaoGettingModel.file,
            discountedTerm: packageDaoGettingModel.package!.discountTerm,
            name: packageDaoGettingModel.package!.name!,
            actualPrice: null,
            discount: null,
            discountedPrice: null,
          ));
        }
      } else {
        if (packageDaoGettingModel.package!.price != null) {
          double? _discountedAmount = getDiscountByAmount(
              packageDaoGettingModel.package!.discountValue!,
              packageDaoGettingModel.package!.price!);
          packageDetail = (PackageListView(
            code: packageDaoGettingModel.package!.code,
            file: packageDaoGettingModel.file,
            discountedTerm: packageDaoGettingModel.package!.discountTerm,
            name: packageDaoGettingModel.package!.name!,
            actualPrice:
                (packageDaoGettingModel.package!.price! / 100).toString(),
            discount: (packageDaoGettingModel.package!.discountValue! / 100)
                .toString(),
            discountedPrice: _discountedAmount.toString(),
          ));
        } else {
          packageDetail = (PackageListView(
            code: packageDaoGettingModel.package!.code,
            file: packageDaoGettingModel.file,
            discountedTerm: packageDaoGettingModel.package!.discountTerm,
            name: packageDaoGettingModel.package!.name!,
            actualPrice: null,
            discount: null,
            discountedPrice: null,
          ));
        }
      }
    }
    packageName = packageDaoGettingModel.package!.name!;
    if (packageDaoGettingModel.file != null) {
      coverImage = imageProcessor.getImageView(
          documentPath: documentDirectory,
          boxFit: BoxFit.fitWidth,
          file: packageDaoGettingModel.file!,
          privateStoragePath: privateStoragePath,
          publicStoragePath: publicStoragePath,
          errorWidget: SizedBox(),
          onTap: () {});
    } else {
      coverImage = null;
    }
  }

  Future<void> getStoragePaths() async {
    documentDirectory = (await getApplicationDocumentsDirectory()).path;
    var appConfig = TransporterPreference();
    transporterModel.TransportModel? studioDetails =
        await appConfig.getAppConfig();
    if (studioDetails != null && studioDetails.studioData!.data != null) {
      publicStoragePath = studioDetails.studioData!.data!.publicStoragePath!;
      privateStoragePath = studioDetails.studioData!.data!.privateStoragePath!;
    }
  }
}
