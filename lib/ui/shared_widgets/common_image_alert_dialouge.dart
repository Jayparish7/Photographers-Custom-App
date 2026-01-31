import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/traits/image_processor.dart';
import 'package:photomall_flutter/ui/album/photoselection/select/photo_selection_route_view_model.dart';

Widget imageDialog(PhotoSelectionImagesModel item, BuildContext context,
    {required String privateStoragePath, required String publicStoragePath}) {
  ImageProcessor imageProcessor = ImageProcessor();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);

  return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: imageProcessor.getImageView(
                file: item.file!,
                publicStoragePath: publicStoragePath,
                privateStoragePath: privateStoragePath,
                onTap: () {},
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: AppColorData.bgIconBackgroundColor,
                            begin: AppColorData.bgIconGradientBegin,
                            end: AppColorData.bgIconGradientEnd,
                            stops: AppColorData.bgIconStops,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.cancel,
                          color: AppColorData.bgIconColor,
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ));
}
