import 'package:flutter/material.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/login_model.dart';
import 'package:photomall_flutter/ui/base/base_model.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class RegisterModel extends BaseModel {
  ApiHelper? apiHandler;
  BuildContext? context;
  PhotomallApis? apiRepo;

  RegisterModel({this.apiHandler, this.context}) {
    this.apiRepo = PhotomallApis(this.context);
  }

  int clientId = 0;
  String signature = "";
  List<Country> countriesList = [];
  List<String> countries = [];

  List<DropdownMenuItem> countriesDropDown = [];
  String selectedCountry = "India";
  var countryCodeId = 108;

  void getUserDetails() async {
    await getCountriesList();
    await _getOtpSignature();
  }

  Future<void> getCountriesList() async {
    try {
      // CountryCodeModel response = await apiRepo.countryCodeApiCall();
      // _parseCountryCode(response);
    } catch (e) {}
  }

  Future<void> _getOtpSignature() async {
    //await SmsAutoFill().listenForCode;
    signature = await SmsAutoFill().getAppSignature;
    showLog(signature);
  }

  register(name, mobileNumber, emailAddress) async {
    setBusy(true);
    //need to check signature, clientId null
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(userNameSharedPreferenceKey, name);
    try {
      LoginModel response = await apiRepo!.registerApiCall(signature, name,
          mobileNumber, countryCodeId.toString(), "0", emailAddress, "0", "0");
      _parseRegister(prefs, response, name, mobileNumber);
    } on OfflineException catch (e) {
      showLog('showInternetRequired $e');
      ToastUtil.showInternetRequired(context!);
      setBusy(false);
    } catch (e) {
      setBusy(false);
    }
  }

  _parseRegister(
      SharedPreferences prefs, LoginModel response, name, mobileNumber) {
    /*if (response.errorMessage != null) {
        showLog('registerError->${response.errorMessage}');
        return;
      }*/
    if (response.status != null) {
      //   showLog(response.userRandomId);
      prefs.setBool(registeredPreferenceKey, true);
      prefs.setString(userNameSharedPreferenceKey, name);
      prefs.setString(userMobileNumberPreferenceKey, mobileNumber);
      //prefs.setString(userRandomIdPreferenceKey, response.userRandomId);
      //client id for otp api call
      // prefs.setInt(clientIdPreferenceKey, response.clientId);
      _showOtpPopup();
    }
  }

  void _showOtpPopup() {
    showDialog(
      builder: (_) => AlertDialog(
        content: SingleChildScrollView(
            // child: OtpPopup(this.context,countryCode: ,)
            ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        backgroundColor: Theme.of(context!).primaryColor,
      ),
      context: context!,
      barrierDismissible: false,
    );
  }
}

class Country {
  int? id;
  String? country;
  String? countryCode;
  String? countryShortCode;

  Country({
    this.id,
    this.country,
    this.countryCode,
    this.countryShortCode,
  });
}
