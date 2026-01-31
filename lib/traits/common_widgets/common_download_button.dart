import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/download_files_controller.dart';
import 'package:photomall_flutter/controllers/download_status_controller.dart';
import 'package:photomall_flutter/controllers/event_controller.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/Utils/file_util.dart';
import 'package:photomall_flutter/core/Utils/permissionUtils/permission_utils.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;
import 'package:photomall_flutter/core/notification/notification_utils.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/album_dao.dart';
import 'package:photomall_flutter/driftdb/dao/common_key_value.dart';
import 'package:photomall_flutter/driftdb/dao/download_status_dao.dart';
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/dao/file_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_images_dao.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/traits/download_method.dart';
import 'package:photomall_flutter/traits/utils/cache_manager_utils.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/shared_preference_constants.dart';

class CommonFolderDownloadButton extends StatefulWidget {
  final String? folderCode;
  final bool? isDownloading;
  final Function onPress;

  CommonFolderDownloadButton(
      {Key? key,
      this.folderCode,
      this.isDownloading = false,
      required this.onPress})
      : super(key: key);

  @override
  State<CommonFolderDownloadButton> createState() =>
      _CommonFolderDownloadButtonState();
}

class _CommonFolderDownloadButtonState
    extends State<CommonFolderDownloadButton> {
  final ValueNotifier<int> downloadedCount = ValueNotifier<int>(0);
  final ValueNotifier<int> totalCount = ValueNotifier<int>(0);
  final ValueNotifier<bool> downloadState = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool?>(
        valueListenable: downloadState,
        builder: (BuildContext context, bool? value, child) {
          return AnimatedCrossFade(
            duration: Duration(milliseconds: 800),
            firstChild: InkWell(
                onTap: () async {
                  downloadState.value = true;
                  double requiredSpace = 0;
                  //double? availableSpace = await DiskSpacePlus.getFreeDiskSpace;
                  EventController eventController = EventController();
                  PhotoSelectionImagesModelDao photoSelectionImagesModelDao =
                      PhotoSelectionImagesModelDao();
                  appDb.Event? event = await eventController
                      .getEventByFolderCode(widget.folderCode!);
                  List<DownloadImageModel>? jvtFiles =
                      await photoSelectionImagesModelDao
                          .getEventPhotoSelectionImages(event!.code);
                  CommonKeyValueDao commonKeyValueDao = CommonKeyValueDao();
                  showLog('data data${jvtFiles!.length}');
                  // cancel all previous download
                  await commonKeyValueDao.deleteAllCommonTable();
                  // initiate download
                  await commonKeyValueDao.insertCommonTable(
                      DownloadStatus, event.code);
                  widget.onPress();
                  try {
                    for (DownloadImageModel file in jvtFiles) {
                      requiredSpace += file.file!.size;
                    }
                    totalCount.value = jvtFiles.length;
                  } catch (e) {
                    showLog("Image downloading error :::: $e");
                  }
                  /*bool status = checkStorage(
                      availableSpace: availableSpace!,
                      requiredSpace: requiredSpace);
                  if (!status) {
                    downloadFailedStorage();
                    return;
                  }
*/
                  await saveToMobileGallery(
                      context: context,
                      folderCode: widget.folderCode!,
                      eventCode: event.code,
                      eventName: event.name!,
                      iconEnabled: event.withIcon,
                      waterMarkEnabled: event.withWaterMark,
                      jvtFiles: jvtFiles);
                  if (context.mounted) {
                    ToastUtil.showSnackBarAtCurrentState(
                      S.of(context).downloaded,
                      seconds: 3,
                      actions: SnackBarAction(
                        label: 'open', // or some operation you would like
                        onPressed: () async {
                          openPath();
                        },
                      ),
                    );
                  }

                  downloadState.value = false;
                  await commonKeyValueDao.deleteCommonTableByEvent(event.code);
                  widget.onPress();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.download,
                      size: 20,
                      color: AppColorData.buttonTextColors,
                    ),
                    /* SizedBox(
                      width: 3,
                    ),*/
                    /*  CommonText(
                      text: S.of(context).download,
                      isButton: true,
                    )*/
                  ],
                )),
            secondChild: widget.isDownloading != true
                ? SizedBox(
                    height: 50,
                    width: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ))
                : ValueListenableBuilder<int>(
                    valueListenable: totalCount,
                    builder: (BuildContext context, int value, child) {
                      return showDownloadCount();
                    }),
            crossFadeState:
                value! ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          );
        });
  }

  Widget showDownloadCount() {
    return CommonText(
      text:
          "${S.of(context).downloading} ${totalCount.value} ${S.of(context).images}",
      isButton: true,
    );
  }

  bool checkStorage({double? availableSpace, requiredSpace}) {
    // converted to mega bytes
    requiredSpace = (requiredSpace / 1024) / 1024;
    // add extra 300 mb space for user friendliness
    requiredSpace = requiredSpace + 300;
    if (requiredSpace < availableSpace) {
      return true;
    } else {
      return false;
    }
  }

  void downloadFailed() {
    downloadState.value = false;
    showLog("Download method toast::2");
    ToastUtil.showSnackBarAtCurrentState(S.of(context).downloadFailed);
  }

  void downloadFailedStorage() {
    downloadState.value = false;
    showLog("Download method toast::3");
    ToastUtil.showSnackBarAtCurrentState(S.of(context).storageFull);
  }

  void downloadFailedNotDownloaded() {
    downloadState.value = false;
    showLog("Download method toast::4");
    ToastUtil.showSnackBarAtCurrentState(
        " ${S.of(context).downloadFailed}\n${S.of(context).tryAfterSomeTimes}");
  }

  Future<bool?> saveToMobileGallery(
      {required String folderCode,
      required BuildContext context,
      required String eventName,
      required bool iconEnabled,
      required bool waterMarkEnabled,
      required String eventCode,
      required List<DownloadImageModel> jvtFiles}) async {
    bool _status = await PermissionUtils.getDownloadPermission(context);
    if (!_status) {
      return false;
    }

    Uint8List? file;
    String fileName;

    TransporterPreference transporterPreference = TransporterPreference();
    transporter.TransportModel? appConfig =
        await transporterPreference.getAppConfig();
    String? folderName = appConfig!.studioData!.data!.name;

    //  String originalFolderName = appConfig.photoSelectionData[index].code;
    FileModelDao fileModelDao = FileModelDao();
    DownloadFilesController downloadFilesController = DownloadFilesController();
    appDb.JvtFile? fileLogo = await fileModelDao.getStudioIcon();
    appDb.JvtFile? waterMarkLogo =
        await fileModelDao.getWaterMarkIcon(eventCode);
    showLog('waterMarkLogo 1---1 $eventCode $fileLogo');
    (waterMarkLogo != null) ? fileLogo = waterMarkLogo : fileLogo;
    appDb.JvtFile? fileQR = await fileModelDao.getEventQr(eventCode);
    Uint8List? studioLogo;
    Uint8List? qr;
    CacheUtil cacheUtil = CacheUtil();
    if (fileLogo != null) {
      studioLogo = await cacheUtil.getCacheFile(
        url: downloadFilesController.createUrl(
          file: fileLogo,
          privatePath: studioPrivatePath!,
          publicPath: studioPublicPath!,
        ),
        /*name: fileLogo.name,
          extension: fileLogo.extension*/
      );
    }
    if (fileQR != null) {
      qr = await cacheUtil.getCacheFile(
        url: downloadFilesController.createUrl(
          file: fileQR,
          privatePath: studioPrivatePath!,
          publicPath: studioPublicPath!,
        ),
      );
    }
    if (folderCode != '') {
      showLog("the number of images  ${jvtFiles.length} :: $eventName  4");
      DownloadFilesController downloadFilesController =
          DownloadFilesController();
      CacheUtil cacheUtil = CacheUtil();
      String? originalName = "";

      final int progressId = 154;
      int maxProgress = totalCount.value;
      NotificationUtils notificationUtils = NotificationUtils();
      int downloadedCount = 1;
      int j = 1;

      CommonKeyValueDao commonKeyValueDao = CommonKeyValueDao();

      for (int i = 0; i < jvtFiles.length; i++) {
        bool status = await commonKeyValueDao.getDownloadStatus(eventCode);
        if (!status) {
          showLog("Canceled..");
          await notificationUtils.showProgressNotification(
              progressId,
              "Download cancelled",
              "Image download has been cancelled",
              j,
              maxProgress,
              false,
              eventCode);
          return false;
        }

        if (jvtFiles[i].photoSelectionImages != null) {
          originalName = jvtFiles[i].photoSelectionImages!.originalName;
        }

        if (originalName == null) {
          fileName = '${jvtFiles[i].file!.name}${jvtFiles[i].file!.extension}';
        } else {
          fileName = "${jvtFiles[i].photoSelectionImages!.originalName}";
        }
        file = await cacheUtil.getCacheFile(
          url: downloadFilesController.createUrl(
            file: jvtFiles[i].file!,
            publicPath: studioPublicPath!,
            privatePath: studioPrivatePath!,
          ),
        );
        showLog("$i File :$file name: $fileName");
        showLog("name: $fileName");
        if (file != null) {
          await saveToGallery(
              eventCode: eventCode,
              context: context,
              iconEnabled: iconEnabled,
              waterMarkEnabled: waterMarkEnabled,
              file: file,
              fileName: fileName,
              folderName: folderName!,
              eventName: eventName,
              logo: studioLogo,
              qr: qr,
              code: jvtFiles[i].photoSelectionImages!.code,
              type: TransportDataKeys.photoSelectionImages);
        }
        originalName = "";
        totalCount.value--;
        downloadedCount++;
        j++;
        if (j <= maxProgress) {
          await notificationUtils.showProgressNotification(
              progressId,
              downloadedCount == maxProgress ? "Downloaded" : "Downloading",
              "$downloadedCount/$maxProgress",
              j,
              maxProgress,
              true,
              eventCode);
        }
      }
      showLog("end====");
      downloadedCount = 0;
      j = 0;
      return true;
    }
    return null;
  }
}

Future saveToGallery({
  required BuildContext context,
  required bool iconEnabled,
  required String folderName,
  required String eventName,
  required String fileName,
  required Uint8List file,
  Uint8List? logo,
  Uint8List? qr,
  required bool waterMarkEnabled,
  required String eventCode,
  required String code,
  required String type,
}) async {
  // iconEnabled = true;
  // waterMarkEnabled = true;
  double watermarkOpacity = .5;
  String watermarkPosition = 'left';
  double watermarkSize = 0.0;
  DownloadStatusController downloadStatusController =
      DownloadStatusController();
  FileUtil fileUtil = FileUtil();
  Directory directory;
  // try {
  if (Platform.isAndroid) {
    directory = Directory(
        '/storage/emulated/0/Download'); // This will work only for Android, not for iOS
    String newPath = "";
    List<String> paths = directory.path.split("/");
    for (int x = 1; x < paths.length; x++) {
      String folder = paths[x];
      if (folder != "Android") {
        newPath += "/" + folder;
      } else {
        break;
      }
    }
    if (folderName != '') {
      if (eventName != '' && eventName != "") {
        newPath = newPath + "/$folderName" + "/$eventName";
      } else {
        newPath = newPath + "/$folderName" + "/Event";
      }
    } else {
      newPath = newPath + "/YourImages";
    }

    directory = Directory(newPath);
  } else {
    directory = await getTemporaryDirectory();
  }

  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  if (await directory.exists()) {
    File saveFile = File(directory.path + "/$fileName");

    showLog("don't copy and $saveFile");

    /// xxx check photo where downloaded xxx
    bool downloadStatus = await downloadStatusController.isImageDownload(
        filePath: saveFile.path, code: code, type: type);
    if (downloadStatus) {
      showLog("don't copy and return ::");
      return false;
    }
    ImageSize? imageSize = fileUtil.getHeightOfFirstImage(file);
    ImageSize? logoSize = fileUtil.getHeightOfFirstImage(logo!);

    showLog("ImageSize > ${imageSize?.height} x ${imageSize?.width} ");
    showLog("logoSize > ${logoSize?.height} x ${logoSize?.width} ");

    ImageSizeValues imageSizeValues = getIconDisplaySize(imageSize!, logoSize!);
    Uint8List image = file;
    double height = double.parse("${imageSize.height!}");
    double width = double.parse("${imageSize.width!}");
    if (!iconEnabled && !waterMarkEnabled) {
      showLog("both are false >>>>");
      image = file;
      final convert = img.decodeImage(image);
      showLog('copying ...');
      File(saveFile.path).writeAsBytesSync(img.encodeJpg(convert!));
      await ImageGallerySaverPlus.saveFile(saveFile.path);

      showLog('copied 1 ...');
      DownloadStatusModelDao downloadStatusModelDao = DownloadStatusModelDao();
      await downloadStatusModelDao.insertDownloadStatus(code, type, true);
      return true;
    }
    if (waterMarkEnabled) {
      final controller = ScreenshotController();
      List<String> waterMarkDetails =
          await getWatermarkDetails(eventCode) ?? [];
      // await prefs.getStringList(waterMarkDetailsKey) ?? [];

      showLog('waterMarkEnabled $waterMarkDetails');
      if (waterMarkDetails.isNotEmpty) {
        watermarkPosition = waterMarkDetails[0];
        watermarkOpacity = double.parse(waterMarkDetails[1]);
        watermarkSize = ((double.parse(waterMarkDetails[2]) / 2) / 100) * 512;
        ;
      }
      //position?[0] as Alignment
      image = await controller.captureFromWidget(
          targetSize: Size(width, height),
          Stack(
            alignment: _getAlignment(watermarkPosition),
            children: [
              Image.memory(
                file,
                height: double.parse("${imageSize.height!}"),
                width: double.parse("${imageSize.width!}"),
              ),
              Align(
                alignment: _getAlignment(watermarkPosition),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Image.memory(
                    logo,
                    opacity: AlwaysStoppedAnimation(watermarkOpacity),
                    fit: BoxFit.contain,
                    height: watermarkSize,
                    width: watermarkSize,
                  ),
                ),
              ),
            ],
          ));
      showLog('WaterMark${imageSize.height!}X${imageSize.width!}');
      showLog('WaterMark1${imageSizeValues.height}X${imageSizeValues.width}');
    }
    if (iconEnabled && qr != null) {
      final controller = ScreenshotController();
      image = await controller.captureFromWidget(
          //   targetSize: Size(width, height),
          Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              child: Image.memory(
            image,
            //    width: double.parse("${imageSize.width}"),
            //   height:double.parse("${imageSize.height}"),
          )),
          Container(
            width: double.parse("${imageSize.width}"),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColorData.sideDrawerBackgroundColors,
                stops: AppColorData.sideDrawerStops,
                begin: AppColorData.sideDrawerBackgroundBegin,
                end: AppColorData.sideDrawerBackgroundEnd,
              ),
              //  boxShadow: [BoxShadow(color: Theme.of(context).accentColor)],
            ),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Text(
                      folderName,
                      style: TextStyle(
                        color: AppColorData.sideDrawerUnselectedTextColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Image.memory(
                    qr,
                    height: 50,
                    fit: BoxFit.fitHeight,
                  )
                ],
              ),
            ),
          )
        ],
      ));
    }
    if (!iconEnabled && !waterMarkEnabled) {
      showLog("both are false >>>>");
      image = file;
    }
    final convert = img.decodeImage(image);
    showLog('copying ...');
    File(saveFile.path).writeAsBytesSync(img.encodeJpg(convert!));

    await ImageGallerySaverPlus.saveFile(saveFile.path);

    showLog('copied ...2');

    DownloadStatusModelDao downloadStatusModelDao = DownloadStatusModelDao();
    await downloadStatusModelDao.insertDownloadStatus(code, type, true);
  }
  return true;
  // } catch (e) {
  // showLog('cant copy file to gallery $e');
  // return false;
  //}
}

Future<List<String>?> getWatermarkDetails(String eventCode) async {
  // Access SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieve the stored JSON string
  String? waterMarkMapString = await prefs.getString(waterMarkDetailsKey);

  if (waterMarkMapString != null) {
    // Decode the JSON string back into a map
    Map<String, List<String>> waterMarkMap = Map<String, List<String>>.from(
        jsonDecode(waterMarkMapString)
            .map((key, value) => MapEntry(key, List<String>.from(value))));

    // Return the details for the specific event code if it exists
    return waterMarkMap[eventCode];
  }

  return null; // Return null if the data is not available
}

Alignment _getAlignment(String position) {
  switch (position) {
    case 'top-left':
      return Alignment.topLeft;
    case 'top':
      return Alignment.topCenter;
    case 'top-right':
      return Alignment.topRight;
    case 'left':
      return Alignment.centerLeft;
    case 'center':
      return Alignment.center;
    case 'right':
      return Alignment.centerRight;
    case 'bottom-left':
      return Alignment.bottomLeft;
    case 'bottom':
      return Alignment.bottomCenter;
    case 'bottom-right':
      return Alignment.bottomRight;
    default:
      return Alignment.centerLeft; // Default alignment if unknown position
  }
}

ImageSizeValues getIconDisplaySize(ImageSize imageSize, ImageSize logoSize) {
  double reducePercentage = 0.15;
  showLog("the icon ${logoSize.height} x ${logoSize.width}");
  showLog("the Image ${imageSize.height} x ${imageSize.width}");
  double calculatedWidth = imageSize.width! * reducePercentage;
  double calculatedHeight = 0.0;

  if (calculatedWidth < double.parse("${logoSize.width}")) {
    calculatedHeight = (logoSize.height! / logoSize.width!) * (calculatedWidth);
  } else {
    calculatedHeight = double.parse('${logoSize.height!}');
  }
  showLog("the size got ${calculatedHeight}x${calculatedWidth}");
  return ImageSizeValues(height: calculatedHeight, width: calculatedWidth);
  // }
}

class CommonFileDownloadButton extends StatefulWidget {
  final String url;
  final String orderCode;
  final String? albumCode;
  final String? eventCode;
  final String? originalName;
  final String extension;
  final bool isFromPhotoSelection;

  CommonFileDownloadButton({
    Key? key,
    required this.url,
    this.albumCode,
    this.eventCode,
    this.originalName,
    this.extension = '.jpeg',
    this.isFromPhotoSelection = false,
    required this.orderCode,
  }) : super(key: key);

  @override
  State<CommonFileDownloadButton> createState() =>
      _CommonFileDownloadButtonState();
}

class _CommonFileDownloadButtonState extends State<CommonFileDownloadButton> {
  final ValueNotifier<bool> downloadState = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    showLog(
        'orderCode ${widget.url} ${widget.orderCode} ${widget.albumCode},${widget.eventCode} ${widget.orderCode},${widget.extension}');

    return ValueListenableBuilder<bool?>(
        valueListenable: downloadState,
        builder: (BuildContext context, bool? value, child) {
          return AnimatedCrossFade(
            duration: Duration(milliseconds: 800),
            firstChild: InkWell(
                onTap: () async {
                  try {
                    showLog('InkWell');
                    bool _status =
                        await PermissionUtils.getDownloadPermission(context);
                    if (!_status) {
                      return;
                    }
                    Uint8List? studioLogo;
                    Uint8List? qr;
                    CacheUtil cacheUtil = CacheUtil();
                    String folderName = '';
                    downloadState.value = true;
                    DownloadFilesController downloadFilesController =
                        DownloadFilesController();
                    EventModelDao eventModelDao = EventModelDao();
                    FileModelDao fileModelDao = FileModelDao();
                    appDb.JvtFile? fileLogo =
                        await fileModelDao.getStudioIcon();
                    appDb.JvtFile? waterMarkLogo =
                        await fileModelDao.getWaterMarkIcon(widget.eventCode!);
                    (waterMarkLogo != null)
                        ? fileLogo = waterMarkLogo
                        : fileLogo;
                    showLog('waterMarkLogo 2 ${widget.eventCode} $fileLogo');

                    if (fileLogo != null) {
                      CacheUtil cacheUtil = CacheUtil();
                      studioLogo = await cacheUtil.getCacheFile(
                        url: downloadFilesController.createUrl(
                          file: fileLogo,
                          privatePath: studioPrivatePath!,
                          publicPath: studioPublicPath!,
                        ),
                        /*   name: fileLogo.name,
                          extension: fileLogo.extension*/
                      );
                    }

                    if (appStudioName != null) {
                      folderName = appStudioName!;
                    } else {
                      EssentialUtils essentialUtils = EssentialUtils();
                      await essentialUtils.loadAppEssentialData();
                      folderName = appStudioName!;
                    }
                    bool iconEnabled = false;
                    bool waterMarkEnabled = false;
                    String? eventName;
                    if (widget.albumCode != null) {
                      AlbumModelDao albumModelDao = AlbumModelDao();
                      appDb.Album? album = await albumModelDao
                          .getSingleAlbumWhereCode(widget.albumCode!);
                      appDb.Event? event =
                          await eventModelDao.getEventByCode(album!.eventCode);
                      iconEnabled = event?.withIcon ?? false;
                      waterMarkEnabled = event?.withWaterMark ?? false;
                      eventName = event?.name ?? "event";
                      appDb.JvtFile? fileQR =
                          await fileModelDao.getEventQr(album.eventCode);
                      if (fileQR != null) {
                        qr = await cacheUtil.getCacheFile(
                          url: downloadFilesController.createUrl(
                            file: fileQR,
                            privatePath: studioPrivatePath!,
                            publicPath: studioPublicPath!,
                          ),
                        );
                      }
                    } else {
                      if (widget.eventCode != null) {
                        appDb.Event? event = await eventModelDao
                            .getEventByCode(widget.eventCode!);
                        iconEnabled = event?.withIcon ?? false;
                        waterMarkEnabled = event?.withWaterMark ?? false;
                        eventName = event?.name ?? "event";
                        appDb.JvtFile? fileQR =
                            await fileModelDao.getEventQr(widget.eventCode!);
                        if (fileQR != null) {
                          qr = await cacheUtil.getCacheFile(
                            url: downloadFilesController.createUrl(
                              file: fileQR,
                              privatePath: studioPrivatePath!,
                              publicPath: studioPublicPath!,
                            ),
                          );
                        }
                      }
                    }
                    showLog('file getCacheFile ${widget.url}');
                    Uint8List? file =
                        await cacheUtil.getCacheFile(url: widget.url);
                    String extension = widget.extension;
                    String fileName = widget.originalName ??
                        "${widget.url.split('/').last}.$extension";

                    showLog(extension);
                    showLog(' >>>>> >>>>> >>>> ${widget.originalName}');
                    showLog(' >>>>> >>>>> >>>> $fileName');
                    if (file == null) {
                      return;
                    }

                    await saveToGallery(
                        context: context,
                        iconEnabled: iconEnabled,
                        waterMarkEnabled: waterMarkEnabled,
                        file: file,
                        fileName: '$fileName',
                        folderName: folderName,
                        eventName: eventName ?? "event",
                        logo: studioLogo,
                        qr: qr,
                        type: TransportDataKeys.orders,
                        code: widget.orderCode,
                        eventCode: widget.eventCode!);
                    downloadState.value = false;
                    ToastUtil.showSnackBarAtCurrentState(
                      S.of(context).downloaded,
                      seconds: 3,
                      actions: SnackBarAction(
                        label: 'open', // or some operation you would like
                        onPressed: () async {
                          openPath();
                        },
                      ),
                    );
                  } catch (e, s) {
                    showLog("some thing went wrong on download image $e , $s");
                    downloadState.value = false;
                    downloadFailed();
                  }
                },
                child: Icon(
                  Icons.download,
                  size: 35,
                  color: (widget.isFromPhotoSelection)
                      ? AppColorData.appBarTextColor
                      : AppColorData.buttonTextColors,
                )),
            secondChild: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                color: AppColorData.buttonTextColors,
              ),
            ),
            crossFadeState:
                value! ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          );
        });
  }

  bool checkStorage({double? availableSpace, requiredSpace}) {
    // converted to mega bytes
    requiredSpace = (requiredSpace / 1024) / 1024;
    // add extra 300 mb space for user friendliness
    requiredSpace = requiredSpace + 300;
    if (requiredSpace < availableSpace) {
      return true;
    } else {
      return false;
    }
  }

  void downloadFailed() {
    downloadState.value = false;
    showLog("Download method toast::2");
    ToastUtil.showSnackBarAtCurrentState(S.of(context).downloadFailed);
  }

  void downloadFailedStorage() {
    downloadState.value = false;
    showLog("Download method toast::3");
    ToastUtil.showSnackBarAtCurrentState(S.of(context).storageFull);
  }

  void downloadFailedNotDownloaded() {
    downloadState.value = false;
    showLog("Download method toast::4");
    ToastUtil.showSnackBarAtCurrentState(
        " ${S.of(context).downloadFailed}\n${S.of(context).tryAfterSomeTimes}");
  }
}



class ImageSizeValues {
  final double height;
  final double width;

  ImageSizeValues({this.height = 0.0, this.width = 0.0});
}

void openPath() async {
  showLog(">>>>>>>> 1");
  var androidInfo = await DeviceInfoPlugin().androidInfo;
  var sdkInt = androidInfo.version.sdkInt;
  if (sdkInt > 28) {
    failedToOpen();
  } else {
    try {
      Directory directory = Directory(
          '/storage/emulated/0/Download'); // This will work only for Android, not for iOS
      showLog(">>>>>>>> 2");

      if (directory.existsSync()) {
        showLog(">>>>>>>> 3");
      } else {
        showLog(">>>>>>>> 4");

        failedToOpen();
      }
    } catch (e) {
      showLog(">>>>>>>>$e");
      failedToOpen();
    }
  }
}

void failedToOpen() {
  ToastUtil.showSnackBarAtCurrentState(
    "Open Downloads\nThe downloaded file will be in the Downloads Directory",
    seconds: 5,
  );
}


Future<void> handleFileDownload({
  required BuildContext context,
  required String url,
  required String extension,
  required String? originalName,
  required String? eventCode,
  required String? albumCode,
  required String? orderCode,
}) async {
  try {
    showLog('InkWell');
    bool _status = await PermissionUtils.getDownloadPermission(context);
    if (!_status) {
      return;
    }

    Uint8List? studioLogo;
    Uint8List? qr;
    CacheUtil cacheUtil = CacheUtil();
    String folderName = '';
    DownloadFilesController downloadFilesController = DownloadFilesController();
    EventModelDao eventModelDao = EventModelDao();
    FileModelDao fileModelDao = FileModelDao();
    appDb.JvtFile? fileLogo = await fileModelDao.getStudioIcon();
    appDb.JvtFile? waterMarkLogo = await fileModelDao.getWaterMarkIcon(eventCode!);
    fileLogo = waterMarkLogo ?? fileLogo;
    showLog('waterMarkLogo 2 $eventCode $fileLogo');

    if (fileLogo != null) {
      studioLogo = await cacheUtil.getCacheFile(
        url: downloadFilesController.createUrl(
          file: fileLogo,
          privatePath: studioPrivatePath!,
          publicPath: studioPublicPath!,
        ),
      );
    }

    if (appStudioName != null) {
      folderName = appStudioName!;
    } else {
      EssentialUtils essentialUtils = EssentialUtils();
      await essentialUtils.loadAppEssentialData();
      folderName = appStudioName!;
    }

    bool iconEnabled = false;
    bool waterMarkEnabled = false;
    String? eventName;

    if (albumCode != null) {
      AlbumModelDao albumModelDao = AlbumModelDao();
      appDb.Album? album = await albumModelDao.getSingleAlbumWhereCode(albumCode);
      appDb.Event? event = await eventModelDao.getEventByCode(album!.eventCode);
      iconEnabled = event?.withIcon ?? false;
      waterMarkEnabled = event?.withWaterMark ?? false;
      eventName = event?.name ?? "event";

      appDb.JvtFile? fileQR = await fileModelDao.getEventQr(album.eventCode);
      if (fileQR != null) {
        qr = await cacheUtil.getCacheFile(
          url: downloadFilesController.createUrl(
            file: fileQR,
            privatePath: studioPrivatePath!,
            publicPath: studioPublicPath!,
          ),
        );
      }
    } else if (eventCode != '') {
      appDb.Event? event = await eventModelDao.getEventByCode(eventCode);
      iconEnabled = event?.withIcon ?? false;
      waterMarkEnabled = event?.withWaterMark ?? false;
      eventName = event?.name ?? "event";

      appDb.JvtFile? fileQR = await fileModelDao.getEventQr(eventCode);
      if (fileQR != null) {
        qr = await cacheUtil.getCacheFile(
          url: downloadFilesController.createUrl(
            file: fileQR,
            privatePath: studioPrivatePath!,
            publicPath: studioPublicPath!,
          ),
        );
      }
    }

    showLog('file getCacheFile $url');
    Uint8List? file = await cacheUtil.getCacheFile(url: url);
    String fileName = originalName ?? "${url.split('/').last}.$extension";

    showLog(extension);
    showLog(' >>>>> >>>>> >>>> $originalName');
    showLog(' >>>>> >>>>> >>>> $fileName');

    if (file == null) {
      return;
    }

    await saveToGallery(
      context: context,
      iconEnabled: iconEnabled,
      waterMarkEnabled: waterMarkEnabled,
      file: file,
      fileName: fileName,
      folderName: folderName,
      eventName: eventName ?? "event",
      logo: studioLogo,
      qr: qr,
      type: TransportDataKeys.orders,
      code: orderCode!,
      eventCode: eventCode,
    );


  } catch (e, s) {
    showLog("Something went wrong on download image: $e, $s");
  }
}
