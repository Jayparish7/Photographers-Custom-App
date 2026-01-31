import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/api_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as country;
import 'package:photomall_flutter/ui/event/unAuth_user/unAuth_user_view_model.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_appbar.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';

import '../../../color_constants.dart';
import '../../../core/Utils/fade_animation.dart';
import '../../../core/constants/common_constants.dart';
import '../../../core/constants/studio_config_constants.dart';
import '../../../traits/common_widgets/country_picker.dart';
import '../../../traits/common_widgets/custom_transition_widget.dart';
import '../../base/base_widget.dart';
import '../../shared_widgets/common_text.dart';

class UnAuthUserForm extends StatefulWidget {
  final String eventCode;

  const UnAuthUserForm({super.key, required this.eventCode});

  @override
  State<UnAuthUserForm> createState() => _UnAuthUserFormState();
}

class _UnAuthUserFormState extends State<UnAuthUserForm> {
  BaseWidget<UnAuthUserViewModel>? baseWidget;
  final _formKey = GlobalKey<FormState>();

  final buffer = StringBuffer();

  @override
  Widget build(BuildContext context) {
    baseWidget = BaseWidget<UnAuthUserViewModel>(
      model: UnAuthUserViewModel(
        context,
      ),
      onModelReady: (model) {
        if (splashBackgroundColorCode.length == 6 ||
            splashBackgroundColorCode.length == 7) buffer.write('ff');
        buffer.write(splashBackgroundColorCode.replaceFirst('#', ''));
        model.getInitialValues(widget.eventCode);
      },
      builder: (context, model, child) {
        var width = MediaQuery.of(context).size.width * .3;

        return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: AppColorData.backgroundColors,
                    begin: AppColorData.backgroundGradientBegin,
                    end: AppColorData.backgroundGradientEnd,
                    stops: AppColorData.appBackgroundStops)),
            child: Scaffold(
              appBar: CommonAppBar(
                title: S.of(context).myPhotos,
              ),
              body: Stack(
                children: [
                  Positioned.fill(
                      child: model.isLoading
                          ? CommonCircularProgress()
                          : SizedBox()),
                  SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 15,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Color(
                                      int.parse(buffer.toString(), radix: 16)),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Image.asset(
                                'assets/images/splash_logo.png',
                                height: 100,
                                width: 100,
                              )
                                  .animate(delay: Duration(microseconds: 500))
                                  .fadeIn(delay: Duration(microseconds: 500))
                                  .animate(
                                      onPlay: (controller) =>
                                          controller.repeat())
                                  .shimmer(duration: 3400.ms),
                            ),
                            ValueListenableBuilder<country.Country>(
                                valueListenable: model.dropDownValue,
                                builder: (BuildContext context,
                                    country.Country itemValue, Widget? child) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        //shape: BoxShape.rectangle,
                                        border: Border(
                                          bottom: BorderSide(
                                              color:
                                                  AppColorData.appBarTextColor,
                                              width: 1.5),
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomCountryPicker(
                                        dropDownValue: itemValue.id!,
                                        onchangeDropDown: (int _id) {
                                          country.Country? _value = model
                                              .loginController
                                              .getObjectByCountryId(_id);
                                          model.dropDownValue.value =
                                              country.Country(
                                                  id: _value!.id,
                                                  code: _value.code,
                                                  name: _value.name,
                                                  shortCode: _value.shortCode);

                                          setState(() {
                                            try {} catch (e) {
                                              showLog('onChangeValidation $e');
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                }),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 3,
                                top: 8,
                              ),
                              child: FadeAnimation(
                                delay: 1.6,
                                child: CustomItemTransition(
                                  duration: itemTransitionDuration,
                                  delay: itemTransitionDelay * 3,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColorData.appBarTextColor
                                            .withOpacity(.2),
                                        shape: BoxShape.rectangle,
                                        border: Border(
                                            bottom: BorderSide(
                                                color: AppColorData
                                                    .appBarTextColor,
                                                width: 1.5)
                                            // Change the color according to your preference
                                            // Change the width according to your preference
                                            ),
                                      ),
                                      child: TextFormField(
                                        validator: (value) {
                                          final trimmedMobile =
                                              value?.trim() ?? '';
                                          final trimmedEmail =
                                              model.emailController.text.trim();
                                          if (model.isCorporateEvent == 1 &&
                                              trimmedMobile.isEmpty) {
                                            return 'Please enter  mobile number';
                                          }
                                          if (trimmedMobile.isEmpty &&
                                              trimmedEmail.isEmpty) {
                                            return 'Please enter either email or mobile number';
                                          } else if (trimmedMobile.isNotEmpty &&
                                              !onlyDigits
                                                  .hasMatch(trimmedMobile)) {
                                            return 'Please enter a valid mobile number';
                                          }
                                          if (trimmedMobile.length != 10 &&
                                              model.dropDownValue.value.code ==
                                                  '+91') {
                                            return 'Please enter a valid mobile number';
                                          }
                                          return null;
                                        },

                                        autofillHints: [
                                          AutofillHints.telephoneNumber,
                                        ],
                                        contextMenuBuilder:
                                            (context, editableTextState) {
                                          final List<ContextMenuButtonItem>
                                              buttonItems = editableTextState
                                                  .contextMenuButtonItems;
                                          buttonItems.removeWhere(
                                              (ContextMenuButtonItem
                                                  buttonItem) {
                                            return buttonItem.type ==
                                                ContextMenuButtonType.cut;
                                          });
                                          return AdaptiveTextSelectionToolbar
                                              .buttonItems(
                                            anchors: editableTextState
                                                .contextMenuAnchors,
                                            buttonItems: buttonItems,
                                          );
                                        },
                                        inputFormatters: [
                                          //  if (denySpaces)
                                          FilteringTextInputFormatter.deny(
                                              RegExp(r'\s')),
                                        ],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        // const TextStyle(fontSize: TextProperty.p1),
                                        autofocus: false,
                                        cursorColor:
                                            AppColorData.textFormFieldCursor,
                                        controller: model.mobileController,
                                        decoration: InputDecoration(
                                          labelText: "Whatsapp Number",
                                          suffixIcon: Icon(
                                            FontAwesome.whatsapp_brand,
                                            color: AppColorData.iconColor,
                                          ),
                                          hintText: "Whatsapp Number",
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            try {} catch (e) {
                                              showLog(
                                                  'onChangeValidation---> $e');
                                            }
                                          });
                                        },
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 3,
                                top: 8,
                              ),
                              child: FadeAnimation(
                                delay: 1.6,
                                child: CustomItemTransition(
                                  duration: itemTransitionDuration,
                                  delay: itemTransitionDelay * 3,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColorData.appBarTextColor
                                            .withOpacity(.2),
                                        shape: BoxShape.rectangle,
                                        border: Border(
                                            bottom: BorderSide(
                                                color: AppColorData
                                                    .appBarTextColor,
                                                width: 1.5)
                                            // Change the color according to your preference
                                            // Change the width according to your preference
                                            ),
                                      ),
                                      child: TextFormField(
                                        validator: (value) {
                                          final trimmedEmail =
                                              value?.trim() ?? '';
                                          final trimmedMobile = model
                                              .mobileController.text
                                              .trim();
                                          if (model.isCorporateEvent == 1 &&
                                              trimmedEmail.isEmpty) {
                                            return 'Please enter  email address';
                                          }
                                          if (trimmedEmail.isEmpty &&
                                              trimmedMobile.isEmpty) {
                                            return 'Please enter either email or mobile number';
                                          } else if (trimmedEmail.isNotEmpty &&
                                              !emailRegularExpression
                                                  .hasMatch(trimmedEmail)) {
                                            return 'Please enter a valid email address';
                                          }

                                          return null;
                                        },
                                        autofillHints: [
                                          AutofillHints.email,
                                        ],
                                        contextMenuBuilder:
                                            (context, editableTextState) {
                                          final List<ContextMenuButtonItem>
                                              buttonItems = editableTextState
                                                  .contextMenuButtonItems;
                                          buttonItems.removeWhere(
                                              (ContextMenuButtonItem
                                                  buttonItem) {
                                            return buttonItem.type ==
                                                ContextMenuButtonType.cut;
                                          });
                                          return AdaptiveTextSelectionToolbar
                                              .buttonItems(
                                            anchors: editableTextState
                                                .contextMenuAnchors,
                                            buttonItems: buttonItems,
                                          );
                                        },
                                        inputFormatters: [
                                          //  if (denySpaces)
                                          FilteringTextInputFormatter.deny(
                                              RegExp(r'\s')),
                                        ],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        // const TextStyle(fontSize: TextProperty.p1),
                                        autofocus: false,
                                        cursorColor:
                                            AppColorData.textFormFieldCursor,
                                        controller: model.emailController,
                                        decoration: InputDecoration(
                                          suffixIcon: Icon(
                                            Icons.mail,
                                            color: AppColorData.iconColor,
                                          ),
                                          labelText: "Email address",
                                          hintText: "Enter your email address",
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            try {} catch (e) {
                                              showLog(
                                                  'onChangeValidation---> $e');
                                            }
                                          });
                                        },
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 3,
                                top: 8,
                              ),
                              child: FadeAnimation(
                                delay: 1.6,
                                child: CustomItemTransition(
                                  duration: itemTransitionDuration,
                                  delay: itemTransitionDelay * 3,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColorData.appBarTextColor
                                            .withOpacity(.2),
                                        shape: BoxShape.rectangle,
                                        border: Border(
                                            bottom: BorderSide(
                                                color: AppColorData
                                                    .appBarTextColor,
                                                width: 1.5)
                                            // Change the color according to your preference
                                            // Change the width according to your preference
                                            ),
                                      ),
                                      child: TextFormField(
                                        validator: (value) {
                                          final trimmedName =
                                              model.nameController.text.trim();
                                          if (model.isCorporateEvent == 1 &&
                                              trimmedName.isEmpty) {
                                            return 'Please enter Your Name';
                                          }

                                          return null;
                                        },
                                        autofillHints: [
                                          AutofillHints.email,
                                        ],
                                        contextMenuBuilder:
                                            (context, editableTextState) {
                                          final List<ContextMenuButtonItem>
                                              buttonItems = editableTextState
                                                  .contextMenuButtonItems;
                                          buttonItems.removeWhere(
                                              (ContextMenuButtonItem
                                                  buttonItem) {
                                            return buttonItem.type ==
                                                ContextMenuButtonType.cut;
                                          });
                                          return AdaptiveTextSelectionToolbar
                                              .buttonItems(
                                            anchors: editableTextState
                                                .contextMenuAnchors,
                                            buttonItems: buttonItems,
                                          );
                                        },
                                        inputFormatters: [
                                          //  if (denySpaces)
                                          FilteringTextInputFormatter.deny(
                                              RegExp(r'\s')),
                                        ],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        // const TextStyle(fontSize: TextProperty.p1),
                                        autofocus: false,
                                        cursorColor:
                                            AppColorData.textFormFieldCursor,
                                        controller: model.nameController,
                                        decoration: InputDecoration(
                                          labelText: "Your Name",
                                          hintText: "Enter Your Name",
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                          suffixText:
                                              model.isCorporateEvent == 1
                                                  ? "(required)"
                                                  : "(optional)",
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            try {} catch (e) {
                                              showLog(
                                                  'onChangeValidation---> $e');
                                            }
                                          });
                                        },
                                      )),
                                ),
                              ),
                            ),
                            (studioIdConfig == "z341pcuq")
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      left: 3,
                                      top: 8,
                                    ),
                                    child: FadeAnimation(
                                      delay: 1.6,
                                      child: CustomItemTransition(
                                        duration: itemTransitionDuration,
                                        delay: itemTransitionDelay * 3,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: AppColorData
                                                  .appBarTextColor
                                                  .withOpacity(.2),
                                              shape: BoxShape.rectangle,
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: AppColorData
                                                          .appBarTextColor,
                                                      width: 1.5)
                                                  // Change the color according to your preference
                                                  // Change the width according to your preference
                                                  ),
                                            ),
                                            child: TextFormField(
                                              validator: (value) {
                                                final trimmedDesc = model
                                                    .designationController.text
                                                    .trim();
                                                if (model.isCorporateEvent ==
                                                        1 &&
                                                    trimmedDesc.isEmpty) {
                                                  return 'Please enter your designation';
                                                }

                                                return null;
                                              },
                                              autofillHints: [
                                                AutofillHints.email,
                                              ],
                                              contextMenuBuilder:
                                                  (context, editableTextState) {
                                                final List<
                                                        ContextMenuButtonItem>
                                                    buttonItems =
                                                    editableTextState
                                                        .contextMenuButtonItems;
                                                buttonItems.removeWhere(
                                                    (ContextMenuButtonItem
                                                        buttonItem) {
                                                  return buttonItem.type ==
                                                      ContextMenuButtonType.cut;
                                                });
                                                return AdaptiveTextSelectionToolbar
                                                    .buttonItems(
                                                  anchors: editableTextState
                                                      .contextMenuAnchors,
                                                  buttonItems: buttonItems,
                                                );
                                              },
                                              inputFormatters: [
                                                //  if (denySpaces)
                                                FilteringTextInputFormatter
                                                    .deny(RegExp(r'\s')),
                                              ],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                              // const TextStyle(fontSize: TextProperty.p1),
                                              autofocus: false,
                                              cursorColor: AppColorData
                                                  .textFormFieldCursor,
                                              controller:
                                                  model.designationController,
                                              decoration: InputDecoration(
                                                suffixText: "(optional)",
                                                labelText: "Designation",
                                                hintText: "Designation",
                                                labelStyle: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge,
                                                border: OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  try {} catch (e) {
                                                    showLog(
                                                        'onChangeValidation---> $e');
                                                  }
                                                });
                                              },
                                            )),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(width: 1)),
                                      // backgroundColor: AppColorData
                                      // .buttonBackgroundColors.last,
                                      foregroundColor: AppColorData
                                          .buttonBackgroundColors.last,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CommonText(
                                        text: '${S.of(context).cancel}',
                                        style: TextStyle(letterSpacing: 3),
                                        color: AppColorData
                                            .buttonBackgroundColors.last,
                                      ),
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        backgroundColor: AppColorData
                                            .buttonBackgroundColors.last,
                                        foregroundColor:
                                            AppColorData.buttonTextColors),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CommonText(
                                        text: '${S.of(context).submit}',
                                        style: TextStyle(letterSpacing: 3),
                                      ),
                                    ),
                                    onPressed: () async {
                                      showLog("_formKey");
                                      if (_formKey.currentState!.validate()) {
                                        showLog(
                                            "submit ${model.dropDownValue.value.name}");
                                        await model.getUnAuthUserCode(
                                            widget.eventCode);
                                      } else {
                                        await ToastUtil
                                            .showSnackBarAtCurrentState(
                                                "Please fill required field");
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
    return baseWidget!;
  }
}
