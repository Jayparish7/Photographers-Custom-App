
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
void customSnackBar({BuildContext? context,required String title, required String message}) {
  if (context != null) {
    Flushbar(
      title: title,
      message: message,
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Theme.of(context).primaryColor,
      ),
      leftBarIndicatorColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 5),
    )..show(context);
  }
}
