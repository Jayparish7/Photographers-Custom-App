import 'package:animated_introduction/animated_introduction.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<TutorialPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  var textColor = AppColorData.appBarTextColor;
  static var mainCircleBg = AppColorData.appBarTitleColor;
  static var dotCircleBg = AppColorData.appBarTitleColor;
  static var style = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.normal,
  );

  /// List of pages to be shown in the introduction
  ///
  final List<SingleIntroScreen> pages = [
    SingleIntroScreen(
      mainCircleBgColor: mainCircleBg,
      sideDotsBgColor: dotCircleBg,
      title: 'AI - Face Recognition',
      description: 'Upload your selfie and get your photos',
      imageAsset: 'assets/images/ai.gif',
      textStyle: style,
    ),
    SingleIntroScreen(
      mainCircleBgColor: mainCircleBg,
      sideDotsBgColor: dotCircleBg,
      title: 'Book an event',
      description: 'Your best memories, once captured, will last a lifetime',
      imageAsset: 'assets/images/book.jpeg',
      textStyle: style,
    ),
    SingleIntroScreen(
      mainCircleBgColor: mainCircleBg,
      sideDotsBgColor: dotCircleBg,
      title: 'Photo Selection',
      description: 'Photo selection process made easy',
      imageAsset: 'assets/images/ps.gif',
      imageHeightMultiple: 1,
      textStyle: style,
    ),
  ];

  @override
  void initState() {
    super.initState();

    /* SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);*/
  }

  /*@override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
    // WidgetsBinding.instance.removeObserver(this);
  }*/

  @override
  Widget build(BuildContext context) {
    return AnimatedIntroduction(
      footerRadius: 56,
      slides: pages,
      doneText: 'Done',
      skipText: '',
      indicatorType: IndicatorType.line,
      isFullScreen: true,
      footerBgColor: AppColorData.appBarTextColor,
      activeDotColor: AppColorData.bgIconColor,
      textColor: AppColorData.appBarIconColor,
      onDone: () {
        /// TODO: Go to desire page like login or home
        Navigator.pop(context);
      },
    );
  }
}
