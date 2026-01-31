import 'package:flutter/material.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/Utils/clipper/oval_right_clipper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/design_properties_model.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as appConf;
import 'package:photomall_flutter/main.dart';
import 'package:provider/provider.dart';

AppDesignKeys? designData;

class AppColorData {
  appConf.DesignData? apiColors;

  Future<appConf.DesignData?> getColor(BuildContext context) async {
    var appConfig = TransporterPreference();
    designData = await appConfig.getColor();
    Provider.of<CustomThemeProvider>(context, listen: false).updateUI();
    return apiColors;
  }

  ///Text Properties
  static Color titleLarge = Color(
      int.parse('0xff${designData!.textProperties!.titleLargeTextColor}'));
  static Color helpText =
      Color(int.parse('0xff${designData!.textProperties!.helpTextColor}'));

  ///Highlight Text Properties
  static Color dateAndEventTitle = Color(
      int.parse('0xff${designData!.highlightTextColor!.headLineSmallText}'));
  static Color dayColor =
      Color(int.parse('0xff${designData!.highlightTextColor!.labelLargeText}'));
  static Color monthAndYearColor = Color(
      int.parse('0xff${designData!.highlightTextColor!.titleMediumText}'));

  /// AppBar Properties
  static Color appBarIconColor =
      Color(int.parse('0xff${designData!.appBar!.icon}'));
  static Color appBarTitleColor =
      Color(int.parse('0xff${designData!.appBar!.titleText}'));
  static Color appBarTextColor =
      Color(int.parse('0xff${designData!.appBar!.textColor}'));
  static List<Color> appBarBackgroundColor =
      getColorArray(designData!.appBar!.background!);
  static AlignmentGeometry appBarGradientBegin =
      getBeginAndEndForColor(designData!.appBar!.backgroundBegin.toString());
  static AlignmentGeometry appBarGradientEnd =
      getBeginAndEndForColor(designData!.appBar!.backgroundEnd!.toString());
  static List<double> appBarStops = designData!.appBar!.backgroundStops!;

  /// TabBar Properties
  static Color tabBarIndicatorColor =
      Color(int.parse('0xff${designData!.tabBar!.indicatorColor}'));
  static Color tabBarSelectedLabelColor =
      Color(int.parse('0xff${designData!.tabBar!.selectedLabelColor}'));
  static Color tabBarUnSelectedLabelColor =
      Color(int.parse('0xff${designData!.tabBar!.unSelectedLabel}'));
  static List<Color> tabBarBackgroundColors =
      getColorArray(designData!.tabBar!.background!);
  static AlignmentGeometry tabBarGradientBegin =
      getBeginAndEndForColor(designData!.tabBar!.backgroundBegin.toString());
  static AlignmentGeometry tabBarGradientEnd =
      getBeginAndEndForColor(designData!.tabBar!.backgroundEnd.toString());
  static List<double> tabBarStops = designData!.tabBar!.backgroundStops!;

  /// App Background Properties
  static List<Color> backgroundColors =
      getColorArray(designData!.app!.background!);
  static AlignmentGeometry backgroundGradientBegin =
      getBeginAndEndForColor(designData!.app!.backgroundBegin.toString());
  static AlignmentGeometry backgroundGradientEnd =
      getBeginAndEndForColor(designData!.app!.backgroundEnd.toString());
  static List<double> appBackgroundStops = designData!.app!.backgroundStops!;

  /// Bottom Navigation Properties
  static List<Color> bottomNavbarBackgroundColors =
      getColorArray(designData!.bottomNavigation!.background!);
  static AlignmentGeometry bottomNavbarBackgroundGradientBegin =
      getBeginAndEndForColor(
          designData!.bottomNavigation!.backgroundBegin.toString());
  static AlignmentGeometry bottomNavbarBackgroundGradientEnd =
      getBeginAndEndForColor(
          designData!.bottomNavigation!.backgroundEnd.toString());
  static List<double> bottomNavbarStops =
      designData!.bottomNavigation!.backgroundStops!;
  static Color bottomNavigationSelectedTextColor =
      Color(int.parse('0xff${designData!.bottomNavigation!.selectedText}'));
  static Color bottomNavTextUnSelectedColor =
      Color(int.parse('0xff${designData!.bottomNavigation!.unselectedText}'));
  static Color bottomNavIconSelectedColor =
      Color(int.parse('0xff${designData!.bottomNavigation!.selectedIcon}'));
  static Color bottomNavIconUnSelectedColor =
      Color(int.parse('0xff${designData!.bottomNavigation!.unselectedIcon}'));

  /// BackGround Icon Properties
  static Color bgIconColor =
      Color(int.parse('0xff${designData!.backgroundIcon!.iconColor}'));
  static List<Color> bgIconBackgroundColor =
      getColorArray(designData!.backgroundIcon!.background!);
  static AlignmentGeometry bgIconGradientBegin = getBeginAndEndForColor(
      designData!.backgroundIcon!.backgroundBegin.toString());
  static AlignmentGeometry bgIconGradientEnd = getBeginAndEndForColor(
      designData!.backgroundIcon!.backgroundEnd!.toString());
  static List<double> bgIconStops =
      designData!.backgroundIcon!.backgroundStops!;

  /// Normal Icon Properties
  static Color iconColor =
      Color(int.parse('0xff${designData!.iconProperties!.unselected}'));
  static Color iconSelectedColor =
      Color(int.parse('0xff${designData!.iconProperties!.selected}'));

  /// sideDrawer Color Properties
  //give this if curved [OvalRightBorderClipper()] else for normal[null]
  static CustomClipper<Path>? sideDrawerClipBehaviour =
      (designData!.sideDrawer!.clipPath == null) ||
              (designData!.sideDrawer!.clipPath ==
                  0) //0 - normal side drawer , 1 - curved side drawer
          ? null
          : OvalRightBorderClipper();
  static List<Color> sideDrawerBackgroundColors =
      getColorArray(designData!.sideDrawer!.background!);
  static AlignmentGeometry sideDrawerBackgroundBegin = getBeginAndEndForColor(
      designData!.sideDrawer!.backgroundBegin.toString());
  static AlignmentGeometry sideDrawerBackgroundEnd =
      getBeginAndEndForColor(designData!.sideDrawer!.backgroundEnd!.toString());
  static List<double> sideDrawerStops =
      designData!.sideDrawer!.backgroundStops!;
  static Color sideDrawerSelectedTextColor =
      Color(int.parse('0xff${designData!.sideDrawer!.selectedText!}'));
  static Color sideDrawerUnselectedTextColor =
      Color(int.parse('0xff${designData!.sideDrawer!.unselectedText}'));
  static Color sideDrawerSelectedIconColor =
      Color(int.parse('0xff${designData!.sideDrawer!.selectedIcon!}'));
  static Color sideDrawerUnselectedIconColor =
      Color(int.parse('0xff${designData!.sideDrawer!.unselectedIcon}'));
  static bool menuPosition =
      (designData!.sideDrawer!.menuPosition == 1) ? true : false;

  /// button Color Properties
  static Color buttonTextColors =
      Color(int.parse('0xff${designData!.buttonProperties!.textColor}'));
  static List<Color> buttonBackgroundColors =
      getColorArray(designData!.buttonProperties!.background!);
  static AlignmentGeometry buttonGradientBegin = getBeginAndEndForColor(
      designData!.buttonProperties!.backgroundBegin!.toString());
  static AlignmentGeometry buttonGradientEnd = getBeginAndEndForColor(
      designData!.buttonProperties!.backgroundEnd!.toString());
  static List<double> buttonBackgroundStops =
      designData!.buttonProperties!.backgroundStops!;
  static Color buttonShadowColors =
      Color(int.parse('0xff${designData!.buttonProperties!.shadow}'));
  static double buttonElevation =
      double.parse(designData!.buttonProperties!.elevation!.toString());
  static Color elevatedButtonText = Color(
      int.parse('0xff${designData!.buttonProperties!.elevatedButtonColor}'));
  static Color textButton =
      Color(int.parse('0xff${designData!.buttonProperties!.textButtonColor}'));
  static Color outLineButtonBorder = Color(
      int.parse('0xff${designData!.buttonProperties!.outLineButtonBorder}'));

  /// Material Design Colors
  static Color dividerColor =
      Color(int.parse('0xff${designData!.material!.divider}'));
  static Color logoBackgroundColor = Colors.red;

  /// Card properties
  static double cardElevation =
      double.parse(designData!.cardProperties!.elevation.toString());
  static Color cardShadowColor =
      Color(int.parse('0xff${designData!.cardProperties!.shadow}'));
  static Color selectedCardBackgroundColor =
      Color(int.parse('0xff${designData!.cardProperties!.selectedBackground}'));
  static EdgeInsetsGeometry cardMargin = EdgeInsets.all(
      double.parse(designData!.cardProperties!.margin.toString()));
  static Color cardHighlightedIconColour = Color(
      int.parse('0xff${designData!.cardProperties!.highlightedIconColour}'));
  static Color cardHighlightedTextColour = Color(
      int.parse('0xff${designData!.cardProperties!.highlightedTextColour}'));
  static Color cardNormalIconColour =
      Color(int.parse('0xff${designData!.cardProperties!.normalIconColour}'));
  static Color cardNormalTextColour =
      Color(int.parse('0xff${designData!.cardProperties!.normalTextColour}'));

  static List<Color> cardBackgroundColors =
      getColorArray(designData!.cardProperties!.backgroundColors!);
  static AlignmentGeometry cardGradientBegin = getBeginAndEndForColor(
      designData!.cardProperties!.backgroundBegin.toString());
  static AlignmentGeometry cardGradientEnd = getBeginAndEndForColor(
      designData!.cardProperties!.backgroundEnd!.toString());
  static List<double> cardStops = designData!.cardProperties!.backgroundStops!;

  /// Photo selection status card properties
  static Color selectionStatusCardUndecidedText =
      Color(int.parse('0xff${designData!.selectionStatusCard!.undecidedText}'));
  static Color selectionStatusCardSelectedText =
      Color(int.parse('0xff${designData!.selectionStatusCard!.selectedText}'));
  static Color selectionStatusCardRejectedText =
      Color(int.parse('0xff${designData!.selectionStatusCard!.rejectedText}'));
  static Color selectionStatusUndecidedCard =
      Color(int.parse('0xff${designData!.selectionStatusCard!.undecidedCard}'));
  static Color selectionStatusSelectedCard =
      Color(int.parse('0xff${designData!.selectionStatusCard!.selectedCard}'));
  static Color selectionStatusRejectedCard =
      Color(int.parse('0xff${designData!.selectionStatusCard!.rejectedCard}'));
  static List<Color> selectionStatusCardBackground =
      getColorArray(designData!.selectionStatusCard!.background!);
  static AlignmentGeometry selectionStatusCardGradientBegin =
      getBeginAndEndForColor(
          designData!.selectionStatusCard!.backgroundBegin.toString());
  static AlignmentGeometry selectionStatusCardGradientEnd =
      getBeginAndEndForColor(
          designData!.selectionStatusCard!.backgroundEnd!.toString());
  static List<double> selectionStatusCardStops =
      designData!.selectionStatusCard!.backgroundStops!;

  ///Text Form Field Properties
  static Color cursor =
      Color(int.parse('0xff${designData!.textFormField!.textFormFieldCursor}'));
  static Color hintText = Color(
      int.parse('0xff${designData!.textFormField!.textFormFieldHintText}'));
  static Color labelText = Color(
      int.parse('0xff${designData!.textFormField!.textFormFieldLabelText}'));
  static Color borderSide = Color(
      int.parse('0xff${designData!.textFormField!.textFormFieldBorderSide}'));
  static Color textFormFieldCardBg = Color(
      int.parse('0xff${designData!.textFormField!.textFormFieldBackground}'));
  static Color textFormFieldCursor =
      Color(int.parse('0xff${designData!.textFormField!.textFormFieldCursor}'));
  static double textFormFieldCardElevation = double.parse(
      designData!.textFormField!.textFormFieldElevation.toString());
  static Color textFormFieldCardShadow =
      Color(int.parse('0xff${designData!.textFormField!.textFormFieldShadow}'));
  static EdgeInsetsGeometry textFormFieldCardMargin = EdgeInsets.all(
      double.parse(designData!.textFormField!.textFormFieldMargin.toString()));
  static Color dateHeadingBg = Color(
      int.parse('0xff${designData!.textFormField!.dateHeadingBackground}'));
  static Color dateText =
      Color(int.parse('0xff${designData!.textFormField!.dateText}'));
  static Color dateSelectedText =
      Color(int.parse('0xff${designData!.textFormField!.dateSelectedText}'));
  static Color dateSelectedTextBg = Color(
      int.parse('0xff${designData!.textFormField!.dateSelectedBackground}'));

  /// Alert Dialog Properties
  static Color alertDialogBg =
      Color(int.parse('0xff${designData!.alertDialog!.alertDialogBackground}'));
  static Color alertDialogTitle =
      Color(int.parse('0xff${designData!.alertDialog!.alertDialogTitle}'));
  static Color alertDialogContent =
      Color(int.parse('0xff${designData!.alertDialog!.alertDialogContent}'));
  static Color alertDialogIcon =
      Color(int.parse('0xff${designData!.alertDialog!.alertDialogIcon}'));

  /// Circular Progress Properties
  static Color circularProgressBg = Color(
      int.parse('0xff${designData!.progressIndicator!.circularBackground}'));
  static Color circularProgress =
      Color(int.parse('0xff${designData!.progressIndicator!.circularColor}'));
  static double circularStrokeWidth =
      double.parse(designData!.progressIndicator!.strokeWidth.toString());

  /// Item & Page Transition Properties
  static int itemTransition = designData!.transitionEffects!.itemTransition!;
  static int pageTransition = designData!.transitionEffects!.pageTransition!;

  /// Text Color Properties
  static Color helpTextColor = Colors.grey;
  static Color titleTextColor = Colors.red;
  static Color normalTextColor = Colors.black;

  /// kotlin
  static String sideDrawerUnselectedTextColorKotlin =
      '${designData!.sideDrawer!.unselectedText}';
  static String sideDrawerBackgroundColorKotlin =
      getColorKotlinFormat(designData!.sideDrawer!.background![0]);
  static String backgroundColorsKotlin =
      getColorsKotlinFormat(designData!.sideDrawer!.background!);

  static String getColorsKotlinFormat(List<String> colorString) {
    return '${colorString[0]},${colorString[1]}';
  }

  static String getColorKotlinFormat(String colorString) {
    return '$colorString';
  }

  static List<Color> getColorArray(List<String> colorString) {
    List<Color> colorList = [];
    for (String color in colorString) {
      colorList.add(Color(int.parse('0xff${color}')));
    }
    return colorList;
  }

  static Alignment getBeginAndEndForColor(String value) {
    showLog('the value got where ${value}');
    switch (value) {
      case "1":
        {
          return Alignment.bottomCenter;
        }

      case "2":
        {
          return Alignment.bottomRight;
        }
      case "3":
        {
          return Alignment.bottomLeft;
        }
      case "4":
        {
          return Alignment.topCenter;
        }
      case "5":
        {
          return Alignment.topRight;
        }
      case "6":
        {
          return Alignment.topLeft;
        }
      case "7":
        {
          return Alignment.center;
        }
      case "8":
        {
          return Alignment.centerRight;
        }
      case "9":
        {
          return Alignment.centerLeft;
        }
      default:
        {
          return Alignment.center;
        }
    }
  }
}

class TextProperty {
  static const base = 16.0;

  static const h1 = base + 8.0;
  static const h2 = base + 6.0;
  static const h3 = base + 4.0;

  static const p1 = base + 2.0;
  static const hint = base - 1.0;
}

Color lightenColor(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
  return hslLight.toColor();
}

Color darkenColor(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}
