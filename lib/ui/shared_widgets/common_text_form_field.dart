import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photomall_flutter/color_constants.dart';

class CommonTextField extends StatefulWidget {
  final TextEditingController controller;
  final Widget? cardIconChild;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final TextStyle? labelStyle;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final bool? autofocus;
  final bool? readOnly;
  final bool? expands;
  final bool? showCursor;
  final bool? enabled;

  const CommonTextField({
    Key? key,
    required this.controller,
    this.cardIconChild,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.inputFormatters,
    this.onSubmitted,
    this.autofocus = false,
    this.readOnly = false,
    this.expands = false,
    this.showCursor = false,
    this.enabled = false,
    this.textInputAction,
    this.labelStyle,
  }) : super(key: key);

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: widget.readOnly ?? false,
      expands: widget.expands ?? false,
      showCursor: widget.showCursor,
      enabled: widget.enabled,
      autofocus: widget.autofocus ?? false,
      focusNode: widget.focusNode,
      style: Theme.of(context).textTheme.titleMedium,
      controller: widget.controller,
      cursorColor: AppColorData.textFormFieldCursor,
      inputFormatters: widget.inputFormatters,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        border: InputBorder.none,
        suffixIcon: Padding(
          padding: const EdgeInsets.all(5.0),
          child: widget.cardIconChild,
        ),
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        /*TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color:
              AppColorData.normalTextColor),*/
        labelText: widget.labelText,
        labelStyle: widget.labelStyle,
        hintText: widget.hintText,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
          borderRadius: BorderRadius.circular(0.0),
        ),
      ),
      maxLines: null,
      onChanged: widget.onChanged,
      onSubmitted: widget.onChanged,
    );
  }
}
