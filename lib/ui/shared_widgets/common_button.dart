import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';

class CommonButton extends StatefulWidget {
  final String? buttonText;
  final double? width;
  final double? height;
  final Function? onPressCall;
  final bool? isOutLinedButton;
  final bool? showIcon;
  final IconData? icon;

  CommonButton(
      {Key? key,
      this.buttonText,
      this.width,
      this.height,
      this.onPressCall,
      this.isOutLinedButton = false,
      this.showIcon = false,
      this.icon})
      : super(key: key);

  @override
  _CommonButtonState createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppColorData.buttonElevation,
      shadowColor: AppColorData.buttonShadowColors,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          widget.onPressCall!();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: widget.isOutLinedButton!
                  ? BoxDecoration(border: Border.all(color: Colors.transparent))
                  : BoxDecoration(
                      gradient: LinearGradient(
                          begin: AppColorData.buttonGradientBegin,
                          end: AppColorData.buttonGradientEnd,
                          colors: AppColorData.buttonBackgroundColors,
                          stops: AppColorData.buttonBackgroundStops),
                      borderRadius: BorderRadius.circular(10)),
              width: widget.width,
              height: widget.height,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  (widget.showIcon == true)
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(
                            widget.icon,
                            size: 15,
                            color: AppColorData.elevatedButtonText,
                          ),
                        )
                      : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CommonText(
                      isButton: true,
                      text: widget.buttonText ?? "",
                      style: Theme.of(context).textTheme.labelLarge,
                      // fontSize: TextProperty.h3,
                    ),
                  ),
                ],
              ),
              /*Text(
                  widget.buttonText,
                  style:
                  const TextStyle(
                      color: Colors.white,
                      fontSize: 18, fontStyle: FontStyle.normal),
                ),*/
            ),
          ],
        ),
      ),
    );
  }
}
