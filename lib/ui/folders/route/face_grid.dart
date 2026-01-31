import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/traits/common_widgets/cached_network_image_widget.dart';
import 'package:photomall_flutter/ui/base/base_widget.dart';
import 'package:photomall_flutter/ui/event/photos/photo_grid.dart';
import 'package:photomall_flutter/ui/folders/model/face_grid_view_model.dart';
import 'package:photomall_flutter/ui/folders/route/person_photo_selection.dart';
import 'package:photomall_flutter/ui/shared_widgets/common.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_appbar.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:provider/provider.dart';

class FaceGrid extends StatefulWidget {
  final String eventCode;
  final int type;
  final List? medias;
  final List<String>? realPersonsPS;

  FaceGrid(
      {Key? key,
      required this.eventCode,
      required this.type,
      this.medias,
      this.realPersonsPS})
      : super(key: key);

  @override
  State<FaceGrid> createState() => _FaceGridState();
}

class _FaceGridState extends State<FaceGrid> {
  BaseWidget<FaceGridViewModel>? baseWidget;

  @override
  Widget build(BuildContext context) {
    baseWidget = BaseWidget<FaceGridViewModel>(
      model: FaceGridViewModel(
        apiHandler: Provider.of<ApiHelper>(context, listen: false),
        context: context,
      ),
      onModelReady: (model) =>
          model.initialFaceListMethod(widget.eventCode, widget.type),
      builder: (context, model, child) {
        return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: AppColorData.backgroundGradientBegin,
                    end: AppColorData.backgroundGradientEnd,
                    colors: AppColorData.backgroundColors,
                    stops: AppColorData.appBackgroundStops)),
            child: SafeArea(
              top: false,
              child: Scaffold(
                appBar: CommonAppBar(
                  isMainPage: false,
                  title: "Persons",
                ),
                body: (model.isLoading)
                    ? CommonCircularProgress()
                    : model.personsListForView.value.isEmpty
                        ? EmptyView(
                            text: "No face detected yet.",
                            iconData: Icons.lock_clock_outlined,
                          )
                        : setPersonsView(model),
              ),
            ));
      },
    );
    return baseWidget!;
  }

  setPersonsView(FaceGridViewModel model) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: GridView.builder(
          controller: model.scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: model.personsListForView.value.length,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              alignment: Alignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (widget.type == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return PersonPhotoSelections(
                            eventCode: widget.eventCode,
                            code: model.personsListForView.value[index].code,
                          );
                        }),
                      );
                    } else {
                      // album
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) {
                      //     return PhotoGrid(
                      //       arguments: PhotoGridArguments(
                      //
                      //         appBarTitle: "Person",
                      //         personCode:
                      //             model.personsListForView.value[index].code,
                      //         eventCode: widget.eventCode,
                      //         callbackPhotoSelection: () {},
                      //       ),
                      //     );
                      //   }),
                      // );
                    }
                  },
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(100.0)),
                    child: Container(
                      color: AppColorData.appBarTextColor,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100.0)),
                            child: Container(
                              width: MediaQuery.of(context).size.width * .25,
                              height: MediaQuery.of(context).size.width * .25,
                              child: CustomCachedNetworkImageWidget(
                                url:
                                    '${model.publicPath}/${model.personsListForView.value[index].image}',
                                fitSize: BoxFit.fill,
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 0,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(200.0)),
                    child: Card(
                      color: AppColorData.appBarTextColor,
                      child: ConstrainedBox(
                          constraints: new BoxConstraints(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.10),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: model.personsListForView.value[index].images
                                    .split(",")
                                    .first
                                    .isNotEmpty
                                ? CommonText(
                                    text:
                                        "${model.personsListForView.value[index].images.split(",").length}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            color:
                                                AppColorData.appBarIconColor),
                                  )
                                : CommonText(
                                    text: "0",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    color: Colors.white,
                                  ),
                          ))),
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}
