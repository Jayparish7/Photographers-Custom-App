import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporterModel;
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:photomall_flutter/driftdb/dao/album_dao.dart';
import 'package:photomall_flutter/driftdb/dao/media_dao.dart';
import 'package:photomall_flutter/driftdb/dao/photo_selection_table_dao.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart';
import 'package:photomall_flutter/driftdb/dao/video_dao.dart';
import 'package:photomall_flutter/ui/event/list/event_list_route_view_model.dart';
import 'package:photomall_flutter/ui/gallery/gallery_route_view_model.dart'
    as galleryViewModel;

import '../../core/constants/shared_preference_constants.dart';

class EventModelDao {
  AppDb database = AppDb();

  Future<Event?> getEventByPhotoSelectionCode(String code) async {
    var query = (database.select(database.events)
          ..where((tbl) {
            return (tbl.code.equalsExp(database.folders.eventCode));
          }))
        .join([
      drift.innerJoin(database.photoSelectionImages,
          database.photoSelectionImages.code.equals(code)),
      drift.innerJoin(
          database.folders,
          database.folders.code
              .equalsExp(database.photoSelectionImages.folderCode)),
    ]);
    query..limit(1);
    return query.map((row) {
      return row.readTableOrNull(database.events);
    }).getSingleOrNull();
  }

  /// Get all event method
  Future<Event?> getEventByCode(String code) async {
    return await (database.select(database.events)
          ..where((tbl) => tbl.code.equals(code))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<Event>> getEvent() async {
    return await database.select(database.events).get();
  }

  Future<List<Event>> getArchivedEvent() async {
    return await (database.select(database.events)
          ..where((tbl) {
            return (tbl.archived.equals(true)) & (tbl.published.equals(true));
          }))
        .get();
  }

  /// Delete event with code

  Future<int?> deleteEventByCode(String code) async {
    showLog('deleting this event ${code}...');
    await PreferenceHelper.deleteKeyFromMap(code, unAuthUserKey);
    await PreferenceHelper.deleteKeyFromMap(code, eventPrivatePrefKey);
    await PreferenceHelper.deleteKeyFromMap(code, userInputPrivatePrefKey);
    AlbumModelDao albumModelDao = AlbumModelDao();
    TransporterDao transporterDao = TransporterDao();
    MediaModelDao mediaModelDao = MediaModelDao();
    PhotoSelectionsDao photoSelectionStatusDao = PhotoSelectionsDao();
    VideoModelDao videoModelDao = VideoModelDao();
    // delete transporter
    await transporterDao.deleteTransporterByCodeAndTag(
        code: code, tag: TransportDataKeys.eventData);
    // delete media
    await mediaModelDao.deleteMediaByEventCode(code);
    // delete album
    await albumModelDao.deleteAlbumByEventCode(code);
    // delete videos
    await videoModelDao.deleteVideosByEventCode(code);

/*    // delete folder
    await folderModelDao.deleteFolderByEventCode(eventCode: code);
    // delete photo selection status
    await photoSelectionStatusDao
        .deletePhotoSelectionsEventCode(code);*/
    // delete photo selection status
    //await folderStatus.deleteFolderStatusBYFolderCode(code);

    // deletePhotoSelectionsFlow
    await photoSelectionStatusDao.deletePhotoSelectionsFlow(code);
    // delete event
    await (database.delete(database.events)
          ..where((tbl) => tbl.code.equals(code)))
        .go();
    showLog('this event ${code} successfully deleted');
    return null;
  }

  Future<void> toggleEventArchiveStatus(String code, bool status) async {
    await (database.update(database.events)
          ..where((tbl) => tbl.code.equals(code)))
        .write(EventsCompanion(archived: drift.Value(status)));
  }

  /// Update event with code

  Future<void> updateEventByCode(EventsCompanion entity, String compare) async {
    await (database.update(database.events)
          ..where((tbl) => tbl.code.equals(compare)))
        .write(entity);
  }

  Future<void> updateShareDate(String compare) async {
    DateTime currentDate = DateUtils.dateOnly(DateTime.now());

    showLog("date updating $currentDate");

    await (database.update(database.events)
          ..where((tbl) => tbl.code.equals(compare)))
        .write(EventsCompanion(shareDate: drift.Value(currentDate.toString())));
  }

  Future<void> toggleArchived(bool archived, String code) async {
    await (database.update(database.events)
          ..where((tbl) => tbl.code.equals(code)))
        .write(EventsCompanion(archived: drift.Value(archived)));
  }

  /// Insert  or update  entity
  Future<int?> insertOrUpdateEventWithCode({
    transporterModel.PhotoSelectionModel? photoSelectionData,
    required transporterModel.EventDetailedData event,
    required bool isUpdate,
    Event? localEvent,
  }) async {
    try {
      Event? _localEvent = localEvent;

      EventsCompanion eventEntity;
      showLog(
          'the person status for this event ${event.code} where ${event.personStatus}');

      if (isUpdate) {
        eventEntity = EventsCompanion(
          priorityScore: drift.Value(event.priorityScore!),
          code: drift.Value(event.code!),
          published: drift.Value(event.published == 1 ? true : false),
          name: drift.Value(event.name!),
          type: drift.Value(event.type!),
          newlyAdded: drift.Value(false),
          loginRequired: drift.Value(event.loginRequired == 1 ? true : false),
          categoryName: drift.Value(event.categoryName!),
          archived: drift.Value(_localEvent!.archived),
          ownedByUser: drift.Value(_localEvent.ownedByUser),
          downloadable: drift.Value(event.downloadable == 1 ? true : false),
          withIcon: drift.Value(event.downloadWithIcon == 1 ? true : false),
          withWaterMark:
              drift.Value(event.downloadWithWatermark == 1 ? true : false),
          personStatus: drift.Value(event.personStatus!),
        );
        if (event.type == userEvent && event.published == 1) {
          // Event? _localEvent = await getEventByCode(event.code!);
          /* // show push notification
            if (!_localEvent!.published) {
              NotifyUser notifyUser = NotifyUser();
              notifyUser.notifyNewEventToUser([event.code!]);
            }*/
        }
      } else {
        eventEntity = EventsCompanion(
          priorityScore: drift.Value(event.priorityScore!),
          code: drift.Value(event.code!),
          published: drift.Value(event.published == 1 ? true : false),
          name: drift.Value(event.name!),
          type: drift.Value(event.type!),
          newlyAdded: drift.Value(true),
          loginRequired: drift.Value(event.loginRequired == 1 ? true : false),
          categoryName: drift.Value(event.categoryName!),
          archived: drift.Value(false),
          ownedByUser: drift.Value(false),
          downloadable: drift.Value(event.downloadable == 1 ? true : false),
          withIcon: drift.Value(event.downloadWithIcon == 1 ? true : false),
          withWaterMark:
              drift.Value(event.downloadWithWatermark == 1 ? true : false),
          personStatus: drift.Value(event.personStatus!),
        );
      }

      return await database
          .into(database.events)
          .insertOnConflictUpdate(eventEntity);
    } catch (e) {
      return null;
    }
  }

  Future<void> insertAllEvents(
      {required List<EventsCompanion> eventsCompanions}) async {
    await database.batch((batch) {
      return batch.insertAllOnConflictUpdate(database.events, eventsCompanions);
    });
  }

  /// get gallery event
  Future<List<Event>> getGalleryEvent() async {
    return await (database.select(database.events)
          ..where((tbl) {
            return (tbl.type.equals(studioGalleyEvent)) &
                (tbl.published.equals(true));
          }))
        .get();
  }

  Future<List<Event>> getAllGalleryEvent() async {
    return await (database.select(database.events)
          ..where((tbl) {
            return tbl.type.equals(studioGalleyEvent);
          }))
        .get();
  }

  Future<List<Event>?> getEventsByTag(String transporterTag) async {
    switch (transporterTag) {
      case (TransportDataKeys.studioData):
        {
          return await (database.select(database.events)
                ..where((tbl) {
                  return ((tbl.type.equals(studioGalleyEvent)) |
                      (tbl.type.equals(demoEvent)));
                }))
              .get();
        }
      case TransportDataKeys.userData:
        {
          return await (database.select(database.events)
                ..where((tbl) {
                  return ((tbl.type.equals(userEvent)));
                }))
              .get();
        }
        // case TransportDataKeys.deviceData:
        {
          return await (database.select(database.events)
                ..where((tbl) {
                  return ((tbl.type.equals(userEvent)));
                }))
              .get();
        }
    }
    return null;
  }

  Future<Event?> getEventVisibility() async {
    return await (database.select(database.events)
          ..where((tbl) {
            return (tbl.type.equals(demoEvent) | tbl.type.equals(userEvent)) &
                (tbl.published.equals(true));
          })
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<Event>> getDemoEvent() async {
    return await (database.select(database.events)
          ..where((tbl) {
            return (tbl.type.equals(demoEvent)) & (tbl.published.equals(true));
          }))
        .get();
  }

/*  Stream<List<Demo>> getStreamDemoEvent() {
    var query = (database.select(database.events)
          ..where((tbl) {
            return (tbl.type.equals(EventTypeConstants.demoEvent)) &
                (tbl.published.equals(true)) &
                (tbl.archived.equals(false));
          }))
        .join([
      drift.innerJoin(database.jvtFileConnectors,
          database.jvtFileConnectors.ableCode.equalsExp(database.events.code)),
      drift.innerJoin(
          database.jvtFiles,
          database.jvtFiles.code
              .equalsExp(database.jvtFileConnectors.jvtFileCode)),
    ]);
    return query.watch().map((rows) {
      return rows.map((row) {
        return Demo(
          file:database.jvtFiles,
          event: row.readTableOrNull(database.events),
          fileConnector: row.readTableOrNull(database.jvtFileConnectors),
        );
      }).toList();
    });
  }*/

  Stream<List<Demo?>?>? getStreamDemoEvent2() {
    try {
      var query = (database.select(database.events)
            ..where((tbl) {
              return (tbl.type.equals(demoEvent)) &
                  (tbl.published.equals(true)) &
                  (tbl.archived.equals(false));
            }))
          .join([
        drift.innerJoin(
            database.jvtFileConnectors,
            ((database.jvtFileConnectors.ableCode
                    .equalsExp(database.events.code)) &
                (database.jvtFileConnectors.tag
                    .equals(TransportDataKeys.eventCover)))),
        drift.innerJoin(
            database.jvtFiles,
            database.jvtFiles.code
                .equalsExp(database.jvtFileConnectors.jvtFileCode)),
      ]);
      return query.watch().map((rows) {
        return rows.map((row) {
          return Demo(
            file: row.readTableOrNull(database.jvtFiles),
            event: row.readTableOrNull(database.events),
            fileConnector: row.readTableOrNull(database.jvtFileConnectors),
          );
        }).toList();
      });
/*    return query.map((resultRow) {
      return Demo(
          file: resultRow.readTableOrNull(database.jvtFiles),
          event:resultRow.readTableOrNull(database.events),
          fileConnector:resultRow.readTableOrNull(database.jvtFileConnectors),
      );
    }).toList();*/
    } catch (e) {
      showLog('the problem while executing stream event dao $e');
      return null;
    }
  }

  Future<List<Event>> getUserEvent() async {
    return await (database.select(database.events)
          ..where((tbl) {
            return (tbl.type.equals(userEvent));
          }))
        .get();
  }

  /// Insert new entity

  Future<int> insertEvents(EventsCompanion entity) async {
    return await database.into(database.events).insert(entity);
  }

  /// InsertOrUpdate new entity

  Future<int> insertOrUpdateEvents(EventsCompanion entity) async {
    return await database.into(database.events).insertOnConflictUpdate(entity);
  }

  Future<Event> getVisibleStatus(String code) async {
    return await (database.select(database.events)
          ..where((table) {
            return (table.code.equals(code));
          })
          ..limit(1))
        .getSingle();
  }

  Stream<List<Demo>>? getStreamUSerEvent() {
    try {
      var query = (database.select(database.events)
            ..where((tbl) {
              return (tbl.type.equals(userEvent)) &
                  (tbl.archived.equals(false));
            }))
          .join([
        drift.innerJoin(
            database.jvtFileConnectors,
            ((database.jvtFileConnectors.ableCode
                    .equalsExp(database.events.code)) &
                (database.jvtFileConnectors.tag
                    .equals(TransportDataKeys.eventCover)))),
        drift.innerJoin(
            database.jvtFiles,
            database.jvtFiles.code
                .equalsExp(database.jvtFileConnectors.jvtFileCode)),
      ]);
      return query.watch().map((rows) {
        return rows.map((row) {
          return Demo(
            file: row.readTableOrNull(database.jvtFiles),
            event: row.readTableOrNull(database.events),
            fileConnector: row.readTableOrNull(database.jvtFileConnectors),
          );
        }).toList();
      });
      /*return query.map((resultRow) {
      return Demo(
        file: resultRow.readTableOrNull(database.jvtFiles),
        event:resultRow.readTableOrNull(database.events),
        fileConnector:resultRow.readTableOrNull(database.jvtFileConnectors),
        temporaryUrl: resultRow.readTableOrNull(database.temporaryUrls),
      );
    }).toList();*/
    } catch (e) {
      showLog('the problem while get user event $e');
      return null;
    }
  }

/*  Stream<List<Demo>> getStreamUSerEvent() {
    var query = (database.select(database.events)
          ..where((tbl) {
            return (tbl.type.equals(EventTypeConstants.userEvent)) &
                (tbl.archived.equals(false));
          }))
        .join([
      drift.innerJoin(database.jvtFileConnectors,
          database.jvtFileConnectors.ableCode.equalsExp(database.events.code)),
    ]);
    return query.watch().map((rows) {
      return rows.map((row) {
        return Demo(
          event: row.readTableOrNull(database.events),
          fileConnector: row.readTableOrNull(database.jvtFileConnectors),
        );
      }).toList();
    });
  }*/
  Future<JvtFile?> getEventCoverByCode(String eventCode) async {
    var query = ((database.select(database.events)
          ..where((tbl) {
            return (tbl.code.equals(eventCode));
          }))
        .join([
      drift.innerJoin(
          database.jvtFileConnectors,
          ((database.jvtFileConnectors.ableCode
                  .equalsExp(database.events.code)) &
              (database.jvtFileConnectors.tag
                  .equals(TransportDataKeys.eventCover)))),
      drift.innerJoin(
          database.jvtFiles,
          database.jvtFiles.code
              .equalsExp(database.jvtFileConnectors.jvtFileCode)),
    ]))
      ..limit(1);
    return query.map((table) {
      return table.readTable(database.jvtFiles);
    }).getSingleOrNull();
  }

  Stream<List<Demo>>? getStreamArchivedEvent() {
    try {
      var query = (database.select(database.events)
            ..where((tbl) {
              return (tbl.type.equals(userEvent)) &
                  (tbl.published.equals(true)) &
                  (tbl.archived.equals(true));
            }))
          .join([
        drift.innerJoin(
            database.jvtFileConnectors,
            ((database.jvtFileConnectors.ableCode
                    .equalsExp(database.events.code)) &
                (database.jvtFileConnectors.tag
                    .equals(TransportDataKeys.eventCover)))),
        drift.innerJoin(
            database.jvtFiles,
            database.jvtFiles.code
                .equalsExp(database.jvtFileConnectors.jvtFileCode)),
      ]);
      return query.watch().map((rows) {
        return rows.map((row) {
          return Demo(
            file: row.readTableOrNull(database.jvtFiles),
            event: row.readTableOrNull(database.events),
            fileConnector: row.readTableOrNull(database.jvtFileConnectors),
          );
        }).toList();
      });
      /* return query.map((resultRow) {
      return Demo(
        file: resultRow.readTableOrNull(database.jvtFiles),
        event:resultRow.readTableOrNull(database.events),
        fileConnector:resultRow.readTableOrNull(database.jvtFileConnectors),
      );
    }).toList();*/
    } catch (e) {
      showLog('the problem while get archived event $e');
      return null;
    }
  }

  Stream<List<galleryViewModel.Media>>? getStreamSingleEvent(String code) {
    showLog('the event code eventDao :: ${code}');

    try {
      var query = (database.select(database.media)
            ..where((tbl) {
              return (tbl.eventCode.equals(code));
            }))
          .join([
        drift.innerJoin(
            database.events,
            (database.events.code.equalsExp(database.media.eventCode)) &
                (database.events.published.equals(
                    true)) /*&
            (database.events.type
                .equals(EventTypeConstants.studioGalleyEvent).not())*/
            ),
        // join file connector for album
        drift.leftOuterJoin(database.albums,
            (database.albums.code.equalsExp(database.media.ableCode))),
        drift.leftOuterJoin(
            database.jvtFileConnectors,
            ((database.jvtFileConnectors.ableCode
                    .equalsExp(database.media.ableCode)) &
                (database.jvtFileConnectors.tag
                    .equals(TransportDataKeys.albumCover)))),
        // join file  for album
        drift.leftOuterJoin(
            database.jvtFiles,
            (database.jvtFiles.code
                .equalsExp(database.jvtFileConnectors.jvtFileCode))),
        // join temp url for album

        drift.leftOuterJoin(database.videos,
            database.videos.code.equalsExp(database.media.ableCode)),
      ])
        ..orderBy([drift.OrderingTerm.desc(database.media.priorityScore)]);
      return query.watch().map((rows) {
        return rows.map((row) {
          return galleryViewModel.Media(
            albums: row.readTableOrNull(database.albums),
            file: row.readTableOrNull(database.jvtFiles),
            fileConnector: row.readTableOrNull(database.jvtFileConnectors),
            event: row.readTableOrNull(database.events),
            media: row.readTableOrNull(database.media),
            videos: row.readTableOrNull(database.videos),
          );
        }).toList();
      });
      /*   showLog('The length of the single event where ${query.map((e) => e.readTableOrNull(database.events))}');
      return  query.map((resultRows) {
        return galleryViewModel.Media(
          file: resultRows.readTableOrNull(database.jvtFiles),
          fileConnector:resultRows.readTableOrNull(database.jvtFileConnectors) ,
          temporaryUrl:resultRows.readTableOrNull(database.temporaryUrls) ,
          event: resultRows.readTableOrNull(database.events) ,
          media: resultRows.readTableOrNull(database.media),
          videos: resultRows.readTableOrNull(database.videos),
        );
      }).toList();*/
    } catch (e) {
      showLog('the problem while event dao :: $e');
      return null;
    }

    /* query.orderBy([drift.OrderingTerm.desc(database.media.priorityScore)]);
    return query.watch().map((rows) {
      return rows.map((row) {
        return galleryViewModel.Media(
          media: row.readTableOrNull(database.media),
        );
      }).toList();
    });*/
  }

  Stream<List<galleryViewModel.Media>?>? getStreamGalleryEventWithMedia() {
    try {
      var query = (database.select(database.media)
            ..where((tbl) {
              return tbl.published.equals(true);
            }))
          .join([
        drift.innerJoin(
            database.events,
            (database.events.code.equalsExp(database.media.eventCode)) &
                (database.events.published.equals(true)) &
                (database.events.type.equals(studioGalleyEvent))),
        // join file connector for album
        drift.leftOuterJoin(
          database.albums,
          (database.albums.code.equalsExp(database.media.ableCode)),
        ),
        drift.leftOuterJoin(database.videos,
            database.videos.code.equalsExp(database.media.ableCode)),
      ])
        ..orderBy([drift.OrderingTerm.desc(database.media.priorityScore)]);

      return query.watch().map((rows) {
        return rows.map((row) {
          return galleryViewModel.Media(
            event: row.readTableOrNull(database.events),
            media: row.readTableOrNull(database.media),
            videos: row.readTableOrNull(database.videos),
            albums: row.readTableOrNull(database.albums),
          );
        }).toList();
      });

      /* return  query.map((resultRows) {
        return galleryViewModel.Media(
          file: resultRows.readTableOrNull(database.jvtFiles),
          fileConnector:resultRows.readTableOrNull(database.jvtFileConnectors) ,
          temporaryUrl:resultRows.readTableOrNull(database.temporaryUrls) ,
          event: resultRows.readTableOrNull(database.events) ,
          media: resultRows.readTableOrNull(database.media),
          videos: resultRows.readTableOrNull(database.videos),
        );
      }).toList();*/
    } catch (e) {
      showLog('the problem while event dao :: $e');
      return null;
    }

    /* query.orderBy([drift.OrderingTerm.desc(database.media.priorityScore)]);
    return query.watch().map((rows) {
      return rows.map((row) {
        return galleryViewModel.Media(
          media: row.readTableOrNull(database.media),
        );
      }).toList();
    });*/
  }

  Future<galleryViewModel.Media?>? getStreamSingleMedia(String code) async {
    try {
      var query = (database.select(database.media)
            ..where((tbl) {
              return (tbl.published.equals(true)) & (tbl.code.equals(code));
            }))
          .join([
        drift.innerJoin(
            database.events,
            (database.events.code.equalsExp(database.media.eventCode)) &
                (database.events.published.equals(true))),
        // join file connector for album
        drift.leftOuterJoin(database.albums,
            (database.albums.code.equalsExp(database.media.ableCode))),
        drift.leftOuterJoin(
            database.jvtFileConnectors,
            ((database.jvtFileConnectors.ableCode
                    .equalsExp(database.media.ableCode)) &
                (database.jvtFileConnectors.tag
                    .equals(TransportDataKeys.albumCover)))),
        // join file  for album
        drift.leftOuterJoin(
            database.jvtFiles,
            (database.jvtFiles.code
                .equalsExp(database.jvtFileConnectors.jvtFileCode))),
        // join temp url for album
        drift.leftOuterJoin(database.videos,
            database.videos.code.equalsExp(database.media.ableCode)),
      ]);
      return query.map((row) {
        return galleryViewModel.Media(
          albums: row.readTableOrNull(database.albums),
          file: row.readTableOrNull(database.jvtFiles),
          fileConnector: row.readTableOrNull(database.jvtFileConnectors),
          event: row.readTableOrNull(database.events),
          media: row.readTableOrNull(database.media),
          videos: row.readTableOrNull(database.videos),
        );
      }).getSingleOrNull();
    } catch (e) {
      showLog('the problem while event dao :: $e');
      return null;
    }
  }

/*
  Stream<List<galleryViewModel.Gallery>> getStreamGalleryAlbumByAlbumCode(
      String code) {
    var query = (database.select(database.jvtFiles)).join([
      drift.innerJoin(
          database.jvtFileConnectors,
          (database.jvtFileConnectors.ableCode.equals(code)) &
          (database.jvtFileConnectors.tag
              .equals(TransportDataKeys.albumCover)) &
          (database.jvtFileConnectors.jvtFileCode
              .equalsExp(database.jvtFiles.code))),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return galleryViewModel.Gallery(
          file: row.readTableOrNull(database.jvtFiles),
        );
      }).toList();
    });
  }*/
  Future<List<galleryViewModel.Gallery>> getStreamGalleryAlbumByAlbumCode(
      String code) async {
    var query = await (database.select(database.jvtFileConnectors)
          ..where((tbl) {
            return (tbl.ableCode.equals(code)) &
                (tbl.tag.equals(TransportDataKeys.albumCover));
          }))
        .join([
      drift.innerJoin(
          database.jvtFiles,
          database.jvtFiles.code
              .equalsExp(database.jvtFileConnectors.jvtFileCode)),
    ]).get();
    // query.join(drift.innerJoin(database.jvtFiles, database.jvtFiles.downloaded.equals(1)));
    return query.map((resultRow) {
      return galleryViewModel.Gallery(
        file: resultRow.readTableOrNull(database.jvtFiles),
        fileConnector: resultRow.readTableOrNull(database.jvtFileConnectors),
      );
    }).toList();
/*    */ /*return*/ /* query.watch().map((rows) {
      return rows.map((row) {
        return galleryViewModel.Gallery(
          fileConnector: row.readTable(database.jvtFileConnectors),
        );
      }).toList();
    });*/
  }

  Future<List<Video>> getStreamGalleryVideoByVideoCode(String code) async {
    return await (database.select(database.videos)
          ..where((tbl) {
            return (tbl.code.equals(code));
          }))
        .get();
  }

  Future<Event?> getSingleEventByCode(String code) async {
    try {
      return await (database.select(database.events)
            ..where((tbl) {
              return (tbl.code.equals(code));
            })
            ..limit(1))
          .getSingleOrNull();
    } catch (e) {
      showLog("problem while getting single data in event dao $e");
    }
    return null;
  }

  Stream<Event?> streamSingleEventByCode(String code) {
    return (database.select(database.events)
          ..where((tbl) {
            return (tbl.code.equals(code));
          })
          ..limit(1))
        .watchSingleOrNull();
  }

  Stream<List<Event>> streamGalleryEvent() {
    return ((database.select(database.events)
          ..where((tbl) {
            return (tbl.type.equals(studioGalleyEvent)) &
                (tbl.published.equals(true));
          }))
          ..orderBy([(t) => drift.OrderingTerm.desc(t.priorityScore)]))
        .watch();
  }

  Stream<List<galleryViewModel.Gallery>> streamEventByCode(String code) {
    var query = (database.select(database.events)
          ..where((tbl) {
            return (tbl.code.equals(code)) & (tbl.published.equals(true));
          }))
        .join([
      drift.innerJoin(database.media,
          database.media.eventCode.equalsExp(database.events.code)),
    ]);

    query.orderBy([drift.OrderingTerm.desc(database.media.priorityScore)]);
    return query.watch().map((rows) {
      return rows.map((row) {
        return galleryViewModel.Gallery(
          media: row.readTableOrNull(database.media),
        );
      }).toList();
    });
  }

  Future<void> toggleEventSeenStatus(String code, bool status) async {
    await (database.update(database.events)
          ..where((tbl) => tbl.code.equals(code)))
        .write(EventsCompanion(newlyAdded: drift.Value(status)));
  }
}
