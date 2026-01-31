import 'package:flutter/material.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';

class CommonTextButton extends StatefulWidget {
  final String buttonText;
  final Color? color;
  final double? width;
  final Function onPressCall;
  final bool underline;

  const CommonTextButton(
      {Key? key,
      required this.buttonText,
      this.color,
      this.width,
      required this.onPressCall,
      this.underline = false})
      : super(key: key);

  @override
  State<CommonTextButton> createState() => _CommonTextButtonState();
}

class _CommonTextButtonState extends State<CommonTextButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CommonText(
          isTextButton: true,
          underline: widget.underline,
          text: widget.buttonText,
          // color: widget.color,
          style: Theme.of(context).textTheme.labelLarge,
          // fontSize: TextProperty.h3,
        ),
      ),
      onTap: () {
        widget.onPressCall();
      },
    );
  }
}
