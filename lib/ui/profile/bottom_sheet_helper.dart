

import 'package:flutter/material.dart';


class BottomSheetHelper extends StatelessWidget {
  final Widget child;
  final double? width;

  const BottomSheetHelper({required this.child,  this.width, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
   // if (DeviceUtil.isSmallScreen(context)) return Container(child: child);
   /* double margin = (CustomAppTheme.fullWidth(context) - (width ?? 0)) / 2;
    return Container(
        margin: EdgeInsets.only(left: margin, right: margin),
        decoration: BoxDecoration(
          color: AppColorData.cardBackgroundColor,//AppColor.get(context, ColorKeys.containerBackgroundColor),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: child);*/
    return Container(child: child);
  }

 /* static Color getBackgroundColor(BuildContext context) {
    if (DeviceUtil.isMobile) {
      return AppColor.get(context, ColorKeys.screenBackgroundColor);
    }
    return DeviceUtil.isSmallScreen(context)
        ? AppColor.get(context, ColorKeys.screenBackgroundColor)
        : AppColor.get(context, ColorKeys.transparentColor);
  }*/
}
