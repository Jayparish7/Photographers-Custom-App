import 'dart:convert';
import 'dart:io';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import '../../../color_constants.dart';
import '../../../core/Utils/toast_util.dart';
import '../../../core/constants/common_constants.dart';
import '../../../core/services/api_helper.dart';
import '../../../generated/l10n.dart';
import '../../base/base_widget.dart';
import '../view_model/customer_profile_view_route_model.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;

class MultipleFaceProfileView extends StatefulWidget {
  final String? publicStoragePath;
  final appDb.JvtFile? profileJvtFile;
  final String? usercode;

  const MultipleFaceProfileView(
      {super.key, this.publicStoragePath, this.profileJvtFile, this.usercode});

  @override
  State<MultipleFaceProfileView> createState() =>
      _MultipleFaceProfileViewState();
}

class _MultipleFaceProfileViewState extends State<MultipleFaceProfileView> {
  BaseWidget<CustomerProfileViewRouteModel>? baseWidget;
  late FaceCameraController controller;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    baseWidget = BaseWidget<CustomerProfileViewRouteModel>(
      model: CustomerProfileViewRouteModel(
          apiHandler: Provider.of<ApiHelper>(context, listen: false),
          context: context),
      onModelReady: (model) {
        controller = FaceCameraController(
          autoCapture: false,
          imageResolution: ImageResolution.ultraHigh,
          defaultCameraLens: CameraLens.front,
          performanceMode: FaceDetectorMode.accurate,
          onCapture: (File? image) async {
            Navigator.pop(context);
            showLog('onModelReady...');
            await _cropImage(image, model, context);
            await model.getMultipleFacesIndexFromApi(/*widget.profileJvtFile*/);
            await ToastUtil.showSnackBarAtCurrentState(
                'Picture Added Successfully',
                seconds: 5);
          },
        );
        return model.getMultipleFacesIndexFromApi(/*widget.profileJvtFile*/);
      },
      builder: (context, model, child) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: AppColorData.backgroundGradientBegin,
                  end: AppColorData.backgroundGradientEnd,
                  colors: AppColorData.backgroundColors,
                  stops: AppColorData.appBackgroundStops)),
          child: WillPopScope(
            onWillPop: () async {
              showLog("swipe-to-go-back gesture run");
              Navigator.of(context).pop(true);
              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Skeletonizer(
                enabled: model.isLoading.value,
                effect: ShimmerEffect(
                    baseColor: AppColorData.appBarTextColor.withOpacity(.5)),
                child: ListView(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 0, left: 18.0, right: 18),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              icon: Icon(Icons.arrow_back)),
                          Text(
                            'Your Photos',
                            style: TextStyle(
                              color: AppColorData.appBarTextColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100)),
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: _userPersonImageView(
                              model, model.profileJvtFile?.name),
                        ),
                      ),
                    ),
                    userPersonView(context, model),
                    SizedBox(height: 25),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: AppColorData.buttonBackgroundColors.last,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Material(
                        child: SmartFaceCamera(
                          indicatorShape: IndicatorShape.square,
                          autoDisableCaptureControl: false,
                          controller: controller,
                          messageBuilder: (context, face) {
                            if (face == null) {
                              return _message('Place your face in the camera');
                            }
                            if (!face.wellPositioned) {
                              return _message(
                                  'Place your face at the center of the face indicator.');
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
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
              ),
            ),
          ),
        );
      },
    );

    return baseWidget!;
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

  _cropImage(
      image, CustomerProfileViewRouteModel model, BuildContext context) async {
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
          // _selectedFile = File(croppedFile!.path);
        });
        await model.addProfileImage(
            base64Image,
            File(croppedFile.path),
            code: model.profileImageCode.value,
            context);
      }
    }
  }

  userPersonView(BuildContext context, CustomerProfileViewRouteModel model) {
    return Center(
      child: SingleChildScrollView(
        //  scrollDirection: Axis.horizontal,
        child: SizedBox(
          //height: 120,
          child: GridView.builder(
            scrollDirection: Axis.vertical,
            // Adjust scroll direction if needed
            shrinkWrap: true,
            itemCount: model.multiFacesList.value.length,
            // Number of items in the list
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              childAspectRatio:
                  1, // Adjust the aspect ratio to suit your design
            ),
            //Number of items in the list
            itemBuilder: (context, index) {
              // This function is called for each item in the list
              return model.profileJvtFile?.name !=
                      model.multiFacesList.value[index].jvtFileConnector!
                          .jvtFile?.name
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        width: 150,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              margin: const EdgeInsets.only(top: 16.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Center(
                                child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(50),
                                  // Optional: to give rounded corners

                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    child: Stack(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: _userPersonImageView(
                                              model,
                                              model
                                                  .multiFacesList
                                                  .value[index]
                                                  .jvtFileConnector!
                                                  .jvtFile
                                                  ?.name),
                                        ),
                                        Positioned(

                                            //top: 0,
                                            bottom: -5,
                                            right: 15,
                                            child: ValueListenableBuilder(
                                              valueListenable:
                                                  model.isConnected,
                                              builder: (context, value, child) {
                                                return model.checkConnectivity(
                                                    child: InkWell(
                                                  onTap: () async {
                                                    String res = await model
                                                        .getJvtFilConnectorCode(
                                                            widget.usercode);
                                                    showLog(
                                                        'updateProfileApi $res ,----> ${widget.profileJvtFile!.code}');
                                                    await model.updateProfileApi(
                                                        jvtFileConnectorCode:
                                                            res,
                                                        jvtFileCode: model
                                                            .multiFacesList
                                                            .value[index]
                                                            .jvtFileConnector!
                                                            .jvtFile!
                                                            .code!,
                                                        ableCode:
                                                            widget.usercode!);
                                                  },
                                                  child: Opacity(
                                                    opacity: 0.70,
                                                    child: Container(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          gradient:
                                                              LinearGradient(
                                                            colors: AppColorData
                                                                .bgIconBackgroundColor,
                                                            begin: AppColorData
                                                                .bgIconGradientBegin,
                                                            end: AppColorData
                                                                .bgIconGradientEnd,
                                                            stops: AppColorData
                                                                .bgIconStops,
                                                          )),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Icon(
                                                        Icons.person_add,
                                                        color: AppColorData
                                                            .bgIconColor,
                                                        size: 25,
                                                      ),
                                                    ),
                                                  ),
                                                ));
                                              },
                                            )),
                                        Positioned(

                                            //top: 0,
                                            bottom: -5,
                                            left: 15,
                                            child: ValueListenableBuilder(
                                              valueListenable:
                                                  model.isConnected,
                                              builder: (context, value, child) {
                                                return model.checkConnectivity(
                                                    child: TapDebouncer(onTap:
                                                        () async {
                                                  showLog(
                                                      'TapDebouncer ${model.multiFacesList.value[index].code!}');

                                                  await model
                                                      .getMultipleFaceDeleteApi(
                                                          code: model
                                                              .multiFacesList
                                                              .value[index]
                                                              .jvtFileConnector!
                                                              .code!,
                                                          index);
                                                  await ToastUtil
                                                      .showSnackBarAtCurrentState(
                                                          'Selfie deleted Successfully',
                                                          seconds: 5);
                                                }, builder:
                                                        (BuildContext context,
                                                            TapDebouncerFunc?
                                                                onTap) {
                                                  return InkWell(
                                                    onTap: onTap,
                                                    child: Opacity(
                                                      opacity: 0.70,
                                                      child: Container(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: AppColorData
                                                                      .bgIconBackgroundColor,
                                                                  begin: AppColorData
                                                                      .bgIconGradientBegin,
                                                                  end: AppColorData
                                                                      .bgIconGradientEnd,
                                                                  stops: AppColorData
                                                                      .bgIconStops,
                                                                )),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: AppColorData
                                                              .bgIconColor,
                                                          size: 25,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }));
                                              },
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox();
            },
          ),
        ),
      ),
    );
  }

  _userPersonImageView(
      CustomerProfileViewRouteModel model, String? userPerson) {
    String? url = '';
    if (userPerson != null && userPerson != '') {
      url = '${widget.publicStoragePath}/${userPerson}';
    }
    showLog('_userPersonView ${widget.profileJvtFile!.code}');
    var emptyProfileWidget = Container(
      decoration: BoxDecoration(
          // color: AppColor.get(context, ColorKeys.darkDividerColor)
          //     .withOpacity(0.18),
          //color: lightIconBackgroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: Image.asset(
        'assets/images/user1.gif',
        fit: BoxFit.fitHeight,
      )),
    );
    //return emptyProfileWidget;
    if (1 == 2) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(''),
      );
    } else if (url != '') {
      return Image.network('$url', errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return const Text('ð¢');
      });
    } else {
      return emptyProfileWidget;
    }
  }
}
