import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';

class CommonText extends StatefulWidget {
  final bool? isWhiteText;
  final String text;
  final double? fontSize;
  final double? textScaleFactor;
  Color? color;
  final int? maxlines;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final bool underline;
  final TextOverflow? overflow;
  final TextStyle? style;
  final bool isAppBar;
  final bool isSideDrawer;
  final bool isBottomNavbar;
  final bool isSelected;
  final bool isButton;
  final bool isTextButton;
  final bool isUndecidedTitle;
  final bool isSelectedTitle;
  final bool isRejectedTitle;
  final bool isHeadingHighlightText;
  final bool isBodyHighlightedText;
  final bool isHelpText;
  final bool isCard;
  final bool isHighlightedCard;
  final bool isLined;
  final bool isHighlightedRedSubtitle;
  final bool isHighlightedGreenSubtitle;

  CommonText({
    Key? key,
    required this.text,
    this.maxlines,
    this.fontSize,
    this.textScaleFactor,
    this.color,
    this.textAlign,
    this.fontWeight,
    this.underline = false,
    this.isWhiteText = false,
    this.overflow,
    this.style,
    this.isAppBar = false,
    this.isSideDrawer = false,
    this.isBottomNavbar = false,
    this.isSelected = false,
    this.isButton = false,
    this.isTextButton = false,
    this.isSelectedTitle = false,
    this.isUndecidedTitle = false,
    this.isRejectedTitle = false,
    this.isHeadingHighlightText = false,
    this.isHelpText = false,
    this.isBodyHighlightedText = false,
    this.isCard = false,
    this.isHighlightedCard = false,
    this.isLined = false,
    this.isHighlightedRedSubtitle = false,
    this.isHighlightedGreenSubtitle = false,
  }) : super(key: key);

  @override
  State<CommonText> createState() => _CommonTextState();
}

class _CommonTextState extends State<CommonText> {
  @override
  Widget build(BuildContext context) {
    if (this.widget.color == null) {
      //this.color = AppColor.get(context, ColorKeys.primaryTextColor);
    }
    return Text(
      widget.text,
      textAlign: widget.textAlign,
      textScaleFactor: widget.textScaleFactor,
      overflow: widget.overflow,
      maxLines: widget.maxlines,
      style: /*widget.style*/ getTextStyle(context),
    );
  }

  TextStyle? getTextStyle(BuildContext context) {
    // _headLineMedium only used photo selection status cards
    TextStyle? _headLineMedium = Theme.of(context).textTheme.headlineMedium;
    TextStyle? _headLineSmall = Theme.of(context).textTheme.headlineSmall;
    TextStyle? _titleLarge = Theme.of(context).textTheme.titleLarge;
    TextStyle? _titleMedium = Theme.of(context).textTheme.titleMedium;
    TextStyle? _labelLarge = Theme.of(context).textTheme.labelLarge;
    TextStyle? _bodyMedium = Theme.of(context).textTheme.bodyMedium;
    TextStyle? _bodySmall = Theme.of(context).textTheme.bodySmall;

    if (!widget.isButton &&
        !widget.isAppBar &&
        !widget.isBottomNavbar &&
        !widget.isSideDrawer &&
        !widget.isTextButton &&
        !widget.isSelectedTitle &&
        !widget.isUndecidedTitle &&
        !widget.isRejectedTitle &&
        !widget.isHeadingHighlightText &&
        !widget.isHelpText &&
        !widget.isBodyHighlightedText &&
        !widget.isCard &&
        !widget.isHighlightedRedSubtitle &&
        !widget.isHighlightedGreenSubtitle) {
      return widget.style;
    } else {
      if (widget.isCard) {
        if (widget.isHighlightedCard) {
          return widget.underline
              ? Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppColorData.cardHighlightedTextColour,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline)
              : Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppColorData.cardHighlightedTextColour,
                  fontWeight: FontWeight.bold);
        } else {
          return widget.isLined
              ? Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColorData.cardNormalTextColour,
                  decoration: TextDecoration.lineThrough)
              : Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: AppColorData.cardNormalTextColour);
        }
      }

      if (widget.isAppBar) {
        return _titleLarge!.copyWith(
          color: AppColorData.appBarTitleColor,
        );
      } else if (widget.isBottomNavbar) {
        if (widget.isSelected) {
          return _bodySmall!
              .copyWith(color: AppColorData.bottomNavigationSelectedTextColor);
        } else {
          return _bodySmall!
              .copyWith(color: AppColorData.bottomNavTextUnSelectedColor);
        }
      } else if (widget.isSideDrawer) {
        if (widget.isSelected) {
          return _titleLarge!
              .copyWith(color: AppColorData.sideDrawerSelectedTextColor);
        } else {
          return _titleMedium!
              .copyWith(color: AppColorData.sideDrawerUnselectedTextColor);
        }
      } else if (widget.isButton) {
        return _labelLarge!.copyWith(
          color: AppColorData.buttonTextColors,
        );
      } else if (widget.isTextButton) {
        return widget.underline == true
            ? _labelLarge!.copyWith(
                color: AppColorData.textButton,
                decoration: TextDecoration.underline)
            : _labelLarge!.copyWith(
                color: AppColorData.textButton,
              );
      } else if (widget.isUndecidedTitle) {
        return _headLineMedium!.copyWith(
            color: AppColorData.selectionStatusCardUndecidedText,
            fontWeight: FontWeight.bold);
      } else if (widget.isSelectedTitle) {
        return _headLineMedium!.copyWith(
            color: AppColorData.selectionStatusCardSelectedText,
            fontWeight: FontWeight.bold);
      } else if (widget.isRejectedTitle) {
        return _headLineMedium!.copyWith(
            color: AppColorData.selectionStatusCardRejectedText,
            fontWeight: FontWeight.bold);
      } else if (widget.isHeadingHighlightText) {
        if (widget.style == _headLineSmall) {
          showLog(".isHighlightText is true");
          return _headLineSmall!.copyWith(
            color: AppColorData.dateAndEventTitle,
          );
        } else if (widget.style == _titleMedium) {
          return _titleMedium!.copyWith(color: AppColorData.monthAndYearColor);
        } else if (widget.style == _labelLarge) {
          return _labelLarge!.copyWith(
            color: AppColorData.dayColor,
          );
        }
      } else if (widget.isHelpText) {
        return _bodyMedium!.copyWith(color: AppColorData.helpText);
      } else if (widget.isBodyHighlightedText) {
        return _labelLarge!.copyWith(color: AppColorData.dateAndEventTitle);
      } else if (widget.isHighlightedRedSubtitle) {
        return _bodyMedium!.copyWith(color: Colors.red);
      } else if (widget.isHighlightedGreenSubtitle) {
        return _bodyMedium!.copyWith(color: Colors.green);
      }
    }
    return null;
  }
}

class UniqueText extends StatefulWidget {
  final String text;
  final bool? isTitle;
  final bool? isBold;
  final double? fontSize;
  final double? letterSpacing;

  const UniqueText(
      {super.key,
      required this.text,
      this.isTitle = false,
      this.fontSize,
      this.letterSpacing,
      this.isBold = true});

  @override
  State<UniqueText> createState() => _UniqueTextState();
}

class _UniqueTextState extends State<UniqueText> {
  @override
  Widget build(BuildContext context) {
    return (widget.isTitle == true)
        ? Text(
            widget.text,
            style: TextStyle(
              color: AppColorData.appBarTextColor,
              fontSize: 14,
              fontWeight:
                  widget.isBold == true ? FontWeight.bold : FontWeight.normal,
              letterSpacing: widget.letterSpacing,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 1.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 1.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
            ),
          )
        : Text(
            widget.text,
            style: TextStyle(
              letterSpacing: widget.letterSpacing,
              color: AppColorData.appBarTextColor,
              fontSize: widget.fontSize != null ? widget.fontSize : 16,
              fontWeight: FontWeight.bold,

            ),
          );
  }
}
