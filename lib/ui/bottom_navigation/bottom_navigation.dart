import 'package:flutter/material.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/ui/bottom_navigation/customer_bottom_navigation.dart';
import 'package:photomall_flutter/ui/bottom_navigation/guest_bottom_navigation.dart';
import 'package:photomall_flutter/ui/bottom_navigation/photomall_bottom_navigation.dart';
import 'package:photomall_flutter/ui/bottom_navigation/photomall_user_bottomnav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigation extends StatelessWidget {
  final int initialIndex;
  final Key? loginKey;
  final Key? bookNowKey;

  const BottomNavigation({
    Key? key,
    this.initialIndex = 1,
    this.loginKey,
    this.bookNowKey,
  }) : super(key: key);

  @override
  void initState() {
    print(">>> ${initialIndex}");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: isLoggedIn(),
        builder: (context, snapshot) {
          //not logged in show guest navigation bar
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return GuestBottomNavigation();
          }
          if (isPhotomallApp) {
            return snapshot.data!
                ? PhotomallBottomNavigationUser()
                : PhotomallBottomNavigationGuest();
          }
          return snapshot.data!
              ? CustomerBottomNavigation()
              : GuestBottomNavigation();
        });
  }

  Future<bool> isLoggedIn() async {
    var pref = await SharedPreferences.getInstance();
    return pref.getBool('$isUserLoggedInPreferenceKey') ?? false;
  }
}
