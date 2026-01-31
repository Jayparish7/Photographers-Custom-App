import 'package:drift/drift.dart';

class TransportData extends Table {
  @override
  String get tableName => 'transport_data';

  IntColumn get id => integer().named('id').autoIncrement()();

  TextColumn get code => text().named('code').withLength(max: 30).nullable()();

  TextColumn get tag => text()
      .named('tag')
      .withLength(
        max: 30,
      )
      .nullable()();

  IntColumn get lastUpdatedAt => integer().named('last_updated_at')();

  IntColumn get updateRequired =>
      integer().named('update_required').withDefault(Constant(0))();

  IntColumn get type => integer().named('type').nullable()();

  TextColumn get data => text().named('data').nullable()();

  @override
  Set<Column> get primaryKey => {id};
// Set<Column> get createIndexStmt => {code,tag};
}

class PhotoSelectionImageFolder extends Table {
  @override
  String get tableName => 'photo_selection_image_folder_status';

  TextColumn get eventCode =>
      text().named('event_code').withLength(max: 30).nullable()();

  IntColumn get lastUpdatedAt => integer().named('last_updated_at')();

  @override
  Set<Column> get primaryKey => {eventCode};
// Set<Column> get createIndexStmt => {eventCode};
}

class Events extends Table {
  @override
  String get tableName => 'events';

  TextColumn get code => text().named('code')();

  TextColumn get name => text().named('name').nullable()();

  TextColumn get categoryName => text().named('category_name')();

  BoolColumn get published =>
      boolean().named('published').withDefault(Constant(false))();

  IntColumn get type =>
      integer().named('type')(); // 1=>User Events,2=>Gallery Event,
  BoolColumn get loginRequired => boolean().named('login_required')();

  BoolColumn get newlyAdded => boolean()
      .named('newly_added')(); // If new event occur set value 1 otherwise 0
  BoolColumn get archived => boolean().named('archived')();

  BoolColumn get ownedByUser => boolean().named('owned_by_user')();

  BoolColumn get downloadable =>
      boolean().named('downloadable').withDefault(Constant(false))();

  BoolColumn get withIcon =>
      boolean().named('with_icon').withDefault(Constant(false))();

  BoolColumn get withWaterMark =>
      boolean().named('with_water_mark').withDefault(Constant(false))();

  IntColumn get priorityScore => integer().named('priority_score').nullable()();

  BoolColumn get personStatus =>
      boolean().named('person_status').withDefault(Constant(false))();
  BoolColumn get isAlbumDownloadable =>
      boolean().named('isAlbumDownloadable').withDefault(Constant(false))();
  TextColumn get studioCode => text().named('studio_code').nullable()();
  TextColumn get shareDate => text().named('share_date').nullable()();
  BoolColumn get myPhotosDownloadable =>
      boolean().named('my_photos_downloadable').withDefault(Constant(false))();
  BoolColumn get hideMedia =>
      boolean().named('hide_media').withDefault(const Constant(false))();
  BoolColumn get ownerDownload =>
      boolean().named('owner_download').withDefault(const Constant(false))();
  BoolColumn get printStatus =>
      boolean().named('print_status').withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {code};
// Set<Column> get createIndexStmt => {code,archived};
}

class Albums extends Table {
  @override
  String get tableName => 'albums';

  TextColumn get code => text().named('code').withLength(max: 10)();

  TextColumn get eventCode => text()
      .named('event_code')
      .withLength(
        max: 10,
      )
      .customConstraint('NULL REFERENCES events(code)')();

  TextColumn get name => text().named('name')();

  IntColumn get type => integer().named(
      'type')(); //1-Photo Selection,2-e-Photobook,4- Invitation 5-Photo Album
  TextColumn get size => text().named('size')();

  BoolColumn get published =>
      boolean().named('published').withDefault(Constant(false))();


  IntColumn get visibility => integer().named('visibility').nullable()();
  IntColumn get priorityScore => integer().named('priority_score')();

  TextColumn get lastSeenIndex => text().named('last_seen_index').nullable()();

  TextColumn get orders => text().named('orders').nullable()();

  TextColumn get oldOrders => text().named('old_orders').nullable()();

  TextColumn get coverImage => text().named('cover_image').nullable()();

  TextColumn get music => text().named('music').nullable()();

  @override
  Set<Column> get primaryKey => {code};
// Set<Column> get createIndexStmt => {code};
}

class PhotoSelections extends Table {
  @override
  String get tableName => 'photo_selections';

  TextColumn get code => text()
      .named('code')
      .withLength(
        max: 10,
      )
      .nullable()();

  TextColumn get eventCode => text().named('event_code').withLength(
        max: 10,
      )();

  BoolColumn get published =>
      boolean().named('published').withDefault(Constant(false))();

  BoolColumn get confirmationStatus =>
      boolean().named('confirmation_status').withDefault(Constant(false))();

  IntColumn get lastUpdatedAt =>
      integer().named('last_updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {eventCode};
// Set<Column> get createIndexStmt => {code,eventCode};
}

class Videos extends Table {
  @override
  String get tableName => 'videos';

  TextColumn get code => text().named('code').withLength(max: 10)();

  TextColumn get eventCode => text()
      .named('event_code')
      .withLength(max: 10)
      .customConstraint('NULL REFERENCES events(code)')();

  TextColumn get name => text().named('name')();

  TextColumn get url => text().named('url')();

  IntColumn get priorityScore => integer().named('priority_score')();

  BoolColumn get published =>
      boolean().named('published').withDefault(Constant(false))();
  IntColumn get visibility => integer().named('visibility').nullable()();


  @override
  Set<Column> get primaryKey => {code};

// Set<Column> get createIndexStmt => {code,eventCode};
}

class JvtFileConnectors extends Table {
  @override
  String get tableName => 'jvt_file_connectors';

  TextColumn get code => text().named('code').withLength(max: 10)();

  TextColumn get ableCode => text().named('able_code').withLength(max: 10)();

  TextColumn get ableType => text().named('able_type')();

  TextColumn get tag => text().named('tag').nullable()();

  TextColumn get jvtFileCode => text()
      .named('jvt_file_code')
      .withLength(max: 10)
      .customConstraint('NULL REFERENCES jvt_files(code)')();

  @override
  Set<Column> get primaryKey => {code};
// Set<Column> get createIndexStmt => {code,ableCode,ableType};
}

class JvtFiles extends Table {
  @override
  String get tableName => 'jvt_files';

  TextColumn get code => text().named('code').withLength(max: 10)();

  TextColumn get name => text().named('name')();

  IntColumn get mode => integer().named('mode')(); //0->public  1-> private
  TextColumn get extension => text().named('extension')();

  IntColumn get downloaded => integer()
      .named('downloaded')
      .withDefault(Constant(0))(); // 0->false || 1->true || 2->studioEvent
  IntColumn get size => integer().named('size')();

  IntColumn get attempt =>
      integer().named('attempt').withDefault(Constant(0))();

  IntColumn get priority =>
      integer().named('priority').withDefault(Constant(0))();

  BoolColumn get isNetworkImage => boolean()
      .named('is_network_image')
      .withDefault(Constant(false))
      .nullable()();

  @override
  Set<Column> get primaryKey => {code};
// Set<Column> get createIndexStmt => {code};
}

class Folders extends Table {
  @override
  String get tableName => 'folders';

  TextColumn get code => text().named('code').withLength(max: 10)();

  TextColumn get name => text().named('name')();

  TextColumn get parentCode => text()
      .named('parent_code')
      .withLength(max: 10)
      .nullable()
      .customConstraint('NULL REFERENCES folders(code)')();

  TextColumn get eventCode => text()
      .named('event_code')
      .withLength(max: 10)
      .customConstraint('NULL REFERENCES events(code)')();

  TextColumn get size => text().named('size').nullable()();

  BoolColumn get published =>
      boolean().named('published').withDefault(Constant(false)).nullable()();

  BoolColumn get submitted =>
      boolean().named('submitted').withDefault(Constant(false)).nullable()();

  IntColumn get lastUpdatedAt =>
      integer().named('lastUpdatedAt').withDefault(Constant(0))();

  @override
  Set<Column> get primaryKey => {code};
// Set<Column> get createIndexStmt => {code,eventCode};
}

class FolderRules extends Table {
  @override
  String get tableName => 'folder_rules';

  TextColumn get code => text().named('code').withLength(max: 10)();

  TextColumn get folderCode => text()
      .named('folder_code')
      .withLength(max: 10)
      .customConstraint('NULL REFERENCES folders(code)')();

  IntColumn get minimumSelectionImages =>
      integer().named('minimum_selection_images')();

  IntColumn get maximumSelectionImages =>
      integer().named('maximum_selection_images')();

  IntColumn get result => integer().named('result')();

  @override
  Set<Column> get primaryKey => {code};
// Set<Column> get createIndexStmt => {code,folderCode};
}

class PhotoSelectionImages extends Table {
  @override
  String get tableName => 'photo_selection_images';

  TextColumn get code => text().named('code').withLength(max: 10)();

  IntColumn get lastUpdated => integer().named('last_updated_at')();

  TextColumn get folderCode => text()
      .named('folder_code')
      .withLength(max: 10)
      .customConstraint('NULL REFERENCES folders(code)')();

  IntColumn get status => integer().named('status')();

  // TextColumn get originalFileName => text().named('original_file_name')();
  BoolColumn get synced =>
      boolean().named('synced').withDefault(Constant(false))();

  TextColumn get comment => text().named('comment')();

  IntColumn get rating => integer().named('rating')();

  TextColumn get originalName => text().named('originalName').nullable()();

  @override
  Set<Column> get primaryKey => {code};
// Set<Column> get createIndexStmt => {code,folderCode,synced};
}

class EventInfo extends Table {
  @override
  String get tableName => 'event_info';

  IntColumn get id => integer().named('id').autoIncrement()();

  TextColumn get eventCode => text()
      .named('event_code')
      .withLength(max: 10)
      .customConstraint('NULL REFERENCES events(code)')();

  TextColumn get value => text().named('value')();
// Set<Column> get createIndexStmt => {eventCode,};
}

class StudioPackage extends Table {
  @override
  String get tableName => 'studio_package';

  TextColumn get code => text().named('code').withLength(max: 10)();

  TextColumn get name => text().named('name').nullable()();

  TextColumn get description => text().named('description').nullable()();

  BoolColumn get published => boolean().named('published').nullable()();

  IntColumn get price => integer().named('price').nullable()();

  IntColumn get discountValue => integer().named('discount_value').nullable()();

  IntColumn get discountTerm => integer().named('discount_term').nullable()();

  @override
  Set<Column> get primaryKey => {code};
// Set<Column> get createIndexStmt => {code};
}

class StudioPackageValue extends Table {
  @override
  String get tableName => 'studio_package_value';

  TextColumn get code => text().named('code').withLength(max: 10)();

  TextColumn get key => text().named('key')();

  TextColumn get value => text().named('value')();

  TextColumn get ableCode => text().named('able_code')();

  @override
  Set<Column> get primaryKey => {code};
// Set<Column> get createIndexStmt => {code,ableCode};
}

class FolderStatuses extends Table {
  String get tableName => 'folder_status';

  IntColumn get id => integer().named('id').autoIncrement()();

  TextColumn get folderCode => text()
      .named('folder_code')
      .withLength(max: 10)
      .customConstraint('NULL REFERENCES folders(code)')();

  BoolColumn get combined => boolean().named('combined')();

  IntColumn get selected => integer().named('selected')();

  IntColumn get rejected => integer().named('rejected')();

  IntColumn get waitingListed => integer().named('waiting_listed')();

// 1, 0, 0, 0, 0, 0
// 1, 1, 45, 0, 0, 0
  @override
  Set<Column> get primaryKey => {id};

// Set<Column> get createIndexStmt => {folderCode};
}

class CarouselProperties extends Table {
  @override
  String get tableName => 'carousel_properties';

  TextColumn get code => text().named('code').withLength(max: 10)();

  IntColumn get priorityScore => integer().named('priority_score')();

  TextColumn get ableCode =>
      text().named('able_code').withLength(max: 10).nullable()();

  TextColumn get ableType =>
      text().named('able_type').withLength(max: 10).nullable()();

  TextColumn get image => text().named('image').nullable()();

  @override
  Set<Column> get primaryKey => {code};
// Set<Column> get createIndexStmt => {code};
}

class Media extends Table {
  @override
  String get tableName => 'media';

  TextColumn get code => text().named('code').withLength(max: 10)();

  TextColumn get eventCode => text().named('event_code').withLength(max: 10)();

  TextColumn get ableType => text().named('able_type')();

  TextColumn get ableCode => text().named('able_code')();

  IntColumn get priorityScore => integer().named('priority_score')();

  BoolColumn get published => boolean().named('published')();

  IntColumn get lastUpdated => integer().named('last_updated_at')();

  @override
  Set<Column> get primaryKey => {code};
// Set<Column> get createIndexStmt => {code,eventCode};
}

class Carousel extends Table {
  @override
  String get tableName => 'carousel';

  TextColumn get code => text().named('code')();

  IntColumn get interval => integer().named('interval')();

  IntColumn get height => integer().named('height')();

  IntColumn get width => integer().named('width')();

  IntColumn get lastUpdatedAt => integer().named('last_updated_at')();

  @override
  Set<Column> get primaryKey => {code};
// Set<Column> get createIndexStmt => {code,};
}

class PhotoSelectionCurrentIndex extends Table {
  @override
  String get tableName => 'Photo_selection_current_index';

  IntColumn get id => integer().named('id').autoIncrement()();

  TextColumn get folderCode => text().named('folder_code')();

  IntColumn get status => integer().named('status')();

  TextColumn get photoSelectionCode => text().named('photo_selection_code')();

  @override
  Set<Column> get primaryKey => {id};

  // Set<Column> get createIndexStmt => {folderCode};

  @override
  List<String> get customConstraints => ['UNIQUE (folder_code, status)'];
}

class PersonsPhotoSelections extends Table {
  @override
  String get tableName => 'persons_photo_selections';

  TextColumn get code => text().named('code').withLength(max: 10)();

  TextColumn get eventCode => text().named('event_code').withLength(max: 10)();

  TextColumn get image => text().named('image')();

  IntColumn get score => integer().named('score')();

  TextColumn get images => text().named('images')();

  @override
  Set<Column> get primaryKey => {code};
// Set<Column> get createIndexStmt => {code,eventCode};
}

class RealPersonsPhotoSelections extends Table {
  @override
  String get tableName => 'real_persons_photo_selections';

  TextColumn get code => text().named('code').withLength(max: 10)();

  TextColumn get eventCode => text().named('event_code').withLength(max: 10)();

  TextColumn get image => text().named('image')();

  IntColumn get score => integer().named('score')();

  TextColumn get persons => text().named('persons')();

  @override
  Set<Column> get primaryKey => {code};
// Set<Column> get createIndexStmt => {code,eventCode};
}

class PersonsAlbums extends Table {
  @override
  String get tableName => 'persons_albums';

  TextColumn get code => text().named('code').withLength(max: 10)();

  TextColumn get eventCode => text().named('event_code').withLength(max: 10)();

  TextColumn get image => text().named('image')();

  IntColumn get score => integer().named('score')();

  TextColumn get images => text().named('images')();

  @override
  Set<Column> get primaryKey => {code};
// Set<Column> get createIndexStmt => {code,eventCode};
}

class RealPersonsAlbums extends Table {
  @override
  String get tableName => 'real_persons_albums';

  TextColumn get code => text().named('code').withLength(max: 10)();

  TextColumn get eventCode => text().named('event_code').withLength(max: 10)();

  TextColumn get image => text().named('image')();

  IntColumn get score => integer().named('score')();

  TextColumn get persons => text().named('persons')();

  @override
  Set<Column> get primaryKey => {code};
// Set<Column> get createIndexStmt => {code,eventCode};
}

class FolderNotification extends Table {
  @override
  String get tableName => 'folder_notification';

  TextColumn get eventCode => text().named('event_code').withLength(max: 10)();

  TextColumn get folderCodes => text().named('folder_code')();

  TextColumn get oldFolderCodes => text().named('old_folder_code')();

  @override
  Set<Column> get primaryKey => {eventCode};
// Set<Column> get createIndexStmt => {eventCode};
}

class WithOutPersonsAlbums extends Table {
  @override
  String get tableName => 'without_persons_albums';

  TextColumn get eventCode => text().named('event_code').withLength(max: 10)();

  TextColumn get images => text().named('images')();

  @override
  Set<Column> get primaryKey => {eventCode};
}

class WithOutPersonsPhotoSelection extends Table {
  @override
  String get tableName => 'without_persons_photo_`selection';

  TextColumn get eventCode => text().named('event_code').withLength(max: 10)();

  TextColumn get images => text().named('images')();

  @override
  Set<Column> get primaryKey => {eventCode};
}

class PhotomallStudioInfo extends Table {
  @override
  String get tableName => 'Photomall_studio_Info';

  TextColumn get code => text()
      .named('code')
      .withLength(max: 10)
      .customConstraint('NULL REFERENCES events(code)')();

  TextColumn get value => text().named('value')();

  IntColumn get lastUpdatedAt => integer().named('last_updated_at')();

  @override
  Set<Column> get primaryKey => {code};
}

class Download extends Table {
  @override
  String get tableName => 'download_status';

  TextColumn get ableCode => text().named('able_code')();
  TextColumn get ableType => text().named('able_type')();

  BoolColumn get downloadedStatus =>
      boolean().named('downloaded_status').withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {ableCode};
}

class CommonTable extends Table {
  @override
  String get tableName => 'common_table';
  TextColumn get key => text().named('key')();

  TextColumn get value => text().named('value')();
// Set<Column> get createIndexStmt => {eventCode,};
  @override
  Set<Column> get primaryKey => {key};
}

class PrintTable extends Table {
  @override
  String get tableName => 'print_table';

  TextColumn get code => text().named('code').withLength(max: 10)();

  TextColumn get eventCode => text().named('event_code').withLength(max: 10)();

  TextColumn get ableType => text().named('able_type')();

  TextColumn get ableCode => text().named('able_code')();

  IntColumn get status => integer().named('status')();

  @override
  Set<Column> get primaryKey => {ableCode};
// Set<Column> get createIndexStmt => {code,eventCode};
}

class UserPersons extends Table {
  @override
  String get tableName => 'user_persons_table';

  TextColumn get code => text().named('code')();

  TextColumn get name => text().named('name')();

  TextColumn get relationship => text().named('relationship')();

  TextColumn get images => text().named('images')();

  IntColumn get userOwnImage => integer().named('User_own_image')();

  @override
  Set<Column> get primaryKey => {code};
// Set<Column> get createIndexStmt => {code,eventCode};
}
