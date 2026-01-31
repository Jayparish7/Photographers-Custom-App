import 'package:photomall_flutter/core/constants/api_constants.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:share_plus/share_plus.dart';

class CommonShare {
  shareEvent(int id, String eventKey) {
    showLog("Event Type $id");
    if (id == userEvent) {
      Share.share(
          "I have shared digital album with you. Kindly download the Android app using the link https://play.google.com/store/apps/details?id=in.photomall.app.demostudio and use the event key $eventKey to view the album or click the following link https://ptml.in/$shareLinkUrl/$eventKey.");
    } else if (id == demoEvent || id == studioGalleyEvent) {
      Share.share(
          "I'm using this awesome app. Do check out! - https://play.google.com/store/apps/details?id=in.photomall.app.demostudio");
    }
  }
}
