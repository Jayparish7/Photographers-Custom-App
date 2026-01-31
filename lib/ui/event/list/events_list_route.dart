import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/PhotomallController/photomall_studio_data_controller.dart';
import 'package:photomall_flutter/controllers/event_controller.dart';
import 'package:photomall_flutter/core/Utils/file_util.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/route_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/traits/common_widgets/cached_network_image_widget.dart';
import 'package:photomall_flutter/traits/common_widgets/common_card.dart';
import 'package:photomall_flutter/traits/common_widgets/custom_transition_widget.dart';
import 'package:photomall_flutter/ui/contactus/contact_us_data_view.dart';
import 'package:photomall_flutter/ui/event/detail/event_details_route.dart';
import 'package:photomall_flutter/ui/event/list/event_list_route_view_model.dart';
import 'package:photomall_flutter/ui/routes/account_delete_route.dart';
import 'package:photomall_flutter/ui/shared_widgets/common.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_alert_dialog.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_appbar.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_button.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../core/constants/studio_config_constants.dart';
import '../../../traits/utils/storage_utils.dart';
import '../../base/base_widget.dart';
import '../../menu_button.dart';

class EventsListRoute extends StatefulWidget {
  final EventsListArguments arguments;

  EventsListRoute({Key? key, required this.arguments}) : super(key: key);

  @override
  _EventsListRouteState createState() => _EventsListRouteState();
}

class _EventsListRouteState extends State<EventsListRoute>
    with TickerProviderStateMixin {
  BaseWidget<EventListRouteViewModel>? baseWidget;
  int index = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    showLog('message the archive status where');
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
    getDeletedStatus();
  }

  getDeletedStatus() async {
    var pref = await SharedPreferences.getInstance();
    var deleteKey = pref.getBool(isDeletedKey) ?? false;
    index = await PreferenceHelper.getInt(eventListPreIndex);
    showLog('eventListPreIndex $index');
    if (deleteKey == true) {
      Future.delayed(Duration(microseconds: 200)).then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DeleteRoute(
                      isFromLogin: true,
                    )));
      });
    }
    await pref.setBool(isDeletedKey, false);
  }

  FileUtil fileUtil = FileUtil();

  @override
  Widget build(BuildContext context) {
    baseWidget = BaseWidget<EventListRouteViewModel>(
      model: EventListRouteViewModel(
        apiHandler: Provider.of<ApiHelper>(context, listen: false),
        context: context,
      ),
      onModelReady: (model) => model.getEventsDetailsFromDb(),
      builder: (context, model, child) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: AppColorData.backgroundColors,
                  begin: AppColorData.backgroundGradientBegin,
                  end: AppColorData.backgroundGradientEnd,
                  stops: AppColorData.appBackgroundStops)),
          child: Scaffold(
              floatingActionButton: widget.arguments.isArchivedEven
                  ? null
                  : (!isPhotomallApp)
                      ? addEventButton(model: model)
                      : null,
              appBar: widget.arguments.isArchivedEven
                  ? CommonAppBar(title: S.of(context).archivedEvents)
                  : null,
              backgroundColor: Colors.transparent,
              body: model.isLoading
                  ? CommonCircularProgress()
                  : ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 18),
                          child: Row(
                            children: [
                              (AppColorData.menuPosition != true)
                                  ? SizedBox()
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: MenuButton(),
                                    ),
                              UniqueText(
                                text: !isPhotomallApp
                                    ? S.of(context).events
                                    : appStudioName ?? '$appName',
                                letterSpacing: 2.5,
                              ),
                              Spacer(),
                              !isPhotomallApp
                                  ? IconButton(
                                      splashRadius: 18,
                                      onPressed: () async {
                                        showLog('message Spacer');
                                        await Navigator.pushNamed(
                                            context, RoutePaths.AddEvent);
                                      },
                                      icon: Icon(
                                        Icons.qr_code_scanner,
                                        size: 28,
                                        color: AppColorData.appBarTextColor,
                                      ),
                                    )
                                  : SizedBox(),
                              (AppColorData.menuPosition == true)
                                  ? SizedBox()
                                  : MenuButton(),
                            ],
                          ),
                        ),
                        FutureBuilder<bool>(
                            future: model.isPageVisible(),
                            builder: (ctx, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CommonCircularProgress();
                              }
                              if (!snapshot.hasData ||
                                  snapshot.hasError ||
                                  snapshot.data == false) {
                                return EmptyView(
                                  text: S.of(context).noEventAvailable,
                                  iconData: Icons.event_note_sharp,
                                );
                              }
                              return Padding(
                                padding: EdgeInsets.only(top: 25, bottom: 55.0),
                                child: Column(
                                  children: [
                                    widget.arguments.isArchivedEven == true
                                        ? (model.archivedEvent.value.isEmpty)
                                            ? EmptyView(
                                                iconData:
                                                    Icons.event_note_sharp,
                                                text: S
                                                    .of(context)
                                                    .noEventAvailable,
                                              )
                                            : eventListViewBuilder(
                                                model.archivedEvent.value,
                                                model,
                                                false)
                                        : eventListViewBuilder(
                                            model.userEvents.value,
                                            model,
                                            true),
                                    widget.arguments.isArchivedEven
                                        ? SizedBox()
                                        : demoEventListViewBuilder(
                                            model.demoEvent.value, model),
                                  ],
                                ),
                              );
                            })
                      ],
                    )),
        );
      },
    );
    return baseWidget!;
  }

  @override
  void dispose() {
    showLog('dispose :: event list route');
    if (baseWidget != null && baseWidget?.model != null) {
      //baseWidget.model.dispose();
      baseWidget!.model.destroy();
    }
    _animationController.dispose();
    super.dispose();
  }

  getUserCoverImage() {}

  deleteEvent(BuildContext context, String eventCode) async {
    ToastContext().init(context);
    ToastUtil toastUtil = ToastUtil();
    EventController eventController = EventController();
    showLog("the event should be removed ${eventCode}");

    /// call delete api
    try {
      PhotomallApis photomallApis = PhotomallApis(null);

      /*CommonResponse response =*/
      await photomallApis.deleteEvent(eventCode: eventCode);
    } catch (e) {
      showLog("Event List route deleting event \n${e}");
    }

    bool status = await eventController.deleteEvent(eventCode);
    if (status) {
      await toastUtil.showShortToast(
          context, S.of(context).deletedSuccessfully);
    } else {
      await toastUtil.showShortToast(context, S.of(context).failedToDelete);
    }
    // Navigator.pop(context);
  }

  unarchiveEvent(BuildContext context, String code) async {
    ToastUtil toast = ToastUtil();
    ToastContext().init(context);
    EventController eventController = EventController();
    bool status = await eventController.eventArchiveOrUnArchive(
        eventCode: code, archiveStatus: false);
    if (status) {
      toast.showShortToast(context, S.of(context).unarchivedSuccessfully);
    } else {
      toast.showShortToast(context,
          "${S.of(context).failedToUnarchived}\n${S.of(context).tryAfterSomeTime}");
    }
  }

  Widget emptyEvent() {
    showLog("noEventAvailable ");
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note_sharp,
            color: AppColorData.iconSelectedColor,
            size: 70,
          ),
          CommonText(
            text: S.of(context).noEventAvailable,
            color: AppColorData.titleTextColor,
            fontWeight: FontWeight.bold,
            //fontSize: TextProperty.h3,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }

  Future<void> onTapUserEvent(Demo data, EventListRouteViewModel model) async {
    if (widget.arguments.isArchivedEven) {
      ToastContext().init(context);
      ToastUtil toastUtil = ToastUtil();
      toastUtil.showShortToast(context, S.of(context).pleaseUnarchiveToOpen);
      return;
    } else {
      EventController eventController = EventController();
      eventController.toggleEventViewed(
          eventCode: data.event!.code, status: false);
      if (data.event!.published) {
        await Navigator.pushNamed(
          context,
          RoutePaths.EventDetails,
          arguments: EventDetailsRouteArguments(
            eventCode: data.event!.code,
          ),
        );
        Navigator.pushReplacementNamed(context, RoutePaths.Home);
        /*Navigator.push(
          context,FadeRoute(
          page: EventDetailsRoute(
            eventCode: data.event.code,
          ),
        ),
        );*/
      } else {}
    }
  }

  Widget eventListViewBuilder(
      List<Demo?> event, EventListRouteViewModel model, bool isUserEvent) {
    double radius = model.borderRadius;
    bool hasInternet = false;

    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: event.length,
        itemBuilder: (BuildContext context, int ind) {
          int index = event.length - 1 - ind;
          Animation<double> animation;
          animation = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              reverseCurve: Curves.easeInOut,
              parent: _animationController,
              curve: Interval(
                (ind / event.length).clamp(0.0, 1.0),
                1.0,
                curve: Curves.easeInOutQuint,
              ),
            ),
          );

          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Opacity(
                opacity: animation.value,
                child: Transform.scale(
                  scale: animation.value,
                  child: child,
                ),
              );
            },
            child: FutureBuilder(
                future: Future.delayed(Duration(milliseconds: index * 200)),
                builder: (context, snapShot) {

                  return ZoomTapAnimation(
                    beginCurve: Curves.bounceIn,
                    endCurve: Curves.bounceInOut,
                    begin: 1,end: .8,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          if (event[index]!.event!.published) {
                            onTapUserEvent(event[index]!, model);
                          } else {
                            ToastUtil toastUtil = ToastUtil();
                            ToastContext().init(context);
                            toastUtil.showShortToast(context,
                                S.of(context).youCanNotViewUnpublishedEvent);
                          }
                        },
                        child: CommonCard(
                          shape: BorderRadius.circular(radius),
                          child: customBanner(
                            isNewEvent: event[index]!.event!.newlyAdded,
                            child: isPhotomallApp
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(radius),
                                            topLeft: Radius.circular(radius)),
                                        child: publishedOrUnpublishedWidget(
                                          event[index]!.event!.published,
                                          model.imageProcessor.getImageView(
                                            documentPath: model.documentDirectory,
                                            onTap: () async {
                                              if (isPhotomallApp) {
                                                StudioDataGetModel?
                                                    studioDataGetModel =
                                                    await model
                                                        .getStudioDetails(
                                                            event[index]!
                                                                .event!
                                                                .studioCode,
                                                            event[index]!
                                                                .event!
                                                                .code);
                                                showLog(
                                                    ">>>>>>>>>>>>>.${studioDataGetModel?.studioData?.data?.playStoreURL}");
                    
                    
                                              }
                                              if (event[index]!
                                                  .event!
                                                  .published) {
                                                showLog(
                                                    'published${event[index]!.event!.published}');
                    
                                                onTapUserEvent(
                                                    event[index]!, model);
                                              } else {
                                                showLog(
                                                    'unpublished${event[index]!.event!.published}');
                                                ToastUtil toastUtil = ToastUtil();
                                                ToastContext().init(context);
                                                toastUtil.showShortToast(
                                                    context,
                                                    S
                                                        .of(context)
                                                        .youCanNotViewUnpublishedEvent);
                                              }
                                            },
                                            file: event[index]!.file!,
                                            publicStoragePath:
                                                model.publicStoragePath!,
                                            privateStoragePath:
                                                model.privateStoragePath,
                                            errorWidget: SizedBox(),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0, left: 8),
                                                    child: CommonText(
                                                      isCard: true,
                                                      isHighlightedCard: true,
                                                      text:
                                                          "${event[index]!.event!.name} ",
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColorData
                                                          .titleTextColor,
                                                      // fontSize: TextProperty.h2,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0,
                                                            left: 8,
                                                            bottom: 8),
                                                    child: CommonText(
                                                      isCard: true,
                                                      isHighlightedCard: false,
                                                      text:
                                                          "${event[index]!.event!.categoryName}",
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: AppColorData
                                                          .normalTextColor,
                                                      //fontSize: TextProperty.h2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            widget.arguments.isArchivedEven
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () async {
                                                              hasInternet =
                                                                  await InternetConnectionChecker.instance
                                                                      .hasConnection;
                                                              if (hasInternet) {
                                                                await unarchiveEvent(
                                                                    context,
                                                                    event[index]!
                                                                        .event!
                                                                        .code);
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    RoutePaths
                                                                        .Events,
                                                                    arguments: EventsListArguments(
                                                                        isArchivedEven:
                                                                            true));
                                                              } else {
                                                                showLog(
                                                                    "Internet permission denied");
                                                                ToastUtil toast =
                                                                    ToastUtil();
                                                                ToastContext()
                                                                    .init(
                                                                        context);
                                                                toast.showShortToast(
                                                                    context,
                                                                    S
                                                                        .of(context)
                                                                        .yourOffline);
                                                                return;
                                                              }
                                                            },
                                                            icon: Icon(
                                                              Icons.unarchive,
                                                              size: 35,
                                                              color: AppColorData
                                                                  .iconColor,
                                                            ),
                                                            tooltip: "UnArchive",
                                                          ),
                                                          CommonText(
                                                            text: S
                                                                .of(context)
                                                                .unarchive,
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () async {
                                                              hasInternet =
                                                                  await InternetConnectionChecker.instance
                                                                      .hasConnection;
                                                              if (hasInternet) {
                                                                showLog(
                                                                    "Internet permission granted to deleted");
                                                                bool status = await showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        deleteDialog(
                                                                            context));
                                                                if (status) {
                                                                  await deleteEvent(
                                                                      context,
                                                                      event[index]!
                                                                          .event!
                                                                          .code);
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      RoutePaths
                                                                          .Events,
                                                                      arguments: EventsListArguments(
                                                                          isArchivedEven:
                                                                              true));
                                                                }
                                                              } else {
                                                                showLog(
                                                                    "Internet permission denied can't delete now");
                                                                ToastUtil toast =
                                                                    ToastUtil();
                                                                ToastContext()
                                                                    .init(
                                                                        context);
                                                                toast.showShortToast(
                                                                    context,
                                                                    S
                                                                        .of(context)
                                                                        .yourOffline);
                                                                return;
                                                              }
                                                            },
                                                            icon: Icon(
                                                              Icons.delete,
                                                              size: 35,
                                                              color: AppColorData
                                                                  .iconColor,
                                                            ),
                                                            tooltip: "Delete",
                                                          ),
                                                          CommonText(
                                                            text: S
                                                                .of(context)
                                                                .delete,
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                    ],
                                                  )
                                                : /*event[index].event.downloadable
                                            ? Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: downloadButton(
                                                    event[index].event.code),
                                              )
                                            :*/
                                                SizedBox()
                                          ],
                                        ),
                                      ),
                                      isPhotomallApp
                                          ? FutureBuilder<StudioDataGetModel?>(
                                              future: model.getStudioDetails(
                                                  event[index]!.event!.studioCode,
                                                  event[index]!.event!.code),
                                              // a previously-obtained Future<String> or null
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<
                                                          StudioDataGetModel?>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return SizedBox(
                                                      height: 50,
                                                      width: 50,
                                                      child:
                                                          CommonCircularProgress());
                                                }
                                                if (snapshot.hasData == false ||
                                                    snapshot.hasError) {
                                                  return SizedBox();
                                                }
                                                return Container(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left: 8,
                                                                          bottom:
                                                                              8),
                                                                  child: InkWell(
                                                                    onTap: () {
                                                                      /* if (snapshot.data!
                                                                            .studioData !=
                                                                        null &&
                                                                    snapshot
                                                                        .data!
                                                                        .studioData!
                                                                        .data!
                                                                        .playStoreURL!
                                                                        .isNotEmpty) {
                                                                  showPopupToPlayStore(
                                                                      context,
                                                                      snapshot
                                                                          .data!
                                                                          .studioData!
                                                                          .data!
                                                                          .playStoreURL!);
                                                                  return;
                                                                }*/
                                                                      Navigator.pushNamed(
                                                                          context,
                                                                          RoutePaths
                                                                              .ContactUs,
                                                                          //S.of(context).contactUs,
                                                                          arguments: ContactUs(
                                                                              appbarRequired:
                                                                                  true,
                                                                              studioCode:
                                                                                  event[index]!.event!.studioCode!));
                                                                    },
                                                                    child: Wrap(
                                                                      crossAxisAlignment:
                                                                          WrapCrossAlignment
                                                                              .center,
                                                                      alignment:
                                                                          WrapAlignment
                                                                              .start,
                                                                      /*  mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,*/
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              right:
                                                                                  8.0),
                                                                          child: Container(
                                                                              height: 50,
                                                                              child: CustomCachedNetworkImageWidget(
                                                                                url: snapshot.data!.image,
                                                                              )),
                                                                        ),
                                                                        CommonText(
                                                                          underline:
                                                                              true,
                                                                          isCard:
                                                                              true,
                                                                          isHighlightedCard:
                                                                              true,
                                                                          text:
                                                                              "${snapshot.data?.studioName}",
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color: AppColorData
                                                                              .titleTextColor,
                                                                          // fontSize: TextProperty.h2,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          /* IconButton(
                                                            onPressed: () async {
                                                              hasInternet =
                                                              await InternetConnectionChecker()
                                                                  .hasConnection;
                                                              if (hasInternet) {
                                                                showLog(
                                                                    "Internet permission granted to deleted");
                                                                bool status = await showDialog(
                                                                    context:
                                                                    context,
                                                                    builder: (BuildContext
                                                                    context) =>
                                                                        deleteDialog(
                                                                            context));
                                                                if (status) {
                                                                  await deleteEvent(
                                                                      context,
                                                                      event[index]!
                                                                          .event!
                                                                          .code!);
                    
                                                                  await model.getEventsDetailsFromDb();
                                                                  setState(() {
                                                                    model.userEvents.value.removeAt(index);
                                                                  });
                                                                }
                                                              } else {
                                                                showLog(
                                                                    "Internet permission denied can't delete now");
                                                                ToastUtil toast =
                                                                ToastUtil();
                                                                ToastContext()
                                                                    .init(context);
                                                                toast.showShortToast(
                                                                    context,
                                                                    S
                                                                        .of(context)
                                                                        .yourOffline);
                                                                return;
                                                              }
                                                            },
                                                            icon: Icon(
                                                              Icons.delete,
                                                              size: 35,
                                                              color: AppColorData.bgIconColor,
                                                            ),
                                                            tooltip: "Delete",
                                                          ),*/
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              })
                                          : SizedBox(),
                                    ],
                                  )
                                : Stack(
                                    children: [
                                      Container(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(radius),
                                              topLeft: Radius.circular(radius)),
                                          child: publishedOrUnpublishedWidget(
                                            event[index]!.event!.published,
                                            model.imageProcessor.getImageView(
                                              boxFit: BoxFit.fill,
                                              documentPath:
                                                  model.documentDirectory,
                                              onTap: () async {
                                                if (isPhotomallApp) {
                                                  StudioDataGetModel?
                                                      studioDataGetModel =
                                                      await model
                                                          .getStudioDetails(
                                                              event[index]!
                                                                  .event!
                                                                  .studioCode,
                                                              event[index]!
                                                                  .event!
                                                                  .code);
                                                  showLog(
                                                      ">>>>>>>>>>>>>.${studioDataGetModel?.studioData?.data?.playStoreURL}");
                    
                                                  /*if (studioDataGetModel!.studioData !=
                                                        null &&
                                                    studioDataGetModel.studioData!.data!
                                                        .playStoreURL!.isNotEmpty) {
                                                  showPopupToPlayStore(
                                                      context,
                                                      studioDataGetModel.studioData!
                                                          .data!.playStoreURL!);
                                                  return;
                                                }*/
                                                }
                                                if (event[index]!
                                                    .event!
                                                    .published) {
                                                  showLog(
                                                      'published${event[index]!.event!.published}');
                    
                                                  onTapUserEvent(
                                                      event[index]!, model);
                                                } else {
                                                  showLog(
                                                      'unpublished${event[index]!.event!.published}');
                                                  ToastUtil toastUtil =
                                                      ToastUtil();
                                                  ToastContext().init(context);
                                                  toastUtil.showShortToast(
                                                      context,
                                                      S
                                                          .of(context)
                                                          .youCanNotViewUnpublishedEvent);
                                                }
                                              },
                                              file: event[index]!.file!,
                                              publicStoragePath:
                                                  model.publicStoragePath!,
                                              privateStoragePath:
                                                  model.privateStoragePath,
                                              errorWidget: SizedBox(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 10,
                                        bottom: 25,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            CommonText(
                                              // isCard: true,
                                              // isHighlightedCard: true,
                                              text:
                                                  "${event[index]!.event!.name} ",
                                              //fontWeight: FontWeight.bold,
                                              //color: AppColorData.titleTextColor,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                shadows: <Shadow>[
                                                  Shadow(
                                                    offset: Offset(1.0, 1.0),
                                                    blurRadius: 3.0,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                  Shadow(
                                                    offset: Offset(1.0, 1.0),
                                                    blurRadius: 8.0,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                ],
                                              ),
                                              // fontSize: TextProperty.h2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        left: 10,
                                        bottom: 0,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            CommonText(
                                              // isCard: true,
                                              //  isHighlightedCard: false,
                                              text:
                                                  "${event[index]!.event!.categoryName}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                shadows: <Shadow>[
                                                  Shadow(
                                                    offset: Offset(1.0, 1.0),
                                                    blurRadius: 3.0,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                  Shadow(
                                                    offset: Offset(1.0, 1.0),
                                                    blurRadius: 8.0,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                ],
                                              ),
                                              // fontWeight: FontWeight.normal,
                                              // color: AppColorData.normalTextColor,
                                              //fontSize: TextProperty.h2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      /*Row(
                                        children: [
                                          Spacer(),
                    
                    
                                        ],
                                      ),*/
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
        });
  }

  Widget eventSwiper(
      List<Demo?> event, EventListRouteViewModel model, bool isUserEvent) {
    double radius = 18;
    bool hasInternet = false;
    return SizedBox(
      height: 350,
      child: CardSwiper(
          allowedSwipeDirection: AllowedSwipeDirection.all(),
          initialIndex: index,
          scale: 0.9,
          backCardOffset: Offset(0.0, 70.0),
          onSwipe: (previousIndex, currentIndex, direction) async =>
              await PreferenceHelper.setInt(eventListPreIndex, currentIndex!) ??
              true,
          key: GlobalKey(),
          numberOfCardsDisplayed: event.length,
          cardsCount: event.length,
          cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
            return FutureBuilder(
                future: Future.delayed(Duration(milliseconds: index * 200)),
                builder: (context, snapShot) {
                  /* if (snapShot.connectionState == ConnectionState.waiting) {
                    return Shimmer(
                        gradient: LinearGradient(
                            begin: AppColorData.cardGradientBegin,
                            end: AppColorData.cardGradientEnd,
                            colors: AppColorData.cardBackgroundColors,
                            stops: AppColorData.cardStops),
                        enabled: true,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: AppColorData.cardGradientBegin,
                                  end: AppColorData.cardGradientEnd,
                                  colors: AppColorData.cardBackgroundColors,
                                  stops: AppColorData.cardStops)),
                        ));
                  }*/
                  return CustomItemTransition(
                    duration: itemTransitionDuration,
                    delay: index * itemTransitionDelay,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          if (event[index]!.event!.published) {
                            onTapUserEvent(event[index]!, model);
                          } else {
                            ToastUtil toastUtil = ToastUtil();
                            ToastContext().init(context);
                            toastUtil.showShortToast(context,
                                S.of(context).youCanNotViewUnpublishedEvent);
                          }
                        },
                        child: CommonCard(
                          shape: BorderRadius.circular(radius),
                          child: customBanner(
                            isNewEvent: event[index]!.event!.newlyAdded,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(radius),
                                      topLeft: Radius.circular(radius)),
                                  child: publishedOrUnpublishedWidget(
                                    event[index]!.event!.published,
                                    model.imageProcessor.getImageView(
                                      documentPath: model.documentDirectory,
                                      onTap: () async {
                                        if (isPhotomallApp) {
                                          StudioDataGetModel?
                                              studioDataGetModel = await model
                                                  .getStudioDetails(
                                                      event[index]!
                                                          .event!
                                                          .studioCode,
                                                      event[index]!
                                                          .event!
                                                          .code);
                                          showLog(
                                              ">>>>>>>>>>>>>.${studioDataGetModel?.studioData?.data?.playStoreURL}");

                                          /*if (studioDataGetModel!.studioData !=
                                                  null &&
                                              studioDataGetModel.studioData!.data!
                                                  .playStoreURL!.isNotEmpty) {
                                            showPopupToPlayStore(
                                                context,
                                                studioDataGetModel.studioData!
                                                    .data!.playStoreURL!);
                                            return;
                                          }*/
                                        }
                                        if (event[index]!.event!.published) {
                                          showLog(
                                              'published${event[index]!.event!.published}');

                                          onTapUserEvent(event[index]!, model);
                                        } else {
                                          showLog(
                                              'unpublished${event[index]!.event!.published}');
                                          ToastUtil toastUtil = ToastUtil();
                                          ToastContext().init(context);
                                          toastUtil.showShortToast(
                                              context,
                                              S
                                                  .of(context)
                                                  .youCanNotViewUnpublishedEvent);
                                        }
                                      },
                                      file: event[index]!.file!,
                                      publicStoragePath:
                                          model.publicStoragePath!,
                                      privateStoragePath:
                                          model.privateStoragePath,
                                      errorWidget: SizedBox(),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, left: 8),
                                              child: CommonText(
                                                isCard: true,
                                                isHighlightedCard: true,
                                                text:
                                                    "${event[index]!.event!.name} ",
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppColorData.titleTextColor,
                                                // fontSize: TextProperty.h2,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, left: 8, bottom: 8),
                                              child: CommonText(
                                                isCard: true,
                                                isHighlightedCard: false,
                                                text:
                                                    "${event[index]!.event!.categoryName}",
                                                fontWeight: FontWeight.normal,
                                                color: AppColorData
                                                    .normalTextColor,
                                                //fontSize: TextProperty.h2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      widget.arguments.isArchivedEven
                                          ? Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Column(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () async {
                                                        hasInternet =
                                                            await InternetConnectionChecker.instance
                                                                .hasConnection;
                                                        if (hasInternet) {
                                                          await unarchiveEvent(
                                                              context,
                                                              event[index]!
                                                                  .event!
                                                                  .code);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pushNamed(
                                                              context,
                                                              RoutePaths.Events,
                                                              arguments:
                                                                  EventsListArguments(
                                                                      isArchivedEven:
                                                                          true));
                                                        } else {
                                                          showLog(
                                                              "Internet permission denied");
                                                          ToastUtil toast =
                                                              ToastUtil();
                                                          ToastContext()
                                                              .init(context);
                                                          toast.showShortToast(
                                                              context,
                                                              S
                                                                  .of(context)
                                                                  .yourOffline);
                                                          return;
                                                        }
                                                      },
                                                      icon: Icon(
                                                        Icons.unarchive,
                                                        size: 35,
                                                        color: AppColorData
                                                            .iconColor,
                                                      ),
                                                      tooltip: "UnArchive",
                                                    ),
                                                    CommonText(
                                                      text: S
                                                          .of(context)
                                                          .unarchive,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () async {
                                                        hasInternet =
                                                            await InternetConnectionChecker.instance
                                                                .hasConnection;
                                                        if (hasInternet) {
                                                          showLog(
                                                              "Internet permission granted to deleted");
                                                          bool status = await showDialog(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  deleteDialog(
                                                                      context));
                                                          if (status) {
                                                            await deleteEvent(
                                                                context,
                                                                event[index]!
                                                                    .event!
                                                                    .code);
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pushNamed(
                                                                context,
                                                                RoutePaths
                                                                    .Events,
                                                                arguments: EventsListArguments(
                                                                    isArchivedEven:
                                                                        true));
                                                          }
                                                        } else {
                                                          showLog(
                                                              "Internet permission denied can't delete now");
                                                          ToastUtil toast =
                                                              ToastUtil();
                                                          ToastContext()
                                                              .init(context);
                                                          toast.showShortToast(
                                                              context,
                                                              S
                                                                  .of(context)
                                                                  .yourOffline);
                                                          return;
                                                        }
                                                      },
                                                      icon: Icon(
                                                        Icons.delete,
                                                        size: 35,
                                                        color: AppColorData
                                                            .iconColor,
                                                      ),
                                                      tooltip: "Delete",
                                                    ),
                                                    CommonText(
                                                      text:
                                                          S.of(context).delete,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            )
                                          : /*event[index].event.downloadable
                                            ? Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: downloadButton(
                                                    event[index].event.code),
                                              )
                                            :*/
                                          SizedBox()
                                    ],
                                  ),
                                ),
                                isPhotomallApp
                                    ? FutureBuilder<StudioDataGetModel?>(
                                        future: model.getStudioDetails(
                                            event[index]!.event!.studioCode,
                                            event[index]!.event!.code),
                                        // a previously-obtained Future<String> or null
                                        builder: (BuildContext context,
                                            AsyncSnapshot<StudioDataGetModel?>
                                                snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return SizedBox(
                                                height: 50,
                                                width: 50,
                                                child:
                                                    CommonCircularProgress());
                                          }
                                          if (snapshot.hasData == false ||
                                              snapshot.hasError) {
                                            return SizedBox();
                                          }
                                          return Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8,
                                                                bottom: 8),
                                                        child: InkWell(
                                                          onTap: () {
                                                            /* if (snapshot.data!
                                                                        .studioData !=
                                                                    null &&
                                                                snapshot
                                                                    .data!
                                                                    .studioData!
                                                                    .data!
                                                                    .playStoreURL!
                                                                    .isNotEmpty) {
                                                              showPopupToPlayStore(
                                                                  context,
                                                                  snapshot
                                                                      .data!
                                                                      .studioData!
                                                                      .data!
                                                                      .playStoreURL!);
                                                              return;
                                                            }*/
                                                            Navigator.pushNamed(
                                                                context,
                                                                RoutePaths
                                                                    .ContactUs,
                                                                //S.of(context).contactUs,
                                                                arguments: ContactUs(
                                                                    appbarRequired:
                                                                        true,
                                                                    studioCode: event[
                                                                            index]!
                                                                        .event!
                                                                        .studioCode!));
                                                          },
                                                          child: Wrap(
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .center,
                                                            alignment:
                                                                WrapAlignment
                                                                    .start,
                                                            /*  mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,*/
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            8.0),
                                                                child: Container(
                                                                    height: 50,
                                                                    child: CustomCachedNetworkImageWidget(
                                                                      url: snapshot
                                                                          .data!
                                                                          .image,
                                                                    )),
                                                              ),
                                                              CommonText(
                                                                underline: true,
                                                                isCard: true,
                                                                isHighlightedCard:
                                                                    true,
                                                                text:
                                                                    "${snapshot.data?.studioName}",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColorData
                                                                    .titleTextColor,
                                                                // fontSize: TextProperty.h2,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        })
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }

  Widget demoEventListViewBuilder(
      List<Demo?> demoEvent, EventListRouteViewModel model) {
    double radius = model.borderRadius;

    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: demoEvent.length,
        itemBuilder: (BuildContext context, int index) {
          return CustomItemTransition(
            duration: itemTransitionDuration,
            delay: itemTransitionDelay + 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  Navigator.pushNamed(context, RoutePaths.EventDetails,
                      arguments: EventDetailsRouteArguments(
                        eventCode: demoEvent[index]!.event!.code,
                      ));
                },
                child: Banner(
                  message: "Demo",
                  textStyle: TextStyle(
                      color: AppColorData.backgroundColors.first,
                      fontSize: 14,
                      letterSpacing: 1.5),
                  location: BannerLocation.topEnd,
                  color: AppColorData.appBarTextColor,
                  child: CommonCard(
                    shape: BorderRadius.circular(radius),
                    child: Stack(
                      children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(radius),
                                topLeft: Radius.circular(radius)),
                            child: model.imageProcessor.getImageView(
                              boxFit: BoxFit.fill,
                              documentPath: model.documentDirectory,
                              privateStoragePath: model.privateStoragePath,
                              publicStoragePath: model.publicStoragePath!,
                              file: demoEvent[index]!.file!,
                              onTap: () async {
                                Navigator.pushNamed(
                                    context, RoutePaths.EventDetails,
                                    arguments: EventDetailsRouteArguments(
                                      eventCode: demoEvent[index]!.event!.code,
                                    ));
                              },
                              errorWidget: SizedBox(),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          bottom: 25,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CommonText(
                                // isCard: true,
                                // isHighlightedCard: true,
                                text: "${demoEvent[index]!.event!.name} ",
                                //fontWeight: FontWeight.bold,
                                //color: AppColorData.titleTextColor,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 3.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 8.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ],
                                ),
                                // fontSize: TextProperty.h2,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 10,
                          bottom: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CommonText(
                                // isCard: true,
                                //  isHighlightedCard: false,
                                text:
                                    "${demoEvent[index]!.event!.categoryName}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 3.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 8.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ],
                                ),
                                // fontWeight: FontWeight.normal,
                                // color: AppColorData.normalTextColor,
                                //fontSize: TextProperty.h2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    /* Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 8.0, left: 8),
                                  child: CommonText(
                                    isCard: true,
                                    isHighlightedCard: true,
                                    text: demoEvent[index]!.event!.name!,
                                    fontWeight: FontWeight.bold,
                                    color: AppColorData.titleTextColor,
                                    //  fontSize: TextProperty.h2,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 8, bottom: 8),
                                  child: CommonText(
                                    isCard: true,
                                    isHighlightedCard: false,
                                    text: demoEvent[index]!.event!.categoryName,
                                    fontWeight: FontWeight.normal,
                                    color: AppColorData.normalTextColor,
                                    //fontSize: TextProperty.h3,
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),*/
                  ),
                ),
              ),
            ),
          );
        });
  }

  addEventButton({required EventListRouteViewModel model}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        model.archivedEvent.value.isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                      begin: AppColorData.buttonGradientBegin,
                      end: AppColorData.buttonGradientEnd,
                      colors: AppColorData.buttonBackgroundColors,
                      stops: AppColorData.buttonBackgroundStops),
                  //gradient: LinearGradient(colors: [Colors.blue,Colors.black])
                ),
                child: FloatingActionButton.extended(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    var storage = getTemporaryDirectory();
                    showLog("the temp folder where ${storage}");
                    Navigator.pushNamed(context, RoutePaths.Events,
                        arguments: EventsListArguments(isArchivedEven: true));
                  },
                  tooltip: S.of(context).archived,
                  icon: Icon(
                    Icons.archive_outlined,
                    color: AppColorData.elevatedButtonText,
                    size: 35,
                  ),
                  label: CommonText(
                    text: S.of(context).archived,
                    // color: AppColorData.elevatedButtonText,
                    isButton: true,
                  ),
                ),
              )
            : SizedBox(),
        Padding(padding: EdgeInsets.all(5)),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
                begin: AppColorData.buttonGradientBegin,
                end: AppColorData.buttonGradientEnd,
                colors: AppColorData.buttonBackgroundColors,
                stops: AppColorData.buttonBackgroundStops),
            //gradient: LinearGradient(colors: [Colors.blue,Colors.black])
          ),
          child: FloatingActionButton.extended(
            elevation: 0,
            backgroundColor: Colors.transparent,
            onPressed: () async {
              await Navigator.pushNamed(context, RoutePaths.AddEvent);
              //    await model.getResourcesFromTransporter();
            },
            tooltip: S.of(context).addEvent,
            icon: Icon(
              Icons.add,
              color: AppColorData.elevatedButtonText,
              size: 35,
            ),
            label: CommonText(
              text: S.of(context).addEvent,
              // color: AppColorData.elevatedButtonText,
              isButton: true,
            ),
          ),
        ),
      ],
    );
  }

  publishedOrUnpublishedWidget(bool value, Widget child) {
    if (value) {
      return child;
    } else {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.grey,
          BlendMode.saturation,
        ),
        child: child,
      );
    }
  }

  Widget customBanner({required Widget child, required bool isNewEvent}) {
    if (!isNewEvent) {
      return child;
    } else {
      return child;
      /* return Banner(
        color: AppColorData.selectedCardBackgroundColor,
        message: S.of(context).newKeyWord,
        location: BannerLocation.topEnd,
        child: child,
      );*/
    }
  }

  Widget deleteDialog(BuildContext context) {
    showLog("deleteDialog method worked");
    return CommonAlertDialog(
      title: S.of(context).delete,
      content: S.of(context).areYouSureYouWantToDeleteThisEventThis,
      actions: [
        CommonTextButton(
          buttonText: S.of(context).no,
          onPressCall: () {
            Navigator.pop(context, false);
          },
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.01,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: AppColorData.buttonBackgroundColors.last,
            foregroundColor: AppColorData.buttonTextColors,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: CommonText(text: S.of(context).yes),
        ),
      ],
    );
  }

  void showPopupToPlayStore(BuildContext context, String url) {
    Widget _logoutDialog = CommonAlertDialog(
      title: "Get your Event",
      content: "get your event on play store",
      actions: [
        CommonTextButton(
          buttonText: S.of(context).cancel,
          onPressCall: () {
            showLog('the context of the >> ${context}');
            Navigator.pop(context, false);
          },
        ),
        CommonButton(
          onPressCall: () async {
            await launchUrl(Uri.parse(url));
          },
          buttonText: S.of(context).yes,
        )
      ],
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => _logoutDialog);
  }
}

class EventsListArguments {
  bool isArchivedEven;

  EventsListArguments({this.isArchivedEven = false});
}
