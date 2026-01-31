import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;

class VideoModelDao {
  AppDb database = AppDb();

  /// Get all video method

  Future<List<Video>> getVideos() async {
    return await database.select(database.videos).get();
  }

  Future<List<Video>> getVideosByCode(String code) async {
    return await (database.select(database.videos)
          ..where((tbl) => tbl.code.equals(code)))
        .get();
  }

  Future<List<Video>> getVideosWhereVisibilityNull(String code) async {
    return await (database.select(database.videos)
          ..where(
              (tbl) => tbl.eventCode.equals(code) & tbl.visibility.isNull()))
        .get();
  }

  Future<Video?> getVideoByCode(String code) async {
    return await (database.select(database.videos)
          ..where((tbl) => tbl.code.equals(code))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Delete video with code

  Future<int> deleteVideosByCode(String code) async {
    return await (database.delete(database.videos)
          ..where((tbl) => tbl.code.equals(code)))
        .go();
  }

  Future<int> deleteVideosByEventCode(String eventCode) async {
    return await (database.delete(database.videos)
          ..where((tbl) => tbl.eventCode.equals(eventCode)))
        .go();
  }

  /// Update event with code

  Future<void> updateVideosByCode(
      VideosCompanion entity, String compare) async {
    await (database.update(database.videos)
          ..where((tbl) => tbl.code.equals(compare)))
        .write(entity);
  }

  /// Insert new entity

  Future<int> insertVideos(VideosCompanion entity) async {
    return await database.into(database.videos).insert(entity);
  }

  /// InsertOrUpdate new entity

  Future<int> insertOrUpdateVideos(VideosCompanion entity) async {
    return await database.into(database.videos).insertOnConflictUpdate(entity);
  }

  Future<void> insertOrUpdateVideosTable(
      {required transporter.Mediable video,
      required String eventCode,
      required bool published,
      required int priorityScore}) async {
    VideosCompanion videosCompanion = VideosCompanion(
      code: drift.Value(video.code!),
      name: drift.Value(video.name!),
      url: drift.Value(video.url!),
      published: drift.Value(published),
      eventCode: drift.Value(eventCode),
      priorityScore: drift.Value(priorityScore),
    );
    await database
        .into(database.videos)
        .insertOnConflictUpdate(videosCompanion);
  }

  Future<void> insertAllVideos(List<VideosCompanion> videos) async {
    if (videos.isNotEmpty) {
      await database.batch((batch) {
        return batch.insertAllOnConflictUpdate(database.videos, videos);
      });
    }
  }
}
