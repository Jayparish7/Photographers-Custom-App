import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:photomall_flutter/controllers/download_files_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/traits/common_widgets/cached_network_image_widget.dart';

class ImageProcessor {
  Future<Size> getSizeOfImage(Uint8List file, String url) async {
    if (url != '' && url.isNotEmpty) {
      return await _calculateImageDimension(url);
    }

    Size size = ImageSizeGetter.getSize(MemoryInput(file));
    if (size.needRotate) {
      showLog('the rotate height where ${size}');
      return size;
    } else {
      return size;
    }
  }

  Future<Size> _calculateImageDimension(String url) {
    showLog('the url where 1 > ${url}');
    Completer<Size> completer = Completer();
    Image image = Image.network(url, errorBuilder:
        (BuildContext context, Object exception, StackTrace? stackTrace) {
      return const Text('ð¢');
    });
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width, myImage.height);
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }

  Widget getImageView({
    required appDb.JvtFile file,
    String? privateStoragePath,
    required String publicStoragePath,
    String? documentPath,
    required Function onTap,
    BoxFit? boxFit,
    double? height,
    Widget? waitingChild,
    Widget? errorWidget,
    double? width,
  }) {
    DownloadFilesController downloadFilesController = DownloadFilesController();
    return InkWell(
      onTap: () async {
        onTap();
      },
      child: CustomCachedNetworkImageWidget(
        fitSize: boxFit,
        url: downloadFilesController.createUrl(
            file: file,
            privatePath: privateStoragePath ?? "",
            publicPath: publicStoragePath),
        //     height: height,
      ),
    );
  }
}
