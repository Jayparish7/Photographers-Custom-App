import 'dart:async';
import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/Utils/device_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/ui/profile/model/status_and_message_model.dart';
import 'package:photomall_flutter/ui/profile/view_model/customer_profile_view_route_model.dart';
import 'package:photomall_flutter/ui/shared_widgets/common.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:photomall_flutter/ui/themes/theme.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../generated/l10n.dart';

class EmailBottomSheet {
  void showBottomSheetForChangeEmailAddress(CustomerProfileViewRouteModel model,
      String email, String ableType, BuildContext context,
      {bool forVerifyEmail = false,
      bool forEdit = false,
      otpMessage = ''}) async {
    showLog('controller opened');
    String emailAddress = '';
    final RegExp emailRegularExpression = RegExp(
        "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$");
    String _code = '';
    final _changeEmailFormKey = GlobalKey<FormState>();
    TextEditingController emailTextEditingController = TextEditingController();
    String statusMsg = '';
    bool? isError;
    bool isOtpScreen = false;
    bool isBusy = false;
    String otpStatusMsg = otpMessage;
    final ValueNotifier<bool> errorShowing = ValueNotifier<bool>(false);

    if (forVerifyEmail) isOtpScreen = true;
    emailTextEditingController.text = email.toString().trim();
    await showModalBottomSheet<void>(
      backgroundColor: AppColorData.cardBackgroundColors[0],
      isScrollControlled: true,
      context: context,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            //bottom: 0.0),

            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CommonText(
                        text: email.isNotEmpty
                            ? S.of(context).email_address
                            : S.of(context).email_address,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        splashRadius: 18,
                        icon: Icon(
                          Icons.close,
                          color: AppColorData.bgIconColor,
                        ),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 800),
                    firstChild: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Form(
                        key: _changeEmailFormKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              cursorColor: AppColorData.textFormFieldCursor,
                              style: Theme.of(context).textTheme.titleLarge,
                              keyboardType: TextInputType.emailAddress,
                              controller: emailTextEditingController,
                              decoration: CustomAppTheme.boxTextFieldDecoration(
                                  context, S.of(context).enterEmailAddress),
                              validator: (String? value) {
                                if (value.toString().trim().isEmpty) {
                                  return S.of(context).pleaseEnterEmailAddresss;
                                } else if (!emailRegularExpression
                                    .hasMatch(value.toString().trim())) {
                                  return S
                                      .of(context)
                                      .pleaseEnterValidEmailAddress;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: CustomButtonWithProgress(
                                text: S.of(context).continue_text,
                                isShowProgress: isBusy,
                                onNetworkError: () {
                                  state(() {
                                    isBusy = false;
                                    isOtpScreen = false;
                                    isError = true;
                                    statusMsg = S.of(context).yourOffline;
                                  });
                                },
                                onPressed: () async {
                                  try {
                                    _code = "";
                                    FocusScope.of(context).unfocus();
                                    if (!isBusy) {
                                      if (_changeEmailFormKey.currentState!
                                          .validate()) {
                                        state(() {
                                          isBusy = true;
                                        });
                                        showLog('email update $emailAddress');
                                        StatusAndMessageModel? status =
                                            await model.addUserEmail(
                                                emailTextEditingController.text
                                                    .toString()
                                                    .trim(),
                                                'users');
                                        showLog('email update 1 $status');

                                        state(() {
                                          isBusy = false;
                                        });
                                        if (status != null && status.status!) {
                                          model.changeEmailAndRefreshInUi(
                                            emailTextEditingController.text
                                                .toString()
                                                .trim(),
                                          );
                                          isOtpScreen = true;
                                          isError = null;
                                          statusMsg = '';
                                          otpStatusMsg = status.message!;
                                          state(() {});
                                        }
                                      }
                                    }
                                  } catch (e) {
                                    //print(e);
                                  }

                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    secondChild: isOtpScreen
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CommonText(
                                        text: otpStatusMsg,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                    ),
                                    DeviceUtil.isMobile
                                        ? TextFieldPinAutoFill(
                                            decoration: CustomAppTheme
                                                    .boxTextFieldDecoration(
                                                        context,
                                                        S.of(context).enterOtp)
                                                .copyWith(),
                                            currentCode: _code,
                                            onCodeChanged: (code) {
                                              errorShowing.value = false;
                                              _code = code.toString().trim();
                                              if (code
                                                      .toString()
                                                      .trim()
                                                      .length ==
                                                  4) {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              }
                                            },
                                            codeLength: 4,
                                          )
                                        : TextField(
                                            cursorColor: AppColorData
                                                .textFormFieldCursor,
                                            //keyboardType: TextInputType.number,
                                            decoration: CustomAppTheme
                                                    .boxTextFieldDecoration(
                                                        context,
                                                        S.of(context).enterOtp)
                                                .copyWith(),
                                            //currentCode: _code,
                                            onChanged: (code) {
                                              _code = code.toString().trim();
                                              if (code
                                                      .toString()
                                                      .trim()
                                                      .length ==
                                                  4) {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              }
                                            },
                                            maxLength: 4,
                                          ),
                                    ValueListenableBuilder<bool>(
                                      valueListenable: errorShowing,
                                      builder: (context, bool value, child) {
                                        if (errorShowing.value == true) {
                                          return Visibility(
                                            visible: value,
                                            child: CommonText(
                                              text: "OTP is not valid",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                          );
                                        } else {
                                          return SizedBox();
                                        }
                                      },
                                    )
                                  ],
                                ),

                                //need to change
                                SizedBox(height: 20),
                                Container(
                                  width: double.infinity,
                                  height: 45,
                                  child: CustomButtonWithProgress(
                                    text: S.of(context).continue_text,
                                    isShowProgress: isBusy,
                                    onNetworkError: () {
                                      state(() {
                                        isBusy = false;
                                        isOtpScreen = false;
                                        isError = true;
                                        statusMsg = S.of(context).yourOffline;
                                      });
                                    },
                                    onPressed: () async {
                                      try {
                                        if (!isBusy) {
                                          FocusScope.of(context).unfocus();
                                          state(() {
                                            isBusy = true;
                                          });
                                          StatusAndMessageModel? response =
                                              await model.verifyOtpForEmail(
                                                  _code,
                                                  emailTextEditingController
                                                      .text
                                                      .toString()
                                                      .trim());
                                          state(() {
                                            isBusy = false;
                                          });
                                          if (response != null &&
                                              response.status!) {
                                            model.changeEmailAndRefreshInUi(
                                              emailTextEditingController.text
                                                  .toString()
                                                  .trim(),
                                            );
                                            state(() {
                                              isOtpScreen = false;
                                              isError = false;
                                              statusMsg = response.message!;
                                              emailAddress =
                                                  emailTextEditingController
                                                      .text
                                                      .toString()
                                                      .trim();
                                            });
                                            Timer(Duration(milliseconds: 2000),
                                                () {
                                              Navigator.pop(context, true);
                                            });
                                          } else {
                                            errorShowing.value = true;
                                          }
                                        }
                                      } catch (e) {
                                        showLog("Otp continue button ${e}");
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              isError != null
                                  ? Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: AppColorData
                                                  .bgIconBackgroundColor,
                                              begin: AppColorData
                                                  .bgIconGradientBegin,
                                              end: AppColorData
                                                  .bgIconGradientEnd,
                                              stops: AppColorData.bgIconStops,
                                            ),
                                            shape: BoxShape.circle),
                                        padding: EdgeInsets.all(20),
                                        child: Icon(
                                          isError!
                                              ? Icons.error_outline
                                              : Icons.check,
                                          color: AppColorData.bgIconColor,
                                          //AppColor.get(context, ColorKeys.lightThemeColor),
                                          size: 32,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 60,
                                    ),
                              const SizedBox(
                                height: 15,
                              ),
                              CommonText(
                                text: statusMsg,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                    crossFadeState: isError == null && !isOtpScreen
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
      },
    );
    emailTextEditingController.text = '';
  }
}
