import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/event_ai_data.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/without_face_album_dao.dart';
import 'package:photomall_flutter/driftdb/dao/without_face_photo_selection_dao.dart';

class WithoutFaceController {
  Future<void> upsertWithoutFaceAlbum(
      {List<EventAiDatumData>? eventAiDetailData}) async {
    List<appDb.WithOutPersonsAlbumsCompanion>
        withoutPersonCompanionsInsertOrUpdate = [];
    if (eventAiDetailData != null && eventAiDetailData.isNotEmpty) {
      for (EventAiDatumData eventData in eventAiDetailData) {
        if (eventData.data!.imageWithoutPerson != null &&
            eventData.data!.imageWithoutPerson!.isNotEmpty) {
          withoutPersonCompanionsInsertOrUpdate
              .add(appDb.WithOutPersonsAlbumsCompanion(
            eventCode: drift.Value(eventData.code!),
            images: drift.Value(eventData.data!.imageWithoutPerson!.join(',')),
          ));
        }
      }
      showLog(
          'imageWithoutPerson aiData $withoutPersonCompanionsInsertOrUpdate');
      if (withoutPersonCompanionsInsertOrUpdate.isNotEmpty) {
        WithoutPersonAlbumDao withoutFaceModelDao = WithoutPersonAlbumDao();
        await withoutFaceModelDao
            .insertAllWithoutFace(withoutPersonCompanionsInsertOrUpdate);
      }
    }
  }

  Future<void> upsertWithoutFacePhotoSelection(
      {required String eventCode, required List<String> images}) async {
    WithoutPersonPhotoSelectionDao withoutPersonPhotoSelectionDao =
        WithoutPersonPhotoSelectionDao();
    /* appDb.WithOutPersonsPhotoSelectionData? withOutPersonsPhotoSelectionData =
    await withoutPersonPhotoSelectionDao.getWithoutFacesByCode(eventCode: eventCode);*/
    await withoutPersonPhotoSelectionDao.insertAllWithoutFace(
        appDb.WithOutPersonsPhotoSelectionCompanion(
            eventCode: drift.Value(eventCode),
            images: drift.Value(images.join(','))));
  }
}
