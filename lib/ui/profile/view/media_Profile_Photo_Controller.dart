import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/media/media_view_model.dart';
import 'package:photomall_flutter/ui/profile/view/bottom_sheet_option.dart';

class MediaProfilePhotoController {
  showBottomSheetForProfileImage(BuildContext context,
      [MediaRouteViewModel? model, Function? imageCallBack]) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      context: context,
      backgroundColor: AppColorData.cardBackgroundColors[0],
      //BottomSheetHelper.getBackgroundColor(context),
      builder: (BuildContext bc) {
        return Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Wrap(
            children: <Widget>[
              BottomSheetOption(
                icon: Icons.photo_camera,
                title: S.of(context).takePhoto,
                onPressed: () async {
                  try {
                    await imageCallBack!(ImageSource.camera, model);
                    Navigator.pop(context);
                  } catch (e) {}
                },
              ),
              /* BottomSheetOption(
                icon: Icons.image,
                title: S.of(context).chooseFromGallery,
                onPressed: () async {
                  try {
                    await   imageCallBack!(ImageSource.gallery, model);
                    Navigator.pop(context);

                  } catch (e) {}
                },
              ),*/
              BottomSheetOption(
                icon: Icons.cancel,
                title: S.of(context).cancel,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
