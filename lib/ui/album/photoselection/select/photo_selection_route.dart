import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/pm_job_controller.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/route_constants.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_current_index_dao.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/ui/album/photoselection/select/photo_selection_route_view_model.dart';
import 'package:photomall_flutter/ui/base/base_widget.dart';
import 'package:photomall_flutter/ui/event/photos/photo_grid.dart';
import 'package:photomall_flutter/ui/photoselection/view/comment_and_rating_view.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:photomall_flutter/ui/shared_widgets/ratting_widget.dart';

import '../../../../help_route.dart';
import '../../../../traits/common_widgets/common_card.dart';
import '../../../../traits/common_widgets/common_download_button.dart';

class PhotoSelectionRoute extends StatefulWidget {
  final int status;
  final String folderCode;
  final String? personCode;
  final String? eventCode;
  final String? eventCodeForDownload;
  final bool? isWithOutPersonSelection;

  PhotoSelectionRoute(
      {Key? key,
      required this.status,
      required this.folderCode,
      this.personCode,
      this.eventCode,
      this.isWithOutPersonSelection = false,
      this.eventCodeForDownload})
      : super(key: key);

  @override
  PhotoSelectionRouteState createState() {
    return PhotoSelectionRouteState();
  }
}

class PhotoSelectionRouteState
    extends State<PhotoSelectionRoute> /* with WidgetsBindingObserver*/ {
  @override
  void initState() {
    //setDeviceOrientation();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    /* SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);*/
    super.dispose();
    // WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    /* SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);*/
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BaseWidget<PhotoSelectionRouteViewModel>(
        model: PhotoSelectionRouteViewModel(context),
        onModelReady: (model) async {
          showLog('PhotoSelectionRouteViewModel ${widget.eventCode}');
          await model.getPhotoSelectionImages(widget.folderCode, widget.status,
              widget.personCode, widget.eventCode, widget.eventCodeForDownload);
        },
        builder: (context, model, child) {
          return model.loading
              ? _setBusy(context)
              : photoSelectionView(context, model);
        },
      ),
    );
  }

  _setBusy(BuildContext context) {
    return Center(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CommonCircularProgress(),
            ),
            CommonText(
              text: S.of(context).please_wait_preparing_your_album,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }

  photoSelectionView(BuildContext context, PhotoSelectionRouteViewModel model) {
    return Container(
      decoration: BoxDecoration(color: Colors.black
          /*gradient: LinearGradient(
              begin: AppColorData.backgroundGradientBegin,
              end: AppColorData.backgroundGradientEnd,
              colors: AppColorData.backgroundColors,
              stops: AppColorData.appBackgroundStops)*/
          ),
      child: WillPopScope(
        onWillPop: () async {
          //await updateCurrentIndex(model);
          showLog('WillPopScope');
          //Navigator.pop(context);
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.startFloat,
              floatingActionButton: ValueListenableBuilder<bool>(
                  valueListenable: model.undoVisibility,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return Visibility(
                        visible: value, child: unDoButton(model: model));
                  }),
              key: model.scaffoldKey,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.black,
                iconTheme: IconThemeData(color: Colors.white),
                /* flexibleSpace: Container(
                    decoration: BoxDecoration(
                      color: Colors.black
                 */ /* gradient: LinearGradient(
                      begin: AppColorData.appBarGradientBegin,
                      end: AppColorData.appBarGradientEnd,
                      colors: AppColorData.appBarBackgroundColors),*/ /*
                )),*/
                title: model.getAppBarTitle(widget.status, widget.folderCode),
                centerTitle: false,
                actions: [
                  InkWell(
                      onTap: () async {
                        /*  int? result = await Navigator.push(
                            context,
                            // Create the SelectionScreen in the next step.
                            MaterialPageRoute(
                                builder: (context) => PhotoGrid(
                                      arguments: PhotoGridArguments(
                                        realPersonCode: model.realPersonsPS,
                                        eventCode: widget.eventCode,
                                        isWithoutFace:
                                            widget.isWithOutPersonSelection ==
                                                true,
                                        callbackPhotoSelection: () {},
                                        storagePath: DownloadPath(
                                          private: model.privateStoragePath,
                                          public: model.publicStoragePath,
                                        ),
                                        folderCode: widget.folderCode,
                                        status: widget.status,
                                      ),
                                    )));
                        //setDeviceOrientation();
                        setState(() {
                          // setState must for device orientation change
                        });
                        if (result != null) {
                          PhotoSelectionCurrentIndex photoSelectionCurrentIndex =
                              PhotoSelectionCurrentIndex();
                          await photoSelectionCurrentIndex.updateCurrentIndex(
                              folderCode: widget.folderCode,
                              photoSelectionCode: model.photoSelections[result]
                                  .photoSelectionImage!.code,
                              status: widget.status);

                          model.itemScrollController.jumpToPage(
                            result,
                            // duration: Duration(milliseconds: 500),
                          );
                        }*/
                      },
                      child: model.getCountOfImages(
                          widget.status, widget.folderCode)),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: InkWell(
                        onTap: () async {
                          showLog('View all taped');
                          model.photoSelections.clear();
                          await model.getPhotoSelectionImages(
                              widget.folderCode,
                              widget.status,
                              widget.personCode,
                              widget.eventCode,
                              widget.eventCodeForDownload);
                          int? result = await Navigator.push(
                              context,
                              // Create the SelectionScreen in the next step.
                              MaterialPageRoute(
                                  builder: (context) => PhotoGrid(
                                        arguments: PhotoGridArguments(

                                          photoSelectionsSubmitStatus: model.submitStatus.value,
                                          photoSelections:
                                              model.photoSelections,
                                          isDemoEvent: model.isDemoEvent,
                                          eventCode: widget.eventCode,
                                          isWithoutFace:
                                              widget.isWithOutPersonSelection ==
                                                  true,
                                          personCode: widget.personCode,
                                          callbackPhotoSelection: () {},
                                          storagePath: DownloadPath(
                                            private: model.privateStoragePath,
                                            public: model.publicStoragePath,
                                          ),
                                          folderCode: widget.folderCode,
                                          status: widget.status,
                                        ),
                                      )));
                          //setDeviceOrientation();
                          setState(() {
                            // setState must for device orientation change
                          });
                          showLog('jumpToPage new $result');

                          if (result != null && model.photoSelections.isNotEmpty) {
                            PhotoSelectionCurrentIndex
                                photoSelectionCurrentIndex =
                                PhotoSelectionCurrentIndex();
                            await photoSelectionCurrentIndex.updateCurrentIndex(
                                folderCode: widget.folderCode,
                                photoSelectionCode: model
                                    .photoSelections[result]
                                    .photoSelectionImage!
                                    .code,
                                status: widget.status);
                            showLog('jumpToPage $result');

                            model.itemScrollController.jumpToPage(
                              result,
                              // duration: Duration(milliseconds: 500),
                            );
                            model.photoSelections.clear();
                            await model.getPhotoSelectionImages(
                                widget.folderCode,
                                widget.status,
                                widget.personCode,
                                widget.eventCode,
                                widget.eventCodeForDownload);
                          }
                        },
                        child: Text(
                          S.of(context).viewAll,
                          style: TextStyle(color: Colors.white, fontSize: 20),

                          //isAppBar: true,
                        ),
                      ),
                    ),
                  ),

                  FloatingActionButton.extended(
                    onPressed: () {
                      showLog('eventCode${widget.eventCode}');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OnBoardingPage()));
                    },
                    icon: Icon(
                      Icons.help,
                      color: Colors.white,
                    ),
                    label: Text(
                      S.of(context).help,
                      style: TextStyle(color: Colors.white),
                    ),
                    highlightElevation: 0,
                    hoverElevation: 0,
                    backgroundColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    clipBehavior: Clip.none,
                    focusElevation: 0,
                    elevation: 0,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                  // getPopUpMenu(context,widget.eventCode,widget.personCode,widget.folderCode,widget.isWithOutPersonSelection)
                ],
              ),
              body: ValueListenableBuilder<bool>(
                  valueListenable: model.submitStatus,
                  builder:
                      (BuildContext context, bool submitValue, Widget? child) {
                    return ValueListenableBuilder<
                            List<PhotoSelectionImagesModel>>(
                        valueListenable: model.items,
                        builder: (BuildContext context,
                            List<PhotoSelectionImagesModel> value,
                            Widget? child) {
                          value.length != 0
                              ? model.downloadUrl =
                                  '${model.publicStoragePath!}/${model.photoSelections[0].file!.name}'
                              : null;
                          value.length != 0
                              ? model.downloadImageName =
                                  '${model.photoSelections[0].photoSelectionImage?.originalName}'
                              : null;
                          value.length != 0
                              ? model.downloadOrderCode =
                                  '${model.photoSelections[0].photoSelectionImage?.code}'
                              : null;
                          showLog(
                              'the length where ${model.currentIndex},length is ${value.length}');
                          return value.length != 0
                              ? Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      PageView.builder(
                                        onPageChanged: (index) async {
                                          model.downloadUrl =
                                              '${model.publicStoragePath!}/${model.photoSelections[index].file!.name}';
                                          model.downloadImageName =
                                              '${model.photoSelections[index].photoSelectionImage?.originalName}';
                                          model.downloadOrderCode =
                                              '${model.photoSelections[index].photoSelectionImage?.code}';

                                          showLog(
                                              'downloadUrl up down ${model.downloadUrl}');
                                          // total 6
                                          // current 4
                                          //
                                          /*
                                           if(index < ((model
                                               .items
                                               .value.length)-1)){
                                             cacheNextImages();
                                             CacheUtil cacheUtil = CacheUtil();
                                             DownloadFilesController download =
                                             DownloadFilesController();
                                         //   for(int i =0; i<2; i++) {
                                             int nextIndex = 1+index;
                                             if(nextIndex > model
                                                 .items
                                                 .value.length - 1){
                                               return;
                                             }
                                             String name = model
                                                 .items.value[nextIndex].file.name;
                                              showLog('the updating index where B : ${1+index} $name');


                                              String url = download.createUrl(
                                                  privatePath:
                                                      model.privateStoragePath,
                                                  publicPath:
                                                      model.publicStoragePath,
                                                  file: model
                                                      .items.value[nextIndex].file,
                                                  temporaryUrl: model
                                                              .items
                                                              .value[nextIndex]
                                                              .temporaryUrl !=
                                                          null
                                                      ? model.items.value[nextIndex]
                                                          .temporaryUrl.value
                                                      : null);
                                              String extension = model
                                                  .items
                                                  .value[nextIndex]
                                                  .file
                                                  .extension;

                                              cacheUtil.getCacheFile(
                                                url: url,
                                                extension: extension,
                                                name: name,
                                              );
                                     //      }
                                          }*/

                                          model.currentIndeximageCode = model
                                              .items
                                              .value[index]
                                              .photoSelectionImage!
                                              .code;
                                          await updateCurrentIndex(model);
                                        },
                                        scrollDirection: Axis.vertical,
                                        controller: model.itemScrollController,
                                        physics: PageScrollPhysics(),
                                        itemCount: model.items.value.length,
                                        //itemCount: items.length,
                                        itemBuilder: (context, index) {
                                          model.downloadUrl =
                                              '${model.publicStoragePath!}/${model.photoSelections[index].file!.name}';
                                          model.downloadImageName =
                                              '${model.photoSelections[index].photoSelectionImage?.originalName}';
                                          model.downloadOrderCode =
                                              '${model.photoSelections[index].photoSelectionImage?.code}';

                                          final item =
                                              model.photoSelections[index];

                                          showLog(
                                              'downloadUrl left right  ${model.downloadUrl}');
                                          return Stack(
                                            children: [
                                              Listener(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onPointerUp: (a) {
                                                  Future.delayed(
                                                      Duration(
                                                          milliseconds: 200),
                                                      () {
                                                    model.leftSwipeIndicator
                                                        .value = false;
                                                    model.rightSwipeIndicator
                                                        .value = false;
                                                  });
                                                },
                                                child: !model.submitStatus.value
                                                    ? Dismissible(
                                                        onUpdate: (a) {
                                                          // DismissDirection.endToStart
                                                          showLog(a.direction);
                                                          if (a.direction ==
                                                              DismissDirection
                                                                  .endToStart) {
                                                            showLog(
                                                                'endToStart ${widget.status}');
                                                            model
                                                                .leftSwipeIndicator
                                                                .value = true;
                                                            model
                                                                .rightSwipeIndicator
                                                                .value = false;
                                                          }
                                                          if (a.direction ==
                                                              DismissDirection
                                                                  .startToEnd) {
                                                            showLog(
                                                                'startToEnd ${widget.status}');
                                                            model
                                                                .leftSwipeIndicator
                                                                .value = false;
                                                            model
                                                                .rightSwipeIndicator
                                                                .value = true;
                                                          }
                                                        },
                                                        key: UniqueKey(),
                                                        onDismissed:
                                                            (direction) async {
                                                          undoProgress(
                                                              model, index);

                                                          ///     undoPhotoSelection();
                                                          model
                                                              .leftSwipeIndicator
                                                              .value = false;
                                                          model
                                                              .rightSwipeIndicator
                                                              .value = false;

                                                          if (direction ==
                                                              DismissDirection
                                                                  .endToStart) {
                                                            // left swipe
                                                            showLog('left');

                                                            await model
                                                                .photoSelectionImageController
                                                                .updatePhotoStatus(
                                                              context: context,
                                                              photoSelectionImage: model
                                                                  .photoSelections[
                                                                      index]
                                                                  .photoSelectionImage,
                                                              status:
                                                                  widget.status,
                                                              direction: 'left',
                                                              isDemoEvent: model
                                                                  .isDemoEvent,
                                                            );
                                                            await model
                                                                .photoSelectionImageController
                                                                .getSyncWithServer(); // update
                                                          }
                                                          if (direction ==
                                                              DismissDirection
                                                                  .startToEnd) {
                                                            await model
                                                                .getAlertToast(
                                                                    widget
                                                                        .folderCode,
                                                                    widget
                                                                        .status);
                                                            await model
                                                                .photoSelectionImageController
                                                                .updatePhotoStatus(
                                                              context: context,
                                                              photoSelectionImage: model
                                                                  .photoSelections[
                                                                      index]
                                                                  .photoSelectionImage,
                                                              status:
                                                                  widget.status,
                                                              direction:
                                                                  'right',
                                                              isDemoEvent: model
                                                                  .isDemoEvent,
                                                            );
                                                            await model
                                                                .photoSelectionImageController
                                                                .getSyncWithServer(); // update
                                                          }
                                                          value.removeAt(index);
                                                          model.photoSelections
                                                              .removeAt(index);
                                                          await model
                                                              .generatePhotoList(
                                                            widget.folderCode,
                                                            widget.status,
                                                            widget.personCode,
                                                            eventCode: widget
                                                                .eventCode,
                                                          );
                                                          if (widget.folderCode
                                                              .isEmpty) {
                                                            setState(() {});
                                                          }
                                                        },
                                                        // Show a white background as the item is swiped away.

                                                        child: Center(
                                                          child: Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.90,
                                                            child: model
                                                                .imageProcessor
                                                                .getImageView(
                                                              boxFit: BoxFit
                                                                  .contain,
                                                              documentPath: model
                                                                  .documentDirectory,
                                                              file: item.file!,
                                                              publicStoragePath:
                                                                  model
                                                                      .publicStoragePath!,
                                                              privateStoragePath:
                                                                  model
                                                                      .privateStoragePath,
                                                              onTap: () {
                                                                model
                                                                    .zoomImageMode(
                                                                        item);
                                                              },
                                                              errorWidget:
                                                                  SizedBox(),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        child: Container(
                                                          color: Colors.black,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.90,
                                                          child: Center(
                                                            child: model
                                                                .imageProcessor
                                                                .getImageView(
                                                              boxFit: BoxFit
                                                                  .contain,
                                                              documentPath: model
                                                                  .documentDirectory,
                                                              file: item.file!,
                                                              publicStoragePath:
                                                                  model
                                                                      .publicStoragePath!,
                                                              privateStoragePath:
                                                                  model
                                                                      .privateStoragePath,
                                                              onTap: () {
                                                                model
                                                                    .zoomImageMode(
                                                                        item);
                                                              },
                                                              errorWidget:
                                                                  SizedBox(),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                              ValueListenableBuilder<bool>(
                                                  valueListenable:
                                                      model.submitStatus,
                                                  builder:
                                                      (BuildContext context,
                                                          bool submitValue,
                                                          Widget? child) {
                                                    return Positioned(
                                                      bottom: 25,
                                                      right: 30,
                                                      child: Row(
                                                        children: [
                                                          (model.downloadEnabled)
                                                              ? CommonCard(
                                                                  child:
                                                                      TextButton(
                                                                    onPressed:
                                                                        () async {},
                                                                    child:
                                                                        CommonFileDownloadButton(
                                                                      url: model
                                                                          .downloadUrl,
                                                                      orderCode:
                                                                          model
                                                                              .downloadOrderCode,
                                                                      originalName:
                                                                          model
                                                                              .downloadImageName,
                                                                      eventCode: (widget.eventCode !=
                                                                              null)
                                                                          ? widget
                                                                              .eventCode
                                                                          : widget
                                                                              .eventCodeForDownload,
                                                                      isFromPhotoSelection:
                                                                          true,
                                                                    ),
                                                                  ),
                                                                )
                                                              : SizedBox(),
                                                          (widget.status == 1 &&
                                                                  !submitValue)
                                                              ? SizedBox(
                                                                  //   width: 65,
                                                                  //  height: 65,
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        gradient: LinearGradient(
                                                                          colors:
                                                                              AppColorData.bgIconBackgroundColor,
                                                                          begin:
                                                                              AppColorData.bgIconGradientBegin,
                                                                          end: AppColorData
                                                                              .bgIconGradientEnd,
                                                                          stops:
                                                                              AppColorData.bgIconStops,
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                              blurRadius: AppColorData.cardElevation,
                                                                              color: AppColorData.cardShadowColor)
                                                                        ]),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        await Navigator.pushNamed(
                                                                            context,
                                                                            RoutePaths
                                                                                .CommentAndRatting,
                                                                            arguments:
                                                                                CommentAndRattingArguments(
                                                                              privateStoragePath: model.privateStoragePath!,
                                                                              publicStoragePath: model.publicStoragePath!,
                                                                              item: item,
                                                                              fileCode: item.file!.code,
                                                                              photoSelectionCode: item.photoSelectionImage!.code,
                                                                            ));
                                                                        model
                                                                            .generatePhotoList(
                                                                          widget
                                                                              .folderCode,
                                                                          widget
                                                                              .status,
                                                                          widget
                                                                              .personCode,
                                                                          eventCode:
                                                                              widget.eventCode,
                                                                        );
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                4,
                                                                            bottom:
                                                                                5,
                                                                            left:
                                                                                9,
                                                                            right:
                                                                                5),
                                                                        child: RattingWidget(
                                                                            gestureIgnore:
                                                                                true,
                                                                            initialRating:
                                                                                double.parse("${item.photoSelectionImage!.rating}"),
                                                                            rattingCallBack: (value) {}),
                                                                        /* Icon(
                                                                          CupertinoIcons
                                                                              .pencil_ellipsis_rectangle,
                                                                          // Icons.message_outlined,
                                                                          color: AppColorData
                                                                              .bgIconColor,
                                                                          size: 40,
                                                                        ),*/
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : SizedBox(),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          );
                                        },
                                      ),
                                      ValueListenableBuilder<bool>(
                                          valueListenable:
                                              model.leftSwipeIndicator,
                                          builder: (BuildContext context,
                                              bool value, Widget? child) {
                                            return Visibility(
                                                visible: value,
                                                child: model.leftSwipeStatus!);
                                          }),
                                      ValueListenableBuilder<bool>(
                                          valueListenable:
                                              model.rightSwipeIndicator,
                                          builder: (BuildContext context,
                                              bool value, Widget? child) {
                                            return Visibility(
                                                visible: value,
                                                child: model.rightSwipeStatus!);
                                          }),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: Text("No image available",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)
                                      //  style: Theme.of(context).textTheme.bodyMedium,
                                      ));
                        });
                  })),
        ),
      ),
    );
  }

  void undoProgress(PhotoSelectionRouteViewModel model, int index) {
    model.previousPhotoSelectionData = (model.photoSelections[index]);
    model.undoVisibility.value = true;
    Future.delayed(const Duration(seconds: 5), () {
      model.undoVisibility.value = false;
    });
  }

  unDoButton({required PhotoSelectionRouteViewModel model}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        gradient: LinearGradient(
            begin: AppColorData.buttonGradientBegin,
            end: AppColorData.buttonGradientEnd,
            colors: AppColorData.buttonBackgroundColors,
            stops: AppColorData.buttonBackgroundStops),
        //gradient: LinearGradient(colors: [Colors.blue,Colors.black])
      ),
      child: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: Colors.transparent,
        onPressed: () async {
          await model.undoPhotoSelection(
              widget.folderCode, widget.status, widget.personCode,
              eventCode: widget.eventCode);
          ToastUtil.showSnackBarAtCurrentState(
              S.of(context).previousDecisionRolledBack);
          model.undoVisibility.value = false;
          if (widget.folderCode.isEmpty) {
            setState(() {});
          }
        },
        heroTag: 'status',
        tooltip: S.of(context).addEvent,
        icon: Icon(
          Icons.undo,
          color: AppColorData.elevatedButtonText,
          size: 35,
        ),
        label: CommonText(
          text: S.of(context).undo,
          // color: AppColorData.elevatedButtonText,
          isButton: true,
        ),
      ),
    );
  }

  void setDeviceOrientation() {
    showLog("the device rotate");
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> updateCurrentIndex(PhotoSelectionRouteViewModel model) async {
    try {
      showLog("error in pop 1    //${model.currentIndeximageCode}//");
      if (model.currentIndeximageCode!.isNotEmpty) {
        showLog("error in pop 2");
        await model.updateCurrentIndex(
          widget.folderCode,
          widget.status,
          photoSelectionImagesCode: model.currentIndeximageCode,
        );
        showLog("error in pop 3");
      }
      showLog("error in pop 4");
    } catch (e) {
      showLog("error in pop ${e}");
    }
  }

  void cacheNextImages() {}
}
