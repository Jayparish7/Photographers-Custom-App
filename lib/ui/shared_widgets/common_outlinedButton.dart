import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';

class CommonOutlinedButton extends StatefulWidget {
  final String? text;
  final Function onPressCall;
  final IconData? icon;

  const CommonOutlinedButton(
      {Key? key, this.text, required this.onPressCall, this.icon})
      : super(key: key);

  @override
  State<CommonOutlinedButton> createState() => _CommonOutlinedButtonState();
}

class _CommonOutlinedButtonState extends State<CommonOutlinedButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        side: BorderSide(color: AppColorData.outLineButtonBorder),
      ),
      onPressed: () {
        widget.onPressCall();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.icon,
            size: 15,
            color: AppColorData.bgIconColor,
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: CommonText(
                text: widget.text ?? "",
                style: Theme.of(context).textTheme.titleMedium,
                maxlines: null,

                //fontSize: TextProperty.hint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
