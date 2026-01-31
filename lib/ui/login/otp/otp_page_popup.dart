import 'dart:async';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/redirection_controller.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/Utils/snackbar_helper.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/otp_model.dart';

import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/preference/preference_handler/redirection_preference_handler.dart';
import 'package:photomall_flutter/preference/preference_model/redirection_preference_model.dart';
import 'package:photomall_flutter/traits/utils/screen_utils.dart';
import 'package:photomall_flutter/ui/app_side_drawer/side_drawer_constants.dart';
import 'package:photomall_flutter/ui/base/base_widget.dart';
import 'package:photomall_flutter/ui/bottom_navigation/bottom_navigation_constants.dart';
import 'package:photomall_flutter/ui/drawer/side_drawer_model.dart';
import 'package:photomall_flutter/ui/event/list/events_list_route.dart';
import 'package:photomall_flutter/ui/login/otp/otp_view_model.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart' as pin;

class OtpPopup extends StatefulWidget {
  final otpContext;

  final countryCode;
  final countryId;
  final Function callBack;

  OtpPopup({
    this.countryCode,
    this.countryId,
    required this.callBack,
    required this.otpContext,
  });

  @override
  _OtpPopupState createState() => _OtpPopupState();
}

class _OtpPopupState extends State<OtpPopup> {
  final _otpKey = GlobalKey<FormState>();
  var oneTimePasswordController = TextEditingController();
  TransporterDao transporterDao = TransporterDao();
  String thisText = "";
  int pinLength = otpLength;
  bool hasError = false;
  String? errorMessage;
  Timer? _timer;
  int _resendOTPDelay = resendOTPDelay;

  bool resendOtpTextEnabled = false;
  bool registered = false;
  bool loggedIn = false;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_resendOTPDelay < 1) {
            timer.cancel();
            setState(() {
              resendOtpTextEnabled = true;
            });
          } else {
            _resendOTPDelay = _resendOTPDelay - 1;

            setState(() {
              resendOtpTextEnabled = false;
            });
          }
        },
      ),
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer?.cancel();
    }
    pin.SmsAutoFill().unregisterListener();

    //  FocusScope.of(context).dispose();
    super.dispose();
  }

  _setBusy(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 25),
        child: new CommonCircularProgress(isOtpPage: [1]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<OtpViewModel>(
      model: OtpViewModel(
          apiHandler: Provider.of<ApiHelper>(context, listen: false),
          context: context),
      onModelReady: (model) => model.getUserDetails(),
      builder: (context, model, child) => Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              model.busy
                  ? _setBusy(context)
                  : _setOtpContent(
                      context,
                      model,
                    ),
              //_setCloseButton(context),
            ],
          ),
        ],
      ),
    );
  }

  _setOtpContent(
    BuildContext context,
    OtpViewModel model,
  ) {
    return Form(
      key: _otpKey,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              UniqueText(
                text: S.of(context).otp_verification,
                letterSpacing: 1.5,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Stack(
            children: [
              Icon(
                FontAwesome.mobile_screen_solid,
                size: 45,
                color: AppColorData.bgIconColor,
              ),
              Positioned(
                  right: 0,
                  top: 5,
                  child: Material(
                      color: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      elevation: 2,
                      child: Icon(
                        Icons.message_outlined,
                        size: 25,
                        color: AppColorData.bgIconColor,
                      ))),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          (_isNumeric(model.userMobileNumber))
              ? Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonText(
                      text:
                          "${S.of(context).enterOtpSentTo}${widget.countryCode ?? ""} ${model.userMobileNumber}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                )
              : Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonText(
                      text:
                          "${S.of(context).enterOtpSentTo} ${model.userMobileNumber}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
          SizedBox(
            height: 50,
            child: pin.PinFieldAutoFill(
              autoFocus: true,
              cursor: pin.Cursor(
                  enabled: true,
                  orientation: pin.Orientation.horizontal,
                  color: AppColorData.appBarTextColor,
                  height: 15,
                  width: 2),
              decoration: pin.BoxLooseDecoration(
                  bgColorBuilder: pin.PinListenColorBuilder(
                    AppColorData.appBarTextColor,
                    Colors.transparent,
                  ),
                  strokeWidth: 1.0,
                  radius: Radius.circular(8),
                  strokeColorBuilder: pin.PinListenColorBuilder(
                    Colors.green,
                    AppColorData.iconSelectedColor,
                  )),
              currentCode: model.otp ?? "",
              onCodeChanged: ((val) async {
                model.isOtpApiCalled = false;

                if (val != null && val.isNotEmpty) {
                  showLog("otp filled...");
                  model.otp = val!;
                  if (val.length == pinLength) {
                    widget.callBack(true);
                    try {
                      if (!context.mounted) return;
                      if (!model.isOtpApiCalled) {
                        model.isOtpApiCalled = true;
                        showLog('otpOnSubmit ${model.isOtpApiCalled}');

                        await otpOnSubmit(model, countryId: widget.countryId);
                      } else {
                        showLog('Already called ${model.isOtpApiCalled}');
                      }
                      widget.callBack(false);
                    } catch (e, s) {
                      showLog("the otp got some error dd $e api $s");
                      widget.callBack(false);
                    }
                  }
                }
              }),
              onCodeSubmitted: ((val) {
                showLog('code submitted : $val');
                model.otp = val;
              }),
              codeLength: pinLength,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (resendOtpTextEnabled) {
                setState(() {
                  resendOtpTextEnabled = false;
                  _resendOTPDelay = resendOTPDelay;
                });
                startTimer();
                if (_otpKey.currentState!.validate()) {
                } else {}
              } else {}
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CommonText(
                    isTextButton: true,
                    text: resendOtpTextEnabled
                        ? S.of(context).resend_otp
                        : "$_resendOTPDelay ${S.of(context).sec}",
                  ),
                ),
                /*Text(
                  resendOtpTextEnabled
                      ? S.of(context).resend_otp
                      : "$_resendOTPDelay sec",
                  style: TextStyle(color: textColor),
                ),*/
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> otpOnSubmit(OtpViewModel model, {countryId}) async {
    if (_otpKey.currentState!.validate()) {
      if (model.otp.toString() == "") {
        customSnackBar(
            context: context,
            title: S.of(context).warning,
            message: S.of(context).please_fill_this_field);
      } else if (model.otp.toString().length < otpLength) {
        customSnackBar(
            context: context,
            title: S.of(context).warning,
            message: S.of(context).otp_length_validation_error);
      } else {
        try {
          OtpModel? response =
              await model.oneTimePasswordApiCall(countryId: countryId);
          showLog("response returned ... $response");

          if (response != null) {
            // setState(() {});

            // call user data and studio user data

            showLog(
                'Navigating to redirection  executeRedirection method worked 1');

            ReDirectionPreference reDirectionPreference =
                ReDirectionPreference();
            RedirectionModel? redirection =
                await reDirectionPreference.getRedirectionRoute();
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
            // setState(() async {
            // get studio name
            //    String studioName = await getStudioName();

            SideDrawerModel drawerModel =
                Provider.of<SideDrawerModel>(context, listen: false);
            showLog("message for login to throw the gallery page");
            if (isPhotomallApp) {
              Navigator.pop(context);
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

              Navigator.pop(context);
            }
            //});
          } else {
            widget.callBack(false);
            ToastUtil.showLongToast(context, "Please fill correct OTP");

            model.setBusy(false);
          }
        } catch (e) {
          // Navigator.pop(context);
          showLog('api otp chat');
          model.setBusy(false);
          ToastUtil.showLongToast(context, "Please fill correct OTP");

          widget.callBack(false);
        }
      }
    }
  }

  bool _isNumeric(String str) {
    String source = str.trim();
    return double.tryParse(source) != null;
  }
}
