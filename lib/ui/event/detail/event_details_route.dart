import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/studio_data_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/media/media_widget.dart';
import 'package:photomall_flutter/ui/event/detail/event_details_route_model.dart';
import 'package:photomall_flutter/ui/folders/model/folder_arguments_model.dart';
import 'package:photomall_flutter/ui/folders/route/folder_route.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_alert_dialog.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_button.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text_button.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:toast/toast.dart';

import '../../../api/repository/photomall_apis.dart';
import '../../../controllers/event_controller.dart';
import '../../../core/Utils/preference_helper.dart';
import '../../../core/Utils/toast_util.dart';
import '../../../core/constants/shared_preference_constants.dart';
import '../../../media/media_list.dart';
import '../../base/base_widget.dart';
import 'info/event_info_data_view.dart';

class EventDetailsRoute extends StatefulWidget {
  final String? eventCode;
  final int? eventType;
  final int? lastUpdatedAt;
  final int? imageId;
  bool? isFromPrivateKey;
  final EventDetailsRouteArguments? arguments;

  EventDetailsRoute({
    this.eventCode,
    this.eventType,
    this.lastUpdatedAt,
    this.imageId,
    this.arguments,
    this.isFromPrivateKey = false,
  });

  @override
  _EventDetailsRouteState createState() => _EventDetailsRouteState();
}

class _EventDetailsRouteState extends State<EventDetailsRoute>
    with TickerProviderStateMixin {
  BaseWidget<EventDetailsRouteModel>? baseWidget;
  Widget? infoWidget;
  Widget? photoSelection;
  Widget? mediaWidget;
  Widget? photoWidget;
  final ValueNotifier<bool> isConnected = ValueNotifier<bool>(false);
  TextEditingController _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _controller = SuperTooltipController();

  @override
  void initState() {
    printInvitationTable();
    getPrivateKeyValue();
    super.initState();
  }

  getPrivateKeyValue() async {
    widget.isFromPrivateKey =
        await checkUserPrivateKey(widget.arguments!.eventCode!);
    showLog("widget.isFromPrivateKey ${widget.isFromPrivateKey}");
  }

  Future<bool> checkUserPrivateKey(String eventCode) async {
    String? userPrivateKey = await PreferenceHelper.getValueForKey(
        eventCode!, userInputPrivatePrefKey);
    String apiPrivateKey =
        await PreferenceHelper.getValueForKey(eventCode!, eventPrivatePrefKey);
    showLog("checkUsedPrivateKey init: $userPrivateKey $apiPrivateKey");

    if (userPrivateKey == apiPrivateKey) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    if (baseWidget != null && baseWidget?.model != null) {
      baseWidget?.model.destroy();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StudioDataController studioDataController = StudioDataController();
    baseWidget = BaseWidget<EventDetailsRouteModel>(
        model: EventDetailsRouteModel(
            isFromPrivateKey: widget.isFromPrivateKey ?? false,
            apiHandler: Provider.of<ApiHelper>(context, listen: false),
            context: context,
            eventId: widget.arguments?.eventCode),
        onModelReady: (model) =>
            model.callGetEventDetailsFromDb(widget.arguments!.eventCode!),
        builder: (context, model, child) {
          return Stack(
            children: <Widget>[
              SafeArea(
                top: false,
                right: false,
                left: false,
                child: WillPopScope(
                  onWillPop: () async {
                    if (model.showShare == true) {
                      EventModelDao eventModelDao = EventModelDao();
                      eventModelDao.updateShareDate(model.eventCode!);
                      bool? result = await showDialog(
                          context: context,
                          builder: (context) {
                            return CommonAlertDialog(
                              title: S.of(context).share,
                              content: S
                                  .of(context)
                                  .justClickOnTheButtonAndShareThisEventWith,
                              actions: [
                                CommonTextButton(
                                  buttonText: S.of(context).cancel,
                                  onPressCall: () {
                                    Navigator.pop(context, false);
                                  },
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                                CommonButton(
                                  buttonText: S.of(context).share,
                                  showIcon: true,
                                  //text: S.of(context).share,
                                  icon: Icons.share,
                                  onPressCall: () async {
                                    if (isPhotomallApp) {
                                      await model.sharePhotomallEvent();
                                    } else {
                                      await Share.share(
                                        "${await studioDataController.getStudioName()} has shared ${model.eventName} with you. Click the link "
                                        "${await studioDataController.getPtmlDomin()}/${await studioDataController.getShortUrl()}/${model.eventCode} to view",
                                      );
                                    }

                                    Navigator.pop(context, false);
                                  },
                                ),
                              ],
                            );
                          });
                      showLog('the popup result where ${result}');
                      Navigator.pop(context);
                      return Future.value(true);
                    } else {
                      return true;
                    }
                  },
                  child: Scaffold(
                    extendBodyBehindAppBar: true,
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      foregroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      iconTheme: IconThemeData(color: AppColorData.bgIconColor),
                      title: UniqueText(text: model.eventName ?? ""),
                      centerTitle: false,
                      actions: [
                        IconButton(
                          onPressed: () async {
                            bool hasInternet = false;

                            hasInternet =
                                await InternetConnectionChecker.instance.hasConnection;
                            if (hasInternet) {
                              showLog("Internet permission granted to deleted");
                              bool status = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      deleteDialog(context));
                              if (status) {
                                await deleteEvent(context, model.eventCode!);

                                Navigator.pop(context);
                              }
                            } else {
                              showLog(
                                  "Internet permission denied can't delete now");
                              ToastUtil toast = ToastUtil();
                              ToastContext().init(context);
                              toast.showShortToast(
                                  context, S.of(context).yourOffline);
                              return;
                            }
                          },
                          icon: Icon(Icons.delete,
                              color: AppColorData.bgIconColor),
                          tooltip: "Delete",
                        ),
                        widget.isFromPrivateKey == true
                            ? SuperTooltip(
                                showBarrier: true,
                                controller: _controller,
                                content: Text(
                                  "You are in Private",
                                  softWrap: true,
                                  style: TextStyle(
                                    color: AppColorData.bgIconColor,
                                  ),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.lock_open),
                                  onPressed: () async {
                                    await _controller.showTooltip();
                                  },
                                ))
                            : IconButton(
                                onPressed: () async {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16)),
                                    ),
                                    builder: (context) {
                                      return Padding(
                                        padding:
                                            MediaQuery.of(context).viewInsets,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text("Private key",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(height: 10),
                                                TextFormField(
                                                  controller: _textController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                    LengthLimitingTextInputFormatter(
                                                        4),
                                                  ],
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Enter Private key",
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Please enter a code";
                                                    } else if (value.length !=
                                                        4) {
                                                      return "Code must be 4 digits";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                const SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CommonButton(
                                                      buttonText: "Cancel",
                                                      showIcon: false,
                                                      onPressCall: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    const SizedBox(width: 10),
                                                    CommonButton(
                                                      buttonText: "Confirm",
                                                      showIcon: false,
                                                      onPressCall: () async {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          model.saveAndValidatePrivateKeyFromUser(
                                                              context,
                                                              _textController
                                                                  .text);
                                                          // Perform action with _textController.text
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.lock),
                                splashRadius: 20,
                                color: AppColorData.bgIconColor,
                              ),
                        IconButton(
                            onPressed: () async {
                              if (isPhotomallApp) {
                                await model.sharePhotomallEvent();
                              } else {
                                Share.share(
                                  "${await studioDataController.getStudioName()} has shared ${model.eventName ?? "event"} with you. Click the link "
                                  "${await studioDataController.getPtmlDomin()}/${await studioDataController.getShortUrl()}/${model.eventCode} to view",
                                );
                              }

                              showLog(
                                  "share button event code :: ${model.eventCode}");
                            },
                            icon: Icon(
                              Icons.share,
                            ),
                            splashRadius: 20,
                            color: AppColorData.bgIconColor),
                      ],
                    ),
                    body: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: TabViewControllerSet(
                          model: model,
                          arguments: widget.arguments!,
                          isFromPrivate: model.isFromPrivateKey,
                        )),
                  ),
                ),
              ),
              model.busy ? _setBusy(context) : SizedBox()
            ],
          );
        });
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: AppColorData.backgroundGradientBegin,
                end: AppColorData.backgroundGradientEnd,
                colors: AppColorData.backgroundColors)),
        child: baseWidget);
  }

  _setBusy(BuildContext context) {
    return Center(
      child: CommonCircularProgress(),
    );
  }

  /* _setTabController(BuildContext context, EventDetailsRouteModel model) {
    return DefaultTabController(

        initialIndex: 0,
        length: model.isPhotoSelectionAvailable! ? 3 : 2,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    stops: AppColorData.tabBarStops,
                    begin: AppColorData.tabBarGradientBegin,
                    end: AppColorData.tabBarGradientEnd,
                    colors: AppColorData.tabBarBackgroundColors),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: model.isPhotoSelectionAvailable!
                      ? TabBar(
                         indicatorPadding:
                              EdgeInsets.symmetric(horizontal: 10),
                          labelPadding: EdgeInsets.symmetric(horizontal: 25),
                          isScrollable: true,
                          tabs: [
                            Tab(
                              child: Column(
                                children: [
                                  Icon(Icons.photo_album),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Expanded(
                                    child: CommonText(
                                      text: S.of(context).photo_selection,
                                      maxlines: 2,
                                      textAlign: TextAlign.center,
                                      // style: Theme.of(context).textTheme.labelLarge,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Tab(
                              //height: orientation == Orientation.portrait ?height *0.09: height *0.12,
                              child: Column(
                                children: [
                                  Icon(Icons.photo),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Expanded(
                                    child: CommonText(
                                      text: S.of(context).medias,
                                      maxlines: 3,
                                      textAlign: TextAlign.center,
                                      // style: Theme.of(context).textTheme.labelMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Tab(
                              //   height: orientation == Orientation.portrait ?height *0.09: height *0.12,
                              child: Column(
                                children: [
                                  Icon(Icons.info),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Expanded(
                                    child: CommonText(
                                      text: S.of(context).info,
                                      maxlines: 3,
                                      textAlign: TextAlign.center,
                                      // style: Theme.of(context).textTheme.labelMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          indicatorColor: AppColorData.tabBarIndicatorColor,
                          //black color
                          labelColor: AppColorData.tabBarSelectedLabelColor,
                          //black color
                          unselectedLabelColor:
                              AppColorData.tabBarUnSelectedLabelColor,
                          //white color
                        )
                      : TabBar(
                          indicatorPadding:
                              EdgeInsets.symmetric(horizontal: 10),
                          labelPadding: EdgeInsets.symmetric(horizontal: 25),
                          isScrollable: true,
                          tabs: [
                            Tab(
                              //height: orientation == Orientation.portrait ?height *0.09: height *0.12,
                              child: Column(
                                children: [
                                  Icon(Icons.photo),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Expanded(
                                    child: CommonText(
                                      text: S.of(context).medias,
                                      maxlines: 3,
                                      textAlign: TextAlign.center,
                                      // style: Theme.of(context).textTheme.labelMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Tab(
                              //   height: orientation == Orientation.portrait ?height *0.09: height *0.12,
                              child: Column(
                                children: [
                                  Icon(Icons.info),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Expanded(
                                    child: CommonText(
                                      text: S.of(context).info,
                                      maxlines: 3,
                                      textAlign: TextAlign.center,
                                      // style: Theme.of(context).textTheme.labelMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          indicatorColor: AppColorData.tabBarIndicatorColor,
                          //black color
                          labelColor: AppColorData.tabBarSelectedLabelColor,
                          //black color
                          unselectedLabelColor:
                              AppColorData.tabBarUnSelectedLabelColor,
                          //white color
                        ),
                ),
              ),
            ),
            model.isPhotoSelectionAvailable!
                ? Expanded(
                    child: TabBarView(
                      physics: ClampingScrollPhysics(),
                      children: [
                        FolderRoute(
                          key: UniqueKey(),
                          arguments: FoldersRouteModel(
                              isDemoEvent: model.isDemoEvent,
                              eventCode: model.eventCode!),
                        ),
                        SingleChildScrollView(
                          child: Flex(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //  crossAxisAlignment: CrossAxisAlignment.center,
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                  child: Center(
                                child: MediaWidget(
                                  eventCode: widget.arguments!.eventCode,

                                ),
                              )),
                            ],
                          ),
                        ),
                        EventInfoDataView(
                          widget.arguments!.eventCode!,
                          key: TabKeys.info,
                          isDemoEvent: model.isDemoEvent,
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: TabBarView(
                      physics: ClampingScrollPhysics(),
                      children: [
                        SingleChildScrollView(
                          child: Flex(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //  crossAxisAlignment: CrossAxisAlignment.center,
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                  child: Center(
                                child: MediaWidget(
                                  eventCode: widget.arguments!.eventCode,
                                ),
                              )),
                            ],
                          ),
                        ),
                        EventInfoDataView(
                          widget.arguments!.eventCode!,
                          key: TabKeys.info,
                          isDemoEvent: model.isDemoEvent,
                        ),
                      ],
                    ),
                  )
          ],
        ));
  }*/

  void checkInternetConnectivity() {
    InternetConnectionChecker.instance
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          isConnected.value = true;
          showLog(" data :: ${isConnected.value} :: $status");
          break;
        case InternetConnectionStatus.disconnected:
          isConnected.value = false;
          break;
        case InternetConnectionStatus.slow:
          // TODO: Handle this case.

      }
    });
  }

  Future<void> printInvitationTable() async {
    showLog("the invitation table is :: ::");
    //await dbHelper.printTable("events");
  }

  getAppBarTitle(model) {
    return CommonText(
      text: "",
    );
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
}

class EventDetailsRouteArguments {
  String? eventCode;

  EventDetailsRouteArguments({this.eventCode});
}

class TabKeys {
  static final info = Key('_info');
  static final album = Key('_album');
  static final video = Key('_video');
}

class TabViewControllerSet extends StatefulWidget {
  final EventDetailsRouteModel model;
  final EventDetailsRouteArguments arguments;
  final bool isFromPrivate;

  const TabViewControllerSet({
    Key? key,
    required this.model,
    required this.arguments,
    required this.isFromPrivate,
  }) : super(key: key);

  @override
  State<TabViewControllerSet> createState() => _TabViewControllerSetState();
}

class _TabViewControllerSetState extends State<TabViewControllerSet> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    widget.model.isInfoPageCheck(index);
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    widget.model.isInfoPageCheck(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pagesWithPhotoSelection = [
      FolderRoute(
        key: PageStorageKey('folder-${widget.model.eventCode ?? widget.arguments.eventCode ?? ''}'),
        arguments: FoldersRouteModel(
          isDemoEvent: widget.model.isDemoEvent,
          eventCode: widget.model.eventCode ?? "",
        ),
      ),
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: MediaWidget(
                eventCode: widget.arguments.eventCode,
                categoryName: [],
                isFromPrivate: widget.isFromPrivate,
              ),
            ),
            EventInfoDataView(
              widget.arguments.eventCode!,
              key: TabKeys.info,
              isDemoEvent: widget.model.isDemoEvent,
            ),
          ],
        ),
      ),
    ];

    final List<Widget> _pagesWithoutPhotoSelection = [
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: MediaWidget(
                eventCode: widget.arguments.eventCode,
                categoryName: [],
                isFromPrivate: widget.isFromPrivate,
              ),
            ),
            EventInfoDataView(
              widget.arguments.eventCode!,
              key: TabKeys.info,
              isDemoEvent: widget.model.isDemoEvent,
            ),
          ],
        ),
      ),
    ];
    var unSelectedColor = AppColorData.tabBarUnSelectedLabelColor;
    var selectedColor = AppColorData.tabBarSelectedLabelColor;
    final List<GButton> _bottomNavItemsWithPhotoSelection = [
      GButton(
          padding: padding,
          icon: Icons.photo_album,
          text: S.of(context).photo_selection),
      GButton(
        padding: padding,
        icon: Icons.photo,
        text: S.of(context).medias,
      ),
      // GButton(
      //   padding: padding,
      //   icon: Icons.info,
      //   text: S.of(context).info,
      // ),
    ];

    final List<GButton> _bottomNavItemsWithoutPhotoSelection = [
      GButton(
        padding: padding,
        icon: Icons.photo,
        text: S.of(context).medias,
      ),
      // GButton(
      //   padding: padding,
      //   icon: Icons.info,
      //   text: S.of(context).info,
      // ),
    ];
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: widget.model.isPhotoSelectionAvailable!
            ? _pagesWithPhotoSelection
            : _pagesWithoutPhotoSelection,
        physics: ClampingScrollPhysics(),
      ),
      bottomNavigationBar: Padding(
        padding: widget.model.isPhotoSelectionAvailable!
            ? const EdgeInsets.all(8.0)
            : EdgeInsets.only(left: 75.0, bottom: 8, right: 75),
        child: GNav(
          backgroundColor: Colors.transparent,
          rippleColor: AppColorData.appBarTextColor,
          hoverColor: Colors.transparent,
          gap: 8,
          mainAxisAlignment: widget.model.isPhotoSelectionAvailable!
              ? MainAxisAlignment.spaceEvenly
              : MainAxisAlignment.center,
          curve: Curves.easeInOut,
          activeColor: AppColorData.backgroundColors.first,
          iconSize: 27,
          padding: EdgeInsets.symmetric(horizontal: 200, vertical: 10),
          duration: Duration(milliseconds: 400),
          tabBackgroundColor: AppColorData.appBarTextColor,
          tabBorderRadius: 15,
          color: AppColorData.appBarTextColor,
          tabs: widget.model.isPhotoSelectionAvailable!
              ? _bottomNavItemsWithPhotoSelection
              : _bottomNavItemsWithoutPhotoSelection,
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            _onItemTapped(index);
          },
        ),
      ),
    );
  }
}
