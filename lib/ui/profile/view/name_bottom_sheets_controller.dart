import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/ui/profile/bottom_sheet_helper.dart';
import 'package:photomall_flutter/ui/profile/view_model/customer_profile_view_route_model.dart';
import 'package:photomall_flutter/ui/shared_widgets/common.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:photomall_flutter/ui/themes/theme.dart';
import '../../../generated/l10n.dart';

class NameBottomSheetsController {
  void showBottomSheetForChangeName(CustomerProfileViewRouteModel model,
      String name, BuildContext context) async {
    showLog('showBottomSheetForChangeName $name');
    final ValueNotifier<bool> loading = ValueNotifier<bool>(false);
    final ValueNotifier<bool> isConnected = ValueNotifier<bool>(true);
    final ValueNotifier<bool> errorWidget = ValueNotifier<bool>(false);
    bool isUpdated = false;
    FocusNode nameFocusNode = FocusNode();
    listenNetwork(onStateChange: (bool value) {
      isConnected.value = value;
    });

    Size contentSize = const Size(0, 0);
    TextEditingController nameTextEditingController = TextEditingController();
    final _changeNameFormKey = GlobalKey<FormState>();
    bool isBusy = false;
    nameTextEditingController.text = name.toString().trim();
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
        return Builder(builder: (context) {
          return ValueListenableBuilder<bool>(
              valueListenable: errorWidget,
              builder: (BuildContext context, bool errorStatus, Widget? child) {
                return ValueListenableBuilder<bool>(
                    valueListenable: isConnected,
                    builder: (BuildContext context, bool networkStatus,
                        Widget? child) {
                      if (!networkStatus) {
                        return networkError(context);
                      }
                      if (errorStatus) {
                        return errorView(context);
                      }
                      return StatefulBuilder(builder: (context, state) {
                        return AnimatedCrossFade(
                            firstChild: Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              //bottom: 0.0),
                              child: BottomSheetHelper(
                                width: contentSize.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CommonText(
                                            text: name.isNotEmpty
                                                ? S.of(context).changeName
                                                : S.of(context).addName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          IconButton(
                                            splashRadius: 18,
                                            icon: Icon(
                                              Icons.close,
                                              color: AppColorData.bgIconColor,
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Form(
                                          key: _changeNameFormKey,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                focusNode: nameFocusNode,
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                cursorColor: AppColorData
                                                    .textFormFieldCursor,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                                keyboardType:
                                                    TextInputType.text,
                                                controller:
                                                    nameTextEditingController,
                                                decoration: CustomAppTheme
                                                    .boxTextFieldDecoration(
                                                        context,
                                                        S.of(context).name),
                                                validator: (String? value) {
                                                  if (value
                                                      .toString()
                                                      .trim()
                                                      .isEmpty) {
                                                    return S
                                                        .of(context)
                                                        .pleaseEnterYourName;
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                              ValueListenableBuilder<bool>(
                                                  valueListenable: loading,
                                                  builder:
                                                      (BuildContext context,
                                                          bool value,
                                                          Widget? child) {
                                                    return value
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              height: 45,
                                                              child:
                                                                  CommonCircularProgress(),
                                                            ),
                                                          )
                                                        : SizedBox(
                                                            width:
                                                                double.infinity,
                                                            height: 45,
                                                            child:
                                                                CustomButtonWithProgress(
                                                              text: S
                                                                  .of(context)
                                                                  .continue_text,
                                                              isShowProgress:
                                                                  isBusy,
                                                              onNetworkError:
                                                                  () {
                                                                errorWidget
                                                                        .value =
                                                                    true;
                                                              },
                                                              onPressed:
                                                                  () async {
                                                                //   loading.value = !loading.value;
                                                                //   try {
                                                                if (!isBusy) {
                                                                  if (_changeNameFormKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    bool
                                                                        status =
                                                                        await (model
                                                                            .changeUserName(
                                                                      nameTextEditingController
                                                                          .text
                                                                          .toString()
                                                                          .trim(),
                                                                    ));

                                                                    isBusy =
                                                                        false;

                                                                    if (status) {
                                                                      model.changeNameAndRefreshInUi(nameTextEditingController
                                                                          .text
                                                                          .toString());
                                                                    } else {
                                                                      errorWidget
                                                                              .value =
                                                                          true;
                                                                    }
                                                                    isUpdated =
                                                                        true;
                                                                    Timer(
                                                                        Duration(
                                                                            milliseconds:
                                                                                2000),
                                                                        () {
                                                                      Navigator.pop(
                                                                          context,
                                                                          true);
                                                                    });
                                                                  }
                                                                }
                                                                // } catch (e) {
                                                                //     print(e);
                                                                //  }
                                                                //  loading.value = !loading.value;
                                                              },
                                                            ),
                                                          );
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            secondChild: updatedWidget(context),
                            crossFadeState: !isUpdated
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: Duration(seconds: 1));
                      });
                    });
              });
        });
      },
    );
    nameTextEditingController.text = '';
  }

  void listenNetwork({required Function(bool value) onStateChange}) {
    InternetConnectionChecker.instance.onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.connected) {
        onStateChange(true);
      } else {
        onStateChange(false);
      }
    });
  }

  Widget networkError(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                text: S.of(context).changeName,
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
          Icon(
            Icons.network_check,
            size: 80,
            color: AppColorData.iconColor,
          ),
          CommonText(
            text: "Check connectivity",
            style: Theme.of(context).textTheme.labelMedium,
          )
        ],
      ),
    );
  }

  Widget updatedWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                text: S.of(context).nameUpdatedSuccessfully,
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
          Icon(
            Icons.check_circle,
            size: 80,
            color: AppColorData.iconColor,
          ),
          CommonText(
            text: S.of(context).success,
            style: Theme.of(context).textTheme.labelLarge,
          )
        ],
      ),
    );
  }

  Widget errorView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                text: S.of(context).something_went_wrong,
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
          Icon(
            Icons.error_outline,
            size: 80,
            color: AppColorData.iconColor,
          ),
          CommonText(
            text: S.of(context).please_try_after_some_time,
            style: Theme.of(context).textTheme.labelMedium,
          )
        ],
      ),
    );
  }
}
