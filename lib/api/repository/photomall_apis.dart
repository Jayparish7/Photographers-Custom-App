import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photomall_flutter/core/constants/api_constants.dart';
import 'package:photomall_flutter/core/constants/api_key_constants.dart';
import 'package:photomall_flutter/core/constants/api_urls_constants.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/account_deletion_response_model.dart';
import 'package:photomall_flutter/core/models/apiModels/account_deletion_store_response_model.dart';
import 'package:photomall_flutter/core/models/apiModels/after_login_book_me_model.dart';
import 'package:photomall_flutter/core/models/apiModels/app_update_model.dart';
import 'package:photomall_flutter/core/models/apiModels/before_login_book_me_model.dart';
import 'package:photomall_flutter/core/models/apiModels/common_success_message_model.dart';
import 'package:photomall_flutter/core/models/apiModels/device_register_model.dart';
import 'package:photomall_flutter/core/models/apiModels/error_notification_response.dart';
import 'package:photomall_flutter/core/models/apiModels/image_server_response_model.dart';
import 'package:photomall_flutter/core/models/apiModels/login_model.dart';
import 'package:photomall_flutter/core/models/apiModels/notification_received_response_model.dart';
import 'package:photomall_flutter/core/models/apiModels/notification_update_request_model.dart';
import 'package:photomall_flutter/core/models/apiModels/otp_model.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/event_ai_data.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/screenshot_response_model.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart';
import 'package:photomall_flutter/core/notification/android_notifications_model.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/preference/preference_handler/booking_handler.dart';
import 'package:photomall_flutter/preference/preference_model/booking_model.dart';
import 'package:photomall_flutter/ui/app_config_request_model.dart';
import 'package:photomall_flutter/ui/common_response.dart';
import 'package:photomall_flutter/ui/folders/folder_photo_selection_model.dart';
import 'package:photomall_flutter/ui/photoselection/model/photo_selection_request_model.dart';
import 'package:photomall_flutter/ui/photoselection/model/photo_selection_response_model.dart';
import 'package:photomall_flutter/ui/profile/model/otp_resend_response.dart';
import 'package:photomall_flutter/ui/profile/model/profile_image_model_response.dart';
import 'package:photomall_flutter/ui/profile/model/status_and_message_model.dart';
import 'package:photomall_flutter/ui/profile/model/user_profile_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/apiModels/folder_status_model.dart';
import '../../core/models/apiModels/multiple_face_delete_response_model.dart';
import '../../core/models/apiModels/multiple_faces_index_response_model.dart';
import '../../core/models/apiModels/myPhotos_doubt_images_response_model.dart';
import '../../core/models/apiModels/myPhotos_images_response_model.dart';
import '../../core/models/apiModels/myPhotos_match_person_response_model.dart';
import '../../core/models/apiModels/print_store_response_model.dart';
import '../../core/models/apiModels/print_users_response_model.dart';
import '../../core/models/apiModels/transport_model/my_photos_model.dart';
import '../../core/models/apiModels/un_auth_user_profile_store.dart';
import '../../core/models/apiModels/un_auth_user_store_api_response_model.dart';
import '../../core/models/apiModels/user_events_store_response_model.dart';
import '../../core/models/apiModels/user_persons_store_api_response_model.dart';
import '../../core/models/delete_user_persons_response_model.dart';
import '../../driftdb/app_db.dart';
import '../../driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;

class PhotomallApis {
  BuildContext? context;
  ApiHelper? apiHelper;

  PhotomallApis(BuildContext? _context) {
    if (_context != null) {
      this.context = _context;
      apiHelper = Provider.of<ApiHelper>(context!, listen: false);
    } else {
      apiHelper = ApiHelper();
    }
  }

  Future<LoginModel> registerApiCall(
      String otpSignature,
      String userName,
      String mobileNumber,
      String countryCode,
      String viaGoogleOrNot,
      String emailAddress,
      String isChangeGoogleAdvertisementId,
      String trueCallerSMS) async {
    var registerMap = {
      nameKey: userName,
      countryCodeIdKey: countryCode,
      mobileNumberKey: mobileNumber,
      emailKey: emailAddress,
      //otpSignatureKey: otpSignature,
      //clientIdKey: "6",
      otpSignatureKey: otpSignature.toString(), //need to check
      //googleKey: viaGoogleOrNot
      KEY_IS_CHANGE_GOOGLE_ADVERTISEMENT_ID: isChangeGoogleAdvertisementId,
      //KEY_TRUE_CALLER_SMS: trueCallerSMS
    };

    var response =
        await apiHelper!.apiRequest(registerUrl, registerMap, context);

    return compute(loginModelFromJson, response);
  }

  Future<LoginModel?>? loginApiCall(int countryCodeId, int clientId,
      String signature, String userName, String viaGoogleOrNot,
      {bool? isTrueCaller}) async {
    try {
      var map = {
        nameKey: '',
        countryCodeIdKey: countryCodeId.toString(),
        clientIdKey: clientId.toString(),
        otpSignatureKey: signature.toString(),
        userNameKey: userName.toString(),
        // phone number or email
        googleKey: viaGoogleOrNot,
        'isTrueCaller': isTrueCaller == true ? '1' : '0'
        // by google or not 1-true,0-false
      };

      var response = await apiHelper!.apiRequest(loginUrl, map, context);
      showLog(" =========================");
      return compute(loginModelFromJson, response);
    } catch (e) {
      showLog("inside else ========================= $e");

      return null;
    }
  }

  Future<AfterLoginBookMeModel> afterLoginBookMeApiCall(
      String? eventTypeCategoryId,
      String? eventDate,
      String? remarks,
      String? package) async {
    var afterLoginBookMeMap = {
      dateKey: eventDate,
      categoryCodeKey: eventTypeCategoryId,
      packageKey: package ?? "",
      remarksKey: remarks
    };

    var response = await apiHelper!
        .apiRequest(afterLoginBookMeUrl, afterLoginBookMeMap, context);
    BookingHandler().setBookingDetails(BookingDetail(
        bookingDetail:
            BookingDetailClass(eventTypesCategoriesCode: '', date: '')));
    return compute(afterLoginBookMeModelFromJson, response);
  }

  Future<BeforeLoginBookMeModel> beforeLoginBookMeApiCall(
      String name,
      String mobileNumber,
      String countryCode,
      String otpSignature,
      String clientId,
      String emailId,
      String eventTypeCategoryId,
      String eventDate) async {
    var pref = await SharedPreferences.getInstance();
    int? clientId = pref.getInt(clientIdPreferenceKey);

    var beforeLoginBookMeMap = {
      dateKey: eventDate,
      categoryCodeKey: eventTypeCategoryId,
      nameKey: name,
      mobileNumberKey: mobileNumber,
      countryCodeIdKey: countryCode,
      otpSignatureKey: otpSignature,
      //clientIdKey: "39574",
      clientIdKey: clientId.toString(),
      emailKey: emailId,
      //trueCallerSmsKey: "0"
    };

    var response = await apiHelper!
        .apiRequest(beforeLoginBookMeUrl, beforeLoginBookMeMap, context);

    return compute(beforeLoginBookMeModelFromJson, response);
  }

  Future<OtpModel?> oneTimePasswordApiCall(
      //need to check not handle try catch
      String otp,
      String userMobileNumber,
      int clientId,
      String clientSecret,
      String userRandomId,
      BuildContext? context,
      String viaGoogleOrNot,
      String countryCode,
      {String? trueCaller}) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      bool? otpApi = await prefs.getBool(otpApiCallKey);
      showLog('otpApiCall start started $otpApi');
      if (otpApi != true) {
        String? ableType = prefs.getString(loginType);

        var oneTimePasswordMap = {
          clientIdKey: clientId.toString(),
          oneTimePasswordKey: (otp != '' && otp.isNotEmpty) ? otp : "1111",
          userNameKey: userMobileNumber,
          clientSecretKey: clientSecret,
          grantTypeKey: "otp_grant",
          scopeKey: "*",
          //password: userRandomId,
          trueCallerSmsKey: trueCaller ?? '0',
          googleKey: viaGoogleOrNot,
          'able_type': ableType ?? '',
          countryCodeIdKey: countryCode.toString()
        };

        showLog('Api Request: $oneTimePasswordMap');

        var response = await apiHelper!
            .apiRequest(oneTimePasswordUrl, oneTimePasswordMap, context);

        return compute(otpModelFromJson, response);
      }
      return null;
    } catch (e) {}
    return null;
  }

  Future<AppUpdateStatusModel> appUpdateStatusApiCall(
      String _versionCode) async {
    // String? token = await FirebaseMessaging.instance.getToken();

    var appUpdateStatusMap = {
      appVersion: _versionCode,
      //"fcm_token": token,
    };
    var response =
        await apiHelper!.apiRequest(appUpdateUrl, appUpdateStatusMap, context);

    //return compute(appUpdateStatusModelFromJson, response);
    return appUpdateStatusModelFromJson(response);
  }

  Future<DeviceRegisterModel?> devRegApiCall(
      Map<String, dynamic> deviceMap) async {
    var response =
        await apiHelper!.apiJsonRequest(deviceRegisterUrl, deviceMap, context);
    return compute(deviceRegisterModelFromJson, response);
  }

  Future<CommonResponse> addEventDetailsApiCall(
      BuildContext context, String eventKey, BaseDeviceInfo androidInfo) async {
    var map = {
      //  deviceIdKey: androidInfo.androidId.toString(),
      codeKey: eventKey,
      //    passwordKey: "",
      //    photoMallEventRandomIdKey: ""
    };
    showLog(deviceIdKey);
    var response = await apiHelper!.apiRequest(addEventUrl, map, context);
    return compute(commonResponseFromJson, response);
  }

  Future<CommonSuccessMessageModel> logoutApiCall(BuildContext context) async {
    showLog("logout api call");
    var logoutMap = {'logout': ''};
    var response = await apiHelper!.apiRequest(logoutUrl, logoutMap, context);
    return compute(commonSuccessMessageModelFromJson, response);
  }

  Future<CommonSuccessMessageModel> notificationCall(
      Map<String, dynamic> notificationMap) async {
    //need to check not handle try catch
    var response = await apiHelper!
        .apiRequest(slackNotifications, notificationMap, context);
    return compute(commonSuccessMessageModelFromJson, response);
  }

  Future<UserProfileModel> callUserProfile(BuildContext context) async {
    var response = await apiHelper!.apiRequest(userProfileUrl, {}, context);
    return compute(userProfileModelFromJson, response);
  }

  Future<bool> callUpdateFcmToken(BuildContext context, String token) async {
    Map<String, dynamic> map = {tokenKey: token};
    var response = await apiHelper!.apiRequest(updateFcmTokenUrl, map, context,
        isShowProgress: false, showSnackBarIfError: false);
    return jsonDecode(response)['updated'] ?? true;
  }

  Future<AndroidNotificationsModel> callGetAndroidNotifications(
      BuildContext context) async {
    var response = await apiHelper!.apiRequest(
        getAndroidNotificationsUrl, {}, context,
        isShowProgress: false, showSnackBarIfError: false);
    return compute(androidNotificationsModelFromJson, response);
  }

  Future<bool> callUpdateAndroidNotificationsSeenByUser(
      BuildContext context, String code) async {
    var response = await apiHelper!.apiRequest(
        androidNotificationsUpdateUrl, {codeKey: code}, context,
        isShowProgress: false, showSnackBarIfError: false);
    return jsonDecode(response)['update'];
  }

  Future<CommonResponse> callChangeUserName(
      BuildContext context, String name) async {
    //need to check api
    var map = {nameKey: name};
    var response = await apiHelper!.apiRequest(
        userProfileUpdateUrl, map, context,
        showSnackBarIfError: false);
    //return jsonDecode(response)['updated'];
    return compute(commonResponseFromJson, response);
  }

  Future<CommonResponse> callChangeDob(BuildContext context, String dob) async {
    //need to check api
    var map = {dobKey: dob};
    var response = await apiHelper!.apiRequest(
        userProfileUpdateUrl, map, context,
        showSnackBarIfError: false);
    //return jsonDecode(response)['updated'];
    return compute(commonResponseFromJson, response);
  }

  Future<CommonResponse> callMaritalStatus(BuildContext context,
      String maritalStatus, String anniversaryDate) async {
    //need to check api
    var map = (anniversaryDate != '')
        ? {
            maritalKey: maritalStatus,
            anniversaryKey: anniversaryDate,
          }
        : {
            maritalKey: maritalStatus,
          };
    var response = await apiHelper!.apiRequest(
        userProfileUpdateUrl, map, context,
        showSnackBarIfError: false);
    //return jsonDecode(response)['updated'];
    return compute(commonResponseFromJson, response);
  }

  Future<PhotoSelectionImagesResponseModel> callPhotoSelectionUpdate(
      BuildContext? context,
      {List<PhotoSelectionImageStatus>? inputData}) async {
    var response = await apiHelper!.apiJsonRequest(
      photoSelectionUpdate,
      PhotoSelectionImagesStatusRequest(
        photoSelectionImageStatuses: inputData!,
      ).toJson(),
      context,
    );

    return compute(photoSelectionImagesResponseModelFromJson, response);
  }

  Future<TransportModel?> callAppConfiguration(
    BuildContext? context, {
    bool callPhotoSelection = false,
    required List<InputData> inputData,
  }) async {
    try {
      // var pref = await SharedPreferences.getInstance();
      // List<InputData> inputData = [];

      var response = await apiHelper!.apiJsonRequest(
        applicationConfigurationUrl,
        AppConfigRequest(inputData: inputData).toJson(),
        context,
      );
      return compute(transportModelFromJson, response);
    } catch (e) {
      showLog(
          "the Problem while calling transporter api for : ${e} \n \n${AppConfigRequest(inputData: inputData).toJson()}");
    }
    return null;
  }

  Future<AiDataResponseModel?> aiData(
    BuildContext? context, {
    bool callPhotoSelection = false,
    required List<InputData> inputData,
  }) async {
    try {
      showLog('aiData api called');
      // var pref = await SharedPreferences.getInstance();
      // List<InputData> inputData = [];

      var response = await apiHelper!.apiJsonRequest(
        applicationConfigurationUrl,
        AppConfigRequest(inputData: inputData).toJson(),
        context,
      );
      return compute(aiDataResponseModelFromJson, response);
    } catch (e) {
      showLog("the Problem while calling aiData api for : ${e} \n ()}");
    }
    return null;
  }

  Future<EventImageStatusModel> eventImageStatus(
      String code, int lastUpdatedAt) async {
    var map = {"event_code": code, "last_updated_at": lastUpdatedAt.toString()};
    var response = await apiHelper!.apiRequest(
        eventImageStatusUrl, map, context,
        showSnackBarIfError: false);
    return compute(photoSelectionImagesFromJson, response);
  }

  Future<StatusAndMessageModel> callAddUserEmail(BuildContext context,
      String? email, String? code, String? ableType) async {
    var map = {
      'address': email ?? "",
      "able_code": code ?? "",
      "able_type": ableType ?? ""
    };
    var response = await apiHelper!
        .apiRequest(addEmailUrl, map, context, showSnackBarIfError: false);
    return compute(statusAndMessageModelFromJson, response);
  }

  Future<CommonResponse> eventArchiveOrUnaArchive(
      {BuildContext? context, String? eventCode, bool? archived}) async {
    var map = {
      'archived': archived == true ? 1.toString() : 0.toString(),
      "event_code": eventCode
    };
    var response = await apiHelper!
        .apiRequest(archiveUrl, map, context, showSnackBarIfError: false);
    return compute(commonResponseFromJson, response);
  }

  Future<CommonResponse> deleteEvent(
      {BuildContext? context, String? eventCode}) async {
    var map = {"event_code": eventCode};
    var response = await apiHelper!
        .apiRequest(deleteEventUrl, map, context, showSnackBarIfError: false);
    return compute(commonResponseFromJson, response);
  }

  Future<StatusAndMessageModel> callVerifyOtpForEmail(
      BuildContext context, String otp, String email, String token) async {
    var map = {
      "otp": otp,
      //emailKey: email,
      tokenKey: token,
    };
    var response = await apiHelper!.apiRequest(
        verifyOtpForEmailUrl, map, context,
        showSnackBarIfError: false);
    //return jsonDecode(response)['status'];
    //return compute(statusAndSuccessMessageModelFromJson, response);
    return compute(statusAndMessageModelFromJson, response);
  }

  Future<OtpResendResponse> resendOtpApiCall(
      BuildContext context, String userName, String currentTokenForEmail,
      {String? signature,
      String? token,
      bool showSnackBarIfError = true}) async {
    //convert details to a map
    var resendMap = {
      //otpSignatureKey: signature.toString(),
      userNameKey: userName.toString(),
      'token': currentTokenForEmail
    };
    if (token != null) resendMap[tokenKey] = token.toString();
    if (signature != null) resendMap[otpSignatureKey] = signature.toString();
    showLog('Api Request: $resendMap');
    var response = await apiHelper!.apiRequest(resendOtpUrl, resendMap, context,
        showSnackBarIfError: showSnackBarIfError);
    return compute(otpResendResponseFromJson, response);
  }

  Future<StatusAndMessageModel> callDeleteEmail(
      BuildContext context, String token) async {
    var map = {tokenKey: token};
    var response = await apiHelper!.apiRequest(deleteUserEmail, map, context);
    //return jsonDecode(response)['status'];
    return compute(statusAndMessageModelFromJson, response);
  }

  Future<UserProfileImage> callFileStore(
      BuildContext context, String imageInBase64, userAbleType,
      {String userCode = '', String type = ''}) async {
    //need to check api
    var map = {
      'able_type': userAbleType,
      'able_code': userCode,
      'image': imageInBase64,
    };

    var response = await apiHelper!.apiRequest(filesStoreUrl, map, context);
    //return jsonDecode(response)['status'];
    return compute(userProfileImageFromJson, response);
  }

  Future<UserProfileImage> callProfileStore(
      BuildContext context, String imageInBase64, userAbleType,
      {String userCode = '', String type = ''}) async {
    //need to check api
    var map = {
      'able_type': userAbleType,
      'able_code': userCode,
      'image': imageInBase64,
    };

    var response = await apiHelper!.apiRequest(filesStoreUrl, map, context);
    //return jsonDecode(response)['status'];
    return compute(userProfileImageFromJson, response);
  }

  Future<PhotoSelectionImagesResponseModel>
      callUpdatePhotoSelectionImagesStatus(
    BuildContext context, {
    List<UpdateModel>? inputData,
  }) async {
    var map = {
      'photo_selection_image_statuses': inputData,
    };
    var response = await apiHelper!.apiRequest(filesStoreUrl, map, context);
    return compute(photoSelectionImagesResponseModelFromJson, response);
  }

  Future<CommonResponse?> submitPhotoSelectionAlbum(
      {String? code, int? status}) async {
    var map = {
      'code': code, // (photoselection_code)
      'confirmed_status': status // (1-confirm)
    };
    var response =
        await apiHelper!.apiJsonRequest(photoSelectionsUpdateUrl, map, context);
    showLog('getAudioJvtFileIndex$response');
    return compute(commonResponseFromJson, response);
  }

  Future<ErrorNotifier> callChatNotifier(
      {String? exception, String? errorDetail}) async {
    var map = {
      'type': 6, // (1-True Caller Failed, 2-403 Image Failed , 6-App error)
      'exception': exception,
      'exception_detail': errorDetail,
    };
    var response =
        await apiHelper!.apiJsonRequest(chatNotifierURL, map, context);
    return compute(errorNotifierFromJson, response);
  }

  Future<ImageServerResponseModel> callImageServerStatus(
      {List<String>? fileCodes}) async {
    List<FileElements> files = [];
    fileCodes!.forEach((newCode) {
      files.add(FileElements(code: newCode));
    });
    showLog(
        'the status api input  where >> ${NotificationRequestModel(files: files).toJson()}');
    /* var map = {
      'files':(files.toList().toString()), // (1-True Caller Failed, 2-403 Image Failed , 6-App error)
    };*/
    var response = await apiHelper!.apiJsonRequest(imageServerStatus,
        NotificationRequestModel(files: files).toJson(), context);
    return compute(imageServerResponseModelFromJson, response);
  }

  Future<NotificationReceived?> notificationReceivedApiCall(
      {String? code}) async {
    var map = {
      "code": code,
      'status': "1" // (1-True Caller Failed, 2-403 Image Failed , 6-App error)
    };
    var response =
        await apiHelper!.apiJsonRequest(notificationReceived, map, context);
    return compute(notificationReceivedFromJson, response);
  }

  Future<ScreenShot?> screenShotRequestApiCall() async {
    Map<String, dynamic> map = {};
    var response =
        await apiHelper!.apiJsonRequest(screenShotRequestUrl, map, context);
    return compute(screenShotFromJson, response);
  }

  Future<UserPersonsPhotos?> myPhotosApiCall({String? eventCode}) async {
    Map<String, dynamic> map = {
      "photomall_event_code": eventCode,
    };
    var response =
        await apiHelper!.apiJsonRequest(userPersonsPhotos, map, context);
    showLog(response);
    return compute(userPersonsPhotosFromJson, response);
  }

  Future<FolderStatusApiModel?> folderStatusApi({String? folderCode}) async {
    var prefs = await SharedPreferences.getInstance();
    bool? isUserLoggedInPreference =
        await prefs.getBool(isUserLoggedInPreferenceKey);
  //  if (isUserLoggedInPreference!) {
      showLog('folderStatusApi start started $isUserLoggedInPreference');

      Map<String, dynamic> map = {
        "folder_code": folderCode,
      };
      var response =
          await apiHelper!.apiJsonRequest(folderStatus, map, context);
      print(response);
      return compute(folderStatusApiModelFromJson, response);
  //  }
    return null;
  }

  Future<AccountDeletionStoreResponseModel?> deletionStoreApi(
      {String? folderCode}) async {
    Map<String, dynamic> map = {};
    var response =
        await apiHelper!.apiJsonRequest(deletionStoreUrl, map, context);
    print(response);
    return compute(accountDeletionStoreResponseModelFromJson, response);
  }

  Future<AccountDeletionResponseModel?> deletionApi(
      {required String? code}) async {
    Map<String, dynamic> map = {"code": code};
    var response = await apiHelper!.apiJsonRequest(deletionUrl, map, context);
    print(response);
    return compute(accountDeletionResponseModelFromJson, response);
  }

  Future<MyPhotosDoubtImages?> doubtImagesApi(
      {required String? eventCode}) async {
    Map<String, dynamic> map = {
      "photomall_event_code": "$eventCode",
    };
    var response = await apiHelper!.apiJsonRequest(doubtImageUrl, map, context);
    print(response);
    return compute(myPhotosDoubtImagesFromJson, response);
  }

  Future<MyPhotosMatchPerson?> matchPersonApi(
      {required String? personCode,
      required String? matchPersonCode,
      required int? status}) async {
    Map<String, dynamic> map = {
      "match_status": "$status",
      "person_code": "$personCode",
      "match_person_code": "$matchPersonCode",
    };
    var response =
        await apiHelper!.apiJsonRequest(matchPersonUrl, map, context);
    print(response);
    return compute(myPhotosMatchPersonFromJson, response);
  }

  Future<PrintStore?> printStoreApi(
      {required String? eventCode,
      required String? ableCode,
      required int? status}) async {
    Map<String, dynamic> map = {
      "event_code": "$eventCode",
      "able_code": "$ableCode",
      "status": "$status",
      "able_type": "orders",
    };
    var response = await apiHelper!.apiJsonRequest(printStoreUrl, map, context);
    print(response);
    return compute(printStoreFromJson, response);
  }

  Future<PrintUsers?> printUsersApi({
    required String? eventCode,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    bool? otpApi = await prefs.getBool(otpApiCallKey);
    if (otpApi!) {
      showLog('printUsersApi start started $otpApi');
      Map<String, dynamic> map = {
        "event_code": "$eventCode",
      };
      var response =
          await apiHelper!.apiJsonRequest(printUsersUrl, map, context);
      print(response);
      return compute(printUsersFromJson, response);
    }
    return null;
  }

  Future<MyPhotosImages?> myPhotosImagesApi(
      {required String? eventCode, required lastUpdatedAt}) async {
    //String? token = await FirebaseMessaging.instance.getToken();
    Map<String, dynamic> map = {
      "photomall_event_code": "$eventCode",
      //"fcm_notification_token": token,
      "last_updated_at": "$lastUpdatedAt",
    };
    var response =
        await apiHelper!.apiJsonRequest(userPersonsImages, map, context);
    showLog(response);
    return compute(myPhotosImagesFromJson, response);
  }

  Future<UserPersonsResponse?> userPersonStoreApi(
      {required String? name, required relationType}) async {
    Map<String, dynamic> map = {
      "name": "$name",
      "relationship_code": relationType,
    };
    var response =
        await apiHelper!.apiJsonRequest(userPersonsStoreUrl, map, context);
    showLog(response);
    return compute(userPersonsResponseFromJson, response);
  }

  Future<MultipleFacesResponseModel?> multiFaceImagesApi() async {
    Map<String, dynamic> map = {};
    var response =
        await apiHelper!.apiJsonRequest(multiFaceImagesUrl, map, context);
    showLog(response);
    return compute(multipleFacesResponseModelFromJson, response);
  }

  Future<MultipleFacesDeleteResponseModel?> multiFaceImagesDeleteApi(
      {required String code}) async {
    Map<String, dynamic> map = {"jvt_file_connector_code": code};
    var response =
        await apiHelper!.apiJsonRequest(multiFaceImagesDeleteUrl, map, context);
    showLog(response);
    return compute(multipleFacesDeleteResponseModelFromJson, response);
  }

  Future<UpdateProfileResponseModel?> profileImageUpdateApi(
      {required String jvtFileConnectorCode,
      required String jvtFileCode}) async {
    Map<String, dynamic> map = {
      "jvt_file_connector_code": jvtFileConnectorCode,
      "jvt_file_code": jvtFileCode,
    };
    var response =
        await apiHelper!.apiJsonRequest(profileImageUpdateUrl, map, context);
    showLog(response);
    return compute(updateProfileResponseModelFromJson, response);
  }

  Future<UserPersonsDeleteResponseModel?> userPersonDeleteApi(
      {required String? userPersonCode}) async {
    Map<String, dynamic> map = {"user_person_code": "$userPersonCode"};
    var response =
        await apiHelper!.apiJsonRequest(userPersonsDeleteUrl, map, context);
    showLog(response);
    return compute(userPersonsDeleteResponseModelFromJson, response);
  }
 Future<UserPersonsDeleteResponseModel?> unAuthUserDeleteApi(
      {required String? userPersonCode}) async {
    Map<String, dynamic> map = {"unauth_user_person_code": "$userPersonCode"};
    var response =
        await apiHelper!.apiJsonRequest(unAuthUserDeleteUrl, map, context);
    showLog(response);
    return compute(userPersonsDeleteResponseModelFromJson, response);
  }

  Future<TransportModel?> userDataApi(int lastUpdated) async {
    var prefs = await SharedPreferences.getInstance();
    bool? otpApi = await prefs.getBool(isUserLoggedInPreferenceKey) ?? false;
    if (otpApi != false) {
      Map<String, dynamic> map = {"last_updated_at": lastUpdated};
      var response = await apiHelper!.apiJsonRequest(userShowUrl, map, context);
      showLog(response);
      return compute(transportModelFromJson, response);
    }
    return null;
  }

  Future<UserAbleEventsStoreUrlResponseModel?> userAbleEventsStoreApi() async {
    List<String> reqEvents = [];
    EventModelDao eventModelDao = EventModelDao();

    List<appDb.Event> events = await eventModelDao.getUserEvent();
    showLog("events  $events");
    if (events.isNotEmpty) {
      for (appDb.Event event in events) {
        reqEvents.add(event.code);
      }

      Map<String, dynamic> map = {"event_codes": reqEvents};
      var response =
          await apiHelper!.apiJsonRequest(userAbleEventsStoreUrl, map, context);
      showLog(response);
      return compute(userAbleEventsStoreUrlResponseModelFromJson, response);
    } else {
      showLog("userAbleEventsStoreApi events is $events");
    }
    return null;
  }

  Future<UnAuthUserStoreApiResponseModel?> unAuthUserEventsStoreApi({
    required String eventCode,
    required String phoneNumber,
    required String email,
    required String name,
    required String designation,
    required String countryId,
  }) async {
    Map<String, dynamic> map = {
      "photomall_event_code": eventCode,
      "phone_number": phoneNumber,
      "email_address": email,
      "name": name,
      "designation": designation,
      "country_id":countryId
    };
    var response =
        await apiHelper!.apiJsonRequest(unAuthUserEventsStoreUrl, map, context);
    showLog(response);
    return compute(unAuthUserStoreApiResponseModelFromJson, response);
  }

  Future<UnAuthUserProfileStoreApiResponseModel?> unAuthUserProfileStoreApi({
    required String ableCode,
    required String imageInBase64,
  }) async {
    Map<String, dynamic> map = {
      "able_type": "unauth_users",
      "able_code": ableCode,
      "image": 'data:image/jpeg;base64,' + imageInBase64,
    };
    var response = await apiHelper!
        .apiJsonRequest(unAuthUserEventsProfileStoreUrl, map, context);
    showLog(response);
    return compute(unAuthUserProfileStoreApiResponseModelFromJson, response);
  }

  Future<MyPhotosImages?> unAuthUserMyPhotosApi({
    required String uUCode,
  }) async {
    Map<String, dynamic> map = {"unauth_user_code": uUCode};
    var response = await apiHelper!
        .apiJsonRequest(unAuthUserEventsMyPhotosUrl, map, context);
    showLog(response);
    return compute(myPhotosImagesFromJson, response);
  }
}
