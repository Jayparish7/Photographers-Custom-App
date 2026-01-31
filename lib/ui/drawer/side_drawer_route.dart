import 'package:flutter/material.dart';
import 'package:photomall_flutter/core/Utils/clipper/oval_right_clipper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/ui/drawer/side_drawer_model.dart';
import 'package:photomall_flutter/ui/event/booking/book_me_route.dart';
import 'package:photomall_flutter/ui/event/list/events_list_route.dart';
import 'package:photomall_flutter/ui/gallery/gallery_route.dart';
import 'package:photomall_flutter/ui/settings/contact_us_route.dart';
import 'package:photomall_flutter/ui/settings/settings_route.dart';
import 'package:photomall_flutter/ui/shared/ui_helpers.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login/login_route.dart';

class SideDrawerView extends StatefulWidget {
  @override
  _SideDrawerViewState createState() => _SideDrawerViewState();
}

class _SideDrawerViewState extends State<SideDrawerView> {
  bool registeredStatus = false;
  bool loggedInStatus = false;

  @override
  void initState() {
    super.initState();
    getLoginRegisterStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    addDrawerItems();
    addDrawerItemsIfLoggedIn();
  }

  addDrawerItems() {
    showLog("add drawer items");
    drawerItems.add(DrawerMenuItem(
      Icons.burst_mode,
      S.of(context).home,
      GalleryRoute(),
      0,
    ));
    drawerItems.add(DrawerMenuItem(
      Icons.collections,
      S.of(context).events,
      EventsListRoute(
        arguments: EventsListArguments(),
      ),
      1,
    ));
    /*drawerItems
        .add(MenuItem(Icons.add_box, S.of(context).add_event, AddEvent()));*/

    drawerItems.add(DrawerMenuItem(
      Icons.book,
      S.of(context).event_booking,
      BookMeRoute(beforeLogin: loggedInStatus),
      3,
    ));
    drawerItems.add(DrawerMenuItem(
      Icons.exit_to_app,
      S.of(context).login,
      LoginRoute(
        true,
      ),
      4,
    ));
    /*  drawerItems.add(DrawerMenuItem(
      Icons.person_add,
      S.of(context).register,
      RegisterRoute(),
      -1,
    ));*/
    drawerItems.add(DrawerMenuItem(
      Icons.settings,
      S.of(context).settings,
      Settings(),
      -1,
    ));
    drawerItems.add(DrawerMenuItem(
      Icons.contacts,
      S.of(context).contact_us,
      ContactUsRoute(),
      -1,
    ));
  }

  addDrawerItemsIfLoggedIn() {
    showLog("add drawer items if logged in");
    drawerItemsIfLoggedIn.add(DrawerMenuItem(
      Icons.burst_mode,
      S.of(context).home,
      GalleryRoute(),
      0,
    ));
    drawerItemsIfLoggedIn.add(DrawerMenuItem(
      Icons.collections,
      S.of(context).events,
      EventsListRoute(arguments: EventsListArguments()),
      1,
    ));
    /*drawerItemsIfLoggedIn
        .add(MenuItem(Icons.add_box, S.of(context).add_event, AddEvent()));*/

    drawerItemsIfLoggedIn.add(DrawerMenuItem(
      Icons.book,
      S.of(context).event_booking,
      BookMeRoute(beforeLogin: loggedInStatus),
      3,
    ));
    drawerItemsIfLoggedIn.add(DrawerMenuItem(
      Icons.settings,
      S.of(context).settings,
      Settings(),
      -1,
    ));
    drawerItemsIfLoggedIn.add(DrawerMenuItem(
      Icons.contacts,
      S.of(context).contact_us,
      ContactUsRoute(),
      -1,
    ));
  }

  bool getBeforeLoginStatus() {
    //loggedInStatus status true means before login false, false means before login true
    //so here we change loggedInStatus reverse to get before login
    return loggedInStatus;
  }

  getLoginRegisterStatus() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      registeredStatus = prefs.getBool(registeredPreferenceKey) ?? false;
      loggedInStatus = prefs.getBool(isUserLoggedInPreferenceKey) ?? false;
    });
    showLog("Registered status : $registeredStatus");
    showLog("Logged In status : $loggedInStatus");
  }

  final List<DrawerMenuItem> drawerItems = [];
  final List<DrawerMenuItem> drawerItemsIfLoggedIn = [];


  SideDrawerModel? drawerChild;

  int? _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    drawerChild = Provider.of<SideDrawerModel>(context, listen: false);
    _selectedIndex = drawerChild!.drawerChildIndex;
    _selectedIndex = showLog(
        'side drawer previous selected ${drawerChild!.drawerChildName}');

    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 40),
        decoration: BoxDecoration(
          //gradient: LinearGradient(colors: [Colors.black26, Colors.black45]),
          color: Colors.white,
          //   boxShadow: [BoxShadow(color: Theme.of(context).accentColor)],
        ),
        width: 300,
        child: menuList(context, registeredStatus),
      ),
    );
  }

  _onSelected(int index) {
    //getLoginRegisterStatus();
    setState(() => _selectedIndex = index);
  }

  Widget menuList(BuildContext context, bool registeredStatus) {
    return ListView(
      children: <Widget>[
        UIHelper.verticalSpaceMedium,
        Container(
          height: 90,
          child: Image.asset('assets/images/studio_logo.png'),
        ),
        SizedBox(height: 10.0),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            //itemCount: ((registeredStatus == true) || (loggedInStatus == true))
            itemCount: (loggedInStatus == true)
                ? drawerItemsIfLoggedIn.length
                : drawerItems.length,
            itemBuilder: (BuildContext context, int index) {
              var sideDrawerItems =
                  //((registeredStatus == true) || (loggedInStatus == true))
                  (loggedInStatus == true)
                      ? drawerItemsIfLoggedIn
                      : drawerItems;
              return Column(
                children: <Widget>[
                  Material(
                    child: InkWell(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                            child: Icon(
                              sideDrawerItems[index].icon,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                            child: CommonText(
                                text: sideDrawerItems[index].title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: _selectedIndex != null &&
                                              _selectedIndex == index
                                          ? Theme.of(context).primaryColor
                                          : Colors.black,
                                    )),
                            /*Text(sideDrawerItems[index].title,
                                style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal,
                                      color: _selectedIndex != null &&
                                              _selectedIndex == index
                                          ? Theme.of(context).primaryColor
                                          : Colors.black,
                                    )),*/
                          ),
                        ]),
                      ),
                      onTap: () {
                        _onSelected(index);
                        drawerChild!.setDrawerChild(
                            sideDrawerItems[index].destination,
                            sideDrawerItems[index].title,
                            index,
                            sideDrawerItems[index].bottomNavigationIndex);
                        Navigator.pop(context);
                        /* Navigator.pushNamed(
                            context, drawerItems[index].destination);*/
                      },
                      //  splashColor: splashColor!,
                    ),
                    color: Colors.white,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                ],
              );
            }),
        SizedBox(height: 20.0),
      ],
    );
  }
}

class DrawerMenuItem {
  String title;
  IconData icon;
  var destination;
  int bottomNavigationIndex;
  String? subTitle;

  DrawerMenuItem(
      this.icon, this.title, this.destination, this.bottomNavigationIndex,
      {this.subTitle});
}
