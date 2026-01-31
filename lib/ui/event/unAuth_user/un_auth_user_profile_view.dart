import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:photomall_flutter/ui/event/unAuth_user/un_auth_user_profile_view_model.dart';
import 'package:photomall_flutter/ui/profile/view_model/customer_profile_view_route_model.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

import '../../../color_constants.dart';
import '../../../core/Utils/toast_util.dart';
import '../../../core/constants/common_constants.dart';
import '../../../core/models/apiModels/myPhotos_images_response_model.dart';
import '../../../media/media_view_model.dart';
import '../../../media/my_photos_route.dart';
import '../../../traits/image_processor.dart';
import '../../base/base_widget.dart';
import '../../shared_widgets/common_rounded_image_widget.dart';
import '../../shared_widgets/common_text.dart';

class UnAuthUserProfileView extends StatefulWidget {
  final String publicStoragePath;
  final String uuCode;
  final String Profile;
  final String eventCode;

  const UnAuthUserProfileView(
      {super.key,
      required this.publicStoragePath,
      required this.uuCode,
      required this.Profile,
      required this.eventCode});

  @override
  State<UnAuthUserProfileView> createState() => _UnAuthUserProfileViewState();
}

class _UnAuthUserProfileViewState extends State<UnAuthUserProfileView> {
  BaseWidget<MediaRouteViewModel>? baseWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    baseWidget = BaseWidget<MediaRouteViewModel>(
      model: MediaRouteViewModel(),
      onModelReady: (model) async {
        await model.getUnAuthUserMyPhotosImagesFromApi(
            uuCode: widget.uuCode, eventCode: widget.eventCode);
        if (model.unAuthUserPersons.isNotEmpty) {}
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
              Navigator.of(context)
                  .pop(model.unAuthUserPersons.length == 0 ? true : false);
              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Skeletonizer(
                enabled: model.unAuthLoading ?? false,
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
                    model.unAuthUserPersons.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * .4),
                              child: Text(
                                "Please add Your selfie",
                                style: TextStyle(
                                  color: AppColorData.appBarTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                        : userPersonView(context, model),
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
                        builder: (context) => FaceCameraWidget(
                              model: model,
                              uuCode: widget.uuCode,
                              eventCode: widget.eventCode,
                            )),
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

  _userPersonImageView(String? userPerson) {
    showLog("_userPersonImageView $userPerson");
    String? url = '';
    if (userPerson != null && userPerson != '') {
      url = '${widget.publicStoragePath}${userPerson}';
    }
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
      showLog("_userPersonImageView url :$url");
      return Image.network('$url', errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return const Text('ð¢');
      });
    } else {
      return emptyProfileWidget;
    }
  }

  userPersonView(BuildContext context, MediaRouteViewModel model) {
    return Center(
      child: SingleChildScrollView(
        //  scrollDirection: Axis.horizontal,
        child: SizedBox(
          //height: 120,
          child: GridView.builder(
            scrollDirection: Axis.vertical,
            // Adjust scroll direction if needed
            shrinkWrap: true,
            itemCount: model.unAuthUserPersons.length,
            // Number of items in the list
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              childAspectRatio:
                  1, // Adjust the aspect ratio to suit your design
            ),
            //Number of items in the list
            itemBuilder: (context, index) {
              // This function is called for each item in the list
              return true
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
                                          child: _userPersonImageView(model
                                              .unAuthUserPersons[index]
                                              .jvtFileConnector!
                                              .jvtFile
                                              ?.name),
                                        ),
                                        /* Positioned(

                                    //top: 0,
                                      bottom: -5,
                                      right: 15,
                                      child: InkWell(
                                        onTap: () async {},
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
                                      )),*/
                                        Positioned(

                                            //top: 0,
                                            bottom: -5,
                                            left: 15,
                                            child: TapDebouncer(
                                                onTap: () async {
                                              await model
                                                  .getMultipleFaceDeleteApi(
                                                      code: model
                                                          .unAuthUserPersons[
                                                              index]
                                                          .code!,
                                                      index);

                                            }, builder: (BuildContext context,
                                                    TapDebouncerFunc? onTap) {
                                              return InkWell(
                                                onTap: onTap,
                                                child: Opacity(
                                                  opacity: 0.70,
                                                  child: Container(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
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
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: AppColorData
                                                          .bgIconColor,
                                                      size: 25,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }))
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
}
