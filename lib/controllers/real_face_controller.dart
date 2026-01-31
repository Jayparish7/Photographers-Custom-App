import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/event_ai_data.dart'
    as ai;
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;

import '../core/models/apiModels/myPhotos_images_response_model.dart';
import '../driftdb/app_db.dart';
import '../driftdb/dao/real_person_dao.dart';
import '../driftdb/dao/real_person_photo_selection_dao.dart';

class RealPersonsController {
  Future<void> upsertPhotoSelectionPersons({
    required List<transporter.RealPerson> realPersons,
    required String eventCode,
  }) async {
    RealPersonPhotoSelectionDao faceModelDao = RealPersonPhotoSelectionDao();

    showLog('Persons upsert begin ...');

    List<String> apiPersons = [];
    for (transporter.RealPerson person in realPersons) {
      apiPersons.add(person.code!);
    }
    List<String> notify = [];
    List<String> existingFolders = [];
    if (apiPersons.isNotEmpty) {
      List create = []; // insert this event
      List delete = []; // delete this event
      List update = []; // change update required as true
      /// get local event

      List<appDb.RealPersonsPhotoSelection>? folders =
          await faceModelDao.getFacesByEvent(
        eventCode: eventCode,
      );

      if (folders.isNotEmpty) {
        folders.forEach((_folder) {
          existingFolders.add(_folder.code);
        });
      }
      for (int i = 0; i < apiPersons.length; i++) {
        if (existingFolders.contains(apiPersons[i])) {
          update.add(apiPersons[i]);
        }
        if (!existingFolders.contains(apiPersons[i])) {
          notify.add(apiPersons[i]);
          create.add(apiPersons[i]);
        }
      }
      for (int i = 0; i < existingFolders.length; i++) {
        if (!apiPersons.contains(existingFolders[i])) {
          delete.add(existingFolders[i]);
        }
      }

      /// INSERT New Folder
      if (create.isNotEmpty) {
        List<appDb.RealPersonsPhotoSelectionsCompanion> personCompanions = [];
        for (int i = 0; i < create.length; i++) {
          List<transporter.RealPerson> _newPersons =
              realPersons.where((obj) => obj.code == create[i]).toList();
          personCompanions.add(appDb.RealPersonsPhotoSelectionsCompanion(
            code: drift.Value(_newPersons.first.code!),
            image: drift.Value(_newPersons.first.image!),
            persons: drift.Value(_newPersons.first.realPersons!.join(',')),
            eventCode: drift.Value(eventCode),
            score: drift.Value(_newPersons.first.score!),
          ));
        }
        await faceModelDao.insertAllFace(personCompanions);
      }

      /// UPDATE Existing Folder
      if (update.isNotEmpty) {
        List<appDb.RealPersonsPhotoSelectionsCompanion> personCompanions = [];
        for (int i = 0; i < update.length; i++) {
          List<transporter.RealPerson> _updatePersons =
              realPersons.where((obj) => obj.code == update[i]).toList();

          // update all
          personCompanions.add(appDb.RealPersonsPhotoSelectionsCompanion(
            code: drift.Value(_updatePersons.first.code!),
            image: drift.Value(_updatePersons.first.image!),
            persons: drift.Value(_updatePersons.first.realPersons!.join(',')),
            eventCode: drift.Value(eventCode),
            score: drift.Value(_updatePersons.first.score!),
          ));
        }
        await faceModelDao.insertAllFace(personCompanions);
      }

      /// DELETE Folder NEED TO BE DELETED
      if (delete.isNotEmpty) {
        for (int i = 0; i < delete.length; i++) {
          await faceModelDao.deletePersons(code: delete[i]);
        }
      }
    }
  }

  Future<void> upsertAlbumRealPersons(
      {List<ai.EventAiDatumData>? eventAiDetailData}) async {
    RealPersonsDao realFaceModelDao = RealPersonsDao();
    List create = []; // insert this event
    List delete = []; // delete this event
    List update = []; // change update required as true
    List<String> apiPersons = [];
    List<String> notify = [];
    List<String> existingFolders = [];
    List<appDb.RealPersonsAlbumsCompanion> RealpersonCompanionsInsertOrUpdate =
        [];
    showLog('upsertAlbumRealPersons 12312321321 $eventAiDetailData');

    if (eventAiDetailData != null && eventAiDetailData.isNotEmpty) {
      showLog('upsertAlbumRealPersons1');

      showLog('upsertAlbumRealPersons1');
      for (ai.EventAiDatumData aIData in eventAiDetailData) {
        List<ai.Person>? realPersons = aIData.data!.realPersons;
        showLog('upsertAlbumRealPersons15 ${realPersons}');

        String eventCode = aIData.code!;
        if (realPersons != null) {
          for (ai.Person realPerson in realPersons) {
            apiPersons.add(realPerson.code!);
            showLog('api real person ${apiPersons.length}');
          }
          if (apiPersons.isNotEmpty) {
            /// get local event

            List<RealPersonsAlbum> folders =
                await realFaceModelDao.getRealFacesByEvent(
              eventCode: eventCode,
            );

            if (folders.isNotEmpty) {
              folders.forEach((_folder) {
                existingFolders.add(_folder.code);
              });
            }
            for (int i = 0; i < apiPersons.length; i++) {
              if (existingFolders.contains(apiPersons[i])) {
                update.add(apiPersons[i]);
              }
              if (!existingFolders.contains(apiPersons[i])) {
                notify.add(apiPersons[i]);
                create.add(apiPersons[i]);
              }
            }
            for (int i = 0; i < existingFolders.length; i++) {
              if (!apiPersons.contains(existingFolders[i])) {
                delete.add(existingFolders[i]);
              }
            }

            /// INSERT New Folder
            if (create.isNotEmpty) {
              for (int i = 0; i < create.length; i++) {
                List<ai.Person?>? _newPersons =
                    realPersons.where((obj) => obj.code == create[i]).toList();
                if (_newPersons.isNotEmpty && _newPersons.first != null) {
                  RealpersonCompanionsInsertOrUpdate.add(
                      appDb.RealPersonsAlbumsCompanion(
                    code: drift.Value(_newPersons.first!.code!),
                    image: drift.Value(_newPersons.first!.imageName!),
                    persons: drift.Value(_newPersons.first!.persons!.join(',')),
                    eventCode: drift.Value(eventCode),
                    score: drift.Value(_newPersons.first!.score!),
                  ));
                  showLog(
                      'upsertAlbumRealPersons5 :  ${RealpersonCompanionsInsertOrUpdate[0]}');
                }
              }
            }

            /// UPDATE Existing Folder
            if (update.isNotEmpty) {
              for (int i = 0; i < update.length; i++) {
                List<ai.Person?>? _updatePersons =
                    realPersons.where((obj) => obj.code == update[i]).toList();

                // update all
                if (_updatePersons.isNotEmpty && _updatePersons.first != null) {
                  RealpersonCompanionsInsertOrUpdate.add(
                      appDb.RealPersonsAlbumsCompanion(
                    code: drift.Value(_updatePersons.first!.code!),
                    image: drift.Value(_updatePersons.first!.imageName!),
                    persons:
                        drift.Value(_updatePersons.first!.persons!.join(',')),
                    eventCode: drift.Value(eventCode),
                    score: drift.Value(_updatePersons.first!.score!),
                  ));
                }
              }
            }

            /// DELETE Folder NEED TO BE DELETED
            if (delete.isNotEmpty) {
              for (int i = 0; i < delete.length; i++) {
                await realFaceModelDao.deleteRealPersonsWhereCode(code: delete[i]);
              }
            }
          }
        }
      }
      if (RealpersonCompanionsInsertOrUpdate.isNotEmpty) {
        await realFaceModelDao
            .insertRealAllFaces(RealpersonCompanionsInsertOrUpdate);
      }
      showLog('upsertAlbumRealPersons2 :  ${create.length}');
      showLog('upsertAlbumRealPersons3 :  ${update.length}');
      showLog('upsertAlbumRealPersons4 :  ${delete.length}');
      showLog(
          'upsertAlbumRealPersons5 :  ${RealpersonCompanionsInsertOrUpdate.length}');
    }
  }

  // Future<void> upsertMyPhotosAlbumRealPersons(
  //     {MyPhotosImages? myPhotosData, String? eventCode}) async {
  //   RealPersonsDao realFaceModelDao = RealPersonsDao();
  //   List create = []; // insert this event
  //   List delete = []; // delete this event
  //   List update = []; // change update required as true
  //   List<String> apiPersons = [];
  //   List<String> notify = [];
  //   List<String> existingFolders = [];
  //   List<appDb.RealPersonsAlbumsCompanion> RealPersonCompanionsInsertOrUpdate =
  //       [];
  //
  //   for (int i = 0; i < myPhotosData!.realPersons!.length; i++) {
  //     if (myPhotosData != null &&
  //         eventCode != null &&
  //         myPhotosData.realPersons![i] != null &&
  //         myPhotosData.realPersons![i].persons!.isNotEmpty) {
  //       showLog(
  //           'my photos data real face ${myPhotosData.realPersons![i].persons}');
  //
  //       showLog('upsertAlbumRealPersons1');
  //       List<Person>? realPersons = [myPhotosData.realPersons![i]];
  //       showLog('upsertAlbumRealPersons15 ${realPersons}');
  //
  //       if (realPersons != null) {
  //         for (Person realPerson in realPersons) {
  //           apiPersons.add(realPerson.code!);
  //           showLog('api real person ${apiPersons.length}');
  //         }
  //         if (apiPersons.isNotEmpty) {
  //           /// get local event
  //
  //           List<RealPersonsAlbum> folders =
  //               await realFaceModelDao.getRealFacesByEvent(
  //             eventCode: eventCode,
  //           );
  //
  //           if (folders != null && folders.isNotEmpty) {
  //             folders.forEach((_folder) {
  //               existingFolders.add(_folder.code);
  //             });
  //           }
  //           for (int i = 0; i < apiPersons.length; i++) {
  //             if (existingFolders.contains(apiPersons[i])) {
  //               update.add(apiPersons[i]);
  //             }
  //             if (!existingFolders.contains(apiPersons[i])) {
  //               notify.add(apiPersons[i]);
  //               create.add(apiPersons[i]);
  //             }
  //           }
  //           for (int i = 0; i < existingFolders.length; i++) {
  //             if (!apiPersons.contains(existingFolders[i])) {
  //               delete.add(existingFolders[i]);
  //             }
  //           }
  //
  //           /// INSERT New Folder
  //           if (create != null && create.isNotEmpty) {
  //             for (int i = 0; i < create.length; i++) {
  //               List<Person?>? _newPersons =
  //                   realPersons.where((obj) => obj.code == create[i]).toList();
  //               if (_newPersons != null &&
  //                   _newPersons.isNotEmpty &&
  //                   _newPersons.first != null) {
  //                 RealPersonCompanionsInsertOrUpdate.add(
  //                     appDb.RealPersonsAlbumsCompanion(
  //                   code: drift.Value(_newPersons.first!.code!),
  //                   image: drift.Value(_newPersons.first!.imageName!),
  //                   persons: drift.Value(_newPersons.first!.persons!.join(',')),
  //                   eventCode: drift.Value(eventCode),
  //                   score: drift.Value(_newPersons.first!.score!),
  //                 ));
  //                 showLog(
  //                     'upsertAlbumRealPersons5 :  ${RealPersonCompanionsInsertOrUpdate[0]}');
  //               }
  //             }
  //           }
  //
  //           /// UPDATE Existing Folder
  //           if (update != null && update.isNotEmpty) {
  //             for (int i = 0; i < update.length; i++) {
  //               List<Person?>? _updatePersons =
  //                   realPersons.where((obj) => obj.code == update[i]).toList();
  //
  //               // update all
  //               if (_updatePersons != null &&
  //                   _updatePersons.isNotEmpty &&
  //                   _updatePersons.first != null) {
  //                 RealPersonCompanionsInsertOrUpdate.add(
  //                     appDb.RealPersonsAlbumsCompanion(
  //                   code: drift.Value(_updatePersons.first!.code!),
  //                   image: drift.Value(_updatePersons.first!.imageName!),
  //                   persons:
  //                       drift.Value(_updatePersons.first!.persons!.join(',')),
  //                   eventCode: drift.Value(eventCode),
  //                   score: drift.Value(_updatePersons.first!.score!),
  //                 ));
  //               }
  //             }
  //           }
  //
  //           /// DELETE Folder NEED TO BE DELETED
  //           if (delete != null && delete.isNotEmpty) {
  //             for (int i = 0; i < delete.length; i++) {
  //               await realFaceModelDao.deleteRealPersonsWhereCode(code: delete[i]);
  //             }
  //           }
  //         }
  //       }
  //     }
  //   }
  //   if (RealPersonCompanionsInsertOrUpdate.isNotEmpty) {
  //     await realFaceModelDao
  //         .insertRealAllFaces(RealPersonCompanionsInsertOrUpdate);
  //   }
  //   showLog('upsertAlbumRealPersons2 :  ${create.length}');
  //   showLog('upsertAlbumRealPersons3 :  ${update.length}');
  //   showLog('upsertAlbumRealPersons4 :  ${delete.length}');
  //   showLog(
  //       'upsertAlbumRealPersons5 :  ${RealPersonCompanionsInsertOrUpdate.length}');
  // }
  Future<void> upsertMyPhotosAlbumRealPersons({
    required MyPhotosImages? myPhotosData,
    required String? eventCode,
  }) async {
    if (eventCode == null) return;

    final realFaceModelDao = RealPersonsDao();

    List<String> apiPersons = [];
    List<String> existingFolders = [];
    List<String> toCreate = [];
    List<String> toUpdate = [];
    List<String> toDelete = [];
    List<appDb.RealPersonsAlbumsCompanion> insertOrUpdateList = [];

    // ✅ Build apiPersons list
    if (myPhotosData?.realPersons != null && myPhotosData!.realPersons!.isNotEmpty) {
      for (var person in myPhotosData.realPersons!) {
        apiPersons.add(person.code!.trim());
      }
    }

    // ✅ Get local persons for the event
    final folders = await realFaceModelDao.getRealFacesByEvent(eventCode: eventCode);
    if (folders.isNotEmpty) {
      existingFolders = folders.map((e) => e.code.trim()).toList();
    }

    // ✅ Compare for create & update
    for (var personCode in apiPersons) {
      if (existingFolders.contains(personCode)) {
        toUpdate.add(personCode);
      } else {
        toCreate.add(personCode);
      }
    }

    // ✅ Compare for delete
    for (var folderCode in existingFolders) {
      if (!apiPersons.contains(folderCode)) {
        toDelete.add(folderCode);
      }
    }

    // ✅ Process Create
    if (toCreate.isNotEmpty) {
      for (var code in toCreate) {
        final person = myPhotosData!.realPersons!.firstWhere((e) => e.code == code);
        insertOrUpdateList.add(appDb.RealPersonsAlbumsCompanion(
          code: drift.Value(person.code!),
          image: drift.Value(person.imageName ?? ''),
          persons: drift.Value((person.persons ?? []).join(',')),
          eventCode: drift.Value(eventCode),
          score: drift.Value(person.score ?? 0),
        ));
      }
    }

    // ✅ Process Update
    if (toUpdate.isNotEmpty) {
      for (var code in toUpdate) {
        final person = myPhotosData!.realPersons!.firstWhere((e) => e.code == code);
        insertOrUpdateList.add(appDb.RealPersonsAlbumsCompanion(
          code: drift.Value(person.code!),
          image: drift.Value(person.imageName ?? ''),
          persons: drift.Value((person.persons ?? []).join(',')),
          eventCode: drift.Value(eventCode),
          score: drift.Value(person.score ?? 0),
        ));
      }
    }

    // ✅ Insert or Update in DB
    if (insertOrUpdateList.isNotEmpty) {
      await realFaceModelDao.insertRealAllFaces(insertOrUpdateList);
    }

    // ✅ Process Delete
    if (toDelete.isNotEmpty) {
      await Future.wait(toDelete.map((code) async {
        await realFaceModelDao.deleteRealPersonsWhereCode(code: code);
      }));
    }

    // ✅ Debug logs
    showLog('👉 Create: $toCreate');
    showLog('👉 Update: $toUpdate');
    showLog('👉 Delete: $toDelete');
    showLog('👉 InsertOrUpdate Count: ${insertOrUpdateList.length}');
  }

}
