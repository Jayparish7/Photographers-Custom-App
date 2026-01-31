import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/Utils/snackbar_helper.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/api_constants.dart';
import 'package:photomall_flutter/core/constants/api_urls_constants.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/common_error_message_model.dart';
import 'package:photomall_flutter/core/models/apiModels/login_model.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_table_dao.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/ui/app_side_drawer/side_drawer_constants.dart';
import 'package:photomall_flutter/ui/bottom_navigation/bottom_navigation_constants.dart';
import 'package:photomall_flutter/ui/drawer/home_route.dart';
import 'package:photomall_flutter/ui/drawer/side_drawer_model.dart';
import 'package:photomall_flutter/ui/login/login_route.dart';
import 'package:photomall_flutter/ui/popup/force_update_dialog.dart';
import 'package:photomall_flutter/ui/popup/logout_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ApiHelper {
  //header for normal request
  var header = {
    'Accept': 'application/json',
    'Authorization': '',
    'Cookie': ''
  };

  //header for json request
  var jsonHeader = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': '',
    'Cookie': ''
  };
  String setCookieHeader = '';

  /*final cookies = <Cookie>[
    Cookie("", ""),
    Cookie("", ""),
    Cookie("", ""),
    Cookie("", ""),
  ];*/
  //bool _isFetching = false;

  //bool get isFetching => _isFetching;
  /* List<Cookie> parseSetCookie(String setCookieHeader) {
    List<Cookie> cookies = [];

    // Split the Set-Cookie header into individual cookie strings
    List<String> cookieStrings = setCookieHeader.split(';');

    // Parse each cookie string and add it to the list
    for (String cookieString in cookieStrings) {
      // Trim any leading or trailing whitespaces
      cookieString = cookieString.trim();

      // Split the cookie string into name and value
      List<String> parts = cookieString.split('=');

      if (parts.length == 2) {
        String name = parts[0];
        String value = parts[1];

        // Create a new Cookie object and add it to the list
        cookies.add(Cookie(name, value));
      }
    }

    return cookies;
  }*/

  List<Cookie> parseSetCookie(String setCookieHeader) {
    List<Cookie> cookies = [];

    // Split the Set-Cookie header into individual cookie strings
    List<String> cookieStrings = setCookieHeader.split(';');

    // Parse each cookie string and add it to the list
    for (String cookieString in cookieStrings) {
      // Trim any leading or trailing whitespaces
      cookieString =
          cookieString.trim().replaceAll(',', '').replaceAll(' ', '');

      // Split the cookie string into name and value
      int equalsIndex = cookieString.indexOf('=');

      if (equalsIndex != -1) {
        String name = cookieString.substring(0, equalsIndex);
        String value = cookieString.substring(equalsIndex + 1);

        // Create a new Cookie object and add it to the list
        cookies.add(Cookie(name, value));
      }
    }

    return cookies;
  }

  Future<void> saveCookies(List<Cookie> cookies, url) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final cookiePath = "${appDocumentDir.path}/.cookies/cookies.json";
    final cj = PersistCookieJar(storage: FileStorage(cookiePath));

    // Save cookies to the cookie jar
    await cj.saveFromResponse(Uri.parse('$baseUrl$url'), cookies);
  }

  //await Future.wait(waitList);

  getCookiesForRequest(String url) async {
    // Get the application's document directory
    final appDocumentDir = await getApplicationDocumentsDirectory();

    // Specify the file path for storing cookies
    final cookiePath = "${appDocumentDir.path}/.cookies/cookies.json";

    // Initialize the PersistCookieJar with the specified storage location
    final cj = PersistCookieJar(storage: FileStorage(cookiePath));

    // Load cookies from the cookie jar for the specified URL
    List<Cookie> cookies = await cj.loadForRequest(Uri.parse(url));

    return cookies;
  }

  Future<dynamic> apiRequest(
      String url, Map<String, dynamic> map, BuildContext? context,
      {bool isShowProgress = true, bool showSnackBarIfError = true}) async {
    //pr = new ProgressDialog(context, type: ProgressDialogType.circle);

    showLog("apiRequest 0.1:: Context $context");

    //   if (isNetWorkAvailable == false) {

    //  throw OfflineException('You are in offline');
    //  }
    var _accessToken =
        await PreferenceHelper.getString('$accessTokenPreferenceKey') ;

    //List<Cookie> results = await cj.loadForRequest(Uri.parse('$baseUrl$url'));

    var headerCookies = await getCookiesForRequest('$baseUrl$url');
    var cookieHeaders = headerCookies
        .map((cookie) => '${cookie.name}=${cookie.value}')
        .join('; ')
        .toString();

    showLog('getCookiesForRequest  $cookieHeaders');

    try {
      if (url != deviceRegisterUrl) {
        map[clientSecret] =
            await PreferenceHelper.getString(clientSecretPreferenceKey) ;
      }
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      map[appVersionCode] =
          packageInfo.buildNumber; //studioVersionConfig; //210.toString();

      map[applicationCode] = studioId;
      showLog("Access token in api handler : 8 $context");

      header['Authorization'] = 'Bearer $_accessToken';
      header['Cookie'] = '$cookieHeaders';
      showLog(
          'Api Request: Url:$baseUrl$url, Body:${jsonEncode(map)}, headers:$header }');
      //showLog('Api Request: Url:$baseUrl$url, Body:$map, Headers:');
      showLog("Access token in api handler : 9 $context");
      var response = await http.post(Uri.parse('$baseUrl$url'),
          body: map, headers: header);
      showLog("Access token in api handler : 10 $context");
      showLog('Response status: ${response.statusCode}');
      showLog('Response header: ${response.headers}');
      showLog('Response body: ${response.body}');

      setCookieHeader = response.headers['set-cookie'] ?? '';
      List<Cookie> cookies1 = parseSetCookie(setCookieHeader);
      await saveCookies(cookies1, url);

      return _returnResponse(response, url, 1, context, map);
    } catch (e){
      showLog('No network connection $context');
      showLog("the Exception msg from api helper$e");
      if (context != null) {
        customSnackBar(
            context: context,
            title: S.of(context).no_internet_connection,
            message: S.of(context).check_your_internet_connection);
      }
      return _checkConnectivity(url, map, context);
    }
  }

  apiJsonRequest(String url, Map<String, dynamic> value,
      [showProgress = false, BuildContext? context]) async {
    var prefs = await SharedPreferences.getInstance();
    var _accessToken = prefs.getString('$accessTokenPreferenceKey') ?? '';
    showLog('saveFromResponse ');

    showLog('saveFromResponse json  ');
    var headerCookies = await getCookiesForRequest('$baseUrl$url');
    var cookieHeadersJSon = headerCookies
        .map((cookie) => '${cookie.name}=${cookie.value}')
        .join('; ')
        .toString();

    showLog('getCookiesForRequest  $cookieHeadersJSon');

    try {
      if (url != deviceRegisterUrl) {
        value[clientSecret] =
            await PreferenceHelper.getString(clientSecretPreferenceKey);
        showLog("deviceRegisterUrl called");
      }
      var clientSecret1 =
          await PreferenceHelper.getString(clientSecretPreferenceKey);
      showLog('prefs:$clientSecret1');
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      value[appVersionCode] =
          packageInfo.buildNumber; //studioVersionConfig;//210.toString(); //
      value[applicationCode] = studioId;
      jsonHeader['Authorization'] = 'Bearer $_accessToken';
      jsonHeader['Cookie'] = '$cookieHeadersJSon';
      showLog(
          'Api Json Request: Url:$baseUrl$url, Body:$value, headers:$jsonHeader}');
      var body = json.encode(value);
      showLog(json.encode(value));
      var response = await http.post(Uri.parse('$baseUrl$url'),
          headers: jsonHeader, body: body);
      showLog('Response status: ${response.statusCode}');
      showLog('Response body: ${response.body}');
      showLog('Response header: ${response.headers}');
      setCookieHeader = response.headers['set-cookie'] ?? '';
      List<Cookie> cookies1 = parseSetCookie(setCookieHeader);
      await saveCookies(cookies1, url);

      return _returnResponse(response, url, 2, context, showProgress, value);
    } catch(e) {
      showLog('No network connection');
      customSnackBar(
          context: context,
          title: S.of(context!).no_internet_connection,
          message: S.of(context).check_your_internet_connection);

      throw FetchDataException('No Internet connection');
    }
  }

  /*
  * 200 - ok
  * 201 Created
                The request has been fulfilled, resulting in the creation of a new resource.
  * 304 Not Modified
  * 400 Bad Request
  * 401 Unauthorized
  * 403 Forbidden
  * 404 Url not found
  * 426 Upgrade Required
  * 500 Internal Server Error*/

  dynamic _returnResponse(http.Response response, String url, int from,
      [BuildContext? context, showProgress, map]) async{
    switch (response.statusCode) {
      case 200:
        var responseJson = response.body;
        return  responseJson ;
      case 409:
        // do some

        showLog("0004090000");
        // [photo selection table]change confirmation status to submitted - 1
        Map map = json.decode(response.body);
        String eventCode = map['event_code'];
        showLog("eventCode where :: ${map['event_code']}");
        ToastUtil.showSnackBarAtCurrentState(
            S.of(context!).thisEventAlreadySubmitted);
        PhotoSelectionsDao photoSelectionsDao = PhotoSelectionsDao();
        photoSelectionsDao.updateSubmittedStatusByEventCode(
            eventCode, 1); // toggle to submitted

        return """{
    "photo_selection_image_statuses":[]}""";

      case 201:
        var responseJson = response.body;
        return responseJson;
            case 304:
        throw {showLog('no update available'), response.toString()};
      case 400:
        var errorMessage = _showCommonErrorMessage(response.body);
        errorMessage.then((response) {
          showLog('errorMessage: ${response.errorMessage}');
          if (context != null) {
            return customSnackBar(
                context: context,
                title: S.of(context).somethingWentWrong,
                message: response.errorMessage ?? "");
          }
        });
        throw {
          BadRequestException(response.body.toString()),
        };
      case 401:
        if (url != refreshTokenUrl) {
          return _refreshToken(url, map, context!)
              .then((LoginModel? response) async {
            var prefs = await SharedPreferences.getInstance();

            if (response != null) {
              showLog(
                  'Access token in api handler : 4 ${prefs.getString('$accessTokenPreferenceKey')}');

              // prefs.setString('$accessTokenKey', response.data.accessToken);

              showLog(
                  'Access token in api handler : 5 ${prefs.getString('$accessTokenPreferenceKey')}');

              //prefs.setString('$refreshTokenKey', response.data.refreshToken);

              showLog('refresh_token_response: ${response.toString()}');

              // prefs.setString('$userRandomIdKey', response.userRandomId);
              await prefs.setBool(otpApiCallKey, true);

              //update user preference
              prefs.setBool(isUserLoggedInPreferenceKey, true);
              //prefs.setString(userMobileNumberKey, emailOrMobile);
              //  showLog("User Random Id : ${response.userRandomId}");
              //showLog("User Name : $emailOrMobile");
              //   prefs.setString(userRandomIdPreferenceKey, response.userRandomId);
              //client id for otp api call
              //   prefs.setInt(clientIdPreferenceKey, response.clientId);
              //update user preference

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeRoute()),
                  ModalRoute.withName("/Home"));

              /*  if (from == 1) {
                apiRequest(url, map, false);
              } else if (from == 2) {
                apiJsonRequest(url, map, false);
              }*/
            }
          });
        } else {
          showLog('inside refresh token else');
          if (context != null) {
            return Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeRoute()),
                ModalRoute.withName("/Home"));
          }
        }
        break;

      // throw response.toString();
      case 403:
        throw {
          UnauthorisedException(response.body.toString()),
        };
      case 422:
        {
          showLog(
              "The response required status is null please fill the valid data");

          throw {response.body};

        }
      case 426:
        {
          showLog(
              "inside api handler : error response 426 api version changed");
          if (context != null) {
            var _appForceUpdateDialog = appForceUpdateStatusDialog(
                context,
                S.of(context).you_are_using_outdated_app,
                S.of(context).kindly_update_to_the_latest_version);
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => _appForceUpdateDialog);
          }
          showLog(
              "inside api handler : error response 426 api version changed");
          break;
        }
      case 429:
        {
          var res = response.headers['retry-after'];

          showLog('Too Many Requests. Please wait before retrying.$res');
          // Store the current time as the last API call time

          await ToastUtil.showSnackBarAtCurrentState(
              'Something went wrong!.Please Try again after sometime',seconds: 10);
          if(context!=null){
            await ToastUtil.showLongToast(context,
                'Something went wrong!.Please Try again after sometime',);
          }
          await Future.delayed(Duration(seconds: 120), () {
            showLog('Retrying after 120 seconds.');
          });
           await Future.delayed(Duration(minutes: int.parse(res ?? '600')), () {
            showLog('Retrying after 120 seconds.');
          });

          throw FetchDataException(
              'Too Many Requests. Please wait before retrying.');
        }
      case 451:
        {
          showLog(
              'Ip Blocked on $url ${response.body} :: map :: ${map.toString()}');
          if (context != null) {
            customSnackBar(
                context: context,
                title: 'Ip Blocked',
                message:
                    'Ip Blocked on $url ${response.body} :: map :: ${map.toString()}');
          }
          throw FetchDataException(
              'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
        }
      case 500:
        throw {
          if (context != null)
            {
              customSnackBar(
                  context: context,
                  title: S.of(context).something_went_wrong,
                  message: S.of(context).please_try_after_some_time)
            }
        };

      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<CommonErrorMessageModel> _showCommonErrorMessage(body) {
    return compute(commonErrorMessageFromJson, body);
  }

  _checkConnectivity(
      String url, Map<String, dynamic> map, BuildContext? context) async {
    // Simple check to see if we have internet
    showLog("The statement 'this machine is connected to the Internet' is: ");
    // showLog(await DataConnectionChecker().hasConnection);
    // returns a bool

    // We can also get an enum value instead of a bool
    // showLog(
    //     "Current status: ${await DataConnectionChecker().connectionStatus}");
    // showLogs either DataConnectionStatus.connected
    // or DataConnectionStatus.disconnected

    // This returns the last results from the last call
    // to either hasConnection or connectionStatus
    //  showLog("Last results: ${DataConnectionChecker().lastTryResults}");

    // actively listen for status updates
    // this will cause DataConnectionChecker to check periodically
    // with the interval specified in DataConnectionChecker().checkInterval
    // until listener.cancel() is called
    /* var listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          {
            showLog('Data connection is available.');
            if (context != null) {
              customSnackBar(
                  context: context,
                  title: S.of(context).connection_available,
                  message:
                      S.of(context).kindly_restart_the_app_if_not_connected);
            }
            return RestartWidget.restartApp(context!);
            // return apiRequest(url, map);
          }
          break;
        case DataConnectionStatus.disconnected:
          showLog('You are disconnected from the internet.');
          break;
      }
    });*/
    // close listener after 30 seconds, so the program doesn't run forever
    // await Future.delayed(Duration(seconds: 30), () => listener.cancel());
  }

  Future<LoginModel?> _refreshToken(url, map, BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    var _clientSecret =
        await PreferenceHelper.getString(clientSecretPreferenceKey);

    var _refreshToken = prefs.getString('$refreshTokenPreferenceKey') ?? '';
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    var refreshTknMap = {
      clientSecret: _clientSecret,
      grantTypeKey: refreshTokenPreferenceKey,
      refreshTokenPreferenceKey: _refreshToken,
      //'client_id': _clientId.toString(),
      appVersionCode: packageInfo.buildNumber,
      //studioVersionConfig,//210.toString(), //packageInfo.buildNumber;
      applicationCode: studioId,
      KEY_IS_CHANGE_GOOGLE_ADVERTISEMENT_ID: "0"
    };

    showLog('Refresh token Api Request: Url:$baseUrl$refreshTokenUrl, '
        'Body:$refreshTknMap, headers:$header}');

    var responseData = await http.post(Uri.parse('$baseUrl$refreshTokenUrl'),
        body: refreshTknMap, headers: header);

    showLog('Response status: ${responseData.statusCode}');
    showLog('Response body: ${responseData.body}');

    if (responseData.statusCode == 200) {
      return compute(loginModelFromJson, responseData.body);
    }
    if (responseData.statusCode == 401) {
      customSnackBar(
          context: context,
          title: S.of(context).session_expired,
          message: S.of(context).please_login_again);
          await removeValues(context, deletePhotos: false);

      await Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
        SideDrawerModel drawerChild =
            Provider.of<SideDrawerModel>(context, listen: false);
        return drawerChild.setDrawerChild(
            LoginRoute(
              false,
            ),
            S.of(context).login,
            SideDrawerConstants.GuestLogin,
            BottomNavigationConstants.GuestLogin);
      });
        } else {
      return null;
    }
    return null;
  }
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class OfflineException extends AppException {
  OfflineException([String? message]) : super(message, "You are in offline: ");
}

showNoInternet(BuildContext context) {
  customSnackBar(context: context, title: 'internet', message: 'not available');
}
