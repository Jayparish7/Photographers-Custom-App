import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/event_controller.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_button.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';

import '../../generated/l10n.dart';

class CustomDialog extends StatefulWidget {
  final Function callBack;
  final List<ArchivedModel> archivedEvents;

  const CustomDialog(
      {Key? key, required this.callBack, required this.archivedEvents})
      : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  bool canUpload = false;
  List<bool>? _isChecked;
  List<ArchivedModel> unarchivedEvents = [];

  @override
  void initState() {
    super.initState();
    _isChecked = List<bool>.filled(widget.archivedEvents.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonText(
            text: S.of(context).archivedEvents,
            color: AppColorData.titleTextColor,
            fontWeight: FontWeight.bold,
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.cancel))
        ],
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView(shrinkWrap: true, padding: EdgeInsets.all(8.0), children: [
              ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.archivedEvents.length,
                itemBuilder: (_, index) {
                  return CheckboxListTile(
                    checkColor: AppColorData.iconSelectedColor,
                    title: CommonText(
                      text: widget.archivedEvents[index].name!,
                      color: AppColorData.normalTextColor,
                      fontWeight: FontWeight.normal,
                    ),
                    value: _isChecked![index],
                    onChanged: (isSelected) {
                      setState(() {
                        _isChecked![index] = isSelected!;
                        if (isSelected) {
                          unarchivedEvents.add(widget.archivedEvents[index]);
                        } else {
                          unarchivedEvents.removeWhere((element) =>
                              element.code ==
                              widget.archivedEvents[index].code);
                        }
                      });
                    },
                  );
                },
              ),
            ]),
          ],
        ),
      ),
      actions: <Widget>[
        CommonButton(
          height: 40,
          onPressCall: () {
            widget.callBack(unarchivedEvents);
            Navigator.pop(context);
          },
          buttonText: S.of(context).retrieve,
        )
      ],
    );
  }
}
