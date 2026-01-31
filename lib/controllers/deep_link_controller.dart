import 'package:flutter/material.dart';
import 'package:photomall_flutter/controllers/studio_data_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/main.dart';
import 'package:photomall_flutter/preference/preference_handler/redirection_preference_handler.dart';
import 'package:photomall_flutter/preference/preference_model/redirection_preference_model.dart';
import 'package:photomall_flutter/preference/redirection_route_constant.dart';

class DeepLinkingController {
  Future<void> setDeepLink(BuildContext? context, Uri link) async {
    ReDirectionPreference reDirectionPreference = ReDirectionPreference();
    // 4
    await mainContextCompleter.future;
    if (!mainContext!.mounted) {
      return;
    }

    List<String> list = await getAbsoluteLinkData(link);
    showLog('getAbsoluteLinkData ew ${list}');
    if (list.length == 1) {
      showLog("deeplink is not null :: list.length is login");
      if (list[0] == 'login') {
        await reDirectionPreference.setReDirectionDetails(RedirectionModel(
            redirection:
                Redirection(route: RedirectionRouteConstant.LoginRoute)));
      }
      if (list[0] == 'packages') {
        await reDirectionPreference.setReDirectionDetails(RedirectionModel(
            redirection: Redirection(
                route: RedirectionRouteConstant.PackagesListRoute)));
      }
      if (list[0] == 'book-now') {
        await reDirectionPreference.setReDirectionDetails(RedirectionModel(
            redirection:
                Redirection(route: RedirectionRouteConstant.BookingRoute)));
      }
      if (list[0] == 'contact-us' || list[0] == 'about-us') {
        await reDirectionPreference.setReDirectionDetails(RedirectionModel(
            redirection:
                Redirection(route: RedirectionRouteConstant.ContactUs)));
      }
      if (list[0] == 'events') {
        await reDirectionPreference.setReDirectionDetails(RedirectionModel(
            redirection:
                Redirection(route: RedirectionRouteConstant.EventListRoute)));
      }

      if (list[0].length == 5) {
        await reDirectionPreference.setReDirectionDetails(RedirectionModel(
            redirection: Redirection(
                arguments: [list[0]],
                route: RedirectionRouteConstant.EventDetailsRoute)));
      }
    }
    if (list.length == 2) {
      if (list[0] == 'events' && list[1].length == 5) {
        showLog('The redirection route where ${list[1].length}');
        await reDirectionPreference.setReDirectionDetails(RedirectionModel(
            redirection: Redirection(
                arguments: [list[1]],
                route: RedirectionRouteConstant.EventDetailsRoute)));
      }
      if (list[0] == 'my-photos' && list[1].length == 5) {
        //event code
        showLog('photos notify');
        await reDirectionPreference.setReDirectionDetails(RedirectionModel(
            redirection: Redirection(
                arguments: [list[1]],
                route: RedirectionRouteConstant.MyPhotosRoute)));
      }
    }
    if (list.length == 4) {
      if (list[0].length == 5) {
        showLog('The redirection route where ${list[1].length}');
        await reDirectionPreference.setReDirectionDetails(RedirectionModel(
            redirection: Redirection(
                arguments: [list[0]],
                route: RedirectionRouteConstant.EventDetailsRoute)));
      }
      if (list[3] == 'my-photos' && list[0].length == 5) {
        await reDirectionPreference.setReDirectionDetails(RedirectionModel(
            redirection: Redirection(
                arguments: [list[0]],
                route: RedirectionRouteConstant.MyPhotosRoute)));
      }
    }
  }

  Future<List<String>> getAbsoluteLinkData(Uri link) async {
    var _link = link.toString();
    String sourceLink = '';
    StudioDataController studioDataController = StudioDataController();
    if (isPhotomallApp) {
      List<String> list = _link.split('/');
      return [list.last];
    }
    String? typeOne = "${await studioDataController.getWebLink()}/en/";
    String? shorten = await studioDataController.getWebLinkTwo();
    String? domain1 = await studioDataController.getWebLink();
    String? typeTwo = 'https://ptml.in/$shorten/';
    String? typeThree = '$domain1/events/';
    showLog('domain is $typeThree \n$domain1');

    /* if (_link.contains(typeOne)) {
      sourceLink = typeOne;
    } else {
      if (_link.contains(typeTwo)) {
        sourceLink = typeTwo;
      } else {
        return [];
      }
    }*/
    if (_link.contains(typeOne)) {
      sourceLink = typeOne;
    } else if (_link.contains(typeTwo)) {
      sourceLink = typeTwo;
    } else if (_link.contains(typeThree)) {
      showLog('type three');
      sourceLink = typeThree;
    } else {
      return [];
    }
    String _replacedLink = _link.replaceAll(sourceLink, "");
    _link = _replacedLink.replaceAll(" ", "");
    // _link = _replacedLink.trim();
    List<String> list = _link.split('/');
    return list;
  }
}
