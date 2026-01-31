import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/traits/common_widgets/warning_widget.dart';
import '../../core/constants/studio_config_constants.dart';

class CommonCircularProgress extends StatelessWidget {
  const CommonCircularProgress({
    Key? key,
    this.value,
    this.isOtpPage,
    this.isPrintButton,
  }) : super(key: key);
  final double? value;
  final List? isOtpPage;
  final bool? isPrintButton;

  @override
  initState() {
    showLog("the stork width$value ${AppColorData.circularStrokeWidth}");
  }

  @override
  Widget build(BuildContext context) {
    return (isOtpPage == null && !isPhotomallApp)
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (value != null)
                    ? ConstrainedBox(
                        constraints:
                            BoxConstraints(maxHeight: 50, maxWidth: 50),
                        child: CircularProgressIndicator(
                          backgroundColor: AppColorData.circularProgressBg,
                          strokeWidth: AppColorData.circularStrokeWidth,
                          value: value,
                          color: AppColorData.circularProgress,
                        ),
                      )
                    : Center(
                        child: Stack(
                        children: [
                          LoadingAnimationWidget.threeArchedCircle(
                            key: GlobalKey(),
                            color: AppColorData.appBarTextColor,
                            size: 50,
                          ),
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(int.parse(
                                        '0xff${splashBackgroundColorCode.replaceAll('#', '')}')),
                                    borderRadius: BorderRadius.circular(100)),
                                child: Image.asset(
                                  'assets/images/splash_logo.png',
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                Padding(padding: EdgeInsets.all(5)),
                isPrintButton == true
                    ? SizedBox()
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(" Loading",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          BlinkingWidget(
                            child: Text(".",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                          BlinkingWidget(
                            child: Text(".",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                          BlinkingWidget(
                            child: Text(".",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )
              ],
            ),
          )
        : !isPhotomallApp
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints:
                          BoxConstraints(maxHeight: 100, maxWidth: 100),
                      child: Center(
                          child: Stack(
                        children: [
                          LoadingAnimationWidget.threeArchedCircle(
                              key: GlobalKey(),
                              color: AppColorData.appBarTextColor,
                              size: 80),
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(int.parse(
                                        '0xff${splashBackgroundColorCode.replaceAll('#', '')}')),
                                    borderRadius: BorderRadius.circular(100)),
                                child: Image.asset(
                                  'assets/images/splash_logo.png',
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    isOtpPage != null ?  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedTextKit(
                          repeatForever: true,
                          isRepeatingAnimation: true,
                          displayFullTextOnTap: true,
                          animatedTexts: [
                            TyperAnimatedText(
                              textAlign: TextAlign.justify,
                              "Please wait for fetching Your Data",
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: AppColorData.appBarTextColor,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1,
                                      overflow: TextOverflow.ellipsis),
                            ),
                          ],
                          onTap: () {},
                        ),
                        BlinkingWidget(
                          child: Text(".",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        BlinkingWidget(
                          child: Text(".",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        BlinkingWidget(
                          child: Text(".",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ):SizedBox()
                  ],
                ),
              )
            : Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
                  child: CircularProgressIndicator(
                    backgroundColor: AppColorData.circularProgressBg,
                    strokeWidth: AppColorData.circularStrokeWidth,
                    value: value,
                    color: AppColorData.circularProgress,
                  ),
                ),
              );
  }
}
