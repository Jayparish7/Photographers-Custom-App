import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/package_controller.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/traits/image_processor.dart';
import 'package:photomall_flutter/ui/base/base_observer.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
as transporterModel;
import 'package:photomall_flutter/ui/studioPackages/common_methods.dart';
class StudioPackageListViewModel extends BaseObserver {
  PackageController packageController = PackageController();

  bool loading = false;
  BuildContext? context;
  ApiHelper? apiHandler;
  PhotomallApis? apiRepo;
  List<PackageListView> packageList = [];
  String? documentDirectory = "";
  String? publicStoragePath = "";
  String? privateStoragePath = "";
  ImageProcessor imageProcessor = ImageProcessor();
  StudioPackageListViewModel({
    this.apiHandler,
    this.context,
  }) {
    apiRepo = PhotomallApis(this.context);
  }

  @override
  void onInternetConnectionBack() {
    // TODO: implement onInternetConnectionBack
  }

  initPackagesPageView() async {
    loading = true;
    await getPackages();
    await getStoragePaths();
    loading = false;
    setBusy(false);
  }

  Future<void> getStoragePaths() async {
    documentDirectory = (await getApplicationDocumentsDirectory()).path;
    var appConfig = TransporterPreference();
    transporterModel.TransportModel? studioDetails =
    await appConfig.getAppConfig();
    if (studioDetails != null && studioDetails.studioData?.data != null) {
      publicStoragePath = studioDetails.studioData?.data?.publicStoragePath ?? "";
      privateStoragePath = studioDetails.studioData?.data?.privateStoragePath ?? "";
    }
  }
  Future<void> getPackages() async {
    List<PackageDaoGettingModel> _packageList =
        await packageController.getPackageList();

    _packageList.forEach((package) {
      if (package.package?.discountValue == null) {
        packageList.add(PackageListView(
          code: package.package!.code,
          file: package.file,
            name: package.package!.name!,
            actualPrice:package.package!.price == null ? null: (package.package!.price! / 100).toString(),
            discount: null,
            discountedPrice: null,
            discountedTerm: null));
      }
      else {
        //  terms_of - 1->percentage,2->amount
        if (package.package!.discountTerm == 1) {
          if(package.package!.price != null){
            double _discountedAmount = getDiscountByPercentage(
                package.package!.discountValue!, package.package!.price!);
            packageList.add(PackageListView(
              code: package.package!.code,
              file: package.file,
              discountedTerm: package.package!.discountTerm,
              name: package.package!.name!,
              actualPrice: (package.package!.price! / 100).toString(),
              discount: (package.package!.discountValue! / 100).toString(),
              discountedPrice: _discountedAmount.toString(),
            ));
          }else{
            packageList.add(PackageListView(
              code: package.package!.code,
              file: package.file,
              discountedTerm: package.package!.discountTerm,
              name: package.package!.name!,
              actualPrice: null,
              discount: null,
              discountedPrice: null,
            ));
          }


        } else {
          if(package.package!.price != null){
            double _discountedAmount = getDiscountByAmount(
                package.package!.discountValue!, package.package!.price!);
            packageList.add(PackageListView(
              code: package.package!.code,
              file: package.file,
              discountedTerm: package.package!.discountTerm,
              name: package.package!.name!,
              actualPrice: (package.package!.price! / 100).toString(),
              discount: (package.package!.discountValue! / 100).toString(),
              discountedPrice: _discountedAmount.toString(),
            ));
          }else{
            packageList.add(PackageListView(
              code: package.package!.code,
              file: package.file,
              discountedTerm: package.package!.discountTerm,
              name: package.package!.name!,
              actualPrice: null,
              discount: null,
              discountedPrice: null,
            ));
          }



        }
      }
    });
  }

}

class PackageListView {
  final String code;
  final String name;
  final String? actualPrice;
  final String? discount;
  final String? discountedPrice;
  final int? discountedTerm;
  final appDb.JvtFile? file;

  PackageListView({
    required this.code,
    this.discount,
    required this.name,
    required this.actualPrice,
    this.discountedPrice,
    this.discountedTerm,
    this.file,
  });
}

class AmountView {
  final String? amount;
  final String? paisa;

  AmountView({this.amount, this.paisa});
}
