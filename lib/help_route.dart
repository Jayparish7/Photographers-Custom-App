import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:photomall_flutter/color_constants.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  var textColor = AppColorData.appBarTextColor;

  void _onIntroEnd(context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    /*  SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);*/
  }

/*  @override
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
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titlePadding: EdgeInsets.only(top: 16, bottom: 4),
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
          child: IntroductionScreen(
            //isTopSafeArea: true,

            key: introKey,
            globalBackgroundColor: Colors.white,
            allowImplicitScrolling: true,
            autoScrollDuration: 3000,
            //infiniteAutoScroll: true,

            /*globalFooter: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:  AppColorData.appBarBackgroundColors.last
                ),


                child: Text(
                  'Let\'s Select the Photos!',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                      color: AppColorData.appBarIconColor,

                  ),
                ),
                onPressed: () => _onIntroEnd(context),
              ),
            ),*/
            pages: [
              PageViewModel(
                title: "Swipe Right ",
                body: "Swipe Right to Select the photo",
                image: Image.asset('assets/images/Swipe-right.png'),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Swipe Left",
                body: "Swipe Left to reject the photo",
                image: Image.asset('assets/images/Swipe-left.png'),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Swipe Up",
                body: "Swipe up to next image",
                image: Image.asset('assets/images/Swipe-up.png'),
                decoration: pageDecoration,
              ),
              PageViewModel(
                  title: "Swipe Down",
                  body: "Swipe Down to previous image",
                  image: Image.asset('assets/images/Swipe-down.png'),
                  decoration: pageDecoration),
            ],
            onDone: () => _onIntroEnd(context),
            onSkip: () => _onIntroEnd(context),
            // You can override onSkip callback
            showSkipButton: true,
            skipOrBackFlex: 0,
            nextFlex: 0,
            showBackButton: false,
            //rtl: true, // Display as right-to-left
            back: Icon(Icons.arrow_back, color: textColor),
            skip: Text('Skip',
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: textColor)),
            next: Icon(Icons.arrow_forward, color: textColor),
            done: Text('Done',
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: textColor)),
            curve: Curves.fastLinearToSlowEaseIn,
            controlsMargin: const EdgeInsets.all(16),
            controlsPadding: kIsWeb
                ? const EdgeInsets.all(12.0)
                : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
            dotsDecorator: DotsDecorator(
              size: Size(10.0, 10.0),
              color: Color(0xFFBDBDBD),
              activeColor: textColor,
              activeSize: Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
            dotsContainerDecorator: const ShapeDecoration(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
