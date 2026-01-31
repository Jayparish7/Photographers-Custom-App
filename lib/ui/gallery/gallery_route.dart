import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photomall_flutter/controllers/pm_job_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/media/media_widget.dart';
import 'package:photomall_flutter/traits/common_widgets/carousel_widget.dart';
import 'package:photomall_flutter/ui/base/base_widget.dart';
import 'package:photomall_flutter/ui/gallery/gallery_route_view_model.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';

class GalleryRoute extends StatefulWidget {
  GalleryRoute({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => GalleryRouteState();
}

class GalleryRouteState extends State<GalleryRoute> {
  var primaryColor;
  var accentColor;
  BaseWidget<GalleryRouteViewModel>? baseWidget;
  ValueNotifier<double> carousalHeight = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (baseWidget != null) {
      baseWidget!.model.destroy();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    baseWidget = BaseWidget<GalleryRouteViewModel>(
      model: GalleryRouteViewModel(context: context),
      onModelReady: (model) async {
        return await model.getGalleryEventAlbums();
      },
      builder: (context, model, child) {
        return Padding(
          padding: EdgeInsets.only(top: 120),
          child: Container(
            child: Stack(
              children: <Widget>[
                _setGalleryContent(context, model),
                ValueListenableBuilder<String?>(
                    valueListenable: model.whatsappNumber,
                    builder:
                        (BuildContext context, String? value, Widget? child) {
                      return (value != null && value.isNotEmpty)
                          ? Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FloatingActionButton(
                                  backgroundColor: Colors.transparent,
                                  onPressed: () async {
                                    /*  ToastUtil T = ToastUtil();
                                     ToastContext().init(context);
                                    await ScreenProtector.preventScreenshotOn();
                                    T.showShortToast(context,"screenshot enabled");
                                     return;*/
                                    await model.launchWhatsapp(context);
                                  },
                                  child: Image.asset(
                                      'assets/images/logoWhatsapp.png'),
                                ),
                              ))
                          : SizedBox();
                    }),
                model.busy
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CommonCircularProgress(),
                        ),
                      )
                    : SizedBox(),
                ValueListenableBuilder<bool>(
                    valueListenable: model.userLoading,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return Visibility(
                        visible: value,
                        child: Center(
                            child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [CommonCircularProgress()],
                                ))),
                      );
                    }),
              ],
            ),
          ),
        );
      },
    );
    return baseWidget!;
  }

  _setGalleryContent(BuildContext context, GalleryRouteViewModel model) {
    return Container(
        child: model.busy
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(),
                ),
              )
            : //initApiCalls(model)
            setGalleryView(model));
    //);
  }

  Widget setGalleryView(GalleryRouteViewModel model) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Obx(() {
        return Column(
          children: <Widget>[
            (model.showCarousel.value)
                ? carouselWidgetView(model)
                : SizedBox.shrink(),
            /*CategoryViewWidget(
                categoryName: model.categoryNames,
              ),*/
            MediaWidget(
              storagePath: DownloadPath(
                  public: model.publicStoragePath,
                  private: model.privateStoragePath,
                  DocumentPath: model.documentDirectory),
              categoryName: model.categoryNames,
              isFromPrivate: false,
            ),
          ],
        );
      }),
    );
  }

  Widget carouselWidgetView(GalleryRouteViewModel model) {
    showLog("the height where ${model.carouselWidth}${model.carouselHeight}");
    if (model.carouselList.isNotEmpty) {
      return CarouselWidget(
        initialPage: model.interval!,
        // aspectRatio:1024 / 500,
        aspectRatio: model.carouselWidth / model.carouselHeight,
        carouselList: model.carouselList,
      );
    } else {
      return SizedBox(
          //child: Text('jay'),
          );
    }
  }
}
