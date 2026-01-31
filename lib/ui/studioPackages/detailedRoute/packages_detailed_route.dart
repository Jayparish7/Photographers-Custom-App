import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/traits/common_widgets/common_card.dart';
import 'package:photomall_flutter/traits/common_widgets/custom_transition_widget.dart';
import 'package:photomall_flutter/ui/base/base_widget.dart';
import 'package:photomall_flutter/ui/shared_widgets/common.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:photomall_flutter/ui/studioPackages/common_methods.dart';
import 'package:photomall_flutter/ui/studioPackages/detailedRoute/packages_detailed_view_model.dart';
import 'package:provider/provider.dart';

class PackagesDetailedRoute extends StatefulWidget {
  final String? code;
  final PackagesDetailArguments arguments;

  PackagesDetailedRoute({Key? key, this.code, required this.arguments})
      : super(key: key);

  @override
  State<PackagesDetailedRoute> createState() => _PackagesDetailedRouteState();
}

class _PackagesDetailedRouteState extends State<PackagesDetailedRoute> {
  BaseWidget<StudioPackageDetailViewModel>? baseWidget;

  initState() {
    super.initState();
    showLog("code is : ${widget.arguments.code}");
  }

  @override
  Widget build(BuildContext context) {
    baseWidget = BaseWidget<StudioPackageDetailViewModel>(
      model: StudioPackageDetailViewModel(
        apiHandler: Provider.of<ApiHelper>(context, listen: false),
        context: context,
      ),
      onModelReady: (model) =>
          model.initPackagesDetailView(widget.arguments.code!),
      builder: (context, model, child) {
        return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: AppColorData.backgroundGradientBegin,
                    end: AppColorData.backgroundGradientEnd,
                    colors: AppColorData.backgroundColors,
                    stops: AppColorData.appBackgroundStops)),
            child: Scaffold(
                extendBodyBehindAppBar: true,
                backgroundColor: Colors.transparent,
                /*appBar: CommonAppBar(
                  title: model.packageName,
                ),*/
                body: ListView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(top: 55),
                    shrinkWrap: true,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_sharp,
                                color: AppColorData.appBarTextColor,
                              )),
                          Text(
                            model.packageName,
                            style: TextStyle(
                              color: AppColorData.appBarTextColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(0.0, 1.0),
                                  blurRadius: 1.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                Shadow(
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 1.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      model.loading
                          ? CommonCircularProgress()
                          : (model.packageName == "") &&
                                  (model.packageDetail?.actualPrice == null)
                              ? EmptyView(
                                  text: S.of(context).noDetailAvailable,
                                  iconData: Icons.assignment,
                                )
                              : packageDetailView(model)
                    ])));
      },
    );
    return baseWidget!;
  }

  packageDetailView(StudioPackageDetailViewModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: AppColorData.cardGradientBegin,
                  end: AppColorData.cardGradientEnd,
                  colors: AppColorData.cardBackgroundColors,
                  stops: AppColorData.cardStops)),
          child: model.coverImage,
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 5.0, right: 5.0, top: 8.0, bottom: 6.0),
          child: Container(
            width: double.infinity,

            /*boxShadow: [
                  BoxShadow(
                    color: AppColorData.cardShadowColor,
                  )
                ]*/

            child: CommonCard(
              shape: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    model.packageName == ""
                        ? SizedBox()
                        : CommonText(
                            isCard: true,
                            isHighlightedCard: true,
                            textAlign: TextAlign.center,
                            // isHeadingHighlightText: true,
                            text: model.packageName,
                          ),
                    model.packageDetail?.actualPrice != null
                        ? getAmountDetailedView(
                            context,
                            model.packageDetail?.discountedPrice,
                            model.packageDetail?.discount,
                            model.packageDetail!.actualPrice!,
                            model.packageDetail?.discountedTerm ?? 0)
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
        model.description == null || model.description == ''
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 8.0, bottom: 6.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                          begin: AppColorData.cardGradientBegin,
                          end: AppColorData.cardGradientEnd,
                          colors: AppColorData.cardBackgroundColors,
                          stops: AppColorData.cardStops)),
                  child: CommonCard(
                    shape: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CommonText(
                        isCard: true,
                        textAlign: TextAlign.left,
                        //isHeadingHighlightText: true,
                        text: model.description ?? "",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ),
              ),
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: model.packageValue.isEmpty
              ? SizedBox()
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: model.packageValue.length,
                  itemBuilder: (context, index) {
                    Widget image = model.packageValue[index].file == null
                        ? Container(
                            color: AppColorData.selectedCardBackgroundColor,
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    gradient: LinearGradient(
                                        begin: AppColorData.cardGradientBegin,
                                        end: AppColorData.cardGradientEnd,
                                        colors:
                                            AppColorData.cardBackgroundColors,
                                        stops: AppColorData.cardStops)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CommonText(
                                    isCard: true,
                                    isHighlightedCard: true,
                                    text:
                                        "${model.packageValue[index].packageValue!.key[0]}",
                                  ),
                                ),
                              ),
                            ),
                          )
                        : model.imageProcessor.getImageView(
                            documentPath: model.documentDirectory,
                            publicStoragePath: model.publicStoragePath,
                            privateStoragePath: model.privateStoragePath,
                            file: model.packageValue[index].file!,
                            errorWidget: SizedBox(),
                            onTap: () {});
                    String title = model.packageValue[index].packageValue!.key;
                    String subTitle =
                        model.packageValue[index].packageValue!.value;
                    showLog(
                        "package detail view::::${model.packageValue[index].file}");
                    return CustomItemTransition(
                      delay: itemTransitionDelay * index,
                      duration: itemTransitionDuration,
                      child: CommonCard(
                        shape: BorderRadius.circular(10),
                        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.blueGrey,),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //  SelectableText('${model.packageValue[index].packageValue.key}'),
                                  title == ''
                                      ? SizedBox()
                                      : Padding(
                                          padding: EdgeInsets.only(
                                              top: 8.0, left: 8),
                                          child: CommonText(
                                            isCard: true,
                                            isHighlightedCard: true,
                                            text: '$title',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ),
                                  subTitle == ''
                                      ? SizedBox()
                                      : Padding(
                                          padding: EdgeInsets.only(
                                              top: 8.0, bottom: 8, left: 8),
                                          child: CommonText(
                                            isCard: true,
                                            text: '$subTitle',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 120,
                                width: 150,
                                child: Stack(
                                  children: [
                                    Transform.translate(
                                      offset: Offset(50.0, 0.0),
                                      child: Container(
                                        child: Stack(
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                                height: 100,
                                                width: 100,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8)),
                                                    child: Container(
                                                        width: 100,
                                                        height: 100,
                                                        child: image),
                                                  ),
                                                )),
                                            Container(
                                              height: 100,
                                              width: 100,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 2, sigmaY: 2),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.0)),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Transform.translate(
                                      offset: Offset(30.0, 15.0),
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        child: CommonCard(
                                            shape: BorderRadius.circular(8),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Container(
                                                    width: 70,
                                                    height: 70,
                                                    child: image),
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
        ),
      ],
    );
  }
}

class PackagesDetailArguments {
  String? code;

  PackagesDetailArguments({this.code});
}
