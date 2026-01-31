import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_button.dart';
import 'package:provider/provider.dart';
import '../color_constants.dart';
import '../core/services/api_helper.dart';
import '../generated/l10n.dart';
import '../traits/common_widgets/cached_network_image_widget.dart';
import '../ui/base/base_widget.dart';
import '../ui/shared_widgets/common_appbar.dart';
import '../ui/shared_widgets/common_circular_progress.dart';
import '../ui/shared_widgets/common_text.dart';
import 'media_view_model.dart';

class DoubtImagesRoute extends StatefulWidget {
  final String eventCode;
  const DoubtImagesRoute({super.key, required this.eventCode});

  @override
  State<DoubtImagesRoute> createState() => _DoubtImagesRouteState();
}

class _DoubtImagesRouteState extends State<DoubtImagesRoute> {
  BaseWidget<MediaRouteViewModel>? baseWidget;
  final ValueNotifier<bool> isLoadingSame = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoadingDifferent = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    baseWidget = BaseWidget<MediaRouteViewModel>(
        model: MediaRouteViewModel(
          apiHandler: Provider.of<ApiHelper>(context, listen: false),
          context: context,
        ),
        onModelReady: (model) async {
          //model.getInitialMediaData(widget.eventCode, widget.personCode);
          model.getStoragePath();
          await model.getDoubtImageUrl();
        },
        builder: (context, model, child) {
          if (model.loading!) {
            return CommonCircularProgress();
          } else {
            var height = MediaQuery.of(context).size.height * 0.15;
            var height1 = MediaQuery.of(context).size.height * 0.45;

            return SafeArea(
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: AppColorData.backgroundGradientBegin,
                            end: AppColorData.backgroundGradientEnd,
                            colors: AppColorData.backgroundColors)),
                    child: Scaffold(
                      appBar: CommonAppBar(title: 'Doubt Image'),
                      backgroundColor: Colors.transparent,
                      body: (model.loading!)
                          ? CommonCircularProgress()
                          : SingleChildScrollView(
                              child: Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      (model.doubtImageUrl != null)
                                          ? Container(
                                              height: height1,
                                              child: Stack(children: [
                                                CustomCachedNetworkImageWidget(
                                                  url:
                                                      '${model.publicStoragePath}/${model.doubtImageUrl}',
                                                ),
                                                CustomPaint(
                                                    painter: RectanglePainter(
                                                        model.boxValues!))
                                              ]),
                                            )
                                          : SizedBox(),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Container(
                                        height: height,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child:
                                                    CustomCachedNetworkImageWidget(
                                                  url:
                                                      '${model.publicStoragePath}/${model.profileJvtFile?.name ?? 'default-event-cover-image-8si4xeoq'}',
                                                ),
                                              ),
                                              SizedBox(
                                                width: 25,
                                              ),
                                              ClipRRect(
                                                key: GlobalKey(),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child:
                                                    CustomCachedNetworkImageWidget(
                                                  url:
                                                      '${model.publicStoragePath}/${model.doubtImageUrl}',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      ColoredBox(
                                        color: Colors.transparent,
                                        child: CommonText(
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30),
                                            text: S.of(context).sameOrDifferentPerson),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ValueListenableBuilder<bool>(
                                              valueListenable:
                                                  isLoadingDifferent,
                                              builder: (BuildContext context,
                                                  bool value, Widget? child) {
                                                return value
                                                    ? CommonCircularProgress()
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: CommonButton(
                                                            onPressCall:
                                                                () async {
                                                              isLoadingDifferent
                                                                  .value = true;
                                                              showLog(
                                                                  'apiMatchPersonCode ${model.apiMatchPersonCode}, '
                                                                  '${model.apiDoubtPersonCode} ');

                                                              await model.myPhotosMatchPersonApiCall(
                                                                  matchPersonCode:
                                                                      model
                                                                          .apiMatchPersonCode,
                                                                  personCode: model
                                                                      .apiDoubtPersonCode,
                                                                  status: 0,
                                                                  context:
                                                                      context,
                                                                  appBarTitle:
                                                                      'My Photos',
                                                                  eventCode: widget
                                                                      .eventCode);

                                                              /*  Navigator.pop(
                                                                  context);*/
                                                            },
                                                            buttonText:
                                                                '         Different           '),
                                                      );
                                              }),
                                          ValueListenableBuilder<bool>(
                                              valueListenable: isLoadingSame,
                                              builder: (BuildContext context,
                                                  bool value, Widget? child) {
                                                return value
                                                    ? CommonCircularProgress()
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: CommonButton(
                                                            onPressCall:
                                                                () async {
                                                              isLoadingSame
                                                                  .value = true;
                                                              showLog(
                                                                  'apiMatchPersonCode ${model.apiMatchPersonCode}, '
                                                                  '${model.apiDoubtPersonCode} ');

                                                              await model.myPhotosMatchPersonApiCall(
                                                                  matchPersonCode:
                                                                      model
                                                                          .apiMatchPersonCode,
                                                                  personCode: model
                                                                      .apiDoubtPersonCode,
                                                                  status: 1,
                                                                  context:
                                                                      context,
                                                                  appBarTitle:
                                                                      'My Photos',
                                                                  eventCode: widget
                                                                      .eventCode);

                                                              /*  Navigator.pop(
                                                                  context);*/
                                                            },
                                                            buttonText:
                                                                '         Same           '),
                                                      );
                                              }),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    )));
          }
        });
    return baseWidget!;
  }
}

class RectanglePainter extends CustomPainter {
  final List<String> pixelCoordinates;
  RectanglePainter(this.pixelCoordinates);
  @override
  void paint(Canvas canvas, Size size) {
    var bound = 38;
    List<int> intList =
        pixelCoordinates.map((String str) => int.parse(str)).toList();
    showLog('pixelCoordinates 123 $pixelCoordinates');

    // Pixel coordinates  [1701, 826, 1836, 968]
    double pixelLeft = intList[0].toDouble(); //1701.0;
    double pixelTop = intList[1].toDouble(); //826.0;
    double pixelRight = intList[2].toDouble(); //1836.0;
    double pixelBottom = intList[3].toDouble(); //968.0;

    // Get the device pixel ratio
    double devicePixelRatio =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .devicePixelRatio;
    List<DisplayFeature> window =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .displayFeatures;
// Use the devicePixelRatio as a scaling factor
    if (window.isNotEmpty) {
      bound = window[0].bounds.width.toInt();
    }
    var scale = getScaleValue(bound.toInt());

    // Convert pixel coordinates to logical pixel coordinates
    double logicalLeft = pixelLeft / devicePixelRatio / scale;
    double logicalTop = pixelTop / devicePixelRatio / scale;
    double logicalRight = pixelRight / devicePixelRatio / scale;
    double logicalBottom = pixelBottom / devicePixelRatio / scale;

    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Rect rect = Rect.fromLTRB(
      logicalLeft,
      logicalTop,
      logicalRight,
      logicalBottom,
    );
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  getScaleValue(value) {
    showLog('getScaleValue $value');

    switch (value) {
      case 32:
        return 3;
      case 38:
        return 3;

      case 51:
        return 2;
      case 52:
        return 3;
      case 42:
        return 2;
      default:
        return 3;
    }
  }
}
