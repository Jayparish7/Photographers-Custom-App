import 'dart:convert';
import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/pm_job_controller.dart';
import 'package:photomall_flutter/core/Utils/file_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/driftdb/dao/event_dao.dart' as eventDao;
import 'package:photomall_flutter/media/media_view_model.dart';
import 'package:photomall_flutter/traits/image_processor.dart';
import 'package:photomall_flutter/ui/base/base_widget.dart';
import 'package:photomall_flutter/ui/event/photos/photo_grid.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_appbar.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/photomall_progress.dart';
import 'package:provider/provider.dart';

import '../core/Utils/preference_helper.dart';
import '../core/Utils/toast_util.dart';
import '../core/constants/shared_preference_constants.dart';
import '../core/models/apiModels/myPhotos_images_response_model.dart';
import '../generated/l10n.dart';
import '../ui/event/photos/photo_grid_view_model.dart';
import '../ui/event/unAuth_user/un_auth_user_profile_view.dart';
import '../ui/shared_widgets/common_rounded_image_widget.dart';
import '../ui/shared_widgets/common_text.dart';

class MyPhotosRoute extends StatefulWidget {
  final String? eventCode;
  final String? personCode;
  final String? appBarTitle;
  final DownloadPath? storagePath;
  final bool? isFromUnAuth;

  const MyPhotosRoute({Key? key,
    this.eventCode,
    this.personCode,
    this.appBarTitle,
    this.storagePath,
    this.isFromUnAuth})
      : super(key: key);

  @override
  State<MyPhotosRoute> createState() => _MyPhotosRouteState();
}

class _MyPhotosRouteState extends State<MyPhotosRoute> {
  BaseWidget<MediaRouteViewModel>? baseWidget;
  List personsList = [];

  // MyPhotos? myPhotos;
  //bool? isBeforeLogin;

  @override
  void initState() {
    showLog('the event code MediaWidget1111:: ${widget.eventCode}');
    super.initState();
    //getBeforeLoginStatus();
  }

  eventDao.EventModelDao eventModelDao = eventDao.EventModelDao();
  ImageProcessor imageProcessor = ImageProcessor();

  FileUtil fileUtil = FileUtil();
  String? cropFile;

  @override
  Widget build(BuildContext context) {
    baseWidget = BaseWidget<MediaRouteViewModel>(
        model: MediaRouteViewModel(
          apiHandler: Provider.of<ApiHelper>(context, listen: false),
          context: context,
        ),
        onModelReady: (model) async {
          if (widget.isFromUnAuth != false) {
            await model.getUnAuthUserMyPhotosImagesFromApi(
                eventCode: widget.eventCode ?? "",
                uuCode: widget.personCode ?? "");
          }
          await model.getPersonCode(widget.eventCode);

          //model.getInitialMediaData(widget.eventCode, widget.personCode);
        },
        builder: (context, model, child) {
          showLog('personCode12;${model.realPerson}');

          if (model.loading!) {
            return CommonCircularProgress();
          } else {
            {
              showLog(
                  'model.realPerson ${model.realPerson} ${widget.personCode}');
              //personsList.add(model.myPhotos?.personCode);

              return  Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: AppColorData.backgroundGradientBegin,
                        end: AppColorData.backgroundGradientEnd,
                        colors: AppColorData.backgroundColors)),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: widget.isFromUnAuth == true
                      ? CommonAppBar(title: "My Photos")
                      : null,
                  body: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      child: Column(
                        children: [
                          widget.isFromUnAuth == true
                              ? InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      UnAuthUserProfileView(
                                        eventCode: widget.eventCode!,
                                        publicStoragePath: publicPath,
                                        uuCode: widget.personCode!,
                                        Profile: model.unAuthUserPersons.isNotEmpty
                                        ? "${
                                        model.unAuthUserPersons.first.jvtFileConnector!.jvtFile
                                        !.name ?? ''}"
                                            : "",
                                      ),
                                ),
                              );
                            },
                            child: profileWidget(context,
                                publicStoragePath: publicPath,
                                uuCode: widget.personCode!,
                                model: model),
                          )
                              : SizedBox(),
                          Expanded(
                            child: PhotoGrid(
                              arguments: PhotoGridArguments(
                                mediaRouteViewModel: model,
                                  eventCode: widget.eventCode,
                                  appBarTitle: S
                                      .of(context)
                                      .myPhotos,
                                  callbackPhotoSelection: () {},
                                  isWithoutFace: false,
                                  uUCode: widget.personCode,
                                  realPersonCode: model.realPerson,
                                  doubtImages: model.doubtImages,
                                  isFromUnAuth: widget.isFromUnAuth ?? false,
                                  isProfileAvailable:
                                  model.unAuthUserPersons.isNotEmpty),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  /*floatingActionButton: (widget.isFromUnAuth == true)
                      ? FloatingActionButton.extended(
                          backgroundColor:
                              AppColorData.buttonBackgroundColors.last,
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FaceCameraWidget(
                                        model: model,
                                        uuCode: widget.personCode!,
                                      )),4545
                            );
                          },
                          icon: Icon(
                            Icons.person,
                            color: AppColorData.elevatedButtonText,
                          ),
                          label: CommonText(
                            text: 'Add selfie',
                            isButton: true,
                          ),
                        )
                      : null,*/
                ),
              );
            }
          }
        });
    return baseWidget!;
  }

  profileWidget(BuildContext context,
      {required String publicStoragePath,
        required String uuCode,
        required MediaRouteViewModel model}) {
    showLog("unAuthUserPersons ${model}");
    return Container(
      height: 130,
      width: 130,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: _profileImageView(model.unAuthUserPersons.isNotEmpty
                ? "$publicStoragePath${model.unAuthUserPersons.first
                .jvtFileConnector!.jvtFile!.name ?? ''}"
                : ""),
          ),
          Positioned(

            //top: 0,
              bottom: 0,
              right: 45,
              child: InkWell(
                onTap: () async {
                  final mediaRouteViewModel =
                  Provider.of<MediaRouteViewModel>(context, listen: false);
                  (/*model.unAuthUserPersons.isEmpty*/ false)
                  //true
                      ? {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FaceCameraWidget(
                                model: mediaRouteViewModel,
                                uuCode: uuCode,
                                eventCode: widget.eventCode!,
                                croppedFile: (value) {
                                  showLog("callback $value");
                                  cropFile = value;
                                  // });
                                },
                              )),
                    ).then((b) async {
                      showLog("then fbn");
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MyPhotosRoute(
                                eventCode: widget.eventCode,
                                isFromUnAuth: widget.isFromUnAuth,
                                appBarTitle: widget.appBarTitle,
                                personCode: widget.personCode,
                                storagePath: widget.storagePath,
                                // Pass if needed
                              ),
                        ),
                      );
                      if (widget.isFromUnAuth != false) {
                        await model.getUnAuthUserMyPhotosImagesFromApi(
                            eventCode: widget.eventCode ?? "",
                            uuCode: widget.personCode ?? "");
                      }
                      await model.getPersonCode(widget.eventCode);
                    })
                  }
                      : Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          UnAuthUserProfileView(
                            eventCode: widget.eventCode!,
                            publicStoragePath: publicStoragePath,
                            uuCode: uuCode,
                            Profile: model.unAuthUserPersons.isNotEmpty
                                ? "${model.unAuthUserPersons.first
                                .jvtFileConnector!.jvtFile!.name ?? ''}"
                                : "",
                          ),
                    ),
                  );
                },
                child: Opacity(
                  opacity: 0.70,
                  child: Container(
                    width: 45.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: LinearGradient(
                          colors: AppColorData.bgIconBackgroundColor,
                          begin: AppColorData.bgIconGradientBegin,
                          end: AppColorData.bgIconGradientEnd,
                          stops: AppColorData.bgIconStops,
                        )),
                    alignment: Alignment.center,
                    child: Icon(
                      (model.unAuthUserPersons.isNotEmpty)
                          ? Icons.edit
                          : Icons.camera_alt,
                      color: AppColorData.bgIconColor,
                      size: 25,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  _profileImageView(profileUrl) {
    ImageProcessor imageProcessor = ImageProcessor();
    var emptyProfileWidget = Container(
      decoration: BoxDecoration(
        // color: AppColor.get(context, ColorKeys.darkDividerColor)
        //     .withOpacity(0.18),
        //color: lightIconBackgroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: Lottie.asset(
            repeat: false,
            'assets/animations/profile.json',
            fit: BoxFit.fitHeight,
          )),
    );
    if (cropFile != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.file(File(cropFile ?? '')));
    }
    if (profileUrl != '') {
      return ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(profileUrl));
    } else {
      return emptyProfileWidget;
    }
  }
}

Widget message(String msg) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 55),
      child: Text(msg,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
            fontWeight: FontWeight.w400,
          )),
    );

class FaceCameraWidget extends StatefulWidget {
  final MediaRouteViewModel model;
  final String uuCode;
  final String eventCode;
  final Function(String)? croppedFile;

  const FaceCameraWidget({super.key,
    required this.model,
    required this.uuCode,
    required this.eventCode,
    this.croppedFile});

  @override
  State<FaceCameraWidget> createState() => _FaceCameraWidgetState();
}

class _FaceCameraWidgetState extends State<FaceCameraWidget> {
  late FaceCameraController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = FaceCameraController(
      autoCapture: false,
      imageResolution: ImageResolution.ultraHigh,
      defaultCameraLens: CameraLens.front,
      performanceMode: FaceDetectorMode.accurate,
      onCapture: (File? image) async {
        // final ImagePicker _picker = ImagePicker();
        // File? _imageFile;
        // final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        //  showLog("messge ${pickedFile?.path}");
        //Get.back();
        Navigator.pop(context!, true);
        var image1 = File(
            "/data/user/0/in.photomall.app.madurai.ptmlstudio/cache/8ffb1a26-8b29-418c-b377-9cecf1a2679e/227adec6-4481-4927-993e-f39ff03ba39d.jpg");
        await _cropImage(image, widget.model);
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartFaceCamera(
        indicatorShape: IndicatorShape.square,
        showCameraLensControl: false,
        showFlashControl: false,
        autoDisableCaptureControl: false,
        controller: controller,
        messageBuilder: (context, face) {
          if (face == null) {
            return message('Place your face in the camera');
          }
          if (!face.wellPositioned) {
            return message(
                'Place your face at the center of the face indicator.');
          }
          return const SizedBox.shrink();
        },
      ),
    );
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
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: S
                    .of(context)
                    .setProfilePicture,
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
        showLog("croppedFile face callback");

        widget.croppedFile?.call(croppedFile.path);

        await model.uploadProfileImageForUnAuthUser(
            image: base64Image,
            uUcode: widget.uuCode ?? "",
            eventCode: widget.eventCode);
      }
    }
  }
}
