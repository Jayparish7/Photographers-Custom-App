import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';

class BottomSheetOption extends StatelessWidget {
  IconData? icon;
  String? title;
  String? subtitle;
  Function onPressed;

  BottomSheetOption({this.icon, this.title, this.subtitle, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
     // color: AppColor.get(context, ColorKeys.transparentColor),
      child: InkWell(
        onTap: () => onPressed(),
        child: ListTile(
          leading: Icon(
            icon,
            color: AppColorData.bgIconColor,
          ),
          title: CommonText(
            text: title!,
            style: Theme.of(context).textTheme.titleMedium,
            maxlines: 2,
          ),
          subtitle: subtitle != null
              ? CommonText(
            text: subtitle!,
            style: Theme.of(context).textTheme.labelLarge,
            maxlines: 2,
          )
              : SizedBox(),
        ),
      ),
    );
  }
}