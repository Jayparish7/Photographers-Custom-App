import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/cupertino.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/core/services/image_handler.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/jvt_file_connector_dao.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';
import 'package:photomall_flutter/ui/base/base_observer.dart';
import 'package:photomall_flutter/ui/profile/model/otp_resend_response.dart';
import 'package:photomall_flutter/ui/profile/model/status_and_message_model.dart';
import '../../../backgroundCron/cron_util.dart';
import '../../../controllers/user_data_controller.dart';
import '../../../controllers/user_person_controller.dart';
import '../../../core/Utils/common_utils.dart';
import '../../../core/Utils/preference_helper.dart';
import '../../../core/constants/shared_preference_constants.dart';
import '../../../core/models/apiModels/multiple_face_delete_response_model.dart';
import '../../../core/models/apiModels/multiple_faces_index_response_model.dart'
    as face;
import '../../../core/models/apiModels/transport_model/transport_model.dart'
    as tr;
import '../../../driftdb/app_db.dart';
import '../../../driftdb/dao/user_persons_dao.dart';
import '../model/user_profile_model.dart';

class CustomerProfileViewRouteModel extends BaseObserver {
  ApiHelper? apiHandler;
  BuildContext? context;

  var documentDirectory;
  String? publicStoragePath;
  String? privateStoragePath;
  final ValueNotifier<bool> isConnected = ValueNotifier<bool>(false);
  File? downloadedImageFile;
  appDb.JvtFile? profileJvtFile;
  String profileUrl = '';
  List<int> downloadedImageId = [];
  List<String> dropdownItems = [];
  var userName = "";
  var userDob = "";
  int userAge = 0;
  var maritalStatus = "";
  var anniversary = "";
  var marital = "Select";
  var userPhoneNumber = "";
  var userEmailAddress = "";
  int emailStatus = 0;
  var usercode = "";
  var imageName;
  ValueNotifier<List<JvtFileConnectors>> userPersonsNotifier =
      ValueNotifier<List<JvtFileConnectors>>([]);
  ValueNotifier<List<JvtFileConnectors>> multiUserPersonsNotifier =
      ValueNotifier<List<JvtFileConnectors>>([]);
  ValueNotifier<List<UserPerson>> userPersonsCode =
      ValueNotifier<List<UserPerson>>([]);
  ValueNotifier<List<UserPerson>> multiUserPersonsCode =
      ValueNotifier<List<UserPerson>>([]);
  ValueNotifier<List<face.Datum>> multiFacesList =
      ValueNotifier<List<face.Datum>>([]);
  ValueNotifier<List<face.JvtFileConnector>> userPersonMultiFacesList =
      ValueNotifier<List<face.JvtFileConnector>>([]);
  ValueNotifier<String> profileImageCode = ValueNotifier<String>('');
  ValueNotifier<String> UserPersonImageCode = ValueNotifier<String>('');
  ValueNotifier<String> profileImage = ValueNotifier<String>('');
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  StatusAndMessageModel? updateUserEmailModel;
  PhotomallApis? apiRepo;
  var lastUpdatedAt;
  String currentTokenForEmail = '';
  bool isVerifyEmailLoading = false;
  UserProfileModel? userProfileModel;
  bool isDeleteEmailProcessing = false;
  bool isUploadProfileImage = false;
  bool addUserPersons = false;
  transporter.TransportModel? customerData;
  JvtFileConnectorModelDao jvtFileConnectorModelDao =
      JvtFileConnectorModelDao();
  UserDataController userDataController = UserDataController();
  BackgroundTasks backgroundTasks = BackgroundTasks();
  bool showRelatives = false;
  CommonUtils commonUtils = CommonUtils();

  CustomerProfileViewRouteModel({this.apiHandler, this.context}) {
    this.apiRepo = PhotomallApis(this.context);
  }

  relativesOnTap() {
    showRelatives ? showRelatives = false : showRelatives = true;
    notifyListeners();
  }

  getUserPersonsAllowedOrNot() async {
    var user = await PreferenceHelper.getString(addPersonKey);
    showLog('getUserPersonsAllowedOrNot $user');
    if (user == '1') {
      addUserPersons = true;
    }
  }

  String? validateMaritalStatus(String dob, String marriageDate) {
    DateTime? dobDate;
    DateTime? marriageDateParsed;
    showLog('marriageDateParsed 0 $marriageDate');

    try {
      dobDate = DateFormat("dd-MM-yyyy").parse(dob);
      marriageDateParsed = DateTime.parse(marriageDate);
    } catch (e) {
      return 'Invalid date format. Please use dd-MM-yyyy.';
    }

    // Check if marriage date is after DOB
    showLog('marriageDateParsed 1 $marriageDateParsed  $dobDate');
    if (!marriageDateParsed.isBefore(dobDate)) {
      // Check if age at marriage is at least 18
      int ageAtMarriage = calculateAgeAtDate(dobDate, marriageDateParsed);
      if (ageAtMarriage < 18) {
        ToastUtil.showSnackBarAtCurrentState(
            'Age must be at least 18 at the time of marriage',
            seconds: 8);
        return 'Age must be at least 18 at the time of marriage.';
      }
    } else {
      showLog('marriageDateParsed.isBefore(dobDate) ===> false');
      ToastUtil.showSnackBarAtCurrentState(
          'Anniversary date cannot be before the date of birth.',
          seconds: 8);

      return 'Marriage date cannot be before the date of birth.';
    }
    return null; // No errors
  }

  int calculateAgeAtDate(DateTime dob, DateTime targetDate) {
    int age = targetDate.year - dob.year;
    if (targetDate.month < dob.month ||
        (targetDate.month == dob.month && targetDate.day < dob.day)) {
      age--;
    }
    return age;
  }

  getMultipleFacesIndexFromApi(/*appDb.JvtFile? profileJvtFile*/) async {
    isLoading.value = true;
    notifyListeners();
    getUserDetails();
    //profileJvtFile = await getUserProfilePicture();

    face.MultipleFacesResponseModel? response =
        await PhotomallApis(context).multiFaceImagesApi();
    showLog('getMultipleFacesIndexFromApi ${response?.data}');
    multiFacesList.value.clear();
    if (response != null &&
        response.data != null &&
        response.data!.isNotEmpty) {
      profileImageCode.value = response.data![0].code!;
      showLog('detectedImage $profileImageCode');
      for (int i = 0; i < response.data!.length; i++) {
        if (/*(response.data![0].userOwnImage == 1) &&
            (profileJvtFile!.code !=
                response.data![0].images![i].jvtFile!.code)||*/
            true) {
          if (response.data![i].jvtFileConnector != null) {
            if (profileJvtFile?.name !=
                response.data![i].jvtFileConnector!.jvtFile?.name) {
              multiFacesList.value.add(response.data![i]);
            }
          }
        } else if (response.data![0].userOwnImage == 1) {
          // profileImage.value = response.data![0].images![i].jvtFile!.name!;
        }
      }

      showLog('multiFacesList ${multiFacesList.value.length}');
      showLog('profileImage ${profileImage.value}');
    }
    isLoading.value = false;
    notifyListeners();
  }

/*
  getUserPersonMultipleFacesIndexFromApi(
      {required String userPersonCode}) async {
    isLoading.value = true;
    notifyListeners();
    getUserDetails();
    //profileJvtFile = await getUserProfilePicture();
    List<appDb.UserPersonsCompanion> UserPersonCompanionsInsertOrUpdate = [];

    face.MultipleFacesResponseModel? response =
        await PhotomallApis(context).multiFaceImagesApi();
    showLog('getMultipleFacesIndexFromApi $response');
    userPersonMultiFacesList.value.clear();
    if (response != null &&
        response.data != null &&
        response.data!.isNotEmpty) {
      UserPersonImageCode.value = response.data![0].code!;
      showLog('detectedImage $profileImageCode');
      for (int j = 0; j < response.data!.length; j++) {
        for (int i = 0; i < response.data![j].images!.length; i++) {
          if ((userPersonCode == response.data![j].code)) {
            userPersonMultiFacesList.value.add(response.data![j].images![i]);
            UserPersonImageCode.value = response.data![j].code!;
          }
          if (response.data![j].userOwnImage != 1) {
            UserPersonCompanionsInsertOrUpdate.add(appDb.UserPersonsCompanion(
              code: drift.Value(response.data![j].code!),
              name: drift.Value(response.data![j].name!),
              images: drift.Value(json.encode((response.data![j].images!))),
              relationship: drift.Value(response.data![j].relationship!),
              userOwnImage: drift.Value(response.data![j].userOwnImage!),
            ));
          }
        }
      }
      UserPersonsDao usersDao = UserPersonsDao();
      await usersDao.insertUserPersons(UserPersonCompanionsInsertOrUpdate);
      await getUserPersons();
      showLog(
          'multiFacesList ${userPersonMultiFacesList.value.length} \n ${userPersonsNotifier.value.length}');
      //  showLog('profileImage ${profileImage.value}');
    }

    isLoading.value = false;
    notifyListeners();
  }*/

  updateMultipleFacesForView(int index) {
    isLoading.value = true;
    notifyListeners();
    multiFacesList.value.removeAt(index);
    userPersonMultiFacesList.value.removeAt(index);
    userPersonsNotifier.value.removeAt(index);

    isLoading.value = false;
    notifyListeners();
  }

  getMultipleFaceDeleteApi(int index, {required String code}) async {
    isLoading.value = true;
    notifyListeners();
    try {
      UserPersonsDao usersDao = UserPersonsDao();

      MultipleFacesDeleteResponseModel? response =
          await PhotomallApis(context).multiFaceImagesDeleteApi(code: code);
      showLog('getMultipleFaceDeleteApi u ${response!.status}');
      if (response.status == 1) {
        updateMultipleFacesForView(index);
        await usersDao.deleteUserPersons(code: code);
        await ToastUtil.showSnackBarAtCurrentState(
            'Picture deleted Successfully',
            seconds: 5);
      }
      isLoading.value = false;
      notifyListeners();
    } catch (e) {
      isLoading.value = false;
      notifyListeners();
    }
  }

  updateProfileApi(
      {required String jvtFileConnectorCode,
      required String jvtFileCode,
      required String ableCode}) async {
    isLoading.value = true;
    notifyListeners();
    tr.UpdateProfileResponseModel? response = await PhotomallApis(context)
        .profileImageUpdateApi(
            jvtFileConnectorCode: jvtFileConnectorCode,
            jvtFileCode: jvtFileCode);
    showLog(
        'updateProfileApi ${response!.jvtFileConnector} ,,,,$jvtFileConnectorCode');
    if (response.status != null) {
      await jvtFileConnectorModelDao.deleteProfileImage();

      await jvtFileConnectorModelDao.insertJvtFilesConnectors(
          jvtFileConnectors: [response.jvtFileConnector!],
          ableType: TransportDataKeys.users,
          ableCode: ableCode,
          isProfile: true);
      getMultipleFacesIndexFromApi();
    }

    isLoading.value = false;
    notifyListeners();
    await ToastUtil.showSnackBarAtCurrentState(
        'Profile Picture Updated successfully',
        seconds: 5);
  }

  changeNameAndRefreshInUi(String name) {
    userName = name;
    setBusy(false);
  }

  changeDobAndRefreshInUi(String dob) {
    userDob = dob;
    setBusy(false);
  }

  Future<bool> changeUserName(String name) async {
    PhotomallApis data = await PhotomallApis(context);
    var response = await data.callChangeUserName(context!, name);

    if (response.status) {
      var _appConfigRef = TransporterPreference();
      await _appConfigRef.updateCustomerName(name);
    }
    return response.status;
  }

  updateDobApiCall(String dob, int hour, int minute) async {
    PhotomallApis api = await PhotomallApis(context);
    var response = await api.callChangeDob(context!, dob);
    if (response.status) {
      var _appConfigRef = TransporterPreference();
      await _appConfigRef.updateCustomerDOB(dob);
      await ToastUtil.showSnackBarAtCurrentState(response.message ?? "Updated",
          seconds: 8);
      List<int> dobForNotify = dob.split('-').map(int.parse).toList();
      final DateTime userBirthday = DateTime(dobForNotify[0], dobForNotify[1],
          dobForNotify[2], hour, minute); // 9:00 AM
      await PreferenceHelper.setBool(BDayWishKey, false);

      backgroundTasks.scheduleBirthdayWish(userBirthday, userName);
      showLog('scheduleBirthdayWish $userDob $dobForNotify $userBirthday');
    }
    showLog('updateDobApiCall $response');
    notifyListeners();
  }

  updateMaritalStatusApiCall(String maritalStatus, String anniversaryDate,
      int hour, int minute) async {
    PhotomallApis data = await PhotomallApis(context);

    var response =
        await data.callMaritalStatus(context!, maritalStatus, anniversaryDate);
    if (response.status) {
      var _appConfigRef = TransporterPreference();
      await _appConfigRef.updateCustomerMaritalStatus(
          maritalStatus, anniversaryDate);
      await ToastUtil.showSnackBarAtCurrentState(response.message ?? "Updated",
          seconds: 8);
      if (anniversaryDate != '') {
        List<int> anneForNotify =
            anniversaryDate.split('-').map(int.parse).toList();
        final DateTime anneWish = DateTime(anneForNotify[0], anneForNotify[1],
            anneForNotify[2], hour, minute); // 9:00 AM
        await PreferenceHelper.setBool(anneWishKey, false);
        backgroundTasks.scheduleBirthdayWish(anneWish, userName,
            isAnniversary: true);
      }
    }
    showLog('updateMaritalStatusApiCall $response');
    notifyListeners();
  }

  Future<OtpResendResponse> resendOtp(
      {bool fromVerifyEmailButton = true}) async {
    if (fromVerifyEmailButton) isVerifyEmailLoading = true;
    //setState(ViewState.Idle);
    OtpResendResponse response = await PhotomallApis(context).resendOtpApiCall(
        context!, userEmailAddress, currentTokenForEmail,
        showSnackBarIfError: false);

    //set currentTokenForEmail after email verified
    currentTokenForEmail = response.token!;

    if (fromVerifyEmailButton) isVerifyEmailLoading = false;
    //  setState(ViewState.Idle);
    return response;
  }

  Future<StatusAndMessageModel?> verifyOtpForEmail(
      String otp, String email) async {
    StatusAndMessageModel? result;
    try {
      var _appConfigRef = TransporterPreference();
      result = await PhotomallApis(context)
          .callVerifyOtpForEmail(context!, otp, email, currentTokenForEmail);

      //set currentTokenForEmail after email verified
      currentTokenForEmail = result.token!;
      await _appConfigRef.updateCustomerEmail(
          userEmailAddress, result.token ?? "", 1);
      emailStatus = 1;
      // ignore: empty_catches
    } catch (e) {
      showLog(" the error in otp is $e");
    }
    setBusy(false);
    return result;
    //return updateUserEmailModel.updated;
  }

  updateProfileImageFromGoogle() async {
    profileUrl = await PreferenceHelper.getString(googleProfileUrlKey);
    showLog('userCredential photoURL preferences $profileUrl');
    if (profileUrl != '' && profileJvtFile?.name == null) {
      String? base64Image = await commonUtils.networkImageToBase64(profileUrl);
      base64Image != null ? await changeProfileImage(base64Image) : null;
    }
  }

  getUserPersonsDropdown() async {
    var savedMap = await PreferenceHelper.getMapFromPrefs(relationShipMap);
    List<String>? dropDown = [];
    if (savedMap.isNotEmpty) {
      dropDown = savedMap.keys.toList();
      showLog('dropDown $dropDown');
      dropdownItems = dropDown;
    }
  }

  userPersonsStoreApiCall(
      {required String name, required String relationType}) async {
    showLog('userPersonsStoreApiCall $name, $relationType');
    UserPersonsDao usersDao = UserPersonsDao();
    List<appDb.UserPersonsCompanion> UserPersonCompanionsInsertOrUpdate = [];
    var res =
        await PreferenceHelper.getValueForKey(relationType, relationShipMap);
    showLog('res $res');
    try {
      var response = await PhotomallApis(context)
          .userPersonStoreApi(name: name, relationType: res);
      if (response != null) {
        showLog('userPersonsStoreApiCall $response');
        UserPersonCompanionsInsertOrUpdate.add(appDb.UserPersonsCompanion(
          code: drift.Value(response.userPerson!.code!),
          name: drift.Value(response.userPerson!.name!),
          relationship: drift.Value(response.userPerson!.relationship!),
          userOwnImage: drift.Value(response.userPerson!.userOwnImage!),
          images: drift.Value(json.encode(response.userPerson!.images)),
        ));
        await usersDao.insertUserPersons(UserPersonCompanionsInsertOrUpdate);

        showLog('userPersonsStore ${userPersonsNotifier.value.length}');
        userPersonsNotifier.value.clear();
        await getUserPersons();
        notifyListeners();
      }
    } catch (e) {
      showLog('error in profileStoreApiCall');
    }
  }

  Future<StatusAndMessageModel?> addUserEmail(
      String email, String ableType) async {
    showLog('add email com qww $email');
    userEmailAddress = email;
    setBusy(true);
    try {
      var _appConfigRef = TransporterPreference();
      showLog('add email com ewe s$email');

      var res = await PhotomallApis(context)
          .callAddUserEmail(context!, email, usercode, ableType);
      showLog('add email com $res');

      try {
        await _appConfigRef.updateCustomerEmail(
            email, updateUserEmailModel?.token ?? "", 0);
      } catch (e) {
        showLog('the error in this $e');
      }

      userEmailAddress = email;
      currentTokenForEmail = updateUserEmailModel?.token ?? "";
    } catch (e) {}
    return updateUserEmailModel;
  }

  changeEmailAndRefreshInUi(String email) {
    userEmailAddress = email;
    setBusy(false);
  }

  Future<String> getFutureString() async {
    return "";
  }

  getUserDetails({isFromUserShow = false}) async {
    // try {
    isFromUserShow ? null : isLoading.value = true;
    notifyListeners();
    await getStoragePaths();
    var documentDirectory = await getApplicationDocumentsDirectory();
    var appConfigRef = TransporterPreference();
    transporter.UserData? userData = await appConfigRef.getUserData();

    if (userData != null) {
      if (userData.userDataData!.accountData!.emails!.isNotEmpty) {
        currentTokenForEmail =
            userData.userDataData!.accountData!.emails![0].token!;

        emailStatus = userData.userDataData!.accountData!.emails![0].verify!;

        userEmailAddress =
            userData.userDataData?.accountData?.emails?[0] == null
                ? ""
                : userData.userDataData!.accountData!.emails![0].address!;
      }
      userPhoneNumber = userData.userDataData?.accountData?.phoneNumber == null
          ? ""
          : userData.userDataData!.accountData!.phoneNumber!;
      userName = userData.userDataData!.accountData!.name == null
          ? ""
          : userData.userDataData!.accountData!.name ?? "";
      userDob = userData.userDataData!.accountData!.dateOfBirth == null
          ? ""
          : userData.userDataData!.accountData!.dateOfBirth ?? "";
      if (userDob != '') {
        showLog('userDob is $userDob');
        List<int> dobForNotify = userDob.split('-').map(int.parse).toList();
        final DateTime userBirthday = DateTime(dobForNotify[0], dobForNotify[1],
            dobForNotify[2], 09, 00); // Dec 25, 9:00 AM
        var wishes = await PreferenceHelper.getBool(BDayWishKey);
        showLog('wishes $wishes');

        if (!wishes) {
          backgroundTasks.scheduleBirthdayWish(userBirthday, userName);
          showLog(
              'scheduleBirthdayWish initial $userDob $dobForNotify $userBirthday');
        } else {
          showLog('Already scheduleBirthdayWish');
        }
        DateTime parsed = DateTime.parse(userDob);
        userDob = DateFormat("dd-MM-yyyy").format(parsed);
        DateTime dob = DateFormat("dd-MM-yyyy").parse(userDob);
        userAge = calculateAgeAtDate(dob, DateTime.now());
        showLog('userAge is $userAge');
      }
      maritalStatus = userData.userDataData!.accountData!.maritalStatus == 0
          ? ""
          : userData.userDataData!.accountData!.maritalStatus.toString();
      showLog('maritalStatus -->$maritalStatus');
      anniversary = userData.userDataData!.accountData!.anniversary == null
          ? ""
          : userData.userDataData!.accountData!.anniversary ?? "";

      if (anniversary != '') {
        DateTime parsedDate = DateTime.parse(anniversary);
        anniversary = DateFormat("dd-MM-yyyy").format(parsedDate);
      }

      usercode = userData.userDataData!.accountData!.code ?? "";
      currentTokenForEmail = userData.userDataData!.accountData!.emails!.isEmpty
          ? ""
          : userData.userDataData!.accountData!.emails![0].token ?? "";
      if (imageName != null) {
        downloadedImageFile = File(
            '${documentDirectory.path}/${getImageWithExtension(imageName)}');
      }
    } else {}
    profileJvtFile = await getUserProfilePicture();
    showLog('profileJvtFile res${profileJvtFile?.name}');
    await getUserPersonsDropdown();
    await getUserPersons();
    await getUserPersonsAllowedOrNot();
    showLog('getUserData profileRoute');
    checkConnectivity();
    setBusy(false);
    //  } catch (e) {
    //    showLog("the problem while parse data for profile view where \n $e");
    //   }
    isFromUserShow ? null : isLoading.value = false;
    notifyListeners();
    bool isUpdateAvailable = false;
    //await updateProfileImageFromGoogle();
    isFromUserShow
        ? null
        : isUpdateAvailable =
            await userDataController.getUserData(isLastUpdatedNull: false);
    (isUpdateAvailable) ? getUserDetails(isFromUserShow: true) : null;
    notifyListeners();
  }

  @override
  void onInternetConnectionBack() async {}

  Future<bool> changeProfileImage(String imageInBase64) async {
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    try {
      isUploadProfileImage = true;
      //setState(ViewState.Idle);
      var response = (await PhotomallApis(context).callFileStore(
          context!, 'data:image/png;base64,' + imageInBase64, 'users',
          userCode: usercode));
      isUploadProfileImage = true;
      // downloading response image
      await jvtFileConnectorModelDao.insertJvtFilesConnectors(
          jvtFileConnectors: response.jvtFileConnectors!,
          ableType: TransportDataKeys.users,
          ableCode: usercode,
          isProfile: true);
      getUserDetails();
      return true;
    } catch (e) {
      print("error while upload :: ${e}");
      return false;
    }
  }

  Future<bool> addProfileImage(String imageInBase64, File croppedFile,
      BuildContext context,
      {required String code}) async {
    //   PmJobController pmJobController = PmJobController();
    isLoading.value = true;
    notifyListeners();
    try {
      String user = await PreferenceHelper.getString(userId);

      isUploadProfileImage = true;
      var response = (await PhotomallApis(context).callProfileStore(
          context, 'data:image/png;base64,' + imageInBase64, 'users',
          userCode: user));
      showLog('response %$response user: $user');
      multiFacesList.value.clear();
      getMultipleFacesIndexFromApi();
      isUploadProfileImage = true;
      isLoading.value = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("error while upload :: ${e}");
      return false;
    }
  }

  Future<bool> changeUserPersonsProfileImage(
      String imageInBase64, File croppedFile, String userPersonCode) async {
    UserPersonsDao users = UserPersonsDao();
    try {
      showLog('userPersons Code $userPersonCode');
      isUploadProfileImage = true;
      //setState(ViewState.Idle);
      var response = (await PhotomallApis(context).callFileStore(
          context!, 'data:image/png;base64,' + imageInBase64, 'users',
          userCode: userPersonCode));
      isUploadProfileImage = true;
      // downloading response image
      await users.updateUserPersonImages(
          code: userPersonCode,
          images: json.encode(response.jvtFileConnectors));
      showLog(
          'userPersons profile ${json.encode(response.jvtFileConnectors)}\n '
          '${response.jvtFileConnectors!.first.code} \n ${userPersonsNotifier.value.first.code}');
      userPersonsNotifier.value.clear();
      await getUserPersons();

      notifyListeners();
      return true;
    } catch (e) {
      print("error while upload :: ${e}");
      return false;
    }
  }

  deleteUserPersons({required String userPersonCode}) async {
    setBusy(true);
    try {
      UserPersonsDao user = UserPersonsDao();
      var response = await PhotomallApis(context)
          .userPersonDeleteApi(userPersonCode: userPersonCode);
      showLog(
          'response $userPersonCode ${response?.message} in deleteUserPersons');

      await user.deleteUserPersons(code: userPersonCode);
      userPersonsNotifier.value.clear();
      await getUserPersons();

      notifyListeners();
    } catch (e) {
      showLog('error in deleteUserPersons');
    }
    setBusy(false);
  }

  Future<bool> deleteEmail() async {
    isDeleteEmailProcessing = true;
    //setState(ViewState.Idle);
    var isSuccess = (await PhotomallApis(context)
            .callDeleteEmail(context!, currentTokenForEmail))
        .status;
    var _appConfigRef = TransporterPreference();
    await _appConfigRef.updateCustomerEmail("", "", 0);
    isDeleteEmailProcessing = false;
    setBusy(false);
    return isSuccess!;
  }

  Future<appDb.JvtFile?> getUserProfilePicture() async {
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    return await jvtFileConnectorModelDao.getUserProfilePicture(usercode);
  }

  getJvtFilConnectorCode(code) async {
    showLog('getJvtFilConnectorCode $code');

    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    var res = await jvtFileConnectorModelDao.getJvtFileConnector();
    showLog('getJvtFilConnectorCode $res');
    return res?.code;
  }

  getUserPersons() async {
    UserPersonsDao users = UserPersonsDao();
    List<UserPerson> entities = await users.getUserPersons();
    userPersonsNotifier.value.clear();
    multiUserPersonsNotifier.value.clear();
    showLog('entity entity === ${entities}');
    if (entities.isNotEmpty) {
      for (UserPerson entity in entities) {
        if (entity.userOwnImage != 1) {
          List<dynamic> decodedJson = json.decode(entity.images);
          JvtFileConnectors jvtFileConnectors =
              JvtFileConnectors.fromJson(decodedJson);
          if (!userPersonsNotifier.value.contains(jvtFileConnectors)) {
            userPersonsNotifier.value.add(jvtFileConnectors);
          }
          if (!userPersonsCode.value.contains(entity)) {
            userPersonsCode.value.add(entity);
          }
        }
      }
      showLog('multiUserPersonsNotifier  \n ${multiUserPersonsCode.value}');
    }
  }

  Future<void> getStoragePaths() async {
    if (studioPublicPath != null &&
        appDocumentDirectoryPath != null &&
        studioPrivatePath != null) {
      publicStoragePath = studioPublicPath;
      documentDirectory = appDocumentDirectoryPath;
      privateStoragePath = studioPrivatePath;
    } else {
      EssentialUtils essentialUtils = EssentialUtils();
      essentialUtils.loadAppEssentialData();
      publicStoragePath = studioPublicPath;
      documentDirectory = appDocumentDirectoryPath;
      privateStoragePath = studioPrivatePath;
    }
  }

  Widget checkConnectivity({Widget? child}) {
    InternetConnectionChecker.instance.onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.connected) {
        isConnected.value = true;
      } else {
        isConnected.value = false;
      }
    });
    return FutureBuilder<InternetConnectionStatus>(
        future: InternetConnectionChecker.instance.connectionStatus,
        builder: (BuildContext context,
            AsyncSnapshot<InternetConnectionStatus> snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return SizedBox();
          }
          if (snapshot.data == InternetConnectionStatus.connected) {
            return child ?? SizedBox();
          } else {
            return SizedBox();
          }
        });
  }
}
