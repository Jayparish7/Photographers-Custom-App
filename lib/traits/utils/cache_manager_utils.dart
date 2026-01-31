import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/studio_config_constants.dart';

class CacheUtil {
  var customCachedManager = CacheManager(
    Config(
      '$studioIdConfig',
      stalePeriod: const Duration(days: 365),
      maxNrOfCacheObjects: 10000,
    ),
  );

  Future<Uint8List?> getCacheFile({required String url}) async {
    showLog("getCacheFile url : $url");
    try {
     // Stream<FileResponse> file =
         // customCachedManager.getFileStream(url, withProgress: true);
      File file_ = await customCachedManager.getSingleFile(url);
      return file_.readAsBytesSync();
      /* if (!status) {

        FileInfo file =
            await customCachedManager.downloadFile(url, key: '$studioIdConfig');
        await customCachedManager.putFile(
          url,
          file.file.readAsBytesSync(),
          key: studioIdConfig,
          maxAge: const Duration(days: 365),
          eTag: file.originalUrl,
          fileExtension:
              extension.replaceAll(".", ""), // extension must not contain dot
        );
        showLog("the file is 1 .. ${file.originalUrl}");
        showLog("the file is 2.. ${file.file}");
        showLog("the file is 3 .. ${file.validTill}");
        showLog("the file is 4 .. ${file.source}");
        showLog("the file is.. ${file.file.dirname}");
        return file.file.readAsBytesSync();
      }
      else {
        Directory temp = await getTemporaryDirectory();
        showLog("Available in ${temp.path}/$studioIdConfig/$name$extension");

        String url = "${temp.path}/$studioIdConfig/$name$extension";
        File file = File(url);
        return file.readAsBytesSync();
      }*/
    } catch (e, s) {
      showLog("Error while save to cache memory$e $s ,");
      return null;
    }
  }

  Future<bool> isCacheFileExists(
    String imageName,
  ) async {
    String localPath;
    Directory directory = await getTemporaryDirectory();
    localPath = '${directory.path}/$studioIdConfig';
    showLog('checking in path $localPath/$imageName');
    return await File('$localPath/$imageName').existsSync();
  }
}
