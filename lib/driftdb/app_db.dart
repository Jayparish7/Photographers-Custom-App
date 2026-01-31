import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/tables.dart';
import 'package:sqflite/sqflite.dart';
import 'package:universal_io/io.dart';

part 'app_db.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getDatabasesPath();
    final file = File(path.join(dbFolder, 'photomallMobile.db'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [
  TransportData,
  Albums,
  JvtFiles,
  JvtFileConnectors,
  Events,
  Folders,
  FolderStatuses,
  FolderRules,
  PhotoSelectionImages,
  EventInfo,
  StudioPackage,
  StudioPackageValue,
  Videos,
  CarouselProperties,
  Carousel,
  Media,
  PhotoSelectionCurrentIndex,
  PhotoSelections,
  PersonsPhotoSelections,
  PersonsAlbums,
  FolderNotification,
  WithOutPersonsAlbums,
  WithOutPersonsPhotoSelection,
  PhotomallStudioInfo,
  CommonTable,
  RealPersonsAlbums,
  Download,
  PhotoSelectionImageFolder,
  RealPersonsPhotoSelections,
  PrintTable,
  UserPersons
],)
class AppDb extends _$AppDb {
  static final AppDb _singleton = AppDb._internal();

  factory AppDb() {
    return _singleton;
  }

  AppDb._internal() : super(_openConnection());

  //AppDb() : super(_openConnection());
  @override
  int get schemaVersion => 14;

  // version [1] 2.7
  // version [2] 2.8
  // version [6] 2.9
  // version [3] 2.11
  // version [4] 2.13
  // version [5] 2.16
  // version [7] 2.17

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(onCreate: (Migrator m) async {
      showLog("the data db creating ...");
      await m.createAll();

      await m.createIndex(Index('photo_selection_images',
          'CREATE INDEX photo_selection_images_code ON photo_selection_images(code);'));
      await m.createIndex(Index('photo_selection_images',
          'CREATE INDEX photo_selection_images_folder_code ON photo_selection_images(folder_code);'));
      await m.createIndex(Index('photo_selection_images',
          'CREATE INDEX photo_selection_images_synced ON photo_selection_images(synced);'));
      await m.createIndex(Index('jvt_file_connectors',
          'CREATE INDEX jvt_file_connectors_code ON jvt_file_connectors(code);'));
      await m.createIndex(Index('jvt_file_connectors',
          'CREATE INDEX jvt_file_connectors_able_code ON jvt_file_connectors(able_code);'));
      await m.createIndex(Index('jvt_file_connectors',
          'CREATE INDEX jvt_file_connectors_able_type ON jvt_file_connectors(able_type);'));
      await m.createIndex(Index('jvt_file_connectors',
          'CREATE INDEX jvt_file_connectors_tag ON jvt_file_connectors(tag);'));
      await m.createIndex(Index(
          'jvt_files', 'CREATE INDEX jvt_files_code ON jvt_files(code);'));
      await m.createIndex(Index('transport_data',
          'CREATE INDEX transport_data_code ON transport_data(code);'));
      await m.createIndex(Index('transport_data',
          'CREATE INDEX transport_data_tag ON transport_data(tag);'));

      await m.createIndex(
          Index('folders', 'CREATE INDEX folders_code ON folders(code);'));

      await m.createIndex(Index('folder_rules',
          'CREATE INDEX folder_rules_code ON folder_rules(code);'));

      await m.createIndex(
          Index('events', 'CREATE INDEX events_code ON events(code);'));

      await m.createIndex(Index('event_info',
          'CREATE INDEX event_info_code ON event_info(event_code);'));

      await m.createIndex(
          Index('media', 'CREATE INDEX media_code ON media(code);'));

      await m.createIndex(
          Index('albums', 'CREATE INDEX albums_code ON albums(code);'));

      await m.createIndex(Index('carousel_properties',
          'CREATE INDEX carousel_properties_code ON carousel_properties(code);'));

      await m.createIndex(
          Index('carousel', 'CREATE INDEX carousel_code ON carousel(code);'));

      await m.createIndex(Index('folder_status',
          'CREATE INDEX folder_status_code ON folder_status(folder_code);'));

      await m.createIndex(
          Index('videos', 'CREATE INDEX videos_code ON videos(code);'));

      await m.createIndex(Index('persons_photo_selections',
          'CREATE INDEX persons_photo_selections_code ON persons_photo_selections(code);'));
      await m.createIndex(Index('persons_albums',
          'CREATE INDEX persons_albums_code ON persons_albums(code);'));
      await m.createIndex(Index('folder_notification',
          'CREATE INDEX folder_notification_code ON folder_notification(event_code);'));
    }, onUpgrade: (Migrator m, int from, int to) async {
      showLog("migrating database onUpgrade");

      if (from < 14) {
        showLog("migrating database to 14...");
        await m.addColumn(videos,videos.visibility);

      }  if (from < 13) {
        showLog("migrating database to 13...");
        await m.addColumn(albums,albums.visibility);

      } if (from < 12) {
        showLog("migrating database to 12...");
        await m.addColumn(events,events.ownerDownload);

      }
      if (from < 11) {
        showLog("migrating database to 11...");
        await m.createTable(userPersons);

      }
      if (from < 10) {
        showLog("migrating database to 10...");
        await m.createTable(printTable);
        await m.addColumn(events, events.printStatus);
      }

      if (from < 9) {
        showLog("migrating database to 9...");
        await m.createTable(realPersonsAlbums);
        await m.createTable(download);
        await m.createTable(photoSelectionImageFolder);
        await m.createTable(realPersonsPhotoSelections);
      }
      if (from < 8) {
        showLog("migrating database to 8...");
        await m.addColumn(events, events.myPhotosDownloadable);
        await m.addColumn(events, events.hideMedia);
      }
      if (from < 7) {
        showLog("migrating database to 7...");
        await m.createTable(commonTable);
      }
      if (from < 6) {
        showLog("migrating database ...6");
        // Photo mall app studio data
        await m.createTable(photomallStudioInfo);
        await m.addColumn(events, events.studioCode);
      }
      if (from < 5) {
        showLog("migrating database to 4...");
        //await m.createTable(downloadStatus);
      }

      if (from < 4) {
        showLog("migrating database to 4...");
        await m.deleteTable("temporary_urls");
      }

      if (from < 3) {
        await m.addColumn(events, events.shareDate);
      }

      if (from < 2) {
        showLog("migrating database ...");
        // create withoutPerson photo selection and album table 2.8 release
        // addColumn downloadable in album table 2.8 release
        await m.createTable(withOutPersonsAlbums);
        await m.createTable(withOutPersonsPhotoSelection);
      }
    }, beforeOpen: (detail) async {
      // if (!isDeveloperMode) {
      //   await customStatement('PRAGMA journal_mode = wal');
      await customStatement('PRAGMA synchronous = normal');
      //  }
    });
  }
}
