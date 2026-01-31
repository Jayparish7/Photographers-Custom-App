import 'package:flutter/material.dart';

import '../constants/common_constants.dart';

class ScreenUtil{
  static bool isPortrait(BuildContext context){
   return MediaQuery.of(context).orientation ==
        Orientation.portrait;
  }

  static double getScreenWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  } static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }


  static bool checkNetworkImageOrientationISLandscape(String imageUrl) {
    Image image = Image.network(imageUrl);
    ImageStream stream = image.image.resolve(ImageConfiguration.empty);
    bool landScape = false;
    stream.addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        int width = info.image.width;
        int height = info.image.height;

        if (height > width) {
          showLog("Image is Portrait");
          landScape= false;

        } else {
          showLog("Image is Landscape");
          landScape =true;
        }
      }),
    );
    showLog("Image is landScape ${landScape}");

    return landScape;
  }

}