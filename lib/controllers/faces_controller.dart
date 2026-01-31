import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/event_ai_data.dart'
    as ai;
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/person_album_dao.dart';
import 'package:photomall_flutter/driftdb/dao/person_photo_selection_dao.dart';

import '../core/models/apiModels/myPhotos_images_response_model.dart';

class PersonsController {
  Future<void> upsertPhotoSelectionPersons({
    required List<transporter.Person> persons,
    required String eventCode,
  }) async {
    PersonPhotoSelectionDao faceModelDao = PersonPhotoSelectionDao();

    showLog('Persons upsert begin ...');

    List<String> apiPersons = [];
    for (transporter.Person person in persons) {
      apiPersons.add(person.code!);
    }
    List<String> notify = [];
    List<String> existingFolders = [];
    if (apiPersons.isNotEmpty) {
      List create = []; // insert this event
      List delete = []; // delete this event
      List update = []; // change update required as true
      /// get local event

      List<appDb.PersonsPhotoSelection>? folders =
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
        List<appDb.PersonsPhotoSelectionsCompanion> personCompanions = [];
        for (int i = 0; i < create.length; i++) {
          List<transporter.Person> _newPersons =
              persons.where((obj) => obj.code == create[i]).toList();
          personCompanions.add(appDb.PersonsPhotoSelectionsCompanion(
            code: drift.Value(_newPersons.first.code!),
            image: drift.Value(_newPersons.first.image!),
            images: drift.Value(_newPersons.first.images!.join(',')),
            eventCode: drift.Value(eventCode),
            score: drift.Value(_newPersons.first.score!),
          ));
        }
        await faceModelDao.insertAllFace(personCompanions);
      }

      /// UPDATE Existing Folder
      if (update.isNotEmpty) {
        List<appDb.PersonsPhotoSelectionsCompanion> personCompanions = [];
        for (int i = 0; i < update.length; i++) {
          List<transporter.Person> _updatePersons =
              persons.where((obj) => obj.code == update[i]).toList();

          // update all
          personCompanions.add(appDb.PersonsPhotoSelectionsCompanion(
            code: drift.Value(_updatePersons.first.code!),
            image: drift.Value(_updatePersons.first.image!),
            images: drift.Value(_updatePersons.first.images!.join(',')),
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

  Future<void> upsertAlbumPersons(
      {List<ai.EventAiDatumData>? eventAiDetailData}) async {
    PersonAlbumDao faceModelDao = PersonAlbumDao();
    List create = []; // insert this event
    List delete = []; // delete this event
    List update = []; // change update required as true
    List<String> apiPersons = [];
    List<String> notify = [];
    List<String> existingFolders = [];
    List<appDb.PersonsAlbumsCompanion> personCompanionsInsertOrUpdate = [];

    if (eventAiDetailData != null && eventAiDetailData.isNotEmpty) {
      for (ai.EventAiDatumData eventData in eventAiDetailData) {
        List<ai.Person>? persons = eventData.data!.persons;
        String eventCode = eventData.code!;
        if (persons != null) {
          for (ai.Person person in persons) {
            apiPersons.add(person.code!);
          }
          if (apiPersons.isNotEmpty) {
            /// get local event
            showLog('apiPersons $apiPersons');

            List<appDb.PersonsAlbum>? folders =
                await faceModelDao.getFacesByEvent(
              eventCode: eventCode,
            );
            showLog('folders $folders');

            if (folders.isNotEmpty) {
              folders.forEach((_folder) {
                existingFolders.add(_folder.code);
                showLog('folders ${_folder.code}');
              });
            }
            for (int i = 0; i < apiPersons.length; i++) {
              showLog('existingFolders ${apiPersons[i]}');

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
                    persons.where((obj) => obj.code == create[i]).toList();
                if (_newPersons.isNotEmpty && _newPersons.first != null) {
                  showLog('_newPersons_newPersons_newPersons$_newPersons');
                  personCompanionsInsertOrUpdate
                      .add(appDb.PersonsAlbumsCompanion(
                    code: drift.Value(_newPersons.first!.code!),
                    image: drift.Value(_newPersons.first!.imageName!),
                    images: drift.Value(_newPersons.first!.images!.join(',')),
                    eventCode: drift.Value(eventCode),
                    score: drift.Value(_newPersons.first!.score!),
                  ));
                }
              }
            }

            /// UPDATE Existing Folder
            if (update.isNotEmpty) {
              for (int i = 0; i < update.length; i++) {
                List<ai.Person?>? _updatePersons =
                    persons.where((obj) => obj.code == update[i]).toList();

                // update all
                if (_updatePersons.isNotEmpty && _updatePersons.first != null) {
                  showLog('_updatePersons_updatePersons$_updatePersons');
                  personCompanionsInsertOrUpdate
                      .add(appDb.PersonsAlbumsCompanion(
                    code: drift.Value(_updatePersons.first!.code!),
                    image: drift.Value(_updatePersons.first!.imageName!),
                    images:
                        drift.Value(_updatePersons.first!.images!.join(',')),
                    eventCode: drift.Value(eventCode),
                    score: drift.Value(_updatePersons.first!.score!),
                  ));
                }
              }
            }

            /// DELETE Folder NEED TO BE DELETED
            if (delete.isNotEmpty) {
              for (int i = 0; i < delete.length; i++) {
                await faceModelDao.deletePersons(code: delete[i]);
              }
            }
          }
        }
      }
      if (personCompanionsInsertOrUpdate.isNotEmpty) {
        showLog('personCompanionsInsertOrUpdate 5156');
        await faceModelDao.insertAllFace(personCompanionsInsertOrUpdate);
      }
    }
  }

    // Future<void> upsertMyPhotosAlbumPersons({
    //   MyPhotosImages? myPhotosData,
    //   String? eventCode,
    // }) async {
    //   PersonAlbumDao faceModelDao = PersonAlbumDao();
    //   List create = []; // insert this event
    //   List delete = []; // delete this event
    //   List update = []; // change update required as true
    //   List<String> apiPersons = [];
    //   List<String> notify = [];
    //   List<String> existingFolders = [];
    //   List<appDb.PersonsAlbumsCompanion> personCompanionsInsertOrUpdate = [];
    //
    //   if (myPhotosData != null &&
    //       eventCode != null &&
    //       myPhotosData.persons!.isNotEmpty &&
    //       myPhotosData.persons != []) {
    //     showLog('my photos data  face');
    //
    //     List<Person>? persons = myPhotosData.persons;
    //     if (persons != null) {
    //       for (Person person in persons) {
    //         apiPersons.add(person.code!);
    //       }
    //       if (apiPersons.isNotEmpty) {
    //         /// get local event
    //         showLog('apiPersons $apiPersons');
    //
    //         List<appDb.PersonsAlbum>? folders =
    //             await faceModelDao.getFacesByEvent(
    //           eventCode: eventCode,
    //         );
    //         showLog('folders $folders');
    //
    //         if (folders.isNotEmpty) {
    //           folders.forEach((_folder) {
    //             existingFolders.add(_folder.code);
    //             showLog('folders ${_folder.code}');
    //           });
    //         }
    //         for (int i = 0; i < apiPersons.length; i++) {
    //           showLog('existingFolders ${apiPersons[i]}');
    //
    //           if (existingFolders.contains(apiPersons[i])) {
    //             update.add(apiPersons[i]);
    //           }
    //           if (!existingFolders.contains(apiPersons[i])) {
    //             notify.add(apiPersons[i]);
    //             create.add(apiPersons[i]);
    //           }
    //         }
    //         for (int i = 0; i < existingFolders.length; i++) {
    //           if (!apiPersons.contains(existingFolders[i])) {
    //             delete.add(existingFolders[i]);
    //           }
    //         }
    //
    //         /// INSERT New Folder
    //         if (create.isNotEmpty) {
    //           for (int i = 0; i < create.length; i++) {
    //             List<Person?>? _newPersons =
    //                 persons.where((obj) => obj.code == create[i]).toList();
    //             if (_newPersons.isNotEmpty && _newPersons.first != null) {
    //               showLog('_newPersons_newPersons_newPersons$_newPersons');
    //               personCompanionsInsertOrUpdate.add(appDb.PersonsAlbumsCompanion(
    //                 code: drift.Value(_newPersons.first!.code!),
    //                 image: drift.Value(_newPersons.first!.imageName!),
    //                 images: drift.Value(_newPersons.first!.images!.join(',')),
    //                 eventCode: drift.Value(eventCode),
    //                 score: drift.Value(_newPersons.first!.score!),
    //               ));
    //             }
    //           }
    //         }
    //
    //         /// UPDATE Existing Folder
    //         if (update.isNotEmpty) {
    //           for (int i = 0; i < update.length; i++) {
    //             List<Person?>? _updatePersons =
    //                 persons.where((obj) => obj.code == update[i]).toList();
    //
    //             // update all
    //             if (_updatePersons.isNotEmpty &&
    //                 _updatePersons.first != null &&
    //                 _updatePersons.first!.images!.isNotEmpty) {
    //               showLog(
    //                   'update in my photos albums${_updatePersons.first!.images}');
    //               personCompanionsInsertOrUpdate.add(appDb.PersonsAlbumsCompanion(
    //                 code: drift.Value(_updatePersons.first!.code!),
    //                 image: drift.Value(_updatePersons.first!.imageName!),
    //                 images: drift.Value(_updatePersons.first!.images!.join(',')),
    //                 eventCode: drift.Value(eventCode),
    //                 score: drift.Value(_updatePersons.first!.score!),
    //               ));
    //             }
    //           }
    //         }
    //
    //         /// DELETE Folder NEED TO BE DELETED
    //         if (delete.isNotEmpty) {
    //           for (int i = 0; i < delete.length; i++) {
    //             await faceModelDao.deletePersons(code: delete[i]);
    //           }
    //         }
    //       }
    //     }
    //   }
    //   if (personCompanionsInsertOrUpdate.isNotEmpty) {
    //     showLog('personCompanionsInsertOrUpdate 5156');
    //     await faceModelDao.insertAllFace(personCompanionsInsertOrUpdate);
    //   }
    // }
  Future<void> upsertMyPhotosAlbumPersons({
    MyPhotosImages? myPhotosData,
    String? eventCode,
  }) async {
    if (eventCode == null) return;

    PersonAlbumDao faceModelDao = PersonAlbumDao();
    List<String> apiPersons = [];
    List<String> existingFolders = [];
    List<String> toCreate = [];
    List<String> toUpdate = [];
    List<String> toDelete = [];
    List<appDb.PersonsAlbumsCompanion> insertOrUpdateList = [];

    // Collect API persons
    if (myPhotosData?.persons != null) {
      apiPersons = myPhotosData!.persons!.map((e) => e.code!.trim()).toList();
    }

    // Fetch local DB persons
    List<appDb.PersonsAlbum> folders = await faceModelDao.getFacesByEvent(eventCode: eventCode);
    existingFolders = folders.map((e) => e.code.trim()).toList();

    // Compare for create & update
    for (var person in apiPersons) {
      if (existingFolders.contains(person)) {
        toUpdate.add(person);
      } else {
        toCreate.add(person);
      }
    }

    // Compare for delete
    for (var folder in existingFolders) {
      if (!apiPersons.contains(folder)) {
        toDelete.add(folder);
      }
    }

    // Handle create
    if (toCreate.isNotEmpty && myPhotosData?.persons != null) {
      for (var code in toCreate) {
        var person = myPhotosData!.persons!.firstWhere((e) => e.code == code);
        insertOrUpdateList.add(appDb.PersonsAlbumsCompanion(
          code: drift.Value(person.code!),
          image: drift.Value(person.imageName ?? ''),
          images: drift.Value((person.images ?? []).join(',')),
          eventCode: drift.Value(eventCode),
          score: drift.Value(person.score ?? 0),
        ));
      }
    }

    // Handle update
    if (toUpdate.isNotEmpty && myPhotosData?.persons != null) {
      for (var code in toUpdate) {
        var person = myPhotosData!.persons!.firstWhere((e) => e.code == code);
        insertOrUpdateList.add(appDb.PersonsAlbumsCompanion(
          code: drift.Value(person.code!),
          image: drift.Value(person.imageName ?? ''),
          images: drift.Value((person.images ?? []).join(',')),
          eventCode: drift.Value(eventCode),
          score: drift.Value(person.score ?? 0),
        ));
      }
    }

    // Perform DB insert/update
    if (insertOrUpdateList.isNotEmpty) {
      await faceModelDao.insertAllFace(insertOrUpdateList);
    }

    // Perform delete
    if (toDelete.isNotEmpty) {
      for (var code in toDelete) {
        await faceModelDao.deletePersons(code: code);
      }
    }

    showLog("Create: $toCreate, Update: $toUpdate, Delete: $toDelete");
  }

  }
