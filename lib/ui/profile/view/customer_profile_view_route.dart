import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/traits/image_processor.dart';
import 'package:photomall_flutter/ui/base/base_widget.dart';
import 'package:photomall_flutter/ui/popup/logout_dialog.dart';
import 'package:photomall_flutter/ui/profile/view/email_bottom_sheets_controller.dart';
import 'package:photomall_flutter/ui/profile/view/name_bottom_sheets_controller.dart';
import 'package:photomall_flutter/ui/profile/view/profile_photo_controller.dart';
import 'package:photomall_flutter/ui/profile/view/user_person_multiple_face_view.dart';
import 'package:photomall_flutter/ui/profile/view_model/customer_profile_view_route_model.dart';
import 'package:photomall_flutter/ui/routes/zoom_image_route.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_button.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:photomall_flutter/ui/themes/theme.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import '../../../traits/common_widgets/custom_transition_widget.dart';
import '../../shared_widgets/common_rounded_image_widget.dart';
import 'multiple_face_profile_view.dart';

class CustomerProfileViewRoute extends StatefulWidget {
  CustomerProfileViewRoute({
    Key? key,
  }) : super(key: key);

  @override
  CustomerProfileViewRouteState createState() =>
      CustomerProfileViewRouteState();
}

class CustomerProfileViewRouteState extends State<CustomerProfileViewRoute> {
  var isShowEditContainer = false;
  var _selectedFile;
  String? relationType;

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController relationTextEditingController = TextEditingController();

  BaseWidget<CustomerProfileViewRouteModel>? baseWidget;

  String emailAddress = '';
  late FaceCameraController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    baseWidget = BaseWidget<CustomerProfileViewRouteModel>(
      model: CustomerProfileViewRouteModel(
          apiHandler: Provider.of<ApiHelper>(context, listen: false),
          context: context),
      onModelReady: (model) {
        controller = FaceCameraController(
          autoCapture: false,
          imageResolution: ImageResolution.ultraHigh,
          defaultCameraLens: CameraLens.front,
          performanceMode: FaceDetectorMode.accurate,
          onCapture: (File? image) async {
            Navigator.pop(context);
            showLog('onModelReady');
            await _cropImage(image, model);
          },
        );
        return model.getUserDetails();
      },
      builder: (context, model, child) {
        return Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Material(
                    color: AppColorData.backgroundColors.first,
                    elevation: 3,
                    surfaceTintColor: Colors.transparent,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25)),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(bottom: BorderSide(width: 0.8)),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25))),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 55.0, top: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 55, left: 0.0, right: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    S.of(context).profile,
                                    style: TextStyle(
                                        color: AppColorData.appBarTextColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: profileWidget(context, model),
                            ),
                            (model.showRelatives &&
                                    model.userPersonsNotifier.value.length != 0)
                                ? Padding(
                                    padding: EdgeInsets.all(8),
                                    child: userPersonView(context, model),
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  AnimatedTextKit(
                    totalRepeatCount: 2,
                    animatedTexts: [
                      TyperAnimatedText(
                        '${S.of(context).about_me}',
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(
                                color: AppColorData.appBarTextColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 3),
                      ),
                    ],
                    onTap: () {},
                  ),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: listItems(model),
                  ))
                ],
              ),
            ));
      },
    );

    return baseWidget!;
  }

  Widget listItems(CustomerProfileViewRouteModel model) {
    return Skeletonizer(
      enabled: model.isLoading.value,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 8.5),
        width: CustomAppTheme.fullWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomItemTransition(
              duration: itemTransitionDuration,
              delay: itemTransitionDelay + 250,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColorData.appBarTextColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 10.0),
                    leading: SizedBox(
                      width: 36,
                      height: 36,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: AppColorData.bgIconBackgroundColor,
                              begin: AppColorData.bgIconGradientBegin,
                              end: AppColorData.bgIconGradientEnd,
                              stops: AppColorData.bgIconStops,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.phone,
                            color: AppColorData.bgIconColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    title: CommonText(
                        color: AppColorData.titleTextColor,
                        text: S.of(context).phone,
                        style: Theme.of(context).textTheme.titleMedium),
                    subtitle: CommonText(
                      color: AppColorData.normalTextColor,
                      text: model.userPhoneNumber,
                      fontWeight: FontWeight.normal,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
              ),
            ),
            //  Email menu
            CustomItemTransition(
              duration: itemTransitionDuration,
              delay: itemTransitionDelay + 500,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColorData.appBarTextColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.only(left: 10.0, right: 10),
                    leading: SizedBox(
                      width: 36,
                      height: 36,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: AppColorData.bgIconBackgroundColor,
                              begin: AppColorData.bgIconGradientBegin,
                              end: AppColorData.bgIconGradientEnd,
                              stops: AppColorData.bgIconStops,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.email,
                            color: AppColorData.bgIconColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    trailing: (model.userEmailAddress == '' ||
                            model.userEmailAddress.isEmpty)
                        ? ValueListenableBuilder(
                            valueListenable: model.isConnected,
                            builder: (context, value, child) {
                              return model.checkConnectivity(
                                  child: InkWell(
                                onTap: () {
                                  if (model.userEmailAddress.isNotEmpty) {
                                    if (!model.isDeleteEmailProcessing) {
                                      model.deleteEmail();
                                    }
                                  } else {
                                    EmailBottomSheet emailController =
                                        EmailBottomSheet();

                                    emailController
                                        .showBottomSheetForChangeEmailAddress(
                                            model,
                                            model.userEmailAddress.isNotEmpty
                                                ? model.userEmailAddress
                                                : '',
                                            "users",
                                            context);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors:
                                            AppColorData.bgIconBackgroundColor,
                                        begin: AppColorData.bgIconGradientBegin,
                                        end: AppColorData.bgIconGradientEnd,
                                        stops: AppColorData.bgIconStops,
                                      ),
                                      shape: BoxShape.circle),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: //model.isDeleteEmailProcessing

                                          Icon(
                                        Icons.add,
                                        color: AppColorData.bgIconColor,
                                        size: 20,
                                      )),
                                ),
                              ));
                            },
                          )
                        : // show only at unVerified users
                        model.emailStatus == 0
                            ? InkWell(
                                onTap: () {
                                  EmailBottomSheet emailController =
                                      EmailBottomSheet();

                                  emailController
                                      .showBottomSheetForChangeEmailAddress(
                                          model,
                                          model.userEmailAddress.isNotEmpty
                                              ? model.userEmailAddress
                                              : '',
                                          "users",
                                          context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors:
                                            AppColorData.bgIconBackgroundColor,
                                        begin: AppColorData.bgIconGradientBegin,
                                        end: AppColorData.bgIconGradientEnd,
                                        stops: AppColorData.bgIconStops,
                                      ),
                                      shape: BoxShape.circle),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: //model.isDeleteEmailProcessing

                                          Icon(
                                        Icons.edit,
                                        color: AppColorData.bgIconColor,
                                        size: 20,
                                      )),
                                ),
                              )
                            : SizedBox(),
                    title: CommonText(
                        color: AppColorData.titleTextColor,
                        text: S.of(context).email,
                        style: Theme.of(context).textTheme.titleMedium,
                        fontWeight: FontWeight.bold),
                    subtitle: isShowEditContainer == false
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (model.userEmailAddress != '' &&
                                      model.userEmailAddress.isNotEmpty)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                          color: AppColorData.normalTextColor,
                                          text: model.userEmailAddress,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                          //: S.of(context).add_your_email,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        /*  model.emailStatus == 0
                                            ? ValueListenableBuilder(
                                                valueListenable: model.isConnected,
                                                builder: (context, value, child) {
                                                  return model.checkConnectivity(
                                                      child: CommonTextButton(
                                                    buttonText: S.of(context).verify,
                                                    onPressCall: () async {
                                                      var response =
                                                          await model.resendOtp();
                                                      if (response.status!) {
                                                        EmailBottomSheet
                                                            emailBottomSheet =
                                                            EmailBottomSheet();
                                                        emailBottomSheet
                                                            .showBottomSheetForChangeEmailAddress(
                                                          model,
                                                          model.userEmailAddress,
                                                          'users',
                                                          context,
                                                          forVerifyEmail: true,
                                                          otpMessage: response.message,
                                                        );
                                                      } else {
                                                        ToastUtil.showLongToast(
                                                            context, response.message!);
                                                      }
                                                    },
                                                  ));
                                                },
                                              )
                                            : SizedBox()*/
                                      ],
                                    )
                                  : CommonText(
                                      color: AppColorData.normalTextColor,
                                      text: S.of(context).addYourEmail,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      //: S.of(context).add_your_email,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                              model.emailStatus != 1
                                  ? const SizedBox()
                                  : InkWell(
                                      onTap: () async {
                                        var response = await model.resendOtp();
                                        if (response.status!) {
                                          EmailBottomSheet emailBottomSheet =
                                              EmailBottomSheet();
                                          emailBottomSheet
                                              .showBottomSheetForChangeEmailAddress(
                                                  model,
                                                  model.userEmailAddress,
                                                  'users',
                                                  context,
                                                  forVerifyEmail: true,
                                                  otpMessage: response.message);
                                        } else {
                                          ToastUtil.showLongToast(
                                              context, response.message!);
                                        }
                                      },
                                      child: model.emailStatus == 0
                                          ? Column(
                                              children: [
                                                CommonText(
                                                  text: S.of(context).verify,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge!
                                                      .copyWith(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline),
                                                ),
                                              ],
                                            )
                                          : SizedBox(),
                                    ),
                            ],
                          )
                        : ConstrainedBox(
                            constraints:
                                BoxConstraints.tight(const Size(200, 45)),
                            child: TextFormField(
                              /*   cursorColor:
                                  AppColor.get(context, ColorKeys.primaryTextColor),
                              style: TextStyle(
                                  color: AppColor.get(
                                      context, ColorKeys.primaryTextColor)),*/
                              controller: emailTextEditingController,
                              onSaved: (String? value) {},
                            ),
                          ),
                  ),
                ),
              ),
            ),
            //  Archive event menu
            CustomItemTransition(
              duration: itemTransitionDuration,
              delay: itemTransitionDelay + 750,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColorData.appBarTextColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 10.0, right: 10),
                      subtitle: model.userDob.isNotEmpty
                          ? CommonText(
                              color: AppColorData.normalTextColor,
                              text: model.userDob,
                              //: S.of(context).add_your_name,
                              fontWeight: FontWeight.normal,
                              style: Theme.of(context).textTheme.titleMedium)
                          : CommonText(
                              color: AppColorData.normalTextColor,
                              text:
                                  'Add your Birthday', //S.of(context).notYetAdded,
                              style: Theme.of(context).textTheme.titleMedium,
                              //: S.of(context).add_your_name,

                              fontWeight: FontWeight.normal,
                            ),
                      leading: SizedBox(
                        width: 36,
                        height: 36,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: AppColorData.bgIconBackgroundColor,
                                begin: AppColorData.bgIconGradientBegin,
                                end: AppColorData.bgIconGradientEnd,
                                stops: AppColorData.bgIconStops,
                              ),
                              shape: BoxShape.circle),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.date_range_outlined,
                              color: AppColorData.bgIconColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      title: CommonText(
                        color: AppColorData.titleTextColor,
                        text: S.of(context).dob,
                        style: Theme.of(context).textTheme.titleMedium,
                        //: S.of(context).add_your_name,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      trailing: ValueListenableBuilder(
                        valueListenable: model.isConnected,
                        builder: (context, value, child) {
                          return model.checkConnectivity(
                            child: InkWell(
                              onTap: () {
                                picker.DatePicker.showDateTimePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime(1900, 1, 1),
                                    // Minimum selectable date (e.g., 1st Jan 1900)
                                    maxTime: DateTime.now(), onChanged: (date) {
                                  showLog('change $date');
                                }, onConfirm: (date) async {
                                  showLog(
                                      'confirm ${date.hour},${date.minute}}');

                                  String dateString =
                                      date.toString().split(' ')[0];
                                  List<String> parts = dateString.split(
                                      '-'); // Split the date string into parts
                                  String formattedDate =
                                      "${parts[2]}-${parts[1]}-${parts[0]}";
                                  String formattedDateForApi =
                                      "${parts[0]}-${parts[1]}-${parts[2]}";
                                  setState(() {
                                    model.userDob = formattedDate;
                                    DateTime dob = DateFormat("dd-MM-yyyy")
                                        .parse(model.userDob);
                                    model.userAge = model.calculateAgeAtDate(
                                        dob, DateTime.now());
                                  });
                                  await model.updateDobApiCall(
                                      formattedDateForApi.toString(),
                                      date.hour,
                                      date.minute);
                                },
                                    currentTime: DateTime.now(),
                                    locale: picker.LocaleType.en);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors:
                                          AppColorData.bgIconBackgroundColor,
                                      begin: AppColorData.bgIconGradientBegin,
                                      end: AppColorData.bgIconGradientEnd,
                                      stops: AppColorData.bgIconStops,
                                    ),
                                    shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    model.userDob.isNotEmpty
                                        ? Icons.edit
                                        : Icons.add,
                                    color: AppColorData.bgIconColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                ),
              ),
            ),
            CustomItemTransition(
              duration: itemTransitionDuration,
              delay: itemTransitionDelay + 1000,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColorData.appBarTextColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15)),
                  child: Visibility(
                    visible: (model.userDob != '' && model.userAge >= 18),
                    child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 10.0),
                        subtitle: model.maritalStatus.isNotEmpty
                            ? CommonText(
                                color: AppColorData.normalTextColor,
                                text: (model.maritalStatus == "1")
                                    ? "${S.of(context).married_on} ${model.anniversary}"
                                    : S.of(context).unmarried,
                                //: S.of(context).add_your_name,
                                fontWeight: FontWeight.normal,
                                style: Theme.of(context).textTheme.titleMedium,
                              )
                            : CommonText(
                                color: AppColorData.normalTextColor,
                                text: S.of(context).are_you_married,
                                style: Theme.of(context).textTheme.titleMedium,
                                //: S.of(context).add_your_name,

                                fontWeight: FontWeight.normal,
                              ),
                        leading: SizedBox(
                          width: 36,
                          height: 36,
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: AppColorData.bgIconBackgroundColor,
                                  begin: AppColorData.bgIconGradientBegin,
                                  end: AppColorData.bgIconGradientEnd,
                                  stops: AppColorData.bgIconStops,
                                ),
                                shape: BoxShape.circle),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/wedding.png',
                                  color: AppColorData.bgIconColor,
                                )),
                          ),
                        ),
                        title: CommonText(
                          color: AppColorData.titleTextColor,
                          text: S.of(context).marital_status,
                          style: Theme.of(context).textTheme.titleMedium,
                          //: S.of(context).add_your_name,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        trailing: model.checkConnectivity(
                            child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    // Adjusts height to content
                                    children: [
                                      CommonText(
                                        text:
                                            S.of(context).select_marital_status,
                                      ),
                                      SizedBox(height: 20),
                                      ListTile(
                                        title: CommonText(
                                          text: S.of(context).married,
                                        ),
                                        onTap: () {
                                          showLog(
                                              'Anniversary ${model.maritalStatus}');
                                          Navigator.pop(
                                              context); // Close the bottom sheet after date is selected

                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                height: 150,
                                                // Adjust height based on content
                                                child: Center(
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: CommonText(
                                                          text: S
                                                              .of(context)
                                                              .enter_anni_date,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: ListTile(
                                                            title: CommonText(
                                                              text: S
                                                                  .of(context)
                                                                  .anni_date,
                                                              isButton: true,
                                                            ),
                                                            trailing: Icon(
                                                                Icons.edit),
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context); // Close the bottom sheet after date is selected

                                                              picker.DatePicker
                                                                  .showDateTimePicker(
                                                                context,
                                                                showTitleActions:
                                                                    true,
                                                                minTime:
                                                                    DateTime(
                                                                        1900,
                                                                        1,
                                                                        1),
                                                                maxTime:
                                                                    DateTime
                                                                        .now(),
                                                                onChanged:
                                                                    (date) {
                                                                  showLog(
                                                                      'change $date');
                                                                },
                                                                onConfirm:
                                                                    (date) async {
                                                                  String? res;
                                                                  if (model
                                                                          .userDob !=
                                                                      '') {
                                                                    res = model.validateMaritalStatus(
                                                                        model
                                                                            .userDob,
                                                                        date.toString());
                                                                  } else {
                                                                    res = null;
                                                                  }
                                                                  showLog(
                                                                      'change we deed --- $res');
                                                                  if (res ==
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      model.maritalStatus =
                                                                          '1';
                                                                    });
                                                                    showLog(
                                                                        'confirm $date');

                                                                    String dateString = date
                                                                        .toString()
                                                                        .split(
                                                                            ' ')[0];
                                                                    List<String>
                                                                        parts =
                                                                        dateString
                                                                            .split('-');
                                                                    String
                                                                        formattedDate =
                                                                        "${parts[2]}-${parts[1]}-${parts[0]}";
                                                                    String
                                                                        formattedDateForApi =
                                                                        "${parts[0]}-${parts[1]}-${parts[2]}";
                                                                    setState(
                                                                        () {
                                                                      model.anniversary =
                                                                          formattedDate;
                                                                    });
                                                                    await model.updateMaritalStatusApiCall(
                                                                        '1',
                                                                        formattedDateForApi
                                                                            .toString(),
                                                                        date.hour,
                                                                        date.minute);
                                                                  } else {}
                                                                },
                                                                currentTime:
                                                                    DateTime
                                                                        .now(),
                                                                locale: picker
                                                                    .LocaleType
                                                                    .en,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      ListTile(
                                        title: CommonText(
                                            text: S.of(context).unmarried),
                                        onTap: () async {
                                          setState(() {
                                            model.maritalStatus = '2';
                                          });
                                          Navigator.pop(context);

                                          await model
                                              .updateMaritalStatusApiCall(
                                                  '2', '', 0, 0);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: AppColorData.bgIconBackgroundColor,
                                    begin: AppColorData.bgIconGradientBegin,
                                    end: AppColorData.bgIconGradientEnd,
                                    stops: AppColorData.bgIconStops,
                                  ),
                                  shape: BoxShape.circle),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  model.maritalStatus.isNotEmpty
                                      ? Icons.edit
                                      : Icons.add,
                                  color: AppColorData.bgIconColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ))),
                  ),
                ),
              ),
            ),
            // Logout menu
            /*  CustomItemTransition(
              duration: itemTransitionDuration,
              delay: itemTransitionDelay + 1250,
              child: InkWell(
                onTap: () async {
                  showLogoutDialog(context);
                },
                child: Column(

                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 10.0),
                      leading: Container(
                        width: 36,
                        height: 36,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: AppColorData.bgIconBackgroundColor,
                                begin: AppColorData.bgIconGradientBegin,
                                end: AppColorData.bgIconGradientEnd,
                                stops: AppColorData.bgIconStops,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.exit_to_app,
                              color: AppColorData.bgIconColor,
                            ),
                          ),
                        ),
                      ),
                      title: CommonText(
                        text: S.of(context).logout,
                        color: AppColorData.titleTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),*/
            // Logout menu
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.3,
              ),
              child: CustomItemTransition(
                duration: itemTransitionDuration,
                delay: itemTransitionDelay + 1250,
                child: IconButton(
                    onPressed: () {
                      showLogoutDialog(context);
                    },
                    icon: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: AppColorData.bgIconBackgroundColor,
                                  begin: AppColorData.bgIconGradientBegin,
                                  end: AppColorData.bgIconGradientEnd,
                                  stops: AppColorData.bgIconStops,
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.exit_to_app,
                                color: AppColorData.bgIconColor,
                              ),
                            ),
                          ),
                        ),
                        CommonText(
                          text: S.of(context).logout,
                          color: AppColorData.titleTextColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  showLogoutDialog(BuildContext context) async {
    /* Widget _logoutDialog = logoutDialog(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => _logoutDialog);*/
    logoutDialog(context);
  }

  Widget setImage(List<File> downloadedImageFile) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height / 2.5,
          width: MediaQuery.of(context).size.width,
          child: Container(
            width: 130.0,
            height: 130.0,
            decoration: new BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height / 2.5,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    TutorialOverlay(downloadedImageFile.isNotEmpty
                        ? downloadedImageFile[0]
                        : 1),
                  );
                },
                child: downloadedImageFile.isNotEmpty
                    ? Container(
                        width: 125.0,
                        height: 125.0,
                        decoration: new BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: FileImage(downloadedImageFile[0]),
                          ),
                        ),
                      )
                    : Container(
                        child: Image.asset("assets/images/user_profile.png"),
                        width: 125.0,
                        height: 125.0,
                        decoration: new BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(),
              )
            ],
          ),
        ),
      ],
    );
  }

  userPersonView(BuildContext context, CustomerProfileViewRouteModel model) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: model
                .userPersonsNotifier.value.length, //Number of items in the list
            itemBuilder: (context, index) {
              final int dynamicDelay = itemTransitionDelay + (index * 300);

              // This function is called for each item in the list
              return CustomItemTransition(
                duration: itemTransitionDuration,
                delay: dynamicDelay,
                child: Container(
                  height: 150,
                  width: 150,
                  child: Stack(
                    children: <Widget>[
                      /*CommonCard(
                        shape: BorderRadius.circular(100.0),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.only(top: 16.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0)),
                        ),
                      ),*/
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Center(
                          child: Container(
                            height: 130,
                            width: 130,
                            child: Stack(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: _userPersonImageView(
                                      model,
                                      model.userPersonsNotifier.value[index]
                                          .jvtFile?.name),
                                ),
                                Positioned(

                                    //top: 0,
                                    bottom: -10,
                                    right: 5,
                                    child: ValueListenableBuilder(
                                      valueListenable: model.isConnected,
                                      builder: (context, value, child) {
                                        return model.checkConnectivity(
                                            child: InkWell(
                                          onTap: () {
                                            ProfilePhotoController
                                                profilePicController =
                                                ProfilePhotoController();
                                            (model
                                                        .userPersonsNotifier
                                                        .value[index]
                                                        .jvtFile
                                                        ?.code ==
                                                    null)
                                                ? profilePicController
                                                    .showBottomSheetForProfileImage(
                                                    context,
                                                    model,
                                                    (ImageSource source,
                                                        CustomerProfileViewRouteModel
                                                            model) async {
                                                      await getImageForUserPerson(
                                                          source, model,
                                                          code: model
                                                              .userPersonsCode
                                                              .value[index]
                                                              .code);
                                                      setState(() {});
                                                    },
                                                  )
                                                : Navigator.of(context)
                                                    .push(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          UserPersonMultipleFaceProfileView(
                                                        publicStoragePath: model
                                                            .publicStoragePath,
                                                        profileJvtFile: model
                                                            .profileJvtFile,
                                                        usercode:
                                                            model.usercode,
                                                        userPersonCode: model
                                                            .userPersonsCode
                                                            .value[index]
                                                            .code,
                                                        appbarTitle: model
                                                            .userPersonsCode
                                                            .value[index]
                                                            .name,
                                                      ),
                                                    ),
                                                  )
                                                    .then((val) async {
                                                    if (val == true) {
                                                      showLog(
                                                          'MultipleFaceProfileView pop');
                                                      await model
                                                          .getUserDetails(); // This function will be called if 'PageTwo' returns true.
                                                    }
                                                  });
                                          },
                                          child: Opacity(
                                            opacity: 0.70,
                                            child: Container(
                                              width: 45.0,
                                              height: 45.0,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  gradient: LinearGradient(
                                                    colors: AppColorData
                                                        .bgIconBackgroundColor,
                                                    begin: AppColorData
                                                        .bgIconGradientBegin,
                                                    end: AppColorData
                                                        .bgIconGradientEnd,
                                                    stops: AppColorData
                                                        .bgIconStops,
                                                  )),
                                              alignment: Alignment.center,
                                              child: Icon(
                                                (model.profileJvtFile !=
                                                            null) ||
                                                        _selectedFile != null
                                                    ? Icons.edit
                                                    : Icons.camera_alt,
                                                color: AppColorData.bgIconColor,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                        ));
                                      },
                                    )),
                                Positioned(

                                    //top: 0,
                                    bottom: -10,
                                    right: 60,
                                    child: ValueListenableBuilder(
                                      valueListenable: model.isConnected,
                                      builder: (context, value, child) {
                                        return model.checkConnectivity(
                                            child: TapDebouncer(
                                                onTap: () async {
                                          showLog('TapDebouncer');

                                          await model.deleteUserPersons(
                                              userPersonCode: model
                                                  .userPersonsCode
                                                  .value[index]
                                                  .code);
                                        }, builder: (BuildContext context,
                                                    TapDebouncerFunc? onTap) {
                                          return InkWell(
                                            onTap: onTap,
                                            child: Opacity(
                                              opacity: 0.70,
                                              child: Container(
                                                width: 45.0,
                                                height: 45.0,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    gradient: LinearGradient(
                                                      colors: AppColorData
                                                          .bgIconBackgroundColor,
                                                      begin: AppColorData
                                                          .bgIconGradientBegin,
                                                      end: AppColorData
                                                          .bgIconGradientEnd,
                                                      stops: AppColorData
                                                          .bgIconStops,
                                                    )),
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.delete,
                                                  color:
                                                      AppColorData.bgIconColor,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                          );
                                        }));
                                      },
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _userPersonImageView(
      CustomerProfileViewRouteModel model, String? userPerson) {
    String? url = '';
    if (userPerson != null && userPerson != '') {
      url = '${model.publicStoragePath}/${userPerson}';
    }
    showLog('_userPersonView $url');
    var emptyProfileWidget = Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: Lottie.asset(
        repeat: false,
        'assets/animations/profile.json',
      )),
    );
    //return emptyProfileWidget;
    if (1 == 2) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(_selectedFile),
      );
    } else if (url != '') {
      return Image.network('$url', errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return const Text('ð¢');
      });
    } else {
      return emptyProfileWidget;
    }
  }

  profileWidget(BuildContext context, CustomerProfileViewRouteModel model) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 150,
            child: Container(
              height: 150,
              width: 150,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.only(top: 16.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        height: 150,
                        width: 150,
                        child: Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: _profileImageView(model),
                            ),
                            Positioned(

                                //top: 0,
                                bottom: 0,
                                right: 45,
                                child: ValueListenableBuilder(
                                  valueListenable: model.isConnected,
                                  builder: (context, value, child) {
                                    return model.checkConnectivity(
                                        child: InkWell(
                                      onTap: () async {
                                        (model.profileJvtFile?.name == null)
                                        //true
                                            ? await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Material(
                                                    child: SmartFaceCamera(
                                                      indicatorShape:
                                                          IndicatorShape.square,
                                                      showCameraLensControl:
                                                          false,
                                                      showFlashControl: false,
                                                      autoDisableCaptureControl:
                                                          true,
                                                      controller: controller,
                                                      messageBuilder:
                                                          (context, face) {
                                                        if (face == null) {
                                                          return _message(
                                                              'Place your face in the camera');
                                                        }
                                                        if (!face
                                                            .wellPositioned) {
                                                          return _message(
                                                              'Place your face at the center of the face indicator.');
                                                        }
                                                        return const SizedBox
                                                            .shrink();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Navigator.of(context)
                                                .push(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      MultipleFaceProfileView(
                                                    publicStoragePath:
                                                        model.publicStoragePath,
                                                    profileJvtFile:
                                                        model.profileJvtFile,
                                                    usercode: model.usercode,
                                                  ),
                                                ),
                                              )
                                                .then((val) async {
                                                if (val == true) {
                                                  showLog(
                                                      'MultipleFaceProfileView pop');
                                                  await model
                                                      .getUserDetails(); // This function will be called if 'PageTwo' returns true.
                                                }
                                              });
                                      },
                                      child: Opacity(
                                        opacity: 0.70,
                                        child: Container(
                                          width: 45.0,
                                          height: 45.0,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              gradient: LinearGradient(
                                                colors: AppColorData
                                                    .bgIconBackgroundColor,
                                                begin: AppColorData
                                                    .bgIconGradientBegin,
                                                end: AppColorData
                                                    .bgIconGradientEnd,
                                                stops: AppColorData.bgIconStops,
                                              )),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            (model.profileJvtFile != null) ||
                                                    _selectedFile != null
                                                ? Icons.edit
                                                : Icons.camera_alt,
                                            color: AppColorData.bgIconColor,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                    ));
                                  },
                                )),
                            /* (model.addUserPersons)
                                ? Positioned(
                                    bottom: 25,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () async {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16.0),
                                            ),
                                          ),
                                          builder: (BuildContext context) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom,
                                                left: 16.0,
                                                right: 16.0,
                                                top: 16.0,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('Add Person',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge
                                                          ?.copyWith(
                                                              letterSpacing: 2,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                  SizedBox(height: 16.0),
                                                  DropdownSearch<String>(
                                                    onChanged: (value) async {
                                                      if (value != null) {
                                                        showLog(
                                                            "the new format $value");
                                                        relationType = value;
                                                      }
                                                    },
                                                    selectedItem: relationType,
                                                    items: model.dropdownItems,
                                                    dropdownDecoratorProps:
                                                        const DropDownDecoratorProps(
                                                      dropdownSearchDecoration:
                                                          InputDecoration(
                                                        focusColor:
                                                            Colors.transparent,
                                                        fillColor:
                                                            Colors.transparent,
                                                        labelText: "Relation",
                                                        hintText:
                                                            "Select a Relationship",
                                                        filled: true,
                                                      ),
                                                    ),
                                                    popupProps:
                                                        const PopupPropsMultiSelection
                                                            .menu(
                                                      fit: FlexFit.tight,
                                                    ),
                                                  ),
                                                  SizedBox(height: 16.0),
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                        labelText: 'Name'),
                                                    controller:
                                                        relationTextEditingController,
                                                  ),
                                                  SizedBox(height: 16.0),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      CommonButton(
                                                        isOutLinedButton: true,
                                                        buttonText: S
                                                            .of(context)
                                                            .cancel,
                                                        onPressCall: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      SizedBox(width: 8.0),
                                                      CommonButton(
                                                        buttonText: '  Add  ',
                                                        onPressCall: () async {
                                                          await model
                                                              .userPersonsStoreApiCall(
                                                            name:
                                                                relationTextEditingController
                                                                    .text,
                                                            relationType:
                                                                '$relationType',
                                                          );
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Opacity(
                                        opacity: 0.70,
                                        child: Container(
                                          width: 40.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              gradient: LinearGradient(
                                                colors: AppColorData
                                                    .bgIconBackgroundColor,
                                                begin: AppColorData
                                                    .bgIconGradientBegin,
                                                end: AppColorData
                                                    .bgIconGradientEnd,
                                                stops: AppColorData.bgIconStops,
                                              )),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.person_add,
                                            color: AppColorData.bgIconColor,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ))
                                : SizedBox()*/
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    model.userName.isNotEmpty
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * .45,
                            child: AnimatedTextKit(
                              totalRepeatCount: 2,
                              displayFullTextOnTap: true,
                              animatedTexts: [
                                TyperAnimatedText(
                                  textAlign: TextAlign.justify,
                                  model.userName,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          color: AppColorData.appBarTextColor,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 2,
                                          overflow: TextOverflow.visible),
                                ),
                              ],
                              onTap: () {},
                            ),
                          )
                        : CommonText(
                            color: AppColorData.normalTextColor,
                            text: S
                                .of(context)
                                .addYourName, //S.of(context).notYetAdded,
                            style: Theme.of(context).textTheme.titleMedium,
                            //: S.of(context).add_your_name,

                            fontWeight: FontWeight.normal,
                          ),
                    ValueListenableBuilder(
                      valueListenable: model.isConnected,
                      builder: (context, value, child) {
                        return model.checkConnectivity(
                          child: InkWell(
                            onTap: () {
                              NameBottomSheetsController nameChangeController =
                                  NameBottomSheetsController();
                              nameChangeController.showBottomSheetForChangeName(
                                  model, model.userName, context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: AppColorData.bgIconBackgroundColor,
                                    begin: AppColorData.bgIconGradientBegin,
                                    end: AppColorData.bgIconGradientEnd,
                                    stops: AppColorData.bgIconStops,
                                  ),
                                  shape: BoxShape.circle),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  model.userName.isNotEmpty
                                      ? Icons.edit
                                      : Icons.add,
                                  color: AppColorData.bgIconColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                /*(model.userPersonsNotifier.value.length != 0)
                    ? IconButton(
                        padding: EdgeInsets.all(0),
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          showLog('Relatives Button');
                          model.relativesOnTap();
                        },
                        icon: Row(
                          children: [
                            Icon(
                              FontAwesome.users_solid,
                              size: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CommonText(
                              color: AppColorData.titleTextColor,
                              text: '${S.of(context).relatives}',
                              style: Theme.of(context).textTheme.titleMedium,
                              //: S.of(context).add_your_name,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              model.showRelatives
                                  ? Icons.arrow_drop_up_outlined
                                  : Icons.arrow_drop_down_outlined,
                              size: 25,
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),*/
              ])
        ],
      ),
    );
  }

  Widget _message(String msg) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 55),
        child: Text(msg,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w400,
            )),
      );

  _profileImageView(CustomerProfileViewRouteModel model) {
    ImageProcessor imageProcessor = ImageProcessor();
    var emptyProfileWidget = Container(
      decoration: BoxDecoration(
          // color: AppColor.get(context, ColorKeys.darkDividerColor)
          //     .withOpacity(0.18),
          //color: lightIconBackgroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: Lottie.asset(
        repeat: false,
        'assets/animations/profile.json',
        fit: BoxFit.fitHeight,
      )),
    );
    //return emptyProfileWidget;
    if (_selectedFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(_selectedFile),
      );
    } else if (model.profileUrl != '' && model.profileJvtFile == null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(model.profileUrl));
    } else if (model.profileJvtFile != null) {
      showLog(
          'model.profileJvtFile ${model.profileJvtFile!.name} ${model.publicStoragePath}');
      String image = "${model.publicStoragePath}/${model.profileJvtFile!.name}";
      return CommonRoundedImageWidget(
        size: Size(150, 150),
        image: image,
      );
    } else {
      return emptyProfileWidget;
    }
  }

  Size contentSize = const Size(0, 0);

  @override
  void dispose() {
    showLog('dispose :: ');
    if (baseWidget != null && baseWidget?.model != null) {
      baseWidget!.model.destroy();
    }
    super.dispose();
    controller.dispose();
  }

  Future getImage(
      ImageSource source, CustomerProfileViewRouteModel model) async {
    PickedFile? image = await ImagePicker.platform.pickImage(source: source);
    _cropImage(image, model);
  }

  _cropImage(image, CustomerProfileViewRouteModel model) async {
    CroppedFile? croppedFile;
    if (image != null) {
      try {
        croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          compressQuality: 100,
          maxHeight: 512,
          maxWidth: 512,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: S.of(context).setProfilePicture,
                //   toolbarColor: AppColor.get(context, ColorKeys.darkThemeColor),
                // toolbarWidgetColor:
                //     AppColor.get(context, ColorKeys.lightThemeColor),
                initAspectRatio: CropAspectRatioPreset.ratio16x9,
                aspectRatioPresets: [
                  CropAspectRatioPreset.square,
                ],
                lockAspectRatio: true),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
              ],
            )
          ],
        );
      } catch (e) {}
      var base64Image;
      try {
        base64Image = base64Encode(await croppedFile!.readAsBytes());
      } catch (e) {}

      if (croppedFile != null) {
        setState(() {
          _selectedFile = File(croppedFile!.path);
        });
        model.changeProfileImage(base64Image);
      }
    }
  }

  Future getImageForUserPerson(
      ImageSource source, CustomerProfileViewRouteModel model,
      {String? code = ''}) async {
    PickedFile? image = await ImagePicker.platform.pickImage(source: source);
    _cropImageForUserPerson(image, model, code);
  }

  _cropImageForUserPerson(
      image, CustomerProfileViewRouteModel model, String? code) async {
    CroppedFile? croppedFile;

    if (image != null) {
      try {
        croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          compressQuality: 100,
          maxHeight: 512,
          maxWidth: 512,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: S.of(context).setProfilePicture,
                //   toolbarColor: AppColor.get(context, ColorKeys.darkThemeColor),
                // toolbarWidgetColor:
                //     AppColor.get(context, ColorKeys.lightThemeColor),
                initAspectRatio: CropAspectRatioPreset.ratio16x9,
                aspectRatioPresets: [
                  CropAspectRatioPreset.square,
                ],
                lockAspectRatio: true),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
              ],
            )
          ],
        );
      } catch (e) {}
      var base64Image;
      try {
        base64Image = base64Encode(await croppedFile!.readAsBytes());
      } catch (e) {}

      if (croppedFile != null) {
        setState(() {
          //_selectedFile = File(croppedFile!.path);
        });
        model.changeUserPersonsProfileImage(
            base64Image, File(croppedFile.path), code ?? '');
      }
    }
  }

  changeState(bool value) {
    setState(() {
      isShowEditContainer = value;
    });
  }
}
