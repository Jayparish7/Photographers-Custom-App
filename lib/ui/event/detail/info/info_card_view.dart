import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/schedule_notification_controller.dart';
import 'package:photomall_flutter/core/Utils/address_utils.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/traits/common_widgets/common_card.dart';
import 'package:photomall_flutter/traits/common_widgets/map_utils.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_outlinedButton.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';

class InfoCustomCardWidget extends StatelessWidget {
  final String? name;
  final String? eventName;
  final transporter.EventDuration? duration;
  final transporter.Address? eventAddress;

  InfoCustomCardWidget(
      {Key? key, this.name, this.eventName, this.duration, this.eventAddress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat timeFormat = DateFormat("hh:mm a");
    DateFormat monthFormat = DateFormat("MMM");
    DateFormat weekDayFormat = DateFormat("EEE");
    EdgeInsets contentPadding = EdgeInsets.only(top: 0, bottom: 0);
    DateTime? startDate;
    DateTime? endDate;
    String? formattedStartDate;
    String? formattedEndDate;
    String? formattedStartTime;
    String? formattedEndTime;

    if (duration != null) {
      if (duration!.startTime != null) {
        showLog("the start date where ${duration!.startTime}");
        startDate = DateTime.parse(duration!.startTime!);
        showLog("the start date where ${startDate}");
      }
      if (duration!.endTime != null) {
        endDate = DateTime.parse(duration!.endTime!);
      }
    }
    if (startDate != null) {
      formattedStartDate = DateFormat("yyyy-MM-dd").format(startDate);
    }
    if (endDate != null) {
      formattedEndDate = DateFormat("yyyy-MM-dd").format(endDate);
    }
    if (endDate != null) {
      formattedEndTime = DateFormat('hh:mm a').format(endDate);
    }
    showLog('the start date is $startDate');

    if (startDate != null) {
      formattedStartTime = DateFormat('hh:mm a').format(startDate);
    }
    return Stack(
      children: [
        (eventAddress != null && eventAddress != "")
            ? InkWell(
                onTap: () {
                  MapUtils mapUtils = MapUtils();
                  mapUtils.openMapByAddress(address: eventAddress!);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/googleMap.png',
                          ),
                          Positioned(
                              top: MediaQuery.of(context).size.height * 0.3,
                              left: MediaQuery.of(context).size.width * 0.34,
                              child: Column(
                                children: [
                                  Lottie.asset(
                                      height: 100,
                                      alignment: Alignment.center,
                                      'assets/animations/location.json'),
                                  UniqueText(
                                    text: 'Get Direction',
                                    isTitle: false,
                                    isBold: false,
                                    fontSize: 20,
                                    letterSpacing: 1.5,
                                  )
                                ],
                              )),
                        ],
                      )),
                ),
              )
            : SizedBox(),
        Positioned(
          bottom: 25,
          left: MediaQuery.of(context).size.width * 0.12,
          child: CommonCard(
            shape: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(35.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(1)),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (duration != null)
                          ? Expanded(
                              child: Padding(
                                  padding: contentPadding,
                                  child: getCompareDate(
                                    context,
                                    timeFormat,
                                    weekDayFormat,
                                    monthFormat,
                                    startDate,
                                    endDate,
                                    formattedStartDate,
                                    formattedStartTime,
                                    formattedEndDate,
                                    formattedEndTime,
                                  )),
                            )
                          : SizedBox(),
                      (eventName != null && eventName!.isNotEmpty)
                          ? CommonText(
                              isCard: true,
                              isHighlightedCard: true,
                              text: '${eventName}',
                              style: Theme.of(context).textTheme.headlineSmall,
                            )
                          : SizedBox(),
                      (eventAddress != null && eventAddress != "")
                          ? Column(
                              children: [
                                CommonText(
                                  isCard: true,
                                  text:
                                      "     ${AddressUtils.getAddressForInfo(eventAddress!, 0)}"
                                      "\n${AddressUtils.getAddressForInfo(eventAddress!, 1)}"
                                      "\n          ${AddressUtils.getAddressForInfo(eventAddress!, 2)}",
                                ),
                                (duration != null)
                                    ? Padding(
                                        padding: contentPadding,
                                        child: CommonOutlinedButton(
                                          text: S.of(context).setReminder,
                                          icon: Icons.date_range,
                                          onPressCall: () {
                                            showLog("set reminder working");
                                            DateAndTimeUtils data =
                                                DateAndTimeUtils();
                                            data.setReminder(
                                                context: context,
                                                startDate: duration!.startTime,
                                                endDate: duration!.endTime,
                                                title: eventName ??
                                                    name ??
                                                    S.of(context).setReminder);
                                          },
                                        ))
                                    : SizedBox(),
                              ],
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

/*  bool getCompareDate(
      DateTime startDate,
      DateTime endDate
      ) {
    if(startDate.compareTo(endDate) == 0){
      showLog("Both date time are at same moment.");
      return false;
    }
    else {
        showLog("startDate: $startDate is before endDate:$endDate");
      return true;
    }

  }*/
  String getEventDurationText(BuildContext context,
      {DateFormat? fullDateFormat,
      DateFormat? timeFormat,
      DateTime? startDate,
      DateTime? endDate}) {
    String finalValidate =
        " ${endDate?.hour != null ? ('${S.of(context).from}' '${timeFormat!.format(startDate!)}, ${S.of(context).to} ${timeFormat.format(endDate!)}') : "('${S.of(context).at} '${timeFormat!.format(startDate!)}')"}";
    return finalValidate;
  }

  Widget? getCompareDate(
    BuildContext context,
    DateFormat? timeFormat,
    DateFormat? weekDayFormat,
    DateFormat? monthFormat,
    DateTime? startDate,
    DateTime? endDate,
    String? formattedStartDate,
    String? formattedStartTime,
    String? formattedEndDate,
    String? formattedEndTime,
  ) {
    if (startDate != null) {
      if (formattedStartDate == formattedEndDate) {
        showLog("from equal to date >> $formattedStartDate $formattedEndDate");
        if (formattedStartTime == formattedEndTime) {
          showLog(
              "from equal to time >> ${formattedStartTime} ${formattedEndTime}");
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              (duration != null)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 0.0),
                      child: CommonText(
                        isCard: true,
                        isHighlightedCard: true,
                        text:
                            "${(weekDayFormat!.format(startDate).toUpperCase())}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    )
                  : SizedBox(),
              (duration != null)
                  ? Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          (duration != null)
                              ? CommonText(
                                  isCard: true,
                                  isHighlightedCard: false,
                                  text: "${monthFormat!.format(startDate)}",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )
                              : SizedBox(),
                          (duration != null)
                              ? Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: CommonText(
                                    isCard: true,
                                    isHighlightedCard: true,
                                    textAlign: TextAlign.center,
                                    text: "${startDate.day}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                )
                              : SizedBox(),
                          (duration != null)
                              ? Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: CommonText(
                                    isCard: true,
                                    isHighlightedCard: false,
                                    text: "${startDate.year}",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    )
                  : SizedBox(),
              CommonText(
                isCard: true,
                text: " ${timeFormat!.format(startDate)}",
              ),
            ],
          );
        } else {
          showLog(
              "from not equal to to time >>${formattedStartTime} ${formattedEndTime}");
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              (duration != null)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 0.0),
                      child: CommonText(
                        isCard: true,
                        isHighlightedCard: true,
                        text:
                            "${(weekDayFormat!.format(startDate).toUpperCase())}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    )
                  : SizedBox(),
              (duration != null)
                  ? Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          (duration != null)
                              ? CommonText(
                                  isCard: true,
                                  isHighlightedCard: false,
                                  text: "${monthFormat!.format(startDate)}",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )
                              : SizedBox(),
                          (duration != null)
                              ? Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: CommonText(
                                    isCard: true,
                                    isHighlightedCard: true,
                                    textAlign: TextAlign.center,
                                    text: "${startDate.day}",
                                  ),
                                )
                              : SizedBox(),
                          (duration != null)
                              ? Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: CommonText(
                                    isCard: true,
                                    text: "${startDate.year}",
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    )
                  : SizedBox(),
              CommonText(
                isCard: true,
                text:
                    "${S.of(context).from} ${timeFormat!.format(startDate)}, ${S.of(context).to} ${timeFormat.format(endDate!)}",
              ),
            ],
          );
        }
      } else {
        showLog(
            "from not equal to date >> $formattedStartDate $formattedEndDate");
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          // alignment: WrapAlignment.spaceBetween,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (duration != null)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 0.0),
                        child: CommonText(
                          isCard: true,
                          isHighlightedCard: true,
                          text:
                              "${(weekDayFormat!.format(startDate).toUpperCase())}",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      )
                    : SizedBox(),
                (duration != null)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          (duration != null)
                              ? CommonText(
                                  isCard: true,
                                  isHighlightedCard: false,
                                  text: "${monthFormat!.format(startDate)}",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )
                              : SizedBox(),
                          (duration != null)
                              ? Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: CommonText(
                                    isCard: true,
                                    isHighlightedCard: true,
                                    textAlign: TextAlign.center,
                                    text: "${startDate.day}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                )
                              : SizedBox(),
                          (duration != null)
                              ? Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: CommonText(
                                    isCard: true,
                                    isHighlightedCard: false,
                                    text: "${startDate.year}",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                )
                              : SizedBox(),
                        ],
                      )
                    : SizedBox(),
                CommonText(
                  isCard: true,
                  isHighlightedCard: false,
                  text: //getEventDurationText(context,timeFormat: timeFormat,fullDateFormat: fullDateFormat,endDate: endDate,startDate: startDate)
                      " ${timeFormat!.format(startDate)}",
                ),
              ],
            ),
            (duration!.endTime != null)
                ? Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: CommonText(
                      isCard: true,
                      isHighlightedCard: false,
                      text: " ${S.of(context).to}",
                    ),
                  )
                : SizedBox(),
            (duration!.endTime != null)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      (duration != null)
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 0.0),
                              child: CommonText(
                                isCard: true,
                                isHighlightedCard: true,
                                text:
                                    "${(weekDayFormat!.format(endDate!).toUpperCase())}",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            )
                          : SizedBox(),
                      (duration != null)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                (duration != null)
                                    ? CommonText(
                                        isCard: true,
                                        isHighlightedCard: false,
                                        text:
                                            "${monthFormat!.format(endDate!)}",
                                      )
                                    : SizedBox(),
                                (duration != null)
                                    ? Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: CommonText(
                                          isCard: true,
                                          isHighlightedCard: true,
                                          textAlign: TextAlign.center,
                                          text: "${endDate!.day}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                      )
                                    : SizedBox(),
                                (duration != null)
                                    ? Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: CommonText(
                                          isCard: true,
                                          text: "${endDate!.year}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            )
                          : SizedBox(),
                      CommonText(
                          isCard: true,
                          text: //getEventDurationText(context,timeFormat: timeFormat,fullDateFormat: fullDateFormat,endDate: endDate,startDate: startDate)
                              " ${timeFormat.format(endDate!)}",
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  )
                : SizedBox(),
          ],
        );
      }
    }
    return null;
  }

/*getAddress(transporter.Address address) {
    String coma = ", ";
    String hyphen = " - ";
    String space = " ";
    String locality =
        "${address.locality == null ? "" : address.locality + coma}";
    String street = "${address.street == null ? "" : address.street + coma}";
    String district = "${address.district == null ? "" : address.district}";
    String pinCode =
        "${address.pincode == null ? "" : hyphen + address.pincode + space}";
    String state = "${address.state == null ? "" : address.state + coma}";
    //  String country = "${address.country ?? ""}";
    return "${locality}${street}${district}${pinCode}${state}";
  }*/
/*  String getAddress(transporter.Address address) {
    String separator = ", ";
    String separator2 = "-";
    String state = "${address.state == null ? "" : address.state + separator}";
    String district =
        "${address.district == null ? "" : address.district + separator2}";
    String street =
        "${address.street == null ? "" : address.street + separator}";
    String locality = "${address.locality == null ? "" : address.locality}";
    String pinCode =
        "${address.pincode == null ? "" : address.pincode + separator}";
    String country = "${address.country ?? ""}";
    return "${street}${locality}\n${district}${pinCode}\n${state}${country}";
  }*/
}
