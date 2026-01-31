import 'package:flutter/material.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/traits/globals.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:toast/toast.dart';
import 'package:toastification/toastification.dart';


class ToastUtil {
  static showInternetRequired(BuildContext context) {
    Toast.show(S.of(context).internetConnectionRequired,
        duration: Toast.lengthShort, gravity: Toast.bottom);
  }

  static showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CommonCircularProgress(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showSnackBar(BuildContext context, String message) {
    Toast.show(message, duration: Toast.lengthShort,
        gravity: Toast.bottom,);
  }

  showShortToast(BuildContext context, String message) {
    //     ToastContext().init(context);
    showLog("the short toast ${context}");
    Toast.show(message, duration: Toast.lengthLong,
        gravity: Toast.bottom,);
  }

  static showLongToast(BuildContext context, String message) {
    Toast.show(message, duration: Toast.lengthLong, gravity: Toast.bottom);
  }
   static showSnackBarAtCurrentState(String message,{ SnackBarAction? actions,int? seconds}){
     if(snackbarKey.currentContext != null && !snackbarKey.currentContext!.mounted){
       return;
     }
     final SnackBar snackBar = SnackBar(
       duration: Duration(seconds: seconds ?? 2),
       action: actions,
       content: Text(message,style: TextStyle(color: Colors.white),),
     );
     snackbarKey.currentState?.showSnackBar(snackBar);
   }
  static showOkAlert() {}

  static getToastification(BuildContext context, String text,Color color,ToastificationType type){
    toastification.show(
        type: type,
        context: context, // optional if you use ToastificationWrapper
        title: Text(text),
        autoCloseDuration: const Duration(seconds: 8),showProgressBar: false
    );
  }


}
