import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/Utils/device_util.dart';
import 'package:photomall_flutter/core/Utils/text_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/traits/common_widgets/common_card.dart';
import 'package:photomall_flutter/traits/utils/network_util.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';

class CustomButtonWithProgress extends StatefulWidget {
  final String text;
  bool isShowProgress;
  final Function onPressed;
  final TextStyle textStyle;
  final bool hideText;
  final Color buttonColor;
  final double progressSize;
  final double borderRadius;
  final Function? onNetworkError;
  final bool checkInternetConnection;
  final bool isTitleCaseRequired;
  final bool isButtonColorHandled;

  CustomButtonWithProgress(
      {required this.text,
      required this.onPressed,
      this.isShowProgress = false,
      this.textStyle = const TextStyle(fontSize: 17.2, color: Colors.red),
      this.hideText = false,
      this.buttonColor = const Color(0xff0077E3),
      this.progressSize = 25,
      this.borderRadius = 6,
      this.onNetworkError,
      this.checkInternetConnection = true,
      this.isTitleCaseRequired = true,
      this.isButtonColorHandled = false});

  @override
  State<CustomButtonWithProgress> createState() =>
      _CustomButtonWithProgressState();
}

class _CustomButtonWithProgressState extends State<CustomButtonWithProgress> {
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> progress = ValueNotifier<bool>(false);

    widget.isShowProgress = false;
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
            /*boxShadow: const [
                  BoxShadow(
                      color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
                ],*/
            gradient: LinearGradient(
                begin: AppColorData.buttonGradientBegin,
                end: AppColorData.buttonGradientEnd,
                colors: AppColorData.buttonBackgroundColors,
                stops: AppColorData.buttonBackgroundStops),
            borderRadius: BorderRadius.circular(4)),
        child: ValueListenableBuilder<bool>(
            valueListenable: progress,
            builder: (BuildContext context, bool value, Widget? child) {
              showLog('button rebuilding ${progress.value}');
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  value
                      ? const SizedBox()
                      : CommonText(
                          isButton: true,
                          text: widget.isTitleCaseRequired
                              ? TextUtil.convertToTitleCase(widget.text)!
                              : widget.text,
                          textAlign: TextAlign.center,
                        ),
                  //: Text(text, style: textStyle),
                  SizedBox(width: value ? 10 : 0),
                  value
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        )
                      : Container()
                ],
              );
            }),
      ),
      onPressed: () async {
        progress.value = true;
        MyConnectivity myConnectivity = MyConnectivity.instance;
        if (await myConnectivity.checkInternetStatus()) {
          await widget.onPressed();
                } else {}
        progress.value = false;

        /*
            showLog("on press progress button  step 1");
            */
        /*if (!isShowProgress) {
              if (DeviceUtil.isWeb) {
                onPressed();
              } else {
                if (dataConnectionStatus == DataConnectionStatus.connected) {
                  onPressed();
                } else {
                  //showOfflineSnackBar(context);
                  onNetworkError();
                }
              }
            }*/
        /*
            showLog("on press progress button  step 2");
            if (DeviceUtil.isWeb) {
              showLog("on press progress button  step 3");
              if (onPressed != null) onPressed();
            } else if (checkInternetConnection) {
              showLog("on press progress button  step 4");
              if (dataConnectionStatus == DataConnectionStatus.connected) {
                showLog("on press progress button  step 5");
                if (onPressed != null) onPressed();
              } else {
                showLog("on press progress button  step 6");
                //showOfflineSnackBar(context);
                onNetworkError();
              }
            } else {
              showLog("on press progress button  step 7");
              isShowProgress = true;
              if (onPressed != null){
                showLog("on press progress button  step 8");
                onPressed();
              }
              isShowProgress = false;
            }
          */
      },
    );
  }
}

class CustomOutlinedButtonWithProgress extends StatelessWidget {
  final String text;
  bool isShowProgress;
  final Function onPressed;
  final TextStyle textStyle;
  final bool hideText;
  final double progressSize;
  final Function onNetworkError;
  final bool checkInternetConnection;
  final bool showWrap;
  final bool isTitleCaseRequired;

  CustomOutlinedButtonWithProgress(
      {required this.text,
      required this.onPressed,
      this.isShowProgress = false,
      this.textStyle = const TextStyle(fontSize: 17.2, color: Colors.red),
      this.hideText = false,
      this.progressSize = 25,
      required this.onNetworkError,
      this.checkInternetConnection = true,
      this.showWrap = false,
      this.isTitleCaseRequired = true});

  @override
  Widget build(BuildContext context) {
    isShowProgress = false;
    return OutlinedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: showWrap ? MainAxisSize.min : MainAxisSize.max,
        children: <Widget>[
          hideText && isShowProgress
              ? const SizedBox()
              : Text(
                  isTitleCaseRequired
                      ? TextUtil.convertToTitleCase(text)!
                      : text,
                  textAlign: TextAlign.center,
                  style: textStyle.copyWith(
                      /*color: AppColor.get(
                          context, ColorKeys.outlinedButtonTextColor),*/
                      fontWeight: FontWeight.w500),
                ),
          //: Text(text, style: textStyle),
          SizedBox(width: isShowProgress ? 10 : 0),
          isShowProgress
              ? Container(
                  width: progressSize,
                  height: progressSize,
                  child: CommonCircularProgress()
                  /* CircularProgressIndicator(
                    strokeWidth: 1.7,
                    */ /*valueColor: AlwaysStoppedAnimation<Color>(AppColor.get(
                        context, ColorKeys.outlinedButtonTextColor)),*/ /*
                  ),*/
                  )
              : Container()
        ],
      ),
      onPressed: () {
        /*if (!isShowProgress) {
          if (DeviceUtil.isWeb) {
            onPressed();
          } else {
            if (dataConnectionStatus == DataConnectionStatus.connected) {
              onPressed();
            } else {
              //showOfflineSnackBar(context);
              onNetworkError();
            }
          }
        }*/
        if (DeviceUtil.isWeb) {
          onPressed();
        } else if (checkInternetConnection) {
          //    if (dataConnectionStatus == DataConnectionStatus.connected) {
          onPressed();
          /*  } else {
            //showOfflineSnackBar(context);
            onNetworkError()!;
          }*/
        } else {
          onPressed();
        }
      },
    );
  }
}

class NoInternetView extends StatelessWidget {
  final Function? onTap;

  NoInternetView({this.onTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        color: Colors.transparent,
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 36.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  /*Image.asset(
                    'assets/images/no_internet.webp',
                    width: 163,
                    height: 163,
                  ),*/
                  Container(
                    /* decoration: BoxDecoration(
                        color:
                            AppColor.get(context, ColorKeys.darkDividerColor)
                                .withOpacity(0.15),
                        shape: BoxShape.circle),*/
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Stack(
                        children: [
                          /*    Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.cloud_off_rounded,
                              size: 90,
                              //color: AppColor.get(context, ColorKeys.lightThemeColorKey),
                              color: AppColor.get(
                                      context, ColorKeys.darkDividerColor)
                                  .withOpacity(0.5),
                            ),
                          ),*/
                          /*Positioned.fill(
                            //bottom: -10,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Card(
                                color: AppColor.get(
                                    context, ColorKeys.iconBackgroundColor),
                                shape: CircleBorder(),
                                elevation: 8,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.close,
                                    size: 30,
                                    color: AppColor.get(
                                        context, ColorKeys.iconIconColor),
                                  ),
                                ),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                      //S.of(context).no_internet_connections,
                      'NO INTERNET CONNECTIONS',
                      /*  style: TextStyle(
                        fontSize: 17.3,
                        fontWeight: FontWeight.w300,
                        color:
                            AppColor.get(context, ColorKeys.primaryTextColor),
                      ),*/
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    child: CustomOutlinedButtonWithProgress(
                      /*borderSide: BorderSide(color: Colors.blue, width: 1.2),
                      splashColor: Colors.grey.withOpacity(0.03),*/
                      text: ' RETRY ',
                      showWrap: true,
                      checkInternetConnection: false,
                      onPressed: () {
                        if (onTap != null) {
                          onTap!();
                        }
                      },
                      onNetworkError: () {},
                      /*child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text(
                          "RETRY",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),*/
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  final String text;
  final IconData? iconData;
  final String? text1;
  final String? text2;

  EmptyView({
    required this.text,
    this.iconData,
    this.text1,
    this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (iconData != null)
                ? Container(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: AppColorData.dividerColor.withOpacity(0.15)
                              /* AppColor.get(context, ColorKeys.darkDividerColor)
                                .withOpacity(0.15)*/
                              ,
                              shape: BoxShape.circle),
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.assignment,
                                    size: 90,
                                    color:
                                        AppColorData.iconColor.withOpacity(0.5),
                                  ),
                                ),
                                Positioned.fill(
                                  //bottom: -10,
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: CommonCard(
                                      shape: BorderRadius.circular(100.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          iconData,
                                          size: 25,
                                          color: AppColorData.iconSelectedColor,
                                          /*  color: AppColor.get(
                                        context, ColorKeys.iconIconColor),*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : SizedBox(),
            const SizedBox(height: 20),
            CommonText(
                text: text,
                color: AppColorData.titleTextColor,
                fontWeight: FontWeight.bold,
                style: Theme.of(context).textTheme.titleLarge
                /*GoogleFonts.mulish(
                color: AppColor.get(context, ColorKeys.primaryTextColor),
                fontSize: 21,
                fontWeight: FontWeight.w300,
              ),*/
                ),
            CommonText(
                text: text1 ?? '',
                color: AppColorData.titleTextColor,
                fontWeight: FontWeight.bold,
                style: Theme.of(context).textTheme.titleLarge
                /*GoogleFonts.mulish(
                color: AppColor.get(context, ColorKeys.primaryTextColor),
                fontSize: 21,
                fontWeight: FontWeight.w300,
              ),*/
                ),
            CommonText(
                text: text2 ?? '',
                color: AppColorData.titleTextColor,
                fontWeight: FontWeight.bold,
                style: Theme.of(context).textTheme.titleLarge
                /*GoogleFonts.mulish(
                color: AppColor.get(context, ColorKeys.primaryTextColor),
                fontSize: 21,
                fontWeight: FontWeight.w300,
              ),*/
                )
          ],
        ),
      ),
    );
  }
}

class DeviceRegisterFailedWidget extends StatelessWidget {
  final Function onTap;

  DeviceRegisterFailedWidget({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 36.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      /*        color: AppColor.get(context, ColorKeys.darkDividerColor)
                          .withOpacity(0.15),*/
                      shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.cloud_off_rounded,
                            size: 90,
                            //color: AppColor.get(context, ColorKeys.lightThemeColorKey),
                            /*            color: AppColor.get(
                                    context, ColorKeys.darkDividerColor)
                                .withOpacity(0.5),*/
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Opacity(
                  opacity: 0.5,
                  child: Text(
                    S.of(context).something_went_wrong,
                    style: const TextStyle(
                      fontSize: 17.3,
                      fontWeight: FontWeight.w300,
                      //color: Colors.black.withOpacity(0.45),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DeviceUtil.isMobile
                    ? Container(
                        child: CustomOutlinedButtonWithProgress(
                          text: ' Close App ',
                          showWrap: true,
                          checkInternetConnection: false,
                          onPressed: () {
                            onTap();
                                                    },
                          onNetworkError: () {},
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
