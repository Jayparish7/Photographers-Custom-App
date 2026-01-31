import 'dart:convert';

import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences>? preferenceValue1;
//Future<SharedPreferences>  preference() => SharedPreferences.getInstance();
//final Future<SharedPreferences> preference = SharedPreferences.getInstance();

class PreferenceHelper {
  //static final Future<SharedPreferences> _preference = SharedPreferences.getInstance();

  static Future<SharedPreferences>? get _preference {
    if (preferenceValue1 != null) return preferenceValue1;
    return SharedPreferences.getInstance();
  }

  static Future<bool> getBool(String key) async {
    return (await _preference)!.getBool(key) ?? false;
  }

  static Future<bool> getBool2(String key) async {
    return (await _preference)!.getBool(key) ?? true;
  }

  static Future<bool> getBoolWithoutNullCheck(String key) async {
    return (await _preference)!.getBool(key) ?? false;
  }

  static Future setBool(String key, bool value) async {
    (await _preference)!.setBool(key, value);
  }

  static Future<int> getInt(String key) async {
    return (await _preference)!.getInt(key) ?? 0;
  }

  static Future setInt(String key, int value) async {
    (await _preference)!.setInt(key, value);
  }

  static Future<String> getString(String key) async {
    return (await _preference)!.getString(key) ?? '';
  }

  static Future setString(String key, String value) async {
    (await _preference)!.setString(key, value);
  }

  static Future<double> getDouble(String key) async {
    return (await _preference)!.getDouble(key) ?? 0.0;
  }

  static Future setDouble(String key, double value) async {
    (await _preference)!.setDouble(key, value);
  }

  static Future setStringList(String key, List<String> value) async {
    (await _preference)!.setStringList(key, value);
  }

  static Future<List<String>?> getStringList(String key) async {
    return (await _preference)!.getStringList(key) ?? [];
  }

  static Future<void> saveMapToPrefs(
      Map<String, dynamic> newMap, String preferenceKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get existing map if any
    String? existingString = prefs.getString(preferenceKey);
    Map<String, dynamic> existingMap = {};

    if (existingString != null) {
      existingMap = json.decode(existingString);
    }

    // Merge existing map with new map
    existingMap.addAll(newMap);

    // Save the merged map
    String jsonString = json.encode(existingMap);
    await prefs.setString(preferenceKey, jsonString);
  }
  static Future<Map<String, dynamic>> getMapFromPrefs(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString =
        prefs.getString(key); // Retrieve JSON string from SharedPreferences
    if (jsonString != null) {
      Map<String, dynamic> map =
          json.decode(jsonString); // Convert JSON string to map
      return map;
    }
    return {}; // Return empty map if no data is found
  }

  static Future<dynamic> getValueForKey(
      String key, String preferenceKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(
        preferenceKey); // Retrieve JSON string from SharedPreferences
    if (jsonString != null) {
      Map<String, dynamic> map =
          json.decode(jsonString); // Convert JSON string to map
      return map[key]; // Retrieve value for the specified key
    }
    return null; // Return null if no data is found or key is not present
  }

  static Future<void> deleteKeyFromMap(String key, String preferenceKey) async {
    showLog("deleteKeyFromMap $key");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(preferenceKey);

    if (jsonString != null) {
      Map<String, dynamic> map = json.decode(jsonString);
      map.remove(key); // Remove the specific key

      // Save the updated map back to preferences
      await prefs.setString(preferenceKey, json.encode(map));
    }
  }

  /*static clearPreference() async {
    try {
      var pref = await _preference;
      pref.remove(PreferenceConst.isUserLogin);
      pref.remove(PreferenceConst.userId);
      pref.remove(PreferenceConst.userName);
      pref.remove(PreferenceConst.professionalTitle);
      pref.remove(PreferenceConst.profileImage);
      pref.remove(PreferenceConst.token);
      pref.remove(PreferenceConst.userEmail);
      pref.remove(PreferenceConst.userMobileNumber);
      pref.remove(PreferenceConst.userColorCode);
      pref.remove(PreferenceConst.connectedUserId);
      pref.remove(PreferenceConst.userProfileCompletion);
      pref.remove(PreferenceConst.openBookFirstTime);

    } catch (e) {
      print(e);
    }
  }*/

  /*static logoutPreference() async {
    var pref = await _preference;
    pref.remove(isUserLoggedIn);
    pref.remove(registeredKey);
    pref.remove(accessTokenPreferenceKey);
    pref.remove(refreshTokenPreferenceKey);
    pref.remove(userNameSharedPreferenceKey);
    pref.remove(isEnableB2BPreferenceKey);
    pref.remove(defaultCompanyCodePreferenceKey);
    pref.remove(defaultCompanyNamePreferenceKey);
    pref.remove(userInfoPreferenceKey);
    pref.remove(companiesInfoPreferenceKey);
    pref.remove(isEnableB2BAsTemporaryPreferenceKey);
    pref.remove(userProfileUrlSharedPreferenceKey);
    pref.remove(userMobileNumberKey);
    pref.remove(canAskQuestionsAndReviewsPreferenceKey);
  }*/

  static Future remove(String key) async {
    (await _preference)!.remove(key);
  }
}
