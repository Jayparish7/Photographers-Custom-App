import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';

class ImageNotAvailable extends StatelessWidget {
  const ImageNotAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.image_not_supported,
                    color: AppColorData.iconSelectedColor,
                    size: 50,
                  ),
                  CommonText(
                    text: S.of(context).imageNotAvailable,
                    fontWeight: FontWeight.normal,
                    color: AppColorData.titleTextColor,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
