import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/photo_selection_image_controller.dart';
import 'package:photomall_flutter/core/Utils/file_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/dao/folder_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_images_dao.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/traits/common_widgets/common_card.dart';
import 'package:photomall_flutter/traits/image_processor.dart';
import 'package:photomall_flutter/ui/album/photoselection/select/photo_selection_route_view_model.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_alert_dialog.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_appbar.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text_button.dart';
import 'package:photomall_flutter/ui/shared_widgets/ratting_widget.dart';

class CommentAndRattingView extends StatefulWidget {
  final PhotoSelectionImagesModel? item;
  final String? fileCode;
  final String? photoSelectionCode;
  final String? privateStoragePath;
  final String? publicStoragePath;
  final CommentAndRattingArguments arguments;

  CommentAndRattingView(
      {Key? key,
      this.item,
      this.fileCode,
      this.photoSelectionCode,
      this.privateStoragePath,
      this.publicStoragePath,
      required this.arguments})
      : super(key: key);

  @override
  State<CommentAndRattingView> createState() => _CommentAndRattingViewState();
}

class _CommentAndRattingViewState extends State<CommentAndRattingView> {
  FileUtil fileUtil = FileUtil();
  TextEditingController commentsController = TextEditingController();
  double rating = 0;
  bool isSaved = true;
  final ValueNotifier<bool> isPageBusy = ValueNotifier<bool>(false);
  FocusNode commentFocusNode = FocusNode();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {});
    });
    getLocalDataForThisPhoto();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isPageBusy,
        builder: (BuildContext context, bool value, Widget? child) {
          return !isPageBusy.value
              ? WillPopScope(
                  onWillPop: () async {
                    await _onBackPressed();
                    return true;
                  },
                  child: SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: AppColorData.backgroundGradientBegin,
                              end: AppColorData.backgroundGradientEnd,
                              colors: AppColorData.backgroundColors,
                              stops: AppColorData.appBackgroundStops)),
                      child: Scaffold(
                        appBar: CommonAppBar(
                          title: S.of(context).designInstructionForDesigner,
                          actions: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: InkWell(
                                onTap: () {
                                  saveEnteredDataInDb();
                                },
                                child: Container(
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 3.0,
                                          color: AppColorData.appBarIconColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              20.0) //                 <--- border radius here
                                          ),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        child: CommonText(
                                          text: S.of(context).save,
                                          isAppBar: true,
                                        ),
                                      ),
                                    )),
                              ),
                            )

                            /*  Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CommonButton(
                                onPressCall: () {
                                  saveEnteredDataInDb();
                                },
                                buttonText: "S.of(context).save",
                                //width: 70,
                              ),
                            ),*/
                          ],
                        ),
                        backgroundColor: Colors.transparent,
                        body: SingleChildScrollView(
                          child: Center(
                            child: IntrinsicHeight(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CommonCard(
                                      shape: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          topLeft: Radius.circular(20)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              getSelectedImage(),
                                              ratingCard(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: CommonCard(
                                        shape: BorderRadius.only(
                                          bottomRight: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.75,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: AppColorData
                                                        .textFormFieldCardBg,
                                                    border: Border.all(
                                                        color: AppColorData
                                                            .textFormFieldCardBg),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextFormField(
                                                    focusNode: commentFocusNode,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                    onChanged: (v) {
                                                      isSaved = false;
                                                    },
                                                    cursorColor: AppColorData
                                                        .textFormFieldCursor,
                                                    cursorHeight: 20,
                                                    controller:
                                                        commentsController,
                                                    maxLines: null,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: S
                                                          .of(context)
                                                          .giveYourSuggestions,
                                                      hintStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium,
                                                      /*TextStyle(
                                                        fontSize: 15,
                                                      ),*/
                                                      // fillColor: Colors.white,
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 0.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: AppColorData.backgroundGradientBegin,
                          end: AppColorData.backgroundGradientEnd,
                          colors: AppColorData.backgroundColors,
                          stops: AppColorData.appBackgroundStops)),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: SizedBox(
                      child: Center(child: CommonCircularProgress()),
                    ),
                  ),
                );
        });
  }

  Widget ratingCard() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: CommonCard(
        child: Column(
          children: [
            RattingWidget(
                initialRating: rating,
                rattingCallBack: (value) {
                  isSaved = false;
                  showLog(rating);
                  rating = value;
                }),
            CommonText(
              text: S.of(context).setPriority,
              // text: S.of(context).rateThisImage,
              style: Theme.of(context).textTheme.bodyLarge,
              // fontWeight: FontWeight.normal,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onBackPressed() async {
    if (isSaved) {
      return;
    } else {
      showDialog(
        context: context,
        builder: (context) => CommonAlertDialog(
          title: S.of(context).unsavedChanges,
          content: S.of(context).areYouSureYouWantToSaveChanges,
          actions: [
            CommonTextButton(
                buttonText: S.of(context).discard,
                onPressCall: () {
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                }),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            CommonTextButton(
              buttonText: S.of(context).saveExit,
              onPressCall: () {
                try {
                  isPageBusy.value = true;
                  saveEnteredDataInDb();
                  isSaved = true;
                  isPageBusy.value = false;
                  _showToast(context, S.of(context).saved);
                  Navigator.of(context).pop(true);
                } catch (e) {
                  isPageBusy.value = false;
                  _showToast(context, S.of(context).somethingWentWrong);
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  Future<void> getLocalDataForThisPhoto() async {
    PhotoSelectionImagesModelDao photoSelectionModelDao =
        PhotoSelectionImagesModelDao();
    appDb.PhotoSelectionImage? photoSelectionImage =
        await photoSelectionModelDao.getPhotoSelectionImageWhereCode(
            widget.arguments.photoSelectionCode!);
    commentsController =
        TextEditingController(text: photoSelectionImage!.comment);
    rating = double.parse('${photoSelectionImage.rating}');
  }

  void saveEnteredDataInDb() async {
    commentFocusNode.unfocus();
    isPageBusy.value = true;
    PhotoSelectionImagesModelDao photoSelectionModelDao =
        PhotoSelectionImagesModelDao();
    PhotoSelectionImageController photoSelectionImageController =
        PhotoSelectionImageController();
    EventModelDao eventModelDao = EventModelDao();
    FolderModelDao folderModelDao = FolderModelDao();
    try {
      await photoSelectionImageController.saveEnteredDataInDb(
          photoSelectionCode: widget.arguments.photoSelectionCode!,
          status: false,
          rating: int.parse(rating.toInt().toString()),
          comment: commentsController.text);
      appDb.PhotoSelectionImage? photoSelectionImage =
          await photoSelectionModelDao.getPhotoSelectionImageWhereCode(
              widget.arguments.photoSelectionCode!);

      appDb.Folder? folder = await folderModelDao
          .getFolderWhereCode(photoSelectionImage!.folderCode);
      appDb.Event? event =
          await eventModelDao.getEventByCode(folder!.eventCode);
      if (event!.type != demoEvent) {
        await photoSelectionImageController.updatePhotoSelection(
            eventCode: folder.eventCode);
      }
      isSaved = true;

      isPageBusy.value = false;
      _showToast(context, S.of(context).saved);
    } catch (e) {
      showLog("the error in this Comment & rating view where \n ${e}");

      isPageBusy.value = false;
      _showToast(context, S.of(context).somethingWentWrong);
    }
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
            label: S.of(context).close,
            onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Widget getSelectedImage() {
    ImageProcessor imageProcessor = ImageProcessor();

    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.2,
      width: MediaQuery.of(context).size.width / 2.5,
      child: imageProcessor.getImageView(
        onTap: () {},
        file: widget.arguments.item!.file!,
        privateStoragePath: widget.arguments.privateStoragePath,
        publicStoragePath: widget.arguments.publicStoragePath!,
      ),
    );
  }
}

class CommentAndRattingArguments {
  PhotoSelectionImagesModel? item;
  String? fileCode;
  String? photoSelectionCode;
  String? privateStoragePath;
  String? publicStoragePath;

  CommentAndRattingArguments(
      {this.item,
      this.fileCode,
      this.photoSelectionCode,
      this.privateStoragePath,
      this.publicStoragePath});
}
