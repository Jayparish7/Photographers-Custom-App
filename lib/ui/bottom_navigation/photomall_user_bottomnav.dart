import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as appConf;
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/ui/app_side_drawer/side_drawer_constants.dart';
import 'package:photomall_flutter/ui/drawer/side_drawer_model.dart';
import 'package:photomall_flutter/ui/event/list/events_list_route.dart';
import 'package:photomall_flutter/ui/profile/view/customer_profile_view_route.dart';
import 'package:provider/provider.dart';
import '../event/add/add_event_route.dart';

class PhotomallBottomNavigationUser extends StatefulWidget {
  final int initialIndex;

  const PhotomallBottomNavigationUser({Key? key, this.initialIndex = 0})
      : super(key: key);

  @override
  _PhotomallBottomNavigationGuestState createState() =>
      _PhotomallBottomNavigationGuestState();
}

class _PhotomallBottomNavigationGuestState
    extends State<PhotomallBottomNavigationUser> {
  int _selectedIndex = 0;
  String studioName = "";
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    getStudioName();
    super.initState();
  }

  bool flushBarStatus = false;

  @override
  Widget build(BuildContext context) {
    SideDrawerModel model =
        Provider.of<SideDrawerModel>(context, listen: false);
    _selectedIndex = model.bottomNavigationIndex;
    return getNotchBottomNavigationBar() /*Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            // stops: [0.0, 0.8,0.0],
              begin: AppColorData.bottomNavbarBackgroundGradientBegin,
              end: AppColorData.bottomNavbarBackgroundGradientEnd,
              colors: AppColorData.bottomNavbarBackgroundColors,
              stops: AppColorData.appBackgroundStops)),
      child:CurvedNavigationBar(



          key: _bottomNavigationKey,
          index: _selectedIndex,
          height: 50.0,

          // animationCurve: Curves.bounceIn,
          backgroundColor: AppColorData.backgroundColors.last,
          color: AppColorData. appBarBackgroundColors.first,
          items: [



            Container(height: 60,
              alignment: Alignment.center,
              child: Column(mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_note_sharp,color: getBottomIconColor(1)),
                  CommonText(
                    isSelected:getBottomTextColor(1) ,
                    isBottomNavbar: true,
                    text: S.of(context).events,

                    //style: Theme.of(context).textTheme.bodySmall.copyWith(color: getBottomTextColor(1)),
                  ),
                ],
              ),
            ),

            Container(height: 60,alignment: Alignment.center,
              child: Column(mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person,color: getBottomIconColor(3)),
                  CommonText(
                    isSelected:getBottomTextColor(3) ,
                    isBottomNavbar: true,
                    text:S.of(context).profile,
                    // style: Theme.of(context).textTheme.bodySmall.copyWith(color: getBottomTextColor(3)),
                  ),
                ],
              ),
            ),

          ],

          onTap: (position) {
            _onBottomNavigationTap(position);

            _selectedIndex = position;
          }
      )


      */ /* BottomNavigationBar(
          key: UniqueKey(),
          elevation: 0,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[



            BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_note_sharp, color: getBottomIconColor(0)),
                  CommonText(
                    isSelected: getBottomTextColor(0),
                    isBottomNavbar: true,
                    text: S.of(context).events,
                  ),
                ],
              ),
              label: '',
              //backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(

              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person,color: getBottomIconColor(1)),
                  CommonText(
                    isSelected:getBottomTextColor(1) ,
                    isBottomNavbar: true,
                    text:S.of(context).profile,
                    // style: Theme.of(context).textTheme.bodySmall.copyWith(color: getBottomTextColor(3)),
                  ),
                ],
              ),
              label: '',
              //backgroundColor: Colors.red,
            ),
          ],
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedItemColor: model.bottomNavigationIndex == -1
              ? AppColorData.iconColor
              : AppColorData.iconSelectedColor,
          unselectedItemColor: AppColorData.iconColor,
          selectedLabelStyle: TextStyle(),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: model.bottomNavigationIndex == -1
              ? 0
              : model.bottomNavigationIndex,
          onTap: (position) {
            _onBottomNavigationTap(position);
            _selectedIndex = position;
          }),*/ /*
    )*/
        ;
  }

  getNotchBottomNavigationBar() {
    String orientation = MediaQuery.of(context).orientation.toString();
    showLog('orientation $orientation');
    NotchBottomBarController _controller = NotchBottomBarController();

    _controller.index = _selectedIndex;
    return Row(
      children: [
        (orientation != 'Orientation.portrait')
            ? SizedBox(
                width: 150,
              )
            : SizedBox(),
        AnimatedNotchBottomBar(
          elevation: 15,
          showTopRadius: true,
          kBottomRadius: 10,
          kIconSize: 25,
          notchBottomBarController: _controller,
          key: _bottomNavigationKey,
          notchGradient: LinearGradient(
              // stops: [0.0, 0.8,0.0],
              begin: AppColorData.bottomNavbarBackgroundGradientBegin,
              end: AppColorData.bottomNavbarBackgroundGradientEnd,
              colors: AppColorData.bottomNavbarBackgroundColors,
              stops: AppColorData.appBackgroundStops),
          notchColor: AppColorData.bottomNavbarBackgroundColors.first,
          itemLabelStyle: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColorData.bottomNavTextUnSelectedColor),
          // animationCurve: Curves.bounceIn,
          color: AppColorData.bottomNavbarBackgroundColors.first,
          bottomBarItems: [
            BottomBarItem(
                itemLabel: S.of(context).events,
                inActiveItem:
                    Icon(Icons.event_note_sharp, color: getBottomIconColor(1)),
                activeItem:
                    Icon(Icons.event_note_sharp, color: getBottomIconColor(1))),
            BottomBarItem(
              itemLabel: S.of(context).add_event,
              inActiveItem:
                  Icon(Icons.qr_code_scanner, color: getBottomIconColor(2)),
              activeItem:
                  Icon(Icons.qr_code_scanner, color: getBottomIconColor(2)),
            ),
            BottomBarItem(
              itemLabel: S.of(context).profile,
              inActiveItem: Icon(Icons.person, color: getBottomIconColor(3)),
              activeItem: Icon(Icons.person, color: getBottomIconColor(3)),
            ),
          ],
          onTap: (position) {
            _onBottomNavigationTap(position);
            showLog('position $position');
            _selectedIndex = position;
          },
        ),
      ],
    );
  }

  bool getBottomTextColor(int index) {
    showLog("the log one  $index");
    showLog("the log two  $_selectedIndex");
    return (index == _selectedIndex) ? true : false;
  }

  getBottomIconColor(int index) {
    return (index == _selectedIndex)
        ? AppColorData.bottomNavIconSelectedColor
        : AppColorData.bottomNavIconUnSelectedColor;
  }

  _onBottomNavigationTap(int position) async {
    SideDrawerModel drawerChild =
        Provider.of<SideDrawerModel>(context, listen: false);
    switch (position) {
      case 0:
        drawerChild.setDrawerChild(
            Container(
                key: UniqueKey(),
                child: EventsListRoute(
                  arguments: EventsListArguments(isArchivedEven: false),
                )),
            S.of(context).events,
            SideDrawerConstants.PhotomallEvents,
            position);
        break;
      case 1:
        drawerChild.setDrawerChild(
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: AddEvent(),
            ),
            S.of(context).add_event,
            SideDrawerConstants.PhotomallCustomerProfile,
            position);
        break;
      case 2:
        drawerChild.setDrawerChild(
            CustomerProfileViewRoute(),
            S.of(context).profile,
            SideDrawerConstants.PhotomallCustomerProfile,
            position);
        break;
    }
  }

  void getStudioName() async {
    try {
      var appConfig = TransporterPreference();
      appConf.TransportModel? studioDetails = await appConfig.getAppConfig();
      studioName = studioDetails!.studioData!.data!.name!;
    } catch (e) {
      showLog("the problem in studio name bottom nav bar ${e}");
    }
  }
}
