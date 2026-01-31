import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/route_constants.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/preference/preference_handler/notification_preference.dart';
import 'package:photomall_flutter/traits/common_widgets/common_card.dart';
import 'package:photomall_flutter/traits/common_widgets/warning_widget.dart';
import 'package:photomall_flutter/ui/base/base_widget.dart';
import 'package:photomall_flutter/ui/folders/model/folder_arguments_model.dart';
import 'package:photomall_flutter/ui/folders/model/folder_route_view_model.dart';
import 'package:photomall_flutter/ui/folders/model/folder_rule_view_model.dart';
import 'package:photomall_flutter/ui/folders/route/face_grid.dart';
import 'package:photomall_flutter/ui/folders/route/person_photo_selection.dart';
import 'package:photomall_flutter/ui/folders/selection_status_card.dart';
import 'package:photomall_flutter/ui/shared_widgets/common.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_alert_dialog.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_button.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text_button.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../../../folder_shape/folder_home.dart';

class FolderRoute extends StatefulWidget {
  final FoldersRouteModel arguments;

  FolderRoute({Key? key, required this.arguments}) : super(key: key);

  @override
  State<FolderRoute> createState() => _FolderRouteState();
}

class _FolderRouteState extends State<FolderRoute> with AutomaticKeepAliveClientMixin<FolderRoute> {
  BaseWidget<FolderRouteViewModel>? baseWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showLog("initiated folder  widget");
    setNotification(true);
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.arguments.eventCode != null) {
      setNotification(false);
    }
    showLog("disposed folder  widget");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    baseWidget = BaseWidget<FolderRouteViewModel>(
      model: FolderRouteViewModel(
        apiHandler: Provider.of<ApiHelper>(context, listen: false),
        context: context,
      ),
      onModelReady: (model) => model.folderWidgetInitialMethod(
          routeEventCode: widget.arguments.eventCode,
          routeFolderCode: widget.arguments.folderCode,
          routeIsDemoEvent: widget.arguments.isDemoEvent),
      builder: (context, model, child) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: AppColorData.backgroundGradientBegin,
                  end: AppColorData.backgroundGradientEnd,
                  colors: AppColorData.backgroundColors,
                  stops: AppColorData.appBackgroundStops)),
          child: (model.isLoading)
              ? Center(
                  child: Container(
                      child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Please Wait...',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      CommonText(
                        text: 'It may take a few minutes to load.',
                        isCard: true,
                      ),

                    ],
                  ),
                )))
              : !model.isPublished
                  ? EmptyView(
                      text: "UnPublished",
                      iconData: Icons.lock_clock_outlined,
                    )
                  : setFolderView(model),
        );
      },
    );
    return baseWidget!;
  }

  Widget setFolderView(FolderRouteViewModel model) {
    return StreamBuilder<appDb.Folder?>(
        stream: model.getStream(),
        builder: (BuildContext context, AsyncSnapshot<appDb.Folder?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return Center(
                child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            'Please Wait...',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          CommonText(
                            text: 'It may take a few minutes to load.',
                            isCard: true,
                          ),

                        ],
                      ),
                    )));
          }
          if (!snapshot.hasData || snapshot.hasError) {
            showLog("snapshot $snapshot");
            return EmptyView(
              text: "No photo selection available",
              iconData: Icons.list_alt,
            );
          } else {
            // model.buildViewByFolder(snapshot.data);
            return Scaffold(
                backgroundColor: Colors.transparent,
                floatingActionButton: model.downloadButton(),
                appBar: !model.isParentFolder!
                    ? AppBar(
                        flexibleSpace: Container(decoration: BoxDecoration()),

                        elevation: 0,
                        // model.drawerChildIndex == 0 ? 0 : 4,
                        title: UniqueText(
                          text: snapshot.data?.name ?? '',
                        ),

                        iconTheme:
                            IconThemeData(color: AppColorData.bgIconColor),
                      )
                    : null,
                body: (widget.arguments.eventCode != null ||
                        widget.arguments.folderCode != null)
                    ? SingleChildScrollView(
                        child: ValueListenableBuilder<bool>(
                            valueListenable: ignoreValue,
                            builder: (BuildContext context, bool value,
                                Widget? child) {
                              return GestureDetector(
                                onTap: () {
                                  if (value == true) {
                                    ToastUtil toastUtil = ToastUtil();
                                    ToastContext().init(context);

                                    toastUtil.showShortToast(context,
                                        "Please cancel download for this action");
                                  }
                                },
                                child: AbsorbPointer(
                                  absorbing: value,
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          subFolderList(model),
                                          photoSelectionCards(model),
                                          faceSelectionCard(model),
                                          withoutFaceSelectionCard(model),
                                          subFolderRuleList(model),
                                          (widget.arguments.isDemoEvent)
                                              ? SizedBox()
                                              : StreamBuilder<
                                                      appDb.PhotoSelection?>(
                                                  stream: model
                                                      .photoSelectionsDao
                                                      .streamPhotoSelectionByEventCode(
                                                          widget.arguments
                                                              .eventCode),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot<
                                                              appDb
                                                              .PhotoSelection?>
                                                          snapshot) {
                                                    if (!snapshot.hasData ||
                                                        snapshot.hasError) {
                                                      return SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                      );
                                                    }
                                                    return snapshot.data!
                                                            .confirmationStatus
                                                        ? submittedButton(model)
                                                        : submitButton(model);
                                                  }),
                                        ],
                                      ),
                                      Obx(
                                        () => model.popAnimation.value
                                            ? Positioned.fill(
                                                child: Lottie.asset(
                                                    'assets/animations/pop_animation.json',
                                                    repeat: false))
                                            : SizedBox.shrink(),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    : EmptyView(
                        text: "No photo selection available",
                        iconData: Icons.content_copy_sharp,
                      ));
          }
        });
  }

  Widget subFolderList(FolderRouteViewModel model) {
    return StreamBuilder<List<appDb.Folder>>(
        stream: model.folderModelDao
            .streamSubFolderWhereParentCode(model.folderCode!),
        builder: (BuildContext context,
            AsyncSnapshot<List<appDb.Folder>> snapshotTwo) {
          if (!snapshotTwo.hasData || snapshotTwo.hasError) {
            return SizedBox();
          } else {
            return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: true,
              child: MasonryGridView.count(
                crossAxisSpacing: 3,
                mainAxisSpacing: 2,
                crossAxisCount: 2,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshotTwo.data!.length,
                itemBuilder: (context, index) {
                  return subFolderListItem(snapshotTwo, index, model);
                },
              ),
            );
          }
        });
  }

  Widget subFolderListItem(AsyncSnapshot<List<appDb.Folder>> snapshotTwo,
      int index, FolderRouteViewModel model) {
    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: FolderHomeWidget(
        title: '${snapshotTwo.data![index].name}',
        curve: Curves.easeInSine,
        onTap: () async {
          await Navigator.pushNamed(
            context,
            RoutePaths.FolderRoute,
            arguments: FoldersRouteModel(
                folderCode: snapshotTwo.data![index].code,
                eventCode: null,
                eventCodeForDownload: widget.arguments.eventCode),
          );

          model.callEssentialApis();
          model.setBusy(false);
        },
      ),
    );
  }

  Widget photoSelectionCards(
    FolderRouteViewModel model,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: photoSelectionCardWidget(
        key: UniqueKey(),
        eventCode: model.eventCode,
        folderCode: model.folderCode,
        eventCodeForDownload: widget.arguments.eventCodeForDownload,
        waitingCount: model.waitingCount,
        rejectedCount: model.rejectedCount,
        selectedCount: model.selectedCount?.value,
        callBack: () async {
          showLog("call back");

          model.callEssentialApis();
          /* if (widget.arguments.eventCode != null) {
            await model.getSyncedWithServer();
            await model.callPhotoSelectionFolderStatusApi();
          }*/
          model.setBusy(false);
        },
      ),
    );
  }

  Widget subFolderRuleList(FolderRouteViewModel model) {
    return FutureBuilder<List<FoldersRuleModel>>(
        future: model.folderRuleController.getFolderRules(model.folderCode!),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return SizedBox();
          }
          return ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      if (model.folderCode ==
                          snapshot.data![index].folderRule!.folderCode) {
                        return;
                      }
                      await Navigator.pushNamed(context, RoutePaths.FolderRoute,
                          arguments: FoldersRouteModel(
                              eventCode: model.eventCode,
                              folderCode: snapshot
                                  .data![index].folderRule!.folderCode));
                      model.setBusy(false);
                    },
                    child: CommonCard(
                      shape: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            snapshot.data![index].file != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        topLeft: Radius.circular(8)),
                                    child: Container(
                                      child: Image.memory(
                                        snapshot.data![index].file!,
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .2,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.folder,
                                    size: 55,
                                    color: AppColorData.iconColor,
                                  ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // is need to verify
                                  /*parentFolderData.code ==
                                          snapshot
                                              .data[index].folderRule.folderCode*/
                                  model.folderCode ==
                                          snapshot.data![index].folderRule!
                                              .folderCode
                                      ? SizedBox()
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: CommonText(
                                            text: snapshot
                                                .data![index].folderName!,
                                            fontWeight: FontWeight.bold,
                                            color: AppColorData.normalTextColor,
                                          ),
                                        ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Wrap(
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          CommonText(
                                            text: snapshot
                                                    .data![index].satisfied!
                                                ? S.of(context).satisfied
                                                : (snapshot.data![index]
                                                            .shortage !=
                                                        0)
                                                    ? "${S.of(context).shortage}${snapshot.data![index].shortage}"
                                                    : '${S.of(context).excess} : ${snapshot.data![index].excess}',
                                            fontWeight: FontWeight.normal,
                                            color:
                                                snapshot.data![index].satisfied!
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                          SizedBox(
                                            width: 23,
                                          ),
                                          CommonText(
                                            text:
                                                '${S.of(context).selected}: ${snapshot.data![index].selectedCount} ',
                                            fontWeight: FontWeight.normal,
                                            color: AppColorData.helpText,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Wrap(
                                        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonText(
                                            text:
                                                '${S.of(context).minimum}: ${snapshot.data![index].folderRule!.minimumSelectionImages}',
                                            fontWeight: FontWeight.normal,
                                            color: AppColorData.helpText,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          CommonText(
                                            text:
                                                '${S.of(context).maximum}: ${snapshot.data![index].folderRule!.maximumSelectionImages}',
                                            fontWeight: FontWeight.normal,
                                            color: AppColorData.helpText,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            snapshot.data![index].satisfied!
                                ? ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(8),
                                        topRight: Radius.circular(8)),
                                    child: Container(
                                        color: Colors.green,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.sentiment_satisfied_alt,
                                            color: Colors.white,
                                          ),
                                        )),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(8),
                                        topRight: Radius.circular(8)),
                                    child: ValueListenableBuilder<bool>(
                                        valueListenable: model.showWarning,
                                        builder: (BuildContext context,
                                            bool value, Widget? child) {
                                          return Visibility(
                                            visible: value,
                                            replacement: BlinkingWidget(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons
                                                      .sentiment_dissatisfied_rounded,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              color: Colors.red,
                                            ),
                                            child: Container(
                                                color: Colors.red,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons
                                                        .sentiment_dissatisfied_rounded,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          );
                                        }),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }

  submittedButton(FolderRouteViewModel model) {
    var width = MediaQuery.of(context).size.width * .1;
    model.isSubmit.value = true;
    ToastContext().init(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.fromLTRB(width, 0, width, 0),
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: AppColorData.buttonBackgroundColors.last,
            foregroundColor: AppColorData.buttonTextColors),
        onPressed: () {
          ToastUtil toastUtil = ToastUtil();
          toastUtil.showShortToast(context, S.of(context).alreadySubmitted);
        },
        child: CommonText(
          text: S.of(context).submitted,
        ),
      ),
    );
  }

  Widget submitButton(FolderRouteViewModel model) {
    var width = MediaQuery.of(context).size.width * .1;

    return ValueListenableBuilder<bool>(
        valueListenable: model.submitLoad,
        builder: (BuildContext context, bool value, Widget? child) {
          return value == true
              ? CommonCircularProgress()
              : Visibility(
                  visible: model.folderRuleController.showSubmitButton,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(width, 0, width, 0),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor:
                                AppColorData.buttonBackgroundColors.last,
                            foregroundColor: AppColorData.buttonTextColors),
                        onPressed: () async {
                          ToastContext().init(context);
                          ToastUtil toastUtil = ToastUtil();
                          if (!model.folderRuleController.buttonStatus) {
                            /*
                             model.maximumCount,
                             model.selectedCount
                          */
                            if ((model.minimumCount?.value != null &&
                                    model.minimumCount?.value != 0) &&
                                model.selectedCount!.value <
                                    model.minimumCount!.value!) {
                              toastUtil.showShortToast(context,
                                  'Select Minimum of ${model.minimumCount!.value} images to submit');
                            }
                            if ((model.maximumCount != 0) &&
                                model.selectedCount!.value >
                                    model.maximumCount!) {
                              toastUtil.showShortToast(context,
                                  'Maximum limit exceeded remove ${model.selectedCount!.value - model.maximumCount!} images from Selected');
                            }

                            model.showWarning.value = false;
                            Future.delayed(const Duration(seconds: 3), () {
                              model.showWarning.value = true;
                            });
                          } else if (!model
                                  .folderRuleController.folderRuleAvailable &&
                              model.selectedCount?.value == 0) {
                            ToastContext().init(context);
                            ToastUtil toastUtil = ToastUtil();
                            toastUtil.showShortToast(
                                context, "Select at least one photo");
                          } else {
                            //getPhotoSelectionCode by event code

                            // call api for move to album

                            showDialog(
                                context: context,
                                builder: (context) {
                                  final ValueNotifier<bool> isChecked =
                                      ValueNotifier<bool>(false);
                                  final ValueNotifier<bool> errorVisible =
                                      ValueNotifier<bool>(false);
                                  return CommonAlertDialog(
                                    title:
                                        S.of(context).albumDesignConfirmation,
                                    content: null,
                                    contentWidget: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ValueListenableBuilder(
                                                valueListenable: isChecked,
                                                builder: (context, bool value,
                                                    child) {
                                                  return Checkbox(
                                                      value: isChecked.value,
                                                      activeColor: AppColorData
                                                          .iconSelectedColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2)),
                                                      onChanged:
                                                          (bool? onChecked) {
                                                        isChecked.value =
                                                            onChecked!;
                                                      });
                                                }),
                                            Container(
                                              color: Colors.transparent,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              child: CommonText(
                                                text: S
                                                    .of(context)
                                                    .iHaveSelectedThePhotosForMyAlbumAndI,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                                textAlign: TextAlign.left,
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(padding: EdgeInsets.all(5)),
                                        ValueListenableBuilder(
                                            valueListenable: errorVisible,
                                            builder:
                                                (context, bool value, child) {
                                              return Visibility(
                                                  visible: value,
                                                  child: BlinkingWidget(
                                                    child: CommonText(
                                                        text:
                                                            "Fill the checkbox",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelMedium),
                                                  ));
                                            })
                                      ],
                                    ),
                                    actions: [
                                      CommonTextButton(
                                        buttonText: "Cancel",
                                        onPressCall: () {
                                          Navigator.pop(context, false);
                                        },
                                      ),
                                      CommonButton(
                                        buttonText: "Submit",
                                        onPressCall: () async {
                                          if (isChecked.value == true) {
                                            // showLog("message");
                                            model.submit();

                                            Navigator.pop(context, true);
                                          } else {
                                            errorVisible.value = true;
                                            Future.delayed(Duration(seconds: 3),
                                                () {
                                              errorVisible.value = false;
                                            });
                                            /*ToastUtil toast = ToastUtil();
                                            ToastContext().init(context);
                                            toast.showShortToast(
                                                context, "Fill the checkbox");*/
                                            return;
                                          }
                                        },
                                      ),
                                      /* */
                                    ],
                                  );
                                });
                          }
                        },
                        child: CommonText(
                          text: S.of(context).submit,
                        ),
                      )),
                );
        });
  }

  faceSelectionCard(FolderRouteViewModel model) {
    showLog(
        "the condition wheres ${model.selectByPersonAvailable} ${model.isParentFolder!}");
    return (model.selectByPersonAvailable && model.isParentFolder!)
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonCard(
                child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.face,
                          color: AppColorData.cardNormalIconColour,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FaceGrid(
                                  eventCode: model.eventCode!,
                                  type: 1,
                                  //realPersonsPS: model.realPersonsPS,
                                )),
                      );
                    },
                    title: CommonText(
                      isCard: true,
                      isHighlightedCard: true,
                      text: S.of(context).selectByFaces,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ))),
          )
        : SizedBox();
  }

  withoutFaceSelectionCard(FolderRouteViewModel model) {
    return (model.selectByPersonAvailable &&
            model.isParentFolder! &&
            model.selectByCommonImageAvailable == true)
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonCard(
                child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.face_retouching_off_sharp,
                          color: AppColorData.cardNormalIconColour,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return PersonPhotoSelections(
                            eventCode: model.eventCode,
                            withoutFace: true,
                            appbarTitle: S.of(context).others,
                          );
                        }),
                      );
                    },
                    title: CommonText(
                      isCard: true,
                      isHighlightedCard: true,
                      text: S.of(context).others,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ))),
          )
        : SizedBox();
  }

  void setNotification(bool status) async {
    NotificationPreference notificationPreference = NotificationPreference();
    await notificationPreference.setNotifyBusy(status);
  }

  @override
  bool get wantKeepAlive => true;
}
