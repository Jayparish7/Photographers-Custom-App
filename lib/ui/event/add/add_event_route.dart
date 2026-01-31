import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/Utils/clipper/curved_line.dart';
import 'package:photomall_flutter/core/Utils/fade_animation.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as appConf;
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/traits/bar_code_scanner.dart';
import 'package:photomall_flutter/traits/common_widgets/common_card.dart';
import 'package:photomall_flutter/ui/base/base_widget.dart';
import 'package:photomall_flutter/ui/event/add/add_event_route_model.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_appbar.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_outlinedButton.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text_button.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

bool isLoggedIn = false;

class AddEvent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddEventState();
}

class AddEventState extends State<AddEvent> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  var eventKeyController = TextEditingController();
  String qrCodeResult = "";
  String errorMessage = "";
  bool errorMessageVisibility = false;

  ValueNotifier<bool> submitNotifier = ValueNotifier(false);

/*  final GlobalKey addEventKey1 = GlobalKey();
  final GlobalKey addEventKey2 = GlobalKey();
  final GlobalKey addEventKey3 = GlobalKey();
  final GlobalKey addEventKey4 = GlobalKey();*/

  @override
  void initState() {
    super.initState();

    // showLog(S.of(context).name);
    userLoggedInOrNot();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {},
    );
  }

  userLoggedInOrNot() async {
    //var prefs = await SharedPreferences.getInstance();
    /* setState(() {
      isLoggedIn =
          (prefs.getBool(SharedPreferenceConst.IS_USER_LOGIN) ?? false);
    });*/
  }

  Widget errorMessageShow(String errorMessage) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 32, top: 2, bottom: 4),
          child: CommonText(
              text: errorMessage,
              style: Theme.of(context).textTheme.labelMedium),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<AddEventRouteViewModel>(
        model: AddEventRouteViewModel(
            apiHandler: Provider.of<ApiHelper>(context, listen: false),
            context: context),
        onModelReady: (model) => model.getDemoEventDetails(),
        builder: (context, model, child) {
          return Stack(
            children: <Widget>[
              IgnorePointer(
                  ignoring: model.busy,
                  child: _setAddEventContent(context, model)),
              model.busy ? _setBusy(context) : SizedBox()
            ],
          );
        });
  }

  _setBusy(BuildContext context) {
    return Center(
      child: CommonCircularProgress(),
    );
  }

  setQRCodeClickHint() {
    return FadeAnimation(
      delay: 1.5,
      child: Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 20),
        child: CommonText(
          text: S.of(context).click_down_and_scan_qr_coden_to_view_event,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }

  _setAddEventContent(BuildContext context, AddEventRouteViewModel model) {
    final ValueNotifier<String> scannedValue = ValueNotifier<String>('');
    final ValueNotifier<bool> showQRWidget = ValueNotifier<bool>(false);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: AppColorData.backgroundGradientBegin,
              end: AppColorData.backgroundGradientEnd,
              colors: AppColorData.backgroundColors,
              stops: AppColorData.appBackgroundStops)),
      child: SafeArea(
        child: Scaffold(
          appBar: CommonAppBar(
            title: '     ${S.of(context).addEvent}',
          ),
          backgroundColor: Colors.transparent,
          key: key,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 75,
                ),
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                ValueListenableBuilder<bool>(
                                    valueListenable: showQRWidget,
                                    builder: (BuildContext context,
                                        bool value, Widget? child) {
                                      return _setPadding(
                                        context,
                                        value
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 8.0,
                                                        right: 8.0),
                                                child: Row(
                                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Expanded(
                                                      child: CommonText(
                                                        text: S
                                                            .of(context)
                                                            .scanQrCode,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .titleLarge,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : CommonOutlinedButton(icon: Icons.close,
                                                text:
                                                    S.of(context).closeCamera,
                                                onPressCall: () {
                                                  showQRWidget.value = !value;
                                                },
                                              ),
                                      );
                                    }),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ValueListenableBuilder<bool>(
                                      valueListenable: showQRWidget,
                                      builder: (BuildContext context,
                                          bool value, Widget? child) {
                                        return !value
                                            ? Visibility(
                                                visible: !showQRWidget.value,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height /
                                                          2.1,
                                                      child:
                                                          BarcodeScannerWithController(
                                                        scannedValue:
                                                            (value) async {
                                                          List<String>
                                                              splitUrl = value
                                                                  .split('/');

                                                          if (isPhotomallApp) {
                                                            String?
                                                                eventCode =
                                                                splitUrl.last;
                                                            if (eventCode !=
                                                                    '' &&
                                                                eventCode
                                                                    .isNotEmpty &&
                                                                eventCode
                                                                        .length ==
                                                                    5) {
                                                              model.getAddEventDetails(
                                                                  eventCode);
                                                            } else {
                                                              invalidEvent();
                                                            }
                                                          } else {
                                                            TransporterPreference
                                                                appConfig =
                                                                TransporterPreference();
                                                            appConf
                                                                .TransportModel?
                                                                studioDetails =
                                                                await appConfig
                                                                    .getAppConfig();

                                                            if (studioDetails!
                                                                        .studioData!
                                                                        .data!
                                                                        .shortUrl ==
                                                                    splitUrl[
                                                                        3] &&
                                                                splitUrl[4]
                                                                    .isNotEmpty &&
                                                                splitUrl[4]
                                                                        .length ==
                                                                    5) {
                                                              model.getAddEventDetails(
                                                                  splitUrl[
                                                                      4]);
                                                            } else {
                                                              invalidEvent();
                                                            }
                                                            scannedValue
                                                                    .value =
                                                                value;
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Visibility(
                                                visible: showQRWidget.value,
                                                child: InkWell(
                                                    onTap: () {
                                                      showLog(value);
                                                      showQRWidget.value =
                                                          !value;
                                                      showLog(
                                                          'the widget view changed$value');
                                                    },
                                                    child: _setFadeAnimation1(
                                                        context)),
                                              );
                                      }),
                                ),
                                _setPadding(
                                  context,
                                  ValueListenableBuilder<String>(
                                      valueListenable: scannedValue,
                                      builder: (BuildContext context,
                                          String value, Widget? child) {
                                        return _setFadeAnimation4(
                                            context, model, value);
                                      }),
                                ),
                                _setPadding(context, _setVisibility(context)),
                                _setFadeAnimation5(context, model)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _setFadeAnimation1(BuildContext context) {
    return FadeAnimation(
      delay: 1.6,
      child: Container(
        width: 222.0,
        height: 222.0,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.all(14),
                alignment: Alignment.center,
                child: Icon(
                  Icons.qr_code_2,
                  color: AppColorData.iconSelectedColor,
                  size: MediaQuery.of(context).size.height * 0.25,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 40.0,
                height: 40.0,
                child: CustomPaint(
                  painter: FocusTopLeft(context: context),
                  child: Container(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 40.0,
                height: 40.0,
                child: CustomPaint(
                  painter: FocusTopRight(context: context),
                  child: Container(),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 40.0,
                height: 40.0,
                child: CustomPaint(
                  painter: FocusBottomLeft(context: context),
                  child: Container(),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 40.0,
                height: 40.0,
                child: CustomPaint(
                  painter: FocusBottomRight(context: context),
                  child: Container(),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 90,
                        height: 5,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: AppColorData.bgIconColor,
                                offset: Offset(0, 73.0),
                                blurRadius: 15,
                                spreadRadius: 2.0)
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        height: 170,
                        width: 170,
                        child: CustomPaint(
                          painter: CurveLiner(context: context),
                          child: Container(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _setFadeAnimation4(
      BuildContext context, AddEventRouteViewModel model, String value) {
    eventKeyController.text;
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
          style: Theme.of(context).textTheme.titleMedium,
          // cursorColor: cursorColor,
          validator: (value) {
            if (value!.isEmpty) {
              setState(() {
                errorMessage = S.of(context).please_fill_this_field;
                errorMessageVisibility = true;
              });
              return null;
            } else if ((value.length < 5) || (value.length > 5)) {
              setState(() {
                errorMessage = S.of(context).invalidKey;
                errorMessageVisibility = true;
              });
              return null;
            } else {
              setState(() {
                errorMessageVisibility = false;
              });
              return null;
            }
          },
          controller: eventKeyController,
          decoration: InputDecoration(
            hintText: S.of(context).enter_event_key_to_view_event,
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            //labelText: S.of(context).event_key,
            labelStyle: Theme.of(context).textTheme.labelLarge,
            suffixIcon: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColorData.bgIconBackgroundColor,
                      begin: AppColorData.bgIconGradientBegin,
                      end: AppColorData.bgIconGradientEnd,
                      stops: AppColorData.bgIconStops,
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(Icons.key, color: AppColorData.bgIconColor),
                  )),
            ),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }

  _setFadeAnimation5(BuildContext context, AddEventRouteViewModel model) {
    var width = MediaQuery.of(context).size.width * .1;

    return Padding(
        padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.fromLTRB(width, 0, width, 0),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: AppColorData.buttonBackgroundColors.last,
              foregroundColor: AppColorData.buttonTextColors),

          child: CommonText(
            text: S.of(context).submit,
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              var eventKey = eventKeyController.text;
              if (eventKey.isNotEmpty) {
                if (eventKey.length == 5) {
                  await model.getAddEventDetails(eventKeyController.text);
                }
              }
            }
          },
          //width: 90,
          //height: 40,
        ));
  }

  _setPadding(BuildContext context, Widget child) {
    return Padding(padding: EdgeInsets.only(top: 8), child: child);
  }

  _setVisibility(BuildContext context) {
    return Visibility(
      visible: errorMessageVisibility,
      child: errorMessageShow(errorMessage),
    );
  }

  requestCamPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted ||
        status.isDenied ||
        status.isPermanentlyDenied ||
        status.isRestricted) {
      final result = await Permission.camera.request();
      if (result.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  void invalidEvent() {
    ToastContext().init(context);
    ToastUtil toastUtil = ToastUtil();
    toastUtil.showShortToast(context, S.of(context).invalidCode);
  }
}
