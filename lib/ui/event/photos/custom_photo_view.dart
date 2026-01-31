import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/album_controller.dart';
import 'package:photomall_flutter/controllers/studio_data_controller.dart';
import 'package:photomall_flutter/core/Utils/file_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/traits/common_widgets/cached_network_image_widget.dart';
import 'package:photomall_flutter/traits/common_widgets/common_download_button.dart';
import 'package:photomall_flutter/traits/image_processor.dart';
import 'package:photomall_flutter/ui/base/base_widget.dart';
import 'package:photomall_flutter/ui/event/photos/custom_photo_view_model.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:provider/provider.dart';

class CustomPhotoView extends StatefulWidget {
  final CustomPhotoViewArgument arguments;

  CustomPhotoView({Key? key, required this.arguments}) : super(key: key);

  @override
  State<CustomPhotoView> createState() => _CustomPhotoViewState();
}

FileUtil fileUtil = FileUtil();
ValueNotifier<bool> isAppBarVisible = ValueNotifier<bool>(true);
StudioDataController studioDataController = StudioDataController();
GlobalKey _scaffold = GlobalKey();

class _CustomPhotoViewState extends State<CustomPhotoView> {
  BaseWidget<CustomPhotoViewModel>? baseWidget;

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // SystemChrome.setEnabledSystemUIOverlays([]);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    // overlays: SystemUiOverlay.values); // to re-show bars
    /*   SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);*/
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    baseWidget = BaseWidget<CustomPhotoViewModel>(
      model: CustomPhotoViewModel(
        apiHandler: Provider.of<ApiHelper>(context, listen: false),
        context: context,
        arguments: widget.arguments,
      ),
      onModelReady: (model) async {
        await model.initialPhotoViewMethod(widget.arguments);
      },
      builder: (context, model, child) {
        return model.loading
            ? Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: AppColorData.backgroundGradientBegin,
                        end: AppColorData.backgroundGradientEnd,
                        colors: AppColorData.backgroundColors,
                        stops: AppColorData.appBackgroundStops)),
                child: Scaffold(
                    key: _scaffold,
                    extendBodyBehindAppBar: true,
                    backgroundColor: Colors.transparent,
                    body: Stack(
                      children: [
                        photoView(model: model, arguments: widget.arguments),
                        IgnorePointer(
                          ignoring: true,
                          child: Container(
                              color: Colors.transparent,
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Center(child: CommonCircularProgress())),
                        ),
                      ],
                    )))
            : photoView(model: model, arguments: widget.arguments);
      },
    );
    return baseWidget!;
  }
}

class photoView extends StatefulWidget {
  final CustomPhotoViewModel model;
  final CustomPhotoViewArgument arguments;

  const photoView({Key? key, required this.model, required this.arguments})
      : super(key: key);

  @override
  State<photoView> createState() => _photoViewState();
}

class _photoViewState extends State<photoView> {
  ImageProcessor imageProcessor = ImageProcessor();

  @override
  void initState() {
    showLog("the data is ready.. ${widget.arguments.eventCode}, ");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.model.controller.jumpToPage(widget.arguments.preIndex!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: GestureDetector(
        onTap: () {
          isAppBarVisible.value = !isAppBarVisible.value;
          showLog("on tap value is :: ${isAppBarVisible.value}");
        },
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: AppColorData.backgroundGradientBegin,
                  end: AppColorData.backgroundGradientEnd,
                  colors: [Colors.black, Colors.black],
                  stops: AppColorData.appBackgroundStops)),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Stack(
                children: [
                  PhotoViewGallery.builder(
                    pageController: widget.model.controller,
                    itemCount: widget.arguments.data!.length,
                    builder: (context, index) {
                      widget.model.orderCode =
                          widget.arguments.data![index]!.orderCode!;
                      return PhotoViewGalleryPageOptions.customChild(
                        minScale: PhotoViewComputedScale.contained * 1,
                        maxScale: PhotoViewComputedScale.covered * 10,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                                child: Hero(
                              tag:
                                  "${widget.arguments.data![index]!.originalName}",
                              child: CustomCachedNetworkImageWidget(
                                url: widget.arguments.data![index]!.url!,
                              ),
                            )),
                            widget.model.viewDownloadButton
                                ? Positioned(
                                    right: 10,
                                    bottom: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                            begin: AppColorData
                                                .buttonGradientBegin,
                                            end: AppColorData.buttonGradientEnd,
                                            colors: AppColorData
                                                .buttonBackgroundColors,
                                            stops: AppColorData
                                                .buttonBackgroundStops),
                                        //gradient: LinearGradient(colors: [Colors.blue,Colors.black])
                                      ),
                                      child: FloatingActionButton.extended(
                                        heroTag: 'download',
                                        elevation: 0,
                                        onPressed: () {},
                                        backgroundColor: Colors.transparent,
                                        tooltip: "download",
                                        label: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CommonFileDownloadButton(
                                            orderCode: widget.arguments
                                                .data![index]!.orderCode!,
                                            originalName: widget.arguments
                                                .data![index]!.originalName,
                                            eventCode:
                                                widget.arguments.eventCode,
                                            albumCode:
                                                widget.arguments.albumCode,
                                            url: widget
                                                .arguments.data![index]!.url!,
                                          ),
                                        ),
                                      ),
                                    ))
                                : SizedBox(),
                            (widget.arguments.title == 'My Photos' &&
                                    widget.model.printStatus == true)
                                ? Positioned(
                                    left: 10,
                                    bottom: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(90),
                                        gradient: LinearGradient(
                                            begin: AppColorData
                                                .buttonGradientBegin,
                                            end: AppColorData.buttonGradientEnd,
                                            colors: AppColorData
                                                .buttonBackgroundColors,
                                            stops: AppColorData
                                                .buttonBackgroundStops),
                                      ),
                                      child: FloatingActionButton.extended(
                                        elevation: 0,
                                        onPressed: () async {
                                          int? status = await widget.model
                                              .getPrintStatus(
                                                  widget.model.orderCode);
                                          showLog('db status $status');
                                          (status == null)
                                              ? await widget.model
                                                  .getPrintStatusApi(
                                                      eventCode: widget
                                                          .arguments.eventCode,
                                                      ableCode: widget
                                                          .model.orderCode,
                                                      status: 1)
                                              : await widget.model.printMessage(
                                                  status: status,
                                                  eventCode: widget
                                                      .arguments.eventCode,
                                                  ableCode:
                                                      widget.model.orderCode,
                                                );
                                        },
                                        backgroundColor: Colors.transparent,
                                        label: widget.model.loadingPrint
                                            ? Center(
                                                child: CommonCircularProgress(
                                                isPrintButton: true,
                                              ))
                                            : Row(
                                                children: [
                                                  Icon(Icons.print),
                                                  Text('${widget.model.print}'),
                                                ],
                                              ),
                                      ),
                                    ))
                                : SizedBox()
                          ],
                        ),
                      );
                    },
                    scrollPhysics: BouncingScrollPhysics(),
                    backgroundDecoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.transparent),
                    enableRotation: false,
                  ),
                  ValueListenableBuilder<bool>(
                      valueListenable: isAppBarVisible,
                      builder:
                          (BuildContext context, bool value, Widget? child) {
                        return isAppBarVisible.value
                            ? Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColorData.backgroundColors.last,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(Icons.arrow_back_ios),
                                            color: AppColorData.bgIconColor,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 0.0),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: UniqueText(
                                                text: getTitle(
                                                    widget.arguments.title!),
                                                //isAppBar: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox();
                      }),
                  ValueListenableBuilder<bool>(
                      valueListenable: isAppBarVisible,
                      builder:
                          (BuildContext context, bool value, Widget? child) {
                        return isAppBarVisible.value
                            ? Positioned(
                                bottom: (MediaQuery.of(context).orientation ==
                                        Orientation.landscape)
                                    ? 0
                                    : 75,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 100,
                                  child: ListView.builder(
                                    physics: ScrollPhysics(),
                                    //shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.arguments.data!.length,
                                    itemBuilder: (context, index) {
                                      showLog(
                                          'ListView.builder thumbnail${widget.arguments.data!.length} ');
                                      return GestureDetector(
                                        onTap: () {
                                          widget.model.controller.jumpToPage(
                                              index); // Jump to the selected image
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child:
                                                CustomCachedNetworkImageWidget(
                                              url: widget
                                                  .arguments.data![index]!.url!,
                                              //width: 80,
                                              //height: 80,

                                              fitSize: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : SizedBox();
                      })

                  // Thumbnails Section
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getTitle(String appBarTitle) {
    if (appBarTitle.contains("&amp;")) {
      appBarTitle = appBarTitle.replaceAll("&amp;", "&");
    }
    if (appBarTitle.contains("&#039;")) {
      appBarTitle = appBarTitle.replaceAll("&#039;", "\'");
    }
    return "$appBarTitle";
  }
}

class CustomPhotoViewArgument {
  int? preIndex;
  String? title;
  String? albumCode;
  List<ImagesViewModel?>? data;
  String? publicStoragePath;
  String? privateStoragePath;
  String? documentPath;
  String? eventCode;
  String? personCode;

  CustomPhotoViewArgument({
    this.preIndex = 0,
    this.title,
    this.data,
    this.albumCode,
    this.eventCode,
    this.publicStoragePath,
    this.privateStoragePath,
    this.documentPath,
    this.personCode,
  });
}
