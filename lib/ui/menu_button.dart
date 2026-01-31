import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/packages_dao.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/ui/login/login_route.dart';
import 'package:photomall_flutter/ui/profile/view/customer_profile_view_route.dart';
import 'package:photomall_flutter/ui/routes/rating_card_route.dart';
import 'package:photomall_flutter/ui/settings/contact_us_route.dart';
import 'package:photomall_flutter/ui/settings/settings_route.dart';
import 'package:photomall_flutter/ui/studioPackages/listRoute/studio_packages_list_route.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import '../core/models/apiModels/transport_model/transport_model.dart';
import 'app_side_drawer/side_drawer_constants.dart';
import 'drawer/side_drawer_model.dart';
import 'event/booking/book_me_route.dart';
import 'event/list/events_list_route.dart';
import 'gallery/gallery_route.dart';

class MenuButton extends StatefulWidget {
  const MenuButton({super.key});

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  List<Review> reviews = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSinglePackage();
  }

  Future<void> getSinglePackage() async {
    appDb.StudioPackageData? _package = await packagesModelDao.getPackage(1);
    var loginStatus =
        await PreferenceHelper.getBool(isUserLoggedInPreferenceKey);
    if (_package != null) {
      isPackageAvailable = true;
    }
    showLog("package get menus $isPackageAvailable,,loginStatus $loginStatus");
    if (loginStatus == true) {
      isLoggedIn = true;
    }
    await getGoogleReview();
  }

  getGoogleReview() async {
    var googleReviewPrefs = await PreferenceHelper.getString(googleReviewsKey);
    showLog('googleReviewsKey ${googleReviewPrefs}');
    List<GoogleReview>? googleReview = (googleReviewPrefs != ''&& googleReviewPrefs != 'null')
        ? googleReviewFromJson(googleReviewPrefs)
        : [];
    if (googleReview.isNotEmpty) {
      showLog('googleReview ${googleReview[0].reviews![0].review}');
      reviews = googleReview[0].reviews!;
      isGoogleReviewAvailable = true;
    }
  }

  PackagesModelDao packagesModelDao = PackagesModelDao();

  bool isPackageAvailable = false;
  bool isGoogleReviewAvailable = false;
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        !isPhotomallApp
            ? showPopover(
                arrowHeight: 2,
                context: context,
                bodyBuilder: (context) => isPackageAvailable
                    ? Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: MenuItems(
                          isLoggedIn: isLoggedIn,
                          isGoogleReviewAvailable: isGoogleReviewAvailable,
                          reviews: reviews,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: MenuItems2(
                          isLoggedIn: isLoggedIn,
                          isGoogleReviewAvailable: isGoogleReviewAvailable,
                          reviews: reviews,
                        ),
                      ),
                width: 180,
                height: isPackageAvailable ? 450 : 400)
            : showPopover(
                arrowHeight: 2,
                context: context,
                bodyBuilder: (context) => Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: PhotomallAppMenu(
                        isLoggedIn: isLoggedIn,
                      ),
                    ),
                width: 150,
                height: 220);
      },
      child: Icon(
        Icons.more_vert,
        color: AppColorData.appBarTextColor,
        size: 28,
      ),
    );
  }
}

class MenuItems extends StatefulWidget {
  final bool isLoggedIn;
  final bool isGoogleReviewAvailable;
  final List<Review> reviews;

  const MenuItems(
      {super.key,
      required this.isLoggedIn,
      required this.isGoogleReviewAvailable,
      required this.reviews});

  @override
  State<MenuItems> createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> {
  static Color textColour = AppColorData.appBarTextColor;
  Color iconColour = AppColorData.appBarTextColor;
  TextStyle style =
      TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: textColour);
  double iconSize = 22;

  @override
  Widget build(BuildContext context) {
    SideDrawerModel drawerModel =
        Provider.of<SideDrawerModel>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: AppColorData.backgroundGradientBegin,
              end: AppColorData.backgroundGradientEnd,
              colors: AppColorData.backgroundColors,
              stops: AppColorData.appBackgroundStops)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: (!widget.isGoogleReviewAvailable) ? 10 : 0,
              ),
              Center(
                child: Container(
                  width: 250,
                  height: 50,
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(context);

                      drawerModel.setDrawerChild(GalleryRoute(), '',
                          SideDrawerConstants.CustomerHome, 0);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.image,
                          size: iconSize,
                          color: iconColour,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).gallery,
                          style: style,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: (!widget.isGoogleReviewAvailable) ? 10 : 0,
              ),
              Center(
                child: Container(
                  width: 250,
                  height: 50,
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(context);

                      drawerModel.setDrawerChild(
                          EventsListRoute(
                            arguments:
                                EventsListArguments(isArchivedEven: false),
                          ),
                          S.of(context).events,
                          SideDrawerConstants.PhotomallEvents,
                          1);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.event_note,
                          size: iconSize,
                          color: iconColour,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).events,
                          style: style,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: (!widget.isGoogleReviewAvailable) ? 10 : 0,
              ),
              Center(
                child: Container(
                  width: 250,
                  height: 50,
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(context);

                      drawerModel.setDrawerChild(
                          BookMeRoute(
                            beforeLogin: false,
                          ),
                          S.of(context).eventBooking,
                          SideDrawerConstants.CustomerEventBooking,
                          2);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.thumb_up,
                          size: iconSize,
                          color: iconColour,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).book_now,
                          style: style,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: (!widget.isGoogleReviewAvailable) ? 10 : 0,
              ),
              Center(
                child: Container(
                  width: 250,
                  height: 50,
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(context);

                      drawerModel.setDrawerChild(
                          (widget.isLoggedIn)
                              ? CustomerProfileViewRoute()
                              : LoginRoute(false),
                          S.of(context).profile,
                          SideDrawerConstants.CustomerProfile,
                          3);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          (widget.isLoggedIn) ? Icons.person : Icons.login,
                          size: iconSize,
                          color: iconColour,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          (widget.isLoggedIn)
                              ? S.of(context).profile
                              : S.of(context).login,
                          style: style,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: (!widget.isGoogleReviewAvailable) ? 10 : 0,
              ),
              Center(
                child: Container(
                  width: 250,
                  height: 50,
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContactUsRoute()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.contact_page,
                          size: iconSize,
                          color: iconColour,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).contact_us,
                          style: style,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: (!widget.isGoogleReviewAvailable) ? 10 : 0,
              ),
              Center(
                child: Container(
                  width: 250,
                  height: 50,
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(context);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudioPackagesListRoute()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.shopping_bag,
                          size: iconSize,
                          color: iconColour,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).packages,
                          style: style,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: (!widget.isGoogleReviewAvailable) ? 10 : 0,
              ),
              Center(
                child: Container(
                  width: 250,
                  height: 50,
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Settings())
                          /*MaterialPageRoute(
                                    builder: (context) => Settings())*/
                          );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.settings,
                          size: iconSize,
                          color: iconColour,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).settings,
                          style: style,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: (!widget.isGoogleReviewAvailable) ? 10 : 0,
              ),
              (widget.isGoogleReviewAvailable)
                  ? Center(
                      child: Container(
                        width: 250,
                        height: 50,
                        child: InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReviewPageRoute(
                                          reviews: widget.reviews,
                                        ))
                                /*MaterialPageRoute(
                                    builder: (context) => Settings())*/
                                );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.reviews,
                                size: iconSize,
                                color: iconColour,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: Text(
                                  S.of(context).reviewsRatings,
                                  style: style,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 0,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItems2 extends StatefulWidget {
  final bool isLoggedIn;
  final bool isGoogleReviewAvailable;
  final List<Review> reviews;

  const MenuItems2(
      {super.key,
      required this.isLoggedIn,
      required this.isGoogleReviewAvailable,
      required this.reviews});

  @override
  State<MenuItems2> createState() => _MenuItems2State();
}

class _MenuItems2State extends State<MenuItems2> {
  static Color textColour = AppColorData.appBarTextColor;
  Color iconColour = AppColorData.appBarTextColor;
  TextStyle style =
      TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: textColour);
  double iconSize = 22;

  @override
  Widget build(BuildContext context) {
    SideDrawerModel drawerModel =
        Provider.of<SideDrawerModel>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: AppColorData.backgroundGradientBegin,
              end: AppColorData.backgroundGradientEnd,
              colors: AppColorData.backgroundColors,
              stops: AppColorData.appBackgroundStops)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: (!widget.isGoogleReviewAvailable) ? 10 : 0,
            ),
            Center(
              child: Container(
                width: 250,
                height: 50,
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);

                    drawerModel.setDrawerChild(GalleryRoute(), '',
                        SideDrawerConstants.CustomerHome, 0);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.image,
                        size: iconSize,
                        color: iconColour,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        S.of(context).gallery,
                        style: style,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: (!widget.isGoogleReviewAvailable) ? 10 : 0,
            ),
            Center(
              child: Container(
                width: 250,
                height: 50,
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);

                    drawerModel.setDrawerChild(
                        EventsListRoute(
                          arguments: EventsListArguments(isArchivedEven: false),
                        ),
                        S.of(context).events,
                        SideDrawerConstants.PhotomallEvents,
                        1);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.event_note,
                        size: iconSize,
                        color: iconColour,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        S.of(context).events,
                        style: style,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: (!widget.isGoogleReviewAvailable) ? 10 : 0,
            ),
            Center(
              child: Container(
                width: 250,
                height: 50,
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);

                    drawerModel.setDrawerChild(
                        BookMeRoute(
                          beforeLogin: false,
                        ),
                        S.of(context).eventBooking,
                        SideDrawerConstants.CustomerEventBooking,
                        2);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.thumb_up,
                        size: iconSize,
                        color: iconColour,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        S.of(context).book_now,
                        style: style,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: (!widget.isGoogleReviewAvailable) ? 10 : 0,
            ),
            Center(
              child: Container(
                width: 250,
                height: 50,
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);

                    drawerModel.setDrawerChild(
                        (widget.isLoggedIn)
                            ? CustomerProfileViewRoute()
                            : LoginRoute(false),
                        S.of(context).profile,
                        SideDrawerConstants.CustomerProfile,
                        3);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        (widget.isLoggedIn) ? Icons.person : Icons.login,
                        size: iconSize,
                        color: iconColour,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        (widget.isLoggedIn)
                            ? S.of(context).profile
                            : S.of(context).login,
                        style: style,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: (!widget.isGoogleReviewAvailable) ? 10 : 0,
            ),
            Center(
              child: Container(
                width: 250,
                height: 50,
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactUsRoute()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.contact_page,
                        size: iconSize,
                        color: iconColour,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        S.of(context).contact_us,
                        style: style,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: (!widget.isGoogleReviewAvailable) ? 10 : 0,
            ),
            Center(
              child: Container(
                width: 250,
                height: 50,
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings())
                        /*MaterialPageRoute(
                                  builder: (context) => Settings())*/
                        );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.settings,
                        size: iconSize,
                        color: iconColour,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        S.of(context).settings,
                        style: style,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            (widget.isGoogleReviewAvailable)
                ? Center(
                    child: Container(
                      width: 250,
                      height: 50,
                      child: InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReviewPageRoute(
                                        reviews: widget.reviews,
                                      ))
                              /*MaterialPageRoute(
                                    builder: (context) => Settings())*/
                              );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.reviews,
                              size: iconSize,
                              color: iconColour,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text(
                                S.of(context).reviewsRatings,
                                style: style,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
          ],
        ),
      ),
    );
  }
}

class PhotomallAppMenu extends StatefulWidget {
  final bool isLoggedIn;

  const PhotomallAppMenu({super.key, required this.isLoggedIn});

  @override
  State<PhotomallAppMenu> createState() => _PhotomallAppMenuState();
}

class _PhotomallAppMenuState extends State<PhotomallAppMenu> {
  static Color textColour = AppColorData.appBarTextColor;
  Color iconColour = AppColorData.appBarTextColor;
  TextStyle style =
      TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: textColour);
  double iconSize = 22;

  @override
  Widget build(BuildContext context) {
    SideDrawerModel drawerModel =
        Provider.of<SideDrawerModel>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: AppColorData.backgroundGradientBegin,
              end: AppColorData.backgroundGradientEnd,
              colors: AppColorData.backgroundColors,
              stops: AppColorData.appBackgroundStops)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: 250,
                height: 50,
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);

                    drawerModel.setDrawerChild(
                        EventsListRoute(
                          arguments: EventsListArguments(isArchivedEven: false),
                        ),
                        S.of(context).events,
                        SideDrawerConstants.PhotomallEvents,
                        0);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.event_note,
                        size: iconSize,
                        color: iconColour,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        S.of(context).events,
                        style: style,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: 250,
                height: 50,
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);

                    drawerModel.setDrawerChild(
                        (widget.isLoggedIn)
                            ? CustomerProfileViewRoute()
                            : LoginRoute(false),
                        S.of(context).profile,
                        SideDrawerConstants.CustomerProfile,
                        2);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        (widget.isLoggedIn) ? Icons.person : Icons.login,
                        size: iconSize,
                        color: iconColour,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        (widget.isLoggedIn)
                            ? S.of(context).profile
                            : S.of(context).login,
                        style: style,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: 250,
                height: 50,
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings())
                        /*MaterialPageRoute(
                                  builder: (context) => Settings())*/
                        );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.settings,
                        size: 25,
                        color: iconColour,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        S.of(context).settings,
                        style: style,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<GoogleReview> googleReviewFromJson(String str) => List<GoogleReview>.from(
    json.decode(str).map((x) => GoogleReview.fromJson(x)));
