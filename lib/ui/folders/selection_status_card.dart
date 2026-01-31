import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/traits/common_widgets/custom_transition_widget.dart';
import 'package:photomall_flutter/ui/album/photoselection/select/photo_selection_route.dart';
import 'package:photomall_flutter/ui/shared/ui_helpers.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../generated/l10n.dart';

class photoSelectionCardWidget extends StatefulWidget {
  final int? waitingCount;
  final int? rejectedCount;
  final int? selectedCount;
  final String? folderCode;
  final String? personCode;
  final String? eventCode;
  final String? eventCodeForDownload;
  final bool isWithOutPersonSelection;
  final Function callBack;

  photoSelectionCardWidget(
      {Key? key,
      this.waitingCount,
      this.rejectedCount,
      this.selectedCount,
      this.folderCode,
      required this.callBack,
      this.personCode,
      this.eventCode,
      this.isWithOutPersonSelection = false,
      this.eventCodeForDownload})
      : super(key: key);

  @override
  State<photoSelectionCardWidget> createState() =>
      _photoSelectionCardWidgetState();
}

class _photoSelectionCardWidgetState extends State<photoSelectionCardWidget> {
  @override
  void initState() {
    showLog(
        "person code 11 ${widget.personCode} \n waitingCount = ${widget.waitingCount}\n rejectedCount = ${widget.rejectedCount}\nselectedCount =${widget.selectedCount}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ZoomTapAnimation(
              beginCurve: Curves.bounceIn,
              endCurve: Curves.bounceInOut,
              begin: 1,end: .8,
              child: cardChild(
                widget.waitingCount,
                EvaIcons.clock,
                S.of(context).undecided,
                context: context,
                CommonText(
                  isUndecidedTitle: true,
                  text: '${widget.waitingCount}',
                  // style: Theme.of(context).textTheme.headlineMedium.copyWith(color: Color(0xfffeba0a),fontWeight: FontWeight.bold),
                ),
                cardColor1: AppColorData.selectionStatusUndecidedCard,
                cardColor2: AppColorData.selectionStatusUndecidedCard,
                iconColor: AppColorData.selectionStatusCardUndecidedText,
                onTap: () async {
                  showLog(
                      "the the person code where eventCodeForDownload person code where 1 ${widget.eventCodeForDownload}");

                  await Navigator.push(
                    context,
                    CustomPageTransitionRoute(
                      page: PhotoSelectionRoute(
                        eventCodeForDownload: widget.eventCodeForDownload,
                        personCode: widget.personCode,
                        status: photoSelectionImageWaitingStatus,
                        folderCode: widget.folderCode!,
                        eventCode: widget.eventCode,
                        isWithOutPersonSelection: widget.isWithOutPersonSelection,
                      ),
                    ),
                  );

                  widget.callBack();
                },
              ),
            ),
            UIHelper.verticalSpaceSmall,
            ZoomTapAnimation(
              beginCurve: Curves.bounceIn,
              endCurve: Curves.bounceInOut,
              begin: 1,end: .8,
              child: cardChild(
                widget.selectedCount,
                EvaIcons.checkmarkCircle2,
                S.of(context).selected_photos,
                context: context,
                CommonText(
                  isSelectedTitle: true,
                  text: widget.selectedCount.toString(),
                ),
                cardColor2: AppColorData.selectionStatusSelectedCard,
                cardColor1: AppColorData.selectionStatusSelectedCard,
                iconColor: AppColorData.selectionStatusCardSelectedText,
                onTap: () async {
                  await Navigator.push(
                    context,
                    CustomPageTransitionRoute(
                      page: PhotoSelectionRoute(
                        eventCodeForDownload: widget.eventCodeForDownload,
                        personCode: widget.personCode,
                        status: photoSelectionImageSelectedStatus,
                        folderCode: widget.folderCode!,
                        eventCode: widget.eventCode,
                        isWithOutPersonSelection: widget.isWithOutPersonSelection,
                      ),
                    ),
                  );
                  widget.callBack();
                },
              ),
            ),
            UIHelper.verticalSpaceSmall,
            ZoomTapAnimation(
              beginCurve: Curves.bounceIn,
              endCurve: Curves.bounceInOut,
              begin: 1,end: .8,
              child: cardChild(
                widget.rejectedCount,
                EvaIcons.closeCircle,
                S.of(context).rejected_photos,
                context: context,
                CommonText(
                  isRejectedTitle: true,
                  text: widget.rejectedCount.toString(),
                ),
                cardColor1: AppColorData.selectionStatusRejectedCard,
                cardColor2: AppColorData.selectionStatusRejectedCard,
                iconColor: AppColorData.selectionStatusCardRejectedText,
                onTap: () async {
                  await Navigator.push(
                    context,
                    CustomPageTransitionRoute(
                      page: PhotoSelectionRoute(
                        eventCodeForDownload: widget.eventCodeForDownload,
                        isWithOutPersonSelection: widget.isWithOutPersonSelection,
                        personCode: widget.personCode,
                        status: photoSelectionImageRejectedStatus,
                        folderCode: widget.folderCode!,
                        eventCode: widget.eventCode,
                      ),
                    ),
                  );
                  widget.callBack();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

/*  Widget cardChild(count, icon, title, child,
      {required Color cardColor1,
      required Color cardColor2,
      required GestureTapCallback onTap,
      required Color iconColor}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        elevation: 5,
        //AppColorData.cardElevation,
        shadowColor: AppColorData.cardShadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: Theme.of(context).primaryColor.withOpacity(0.5),
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cardColor1, cardColor2],
                  //AppColorData.selectionStatusCardBackground,
                  begin: AppColorData.selectionStatusCardGradientBegin,
                  end: AppColorData.selectionStatusCardGradientEnd,
                  stops: AppColorData.selectionStatusCardStops,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 4.0, top: 8, left: 1, right: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            color: iconColor,
                            size: 18,
                          ),
                          SizedBox(
                            width: 0.1,
                          ),
                          Text(
                            title,
                            style: TextStyle(
                              color: iconColor,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 80,
                      width: 115,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Center(
                        child: child,
                      ),
                    ),
                    */ /*Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CommonText(
                        text: title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),*/ /*
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }*/

  Widget cardChild(
    count,
    icon,
    title,
    child, {
    required Color cardColor1,
    required Color cardColor2,
    required GestureTapCallback onTap,
    required Color iconColor,
    required BuildContext context, // Pass context to access MediaQuery
  }) {
    // Fetch the screen size and orientation
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Define scale factors based on orientation
    final widthScale =
        isLandscape ? screenHeight / 375 : screenWidth / 375; // Scale for width
    final heightScale = isLandscape
        ? screenWidth / 812
        : screenHeight / 812; // Scale for height

    return Padding(
      padding: EdgeInsets.all(2.0 * widthScale),
      child: Card(
        elevation: 5,
        shadowColor: AppColorData.cardShadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10 * widthScale),
          ),
        ),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10 * widthScale),
          splashColor: Theme.of(context).primaryColor.withOpacity(0.5),
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10 * widthScale),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cardColor1, cardColor2],
                  begin: AppColorData.selectionStatusCardGradientBegin,
                  end: AppColorData.selectionStatusCardGradientEnd,
                  stops: AppColorData.selectionStatusCardStops,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 4.0 * heightScale,
                  top: 8 * heightScale,
                  left: 1 * widthScale,
                  right: 1 * widthScale,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            color: iconColor,
                            size: 18 * widthScale,
                          ),
                          SizedBox(
                            width: 2 * widthScale,
                          ),
                          Text(
                            title,
                            style: TextStyle(
                              color: iconColor,
                              fontSize: 18 * widthScale,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 80 * heightScale,
                      width: 105 * widthScale,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10 * widthScale),
                          bottomRight: Radius.circular(10 * widthScale),
                        ),
                      ),
                      child: Center(
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
