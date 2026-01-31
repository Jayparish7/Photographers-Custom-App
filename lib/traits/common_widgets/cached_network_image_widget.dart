import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/traits/utils/cache_manager_utils.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';

import '../../generated/l10n.dart';

class CustomCachedNetworkImageWidget extends StatefulWidget {
  final String url;
  final BoxFit? fitSize;
  final int? memCacheHeight;

  CustomCachedNetworkImageWidget(
      {Key? key, required this.url, this.fitSize, this.memCacheHeight})
      : super(key: key);

  @override
  State<CustomCachedNetworkImageWidget> createState() =>
      _CustomCachedNetworkImageWidgetState();
}

class _CustomCachedNetworkImageWidgetState
    extends State<CustomCachedNetworkImageWidget> {
  CacheUtil cacheUtil = CacheUtil();
  CachedNetworkImageProvider? image;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    image = null;
  }

  @override
  void initState() {
    // TODO: implement initState
    showLog("image loading12 ..${widget.url}");
  }

  @override
  Widget build(BuildContext context) {
    CachedNetworkImage image = CachedNetworkImage(
        memCacheHeight: widget.memCacheHeight,
        fit: widget.fitSize,
        cacheManager: cacheUtil.customCachedManager,
        imageUrl: widget.url,
        errorWidget: (context, url, error) {
          showLog("Error12312 : $url");
          return FittedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColorData.iconColor,
                  size: 40,
                ),
                CommonText(
                  text: S.of(context).couldNotLoadThisImage,
                  style: Theme.of(context).textTheme.labelLarge,
                )
              ],
            ),
          );
        },
        progressIndicatorBuilder: (context, url, progress) {
             return  Container(
               color: Colors.transparent,
               child: Stack(
                 alignment: Alignment.center,
                 children: [
                   /*if (progress.isDownloading && progress.totalBytes != null)
                Text('${progress.downloadedBytes ~/ 1024} / ${progress.totalBytes! ~/ 1024} kb',
                    style: const TextStyle(color: Colors.red)),*/

                   SizedBox(
                       width: 120,
                       height: 120,
                       child: CommonCircularProgress(
                         value: progress.progress,
                         isPrintButton: true,
                       )),
                 ],
               ),
             );
        },
        /*placeholder: (
          a,
          b,
        ) {
          return CommonCircularProgress();
        }*/);
    return image;
  }
}
