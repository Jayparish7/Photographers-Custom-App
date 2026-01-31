import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporterModel;
import 'package:photomall_flutter/ui/event/list/events_list_route.dart';
import 'package:photomall_flutter/ui/gallery/gallery_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/Utils/preference_helper.dart';
import '../../core/constants/shared_preference_constants.dart';

class SideDrawerModel extends ChangeNotifier {

  bool isPartyApp = false;
  bool isGalleryAvailable = false;

  dynamic drawerChild = isPhotomallApp
      ? EventsListRoute(
          arguments: EventsListArguments(isArchivedEven: false),
        )
      : GalleryRoute();
  dynamic partyDrawerChild = EventsListRoute(
    arguments: EventsListArguments(isArchivedEven: false),
  );
  dynamic partyGalleryDrawerChild = GalleryRoute();

  String drawerChildName = "Events";
  int drawerChildIndex = 0;
  int bottomNavigationIndex = 0;
  SideDrawerModel? pendingNavigation;

  setPendingNavigation(SideDrawerModel sideDrawerModel) {
    pendingNavigation = sideDrawerModel;
  }

  /*get drawerChild => _drawerChild;

  get drawerChildName => _drawerChildName;

  get drawerChildIndex => _drawerChildIndex;

  get bottomNavigationIndex => _bottomNavigationIndex;*/

  setDrawerChild(Widget child, name, index, bottomNavigationIndexes,
      {BuildContext? context, bool? refreshSamePage}) {
    showLog('bottomNavigationIndex $bottomNavigationIndexes');
    if ((drawerChildIndex != index) ||
        bottomNavigationIndexes == 3 ||
        bottomNavigationIndexes == 1 ||
        bottomNavigationIndexes == 2 ||bottomNavigationIndexes == 0||
        refreshSamePage == true) {
      drawerChild = child; //  pages[getIndexOfChild(index)];
      partyDrawerChild = child;
      partyGalleryDrawerChild = child;
      drawerChildName = name;
      drawerChildIndex = index;
      bottomNavigationIndex = bottomNavigationIndexes;
      notifyListeners();
    }
  }

  getStudioType() async {
    try{
      var pref = await SharedPreferences.getInstance();
      var party = pref.getString('$studioTypeKey') ?? '';
      if (party == 'Party') {
        showLog('getStudioType $party');

        isPartyApp = true;
      }
    }catch(e){

    }
  }

  getGalleryAvailability() async {
    var gallery = await PreferenceHelper.getBool(galleryKey);
    var carousel = await PreferenceHelper.getBool(carouselKey);
    if (gallery == true || carousel == true) {
      showLog('getGalleryAvailability $gallery $carousel');
      isGalleryAvailable = true;
    }
    showLog('getGalleryAvailability $gallery $carousel $isGalleryAvailable');
  }

  SideDrawerEssential getSideDrawerItem() {
    return SideDrawerEssential(
        name: drawerChildName,
        bottomIndex: bottomNavigationIndex,
        child: drawerChild,
        index: drawerChildIndex);
  }

  Future<String?> getStudioName() async {
    String? studioName = "";
    var appConfig = TransporterPreference();
    transporterModel.TransportModel? studioDetails =
        await appConfig.getAppConfig();
    if (studioDetails != null && studioDetails.studioData?.data != null) {
      studioName = studioDetails.studioData?.data?.name;
    }
    return studioName;
  }

  int getIndexOfChild(int index) {
    switch (index) {
      case 0:
        {
          return 0;
        }
      case 1:
        {
          return 1;
        }
      case 2:
        {
          return 2;
        }
      case 3:
        {
          return 3;
        }

      default:
        {
          return 0;
        }
    }
  }
}

class SideDrawerEssential {
  final Widget child;
  final String name;
  final int index;
  final int bottomIndex;

  SideDrawerEssential(
      {required this.child,
      required this.name,
      required this.index,
      required this.bottomIndex});
}
