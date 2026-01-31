import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/user_data_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/driftdb/dao/real_person_dao.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/ui/drawer/side_drawer_model.dart';
import 'package:photomall_flutter/ui/login/login_route.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../backgroundCron/cron_util.dart';
import '../../color_constants.dart';
import '../../core/Utils/preference_helper.dart';
import '../../driftdb/dao/user_persons_dao.dart';
import '../event/list/events_list_route.dart';
import '../shared_widgets/common_text.dart';

const CURVE_HEIGHT = 140.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;

logoutDialog(BuildContext context) {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  return showLogoutBottomSheet(context, isLoading);
}

Future<bool> signOutFromGoogle() async {
  GoogleSignIn googleSignIn = GoogleSignIn();

  try {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    return true;
  } on Exception catch (_) {
    return false;
  }
}

removeValues(BuildContext context,
    {bool? deletePhotos, bool? isFromDeletePage = false}) async {
  var prefs = await SharedPreferences.getInstance();

  prefs.remove(isUserLoggedInPreferenceKey);

  UserDataController userDataController = UserDataController();
  BackgroundTasks backgroundTasks = BackgroundTasks();
  UserPersonsDao userPersons = UserPersonsDao();
  RealPersonsDao realPersonsDao = RealPersonsDao();
  showLog('deleteEvents');
  await userPersons.deleteUserPersonsForLogOut();
  await realPersonsDao.deleteRealPersons();
  await userDataController.deleteUserEventsFromDb();
  // delete profile images
  await userDataController.deleteUserProfile();
  // delete user events
  await userDataController.deleteUserEventsFromDb();
//  Provider.of<SideDrawerModel>(context,listen: false).setCustomerView();
  var firebase = await prefs.getBool(firebaseKey);
  var firebaseGoogle = await prefs.getBool(signInWithGoogleKey);
  showLog("firebase logout $firebase $firebaseGoogle}");
  showLog(
      "access token : ${prefs.getString(accessTokenPreferenceKey)}\n firebase logout ${prefs.getBool(firebaseKey)}");
  backgroundTasks.cancelBackgroundTasks();
  prefs.remove(registeredPreferenceKey);
  prefs.remove(accessTokenPreferenceKey);
  prefs.remove(refreshTokenPreferenceKey);
  prefs.remove(eventKeyPreferenceKey);
  prefs.remove(userNameSharedPreferenceKey);
  prefs.remove(userDataKey);
  prefs.remove(screenShotPreferenceKey);
  prefs.remove(profileImage);
  prefs.remove(redirectionConstant);
  prefs.remove(isNotificationsAvailablePreferenceKey);
  prefs.remove(callFoldersApi);
  prefs.remove(callOnceKey);
  prefs.remove(profileKey);
  prefs.remove(userMobileNumberPreferenceKey);
  prefs.remove(isDeletedKey);
  prefs.remove(isDeletedDataKey);
  prefs.remove(userId);
  prefs.remove(otpApiCallKey);
  prefs.remove(lastUpdatedAtMap);
  prefs.remove(userMaritalDetailsKey);
  prefs.remove(userDataLastUpdatedKey);
  prefs.remove(scrollOffsetKey);
  prefs.remove(scrollIndexKey);
  prefs.remove(BDayWishKey);
  prefs.remove(anneWishKey);
  prefs.remove(googleProfileUrlKey);
  prefs.remove(profileUrlKey);
  if (firebase == true) {
    prefs.remove(firebaseKey);
    await FirebaseAuth.instance.signOut();
  }
  if (firebaseGoogle == true) {
    prefs.remove(signInWithGoogleKey);

    await signOutFromGoogle();
  }

  if (isPhotomallApp == false) {
    var gallery = await PreferenceHelper.getBool(galleryKey);
    var carousel = await PreferenceHelper.getBool(carouselKey);
    var party = await PreferenceHelper.getString(studioTypeKey);
    if (party != 'Party' ||
        (party == 'Party' && gallery == true ||
            party == 'Party' && carousel == true)) {
      showLog('getGalleryAvailability ee $gallery $carousel');
      SideDrawerModel drawerModel =
          Provider.of<SideDrawerModel>(context, listen: false);
      party != 'Party'
          ? drawerModel.setDrawerChild(
              LoginRoute(true), S.of(context).login, 3, 3)
          : drawerModel.setDrawerChild(
              EventsListRoute(
                arguments: EventsListArguments(isArchivedEven: false),
              ),
              S.of(context).events,
              1,
              1);
      Navigator.pop(context);
    } else {
      SideDrawerModel drawerModel =
          Provider.of<SideDrawerModel>(context, listen: false);
      drawerModel.setDrawerChild(
          EventsListRoute(
            arguments: EventsListArguments(isArchivedEven: false),
          ),
          S.of(context).events,
          0,
          0);
      Navigator.pop(context);
    }
  } else {
    Navigator.pop(context);
    SideDrawerModel drawerModel =
        Provider.of<SideDrawerModel>(context, listen: false);
    drawerModel.setDrawerChild(
        /*EventsListRoute(
          arguments: EventsListArguments(isArchivedEven: false),
        ),*/
        LoginRoute(true),
        S.of(context).login,
        2,
        2);
  }
}

showLogoutBottomSheet(BuildContext context, ValueNotifier<bool> isLoading) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UniqueText(
                  text: S.of(context).logOut,
                  //style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            SizedBox(height: 10),
            CommonText(
              style: TextStyle(
                  color: AppColorData.cardHighlightedTextColour, fontSize: 18),
              text: S
                  .of(context)
                  .are_you_sure_you_want_to_logout_after_logout_your,
            ),
            SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (BuildContext context, bool value, Widget? child) {
                return value
                    ? CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CommonTextButton(
                            onPressCall: () {
                              showLog('the context of the >> ${context}');
                              Navigator.pop(context, false);
                            },
                            buttonText: S.of(context).no,
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor:
                                  AppColorData.buttonBackgroundColors.last,
                              foregroundColor: AppColorData.buttonTextColors,
                            ),
                            onPressed: () {
                              isLoading.value = true;
                              PhotomallApis(context)
                                  .logoutApiCall(context)
                                  .then((response) async {
                                await removeValues(context, deletePhotos: true);
                                isLoading.value =
                                    false; // Reset isLoading once done
                              });
                            },
                            child: Text(S.of(context).yes),
                          ),
                        ],
                      );
              },
            ),
          ],
        ),
      );
    },
  );
}
