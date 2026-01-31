import 'package:flutter/material.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/login_controller.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/otp_model.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/ui/base/base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:toast/toast.dart';

class OtpViewModel extends BaseModel {
  ApiHelper? apiHandler;
  BuildContext? context;

  PhotomallApis? apiRepo;

  OtpViewModel({this.apiHandler, this.context}) {
    this.apiRepo = PhotomallApis(this.context);
  }

  List<EventIdDetails> events = [];
  var clientId = 0;
  var userMobileNumber = "";
  var userName;
  String clientSecret = "";
  String userRandomId = "";
  String? otp;
  String signature = "{{ app signature }}";
  String? deviceId;
  bool isPartyApp = false;
  bool isGalleryAvailable = false;
  bool isOtpApiCalled = false;

  getUserDetails() async {
    await SmsAutoFill().listenForCode;
    signature = await SmsAutoFill().getAppSignature;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    clientId = (prefs.getInt('$clientIdPreferenceKey') ?? 0);
    clientSecret = (prefs.getString('$clientSecretPreferenceKey') ?? "");
    userMobileNumber =
        (prefs.getString("$userMobileNumberPreferenceKey") ?? "");
    userName = (prefs.getString("$userNameSharedPreferenceKey") ?? "");
    userRandomId = (prefs.getString("$userRandomIdPreferenceKey") ?? "");

    deviceId = (prefs.getString("$deviceIdPreferenceKey") ?? "");
    await getStudioType();
    await getGalleryAvailability();
  }

  getStudioType() async {
    var pref = await SharedPreferences.getInstance();
    var party = pref.getString('$studioTypeKey') ?? '';
    if (party == 'Party') {
      showLog('getStudioTypeOtp $party');
      isPartyApp = true;
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

  Future<OtpModel?> oneTimePasswordApiCall({countryId}) async {
    setBusy(true);
    OtpModel? response;

    response = await apiRepo!.oneTimePasswordApiCall(
        otp.toString(),
        userMobileNumber.toString(),
        clientId,
        clientSecret.toString(),
        userRandomId.toString(),
        context,
        "0",
        countryId.toString());
    if (response != null) {
      showLog("ResponseOtp studioUserId ${response}} >>> ");
      showLog("the screen shot where ${response.screenShot} >>> ");
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setBool(isUserLoggedInPreferenceKey, true);
      await prefs.setBool(otpApiCallKey, true);
      bool? otpApi = await prefs.getBool(otpApiCallKey);
      showLog('prefs.setBool otpApiCallKey $otpApi');
      await prefs.setString(accessTokenPreferenceKey, response.accessToken!);
      await prefs.setString(refreshTokenPreferenceKey, response.refreshToken!);

      try {
        LoginController loginController = LoginController();
        await loginController.setUpLoginData();
      } catch (e, s) {
        showLog('error in setUpLoginData $e $s');
      }

      setBusy(false);
      if (response?.screenShot != null && response?.screenShot == true) {
        await PreferenceHelper.setBool(screenShotPreferenceKey, true);
        ToastUtil toastUtil = ToastUtil();
        ToastContext().init(context!);
        await toastUtil.showShortToast(
            context!, "Close the app and reopen to enable screenshot ");
      }
      return response;
    }
    return null;
  }
/*accountDeletionStoreApiCall()async{
    var response = await PhotomallApis(context).deletionStoreApi();
    if(response!=null) {
      showLog('accountDeletionStoreApiCallLogin${response.data.code}');
      Map<String, String> deletedData = {
          response.data.code: response.data.daysCount.toString()
      };
      String encodedMap = json.encode(deletedData);
    await PreferenceHelper.setString(isDeletedDataKey, encodedMap);
      await PreferenceHelper.setBool(isDeletedKey,true);

    }
  }*/
}

class EventIdDetails {
  String id;
  String name;

  EventIdDetails(this.id, this.name);
}
