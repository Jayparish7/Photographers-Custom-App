import 'package:flutter/material.dart';
import 'package:photomall_flutter/controllers/event_controller.dart';
import 'package:photomall_flutter/controllers/studio_data_controller.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/traits/common_widgets/common_card.dart';
import 'package:photomall_flutter/ui/event/detail/info/event_info_data_view_model.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_alert_dialog.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_button.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text_button.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toast/toast.dart';
import '../../../../generated/l10n.dart';

class ArchiveWidget extends StatefulWidget {
  final String? eventCode;
  final BuildContext? context;
  final EventInfoDataViewModel? model;
  final bool? isOwenEvent;

  ArchiveWidget(
      {Key? key, this.eventCode, this.context, this.model, this.isOwenEvent})
      : super(key: key);

  @override
  State<ArchiveWidget> createState() => _ArchiveWidgetState();
}

class _ArchiveWidgetState extends State<ArchiveWidget> {
  @override
  void initState() {
    super.initState();
    showLog("widget.isOwenEvent :: ${widget.isOwenEvent}");
  }

  @override
  Widget build(BuildContext context) {
    StudioDataController studioDataController = StudioDataController();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: IntrinsicHeight(
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: CommonText(
              //       text: S
              //           .of(context)
              //           .justClickOnTheButtonAndShareThisEventWith,
              //       style: Theme.of(context).textTheme.titleMedium,
              //       textAlign: TextAlign.center),
              // ),
              //
              // (widget.isOwenEvent == true)
              //     ? Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: CommonText(
              //             text: S
              //                 .of(context)
              //                 .noteThePhotoSelectionPortionWillNotBeShared,
              //             style: Theme.of(context).textTheme.labelMedium,
              //             textAlign: TextAlign.center),
              //       )
              //     : SizedBox(),
              EventQrCodeWidget(eventCode: widget.eventCode ??"",),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CommonButton(
                  buttonText: S.of(context).share,
                  showIcon: true,
                  //text: S.of(context).share,
                  icon: Icons.share,
                  onPressCall: () async {
                    if (isPhotomallApp) {
                      await widget.model!.sharePhotomallEvent();
                    } else {
                      Share.share(
                        "${await studioDataController.getStudioName()} has shared ${widget.model!.eventName} with you. Click the link "
                        "${await studioDataController.getPtmlDomin()}/${await studioDataController.getShortUrl()}/${widget.eventCode} to view",
                      );
                    }
                  },
                ),
              ),
              /// this command line are future enhancement to archived and delete options
              /*  Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    hasInternet = await InternetConnectionChecker().hasConnection;
                  if (hasInternet) {
                    showLog("Internet permission granted to archived");
                    await archiveEvent(context);
                  }
                  else {
                    showLog("Internet permission denied");
                    ToastUtil toast = ToastUtil();
                    ToastContext().init(context);
                    toast.showShortToast(context, S.of(context).yourOffline);
                    return;
                  }},
                  child: Column(
                    children: [
                      Icon(
                        Icons.archive,
                        size: 40,
                        color: AppColorData.bgIconColor,
                      ),
                      CommonText(
                        text: S.of(context).archive,
                        isTextButton: true,
                        //fontSize: TextProperty.hint,
                      ),
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                color: AppColorData.dividerColor,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    hasInternet = await InternetConnectionChecker().hasConnection;
                    if (hasInternet) {
                      showLog("Internet permission granted to deleted");
                     // await deleteEvent(context);
                    bool status =  await  showDialog(
                        context: context, builder: (BuildContext context) => deleteDialog(context));
                    if(status){
                      deleteEvent(context);
                    }

                    }
                    else{
                      showLog("Internet permission denied can't delete now");
                      ToastUtil toast = ToastUtil();
                      ToastContext().init(context);
                      toast.showShortToast(context, S.of(context).yourOffline);
                      return;
                    }
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.delete,
                        size: 40,
                        color: AppColorData.bgIconColor,
                      ),
                      CommonText(
                        isTextButton: true,
                        text: S.of(context).delete,
                        //fontSize: TextProperty.p1
                      ),
                    ],
                  ),
                ),
              )*/
            ],
          ),
        ),
      ),
    );
  }

  /// this methods are future enhancement to archived and delete options
  Widget deleteDialog(BuildContext context) {
    showLog("deleteDialog method worked");
    return CommonAlertDialog(
      title: S.of(context).delete,
      content: S.of(context).areYouSureYouWantToDeleteThisEventThis,
      actions: [
        CommonTextButton(
          buttonText: S.of(context).no,
          onPressCall: () {
            Navigator.pop(context, false);
          },
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.01,
        ),
        CommonButton(
          onPressCall: () {
            Navigator.pop(context, true);
          },
          buttonText: S.of(context).yes,
        ),
      ],
    );
  }

  Future<void> archiveEvent(BuildContext context) async {
    ToastContext().init(context);
    ToastUtil toastUtil = ToastUtil();
    EventController eventController = EventController();
    showLog("the event should be removed ${widget.eventCode}");
    // toggle event to archive
    bool status = await eventController.eventArchiveOrUnArchive(
        eventCode: widget.eventCode!, archiveStatus: true);
    if (status) {
      await toastUtil.showShortToast(
          context, S.of(context).archivedSuccessfully);
      Navigator.pop(context);
    } else {
      toastUtil.showShortToast(context,
          "${S.of(context).failedToArchive}\n${S.of(context).tryAfterSomeTime}");
    }
  }
}

class EventQrCodeWidget extends StatefulWidget {
  final String eventCode;
  const EventQrCodeWidget({super.key, required this.eventCode});

  @override
  State<EventQrCodeWidget> createState() => _EventQrCodeWidgetState();
}

class _EventQrCodeWidgetState extends State<EventQrCodeWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final qrData = widget.eventCode;
    return SizedBox(
      height: size.height*0.2,
      width: size.width*1,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              // Show download dialog when QR code is tapped
              /*showDialog(
                context: context,
                builder: (context) {
                  return getDownloadDialog(
                      model,
                      qrData,
                      context,
                      widget.eventName);
                },
              );*/
            },
            child: Stack(
              children: [
                QrImageView(
                  backgroundColor: Colors.white,
                  // White background for QR code
                  data: qrData,
                  version: QrVersions.auto,
                  size: 150.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
