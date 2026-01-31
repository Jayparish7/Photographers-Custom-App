import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/route_constants.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/traits/common_widgets/common_card.dart';
import 'package:photomall_flutter/media/media_widget.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_appbar.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';

class GalleryDetailedRoute extends StatefulWidget {
  final String? eventCode;

  final String? categoryName;
  final GalleryDetailedRouteArguments arguments;

  GalleryDetailedRoute(
      {Key? key, this.eventCode, this.categoryName, required this.arguments})
      : super(key: key);

  @override
  State<GalleryDetailedRoute> createState() => _GalleryDetailedRouteState();
}

class _GalleryDetailedRouteState extends State<GalleryDetailedRoute> {
  @override
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showLog("_willPop is worked");
        Navigator.pushReplacementNamed(context, RoutePaths.Home);
        return true;
      },
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: AppColorData.backgroundGradientBegin,
                  end: AppColorData.backgroundGradientEnd,
                  colors: AppColorData.backgroundColors,
                  stops: AppColorData.appBackgroundStops)),
          child: Scaffold(
            appBar: CommonAppBar(
              title: widget.arguments.categoryName,
            ),
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: CommonCard(
                          shape: BorderRadius.circular(8),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: CommonText(
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.normal,
                                    text: S.of(context).category,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    // fontSize: TextProperty.hint
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.filter_alt,
                                size: 20,
                                color: AppColorData.iconSelectedColor,
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {
                          showLog("Category list view :: pressed");
                          Navigator.pushNamed(context, RoutePaths.CategoryList);
                        },
                      ),
                    ],
                  ),
                ),
                MediaWidget(
                  eventCode: widget.arguments.eventCode,
                  categoryName: [],
                   isFromPrivate: false,
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
/*  Future<bool> _willPop() async {
    showLog("_willPop is worked");
  return  await Navigator.pushReplacementNamed(
        context,
        RoutePaths.Home);
  }*/
/*  getAppBarTitle()  {
    EventModelDao eventModelDao = EventModelDao();
    // get event name by event code
    return StreamBuilder<appDb.Event>(
        stream: eventModelDao.streamSingleEventByCode(widget.eventCode),
        builder: (BuildContext context, AsyncSnapshot<appDb.Event> snapshot) {
         if(!snapshot.hasData || snapshot.hasError){
           return SizedBox();
         }
          return CommonText(
            text: snapshot.data.categoryName,
            color: AppColorData.appBarTitleColor,
            fontSize: TextProperty.h3,);
      }
    );
  }*/
}

class GalleryDetailedRouteArguments {
  String eventCode;
  String categoryName;

  GalleryDetailedRouteArguments(
      {required this.eventCode, required this.categoryName});
}
