import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/pm_job_controller.dart';
import 'package:photomall_flutter/core/Utils/file_util.dart';
import 'package:photomall_flutter/core/Utils/screen_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/driftdb/dao/event_dao.dart' as eventDao;
import 'package:photomall_flutter/media/media_list.dart';
import 'package:photomall_flutter/media/media_view_model.dart';
import 'package:photomall_flutter/media/my_photos_route.dart';
import 'package:photomall_flutter/preference/preference_handler/redirection_preference_handler.dart';
import 'package:photomall_flutter/preference/preference_model/redirection_preference_model.dart';
import 'package:photomall_flutter/preference/redirection_route_constant.dart';
import 'package:photomall_flutter/traits/common_widgets/common_card.dart';
import 'package:photomall_flutter/traits/common_widgets/custom_transition_widget.dart';
import 'package:photomall_flutter/traits/image_processor.dart';
import 'package:photomall_flutter/ui/base/base_widget.dart';
import 'package:photomall_flutter/ui/drawer/side_drawer_model.dart';
import 'package:photomall_flutter/ui/event/photos/custom_photo_view.dart';
import 'package:photomall_flutter/ui/event/photos/photo_grid.dart';
import 'package:photomall_flutter/ui/folders/route/face_grid.dart';
import 'package:photomall_flutter/ui/gallery/gallery_route_view_model.dart';
import 'package:photomall_flutter/ui/login/login_route.dart';
import 'package:photomall_flutter/ui/shared_widgets/common.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../controllers/studio_data_controller.dart';
import '../core/Utils/preference_helper.dart';
import '../core/constants/shared_preference_constants.dart';
import '../core/models/apiModels/transport_model/my_photos_model.dart';
import '../driftdb/app_db.dart';
import '../generated/l10n.dart';
import '../ui/app_side_drawer/side_drawer_constants.dart';
import '../ui/bottom_navigation/bottom_navigation_constants.dart';
import '../ui/event/detail/info/archive_widget.dart';
import '../ui/event/unAuth_user/unAuth_user_form.dart';
import '../ui/shared_widgets/common_button.dart';
import '../ui/shared_widgets/common_text_button.dart';

class MediaWidget extends StatefulWidget {
  final String? eventCode;
  final String? personCode;
  final String? appBarTitle;
  final DownloadPath? storagePath;
  final List<String>? categoryName;
  final bool isFromPrivate;

  MediaWidget({
    Key? key,
    this.eventCode,
    this.personCode,
    this.appBarTitle,
    this.storagePath,
    this.categoryName,
    required this.isFromPrivate,
  }) : super(key: key);

  @override
  State<MediaWidget> createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  BaseWidget<MediaRouteViewModel>? baseWidget;
  bool? isBeforeLogin;
  var selectedFile;

  MediaRouteViewModel mediaRouteViewModel = MediaRouteViewModel();

  eventDao.EventModelDao eventModelDao = eventDao.EventModelDao();
  ImageProcessor imageProcessor = ImageProcessor();

  FileUtil fileUtil = FileUtil();
  late FaceCameraController controller;

  @override
  void initState() {
    showLog("initState media widget isFromPrivate: ${widget.isFromPrivate}");
    isJvt();
    super.initState();
    setState(() {});
    getBeforeLoginStatus();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();

    showLog("disposed folder  widget");
  }

  @override
  Widget build(BuildContext context) {
    baseWidget = BaseWidget<MediaRouteViewModel>(
      model: MediaRouteViewModel(
        apiHandler: Provider.of<ApiHelper>(context, listen: false),
        context: context,
      ),
      onModelReady: (model) async {
        controller = FaceCameraController(
          autoCapture: false,
          imageResolution: ImageResolution.ultraHigh,
          defaultCameraLens: CameraLens.front,
          performanceMode: FaceDetectorMode.accurate,
          onCapture: (File? image) {
            Navigator.pop(context);
            showLog('onModelReady');
            _cropImage(image, model);
          },
        );
        await model.getInitialMediaData(widget.eventCode, widget.personCode,
            storagePath: widget.storagePath);
      },
      builder: (context, model, child) {
        var galleryModel =
            Provider.of<GalleryRouteViewModel>(context, listen: false);
        return model.loading!
            ? CommonCircularProgress()
            : Column(children: [
                ///comment below for future implementation
                /*(model.hideMedia == false)
                    ? faceSelectionCard(model, model.localMedia.value)
                    : SizedBox(),
                (model.hideMedia == false)
                    ? withoutFaceSelectionCard(model)
                    : SizedBox(),*/
                myPhotos(model),
                (widget.categoryName!.isNotEmpty)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Row(
                              children: [
                                Icon(
                                  model.showCategory
                                      ? Icons.category_outlined
                                      : Icons.category_rounded,
                                  color: AppColorData.bgIconColor,
                                ),
                                CommonText(
                                  text: S.of(context).category,
                                  isCard: true,
                                ),
                              ],
                            ),
                            onPressed: () {
                              showLog('onPressed');
                              setState(() {
                                model.showCategory =
                                    model.showCategory ? false : true;

                                galleryModel.showCarousel.value =
                                    !model.showCategory;

                                model.category =
                                    (model.showCategory ? null : '') ?? "";
                              });
                            },
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
                (widget.categoryName!.isNotEmpty && model.showCategory)
                    ? showCategoryFilters(model, context)
                    : SizedBox.shrink(),
                (widget.eventCode != null)
                    ? showMedia(
                        model.downloadPath ?? DownloadPath(public: publicPath),
                        model.localMedia.value,
                        model)
                    : showGalleryMedia(
                        model.downloadPath ?? DownloadPath(public: publicPath),
                        model.localMedia.value,
                        model),
              ]);
      },
    );
    return baseWidget!;
  }

  Widget showCategoryFilters(MediaRouteViewModel model, BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.categoryName?.length,
          itemBuilder: (context, index) {
            final String text = widget.categoryName![index];
            final TextPainter textPainter = TextPainter(
              text: TextSpan(
                text: text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.deepOrange,
                ),
              ),
              maxLines: 1,
              textDirection: TextDirection.ltr,
            )..layout();

            final double textWidth = textPainter.width + 20;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedButton(
                onChanges: (bool) {
                  showLog('onChanges $bool ${model.selectedCategoryIndex} ');
                },
                selectedBackgroundColor: (model.selectedCategoryIndex == index)
                    ? AppColorData.appBarTextColor
                    : AppColorData.backgroundColors.first,
                width: textWidth,
                onPress: () async {
                  model.changeCategory(widget.categoryName![index]);

                  model.changeSelectedCategoryIndex(index);
                  showLog(
                      'selectedCategoryIndex ${model.selectedCategoryIndex}');
                },
                text: widget.categoryName![index],
                selectedTextColor: (model.selectedCategoryIndex == index)
                    ? AppColorData.backgroundColors.first
                    : AppColorData.appBarTextColor,
                transitionType: TransitionType.LEFT_TO_RIGHT,
                isReverse: model.selectedCategoryIndex == index,
                borderRadius: 10,
                borderWidth: 2,
                borderColor: AppColorData.bottomNavIconSelectedColor,
                textStyle: TextStyle(
                    fontSize: 14,
                    color: AppColorData.appBarTextColor,
                    fontWeight: FontWeight.w500),
              ),
            );
          }),
    );
  }

  Future<bool?> downloadComplete1(Stream<String> source) async {
    await for (String value in source) {
      showLog('MediaWidget :: downloadComplete :: STEP 1');
      if (value.endsWith('5')) {
        return true;
      }
    }
    return null;
  }

  showMedia(DownloadPath downloadPath, List<Media> medias,
      MediaRouteViewModel model) {
    showLog('medias medias ${medias.length}');

    if ((medias.isNotEmpty && medias.length != 0)) {
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: MasonryGridView.count(
            itemCount: medias.length,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: ScreenUtil.isPortrait(context) ? 1 : 2,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ZoomTapAnimation(
                beginCurve: Curves.bounceIn,
                endCurve: Curves.bounceInOut,
                begin: 1,
                end: .95,
                child: CustomItemTransition(
                  duration: 1000,
                  delay: 100 * index,
                  child: MediaList(
                    userOwnEvent: model.event!.ownedByUser ?? false,
                    key: UniqueKey(),
                    downloadPath: downloadPath,
                    model: model,
                    eventCode: widget.eventCode,
                    index: index,
                    medias: medias,
                  ),
                ),
              );
            }),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 70),
        child: EmptyView(
          iconData: Icons.perm_media_outlined,
          text: S.of(context).noMediaAvailable,
        ),
      );
    } //noMediaWidget();
  }

  showGalleryMedia(DownloadPath downloadPath, List<Media> medias,
      MediaRouteViewModel model) {
    if ((medias.isNotEmpty && medias.length != 0)) {
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: MasonryGridView.count(
            itemCount: medias.length,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: ScreenUtil.isPortrait(context) ? 1 : 2,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ZoomTapAnimation(
                beginCurve: Curves.bounceIn,
                endCurve: Curves.bounceInOut,
                begin: 1,
                end: .95,
                child: CustomItemTransition(
                  duration: 1000,
                  delay: 100 * index,
                  child: MediaList(
                    key: UniqueKey(),
                    downloadPath: downloadPath,
                    model: model,
                    index: index,
                    medias: medias,
                    eventCode: widget.eventCode,
                    categoryName: widget.categoryName,
                  ),
                ),
              );
            }),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 70),
        child: EmptyView(
          iconData: Icons.perm_media_outlined,
          text: S.of(context).noMediaAvailable,
        ),
      );
    } //noMediaWidget();
  }

  faceSelectionCard(
    MediaRouteViewModel model,
    List<Media> medias,
  ) {
    return (widget.eventCode != null && model.showPersonTile)
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonCard(
                shape: BorderRadius.circular(20),
                child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: /*Icon(
                    Icons.face,
                    color: AppColorData.cardNormalIconColour,
                  ),*/
                              Image.asset(
                            'assets/images/faces.png',
                            fit: BoxFit.cover,
                            height: 100,
                            width: 25,
                          )),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FaceGrid(
                                  eventCode: widget.eventCode!,
                                  type: 2,
                                  medias: medias,
                                )),
                      );
                    },
                    title: CommonText(
                      isCard: true,
                      isHighlightedCard: true,
                      text: S.of(context).viewByFaces,
                    ))),
          )
        : SizedBox();
  }

  withoutFaceSelectionCard(MediaRouteViewModel model) {
    return widget.eventCode != null && model.showWithoutPersonTile == true
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonCard(
                shape: BorderRadius.circular(20),
                child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhotoGrid(
                                  arguments: PhotoGridArguments(
                                      mediaRouteViewModel: model,
                                      eventCode: widget.eventCode,
                                      callbackPhotoSelection: () {},
                                      isWithoutFace: true,
                                      appBarTitle: "Other photos"),
                                )),
                      );
                    },
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: AppColorData.bgIconBackgroundColor,
                                begin: AppColorData.bgIconGradientBegin,
                                end: AppColorData.bgIconGradientEnd,
                                stops: AppColorData.bgIconStops,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: /*Icon(
                        Icons.face_retouching_off_sharp,
                        color: AppColorData.cardNormalIconColour,
                      ),*/
                                  Image.asset(
                                'assets/images/others.jpg',
                                fit: BoxFit.cover,
                                height: 100,
                                width: 55,
                              ))),
                    ),
                    title: CommonText(
                      isCard: true,
                      isHighlightedCard: true,
                      text: S.of(context).others,
                    ))),
          )
        : SizedBox();
  }

  myPhotos(MediaRouteViewModel model) {
    return widget.eventCode != null && model.myPhotosTile == true
        ? myPhotosRoute(model)
        : SizedBox();
  }

  myPhotosRoute(MediaRouteViewModel model) {
    return FutureBuilder<bool>(
        future: isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return myPhotosListTile(model);
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/myPhotos.gif',
                            fit: BoxFit.cover,
                            height: 100,
                            width: 25,
                          )),
                    ),
                    title: CommonText(
                      isCard: true,
                      isHighlightedCard: true,
                      text: S.of(context).myPhotos,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: AppColorData.bgIconColor,
                    ),
                    onTap: () async {
                      Map<String, dynamic> uUCodeMap =
                          await PreferenceHelper.getMapFromPrefs(aiEmbedKey);
                      showLog(
                          "uUCodeMapuUCodeMap $uUCodeMap ${widget.eventCode}");
                      String? uUCode = await PreferenceHelper.getValueForKey(
                          widget.eventCode!, unAuthUserKey);
                      int? aiEmbeddingMethod =
                          await PreferenceHelper.getValueForKey(
                              widget.eventCode!, aiEmbedKey);
                      showLog("aiEmbeddingMethod $aiEmbeddingMethod");
                      (aiEmbeddingMethod != null && aiEmbeddingMethod == 4)
                          ? (uUCode != null && uUCode.isNotEmpty)
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyPhotosRoute(
                                            eventCode: widget.eventCode,
                                            appBarTitle: "My Photos",
                                            personCode: uUCode,
                                            isFromUnAuth: true,
                                          ),
                                      //myPhotosGrid(myPhotos),
                                      maintainState: false))
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UnAuthUserForm(
                                            eventCode: widget.eventCode!,
                                          )))
                          : myPhotosAlertDialog(model);
                      return;
                    }),
              ),
            );
          }
        });
  }

  Future<bool> isJvt() async {
    var profile = await PreferenceHelper.getBool(profileKey);
    showLog('profileSP1 $profile');
    return profile;
  }

  myPhotosListTile(MediaRouteViewModel model) {
    return FutureBuilder<bool>(
        future: isJvt(),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15)),
                child: TapDebouncer(onTap: () async {
                  showLog('MyPhotosRoute pC qw ${widget.personCode}');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyPhotosRoute(
                                eventCode: widget.eventCode,
                                appBarTitle: widget.appBarTitle,
                                personCode: widget.personCode,
                              ),
                          //myPhotosGrid(myPhotos),
                          maintainState: false));
                }, builder: (BuildContext context, TapDebouncerFunc? onTap) {
                  return ListTile(
                      onTap: onTap,
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/myPhotos.gif',
                              fit: BoxFit.cover,
                              height: 100,
                              width: 25,
                            )),
                      ),
                      title: CommonText(
                          isCard: true,
                          isHighlightedCard: true,
                          text: S.of(context).myPhotos),
                      subtitle: CommonText(
                          isHighlightedGreenSubtitle: true,
                          text: S.of(context).clickHereToGetYourPhotos),
                      trailing: IconButton(
                        onPressed: () async {
                          /* MediaProfilePhotoController
                              mediaProfilePicController =
                              MediaProfilePhotoController();
                          mediaProfilePicController
                              .showBottomSheetForProfileImage(context, model,
                                  (ImageSource source,
                                      MediaRouteViewModel model) async {
                            await getImage(source, model);
                          });*/
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Material(
                                        child: SmartFaceCamera(
                                            indicatorShape:
                                                IndicatorShape.square,
                                            showCameraLensControl: false,
                                            showFlashControl: false,
                                            autoDisableCaptureControl: true,
                                            controller: controller,
                                            messageBuilder: (context, face) {
                                              if (face == null) {
                                                return _message(S
                                                    .of(context)
                                                    .placeYourFaceInTheCamera);
                                              }
                                              if (!face.wellPositioned) {
                                                return _message(S
                                                    .of(context)
                                                    .placeYourFaceAtTheCenterOfTheFaceIndicator);
                                              }
                                              return const SizedBox.shrink();
                                            }),
                                      )));
                        },
                        icon: Icon(Icons.camera_enhance_sharp),
                      ));
                }),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15)),
                child: TapDebouncer(onTap: () async {
                  profileAlertDialog(model);
                }, builder: (BuildContext context, TapDebouncerFunc? onTap) {
                  return ListTile(
                      onTap: onTap,
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/myPhotos.gif',
                              fit: BoxFit.cover,
                              height: 100,
                              width: 25,
                            )),
                      ),
                      title: CommonText(
                          isCard: true,
                          isHighlightedCard: true,
                          text: S.of(context).myPhotos),
                      trailing: Icon(
                        Icons.arrow_forward,
                        color: AppColorData.bgIconColor,
                      ),
                      subtitle: CommonText(
                        isHighlightedRedSubtitle: true,
                        text: S.of(context).clickHereToUploadYourSelfie,
                      ));
                }),
              ),
            );
          }
        });
  }

  Widget myPhotosGrid(
    MyPhotos? myPhotos,
    MediaRouteViewModel model,
  ) {
    if (myPhotos != null) {
      return PhotoGrid(
        arguments: PhotoGridArguments(
          mediaRouteViewModel: model,
          eventCode: widget.eventCode,
          personCode: myPhotos.personCode,
          appBarTitle: S.of(context).myPhotos,
          callbackPhotoSelection: () {},
          isWithoutFace: false,
        ),
      );
    } else {
      return PhotoGrid(
        arguments: PhotoGridArguments(
          mediaRouteViewModel: model,
          appBarTitle: S.of(context).myPhotos,
          callbackPhotoSelection: () {},
        ),
      );
    }
  }

  Widget _message(String msg) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 55),
        child: Text(msg,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w400,
            )),
      );

  Future profileAlertDialog(MediaRouteViewModel model) {
    return /*showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CommonAlertDialog(
            title: 'Upload Profile Photo to Continue',
            content: 'You have to Upload Your Profile Photo',
            actions: [
              CommonButton(
                isOutLinedButton: true,
                buttonText: S.of(context).cancel,
                onPressCall: () {
                  Navigator.pop(context);

                  // _setRefresh(context,model);
                },
              ),
              CommonButton(
                buttonText: 'Upload',
                onPressCall: () async {
                  MediaProfilePhotoController mediaProfilePicController =
                      MediaProfilePhotoController();
                  mediaProfilePicController.showBottomSheetForProfileImage(
                    context,
                    model,
                    (ImageSource source, MediaRouteViewModel model) async {
                      await getImage(source, model);

                      Navigator.pop(context);

                      return;
                    },
                  );

                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginRoute(true)));
                },
              ),
            ],
          );
        });*/
        showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isDismissible: false,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  UniqueText(
                    text: S.of(context).uploadProfilePhoto,
                  ),
                ],
              ),
              SizedBox(height: 10),
              CommonText(
                style: TextStyle(
                  color: AppColorData.cardHighlightedTextColour,
                  fontSize: 18,
                ),
                text: S
                    .of(context)
                    .youHaveToUploadYourProfilePhotoToGetYourPhotos,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CommonTextButton(
                    buttonText: S.of(context).cancel,
                    onPressCall: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 25),
                  ElevatedButton(
                    child: CommonText(
                      text: S.of(context).upload,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: AppColorData.buttonBackgroundColors.last,
                      foregroundColor: AppColorData.buttonTextColors,
                    ),
                    onPressed: () {
                      Navigator.pop(context);

                      /* MediaProfilePhotoController mediaProfilePicController =
                      MediaProfilePhotoController();
                      mediaProfilePicController.showBottomSheetForProfileImage(
                        context,
                        model,
                            (ImageSource source, MediaRouteViewModel model) async {
                          await getImage(source, model);

                          Navigator.pop(context);
                        },
                      );*/

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Material(
                                    child: SmartFaceCamera(
                                        indicatorShape: IndicatorShape.square,
                                        autoDisableCaptureControl: true,
                                        controller: controller,
                                        showCameraLensControl: false,
                                        showFlashControl: false,
                                        messageBuilder: (context, face) {
                                          if (face == null) {
                                            return _message(S
                                                .of(context)
                                                .placeYourFaceInTheCamera);
                                          }
                                          if (!face.wellPositioned) {
                                            return _message(S
                                                .of(context)
                                                .placeYourFaceAtTheCenterOfTheFaceIndicator);
                                          }
                                          return const SizedBox.shrink();
                                        }),
                                  )));
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _setRefresh(BuildContext context, MediaRouteViewModel model) {
    if (model.loading!) {
      return CommonCircularProgress();
    } else {
      return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MyPhotosRoute(
                  eventCode: widget.eventCode,
                  appBarTitle: widget.appBarTitle,
                  personCode: widget.personCode,
                )),
      );
    }
  }

  _cropImage(image, MediaRouteViewModel model) async {
    CroppedFile? croppedFile;

    if (image != null) {
      try {
        croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          compressQuality: 100,
          maxHeight: 512,
          maxWidth: 512,
          /*aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],*/
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: S.of(context).setProfilePicture,
                //   toolbarColor: AppColor.get(context, ColorKeys.darkThemeColor),
                // toolbarWidgetColor:
                //     AppColor.get(context, ColorKeys.lightThemeColor),
                initAspectRatio: CropAspectRatioPreset.ratio16x9,
                aspectRatioPresets: [
                  CropAspectRatioPreset.square,
                ],
                lockAspectRatio: true),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
              ],
            )
          ],
        );
      } catch (e) {}
      var base64Image;
      try {
        base64Image = base64Encode(await croppedFile!.readAsBytes());
      } catch (e) {}

      if (croppedFile != null) {
        setState(() {
          selectedFile = File(croppedFile!.path);
        });
        model.changeProfileImage(base64Image, File(croppedFile.path));
      }
    }

    print('start');
    await _setRefresh(context, model);

    print('stop');
  }

  Future myPhotosAlertDialog(MediaRouteViewModel model) {
    return /*showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CommonAlertDialog(
            title: S.of(context).log_in_to_continue,
            content: S.of(context).You_have_to_login_to_use_thisAiFeature,
            actions: [
              CommonButton(
                isOutLinedButton: true,
                buttonText: S.of(context).cancel,
                onPressCall: () {
                  Navigator.pop(context);
                },
              ),
              CommonButton(
                buttonText: S.of(context).login,
                onPressCall: () async {
                  if (isBeforeLogin == true) {
                    ReDirectionPreference reDirectionPreference =
                        ReDirectionPreference();
                    await reDirectionPreference.setReDirectionDetails(
                        RedirectionModel(
                            redirection: Redirection(
                                route:
                                    RedirectionRouteConstant.EventDetailsRoute,
                                arguments: [
                          '${widget.eventCode}',
                          'myPhotos'
                        ])));

                    SideDrawerModel drawerModel =
                        Provider.of<SideDrawerModel>(context, listen: false);

                   */ /* drawerModel.setPendingNavigation(SideDrawerModel()
                      ..drawerChild = EventsListRoute(
                          arguments:
                              EventsListArguments(isArchivedEven: false)));*/ /*
                    drawerModel.setDrawerChild(
                        LoginRoute(false),
                        S.of(context).login,
                        (model.isPartyApp == true &&
                                    model.isGalleryAvailable == false ||
                                isPhotomallApp)
                            ? 1
                            : (model.isPartyApp &&
                                    model.isGalleryAvailable == true)
                                ? 2
                                : SideDrawerConstants.GuestLogin,
                        (model.isPartyApp == true &&
                                    model.isGalleryAvailable == false ||
                                isPhotomallApp)
                            ? 1
                            : (model.isPartyApp &&
                                    model.isGalleryAvailable == true)
                                ? 2
                                : BottomNavigationConstants.GuestLogin);
                    await PreferenceHelper.setBool(isFromEvents, true);

                    showLog('Login route returned.... ');

                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                  return;

                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginRoute(true)));
                },
              ),
            ],
          );
        });*/
        showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isDismissible: false,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  UniqueText(
                    text: S.of(context).log_in_to_continue,
                  ),
                ],
              ),
              SizedBox(height: 10),
              CommonText(
                style: TextStyle(
                  color: AppColorData.cardHighlightedTextColour,
                  fontSize: 18,
                ),
                text: S.of(context).You_have_to_login_to_use_thisAiFeature,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CommonTextButton(
                    buttonText: S.of(context).cancel,
                    onPressCall: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 25),
                  ElevatedButton(
                    child: CommonText(
                      text: S.of(context).login,
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: AppColorData.buttonBackgroundColors.last,
                      foregroundColor: AppColorData.buttonTextColors,
                    ),
                    onPressed: () async {
                      if (isBeforeLogin!) {
                        ReDirectionPreference reDirectionPreference =
                            ReDirectionPreference();
                        await reDirectionPreference.setReDirectionDetails(
                          redirectionConstantFrom: "isBeforeLogin",
                          RedirectionModel(
                            redirection: Redirection(
                              route: RedirectionRouteConstant.EventDetailsRoute,
                              arguments: ['${widget.eventCode}', 'myPhotos'],
                            ),
                          ),
                        );

                        SideDrawerModel drawerModel =
                            Provider.of<SideDrawerModel>(context,
                                listen: false);

                        drawerModel.setDrawerChild(
                          LoginRoute(false),
                          S.of(context).login,
                          (model.isPartyApp && !model.isGalleryAvailable ||
                                  isPhotomallApp)
                              ? 1
                              : (model.isPartyApp && model.isGalleryAvailable)
                                  ? 2
                                  : SideDrawerConstants.GuestLogin,
                          (model.isPartyApp && !model.isGalleryAvailable ||
                                  isPhotomallApp)
                              ? 1
                              : (model.isPartyApp && model.isGalleryAvailable)
                                  ? 2
                                  : BottomNavigationConstants.GuestLogin,
                        );
                        await PreferenceHelper.setBool(isFromEvents, true);

                        showLog('Login route returned....');

                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool?> getBeforeLoginStatus() async {
    var prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(isUserLoggedInPreferenceKey) ?? false;
    showLog('the login value where $isLoggedIn');
    isBeforeLogin = !isLoggedIn;
    return null; // opposite value
  }
}

Future<bool> isLoggedIn() async {
  var pref = await SharedPreferences.getInstance();
  return pref.getBool('$isUserLoggedInPreferenceKey') ?? false;
}

Future<bool> isJvt() async {
  var profile = await PreferenceHelper.getBool(profileKey);
  showLog('profileSP$profile');
  return profile;
}

class UserOfStream {
  UserOfStream(app) {
    app.onExit.listen((String message) => showLog(message));
  }
}
