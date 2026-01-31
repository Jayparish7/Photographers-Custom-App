import 'dart:convert';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart' as transporter;
import 'package:photomall_flutter/driftdb/dao/event_info_dao.dart';
import 'package:photomall_flutter/preference/preference_model/event_info_preference_model.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import '../core/constants/common_constants.dart';
import 'package:drift/drift.dart' as drift;

class EventInfoController{
  EventInfoDao eventInfoDao = EventInfoDao();
  Future<void>upsertEventInfo({
    required String eventCode,
    String? eventName,
    transporter.Address? address,
    transporter.EventDuration? duration,
    List<transporter.Subevent>? subEvents}) async {
   // get local event by code

    appDb.EventInfoData? eventInfoData = await  eventInfoDao.getInfoByCode(eventCode);
      if(eventInfoData != null){
        // delete that event and insert in db
        await  eventInfoDao.deleteEventInfo(eventCode);
        await  eventInfoDao.insertEventInfo(
            EventInfoPreference(
              eventInfo:EventInfo(
                data: Data(
                  code: eventCode,
                  name: eventName ?? '',
                  address: address,
                  duration:
                  duration == null ?
                null
                  : duration.endTime != null ?
                  transporter.EventDuration(
                      endTime: duration.endTime,
                      startTime: duration.startTime
                  ) :
                  transporter.EventDuration(
                      startTime: duration.startTime
                  ),
                  subevents:subEvents,
                )
              ),
            )
        );
      }
      else{
        await  eventInfoDao.insertEventInfo(
            EventInfoPreference(
              eventInfo:EventInfo(
                  data: Data(
                    code: eventCode,
                    name: eventName,
                    address: address,
                    duration: duration == null ? null :

                    transporter.EventDuration(
                        endTime: duration.endTime ?? null,
                        startTime: duration.startTime ?? null
                    ) ,
                    subevents:subEvents,
                  )
              ),
            )
        );

      }
  }

  Future<void>upsertEventsInformation( {
    required List<transporter.EventDetailedData> eventDetaildatas,
                    }) async {
    EventInfoDao eventInfoDao = EventInfoDao();
    List<appDb.EventInfoCompanion> eventInfoCompanions = [];

    // get local event by code
            for(transporter.EventDetailedData eventDetaildata
            in eventDetaildatas) {
              String eventCode = eventDetaildata.code!;
              String eventName = eventDetaildata.name!;
              transporter.Address? address = eventDetaildata.address;
              transporter.EventDuration? duration = eventDetaildata.duration;
              List<transporter.Subevent>? subEvents = eventDetaildata.subevents;
              appDb.EventInfoData? eventInfoData = await eventInfoDao
                  .getInfoByCode(eventCode);
              if (eventInfoData != null) {
                // delete that event and insert in db
                await eventInfoDao.deleteEventInfo(eventCode);
                EventInfoPreference data =  EventInfoPreference(
                  eventInfo: EventInfo(
                      data: Data(
                        code: eventCode,
                        name: eventName,
                        address: address,
                        duration:
                        duration == null ?
                        null
                            : duration.endTime != null ?
                        transporter.EventDuration(
                            endTime: duration.endTime,
                            startTime: duration.startTime
                        ) :
                        transporter.EventDuration(
                            startTime: duration.startTime
                        ),
                        subevents: subEvents,
                      )
                  ),
                );
                String value =  await convertEventInfoObjectToString(data);
                eventInfoCompanions.add(
                    appDb.EventInfoCompanion(
                        eventCode:drift.Value(data.eventInfo!.data!.code!) ,
                        value: drift.Value(value)
                    ));
              }
              else {
                EventInfoPreference data =  EventInfoPreference(
                  eventInfo: EventInfo(
                      data: Data(
                        code: eventCode,
                        name: eventName,
                        address: address,
                        duration: duration == null ? null :

                        transporter.EventDuration(
                            endTime: duration.endTime ?? null,
                            startTime: duration.startTime ?? null
                        ),
                        subevents: subEvents,
                      )
                  ),
                );
                String value =  await convertEventInfoObjectToString(data);
                eventInfoCompanions.add(
                    appDb.EventInfoCompanion(
                    eventCode:drift.Value(data.eventInfo!.data!.code!) ,
                    value: drift.Value(value)
                ));
              }
            }
            if(eventInfoCompanions.isNotEmpty){
            await  eventInfoDao.insertAll(eventInfoCompanions);
            }

  }


  Future<String> convertEventInfoObjectToString(EventInfoPreference eventInfoPreference) async {
    try{
      showLog("converted info ${jsonEncode(eventInfoPreference.toJson())}");
      return jsonEncode(eventInfoPreference.toJson());
    }catch(e){
      showLog('error while converting to STRING @ event info controller info\n $e \n');
      return " ";
    }
  }
  Future<EventInfoPreference?> getEventInfoValue(String code) async {
  appDb.EventInfoData? eventInfoData = await eventInfoDao.getInfoByCode(code);
   String eventInfoValue = eventInfoData!.value.toString();
    String value = eventInfoValue;
    if (value.isEmpty) {
      showLog('value empty');
      return null;
    }
    showLog('user_data is $value');
    Map<String, dynamic> jsonMap =
    jsonDecode(value) as Map<String, dynamic>;
    return EventInfoPreference.fromJson(jsonMap);
  }
}