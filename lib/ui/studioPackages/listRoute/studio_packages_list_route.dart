import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/Utils/file_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/route_constants.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/traits/common_widgets/common_card.dart';
import 'package:photomall_flutter/traits/common_widgets/custom_transition_widget.dart';
import 'package:photomall_flutter/ui/base/base_widget.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_appbar.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:photomall_flutter/ui/studioPackages/common_methods.dart';
import 'package:photomall_flutter/ui/studioPackages/detailedRoute/packages_detailed_route.dart';
import 'package:photomall_flutter/ui/studioPackages/listRoute/studio_package_list_view_model.dart';
import 'package:provider/provider.dart';

class StudioPackagesListRoute extends StatefulWidget {
  const StudioPackagesListRoute({Key? key}) : super(key: key);

  @override
  State<StudioPackagesListRoute> createState() =>
      _StudioPackagesListRouteState();
}

class _StudioPackagesListRouteState extends State<StudioPackagesListRoute> {
  BaseWidget<StudioPackageListViewModel>? baseWidget;
  FileUtil fileUtils = FileUtil();

  @override
  Widget build(BuildContext context) {
    baseWidget = BaseWidget<StudioPackageListViewModel>(
      model: StudioPackageListViewModel(
        apiHandler: Provider.of<ApiHelper>(context, listen: false),
        context: context,
      ),
      onModelReady: (model) => model.initPackagesPageView(),
      builder: (context, model, child) {
        return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: AppColorData.backgroundGradientBegin,
                    end: AppColorData.backgroundGradientEnd,
                    colors: AppColorData.backgroundColors,
                    stops: AppColorData.appBackgroundStops)),
            child: Scaffold(
                body: model.loading
                    ? CommonCircularProgress()
                    : packageView(model.packageList, model)));
      },
    );
    return baseWidget!;
  }

  Widget packageView(
      List<PackageListView> packageList, StudioPackageListViewModel model) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: AppColorData.backgroundGradientBegin,
              end: AppColorData.backgroundGradientEnd,
              colors: AppColorData.backgroundColors,
              stops: AppColorData.appBackgroundStops)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CommonAppBar(
          title: S.of(context).packages,
        ),
        body: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: packageList.length,
            itemBuilder: (context, index) {
              return CustomItemTransition(
                delay: index * itemTransitionDelay,
                duration: itemTransitionDuration,
                child: packageListItem(packageList[index], model, onTap: () {
                  Navigator.pushNamed(context, RoutePaths.StudioPackageDetails,
                      arguments: PackagesDetailArguments(
                          code: packageList[index].code));
                }),
              );
            }),
      ),
    );
  }

  Widget packageListItem(
      PackageListView packageList, StudioPackageListViewModel model,
      {required Function onTap}) {
    String title = packageList.name;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.transparent,
          ),
          child: CommonCard(
            shape: BorderRadius.circular(25.0),
            child: Column(
              children: [
                _packageImage(
                    onTap: onTap, model: model, packageList: packageList),
                _packageName(
                    packageList: packageList, title: title, onTap: onTap),
              ],
            ),
          )

          /*TicketMaterial(
          colorShadow: AppColorData.cardShadowColor,
          shadowSize: 0,
          flexRightSize: 40,
          lowerBoundAnimation: 0.0,
          marginBetweenCircles: 8,
          radiusCircle: 5,
          height: MediaQuery.of(context).size.height * 0.18,
          colorBackground: AppColorData.selectedCardBackgroundColor,
          radiusBorder: 10,
          leftChild: _packageName(
              packageList: packageList, title: title, onTap: onTap),
          rightChild: _packageImage(
              onTap: onTap, model: model, packageList: packageList),
          useAnimationScaleOnTap: false,
        ),*/
          ),
    );
  }

  Widget _packageImage(
      {required StudioPackageListViewModel model,
      required PackageListView packageList,
      required Function onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5), topRight: Radius.circular(5)),
        child: packageList.file == null
            ? SizedBox()
            : model.imageProcessor.getImageView(
                documentPath: model.documentDirectory,
                boxFit: BoxFit.fill,
                file: packageList.file!,
                privateStoragePath: model.privateStoragePath,
                publicStoragePath: model.publicStoragePath!,
                onTap: () {
                  onTap();
                },
              ),
      ),
    );
  }

  Widget _packageName(
      {String? title, PackageListView? packageList, required Function onTap}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonText(
                isCard: true,
                isHighlightedCard: true,
                textAlign: TextAlign.center,
                text: title ?? "",
                maxlines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              packageList!.actualPrice != null
                  ? getAmountDetailedView(
                      context,
                      packageList.discountedPrice,
                      packageList.discount,
                      packageList.actualPrice!,
                      packageList.discountedTerm)
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
