import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/album_controller.dart';
import 'package:photomall_flutter/controllers/pm_job_controller.dart';
import 'package:photomall_flutter/core/constants/route_constants.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/traits/common_widgets/cached_network_image_widget.dart';
import 'package:photomall_flutter/ui/base/base_widget.dart';
import 'package:photomall_flutter/ui/event/photos/custom_photo_view.dart';
import 'package:photomall_flutter/ui/event/photos/photo_grid_view_model.dart';
import 'package:photomall_flutter/ui/shared_widgets/common.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_appbar.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_button.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:thanos_snap_effect/thanos_snap_effect.dart';

import '../../../core/constants/common_constants.dart';
import '../../../generated/l10n.dart';
import '../../../media/doubt_images_route.dart';
import '../../../media/media_view_model.dart';
import '../../../media/my_photos_route.dart';
import '../../../traits/common_widgets/common_card.dart';
import '../../../traits/common_widgets/common_download_button.dart';
import '../../album/ios_eAlbum_widget.dart';
import '../../album/photoselection/select/photo_selection_route_view_model.dart';
import '../../widgets/empty_screen_widget.dart';
import '../unAuth_user/un_auth_user_profile_view.dart';

class PhotoGrid extends StatefulWidget {
  final PhotoGridArguments? arguments;

  PhotoGrid({
    Key? key,
    this.arguments,
  }) : super(key: key);

  @override
  State<PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> with TickerProviderStateMixin {
  BaseWidget<PhotoGridViewModel>? baseWidget;
  late AnimationController _animationController;
  late AnimationController animationController;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    baseWidget = BaseWidget<PhotoGridViewModel>(
      model: PhotoGridViewModel(
        apiHandler: Provider.of<ApiHelper>(context, listen: false),
        context: context,
      ),
      onModelReady: (model) async {
        if (widget.arguments!.appBarTitle == "My Photos") {
          model.loading = true;
          final mediaRouteViewModel =
              await Provider.of<MediaRouteViewModel>(context, listen: false);
          await mediaRouteViewModel.getPersonCode(
            widget.arguments!.eventCode,
            isLastUpdatedNull: true,
          );
        }

        await model.getInitialData(widget.arguments!.albumCode,
            storagePath: widget.arguments!.storagePath,
            folderCode: widget.arguments!.folderCode,
            status: widget.arguments!.status,
            personCode: widget.arguments!.personCode,
            realPersons: widget.arguments!.realPersonCode,
            eventCode: widget.arguments!.eventCode,
            isWithoutFace: widget.arguments!.isWithoutFace,
            photoSelectionsData: widget.arguments?.photoSelections);
      },
      builder: (context, model, child) {
        return (widget.arguments?.isIos != true)
            ? Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: AppColorData.backgroundGradientBegin,
                        end: AppColorData.backgroundGradientEnd,
                        colors: AppColorData.backgroundColors)),
                child: !widget.arguments!.isFromAlbum
                    ? Scaffold(
                        extendBodyBehindAppBar: true,
                        backgroundColor: Colors.transparent,
                        appBar: widget.arguments?.isFromUnAuth == true
                            ? null
                            : CommonAppBar(
                                autoLeadingIcon: (widget
                                                .arguments!.appBarTitle ==
                                            "My Photos" ||
                                        widget.arguments?.folderCode == null)
                                    ? true
                                    : false,
                                isCenterTitle: false,
                                titleWidget:
                                    widget.arguments!.appBarTitle == null
                                        ? Row(children: [
                                            IconButton(
                                                onPressed: () {
                                                  //await updateCurrentIndex(model);
                                                  Navigator.pop(
                                                      context,
                                                      (model.localPhotosList.value
                                                                  .length) ==
                                                              0
                                                          ? 0
                                                          : 1);
                                                },
                                                icon: Icon(Icons.arrow_back)),
                                            model.getAppBarTitle(
                                                widget.arguments!.status,
                                                widget.arguments!.folderCode)
                                          ])
                                        : SizedBox(),
                                isAppBarTitleWidget:
                                    widget.arguments!.appBarTitle == null
                                        ? true
                                        : false,
                                actions: [
                                  (widget.arguments!.folderCode != null &&
                                          widget.arguments!.status != null)
                                      ? Obx(() => UniqueText(
                                          text:
                                              '(${model.photosListLength})   '))
                                      : Obx(() => UniqueText(
                                          text:
                                              '(${model.photosListLength})   '))
                                ],
                                title: getTitle(
                                    widget.arguments!.appBarTitle ?? ""),
                              ),
                        body: model.loading
                            ? model.personImage != null
                                ? EmptyView(
                                    iconData: Icons.perm_media_outlined,
                                    text: S.of(context).noMatchesFound)
                                : Center(
                                    child: Lottie.asset(
                                        'assets/animations/loading_clock.json'))
                            : ValueListenableBuilder<List<ImagesViewModel>>(
                                valueListenable: model.localPhotosList,
                                builder: (BuildContext context,
                                    List<ImagesViewModel> value,
                                    Widget? child) {
                                  if (value.isEmpty) {
                                    if ((widget.arguments!.folderCode ==
                                        null)) {
                                      if (((widget.arguments!.appBarTitle) !=
                                          'My Photos')) {
                                        return EmptyView(
                                            text: S
                                                .of(context)
                                                .no_photos_available,
                                            iconData: Icons.update
                                            //'Profile photo has been uploaded successfully but still under process please wait for the notification ',//'Your Request is under Process',
                                            );
                                      } else {
                                        /*return EmptyView(
                                                iconData: Icons.update,
                                                text: S
                                                    .of(context)
                                                    .profilePhotoUploaded,
                                                text1: S
                                                    .of(context)
                                                    .butStillUnderProcess,
                                                text2: S
                                                    .of(context)
                                                    .pleaseWaitForNotification,
                                              );*/
                                      }
                                    } else {
                                      return EmptyView(
                                          text:
                                              S.of(context).no_photos_available,
                                          iconData: Icons.update);
                                    }
                                  }

                                  return ListView(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      padding: EdgeInsets.only(top: 50),
                                      children: [
                                        //showCircleAvatar(context, model, value),
                                        showGrid(
                                          context,
                                          model,
                                          value,
                                        )
                                      ]);
                                }))
                    : GestureDetector(
                        onTap: () {
                          isAppBarVisible.value = !isAppBarVisible.value;
                          showLog(
                              "on tap value is :: ${isAppBarVisible.value}");
                        },
                        child: Scaffold(
                            backgroundColor: Colors.black,
                            extendBodyBehindAppBar: true,
                            body: Padding(
                              padding: EdgeInsets.only(
                                  top: (widget.arguments!.appBarTitle !=
                                          "My Photos")
                                      ? 0
                                      : 65.0),
                              child: Stack(
                                children: [
                                  model.loading
                                      ? model.personImage != null
                                          ? CommonCircularProgress()
                                          : EmptyView(
                                              iconData:
                                                  Icons.perm_media_outlined,
                                              text:
                                                  S.of(context).noMatchesFound)
                                      : ValueListenableBuilder<
                                              List<ImagesViewModel>>(
                                          valueListenable:
                                              model.localPhotosList,
                                          builder: (BuildContext context,
                                              List<ImagesViewModel> value,
                                              Widget? child) {
                                            if (value.isEmpty) {
                                              return (widget.arguments!
                                                          .folderCode ==
                                                      null)
                                                  ? ((widget.arguments!
                                                              .appBarTitle) !=
                                                          'My Photos')
                                                      ? EmptyView(
                                                          text: S
                                                              .of(context)
                                                              .no_photos_available,
                                                          iconData: Icons.update
                                                          //'Profile photo has been uploaded successfully but still under process please wait for the notification ',//'Your Request is under Process',
                                                          )
                                                      : EmptyView(
                                                          iconData:
                                                              Icons.update,
                                                          text: S
                                                              .of(context)
                                                              .profilePhotoUploaded,
                                                          text1: S
                                                              .of(context)
                                                              .butStillUnderProcess,
                                                          text2: S
                                                              .of(context)
                                                              .pleaseWaitForNotification,
                                                        )
                                                  : EmptyView(
                                                      text: S
                                                          .of(context)
                                                          .no_photos_available,
                                                      iconData: Icons.update);
                                            }

                                            return ListView(
                                                shrinkWrap: true,
                                                physics: ScrollPhysics(),
                                                children: [
                                                  //showCircleAvatar(context, model, value),
                                                  showGrid(
                                                    context,
                                                    model,
                                                    value,
                                                  )
                                                ]);
                                          }),
                                  ValueListenableBuilder<bool>(
                                      valueListenable: isAppBarVisible,
                                      builder: (BuildContext context,
                                          bool value, Widget? child) {
                                        return isAppBarVisible.value
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 45.0),
                                                child: Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: AppColorData
                                                        .backgroundColors.last,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            IconButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: Icon(Icons
                                                                  .arrow_back_ios),
                                                              color: AppColorData
                                                                  .bgIconColor,
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left:
                                                                          0.0),
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.7,
                                                                child:
                                                                    UniqueText(
                                                                  text: getTitle(widget
                                                                      .arguments!
                                                                      .appBarTitle!),
                                                                  //isAppBar: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox();
                                      }),
                                ],
                              ),
                            )),
                      ),
              )
            : Scaffold(
                backgroundColor: Colors.transparent,
                body: model.loading
                    ? model.personImage != null
                        ? CommonCircularProgress()
                        : EmptyView(
                            iconData: Icons.perm_media_outlined,
                            text: S.of(context).noMatchesFound)
                    : ValueListenableBuilder<List<ImagesViewModel>>(
                        valueListenable: model.localPhotosList,
                        builder: (BuildContext context,
                            List<ImagesViewModel> value, Widget? child) {
                          if (value.isEmpty) {
                            return (widget.arguments!.folderCode == null)
                                ? ((widget.arguments!.appBarTitle) !=
                                        'My Photos')
                                    ? EmptyView(
                                        text: S.of(context).no_photos_available,
                                        iconData: Icons.update)
                                    : EmptyView(
                                        iconData: Icons.update,
                                        text:
                                            S.of(context).profilePhotoUploaded,
                                        text1:
                                            S.of(context).butStillUnderProcess,
                                        text2: S
                                            .of(context)
                                            .pleaseWaitForNotification,
                                      )
                                : EmptyView(
                                    text: S.of(context).no_photos_available,
                                    iconData: Icons.update);
                          }

                          return showGrid(
                            context,
                            model,
                            value,
                          );
                        }));
      },
    );
    return baseWidget!;
  }

  getAlbumName(String text) {
    if (text.contains("&amp;")) {
      showLog("yes it contain this ");
      text = text.replaceAll("&amp;", "&");
    }
    if (text.contains("&#039;")) {
      showLog("yes it contain this ");
      text = text.replaceAll("&#039;", "\'");
    }

    return text;
  }

  showCircleAvatar(
    BuildContext context,
    PhotoGridViewModel model,
  ) {
    showLog('message showCircleAvatar');
    if ((widget.arguments?.personCode != null)) {
      return Padding(
        padding: const EdgeInsets.only(top: 45.0),
        child: Card(
          elevation: 20,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: CircularProfileAvatar(
            '',
            child: (model.personImage != null)
                ? CustomCachedNetworkImageWidget(
                    url: '${model.publicPath}/${model.personImage!}',
                    fitSize: BoxFit.fitHeight,
                  )
                : SizedBox(),
            borderColor: AppColorData.appBarTextColor,
            borderWidth: 1,
            elevation: 20,
            radius: 50,
          ),
        ),
      );
    } else if (model.personImageForUserPersons != null &&
        model.personImageForUserPersons!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 45.0),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * .13,
          width: MediaQuery.sizeOf(context).width * 1,
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 1, //model.userPersonsNotifier.value.length,
                      itemBuilder: (context, index) {
                        return Card(
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            child: CircularProfileAvatar(
                              '',
                              child: CustomCachedNetworkImageWidget(
                                url:
                                    '${model.publicPath}/${model.userPersonsNotifier.value[index].jvtFile?.name ?? model.profileUrl}',
                                fitSize: BoxFit.fitHeight,
                              ),
                            ));
                      }),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  showGrid(
    BuildContext context,
    PhotoGridViewModel model,
    List<ImagesViewModel?> photosList,
  ) {
    Future<void> scrollToIndex() async {
      if (!model.isScrolling) {
        double offset = await model.scrollOffsetManager.getScrollOffset(
                widget.arguments!.folderCode ??
                    widget.arguments!.albumCode ??
                    widget.arguments!.eventCode ??
                    '') ??
            0;
        showLog('scrollToIndex $offset');
        showLog(
            'code --- for scroll ${widget.arguments!.folderCode ?? widget.arguments!.albumCode ?? ""}');
        (widget.arguments!.folderCode != null)
            ? model.scrollController.animateTo(
                duration: Duration(seconds: 1),
                curve: Curves.easeIn,
                offset,
              )
            : model.scrollController.animateTo(
                duration: Duration(seconds: 1),
                curve: Curves.easeIn,
                offset,
              );
      } else {
        showLog('scrolling is true');
      }
    }

    Future<void> handleRefresh(BuildContext context) async {
      setState(() {});
      if (widget.arguments?.folderCode != null) {
        showLog(
            'LiquidPullToRefresh handleRefresh folderCode --> ${widget.arguments?.folderCode} \n refresh length ${model.localPhotosList.value.length}');
        model.localPhotosList.value.clear();
        await model.getInitialData(
          widget.arguments!.albumCode,
          storagePath: widget.arguments!.storagePath,
          folderCode: widget.arguments!.folderCode,
          status: widget.arguments!.status,
          personCode: widget.arguments!.personCode,
          realPersons: widget.arguments!.realPersonCode,
          eventCode: widget.arguments!.eventCode,
          isWithoutFace: widget.arguments!.isWithoutFace,
          photoSelectionsData: widget.arguments?.photoSelections,
        );
      } else if (widget.arguments!.appBarTitle == 'My Photos') {
        model.userPersonsNotifier.value.clear();
        showLog(
            ' model.localPhotosList.value ${model.localPhotosList.value.length}');
        model.localPhotosList.value.clear();
        model.userPersonsCode.value.clear();
        showLog(
            'LiquidPullToRefresh  My Photos --> ${widget.arguments?.appBarTitle} '
            '\n Ai data ${widget.arguments!.realPersonCode}');

        final mediaRouteViewModel =
            Provider.of<MediaRouteViewModel>(context, listen: false);
        if (widget.arguments!.isFromUnAuth != false) {
          await mediaRouteViewModel.getUnAuthUserMyPhotosImagesFromApi(
              uuCode: widget.arguments!.uUCode!,
              eventCode: widget.arguments!.eventCode!);
        }
        await mediaRouteViewModel.getPersonCode(
          widget.arguments!.eventCode,
          isLastUpdatedNull: true,
        );

        await model.getInitialData(
          widget.arguments!.albumCode,
          storagePath: widget.arguments!.storagePath,
          folderCode: widget.arguments!.folderCode,
          status: widget.arguments!.status,
          personCode: widget.arguments!.personCode,
          realPersons: mediaRouteViewModel.realPerson,
          eventCode: widget.arguments!.eventCode,
          isWithoutFace: widget.arguments!.isWithoutFace,
          photoSelectionsData: widget.arguments?.photoSelections,
        );
      }
    }

    return (widget.arguments?.isIos != true)
        ? Scrollbar(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: CustomMaterialIndicator(
                onRefresh: () async {
                  model.loading = true;
                  showLog('CustomMaterialIndicator');
                  await handleRefresh(context);
                  model.loading = false;
                }, // Your refresh logic
                backgroundColor: Colors.white,

                indicatorBuilder: (context, controller) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: CircularProgressIndicator(
                      color: AppColorData.circularProgress,
                      value: controller.state.isLoading
                          ? null
                          : math.min(controller.value, 1.0),
                    ),
                  );
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .00,
                    ),
                    (photosList.length > 0 &&
                            widget.arguments?.isFromUnAuth == false)
                        ? showCircleAvatar(context, model)
                        : SizedBox.shrink(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .01,
                    ),
                    (widget.arguments?.doubtImages == true)
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CommonCard(
                              shape: BorderRadius.circular(20),
                              child: ListTile(
                                  leading: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          'assets/images/user1.gif',
                                          fit: BoxFit.cover,
                                          height: 100,
                                          width: 25,
                                        )),
                                  ),
                                  title: CommonText(
                                    isCard: true,
                                    isHighlightedCard: true,
                                    text: S.of(context).ThisMayBeYou,
                                  ),
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DoubtImagesRoute(
                                                  eventCode: widget
                                                      .arguments!.eventCode!,
                                                )));
                                  }),
                            ),
                          )
                        : SizedBox(),
                    (model.viewDownloadButton &&
                            widget.arguments!.appBarTitle == "My Photos")
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              (photosList.length > 0)
                                  ? Obx(() => CommonButton(
                                        showIcon: true,
                                        icon: model.isLoading.value
                                            ? Icons.downloading
                                            : Icons.download,
                                        buttonText: model.isLoading.value
                                            ? "Downloading Please Wait"
                                            : S.of(context).downloadMyPhotos,
                                        onPressCall: () async {
                                          showLog(
                                              'handleFileDownload ${model.isLoading.value}');
                                          if (model.isLoading.value == false) {
                                            model.isLoading.value = true;

                                            for (int i = 0;
                                                i <
                                                    model.photosList.value!
                                                        .length;
                                                i++) {
                                              await handleFileDownload(
                                                context: context,
                                                albumCode:
                                                    widget.arguments?.albumCode,
                                                eventCode:
                                                    widget.arguments?.eventCode,
                                                url: model
                                                    .photosList.value![i]!.url!,
                                                orderCode: model.photosList
                                                    .value![i]!.orderCode,
                                                originalName: model.photosList
                                                    .value![i]!.originalName,
                                                extension: '',
                                              );
                                              await model.notificationUtils
                                                  .showProgressNotification(
                                                      1,
                                                      i + 1 ==
                                                              model.photosList
                                                                  .value!.length
                                                          ? "Downloaded"
                                                          : "Downloading",
                                                      "${i + 1}/${model.photosList.value?.length}",
                                                      i,
                                                      model.photosList.value!
                                                          .length,
                                                      true,
                                                      widget.arguments
                                                              ?.eventCode ??
                                                          "");
                                            }

                                            model.isLoading.value = false;
                                          } else {
                                            showLog('Already in process');
                                          }
                                        },
                                      ))
                                  : SizedBox(),
                            ],
                          )
                        : SizedBox.shrink(),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * .01,
                    // ),
                    Stack(
                      children: [
                        (photosList.length > 0)
                            ? MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * .9,
                                    child: MasonryGridView.builder(
                                      controller: model.scrollController,
                                      gridDelegate:
                                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                      ),
                                      addRepaintBoundaries: false,
                                      // key:   PageStorageKey<String>('savePositionKey'),
                                      addAutomaticKeepAlives: false,
                                      //controller: model.scrollController,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      //  crossAxisCount: ScreenUtil.isPortrait(context) ? 2 : 2,
                                      //  shrinkWrap: true,
                                      padding:
                                          EdgeInsets.fromLTRB(0, 40, 0, 170),
                                      //  physics: BouncingScrollPhysics(),
                                      itemCount: photosList.length,
                                      itemBuilder: (context, index) {
                                        scrollToIndex();
                                        // Animate each grid item
                                        Animation<double> animation;
                                        if ((!model.isScrolling &&
                                            model.selectedIndices.isEmpty)) {
                                          showLog(
                                              'model.isScrolling ${model.selectedIndices.isEmpty}');
                                          animation =
                                              Tween<double>(begin: 0, end: 1)
                                                  .animate(
                                            CurvedAnimation(
                                              parent: _animationController,
                                              curve: Interval(
                                                (index / photosList.length)
                                                    .clamp(0.0, 1.0),
                                                1.0,
                                                curve: Curves.easeInOut,
                                              ),
                                            ),
                                          );
                                        } else {
                                          showLog('model.isScrolling else');

                                          animation =
                                              AlwaysStoppedAnimation<double>(
                                                  1.0);
                                        }
                                        return AnimatedBuilder(
                                          animation: animation,
                                          builder: (context, child) {
                                            return Opacity(
                                              opacity: animation.value,
                                              child: Transform.scale(
                                                scale: animation.value,
                                                child: child,
                                              ),
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                widget.arguments!.borderRadius),
                                            child: InkWell(
                                              onLongPress: () {
                                                showLog(
                                                    'onLongPress $index ${widget.arguments!.borderRadius}');
                                                (widget.arguments!.folderCode !=
                                                            null &&
                                                        !widget.arguments!
                                                            .photoSelectionsSubmitStatus)
                                                    ? model
                                                        .toggleSelection(index)
                                                    : null;
                                              },
                                              onTap: () async {
                                                showLog(
                                                    'model.isSelectionMode ${model.isSelectionMode}');
                                                if (model.selectedIndices
                                                        .isNotEmpty &&
                                                    model.isSelectionMode &&
                                                    widget.arguments!
                                                            .folderCode !=
                                                        null) {
                                                  model.toggleSelection(index);
                                                } else {
                                                  model.isSelectionMode = false;
                                                }
                                                if (!model.isSelectionMode) {
                                                  if (widget.arguments
                                                          ?.folderCode ==
                                                      null) {
                                                    await model
                                                        .scrollOffsetManager
                                                        .updateScrollOffset(
                                                            widget.arguments!
                                                                    .folderCode ??
                                                                widget
                                                                    .arguments!
                                                                    .albumCode ??
                                                                widget
                                                                    .arguments!
                                                                    .eventCode ??
                                                                '',
                                                            model
                                                                .scrollController
                                                                .offset);
                                                    await model
                                                        .scrollIndexManager
                                                        .updateScrollIndex(
                                                            widget.arguments!
                                                                    .folderCode ??
                                                                widget
                                                                    .arguments!
                                                                    .albumCode ??
                                                                widget
                                                                    .arguments!
                                                                    .eventCode ??
                                                                '',
                                                            index);
                                                    showLog(
                                                        'widget.arguments?.eventCode ${widget.arguments?.eventCode}');
                                                    Navigator.pushNamed(
                                                        context, RoutePaths.CustomPhotoView,
                                                        arguments: CustomPhotoViewArgument(
                                                            preIndex: index,
                                                            title: widget
                                                                .arguments
                                                                ?.appBarTitle,
                                                            albumCode: widget
                                                                .arguments
                                                                ?.albumCode,
                                                            eventCode: widget
                                                                .arguments
                                                                ?.eventCode,
                                                            data: photosList,
                                                            publicStoragePath: widget
                                                                .arguments
                                                                ?.storagePath
                                                                ?.public,
                                                            privateStoragePath:
                                                                widget
                                                                    .arguments
                                                                    ?.storagePath
                                                                    ?.private,
                                                            documentPath: widget
                                                                .arguments
                                                                ?.storagePath
                                                                ?.DocumentPath,
                                                            personCode: widget
                                                                .arguments
                                                                ?.personCode));
                                                  } else {
                                                    showLog(
                                                        'photos length ==> ${model.localPhotosList.value.length} ');

                                                    //await prefs.setDouble('scroll_offset', model.scrollController.offset);
                                                    await model
                                                        .scrollOffsetManager
                                                        .updateScrollOffset(
                                                            widget.arguments!
                                                                .folderCode!,
                                                            model
                                                                .scrollController
                                                                .offset);
                                                    await model
                                                        .scrollIndexManager
                                                        .updateScrollIndex(
                                                            widget.arguments!
                                                                .folderCode!,
                                                            index);

                                                    Navigator.pop(
                                                        context, index);
                                                  }
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      if (model.selectedIndices
                                                          .contains(index))
                                                        Snappable(
                                                          animation:
                                                              animationController,
                                                          outerPadding:
                                                              const EdgeInsets
                                                                  .all(40),
                                                          style:
                                                              const SnappableStyle(
                                                            particleSize:
                                                                SnappableParticleSize
                                                                    .absoluteDp(
                                                              width: 1,
                                                              height: 1,
                                                            ),
                                                          ),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: model
                                                                      .selectedIndices
                                                                      .contains(
                                                                          index)
                                                                  ? Colors.green
                                                                      .withOpacity(
                                                                          0.5) // Highlight selected
                                                                  : Colors
                                                                      .transparent,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              border:
                                                                  Border.all(
                                                                color: (model
                                                                            .selectedIndices
                                                                            .contains(
                                                                                index) &&
                                                                        !animationController
                                                                            .isAnimating)
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .transparent,
                                                                width: 2,
                                                              ),
                                                            ),
                                                            child:
                                                                CustomCachedNetworkImageWidget(
                                                              url: photosList[
                                                                      index]!
                                                                  .url!,
                                                            ),
                                                          ),
                                                        )
                                                      else
                                                        Hero(
                                                          tag: photosList[
                                                                      index]!
                                                                  .originalName ??
                                                              "",
                                                          child:
                                                              CustomCachedNetworkImageWidget(
                                                            url: photosList[
                                                                    index]!
                                                                .url!,
                                                          ),
                                                        ),
                                                      model.selectedIndices
                                                              .contains(index)
                                                          ? Positioned(
                                                              left: 10,
                                                              top: 10,
                                                              child: Snappable(
                                                                animation:
                                                                    animationController,
                                                                outerPadding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        40),
                                                                style:
                                                                    const SnappableStyle(
                                                                  particleSize:
                                                                      SnappableParticleSize
                                                                          .absoluteDp(
                                                                    width: 1,
                                                                    height: 1,
                                                                  ),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      color: Colors
                                                                          .green),
                                                                  child: Icon(
                                                                    Icons.check,
                                                                    color: Colors
                                                                        .white70,
                                                                  ),
                                                                ),
                                                              ))
                                                          : SizedBox()
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : ListView(
                                shrinkWrap: true,
                                children: [
                                  (model.personImageForUserPersons != null &&
                                          model.personImageForUserPersons!
                                              .isEmpty)
                                      ? SizedBox(
                                          height: 0,
                                        )
                                      : SizedBox.shrink(),
                                  /* SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: SvgPicture.string(
                                        noNotificationIllustration,
                                        fit: BoxFit.scaleDown,
                                        colorFilter: ColorFilter.mode(
                                            AppColorData.appBarTextColor
                                                .withOpacity(.4),
                                            BlendMode.srcATop),
                                      ),
                                    ),
                                  ),*/
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                  ),
                                  ErrorInfo(
                                    title: (widget.arguments!
                                                    .isProfileAvailable ==
                                                false &&
                                            widget.arguments!.isFromUnAuth ==
                                                true)
                                        ? ""
                                        : S.of(context).no_matches_found_yet,
                                    description: (widget.arguments!
                                                    .isProfileAvailable ==
                                                false &&
                                            widget.arguments!.isFromUnAuth ==
                                                true)
                                        ? "Please upload a selfie to get your photos"
                                        : S
                                            .of(context)
                                            .itLooksLikeYouDonHaveAnyMatches,
                                    // button: you can pass your custom button,
                                    btnText: (widget.arguments!
                                                    .isProfileAvailable ==
                                                false &&
                                            widget.arguments!.isFromUnAuth ==
                                                true)
                                        ? "Upload Selfie"
                                        : S.of(context).checkAgain,
                                    press: (widget.arguments!
                                                    .isProfileAvailable ==
                                                false &&
                                            widget.arguments!.isFromUnAuth ==
                                                true)
                                        ? () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    UnAuthUserProfileView(
                                                  eventCode: widget
                                                      .arguments!.eventCode!,
                                                  publicStoragePath: publicPath,
                                                  uuCode:
                                                      widget.arguments!.uUCode!,
                                                  Profile: "",
                                                ),
                                              ),
                                            );
                                          }
                                        : () async {
                                            model.loading = true;
                                            showLog('CustomMaterialIndicator');
                                            await handleRefresh(context);
                                            model.loading = false;
                                          },
                                  ),
                                ],
                              ),
                        (model.selectedIndices.isNotEmpty &&
                                model.isSelectionMode &&
                                widget.arguments!.folderCode != null)
                            ? Positioned(
                                top: 20,
                                left: 20,
                                right: 20,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${model.selectedIndices.length} ${S.of(context).selected}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      IconButton(
                                        key: GlobalKey(),
                                        icon: Icon(Icons.close,
                                            color: Colors.white),
                                        onPressed: () async {
                                          model.clearSelection();

                                          showLog(
                                              'message select_all ${model.selectedIndices.length} ');
                                        }, // Clear selection on close
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                        (model.selectedIndices.isNotEmpty &&
                                model.isSelectionMode &&
                                widget.arguments!.folderCode != null)
                            ? Positioned(
                                bottom: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? 20
                                    : 60,
                                left: 20,
                                right: 20,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: (widget.arguments?.status ==
                                                    2)
                                                ? AppColorData
                                                    .selectionStatusCardUndecidedText
                                                : AppColorData
                                                    .selectionStatusCardRejectedText,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(width: .7)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: IconButton(
                                            splashColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            icon: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  widget.arguments?.status == 2
                                                      ? Icons
                                                          .question_mark_outlined
                                                      : Icons.close,
                                                  color: (widget.arguments
                                                              ?.status ==
                                                          2)
                                                      ? Colors.black
                                                      : Colors.white,
                                                ),
                                                SizedBox(width: 8),
                                                CommonText(
                                                  text: (widget.arguments
                                                              ?.status ==
                                                          2)
                                                      ? S.of(context).undecided
                                                      : (model.selectedIndices
                                                                  .length >
                                                              1)
                                                          ? S
                                                              .of(context)
                                                              .reject_all
                                                          : S
                                                              .of(context)
                                                              .reject_photo,
                                                  style: TextStyle(
                                                      color: widget.arguments
                                                                  ?.status ==
                                                              2
                                                          ? Colors.black
                                                          : Colors.white),
                                                ),
                                              ],
                                            ),
                                            onPressed: () async {
                                              await animationController.forward(
                                                  from: 0);

                                              model.updateUI();
                                              model.clearSelection();
                                              for (int i = 0;
                                                  i <
                                                      model
                                                          .multiplePhotoSelections
                                                          .length;
                                                  i++) {
                                                await model
                                                    .photoSelectionImageController
                                                    .updatePhotoStatus(
                                                  context: context,
                                                  photoSelectionImage: model
                                                      .multiplePhotoSelections[
                                                          i]
                                                      .photoSelectionImage,
                                                  status:
                                                      widget.arguments?.status,
                                                  direction: 'left',
                                                  isDemoEvent: widget
                                                      .arguments?.isDemoEvent,
                                                );
                                                showLog(
                                                    'Icons.check ${model.multiplePhotoSelections[i].file?.name}');
                                              }
                                              await model
                                                  .photoSelectionImageController
                                                  .getSyncWithServer();
                                            }, // Clear selection on close
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: (widget.arguments?.status ==
                                                    1)
                                                ? AppColorData
                                                    .selectionStatusCardUndecidedText
                                                : AppColorData
                                                    .selectionStatusCardSelectedText,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(width: .7)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: IconButton(
                                              splashColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              icon: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    widget.arguments?.status ==
                                                            1
                                                        ? Icons
                                                            .question_mark_outlined
                                                        : Icons.check,
                                                    color: (widget.arguments
                                                                ?.status ==
                                                            1)
                                                        ? Colors.black
                                                        : Colors.white,
                                                  ),
                                                  SizedBox(width: 4),
                                                  CommonText(
                                                    text: (widget.arguments
                                                                ?.status ==
                                                            1)
                                                        ? S
                                                            .of(context)
                                                            .undecided
                                                        : (model.selectedIndices
                                                                    .length >
                                                                1)
                                                            ? S
                                                                .of(context)
                                                                .select_all
                                                            : S
                                                                .of(context)
                                                                .select,
                                                    style: TextStyle(
                                                        color: widget.arguments
                                                                    ?.status ==
                                                                1
                                                            ? Colors.black
                                                            : Colors.green
                                                                .shade900),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () async {
                                                await animationController
                                                    .forward(from: 0);

                                                model.updateUI();
                                                model.clearSelection();
                                                for (int i = 0;
                                                    i <
                                                        model
                                                            .multiplePhotoSelections
                                                            .length;
                                                    i++) {
                                                  await model
                                                      .photoSelectionImageController
                                                      .updatePhotoStatus(
                                                    context: context,
                                                    photoSelectionImage: model
                                                        .multiplePhotoSelections[
                                                            i]
                                                        .photoSelectionImage,
                                                    status: widget
                                                        .arguments?.status,
                                                    direction: 'right',
                                                    isDemoEvent: widget
                                                        .arguments?.isDemoEvent,
                                                  );
                                                  showLog(
                                                      'Icons.check ${model.multiplePhotoSelections[i].file?.name}');
                                                }
                                                await model
                                                    .photoSelectionImageController
                                                    .getSyncWithServer();
                                                // update
                                              } // Clear selection on close
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : SafeArea(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: AppColorData.appBarGradientBegin,
                      end: AppColorData.appBarGradientEnd,
                      colors: AppColorData.appBarBackgroundColor)),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: ShowCaseWidget(
                  onStart: (index, key) {
                    showLog('onStart: $index, $key');
                  },
                  onComplete: (index, key) {
                    showLog('onComplete: $index, $key');
                    if (index == 4) {
                      SystemChrome.setSystemUIOverlayStyle(
                        SystemUiOverlayStyle.light.copyWith(
                          statusBarIconBrightness: Brightness.dark,
                          statusBarColor: Colors.white,
                        ),
                      );
                    }
                  },
                  blurValue: 1,
                  builder: (context) => CustomWidget(
                    images: photosList,
                    mp3: model.musicUrl,
                    publicPath: widget.arguments?.storagePath!.public,
                    privatePath: widget.arguments?.storagePath?.private,
                  ),
                  autoPlayDelay: const Duration(seconds: 3),
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
    return appBarTitle;
  }
}

class PhotoGridArguments {
  String? albumCode;
  String? appBarTitle;
  String? folderCode;
  String? personCode;
  List<String>? realPersonCode;
  String? eventCode;
  String? uUCode;
  int? status;
  bool isWithoutFace;
  bool? isDemoEvent;
  bool isIos;
  bool doubtImages;
  bool isFromAlbum;
  double borderRadius;
  DownloadPath? storagePath;
  final Function callbackPhotoSelection;
  List<PhotoSelectionImagesModel>? photoSelections;
  bool photoSelectionsSubmitStatus;
  bool isFromUnAuth;
  bool isProfileAvailable;
  MediaRouteViewModel? mediaRouteViewModel;

  PhotoGridArguments({
    this.albumCode,
    this.appBarTitle,
    this.storagePath,
    this.folderCode,
    this.isDemoEvent,
    this.personCode,
    this.realPersonCode,
    this.eventCode,
    this.status,
    this.isWithoutFace = false,
    this.isFromUnAuth = false,
    this.isIos = false,
    this.doubtImages = false,
    this.isFromAlbum = false,
    this.borderRadius = 10.0,
    required this.callbackPhotoSelection,
    this.photoSelections,
    this.photoSelectionsSubmitStatus = false,
    this.uUCode,
    this.isProfileAvailable = false,
    this.mediaRouteViewModel,
  });
}
