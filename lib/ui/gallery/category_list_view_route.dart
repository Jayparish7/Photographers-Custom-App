import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/constants/route_constants.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/traits/common_widgets/common_card.dart';
import 'package:photomall_flutter/traits/common_widgets/custom_transition_widget.dart';
import 'package:photomall_flutter/ui/gallery/gallery_detailed_route.dart';
import 'package:photomall_flutter/ui/shared_widgets/common.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_appbar.dart';
import 'package:photomall_flutter/driftdb/dao/event_dao.dart' as eventDao;
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import '../../core/constants/common_constants.dart';

class CategoryListRoute extends StatefulWidget {
  const CategoryListRoute({Key? key}) : super(key: key);

  @override
  State<CategoryListRoute> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryListRoute> {
  Stream<List<appDb.Event>>? events;

  @override
  void initState() {
    prepareCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(
        title: S.of(context).category,
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: AppColorData.backgroundGradientBegin,
                  end: AppColorData.backgroundGradientEnd,
                  colors: AppColorData.backgroundColors,
                  stops: AppColorData.appBackgroundStops)),
          child: StreamBuilder<List<appDb.Event>>(
              stream: events,
              builder: (BuildContext context,
                  AsyncSnapshot<List<appDb.Event>> snapshot) {
                if (!snapshot.hasData || snapshot.hasError) {
                  return EmptyView(
                    text: S.of(context).noDetailAvailable,
                    iconData: Icons.assignment,
                  );
                }
                if (snapshot.hasData) {
                  return snapshot.data!.length == 0
                      ? EmptyView(
                          text: S.of(context).noDetailAvailable,
                          iconData: Icons.assignment,
                        )
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CustomItemTransition(
                              duration: itemTransitionDuration,
                              delay: itemTransitionDelay * index,
                              child: CommonCard(
                                child: ListTile(
                                  title: CommonText(
                                    fontWeight: FontWeight.normal,
                                    text: snapshot.data![index].categoryName,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    // fontSize: TextProperty.hint
                                  ),
                                  onTap: () {
                                    showLog(
                                        "Category view :: event code where ${snapshot.data![index].code}");
                                    Navigator.pushNamed(
                                        context, RoutePaths.GalleryDetailed,
                                        arguments:
                                            GalleryDetailedRouteArguments(
                                                eventCode:
                                                    snapshot.data![index].code,
                                                categoryName: snapshot
                                                    .data![index]
                                                    .categoryName));
                                  },
                                ),
                              ),
                            );
                          },
                        );
                }
                return const SizedBox();
              })),
    ));
  }

  void prepareCategoryList() {
    eventDao.EventModelDao eventModelDao = eventDao.EventModelDao();
    // get gallery events
    events = eventModelDao.streamGalleryEvent();
  }
}
