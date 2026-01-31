import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/login_controller.dart';
import 'package:photomall_flutter/core/Utils/snackbar_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/otp_model.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/preference/preference_handler/redirection_preference_handler.dart';
import 'package:photomall_flutter/preference/preference_model/redirection_preference_model.dart';
import 'package:photomall_flutter/ui/app_side_drawer/side_drawer_constants.dart';
import 'package:photomall_flutter/ui/bottom_navigation/bottom_navigation_constants.dart';
import 'package:photomall_flutter/ui/drawer/side_drawer_model.dart';
import 'package:photomall_flutter/ui/event/list/events_list_route.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../controllers/redirection_controller.dart';
import '../../constants/studio_config_constants.dart';
import '../../models/apiModels/truecaller_accessToken _response_model.dart';
import '../../models/apiModels/truecaller_user_info_response_model.dart';

class TrueCallerUtils {
  bool? forLogin;
  PhotomallApis photomallApis = PhotomallApis(null);
  LoginController loginController = LoginController();
  StreamSubscription? _streamSubscription;
  BuildContext? _context;
  final int? _countryCodeId = 108;
  bool isCalledFirst = false;
  Function? _onLoginSuccess;
  late String? codeVerifier;

  TrueCallerUtils({this.forLogin});

  execute(BuildContext context, {required Function onLoginSuccess}) async {
    _context = context;
    _onLoginSuccess = onLoginSuccess;

    showLog(
        'TRUECALLER :: initializing..$_context $_onLoginSuccess $_countryCodeId');
    try {
      TcSdk.initializeSDK(
          //sdkOption: TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP,

          sdkOption: TcSdkOptions.OPTION_VERIFY_ONLY_TC_USERS);
    } catch (e) {
      showLog('TRUECALLER :: error while initialize $e');
    }

    //  sleep(Duration(milliseconds:1500));

    bool status = await TcSdk.isOAuthFlowUsable;
    showLog('TRUECALLER :: usability status $status');
    TcSdk.isOAuthFlowUsable.then((isOAuthFlowUsable) {
      if (isOAuthFlowUsable) {
        TcSdk.setOAuthState(Uuid().v1());
        TcSdk.setOAuthScopes(['profile', 'phone', 'openid', 'offline_access']);
        TcSdk.generateRandomCodeVerifier.then((codeVerifier) {
          TcSdk.generateCodeChallenge(codeVerifier).then((codeChallenge) {
            if (codeChallenge != null) {
              this.codeVerifier = codeVerifier;
              TcSdk.setCodeChallenge(codeChallenge);
              TcSdk.getAuthorizationCode;
            } else {
              final snackBar = SnackBar(content: Text("Device not supported"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              print("***Code challenge NULL***");
            }
          });
        });
      } else {
        //  final snackBar = SnackBar(content: Text("Not Usable"));
        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print("***Not usable***");
      }
      showLog('TRUECALLER :: step 2');
    });
    try {
      _streamSubscription =
          TcSdk.streamCallbackData.listen((truecallerSdkCallback) async {
        showLog('TRUECALLER :: step 3');
        switch (truecallerSdkCallback.result) {
          case TcSdkCallbackResult.success:
            onLoginSuccess();
            showLog('TRUECALLER :: step 4');
            TcOAuthData tcOAuthData = truecallerSdkCallback.tcOAuthData!;
            String authorizationCode = tcOAuthData
                .authorizationCode; // use this along with codeVerifier generated in step 3.3 to generate an access token
            String stateReceivedFromServer =
                tcOAuthData.state; // match it with what you set in step 3.1
            List<dynamic> scopesGranted = tcOAuthData.scopesGranted;
            showLog(
                'TRUECALLER ::  $authorizationCode  }{ :: $stateReceivedFromServer :: ${scopesGranted}');
            //if (phNo.isNotEmpty && !isCalledFirst) {
            showLog('TRUECALLER :: step 5$stateReceivedFromServer');
            isCalledFirst = true;
            var res = TcSdk.requestVerification(phoneNumber: "PHONE_NUMBER");

            showLog(' result res ${res}');
            var response = await fetchAccessToken(
                AccessTokenHelper(tcOAuthData, codeVerifier!));
            showLog('response fetchAccessToken  ${response.accessToken}');
            var phoneNumber = await fetchUserInfo(response.accessToken!);
            var code = loginController
                .getObjectByCountryCode(phoneNumber.phoneNumberCountryCode!);
            String? code1 = code?.code?.replaceAll('+', '');
            String? phNo = phoneNumber.phoneNumber!.replaceAll('$code1', '');

            showLog(
                'response$code1 removeCountryCode-->$phNo  ${phoneNumber.phoneNumberCountryCode} ,, ');

            await setUserData(context, phNo);
            // } else {
            // can't login with true caller login with your mobile method
            showLog('TRUECALLER :: execute IF ELSE');
            //  }
            break;
          case TcSdkCallbackResult.failure:
            int errorCode = truecallerSdkCallback.error?.code ?? 00;
            String errorMsg = truecallerSdkCallback.error?.message ?? "";
            // ERROR_TYPE_INTERNAL = 0;
            // ERROR_TYPE_NETWORK = 1;
            // ERROR_TYPE_USER_DENIED = 2;
            // ERROR_TYPE_UNAUTHORIZED_PARTNER = 3;
            // ERROR_TYPE_UNAUTHORIZED_USER = 4;
            // ERROR_TYPE_TRUECALLER_CLOSED_UNEXPECTEDLY = 5;
            // ERROR_TYPE_TRUESDK_TOO_OLD = 6;
            //  ERROR_TYPE_POSSIBLE_REQ_CODE_COLLISION = 7;
            // ERROR_TYPE_RESPONSE_SIGNATURE_MISSMATCH = 8;
            // ERROR_TYPE_REQUEST_NONCE_MISSMATCH = 9;

            customSnackBar(
                context: context,
                title: 'Authentication',
                message:
                    'Authentication failed with error $errorMsg code: $errorCode');

            break;

          default:
            showLog('TRUECALLER :: default');
        }
      });
    } catch (e) {
      showLog('problem in true caller ${e}');
    }
  }

  disposeTrueCaller() {
    _streamSubscription?.cancel();
  }

  setUserData(BuildContext context, mobileNumber,
      {isFirebaseLogin = false}) async {
    showLog("Response truecaller response} >>> ");
    PhotomallApis photomallApis = PhotomallApis(null);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var clientId = (prefs.getInt('$clientIdPreferenceKey') ?? 0);
    var clientSecret = (prefs.getString('$clientSecretPreferenceKey') ?? '');
    var userRandomId = (prefs.getString("$userRandomIdPreferenceKey") ?? "");
    try {
      OtpModel? response = await photomallApis.oneTimePasswordApiCall(
          "",
          // otp
          mobileNumber.toString(),
          clientId,
          clientSecret.toString(),
          userRandomId.toString(),
          null,
          "0",
          "108",
          trueCaller: '1'); // default given need to change
      showLog("true caller error step one 7");
      if (response != null) {
        showLog("true caller error step one 8");

        showLog("true caller error step one 9");

        prefs.setBool(isUserLoggedInPreferenceKey, true);
        showLog("true caller error step one 10");
        await prefs.setBool(otpApiCallKey, true);

        prefs.setString(accessTokenPreferenceKey, response.accessToken!);
        showLog("true caller error step one 11");

        prefs.setString(refreshTokenPreferenceKey, response.refreshToken!);
        showLog("true caller error step one 12");

        LoginController loginController = LoginController();
        await loginController.setUpLoginData();

        {
          //setState(() {});

          // call user data and studio user data

          showLog(
              'Navigating to redirection  executeRedirection method worked firebase');

          ReDirectionPreference reDirectionPreference = ReDirectionPreference();
          RedirectionModel? redirection =
              await reDirectionPreference.getRedirectionRoute();
          showLog('method worked truecaller $redirection');
          if (redirection != null &&
              redirection.redirection != null &&
              redirection.redirection!.route != null &&
              redirection.redirection!.route != '') {
            while (Navigator.canPop(context)) {
              //Navigator.pop(context);
            }
            SideDrawerModel drawerModel =
                Provider.of<SideDrawerModel>(context, listen: false);

            drawerModel.setDrawerChild(
                EventsListRoute(
                    arguments: EventsListArguments(isArchivedEven: false)),
                S.of(context).events,
                SideDrawerConstants.PhotomallEvents,
                BottomNavigationConstants.CustomerEvents);
            RedirectionController redirectionController =
                RedirectionController();

            await redirectionController.executeRedirection(
                context, redirection);
            showLog(
                'Navigating to redirection  executeRedirection method worked 2$redirection');

            showLog(
                'Navigating to redirection  executeRedirection method worked');
            return;
          }

          // Add Your Code here.

          // get studio name
          //    String studioName = await getStudioName();

          SideDrawerModel drawerModel =
              Provider.of<SideDrawerModel>(context, listen: false);
          showLog("message for login to throw the gallery page");
          if (!isPhotomallApp) {
            drawerModel.setDrawerChild(
                EventsListRoute(
                  arguments: EventsListArguments(isArchivedEven: false),
                ),
                S.of(context).events,

                // GalleryRoute(),
                //'${'studio name'}',
                1,
                1);
          } else {
            drawerModel.setDrawerChild(
                EventsListRoute(
                  arguments: EventsListArguments(isArchivedEven: false),
                ),
                S.of(context).events,

                // GalleryRoute(),
                //'${'studio name'}',
                0,
                0);
          }
        }
        //});
      }
    } catch (e) {}
  }

  Future<TcSdkAccessTokenResponseModel> fetchAccessToken(
      AccessTokenHelper accessTokenHelper) async {
    showLog('fetchAccessToken  start ${accessTokenHelper.codeVerifier}, '
        'code: ${accessTokenHelper.tcOAuthData.authorizationCode}');

    final response = await http.post(
      Uri.parse('https://oauth-account-noneu.truecaller.com/v1/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'authorization_code',
        'client_id': '$clientId',
        'code': accessTokenHelper.tcOAuthData.authorizationCode,
        'code_verifier': accessTokenHelper.codeVerifier,
      },
    );
    showLog('url : https://oauth-account-noneu.truecaller.com/v1/token');
    showLog('response: ${response.body} \n ${response}');
    TcSdkAccessTokenResponseModel result =
        tcSdkAccessTokenResponseModelFromJson(response.body);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      TcSdkAccessTokenResponseModel result =
          tcSdkAccessTokenResponseModelFromJson(response.body);
      showLog('response accessToken:  ${result.accessToken}');
    } else {}
    return result;
  }

  Future<TcSdkUserInfoResponseModel> fetchUserInfo(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://oauth-account-noneu.truecaller.com/v1/userinfo'),
      headers: {"Authorization": "Bearer $accessToken"},
    );
    showLog('url : https://oauth-account-noneu.truecaller.com/v1/userinfo');
    showLog('response: ${response.body} \n ${response}');
    TcSdkUserInfoResponseModel result =
        tcSdkUserInfoResponseModelFromJson(response.body);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      // Map<String, dynamic> result = jsonDecode(response.body);
    } else {}
    return result;
  }

  String removeCountryCode(String phoneNumber) {
    // Regular expression to match country code
    final RegExp countryCodeRegExp = RegExp(r'^\+\d{1,3}');
    // Replace the country code with an empty string
    return phoneNumber.replaceFirst(countryCodeRegExp, '');
  }
}

class AccessTokenHelper {
  final TcOAuthData tcOAuthData;
  final String codeVerifier;

  AccessTokenHelper(this.tcOAuthData, this.codeVerifier);
}
