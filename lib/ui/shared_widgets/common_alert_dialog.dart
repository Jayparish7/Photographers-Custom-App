import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';

class CommonAlertDialog extends StatefulWidget {
  final String? title;
  final Widget? titleWidget;
  final String? content;
  final Widget? contentWidget;
  final List<Widget>? actions;
  final bool canPop;

  const CommonAlertDialog({
    Key? key,
    this.title,
    this.content,
    this.actions,
    this.titleWidget,
    this.contentWidget,
    this.canPop = true,
  }) : super(key: key);

  @override
  State<CommonAlertDialog> createState() => _CommonAlertDialogState();
}

class _CommonAlertDialogState extends State<CommonAlertDialog> {
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    showLog("the data where update ${widget.actions} ");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.canPop,
      child:    /*(widget.title!='Enter OTP')
          ?*/ AlertDialog(
              backgroundColor: AppColorData.alertDialogBg,
              scrollable: true,
              titlePadding: EdgeInsets.all(10),
              contentPadding: EdgeInsets.all(10),
              title: (widget.title == null)
                  ? widget.titleWidget
                  : CommonText(
                      text: widget.title ?? "",
                      textAlign: TextAlign.left,
                      //color: Theme.of(context).primaryColorDark,
                      style: Theme.of(context).textTheme.titleLarge,
                      //fontSize: TextProperty.h1,
                    ),
              content: (widget.content == null)
                  ? widget.contentWidget
                  : CommonText(
                      text: widget.content ?? "",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyLarge,
                      //fontSize: TextProperty.h2,
                    ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              actions: widget.actions,
            )
         /* : GiffyDialog.image(
        backgroundColor: AppColorData.alertDialogBg,
        scrollable: true,
        titlePadding: EdgeInsets.all(18),
        contentPadding: EdgeInsets.all(18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
              Image.asset('assets/images/screen_shot.gif',
                height: 200,
                fit: BoxFit.fill,color: AppColorData.bgIconColor,
              ),
              title: (widget.title == null)
                  ? widget.titleWidget
                  : CommonText(
                text: widget.title ?? "",
                textAlign: TextAlign.left,
                //color: Theme.of(context).primaryColorDark,
                style: Theme.of(context).textTheme.titleLarge,
                //fontSize: TextProperty.h1,
              ),
              content: (widget.content == null)
                  ? widget.contentWidget
                  : CommonText(
                text: widget.content ?? "",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyLarge,
                //fontSize: TextProperty.h2,
              ),
              actions:widget.actions,
            ),*/
    );
  }
}
