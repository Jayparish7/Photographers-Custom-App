import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';


class CustomAppTheme {
  const CustomAppTheme();

  static ThemeData appTheme(BuildContext context) => ThemeData(/*

  //  unselectedWidgetColor: AppColor.get(context,  ColorKeys.primaryTextColor),
        fontFamily: FontUtil.getFontFamily(),
        brightness: Brightness.light,
        //textTheme: FontUtil.getFontTextTheme(context),
    //    primaryColor: AppColor.get(context, ColorKeys.primaryColor),
        // scaffoldBackgroundColor: Colors.white,
    //    primaryColorLight: AppColor.get(context, ColorKeys.primaryColorLight1),
    //    primaryColorDark: AppColor.get(context, ColorKeys.primaryColorDark),
    //    accentColor: AppColor.get(context, ColorKeys.accentColor),
     //   backgroundColor: AppColor.get(context, ColorKeys.screenBackgroundColor),
     //   cardTheme: CardTheme(
    //        color: AppColor.get(context, ColorKeys.cardBackgroundColor)),
     //   bottomAppBarColor: AppColor.get(context, ColorKeys.bottomAppBarColor),
     //   dividerColor: AppColor.get(context, ColorKeys.dividerColor),
        //fontFamily: 'OpenSans',
        //textTheme: TextTheme(
        *//*textTheme:
            FontUtil.getFontTextTheme(Theme.of(context).textTheme).copyWith(
          //body1: TextStyle(color: LightColor.titleTextColor),
          headline5: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
          subtitle1: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: AppColor.get(context, ColorKeys.primaryTextColor),
          ),
          headline6: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
          subtitle2: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
          ),
          bodyText2: TextStyle(
            fontSize: 15.0,
            fontStyle: FontStyle.normal,
            color: AppColor.get(context, ColorKeys.primaryTextColor),
          ),
          bodyText1: TextStyle(
              fontSize: 15.0,
              fontStyle: FontStyle.normal,
              color: AppColor.get(context, ColorKeys.secondaryTextColor)),
          headline4: TextStyle(
            fontSize: 16.0,
            color: AppColor.get(context, ColorKeys.primaryTextColor),
            fontWeight: FontWeight.w600,
          ),
          headline3: TextStyle(
              fontSize: 15.0,
              fontStyle: FontStyle.normal,
              color: AppColor.get(context, ColorKeys.primaryTextColor)),
          headline2: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w800,
              color: AppColor.get(context, ColorKeys.primaryTextColor)),
        ),*//*
        buttonTheme: ButtonThemeData(
            splashColor: AppColor.get(context, ColorKeys.splashColor),
            buttonColor: AppColor.get(context, ColorKeys.primaryColorDark),
            textTheme: ButtonTextTheme.accent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))),

        *//*textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.orange,
            onSurface: Colors.red
          ),
        ),*//*

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: AppColor.get(context, ColorKeys.materialButtonTextColor),
            primary:
                AppColor.get(context, ColorKeys.materialButtonBackgroundColor),
          ),
        ),

        *//*elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: AppColor.get(context, ColorKeys.materialButtonTextColor),
            primary: AppColor.get(context, ColorKeys.materialButtonBackgroundColor),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),*//*
    */  );

  /*static TextStyle titleStyle =
      const TextStyle(color: Colors.black54, fontSize: 16);
  static TextStyle subTitleStyle =
      const TextStyle(color: Colors.grey, fontSize: 12);

  static List<BoxShadow> shadow = <BoxShadow>[
    BoxShadow(color: Color(0xfff8f8f8), blurRadius: 10, spreadRadius: 15),
  ];*/

  static EdgeInsets padding =
      const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static EdgeInsets hPadding = const EdgeInsets.symmetric(
    horizontal: 10,
  );

  static double fullWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static var cardBorder = (double size) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(size));

  static double fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static boxTextFieldDecoration(BuildContext context, String label, [String? helperText]) {
    return InputDecoration(
      errorStyle: Theme.of(context).textTheme.labelMedium,
      disabledBorder: InputBorder.none,
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: AppColorData.borderSide//AppColor.get(context, ColorKeys.primaryTextColor)
          )),
      helperText: helperText,
        helperStyle: Theme.of(context).textTheme.labelLarge,
        /*TextStyle(
            color:
            AppColor.get(context, ColorKeys.primaryTextColor),
            fontSize: 12),*/
      contentPadding: EdgeInsets.only(top: 18, bottom: 18, left: 14, right: 14),
      labelText: label,
      labelStyle: Theme.of(context).textTheme.labelLarge,
      /*TextStyle(
          color:
              AppColor.get(context, ColorKeys.primaryTextColor),
          fontSize: 16),*/
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: AppColorData.borderSide//AppColor.get(context, ColorKeys.primaryTextColor)
          )),
      filled: true,
      fillColor: AppColorData.textFormFieldCardBg,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: AppColorData.borderSide//AppColor.get(context, ColorKeys.primaryTextColor).withOpacity(0.6)
          )),
      //focusColor: Colors.black,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: AppColorData.borderSide,//AppColor.get(context, ColorKeys.darkDividerColor),
            width: 0.7),
      ),
    );
  }
}
