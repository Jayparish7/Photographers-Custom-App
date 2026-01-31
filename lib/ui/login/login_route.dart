import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/login_controller.dart';
import 'package:photomall_flutter/core/Utils/fade_animation.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as contry;
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/preference/redirection_route_constant.dart';
import 'package:photomall_flutter/traits/common_widgets/country_picker.dart';
import 'package:photomall_flutter/traits/common_widgets/custom_transition_widget.dart';
import 'package:photomall_flutter/ui/app_side_drawer/side_drawer_constants.dart';
import 'package:photomall_flutter/ui/base/base_widget.dart';
import 'package:photomall_flutter/ui/bottom_navigation/bottom_navigation_constants.dart';
import 'package:photomall_flutter/ui/drawer/side_drawer_model.dart';
import 'package:photomall_flutter/ui/login/login_route_model.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text_button.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:timezone_to_country/timezone_to_country.dart';
import 'package:toast/toast.dart';
import '../../core/Utils/TrueCaller/truecaller_utils.dart';
import '../../core/constants/route_constants.dart';
import '../../core/constants/shared_preference_constants.dart';
import '../../core/constants/studio_config_constants.dart';
import '../menu_button.dart';

class LoginRoute extends StatefulWidget {
  final bool? fromLoginPage;
  final bool? isRegister;
  final String referralPhoneNumber;

  LoginRoute(this.fromLoginPage,
      {Key? key, this.isRegister, this.referralPhoneNumber = ''})
      : super(key: key);

  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  String studioName = '';
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

 TrueCallerUtils trueCallerUtils = TrueCallerUtils();

  //var primaryColor;
  var accentColor;
  final emailOrMobileController = TextEditingController();
  final emailController = TextEditingController();
  final FocusNode emailOrMobileFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final RegExp _mobileRegEx = RegExp(r'(^(?:[+0]9)?[0-9]{10,11}$)');
  final RegExp _emailRegEx = RegExp(
      "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$");
  var source;
  String errorMessage = "";

  bool errorMessageVisibility = false;
  LoginController loginController = LoginController();

  var completePhoneNumber;
  List<String>? defaultCountry = [];
  List<String>? defaultCountryFromApi = [];
  final ValueNotifier<bool> isPhoneNumber = ValueNotifier<bool>(false);
  final ValueNotifier<contry.Country> dropDownValue =
      ValueNotifier<contry.Country>(
          contry.Country(id: 108, shortCode: "IN", name: "india", code: "+91"));

  @override
  void dispose() {
    trueCallerUtils.disposeTrueCaller();

    super.dispose();
  }

  @override
  void initState() {
    setDefaultCountries();

    fillTextField();
    if (widget.referralPhoneNumber != '') {
      emailOrMobileController.text = widget.referralPhoneNumber;
    }
    showLog('the phone number data where ${widget.isRegister}');
    emailOrMobileController.addListener(() {
      if (emailOrMobileController.text.isNotEmpty) {
        if (_isNumeric(emailOrMobileController.text) ||
            emailOrMobileController.text[0] == "+") {
          isPhoneNumber.value = true;
        } else {
          isPhoneNumber.value = false;
        }
        String _data = emailOrMobileController.text;
        if (_data.length >= 5 && _data[0] == "+") {
          dropDownValue.value =
              loginController.separatePhoneAndDialCode(_data)!.object!;
          showLog('the phone number data where ${dropDownValue.value.code}');
        }
      }
    });
    // getPhoneNumber();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        String? res = await getTrueCallerStatus();
        if (res == '1' || isPhotomallApp) {
          if (Platform.isAndroid) {
            try {
              showLog("On success call back happen $res");
              trueCallerUtils.execute(context, onLoginSuccess: () {
                showLog("On success call back happened");
                isLoading.value = true;
              });
            } catch (e) {
              showLog("trueCaller problem ::  ${e}");
            }
          }
        } else {
          showLog('true caller disabled');
        }
      },
    );
  }

  getTrueCallerStatus() async {
    String res = await PreferenceHelper.getString(trueCallerKey);
    showLog('res trueCaller in login $res');
    return res;
  }

  Widget errorMessageShow(String errorMessage) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 8, bottom: 2),
      child: CommonText(
        text: errorMessage,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }

  _setBusy(BuildContext context) {
    return Center(
      child: CommonCircularProgress(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buffer = StringBuffer();
    if (splashBackgroundColorCode.length == 6 ||
        splashBackgroundColorCode.length == 7) buffer.write('ff');
    buffer.write(splashBackgroundColorCode.replaceFirst('#', ''));
    return BaseWidget<LoginRouteModel>(
        model: LoginRouteModel(
            apiHandler: Provider.of<ApiHelper>(context, listen: false),
            context: context),
        onModelReady: (model) => model.getUserDetails(widget.isRegister),
        builder: (context, model, child) {
          return Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  emailOrMobileFocus.unfocus();
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: AppColorData.backgroundGradientBegin,
                          end: AppColorData.backgroundGradientEnd,
                          colors: AppColorData.backgroundColors,
                          stops: AppColorData.appBackgroundStops)),
                  child: Stack(
                    children: [
                      Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Center(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 30.0, horizontal: 10.0),
                              child: FadeAnimation(
                                delay: .8,
                                //child: SizedBox(
                                //  height: containerOrientation(),
                                child: Stack(
                                  children: [
                                    _setLoginForm(model),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              model.busy ? _setBusy(context) : SizedBox(),
              ValueListenableBuilder<bool>(
                  valueListenable: isLoading,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return value
                        ? AbsorbPointer(
                            absorbing: true,
                            // ignoring: true,
                            child: Container(
                                color: Colors.transparent,
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: CommonCircularProgress()),
                          )
                        : SizedBox();
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 55, left: 18.0, right: 25),
                child: Row(
                  children: [
                    (AppColorData.menuPosition != true)
                        ? SizedBox()
                        : MenuButton(),
                    UniqueText(
                      text: model.isRegisterView
                          ? S.of(context).register
                          : S.of(context).login,
                      letterSpacing: 2.5,
                    ),
                    Spacer(),
                    !isPhotomallApp
                        ? IconButton(
                            splashRadius: 18,
                            onPressed: () async {
                              await Navigator.pushNamed(
                                  context, RoutePaths.AddEvent);
                            },
                            icon: Icon(
                              Icons.qr_code_scanner,
                              size: 28,
                              color: AppColorData.appBarTextColor,
                            ),
                          )
                        : SizedBox(),
                    (AppColorData.menuPosition == true)
                        ? SizedBox()
                        : MenuButton(),
                  ],
                ),
              ),
            ],
          );
        });
  }

  bool _isNumeric(String str) {
    String source = str.trim();
    return double.tryParse(source) != null;
  }

  Widget _setLoginForm(LoginRouteModel model) {
    var width = MediaQuery.of(context).size.width * .3;
    final buffer = StringBuffer();
    if (splashBackgroundColorCode.length == 6 ||
        splashBackgroundColorCode.length == 7) buffer.write('ff');
    buffer.write(splashBackgroundColorCode.replaceFirst('#', ''));
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /*CircleAvatar(
              backgroundColor: Color(int.parse(buffer.toString(), radix: 16)),
              radius: 60,
              //MediaQuery.of(context).size.aspectRatio * 125,
              child: Image.asset('assets/images/splash_logo.png')
                  .animate(delay: Duration(microseconds: 500))
                  .fadeIn(delay: Duration(microseconds: 500))
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 3400.ms), // Replace with your image
            ),*/
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(int.parse(buffer.toString(), radix: 16)),
                      borderRadius: BorderRadius.circular(30)),
                  child: Image.asset(
                    'assets/images/splash_logo.png',
                    height: 100,
                    width: 100,
                  )
                      .animate(delay: Duration(microseconds: 500))
                      .fadeIn(delay: Duration(microseconds: 500))
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 3400.ms),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: AnimatedTextKit(
                    totalRepeatCount: 1,
                    animatedTexts: [
                      TyperAnimatedText(
                        speed: Durations.medium1,
                        appName,
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: AppColorData.appBarTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                letterSpacing: 2.5),
                      ),
                    ],
                    onTap: () {},
                  ),
                ),
              ],
            ),
            // welcome
            Padding(
              padding: const EdgeInsets.only(top: 25.0, left: 6),
              child: Visibility(
                //visible: widget.fromLoginPage == true ? false : true,
                visible: true,
                child: FadeAnimation(
                  delay: 1.4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[],
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<bool>(
                valueListenable: isPhoneNumber,
                builder: (BuildContext context, bool value, Widget? child) {
                  return Visibility(
                    visible: value,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 3,
                        top: 8,
                      ),
                      //padding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                      child: ValueListenableBuilder<contry.Country>(
                          valueListenable: dropDownValue,
                          builder: (BuildContext context,
                              contry.Country itemValue, Widget? child) {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  //shape: BoxShape.rectangle,
                                  border: Border(
                                    bottom: BorderSide(
                                        color: AppColorData.appBarTextColor,
                                        width: 1.5),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomCountryPicker(
                                  dropDownValue: itemValue.id!,
                                  onchangeDropDown: (int _id) {
                                    contry.Country? _value = loginController
                                        .getObjectByCountryId(_id);
                                    dropDownValue.value = contry.Country(
                                        id: _value!.id,
                                        code: _value.code,
                                        name: _value.name,
                                        shortCode: _value.shortCode);
                                    if (emailOrMobileController
                                        .text.isNotEmpty) {
                                      if (emailOrMobileController.text[0] ==
                                          "+") {
                                        contry.Country list = loginController
                                            .separatePhoneAndDialCode(
                                                emailOrMobileController.text)!
                                            .object!;

                                        String _countryCode = list.code!;
                                        emailOrMobileController.text =
                                            emailOrMobileController.text
                                                .replaceAll(
                                                    _countryCode, _value.code!);
                                      }
                                    }
                                    setState(() {
                                      try {
                                        onChangeValidation(
                                            emailOrMobileController.text);
                                      } catch (e) {
                                        showLog('onChangeValidation $e');
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          }),
                    ),
                  );
                }),

            ValueListenableBuilder<contry.Country>(
                valueListenable: dropDownValue,
                builder: (BuildContext context, contry.Country itemValue,
                    Widget? child) {
                  return Padding(
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
                            color: AppColorData.appBarTextColor.withOpacity(.2),
                            shape: BoxShape.rectangle,
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColorData.appBarTextColor,
                                    width: 1.5)
                                // Change the color according to your preference
                                // Change the width according to your preference
                                ),
                          ),
                          child: Consumer<LoginProvider>(builder: (
                            context,
                            model,
                            widget,
                          ) {
                            return TextField(
                              autofillHints: [
                                AutofillHints.telephoneNumber,
                              ],
                              contextMenuBuilder: (context, editableTextState) {
                                final List<ContextMenuButtonItem> buttonItems =
                                    editableTextState.contextMenuButtonItems;
                                buttonItems.removeWhere(
                                    (ContextMenuButtonItem buttonItem) {
                                  return buttonItem.type ==
                                      ContextMenuButtonType.cut;
                                });
                                return AdaptiveTextSelectionToolbar.buttonItems(
                                  anchors: editableTextState.contextMenuAnchors,
                                  buttonItems: buttonItems,
                                );
                              },
                              inputFormatters: [
                                //  if (denySpaces)
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              style: Theme.of(context).textTheme.titleMedium,
                              // const TextStyle(fontSize: TextProperty.p1),
                              autofocus: false,
                              cursorColor: AppColorData.textFormFieldCursor,
                              controller: emailOrMobileController,
                              focusNode: model.emailOrMobileFocus,
                              decoration: InputDecoration(
                                hintText: S.of(context).email_or_mobile_number,
                                labelStyle:
                                    Theme.of(context).textTheme.labelLarge,
                                //color: emailOrMobileFocus.hasFocus ? Colors.black87 : Colors.black87
                                /*suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: AppColorData
                                              .bgIconBackgroundColor,
                                          begin:
                                              AppColorData.bgIconGradientBegin,
                                          end: AppColorData.bgIconGradientEnd,
                                          stops: AppColorData.bgIconStops,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Icon(Icons.person,
                                            color: AppColorData.bgIconColor),
                                      )),
                                ),*/

                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  try {
                                    onChangeValidation(value);
                                  } catch (e) {
                                    showLog('onChangeValidation---> $e');
                                  }
                                });
                              },
                              onSubmitted: (value) {},
                            );
                          }),
                        ),
                      ),
                    ),
                  );
                }),

            ValueListenableBuilder<contry.Country>(
                valueListenable: dropDownValue,
                builder: (BuildContext context, contry.Country itemValue,
                    Widget? child) {
                  return Visibility(
                    visible: itemValue.id == 108,
                    child: Visibility(
                      visible: errorMessageVisibility,
                      child: errorMessageShow(errorMessage),
                    ),
                  );
                }),

            /* ValueListenableBuilder<contry.Country>(
                valueListenable: dropDownValue,
                builder: (BuildContext context, contry.Country itemValue,
                    Widget? child) {
                  return ValueListenableBuilder<bool>(
                      valueListenable: isPhoneNumber,
                      builder:
                          (BuildContext context, bool value, Widget? child) {
                        return Visibility(
                          visible: itemValue.code != "+91" && value,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 3,
                              top: 8,
                            ),
                            child: FadeAnimation(
                              delay: 1.6,
                              child: CustomItemTransition(
                                duration: itemTransitionDuration,
                                delay: itemTransitionDelay * 3,
                                child: Card(
                                  elevation:
                                      AppColorData.textFormFieldCardElevation,
                                  margin: AppColorData.textFormFieldCardMargin,
                                  //AppColorData.cardMargin ,
                                  shadowColor:
                                      AppColorData.textFormFieldCardShadow,
                                  color: AppColorData.textFormFieldCardBg,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Consumer<LoginProvider>(builder: (
                                    context,
                                    model,
                                    widget,
                                  ) {
                                    return TextField(
                                      toolbarOptions: ToolbarOptions(
                                          copy: true,
                                          cut: true,
                                          selectAll: true,
                                          paste: true),

                                      */
            /* inputFormatters: [
                                    //  if (denySpaces)
                                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                  ],*/
            /*
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      // const TextStyle(fontSize: TextProperty.p1),
                                      autofocus: false,
                                      cursorColor:
                                          AppColorData.textFormFieldCursor,
                                      controller: emailController,
                                      focusNode: model.email,
                                      decoration: InputDecoration(
                                        labelText: S.of(context).email_address,
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                        //color: emailOrMobileFocus.hasFocus ? Colors.black87 : Colors.black87
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: AppColorData
                                                      .bgIconBackgroundColor,
                                                  begin: AppColorData
                                                      .bgIconGradientBegin,
                                                  end: AppColorData
                                                      .bgIconGradientEnd,
                                                  stops:
                                                      AppColorData.bgIconStops,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Icon(Icons.person,
                                                    color: AppColorData
                                                        .bgIconColor),
                                              )),
                                        ),

                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                      ),

                                      onSubmitted: (value) {},
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }),*/

            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(width, 0, width, 0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: AppColorData.buttonBackgroundColors.last,
                    foregroundColor: AppColorData.buttonTextColors),
                child: model.isRegisterView
                    ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CommonText(text: '${S.of(context).register}'),
                    )
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CommonText(
                          text: '${S.of(context).send_otp}',
                          style: TextStyle(letterSpacing: 3),
                        ),
                    ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var emailOrMobile = emailOrMobileController.text;
                    if (emailOrMobile.isNotEmpty) {
                      if (emailOrMobileController.text[0] == "+") {
                        String? _phoneNumber = loginController
                            .separatePhoneAndDialCode(
                                emailOrMobileController.text)!
                            .phoneNumber;
                        if (_phoneNumber != null) {
                          emailOrMobileController.text = _phoneNumber;
                        }
                      }
                      //user enter mobile number, so login with mobile
                      if (_isNumeric(emailOrMobile)) {
                        //check number only entered
                        if (_mobileRegEx.hasMatch(emailOrMobile) ||
                            dropDownValue.value.code != '+91') {
                          isLoading.value = true;
                          showLog(
                              'login m2 $emailOrMobile ,,,${dropDownValue.value.code}');
                          (dropDownValue.value.code.toString()) == '+91'
                              ? await model.login(emailOrMobileController.text,
                                  countryCode: dropDownValue.value.id,
                                  code: dropDownValue.value.code)
                              : await model.firebaseLogin(context,
                                  emailOrMobile, dropDownValue.value.code);
                          isLoading.value = false;
                        } else {
                          showLog('login m3');
                          isLoading.value = true;
                          await model.login(emailController.text,
                              countryCode: dropDownValue.value.id,
                              code: dropDownValue.value.code);
                          isLoading.value = false;
                        }
                      } else if (_emailRegEx.hasMatch(emailOrMobile)) {
                        isLoading.value = true;
                        showLog('login m4');
                        await model.login(emailOrMobileController.text,
                            countryCode: dropDownValue.value.id,
                            code: dropDownValue.value.code);
                        isLoading.value = false;
                      }
                    } else {
                      if (dropDownValue.value.code != "+91") {
                        if (emailController.text.isEmpty) {
                          ToastUtil toastUtil = ToastUtil();
                          ToastContext().init(context);
                          toastUtil.showShortToast(
                              context, "please enter email");
                          return;
                        } else {
                          if (!_emailRegEx.hasMatch(emailController.text)) {
                            ToastUtil toastUtil = ToastUtil();
                            ToastContext().init(context);
                            toastUtil.showShortToast(
                                context, "please valid enter email address");
                            return;
                          } else {
                            showLog('login m5');
                            isLoading.value = true;
                            await model.login(emailController.text,
                                countryCode: dropDownValue.value.id,
                                code: dropDownValue.value.code);
                            isLoading.value = false;
                          }
                        }
                      }
                    }
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: FadeAnimation(
                delay: 1.7,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    model.isRegisterView
                        ? CommonText(
                            isCard: true,
                            isHighlightedCard: false,
                            text: S.of(context).alreadyHaveAnAccount,
                          )
                        : CommonText(
                            isCard: true,
                            isHighlightedCard: false,
                            text:
                                "${S.of(context).newTo} ${model.getStudioName}?",

                            //style: Theme.of(context).textTheme.headlineSmall.copyWith(color: Colors.black),
                          ),
                    CommonTextButton(
                      buttonText: model.isRegisterView
                          ? S
                              .of(context)
                              .login //S.of(context).already_have_an_account_login
                          : S.of(context).register,
                      onPressCall: () {
                        SideDrawerModel drawerChild =
                            Provider.of<SideDrawerModel>(context,
                                listen: false);
                        model.isRegisterView = !model.isRegisterView;

                        if (model.isRegisterView) {
                          drawerChild.setDrawerChild(
                              LoginRoute(false, isRegister: true),
                              S.of(context).register,
                              isPhotomallApp
                                  ? SideDrawerConstants.PhotomallLogin
                                  : SideDrawerConstants.GuestLogin,
                              isPhotomallApp
                                  ? SideDrawerConstants.PhotomallLogin
                                  : BottomNavigationConstants.GuestLogin,
                              refreshSamePage: true);
                        } else {
                          drawerChild.setDrawerChild(
                              LoginRoute(false, isRegister: false),
                              S.of(context).login,
                              isPhotomallApp
                                  ? SideDrawerConstants.PhotomallLogin
                                  : SideDrawerConstants.GuestRegister,
                              isPhotomallApp
                                  ? SideDrawerConstants.PhotomallLogin
                                  : BottomNavigationConstants.GuestRegister,
                              refreshSamePage: true);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            SignInButton(
              Buttons.google,
              text: "Sign in with Google",
              onPressed: () async {
                isLoading.value = true;
                ValueNotifier userCredential = ValueNotifier('');

                try {
                  userCredential.value = await signInWithGoogle(model);
                } catch (e) {
                  showLog('userCredential exception $e');
                  isLoading.value = false;
                }
                if (userCredential.value != null) {
                  showLog(
                      'signInWithGoogle ${userCredential.value.user!.email}');
                  await PreferenceHelper.setBool(signInWithGoogleKey, true);

                  try {
                    await model.setUserData(
                        context, userCredential.value.user!.email,
                        isFirebaseLogin: true);
                    getUserDetailsFromGoogle(model,
                        photoURL: userCredential.value.user!.photoURL,
                        displayName: userCredential.value.user!.displayName);
                  } catch (e) {
                    showLog('error in signInWithGoogle');
                    await ToastUtil.showLongToast(
                        context, 'Something went wrong');
                  }
                }
                isLoading.value = false;
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> signInWithGoogle(LoginRouteModel model) async {
    try {
      showLog('signInWithGoogle signInWithGoogle');

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      showLog('userCredential $googleUser');

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      showLog('userCredential $googleAuth');

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e, s) {
      isLoading.value = false;
      ToastUtil.showSnackBarAtCurrentState(S.of(context).something_went_wrong);
      showLog('exception->$e, .... $s');
    }
  }

  getUserDetailsFromGoogle(LoginRouteModel model,
      {String? photoURL = '', String? displayName = 'Guest User'}) async {
    if (photoURL != null) {
      showLog('getUserDetailsFromGoogle photoURL $photoURL ');
      await PreferenceHelper.setString(googleProfileUrlKey, photoURL);
    }
    if (displayName != null) {
      showLog('getUserDetailsFromGoogle displayName $displayName}');
      await model.apiRepo?.callChangeUserName(context, displayName);
    }
  }

  onChangeValidation(String value) {
    errorMessageVisibility = false;
    if (value.isEmpty) {
      setState(() {
        errorMessage = S.of(context).please_fill_this_field;
        errorMessageVisibility = true;
      });
      return null;
    } else {
      String data = value;
      if (value[0] == "+") {
        data.replaceAll('+', '');
      }
      if (value.isNotEmpty &&
          (_isNumeric(value) || (value[0] == "+" && _isNumeric(data)))) {
        if (value[0] != "+") {
          if (dropDownValue.value.code == '+91') {
            if (value.length != 10) {
              errorMessageVisibility = true;
            } else {
              errorMessageVisibility = false;
            }
          }
        }
        if (_isNumeric(value) &&
            value.length != 13 &&
            dropDownValue.value.code == '+91' &&
            value[0] == "+" &&
            value[1] == "9" &&
            value[2] == "1") {
          errorMessageVisibility = true;
        }
        if (_isNumeric(value) &&
            value.length == 13 &&
            dropDownValue.value.code == '+91' &&
            value[0] == "+" &&
            value[1] == "9" &&
            value[2] == "1") {
          showLog('india number is valid  ${dropDownValue.value.code}');
          errorMessageVisibility = false;
        }
        if (!_mobileRegEx.hasMatch(value) &&
            dropDownValue.value.code == '+91') {
          setState(() {
            errorMessage = S.of(context).please_enter_valid_mobile_number;
            errorMessageVisibility = true;
          });
          return null;
        }
      } else if (!_emailRegEx.hasMatch(value)) {
        setState(() {
          errorMessage = S.of(context).please_enter_valid_email_address;
          errorMessageVisibility = true;
        });
        return null;
      } else {
        setState(() {
          errorMessageVisibility = false;
        });
      }
      return null;
    }
  }

  Future<void> fillTextField() async {
    showLog('checking num 1 ..');
    String number =
        await PreferenceHelper.getString(RedirectionRouteConstant.loginNumber);
    if (number.isNotEmpty) {
      showLog('checking num 2 ..');

      setState(() {
        emailOrMobileController.text = number;
      });
    }
  }

  setDefaultCountries() async {
    String _countryCode = await TimeZoneToCountry.getLocalCountryCode();
    var res = loginController.getObjectByCountryCode(_countryCode);

    showLog('CountryCodes $_countryCode init ---${res?.code})}'); // Displays en
    showLog(" defaultCountry Id :${dropDownValue.value.name} ");

    defaultCountry = await PreferenceHelper.getStringList(countryKey) ??
        ['+91', 'India', 'In', '108'];
    dropDownValue.value.code = res?.code ?? defaultCountry![0];
    dropDownValue.value.name = res?.name ?? defaultCountry![1];
    dropDownValue.value.shortCode = res?.shortCode ?? defaultCountry![2];
    dropDownValue.value.id = res?.id ?? int.parse(defaultCountry!.last);
    showLog(" defaultCountry Id :${dropDownValue.value.name} ");
  }
}

class LoginProvider extends ChangeNotifier {
  final FocusNode emailOrMobileFocus = FocusNode();
  final FocusNode email = FocusNode();

  LoginProvider();

  Future<bool> unFocusLogin() async {
    showLog('the focus node where focused ${emailOrMobileFocus.hasFocus}');
    if (!emailOrMobileFocus.hasFocus) {
      return Future.delayed(Duration(milliseconds: 1), () {
        return true;
      });
    } else {
      emailOrMobileFocus.unfocus();

      notifyListeners();
      return Future.delayed(Duration(milliseconds: 200), () {
        showLog('emailOrMobileFocus where unfocused');
        return true;
      });
    }
  }
}
/*
const double _kCurveHeight = 300;

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Path();
    p.lineTo(0, size.height - _kCurveHeight);
    p.relativeQuadraticBezierTo(
        size.width / 1, .01 * _kCurveHeight, size.width, 0);
    p.lineTo(size.width, 0);
    p.close();

    canvas.drawPath(
        p, Paint()..color = AppColorData.appBarBackgroundColors.first);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}*/
// Platform messages are asynchronous, so we initialize in an async method.
