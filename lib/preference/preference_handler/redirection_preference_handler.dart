import 'dart:convert';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/preference/preference_model/redirection_preference_model.dart';

class ReDirectionPreference {
  Future<void> setReDirectionDetails(RedirectionModel redirectionModel,
      {String redirectionConstantFrom = ''}) async {
    showLog(
        "setReDirectionDetails step 1Redirection route saved > redirectionConstantFrom :${redirectionConstantFrom}::  ${jsonEncode(redirectionModel.redirection!.route)}");
    await PreferenceHelper.setString(
        redirectionConstant, jsonEncode(redirectionModel.toJson()));
    showLog(
        " setReDirectionDetails step 2 Redirection route saved >  ${jsonEncode(redirectionModel.toJson())}");

    return;
  }

  Future<void> removeRedirection() async {
    showLog("removeRedirection");
    await PreferenceHelper.remove(redirectionConstant);
  }

  /// Get Design Data From Preference
  Future<RedirectionModel?> getRedirectionRoute() async {
    String reDirection = await PreferenceHelper.getString(redirectionConstant);

    if (reDirection == '' || reDirection.isEmpty || reDirection == '') {
      return null;
    }

    showLog('redirection getting $reDirection');
    Map<String, dynamic> jsonMap =
        jsonDecode(reDirection) as Map<String, dynamic>;
    return RedirectionModel.fromJson(jsonMap);
  }
}
