import 'package:flutter/material.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import '../../color_constants.dart';
import '../../traits/common_widgets/custom_transition_widget.dart';
import '../album/photoselection/select/photo_selection_route.dart';

getPopUpMenu(BuildContext context, String? personCode, String? folderCode,
    String? eventCode, bool? isWithOutPersonSelection) {
  String? personCode;

  List<PopupMenuItem<int>> subPage = [
    PopupMenuItem<int>(
      value: 0,
      child: CommonText(
          text: 'undecided',
          style: TextStyle(color: AppColorData.appBarIconColor)),
    ),
    PopupMenuItem<int>(
      value: 1,
      child: CommonText(
          text: 'Selected',
          style: TextStyle(color: AppColorData.appBarIconColor)),
    ),
    PopupMenuItem<int>(
      value: 2,
      child: CommonText(
          text: 'Rejected',
          style: TextStyle(color: AppColorData.appBarIconColor)),
    ),
  ];
/*  List<PopupMenuItem<int>> mainPage = [
    PopupMenuItem<int>(
      value: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getIcon(Icons.home),

          const Text(
            "Home",
            style: textStyle,
          ),
        ],
      ),
    ),
    PopupMenuItem<int>(
      value: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getIcon(Icons.logout),
          const Text(
            "Logout",
            style: textStyle,
          ),
        ],
      ),
    ),
  ];*/
  return PopupMenuButton(
      color: Colors.black,
      child: Center(
          child: getIcon(Icons
              .menu) /*CommonText(
            text: "Menu  ",

          )*/
          ),
      itemBuilder: (context) {
        return /*isMain ? mainPage :*/ subPage;
      },
      onSelected: (value) async {
        print("selected == > $value");
        if (value == 0) {
          showLog('values are :: $personCode,$folderCode,$eventCode');
          /*Navigator.pushNamed(context, RoutePaths.studioList);*/
          /*   Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const StudioUserListRoute()),
          );*/
          await Navigator.push(
            context,
            CustomPageTransitionRoute(
              page: PhotoSelectionRoute(
                personCode: personCode,
                status: photoSelectionImageWaitingStatus,
                folderCode: folderCode ?? '',
                eventCode: eventCode,
                isWithOutPersonSelection: isWithOutPersonSelection,
              ),
            ),
          );
          showLog('values are :: $personCode,$folderCode,$eventCode');
        } else if (value == 1) {
          /* String code = await getStudioCode();*/
          if (/*code.isNotEmpty*/ 1 == 1) {
            if (context.mounted) {
              /* Navigator.pushNamed(context, RoutePaths.eventList,arguments: EventArguments(
                  code
              ));*/

              /*    Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EventListView(studioCode: code)),
              );*/
            }
          } else {
            if (context.mounted) {
              /*ToastUtil.getToast(context, "Error", "Can't navigate");*/
            }
          }
        } else if (value == 2) {
          /* OauthMethods.setLogout(context);*/
        }
        //  Navigator.pop(context);
      });
}

getIcon(IconData icon) {
  return Icon(
    icon,
    size: 20,
    color: AppColorData.appBarIconColor,
  );
}

/*Future<String> getStudioCode() async {
  return await PreferenceHelper.getString(eventCodePreferenceKey);
}*/
