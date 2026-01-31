import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';

class CommonCard extends StatelessWidget {
  final Widget? child;

  final BorderRadiusGeometry? shape;

  CommonCard({Key? key, this.child, this.shape}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: shape ?? BorderRadius.circular(8.0),
        ),
        elevation: AppColorData.cardElevation,
        shadowColor: AppColorData.cardShadowColor,
        color: Colors.transparent,
        margin: AppColorData.cardMargin,
        child: ClipRRect(
          borderRadius: shape ?? BorderRadius.circular(8.0),
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: AppColorData.cardGradientBegin,
                      end: AppColorData.cardGradientEnd,
                      colors: AppColorData.cardBackgroundColors,
                      stops: AppColorData.cardStops)),
              child: child),
        ));
  }
}
