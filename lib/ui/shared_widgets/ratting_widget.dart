import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:photomall_flutter/color_constants.dart';

class RattingWidget extends StatefulWidget {
  final Function rattingCallBack;
  final double initialRating;
  final bool gestureIgnore;

  RattingWidget(
      {Key? key,
      required this.rattingCallBack,
      required this.initialRating,
      this.gestureIgnore = false})
      : super(key: key);

  @override
  State<RattingWidget> createState() => _RattingWidgetState();
}

class _RattingWidgetState extends State<RattingWidget> {
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
        ignoreGestures: widget.gestureIgnore,
        initialRating: widget.initialRating,
        itemCount: 3,
        unratedColor: AppColorData.iconColor,
        itemBuilder: (context, index) {
          return Icon(
            Icons.star,
            color: AppColorData.iconSelectedColor,
          );
        },
        onRatingUpdate: (rating) {
          widget.rattingCallBack(rating);
        });
  }
}
