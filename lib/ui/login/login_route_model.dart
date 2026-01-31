import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/studio_data_controller.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/login_model.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/ui/base/base_model.dart';
import 'package:photomall_flutter/ui/login/otp/otp_page_popup.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:toast/toast.dart';

import '../../controllers/login_controller.dart';
import '../../controllers/redirection_controller.dart';
import '../../core/Utils/preference_helper.dart';
import '../../core/Utils/snackbar_helper.dart';
import '../../core/models/apiModels/otp_model.dart';
import '../../core/models/apiModels/transport_model/transport_model.dart';
import '../../preference/preference_handler/redirection_preference_handler.dart';
import '../../preference/preference_model/redirection_preference_model.dart';
import '../animation/bouncy_page_route_animation.dart';
import '../app_side_drawer/side_drawer_constants.dart';
import '../bottom_navigation/bottom_navigation_constants.dart';
import '../drawer/side_drawer_model.dart';
import '../event/list/events_list_route.dart';
import '../shared_widgets/common_circular_progress.dart';
import '../shared_widgets/common_text.dart';
import 'otp/otp_view_model.dart';

class LoginRouteModel extends BaseModel {
  ApiHelper? apiHandler;
  BuildContext? context;
  int clientId = 0;
  String signature = "";
  var countryCodeId = 108;
  bool isRegisterView = false;
  PhotomallApis? apiRepo;
  String? getStudioName = '';
  String? otp;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  StudioDataController studioDataController = StudioDataController();
  String? phoneNumber;
  String? VerificationCode;
  List<Country>? defaultCountry = [];
  String? smsCode;
  final _otpKey = GlobalKey<FormState>();
  OtpViewModel otpViewModel = OtpViewModel();

  LoginRouteModel({
    this.apiHandler,
    this.context,
  }) {
    this.apiRepo = PhotomallApis(this.context);
  }

  void setUserWaitingStatus(bool status) {
    setBusy(status);
  }

  void getUserDetails(
    bool? isRegister,
  ) async {
    getStudioName = await studioDataController.getStudioName();
    if (isRegister != null) {
      isRegisterView = isRegister;
    }
    await _getOtpSignature();
    await _getClientDetails();

    setBusy(false);
  }

  Future<void> _getOtpSignature() async {
    await SmsAutoFill().listenForCode;
    signature = await SmsAutoFill().getAppSignature;
    showLog('signature->$signature');
  }

  Future<void> _getClientDetails() async {
    var prefs = await SharedPreferences.getInstance();
    clientId = (prefs.getInt('$clientIdPreferenceKey') ?? 0);
    showLog("Client Id : $clientId");
  }

  bool _isNumeric(String str) {
    String source = str.trim();
    return double.tryParse(source) != null;
  }

  login(emailOrMobile, {countryCode, code}) async {
    emailOrMobile = emailOrMobile.replaceAll(" ", "");
    ToastUtil toastUtil = ToastUtil();
    ToastContext().init(context!);
    if (countryCode == 108) {
      if (_isNumeric(emailOrMobile)) {
        if (emailOrMobile[0] == '0') {
          emailOrMobile = emailOrMobile.replaceFirst(new RegExp(r'^0+'), '');
        }
        if (emailOrMobile.length > 10) {
          return toastUtil.showShortToast(
              context!, S.of(context!).useValid10DigitMobileNumber);
        }
      }
    }
    //need to check clientId, signature is null
    showLog("inside else");
    try {
      LoginModel? response = await apiRepo!
          .loginApiCall(countryCode, clientId, signature, emailOrMobile, "0");
      showLog("inside else =========================$signature");
      if (response!.status == 4) {
        ToastUtil.showSnackBarAtCurrentState(response.errorMessage!);
        return;
      }
      /*    if(response.status == 0){
        showLog("the response ${response.status}");
      await  ToastUtil.showSnackBarAtCurrentState(response.errorMessage,seconds: 3);
        return;
      }*/

      await _parseLogin(emailOrMobile, response,
          code: code, countryId: countryCode);
      return;
    } on OfflineException catch (e) {
      showLog(e);
      ToastUtil.showInternetRequired(context!);
      setBusy(false);
      return;
    } catch (e) {
      setBusy(false);
      return;
    }
  }

  Future<void> firebaseLogin(
      BuildContext context, mobileNumber, countryCode) async {
    await PreferenceHelper.setBool(firebaseKey, true);
    setBusy(true);
    final PhoneVerificationCompleted verificationSuccess =
        (AuthCredential credential) {
      showLog('PhoneVerificationCompleted $credential');
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      showLog('PhoneVerificationFailed ${exception.message}');
      customSnackBar(
          context: context,
          title: 'TryAgain later',
          message: 'Something went wrong');
      setBusy(false);
    };

    final PhoneCodeSent codeSent =
        (String? verId, [int? forceCodeResend]) async {
      showLog('firebase otp $verId');
      this.VerificationCode = verId;
      await smsCodeDialog(context, mobileNumber, countryCode).then((value) {
        setBusy(false);
      });
    };
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      this.VerificationCode = verId;
    };
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: countryCode + mobileNumber,
          verificationCompleted: verificationSuccess,
          timeout: const Duration(seconds: 5),
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: autoRetrievalTimeout);
    } catch (e) {
      setBusy(false);
      showLog('firebase auth failed $e');
    }
    //setBusy(false);
  }

  smsCodeDialog(BuildContext context, mobileNumber, countryCode) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          showLog('smsCodeDialog $isLoading');
          return Form(
            key: _otpKey,
            child: AlertDialog(
              title: Column(
                children: [
                  CommonText(
                    text: isLoading.value == true
                        ? ''
                        : S.of(context).verification_code,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  CommonText(
                    text:
                        "${S.of(context).enterOtpSentTo}$countryCode$mobileNumber",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              content: /*TextField(
                onChanged: (value) {
                  smsCode = value;
                },
              ),*/
                  PinFieldAutoFill(
                autoFocus: true,
                decoration: UnderlineDecoration(
                  colorBuilder:
                      FixedColorBuilder(AppColorData.iconSelectedColor),
                  textStyle: Theme.of(context).textTheme.titleLarge,
                ),
                //currentCode: model.otp,
                onCodeChanged: ((value) async {
                  smsCode = value;
                  showLog("firebase otp filled...");
                  //model.otp = val!;
                  if (/*val.length == pinLength*/ 1 == 1) {
                    //ScreenUtil screenUtil = ScreenUtil();
                    //screenUtil.setCurrentDevice(context);
                    // widget.callBack(true);
                    try {
                      //await otpOnSubmit(model, countryId: widget.countryId);
                    } catch (e, s) {
                      showLog("the otp got some error while$e api $s");
                    }
                  }
                }),
                onCodeSubmitted: ((value) {
                  showLog('code submitted : $value');
                  smsCode = value;
                }),
                codeLength: 6,
              ),
              contentPadding: EdgeInsets.all(10),
              actions: [
                Center(
                    child: ValueListenableBuilder<bool>(
                        valueListenable: isLoading,
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return isLoading.value == true
                              ? CommonCircularProgress()
                              : ElevatedButton(
                                  onPressed: () async {
                                    isLoading.value = true;
                                    //User? user =
                                    // FirebaseAuth.instance.currentUser;
                                    // if (user != null) {
                                    showLog('user submit ${isLoading.value}');

                                    await otpOnSubmit(
                                        otpViewModel, context, mobileNumber);
                                    isLoading.value = false;

                                    /* Navigator.push(context,
                              MaterialPageRoute(builder: (context) => HomePage()));*/
                                    //} else {

                                    // signIn(context, mobileNumber);
                                    //}
                                  },
                                  child: Text('Submit'));
                        }))
              ],
            ),
          );
        });
  }

  signIn(BuildContext context, MobileNumber) {
    showLog('signIn');

    AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: VerificationCode!, smsCode: smsCode!);
    FirebaseAuth.instance
        .signInWithCredential(phoneAuthCredential)
        .then((user) async => await setUserData(context, MobileNumber)
            .catchError((e, s) => showLog(' $s')))
        .catchError((e, s) => customSnackBar(
            context: context,
            title: S.of(context).warning,
            message: 'Please fill correct OTP'));
    setBusy(false);
  }

  Future<void> otpOnSubmit(
      OtpViewModel model, BuildContext context, mobileNUmber) async {
    if (_otpKey.currentState!.validate()) {
      if (smsCode.toString() == "") {
        customSnackBar(
            context: context,
            title: S.of(context).warning,
            message: S.of(context).please_fill_this_field);
      } else if (smsCode.toString().length < otpLength) {
        customSnackBar(
            context: context,
            title: S.of(context).warning,
            message: S.of(context).otp_length_validation_error);
      } else {
        try {
          showLog("response returned ...");
          //if (response != null)
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            showLog('user user ${user}');
            //Navigator.pop(context);
            try {
              await setUserData(context, mobileNUmber);
            } catch (e) {
              showLog('setUserData $e');
            }
            /* Navigator.push(context,
                              MaterialPageRoute(builder: (context) => HomePage()));*/
          } else {
            await signIn(context, mobileNUmber);
          }
        } catch (e) {
          // Navigator.pop(context);
          isLoading.value = false;

          setBusy(false);
          showLog('Please fill');
          ToastUtil.showLongToast(context, "Please fill correct OTP");
          // widget.callBack(false);
        }
      }
    }
  }

  setUserData(BuildContext context, mobileNumber,
      {isFirebaseLogin = false}) async {
    showLog("Response firebase response} >>> ");
    PhotomallApis photomallApis = PhotomallApis(null);
    OtpViewModel model = OtpViewModel();
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
      if (response != null) {
        prefs.setBool(isUserLoggedInPreferenceKey, true);
        await prefs.setBool(otpApiCallKey, true);
        prefs.setString(accessTokenPreferenceKey, response.accessToken!);
        prefs.setString(refreshTokenPreferenceKey, response.refreshToken!);
        LoginController loginController = LoginController();
        await loginController.setUpLoginData();
        setBusy(false);
        {
          showLog(
              'Navigating to redirection  executeRedirection method worked firebase');
          ReDirectionPreference reDirectionPreference = ReDirectionPreference();
          RedirectionModel? redirection =
              await reDirectionPreference.getRedirectionRoute();
          showLog('method worked firebase $redirection');
          if (redirection != null &&
              redirection.redirection != null &&
              redirection.redirection!.route != null &&
              redirection.redirection!.route != '') {
            while (Navigator.canPop(context)) {
              Navigator.pop(context);
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
          if (isPhotomallApp) {
           // Navigator.pop(context);
            drawerModel.setDrawerChild(
                EventsListRoute(
                  arguments: EventsListArguments(isArchivedEven: false),
                ),
                S.of(context).events,
                // GalleryRoute(),
                //'${'studio name'}',
                SideDrawerConstants.PhotomallEvents,
                SideDrawerConstants.PhotomallEvents);
          } else {
            var gallery = await PreferenceHelper.getBool(galleryKey);
            var carousel = await PreferenceHelper.getBool(carouselKey);
            var party = await PreferenceHelper.getString(studioTypeKey);
            showLog(' worked firebase $gallery $carousel $party');
            if (party != 'Party' ||
                (party == 'Party' && gallery == true ||
                    party == 'Party' && carousel == true)) {
              drawerModel.setDrawerChild(
                  EventsListRoute(
                    arguments: EventsListArguments(isArchivedEven: false),
                  ),
                  S.of(context).events,

                  // GalleryRoute(),
                  //'${'studio name'}',
                  (model.isPartyApp == true &&
                          model.isGalleryAvailable == false)
                      ? 0
                      : (model.isPartyApp && model.isGalleryAvailable == true)
                          ? 1
                          : SideDrawerConstants.CustomerEvents,
                  (model.isPartyApp == true &&
                          model.isGalleryAvailable == false)
                      ? 0
                      : (model.isPartyApp && model.isGalleryAvailable == true)
                          ? 1
                          : BottomNavigationConstants.CustomerEvents);
              // Navigator.pop(context);
            } else {
              showLog('  firebase login conclusion $gallery $carousel $party');

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

            (isFirebaseLogin != true) ? Navigator.pop(context) : null;
          }
        }
        //});
      } else {
        showLog('response is null');
        isLoading.value = false;
        ToastUtil.showSnackBarAtCurrentState(
            S.of(context).something_went_wrong);
        GoogleSignIn googleSignIn = GoogleSignIn();

        try {
          await FirebaseAuth.instance.signOut();
          await googleSignIn.signOut();
          return true;
        } on Exception catch (_) {
          return false;
        }
      }
    } catch (e) {
      isLoading.value = false;
      ToastUtil.showSnackBarAtCurrentState(S.of(context).something_went_wrong);
    }
  }

  Future<bool?> _parseLogin(emailOrMobile, LoginModel response,
      {code, countryId}) async {
    FocusScope.of(context!).unfocus();
    var prefs = await SharedPreferences.getInstance();
    if (response.status != null) {
      prefs.setString(loginType, response.ableType!);
      prefs.setString(userMobileNumberPreferenceKey, emailOrMobile);
      bool status = await _showEventListPop(code: code, countryId: countryId);
      return status;
    }
    return null;
  }

  Future<bool> _showEventListPop({code, countryId}) async {
    showLog('_showEventListPop');

    Navigator.push(
        context!,
        SlidePageRoute(
            widget: showOtpPage(code: code, countryId: countryId),
            direction: AxisDirection.left));

    return false;
  }

  showOtpPage({code, countryId}) {
    bool closeButtonRestricted = false;

    return Material(
      child: Container(
        height: MediaQuery.of(context!).size.height, // Full-screen height

        padding: EdgeInsets.only(
          top: 16,
          left: 25,
          right: 25,
          bottom: MediaQuery.of(context!).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title Row

                  SizedBox(height: 16),
                  // Content Widget
                  SingleChildScrollView(
                    child: OtpPopup(
                      otpContext: context,
                      countryCode: code,
                      countryId: countryId,
                      callBack: (value) {
                        showLog("closeButtonRestricted unix $value");
                        closeButtonRestricted = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              top: 65,
              child: Container(
                height: 35.0,
                width: 35.0,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100)),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  color: Colors.transparent,
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColorData.bgIconColor,
                    size: 30,
                  ),
                  onPressed: () {
                    if (closeButtonRestricted) {
                      try {
                        ToastUtil toast = ToastUtil();
                        ToastContext().init(context!);
                        toast.showShortToast(context!, "please wait");
                      } catch (e) {
                        showLog("OTP error while show toast \n $e");
                      }
                      return;
                    }
                    Navigator.of(context!).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
