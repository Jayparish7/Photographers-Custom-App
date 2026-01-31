import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photomall_flutter/controllers/pm_job_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/services/image_handler.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/traits/utils/storage_utils.dart';

class FileUtil {
  static File convertUint8ListToFile(Uint8List bytes) {
    return File.fromRawPath(bytes);
  }

  Future<Uint8List?> getFile(String fileName, {String? documentPath}) async {
    String localPath;
    if (documentPath == null) {
      localPath = await getDocumentDirectoryPath();
    } else {
      showLog('FileUtil :: getFile : Path available');
      localPath = documentPath;
    }

    showLog('FileUtil :: getFile :: $localPath/$fileName');
    return null;
  }

  Future<Uint8List?> getDownloaded(appDb.JvtFile jvtFile,
      {DownloadPath? downloadPath}) async {
    showLog(
        'Local method called ${DateTime.now().minute} : ${DateTime.now().second} : ${DateTime.now().millisecond}');

    if (studioPrivatePath == null ||
        studioPublicPath == null ||
        appDocumentDirectoryPath == null) {
      EssentialUtils essentialUtils = EssentialUtils();
      essentialUtils.loadAppEssentialData();
      downloadPath = DownloadPath(
        private: studioPrivatePath,
        public: studioPublicPath,
        DocumentPath: appDocumentDirectoryPath,
      );
    } else {
      downloadPath = DownloadPath(
        private: studioPrivatePath,
        public: studioPublicPath,
        DocumentPath: appDocumentDirectoryPath,
      );
    }
    Stopwatch stopwatch = new Stopwatch()..start();
    Uint8List? a;
    showLog("File description::${stopwatch.elapsed.inMilliseconds}");
    return a;
  }

  Future<String> getDocumentDirectoryPath() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    return documentDirectory.path;
  }

  static CdnImage getFileNameAndExtensionFromCdnPath(String imageUrl) {
    var name = "";
    var extension = "";
    if (imageUrl
            .substring(imageUrl.lastIndexOf("/") + 1, imageUrl.length)
            .lastIndexOf(".") ==
        -1) {
      name = imageUrl.substring(imageUrl.lastIndexOf("/") + 1, imageUrl.length);
      extension = ".jpeg";
    } else {
      name = imageUrl.substring(
          imageUrl.lastIndexOf("/") + 1, imageUrl.lastIndexOf("."));
      extension =
          imageUrl.substring(imageUrl.lastIndexOf("."), imageUrl.length);
    }
    showLog(
        "InsertEvents :: getImageNameAndExtensionFromCdnPath() :: $name :: $extension");
    return CdnImage(name: name, extension: extension);
  }

  Future<Uint8List?> getLocalFile(
      {BuildContext? context,
      appDb.JvtFile? jvtFile,
      String? isFromGallery}) async {
    return null;
  }

  Future<Uint8List> getCacheFileFile(String fileName,
      {String? documentPath}) async {
    String localPath;
    if (documentPath == null) {
      Directory directory = await getTemporaryDirectory();
      localPath = '${directory.path}/customCacheKey';
    } else {
      showLog('FileUtil :: getFile : Path available');
      localPath = documentPath;
    }

    showLog('FileUtil :: getFile :: $localPath/$fileName');
    return await File('$localPath/$fileName').readAsBytes();
  }

  static String getFileNameFromURL(String url) {
    var fileName = url;
    if (fileName != '' && fileName.contains('/')) {
      var lastIndex = fileName.lastIndexOf('/') + 1;
      fileName = fileName.substring(lastIndex);
    }
    return fileName;
  }

  static String addImageExtensionIfRequired(String imageName) {
    String extension = getImageExtension(imageName);
    if (!imageName.endsWith(extension)) {
      imageName = imageName + getImageExtension(imageName);
    }
    return imageName;
  }

  ImageSize? getHeightOfFirstImage(Uint8List file) {
    try {
      // Image _image = Image.memory(file);
      final size = ImageSizeGetter.getSize(MemoryInput(file));
      if (size.needRotate) {
        print('getHeightOfFirstImage if');
        final width = size.height;
        final height = size.width;
        return ImageSize(height: height, width: width);
      } else {
        print('getHeightOfFirstImage else');
        return ImageSize(height: size.height, width: size.width);
      }
    } catch (e) {
      return null;
    }
  }

  static getFileExtension(String fileName) {
    String extension = "";
    if (fileName != '' && fileName.contains('.')) {
      var lastIndex = fileName.lastIndexOf('.') + 1;
      extension = fileName.substring(lastIndex);
    }
    return extension;
  }
}

class CdnImage {
  String? name;
  String? extension;

  CdnImage({this.name, this.extension});
}

class ImageSize {
  int? height;
  int? width;

  ImageSize({this.height, this.width});
}

class TwoValue {
  bool? isNetwork;
  String? NetworkUrl;

  TwoValue({this.isNetwork, this.NetworkUrl});
}
