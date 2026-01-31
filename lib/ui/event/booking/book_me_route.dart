import 'package:animated_custom_hint_textfield/animated_custom_hint_textfield.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/Utils/file_util.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/route_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as appConf;
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/file_dao.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/preference/preference_handler/booking_handler.dart';
import 'package:photomall_flutter/preference/preference_handler/redirection_preference_handler.dart';
import 'package:photomall_flutter/preference/preference_model/booking_model.dart';
import 'package:photomall_flutter/preference/preference_model/redirection_preference_model.dart';
import 'package:photomall_flutter/preference/redirection_route_constant.dart';
import 'package:photomall_flutter/traits/common_widgets/custom_transition_widget.dart';
import 'package:photomall_flutter/traits/utils/network_util.dart';
import 'package:photomall_flutter/ui/app_side_drawer/side_drawer_constants.dart';
import 'package:photomall_flutter/ui/bottom_navigation/bottom_navigation_constants.dart';
import 'package:photomall_flutter/ui/contactus/contact_us_data_view.dart';
import 'package:photomall_flutter/ui/drawer/side_drawer_model.dart';
import 'package:photomall_flutter/ui/event/booking/book_me_route_model.dart';
import 'package:photomall_flutter/ui/gallery/gallery_route.dart';
import 'package:photomall_flutter/ui/login/login_route.dart';
import 'package:photomall_flutter/ui/shared/ui_helpers.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text_button.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../base/base_widget.dart';
import '../../menu_button.dart';

class BookMeRoute extends StatefulWidget {
  final bool? beforeLogin;

  const BookMeRoute({Key? key, this.beforeLogin}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BookMeState();
}

class BookMeState extends State<BookMeRoute> {
  DateTime? selectedDate = null; // DateTime.now();
  DateTime? date;
  bool startingDateAndTimeTextClearVisible = false;
  bool endingDateAndTimeTextClearVisible = false;
  var staringDateAndTime = "";
  var endingDateAndTime = "";
  var countryCode = 108;
  var eventDate = "";
  ValueNotifier<String?> currentEventValueNotifier = ValueNotifier(null);
  ValueNotifier<String?> currentPackageValueNotifier = ValueNotifier(null);
  ValueNotifier<String?> eventDateValueNotifier = ValueNotifier("");
  ValueNotifier<bool> bookingVisibilityValueNotifier = ValueNotifier(true);
  ValueNotifier<bool> mobileErrorMessageVisibilityNotifier =
      ValueNotifier(false);
  ValueNotifier<bool> nameErrorMessageVisibilityNotifier = ValueNotifier(false);
  ValueNotifier<bool> emailErrorMessageVisibilityNotifier =
      ValueNotifier(false);
  ValueNotifier<bool> dateErrorMessageVisibilityNotifier = ValueNotifier(false);
  ValueNotifier<bool> eventErrorMessageVisibilityNotifier =
      ValueNotifier(false);
  TextEditingController remarksController = TextEditingController();

  ///FocusNode
  final FocusNode _eventDateFocus = FocusNode();
  final FocusNode _eventTypeFocus = FocusNode();
  String nameErrorMessage = "";
  String emailErrorMessage = "";
  String mobileErrorMessage = "";
  String eventErrorMessage = "";
  String dateErrorMessage = "";
  bool emailErrorMessageVisibility = false;
  var primaryColor;
  var accentColor;

  bool? isBeforeLogin;

  BaseWidget<BookMeRouteModel>? baseWidget;
  String? platformCountryCode = '';
  var keyChat = GlobalKey();
  GlobalKey<BookMeState> myWidgetKey = GlobalKey<BookMeState>();

  @override
  void initState() {
    //  getDeviceLocal();
    super.initState();
    showLog('booking page init state');

    getBeforeLoginStatus();
  }

  Future<bool?> getBeforeLoginStatus() async {
    var prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(isUserLoggedInPreferenceKey) ?? false;
    showLog('the login value where $isLoggedIn');
    isBeforeLogin = !isLoggedIn;
    return null; // opposite value
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems(
      List<appConf.EventCategory> eventCategories) {
    List<DropdownMenuItem<String>> items = [];
    for (appConf.EventCategory event in eventCategories) {
      items.add(
        DropdownMenuItem(
          value: "${event.code}",
          child: CommonText(
            text: event.name!,
            style: Theme.of(context).textTheme.titleMedium,
            //fontSize: TextProperty.h3,
          ),
        ),
      );
    }
    return items;
  }

  List<String> getEventCategoryStrings(
      List<appConf.EventCategory> eventCategories) {
    List<String> eventCategoryStrings = [];

    for (appConf.EventCategory event in eventCategories) {
      // Add the name or code of the event category to the list
      eventCategoryStrings.add(event.name ??
          event.code!); // Use 'event.name' if available, otherwise 'event.code'
    }

    return eventCategoryStrings;
  }

  List<DropdownMenuItem<String>> getPackageDropDownMenuItems(
      List<appDb.StudioPackageData> eventPackageList) {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i <= eventPackageList.length - 1; i++) {
      items.add(
        DropdownMenuItem(
          value: "${eventPackageList[i].code}",
          child: CommonText(
            text: eventPackageList[i].name!,
            style: Theme.of(context).textTheme.titleMedium,
            //fontSize: TextProperty.h3,
          ),
        ),
      );
      //setState(() {
      //});
    }
    return items;
  }

  ///Widgets
  Widget districtsSuggestionView(String district) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CommonText(
          text: district,
          style: Theme.of(context).textTheme.titleMedium,
          // fontSize: TextProperty.h3,
        ),
        /*Text(
          district,
          style: TextStyle(fontSize: 16.0),
        ),*/
      ),
    );
  }

  Widget errorMessageShow(String errorMessage) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 8, bottom: 2),
          child: CommonText(
            text: errorMessage,
            style: Theme.of(context).textTheme.labelMedium,
            // fontSize: TextProperty.h3,
          ),
          /* Text(
            errorMessage,
            style: TextStyle(fontSize: 14, color: Colors.red),
          ),*/
        ),
      ],
    );
  }

  FileUtil fileUtil = FileUtil();
  FileModelDao fileModelDao = FileModelDao();
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    primaryColor = Theme.of(context).primaryColor;
    baseWidget = BaseWidget<BookMeRouteModel>(
        model: BookMeRouteModel(
            apiHandler: Provider.of(context, listen: false), context: context),
        onModelReady: (model) => model.getEventTypes(),
        builder: (context, model, child) {
          eventStoreApiCall(model);
          return Stack(
            children: <Widget>[
              Positioned(
                top: 130,
                right: 10,
                left: 10,
                child: Container(
                  child: TableCalendar(
                    headerStyle: HeaderStyle(
                        titleTextStyle: TextStyle(
                            color: AppColorData.appBarTextColor, fontSize: 16),
                        rightChevronIcon: Icon(
                          Icons.arrow_forward_ios_sharp,
                          size: 15,
                          color: AppColorData.appBarTextColor,
                        ),
                        leftChevronIcon: Icon(
                          Icons.arrow_back_ios_sharp,
                          size: 15,
                          color: AppColorData.appBarTextColor,
                        ),
                        titleCentered: true),
                    calendarStyle: CalendarStyle(
                      defaultTextStyle:
                          TextStyle(color: AppColorData.appBarTextColor),
                      todayTextStyle:
                          TextStyle(color: AppColorData.backgroundColors.first),
                      todayDecoration: BoxDecoration(
                        color: AppColorData.appBarTextColor,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: AppColorData.dateSelectedTextBg,
                        shape: BoxShape.circle,
                      ),
                    ),
                    firstDay: DateTime.now(),
                    lastDay: DateTime(2100),
                    focusedDay: _focusedDay,
                    availableCalendarFormats: {
                      // CalendarFormat.month: 'Month',
                      CalendarFormat.twoWeeks: '2 weeks',
                      //CalendarFormat.week: 'Week',
                    },
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        selectedDate = selectedDay;
                        eventDateValueNotifier.value =
                            "${selectedDay.day}-${selectedDay.month}-${selectedDay.year}";
                        setState(() {
                          dateErrorMessageVisibilityNotifier.value = false;
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      }
                    },
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        // Call `setState()` when updating calendar format
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 65, left: 18.0, right: 18),
                child: Row(
                  children: [
                    (AppColorData.menuPosition != true)
                        ? SizedBox()
                        : MenuButton(),
                    UniqueText(
                      text: S.of(context).event_booking,
                      letterSpacing: 1.5,
                    ),
                    Spacer(),
                    IconButton(
                      splashRadius: 18,
                      onPressed: () async {
                        await Navigator.pushNamed(context, RoutePaths.AddEvent);
                      },
                      icon: Icon(
                        Icons.qr_code_scanner,
                        size: 28,
                        color: AppColorData.appBarTextColor,
                      ),
                    ),
                    (AppColorData.menuPosition == true)
                        ? SizedBox()
                        : MenuButton(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 300.0),
                child: _setEventBookingContent(context, model),
              ),
              model.busy ? _setBusy(context) : SizedBox()
            ],
          );
        });
    return baseWidget!;
  }

  Future<void> changedDropDownItem(
      BookMeRouteModel model, selectedEvent) async {
    //setState(() {
    _eventTypeFocus.unfocus();
    FocusScope.of(context).requestFocus(_eventDateFocus);
    //_currentEvent = selectedEvent;
    currentEventValueNotifier.value = selectedEvent;
    eventErrorMessageVisibilityNotifier.value = false;
  }

  Future<void> changedPackageDropDownItem(
      BookMeRouteModel model, selectedPackage) async {
    //setState(() {
    _eventTypeFocus.unfocus();

    FocusScope.of(context).requestFocus(_eventDateFocus);
    currentPackageValueNotifier.value = selectedPackage;
    eventErrorMessageVisibilityNotifier.value = false;
  }

  double buttonOrientationWidth(bool beforeLogin) {
    return beforeLogin == true
        ? MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width / 1.1
            : MediaQuery.of(context).size.width / 1.1
        : MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width / 1.1
            : MediaQuery.of(context).size.width / 1.1;
  }

  double buttonOrientationHeight(bool beforeLogin) {
    return beforeLogin == true
        ? MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height / 0.88
            : MediaQuery.of(context).size.width / 1.05
        : MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height / 2.35
            : MediaQuery.of(context).size.width / 2.35;
  }

  _setBusy(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CommonCircularProgress(),
        ],
      ),
    );
  }

  void _removeAllFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _onAfterLoginSubmit(BookMeRouteModel model) {
    showLog('step 3 >> ${currentEventValueNotifier.value}');
    if (currentEventValueNotifier.value != null) {
      if (eventDateValueNotifier.value != null) {
        showLog("if event date $eventDate");
        selectedDate == null ? selectedDate = DateTime.now() : null;
        if (selectedDate!.difference(DateTime.now()).inDays >= 0) {
          model
              .afterLoginBookMeApiCall(
                  currentEventValueNotifier.value!,
                  "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}",
                  remarksController.text,
                  currentPackageValueNotifier.value)
              .then((response) async {
            if (response != null) {
              if (response.status == false) {
                try {
                  ToastUtil.showSnackBarAtCurrentState(response.errorMessage ??
                      S.of(context).somethingWentWrong);
                } catch (e) {
                  showLog('book_me_rout_model-> 1 ) > ${e.toString()}');
                }
                return null;
              }
              eventDateValueNotifier.value = "";
              ToastUtil.showSnackBarAtCurrentState(
                  S.of(context).eventEnquirySentSuccessfully);

              var appConfig = TransporterPreference();
              appConf.TransportModel? studioDetails =
                  await appConfig.getAppConfig();
              String? studioName = studioDetails!.studioData!.data!.name;
              SideDrawerModel drawerModel =
                  Provider.of<SideDrawerModel>(context, listen: false);
              drawerModel.setDrawerChild(
                  GalleryRoute(),
                  studioName ?? "",
                  SideDrawerConstants.CustomerHome,
                  BottomNavigationConstants.CustomerHome);
            }
          });
        } else {
          showLog("try");
          dateErrorMessage = S.of(context).please_select_correct_event_date;
          dateErrorMessageVisibilityNotifier.value = true;
        }
      } else {
        showLog("else event date $eventDate");
        dateErrorMessage = S.of(context).please_select_event_date;
        dateErrorMessageVisibilityNotifier.value = true;
      }
    } else {
      eventErrorMessage = S.of(context).please_select_event_type;
      eventErrorMessageVisibilityNotifier.value = true;
    }
  }

  _setEventBookingContent(
    BuildContext context,
    BookMeRouteModel model,
  ) {
    var width = MediaQuery.of(context).size.width * .1;

    //data is login status
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Center(
        child: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                Card(
                  color: Colors.transparent,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  elevation: 15,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(top: BorderSide(width: 1.5)),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                CustomItemTransition(
                                  duration: itemTransitionDuration,
                                  delay: itemTransitionDelay,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: AnimatedTextKit(
                                        totalRepeatCount: 1,
                                        animatedTexts: [
                                          TyperAnimatedText(
                                            S
                                                .of(context)
                                                .book_us_for_your_special_occasion,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    color: AppColorData
                                                        .cardNormalTextColour,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                        ],
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                CustomItemTransition(
                                  duration: itemTransitionDuration,
                                  delay: itemTransitionDelay + 100,
                                  child: Padding(
                                    padding: getTopPadding(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            flex: MediaQuery.of(context)
                                                        .orientation ==
                                                    Orientation.portrait
                                                ? 6
                                                : 11,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: AppColorData
                                                      .appBarTextColor
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton2(
                                                    isExpanded: true,
                                                    focusNode: _eventTypeFocus,
                                                    hint:
                                                        CircularAnimatedHintTextField(
                                                      fieldBackgroundColor:
                                                          Colors.transparent,
                                                      fieldBorder: Border(),
                                                      staticHintText: '',
                                                      staticHintTextStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .labelLarge,
                                                      hints: getEventCategoryStrings(
                                                          model
                                                              .eventCategories),
                                                      animatedHintTextStyle:
                                                          TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    value:
                                                        currentEventValueNotifier
                                                            .value,
                                                    items: getDropDownMenuItems(
                                                        model.eventCategories),
                                                    onChanged: (selectedEvent) {
                                                      _removeAllFocus();
                                                      showLog(
                                                          'the selected event ${selectedEvent}');
                                                      changedDropDownItem(
                                                          model, selectedEvent);
                                                    }),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                CustomItemTransition(
                                  duration: itemTransitionDuration,
                                  delay: itemTransitionDelay + 200,
                                  child: ValueListenableBuilder(
                                      valueListenable:
                                          eventErrorMessageVisibilityNotifier,
                                      builder: (context,
                                          eventErrorMessageVisibility, child) {
                                        return Visibility(
                                          visible:
                                              eventErrorMessageVisibility ==
                                                  true,
                                          child: errorMessageShow(
                                              eventErrorMessage),
                                        );
                                      }),
                                ),
                                //Event Date
                                CustomItemTransition(
                                  duration: itemTransitionDuration,
                                  delay: itemTransitionDelay + 300,
                                  child: Padding(
                                    padding: getTopPadding(),
                                    child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColorData.appBarTextColor
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 18.0),
                                          child: ValueListenableBuilder<
                                                  String?>(
                                              valueListenable:
                                                  eventDateValueNotifier,
                                              builder: (context, value, child) {
                                                return CommonTextField(
                                                  readOnly: true,
                                                  focusNode: _eventDateFocus,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  labelText: value == "" ||
                                                          value!.isEmpty
                                                      ? DateFormat('dd/MM/yyyy')
                                                          .format(DateTime
                                                              .now()) //S.of(context).select_date
                                                      : value,
                                                  labelStyle: value == "" ||
                                                          value!.isEmpty
                                                      ? Theme.of(context)
                                                          .textTheme
                                                          .labelLarge
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .titleMedium,
                                                  cardIconChild: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Icon(
                                                        Icons.date_range,
                                                        color: AppColorData
                                                            .bgIconColor),
                                                  ),
                                                  controller:
                                                      TextEditingController(),
                                                );
                                              }),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                CustomItemTransition(
                                  duration: itemTransitionDuration,
                                  delay: itemTransitionDelay + 400,
                                  child: ValueListenableBuilder(
                                      valueListenable:
                                          dateErrorMessageVisibilityNotifier,
                                      //new
                                      builder: (context,
                                          dateErrorMessageVisibility, child) {
                                        return Visibility(
                                          visible: dateErrorMessageVisibility ==
                                              true,
                                          child: errorMessageShow(
                                              dateErrorMessage),
                                        );
                                      }),
                                ),
                                CustomItemTransition(
                                  duration: itemTransitionDuration,
                                  delay: itemTransitionDelay + 500,
                                  child: Padding(
                                    padding: getTopPadding(),
                                    child: Container(
                                      /*  decoration: BoxDecoration(
                                          border: Border.fromBorderSide(
                                              BorderSide()),
                                          borderRadius:
                                              BorderRadius.circular(10)),*/
                                      decoration: BoxDecoration(
                                          color: AppColorData.appBarTextColor
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 18.0),
                                        child: Consumer<BookMeProvider>(
                                            builder: (context, data, widget) {
                                          return CommonTextField(
                                            focusNode: data.bookMeFocus,
                                            showCursor: true,
                                            enabled: true,
                                            controller: remarksController,
                                            cardIconChild: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Icon(
                                                  FontAwesomeIcons.commentDots,
                                                  color:
                                                      AppColorData.bgIconColor),
                                            ),
                                            hintText: S.of(context).comment,
                                            labelStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          );
                                        }),
                                        /*  TextField(
                                              style: Theme.of(context).textTheme.titleMedium,
                                              controller: remarksController,
                                              decoration: InputDecoration(
                                                  suffixIcon: Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child:
                                                    Container(
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors: AppColorData
                                                                  .bgIconBackgroundColor),
                                                          borderRadius: BorderRadius.only(
                                                            topRight: Radius.circular(10),
                                                            bottomRight:
                                                                Radius.circular(10),
                                                            topLeft: Radius.circular(10),
                                                            bottomLeft:
                                                                Radius.circular(10),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(10),
                                                          child: Icon(
                                                              FontAwesomeIcons
                                                                  .commentDots,
                                                              color: AppColorData
                                                                  .bgIconColor),
                                                        )),
                                                  ),
                                                  hintStyle: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 14,
                                                      color:
                                                          AppColorData.normalTextColor),
                                                  labelText: S.of(context).remarks,
                                                  labelStyle: Theme.of(context).textTheme.labelLarge,
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        color: Colors.transparent,
                                                        width: 0.0),
                                                    borderRadius:
                                                        BorderRadius.circular(0.0),
                                                  ),
                                                  border: InputBorder.none),
                                              maxLines: null,
                                            ),*/
                                      ),
                                    ),
                                  ),
                                ),

                                //Submit Button
                                SizedBox(
                                  height: 25,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.fromLTRB(
                                          width, 0, width, 0),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor: AppColorData
                                          .buttonBackgroundColors.last,
                                      foregroundColor:
                                          AppColorData.buttonTextColors),
                                  child: CommonText(
                                    text: S.of(context).submit,
                                  ),
                                  onPressed: () async {
                                    InternetChecker myConnectivity =
                                        InternetChecker();
                                    myConnectivity.networkChecker(
                                        onTap: () async {
                                          if (isBeforeLogin == true) {
                                            showLog('before login true');
                                            if (selectedDate == null ||
                                                currentEventValueNotifier
                                                        .value ==
                                                    null) {
                                              if (selectedDate == null) {
                                                dateErrorMessageVisibilityNotifier
                                                    .value = true;
                                                dateErrorMessage = S
                                                    .of(context)
                                                    .chooseValidDate;
                                              }
                                              if (currentEventValueNotifier
                                                      .value ==
                                                  null) {
                                                eventErrorMessageVisibilityNotifier
                                                    .value = true;
                                                eventErrorMessage = S
                                                    .of(context)
                                                    .chooseEventType;
                                              }
                                              return;
                                            }
                                            // set preference
                                            BookingHandler().setBookingDetails(
                                                BookingDetail(
                                                    bookingDetail:
                                                        BookingDetailClass(
                                              packageCode:
                                                  currentPackageValueNotifier
                                                      .value,
                                              eventTypesCategoriesCode:
                                                  currentEventValueNotifier
                                                      .value,
                                              date: selectedDate.toString(),
                                              remarks: remarksController.text,
                                            )));
                                            // navigate to login page and return back
                                            ReDirectionPreference
                                                reDirectionPreference =
                                                ReDirectionPreference();
                                            await reDirectionPreference
                                                .setReDirectionDetails(RedirectionModel(
                                                    redirection: Redirection(
                                                        route:
                                                            RedirectionRouteConstant
                                                                .BookingRoute)));
                                            SideDrawerModel drawerModel =
                                                Provider.of<SideDrawerModel>(
                                                    context,
                                                    listen: false);
                                            drawerModel.setPendingNavigation(
                                                SideDrawerModel()
                                                  ..drawerChild =
                                                      GalleryRoute());
                                            drawerModel.setDrawerChild(
                                                LoginRoute(true),
                                                S.of(context).login,
                                                SideDrawerConstants.GuestLogin,
                                                BottomNavigationConstants
                                                    .GuestLogin);
                                            showLog('Login route returned');
                                            // _setBusy(context);
                                            bool status =
                                                await PreferenceHelper.getBool(
                                                    isUserLoggedInPreferenceKey);
                                            if (status) {
                                              showLog('api call for booking');
                                              _onAfterLoginSubmit(model);
                                            }
                                          } else if (isBeforeLogin == false) {
                                            showLog('message->false');
                                            // remove this line for api call
                                            _onAfterLoginSubmit(model);
                                          } else {
                                            showLog(
                                                'the before value is ${isBeforeLogin}');
                                          }
                                        },
                                        context: context);
                                  },
                                ),
                                Padding(
                                  padding: getTopPadding(),
                                  child: CommonTextButton(
                                    buttonText: S.of(context).contactUs,
                                    underline: true,
                                    onPressCall: () {
                                      Navigator.pushNamed(
                                          context, RoutePaths.ContactUs,
                                          //S.of(context).contactUs,
                                          arguments:
                                              ContactUs(appbarRequired: true));
                                    },
                                  ),
                                ),

                                UIHelper.verticalSpaceSmall,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            ValueListenableBuilder<String?>(
                valueListenable: model.whatsappNumber,
                builder: (BuildContext context, String? value, Widget? child) {
                  return (value != null && value.isNotEmpty)
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton(
                              key: myWidgetKey,
                              backgroundColor: Colors.transparent,
                              onPressed: () async {
                                await model.launchWhatsapp(context);
                              },
                              child:
                                  Image.asset('assets/images/logoWhatsapp.png'),
                            ),
                          ))
                      : SizedBox();
                }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    showLog('dispose :: ');
    if (baseWidget != null && baseWidget?.model != null) {
      baseWidget?.model.destroy();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    context.dependOnInheritedWidgetOfExactType();
    super.didChangeDependencies();
  }

  void eventStoreApiCall(BookMeRouteModel model) async {
    BookingDetail? bookingDetails = await BookingHandler().getBookingDetails();
    if (bookingDetails != null &&
        bookingDetails.bookingDetail?.eventTypesCategoriesCode != null &&
        bookingDetails.bookingDetail!.eventTypesCategoriesCode != '') {
      currentEventValueNotifier =
          ValueNotifier(bookingDetails.bookingDetail?.eventTypesCategoriesCode);
      try {
        selectedDate = DateTime.parse(bookingDetails.bookingDetail!.date!);

        eventDateValueNotifier.value =
            '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}';
      } catch (e) {
        showLog('the error while parsing date $e');
      }

      remarksController.text = bookingDetails.bookingDetail!.remarks!;
      currentPackageValueNotifier =
          ValueNotifier(bookingDetails.bookingDetail!.packageCode);
      //_onAfterLoginSubmit(model);
    }
  }

  getTopPadding() {
    return EdgeInsets.only(top: 18.0);
  }
}

class BookMeProvider extends ChangeNotifier {
  BookMeProvider();

  final FocusNode bookMeFocus = FocusNode();

  Future<bool> unFocusMethod() async {
    if (!bookMeFocus.hasFocus) {
      return Future.delayed(Duration(milliseconds: 1), () {
        return true;
      });
    } else {
      bookMeFocus.unfocus();
      notifyListeners();
      return Future.delayed(Duration(milliseconds: 200), () {
        return true;
      });
    }
  }
}
