import 'dart:async';
import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/event_info_controller.dart';
import 'package:photomall_flutter/core/Utils/file_util.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/preference/preference_model/event_info_preference_model.dart';
import 'package:photomall_flutter/ui/base/base_widget.dart';
import 'package:photomall_flutter/ui/event/detail/info/archive_widget.dart';
import 'package:photomall_flutter/ui/event/detail/info/event_info_data_view_model.dart';
import 'package:photomall_flutter/ui/event/detail/info/info_card_view.dart';
import 'package:photomall_flutter/ui/shared_widgets/common.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:provider/provider.dart';

class EventInfoDataView extends StatefulWidget {
  final String eventCode;
  final bool? isDemoEvent;
  final Key? key;

  EventInfoDataView(this.eventCode, {this.key, this.isDemoEvent})
      : super(key: key);

  @override
  EventInfoDataViewState createState() => EventInfoDataViewState();
}

class EventInfoDataViewState extends State<EventInfoDataView> {
  StreamController<int> _currentVisiblePosition = StreamController();

  EventInfoDataViewModel? model;



  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _currentVisiblePosition.close();

  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<EventInfoDataViewModel>(
        model: EventInfoDataViewModel(
            apiHandler: Provider.of<ApiHelper>(context, listen: false),
            context: context),
        onModelReady: (model) =>
            model.getInvitationDetailsFromDb(widget.eventCode),
        builder: (context, model, child) {
          this.model = model;
          return model.busy
              ? Center(
                  child: CommonCircularProgress(),
                )
              : InvitationView(
                isDemoEvent: widget.isDemoEvent!,
                model: model,
                eventCode: widget.eventCode,
                context: context,
              );
        });
  }
}

class InvitationView extends StatefulWidget {
  final EventInfoDataViewModel? model;
  final String? eventCode;
  final BuildContext? context;
  final bool? isDemoEvent;

  InvitationView(
      {Key? key, this.model, this.eventCode, this.context, this.isDemoEvent})
      : super(key: key);

  @override
  State<InvitationView> createState() => _InvitationViewState();
}

EventInfoController eventInfoController = EventInfoController();

class _InvitationViewState extends State<InvitationView> {
  @override
  void initState() {
    super.initState();
  }

  FileUtil fileUtil = FileUtil();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.model!.isDemoEvent != true
            ? ArchiveWidget(
            isOwenEvent: widget.model!.isOwenEvent,
            eventCode: widget.eventCode,
            context: widget.context,
            model: widget.model)
            : SizedBox(),
        FutureBuilder<EventInfoPreference?>(
            future: eventInfoController.getEventInfoValue(widget.eventCode!),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CommonCircularProgress();
              }
              if (!snapshot.hasData || snapshot.hasError) {
                return EmptyView(
                  text: S.of(context).informationNotAvailable,
                  iconData: Icons.event_note_sharp,
                );
              }

              return Column(
                children: [
                 ((snapshot.data?.eventInfo?.data?.duration !=
                          null)  ||
                          (snapshot.data?.eventInfo?.data?.address != null)
                      )
                      ? InfoCustomCardWidget(
                          name: snapshot.data!.eventInfo!.data!.name!,
                          duration: snapshot.data!.eventInfo!.data!.duration,
                          eventName: null,
                          eventAddress: snapshot.data!.eventInfo!.data!.address)
                      : SizedBox(),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.eventInfo!.data!.subevents!.length,
                      itemBuilder: (context, index) {
                        return InfoCustomCardWidget(
                            eventName: snapshot
                                .data!.eventInfo!.data!.subevents![index].name!,
                            duration: snapshot
                                .data!.eventInfo!.data!.subevents![index].duration!,
                            eventAddress: snapshot
                                .data!.eventInfo!.data!.subevents![index].address!);
                      })
                ],
              );
            }),

      ],
    );
  }
}
