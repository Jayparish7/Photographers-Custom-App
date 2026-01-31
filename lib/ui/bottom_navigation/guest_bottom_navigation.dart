import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as appConf;
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/ui/app_side_drawer/side_drawer_constants.dart';
import 'package:photomall_flutter/ui/drawer/side_drawer_model.dart';
import 'package:photomall_flutter/ui/event/booking/book_me_route.dart';
import 'package:photomall_flutter/ui/event/list/events_list_route.dart';
import 'package:photomall_flutter/ui/gallery/gallery_route.dart';
import 'package:photomall_flutter/ui/login/login_route.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/Utils/preference_helper.dart';

class GuestBottomNavigation extends StatefulWidget {
  final int initialIndex;

  const GuestBottomNavigation({Key? key, this.initialIndex = 0})
      : super(key: key);

  @override
  _GuestBottomNavigationState createState() => _GuestBottomNavigationState();
}

class _GuestBottomNavigationState extends State<GuestBottomNavigation> {
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();
  GlobalKey<CurvedNavigationBarState> NavigationKey = GlobalKey();
  NotchBottomBarController _controller = NotchBottomBarController();
  int _selectedIndex = 1;
  String studioName = "";
  bool flushBarStatus = false;
  bool type = false;
  bool isGalleryAvailable = false;
  bool isPartyApps = false;

  @override
  void initState() {
    getStudioName();
    getStudioType();
    getStudioType1();
    showLog('getStudioType $isPartyApps');
    getGalleryAvailability();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SideDrawerModel model =
        Provider.of<SideDrawerModel>(context, listen: false);
    _selectedIndex = isGalleryAvailable == true
        ? model.bottomNavigationIndex
        : (isPartyApps == true)
            ? 0
            : model.bottomNavigationIndex; //model.bottomNavigationIndex;
    return Container(
        child: FutureBuilder<String>(
            future: getStudioType(),
            builder: (context, snapshot) {
              //not logged in show guest navigation bar
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data == null) {
                return getGoogleBar();
              }

              return snapshot.data != 'Party'
                  ? getGoogleBar()
                  : getPartyBottomNavigationBar();
            }));
  }

  getBottomNavigationBar() {
    return CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _selectedIndex,
        height: 50.0,

        // animationCurve: Curves.bounceIn,
        backgroundColor: AppColorData.backgroundColors.last,
        color: AppColorData.bottomNavbarBackgroundColors.last,
        items: [
          Container(
            height: 55,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.image, color: getBottomIconColor(0)),
                CommonText(
                  isSelected: getBottomTextColor(0),
                  isBottomNavbar: true,
                  text: S.of(context).gallery,
                  //style: Theme.of(context).textTheme.bodySmall.copyWith(color: getBottomTextColor(0)),
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.event_note_sharp, color: getBottomIconColor(1)),
                CommonText(
                  isSelected: getBottomTextColor(1),
                  isBottomNavbar: true,
                  text: S.of(context).events,

                  //style: Theme.of(context).textTheme.bodySmall.copyWith(color: getBottomTextColor(1)),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 55,
            child: Column(
              // key: keyBookNow,
              mainAxisSize: MainAxisSize.min,

              children: [
                Icon(Icons.thumb_up, color: getBottomIconColor(2)),
                CommonText(
                  isSelected: getBottomTextColor(2),
                  isBottomNavbar: true,
                  textAlign: TextAlign.center,
                  text: S.of(context).bookNow,
                  maxlines: 3,
                  overflow: TextOverflow.ellipsis,
                  //style: Theme.of(context).textTheme.bodySmall.copyWith(color: getBottomTextColor(2)),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 60,
            child: Column(
              //key: keyLogIn,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.login, color: getBottomIconColor(3)),
                CommonText(
                  isSelected: getBottomTextColor(3),
                  isBottomNavbar: true,
                  textAlign: TextAlign.center,
                  text: S.of(context).login,
                  maxlines: 3,

                  //style: Theme.of(context).textTheme.bodySmall.copyWith(color: getBottomTextColor(3)),
                ),
              ],
            ),
          ),
        ],
        onTap: (position) {
          _onBottomNavigationTap(position);

          _selectedIndex = position;
        });
  }

  getNotchBottomNavigationBar() {
    String orientation = MediaQuery.of(context).orientation.toString();
    showLog('orientation $orientation');
    _controller.index = _selectedIndex;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //(orientation!='Orientation.portrait')?SizedBox(width: 150,):SizedBox(),
        AnimatedNotchBottomBar(
          elevation: 5,
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
              itemLabel: S.of(context).gallery,
              inActiveItem: Icon(Icons.image,
                  color: AppColorData.bottomNavIconUnSelectedColor),
              activeItem: Icon(Icons.image,
                  color: AppColorData.bottomNavIconSelectedColor),
            ),
            BottomBarItem(
                itemLabel: S.of(context).events,
                inActiveItem:
                    Icon(Icons.event_note_sharp, color: getBottomIconColor(1)),
                activeItem:
                    Icon(Icons.event_note_sharp, color: getBottomIconColor(1))),
            BottomBarItem(
              itemLabel: S.of(context).bookNow,
              inActiveItem: Icon(Icons.thumb_up, color: getBottomIconColor(2)),
              activeItem: Icon(Icons.thumb_up, color: getBottomIconColor(2)),
            ),
            BottomBarItem(
              itemLabel: S.of(context).login,
              inActiveItem: Icon(Icons.login, color: getBottomIconColor(3)),
              activeItem: Icon(Icons.login, color: getBottomIconColor(3)),
            ),
          ],
          onTap: (position) {
            _onBottomNavigationTap(position);

            _selectedIndex = position;
          },
        ),
      ],
    );
  }

  getGoogleBar() {
    String orientation = MediaQuery.of(context).orientation.toString();
    showLog('orientation $orientation');

    _controller.index = _selectedIndex;
    EdgeInsets padding = EdgeInsets.all(8);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GNav(
        backgroundColor: Colors.white.withOpacity(.8),
        rippleColor: AppColorData.appBarTextColor,
        hoverColor: Colors.transparent,
        curve: Curves.easeInOut,
        tabBorderRadius: 15,
        activeColor: AppColorData.backgroundColors.first,
        iconSize: 25,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        duration: Duration(milliseconds: 400),
        haptic: true,
        tabBackgroundColor: AppColorData.appBarTextColor,
        color: AppColorData.appBarTextColor,
        tabs: [
          GButton(
              padding:padding,
              icon: Icons.image, text: S.of(context).gallery),
          GButton(padding:padding,
            icon: Icons.event_note_sharp,
            text: S.of(context).events,
          ),
          GButton(padding:padding,
            icon: Icons.thumb_up,
            text: S.of(context).bookNow,
          ),
          GButton(padding:padding,
            icon: Icons.login_outlined,
            text: S.of(context).login,
          ),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          _onBottomNavigationTap(index);
        },
      ),
    );
  }

  getSnakeBottomNavigationBar() {
    String orientation = MediaQuery.of(context).orientation.toString();
    showLog('orientation getSnakeBottomNavigationBar $orientation');
    _controller.index = _selectedIndex;
    return SnakeNavigationBar.color(
      height: 65,
      backgroundColor: AppColorData.bottomNavbarBackgroundColors.first,
      shadowColor: Colors.white,
      // height: 80,
      behaviour: snakeBarStyle,
      snakeShape: snakeShape,
      shape: bottomBarShape,
      padding: padding,

      ///configuration for SnakeNavigationBar.color
      snakeViewColor:
          AppColorData.bottomNavbarBackgroundColors.last.withOpacity(.5),
      selectedItemColor: AppColorData.bottomNavIconSelectedColor,
      unselectedItemColor: AppColorData.bottomNavIconUnSelectedColor,

      ///configuration for SnakeNavigationBar.gradient
      // snakeViewGradient: selectedGradient,
      // selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
      // unselectedItemGradient: unselectedGradient,

      // showUnselectedLabels: showUnselectedLabels,
      // / showSelectedLabels: showSelectedLabels,

      currentIndex: _selectedIndex,
      onTap: (index) {
        _onBottomNavigationTap(index);

        _selectedIndex = index;
      },
      items: [
        BottomNavigationBarItem(
            activeIcon: Icon(Icons.image,
                color: AppColorData.bottomNavIconSelectedColor),
            icon: Icon(Icons.image,
                color: AppColorData.bottomNavIconUnSelectedColor),
            label: S.of(context).gallery),
        BottomNavigationBarItem(
            activeIcon:
                Icon(Icons.event_note_sharp, color: getBottomIconColor(1)),
            icon: Icon(Icons.event_note_sharp, color: getBottomIconColor(1)),
            label: S.of(context).events),
        BottomNavigationBarItem(
            activeIcon: Icon(Icons.thumb_up, color: getBottomIconColor(2)),
            icon: Icon(Icons.thumb_up, color: getBottomIconColor(2)),
            label: S.of(context).bookNow),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.login, color: getBottomIconColor(3)),
          icon: Icon(Icons.login, color: getBottomIconColor(3)),
          label: S.of(context).login,
        )
      ],
      selectedLabelStyle: const TextStyle(
        fontSize: 14,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
    );
  }

  getPartyBottomNavigationBar() {
    if (isGalleryAvailable) {
      return CurvedNavigationBar(
          key: NavigationKey,
          index: _selectedIndex,
          height: 50.0,

          // animationCurve: Curves.bounceIn,
          backgroundColor: AppColorData.backgroundColors.last,
          color: AppColorData.bottomNavbarBackgroundColors.last,
          items: [
            Container(
              height: 55,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.image, color: getBottomIconColor(0)),
                  CommonText(
                    isSelected: getBottomTextColor(0),
                    isBottomNavbar: true,
                    text: S.of(context).gallery,
                    //style: Theme.of(context).textTheme.bodySmall.copyWith(color: getBottomTextColor(0)),
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_note_sharp, color: getBottomIconColor(1)),
                  CommonText(
                    isSelected: getBottomTextColor(1),
                    isBottomNavbar: true,
                    text: S.of(context).events,

                    //style: Theme.of(context).textTheme.bodySmall.copyWith(color: getBottomTextColor(1)),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              child: Column(
                //key: keyLogIn,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.login, color: getBottomIconColor(3)),
                  CommonText(
                    isSelected: getBottomTextColor(3),
                    isBottomNavbar: true,
                    textAlign: TextAlign.center,
                    text: S.of(context).login,
                    maxlines: 3,

                    //style: Theme.of(context).textTheme.bodySmall.copyWith(color: getBottomTextColor(3)),
                  ),
                ],
              ),
            ),
          ],
          onTap: (position) {
            onBottomNavigationPartyTap(position);

            _selectedIndex = position;
          });
    } else {
      return CurvedNavigationBar(
          key: bottomNavigationKey,
          index: _selectedIndex,
          height: 50.0,

          // animationCurve: Curves.bounceIn,
          backgroundColor: AppColorData.backgroundColors.last,
          color: AppColorData.bottomNavbarBackgroundColors.last,
          items: [
            Container(
              height: 60,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_note_sharp, color: getBottomIconColor(1)),
                  CommonText(
                    isSelected: getBottomTextColor(1),
                    isBottomNavbar: true,
                    text: S.of(context).events,

                    //style: Theme.of(context).textTheme.bodySmall.copyWith(color: getBottomTextColor(1)),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              child: Column(
                //key: keyLogIn,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.login, color: getBottomIconColor(3)),
                  CommonText(
                    isSelected: getBottomTextColor(3),
                    isBottomNavbar: true,
                    textAlign: TextAlign.center,
                    text: S.of(context).login,
                    maxlines: 3,

                    //style: Theme.of(context).textTheme.bodySmall.copyWith(color: getBottomTextColor(3)),
                  ),
                ],
              ),
            ),
          ],
          onTap: (position) {
            onBottomNavigationPartyTapNotGallery(position);

            _selectedIndex = position;
          });
    }
  }

  bool getBottomTextColor(int index) {
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
        drawerChild.setDrawerChild(GalleryRoute(), studioName,
            SideDrawerConstants.GuestHome, position);
        break;
      case 1:
        drawerChild.setDrawerChild(
            Container(
                key: UniqueKey(),
                child: EventsListRoute(
                  arguments: EventsListArguments(isArchivedEven: false),
                )),
            S.of(context).events,
            SideDrawerConstants.GuestEvents,
            position);
        break;
      case 2:
        drawerChild.setDrawerChild(
            BookMeRoute(
              beforeLogin: false,
            ),
            S.of(context).eventBooking,
            SideDrawerConstants.GuestEventBooking,
            position);
        break;
      case 3:
        drawerChild.setDrawerChild(LoginRoute(true), S.of(context).login,
            SideDrawerConstants.GuestLogin, position);
        break;
    }
  }

/*  _onBottomNavigationTapNotGallery(int position) async {
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
            SideDrawerConstants.GuestEvents,
            position);
        break;
      case 1:
        drawerChild.setDrawerChild(
            BookMeRoute(
              beforeLogin: false,
            ),
            S.of(context).eventBooking,
            SideDrawerConstants.GuestEventBooking,
            position);
        break;
      case 2:
        drawerChild.setDrawerChild(LoginRoute(true), S.of(context).login,
            SideDrawerConstants.GuestLogin, position);
        break;
    }
  }*/

  onBottomNavigationPartyTap(int position) async {
    showLog('onBottomNavigationPartyTap true');
    SideDrawerModel drawerChild =
        Provider.of<SideDrawerModel>(context, listen: false);
    switch (position) {
      case 0:
        drawerChild.setDrawerChild(GalleryRoute(), studioName,
            SideDrawerConstants.GuestHome, position);
        break;
      case 1:
        drawerChild.setDrawerChild(
            Container(
                key: UniqueKey(),
                child: EventsListRoute(
                  arguments: EventsListArguments(isArchivedEven: false),
                )),
            S.of(context).events,
            SideDrawerConstants.GuestEvents,
            position);
        break;

      case 2:
        drawerChild.setDrawerChild(LoginRoute(true), S.of(context).login,
            SideDrawerConstants.GuestLogin, position);
        break;
    }
  }

  onBottomNavigationPartyTapNotGallery(int position) async {
    showLog('onBottomNavigationPartyTapNotGallery true');

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
            SideDrawerConstants.GuestEvents,
            position);
        break;

      case 1:
        drawerChild.setDrawerChild(LoginRoute(true), S.of(context).login,
            SideDrawerConstants.GuestLogin, position);
        break;
    }
  }

  void getStudioName() async {
    try {
      var appConfig = TransporterPreference();
      appConf.TransportModel? studioDetails = await appConfig.getAppConfig();
      studioName = studioDetails!.studioData!.data!.name!;
      showLog('getStudioType$studioName');
    } catch (e) {
      showLog("the problem in studio name bottom nav bar ${e}");
    }
  }

  Future<String> getStudioType() async {
    var pref = await SharedPreferences.getInstance();
    var res = await pref.getString('$studioTypeKey') ?? '';

    return res;
    //isPartyApps = true;
  }

  getStudioType1() async {
    var pref = await SharedPreferences.getInstance();
    var res = await pref.getString('$studioTypeKey') ?? '';
    if (res == 'Party') {
      isPartyApps = true;
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
}
