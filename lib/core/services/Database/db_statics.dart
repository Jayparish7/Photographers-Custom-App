class DbStatics {
  ///common
  static const _createTable = 'CREATE TABLE';
  static const _integer = 'INTEGER';
  static const _text = 'TEXT';
  static const _primaryKey = 'PRIMARY KEY';
  static const KEY_ACCESS_TYPE = "access_type";

  static const id = 'id';
  static const name = 'name';
  static const url = 'url';
  static const userRandomId = 'user_random_id';
  static const lastUpdatedAt = 'last_updated_at';
  ///Temporary URL Table
  static const temporaryUrlTable = 'temporary_url';
  static const tempId = 'id';
  static const tempUrl = 'url';
  static const expiryDate = 'expiry_date';
  static const createTemporaryUrlTable =
      '$_createTable $temporaryUrlTable ($tempId $_text $_primaryKey,'
      '$tempUrl $_text,$expiryDate $_text)';

  ///Last Updated At table
  static const tableLastUpdatedAt = '${lastUpdatedAt}_table';
  static const lastUpdatedAtUrl = '$url';
  static const lastUpdatedAtValue = '$lastUpdatedAt';

  static const createLastUpdatedAtTable =
      '$_createTable $tableLastUpdatedAt ($lastUpdatedAtUrl '
      '$_text $_primaryKey,$lastUpdatedAtValue $_integer)';

  /// Table Events
  static const tableEvents = "events";
  static const eventCode = "code";
  static const eventName = "name";
  static const eventCoverImageId = "cover_image_id";
  static const eventCategoryName = "category_name";
  static const eventType =
      "event_type"; // 1 -> User event, 2 -> Studio Event, 3 -> Gallery Event
  static const eventStudioId = "studio_id";
  static const eventLoginRequired = "login_required";
  static const eventNewlyAdded =
      "newly_added"; // If new event occur set value 1 otherwise 0
  static const eventArchived = "archived";
  static const eventOwnerOfTheEventStatus = "owned_by_user";
  static const KEY_PUBLISH = "published";

  static const createTableEvents =
      '$_createTable $tableEvents($eventCode $_text $_primaryKey,'
      '$eventType $_integer,'
      '$eventName $_text,'
      '$eventCoverImageId $_integer,'
      '$eventCategoryName $_text,'
      '$eventLoginRequired $_integer,'
      '$eventStudioId $_integer,'
      '$eventNewlyAdded $_integer,'
      '$eventArchived $_integer,'
      '$eventOwnerOfTheEventStatus $_integer,'
      '$KEY_PUBLISH $_integer)';

  ///Table Images
  static const tableFiles = "file";
  static const fileCode = "code";
  static const fileName = name;
  static const fileDownloaded = "downloaded";
  static const fileSize = "size";


  static const createTableAlbumImages =
      '$_createTable $tableFiles ($fileCode $_text $_primaryKey,'
      '$fileName $_text,'
      '$fileDownloaded $_integer DEFAULT 0,'
      '$fileSize $_integer,'
      '$KEY_ACCESS_TYPE $_integer)';

  /// Table Folders
  static const tableFileConnectors = "file_connectors";
  static const fileConnectorAbleType = "able_type";
  static const fileConnectorAbleCode = "able_code";
  static const fileConnectorName = "name";
  static const fileConnectorAbleIdFileId = "file_code";

  static const createTableFileConnectors =
      '$_createTable $tableFileConnectors ($fileConnectorAbleType $_text,'
      '$fileConnectorAbleCode $_text,'
      '$fileConnectorName $_text,'
      '$fileConnectorAbleIdFileId $_integer,'
      ' CONSTRAINT file_connector_constraint UNIQUE ($fileConnectorAbleType, $fileConnectorAbleCode, $fileConnectorAbleIdFileId))';

  /// Table Transport Data
  static const tableTransportData = "transport_data";
  static const transportDataCode = "code";
  static const transportDataTag = "tag";
  static const transportDataLastUpdatedAt = "last_updated_at";
  static const transportDataUpdateRequired = "update_required";

  static const createTableTransportData =
      '$_createTable $tableTransportData ($transportDataCode $_text,'
      '$transportDataTag $_text,'
      '$transportDataLastUpdatedAt $_integer,'
      '$transportDataUpdateRequired $_integer,'
      ' CONSTRAINT transport_data_constraint UNIQUE ($transportDataCode, $transportDataTag))';


  ///Table audio
  static const TABLE_AUDIO = "audio";
  static const KEY_AUDIO_ID = "audio_id";

  static const KEY_AUDIO_REFERENCE_ID = "reference_id";
  static const KEY_AUDIO_NAME = "name";
  static const KEY_AUDIO_ORIGINAL_URL = "audio_original_url";
  static const KEY_AUDIO_EXTENSION = "audio_extension";
  static const KEY_AUDIO_ORIGINAL_DOWNLOAD_STATUS = "audio_original_download_status";
  static const KEY_AUDIO_SIZE = "audio_size";
  static const KEY_AUDIO_ACCESS_TYPE = "audio_access_type";

  static const CREATE_TABLE_AUDIO =
      '$_createTable $TABLE_AUDIO ($KEY_AUDIO_ID $_integer $_primaryKey,'
      '$KEY_AUDIO_REFERENCE_ID $_integer,'
      '$KEY_AUDIO_NAME $_text,'
      '$KEY_AUDIO_ORIGINAL_URL $_text DEFAULT "",'
      '$KEY_AUDIO_EXTENSION $_text DEFAULT "",'
      '$KEY_AUDIO_ORIGINAL_DOWNLOAD_STATUS $_integer DEFAULT 0,'
      '$KEY_AUDIO_SIZE $_integer,'
      '$KEY_AUDIO_ACCESS_TYPE $_integer)';

  ///Table Photo Selection Images
  static const tablePhotoSelectionImages = "photo_selection_images";
  static const photoSelectionImageID = "image_id";

  // 0->wait list, 1->selected, 2->rejected
  static const photoSelectionImageSelectedStatus = "selected_status";
  static const photoSelectionImageSyncStatus = "sync_status";

  static const createTablePhotoSelectionImages =
      '$_createTable $tablePhotoSelectionImages ($photoSelectionImageID $_integer $_primaryKey,'
      '$photoSelectionImageSelectedStatus $_integer,'
      '$photoSelectionImageSyncStatus $_integer)';

  ///Table Photo Selection Edited Images
  static const tablePhotoSelectionEditedImages =
      "photo_selection_images";
  static const photoSelectionEditedImageID = "edited_image_id";
  static const photoSelectionEditedAlbumID = "edited_image_album_id";

  // 0->wait list, 1->selected, 2->rejected
  static const photoSelectionEditedImageStatus = "edited_image_status";

  static const createTablePhotoSelectionEditedImages =
      '$_createTable $tablePhotoSelectionEditedImages ($photoSelectionEditedImageID $_integer $_primaryKey,'
      '$photoSelectionEditedAlbumID $_integer,'
      '$photoSelectionEditedImageStatus $_integer)';

  ///Table Completed Album Images
  static const tableCompletedAlbumImages = "completed_album_images";
  static const completedAlbumImageID = "image_id";
  static const completedAlbumID = "completed_album_id";
  static const completedAlbumImageOrder = "completed_album_images_order";
  static const completedAlbumImageMergeImageName = "merge_image_name";

  static const createCompletedAlbumImages =
      '$_createTable $tableCompletedAlbumImages ($completedAlbumImageID $_integer $_primaryKey,'
      '$completedAlbumID $_integer,'
      '$completedAlbumImageMergeImageName $_text DEFAULT "",'
      '$completedAlbumImageOrder $_integer)';

  ///Table Albums -> common table for completed album & photo selection

  static const tableAlbums = "albums";
  static const albumCode = "code";
  static const albumEventCode = "event_code";
  static const albumName = "name";
  
  //1-Pre-designed album,2-Completed album,3-Studio Gallery,4- Invitation,5-demo preDesign
  static const albumType = "type";
  static const albumSize = "size";
  static const albumLastUpdatedAt = lastUpdatedAt;

  static const createTableAlbums =
      '$_createTable $tableAlbums ($albumCode $_text $_primaryKey,'
      '$albumEventCode $_integer,'
      '$albumName $_text,'
      '$albumType $_integer,'
      '$albumSize $_text,'
      '$albumLastUpdatedAt $_integer,'
      '$KEY_PUBLISH $_integer)';

  ///Table Completed Album Details
  static const tableCompletedAlbumDetails = "completed_album_details";
  static const completedAlbumDetailsID = "completed_album_id";
  static const completedAlbumDetailsOrientation = "completed_album_orientation";
  static const completedAlbumDetailsMusic = "completed_album_music";
  static const completedAlbumDetailsRatio = "completed_album_ratio";

  static const createTableCompletedAlbumDetails =
      '$_createTable $tableCompletedAlbumDetails ($completedAlbumDetailsID $_integer $_primaryKey,'
      '$completedAlbumDetailsOrientation $_text,'
      '$completedAlbumDetailsMusic $_text,'
      '$completedAlbumDetailsRatio $_text)';

  ///Table Photo Selection Details
  static const tablePhotoSelectionAlbumDetails = "photo_selection_album_details";
  static const photoSelectionDetailsAlbumID = "photo_selection_album_id";

  //status 0 or 1-> moved to design or not
  static const photoSelectionDetailsStatus = "photo_selection_album_status";
  static const photoSelectionDetailsAlbumType = "photo_selection_album_type";
  static const createTablePhotoSelectionDetails =
      '$_createTable $tablePhotoSelectionAlbumDetails ($photoSelectionDetailsAlbumID $_integer $_primaryKey,'
      '$photoSelectionDetailsStatus $_integer,'
      '$photoSelectionDetailsAlbumType $_integer)';

  /// Table Folders
  static const tableFolders = "folders";
  static const folderCode = "code";
  static const folderName = "name";
  static const folderParentId = "parent_id";
  static const folderEventId = "event_id";
  static const folderPublish = "publish_status";

  static const createTableFolders =
      '$_createTable $tableFolders ($folderCode $_text $_primaryKey,'
      '$folderName $_text,'
      '$folderParentId $_integer,'
      '$folderEventId $_integer,'
      '$folderPublish $_integer)';

  /// Table Folder Rules
  static const tableFolderRules = "folder_rule";
  static const folderRuleCode = "code";
  static const folderRuleFolderCode = "folder_code";
  static const folderMinimumSelectionImages = "minimum_selection_images";
  static const folderMaximumSelectionImages = "maximum_selection_images";

  static const createTableFolderRule =
      '$_createTable $tableFolderRules ($folderRuleCode $_text $_primaryKey,'
      '$folderRuleFolderCode $_text,'
      '$folderMinimumSelectionImages $_integer,'
      '$folderMaximumSelectionImages $_integer)';


  /// Table Studio Details
  static const tableStudioDetails = "studio_details";
  static const studioId = "studio_id";
  static const studioName = "studio_name";

  //static const studioCity = "city";
  static const studioDistrict = "district";

  static const createTableStudioDetails =
      '$_createTable $tableStudioDetails ($studioId $_integer $_primaryKey,'
      '$studioName $_text,'
      '$studioDistrict $_text)';

  /// Table Durations

  static const tableDurations = "durations";
  static const durationsId = "durations_id";
  static const durationsEventId = "durations_event_id";
  static const durationsName = "durations_name";
  static const durationsDate = "durations_date";
  static const durationsStartTime = "durations_start_time";
  static const durationsEndTime = "durations_end_time";
  static const durationsStreet = "street";
  static const durationsLocality = "locality";
  static const durationsCity = "city";
  static const durationsDistrict = "district";
  static const durationState = "state";
  static const durationsCountry = "country";
  static const durationsPinCode = "pincode";

  static const createTableDurations =
      '$_createTable $tableDurations ($durationsId $_integer $_primaryKey,'
      '$durationsEventId $_integer,'
      '$durationsName $_text,'
      '$durationsDate $_text,'
      '$durationsStartTime $_text,'
      '$durationsEndTime $_text,'
      '$durationsStreet $_text,'
      '$durationsLocality $_text,'
      '$durationsCity $_text,'
      '$durationsDistrict $_text,'
      '$durationState $_text,'
      '$durationsCountry $_text,'
      '$durationsPinCode $_integer)';

  ///Table Videos
  static const tableVideos = "videos";
  static const videosId = "videos_id";
  static const videosEventId = "videos_event_id";
  static const videosName = "videos_name";
  static const videosUrl = "videos_url";

  static const createTableVideos = '$_createTable $tableVideos ('
      '$videosId $_integer $_primaryKey,'
      '$videosEventId $_integer,'
      '$videosName $_text,'
      '$videosUrl $_text,'
      '$KEY_PUBLISH $_integer)';

  ///Table Invitations
  static const tableInvitations = "invitations";
  static const invitationsId = "invitations_id";
  static const invitationsName = "invitations_name";
  static const invitationsEventId = "invitations_event_id";

  static const createTableInvitations = '$_createTable $tableInvitations ('
      '$invitationsId $_integer $_primaryKey,'
      '$invitationsName $_text,'
      '$invitationsEventId $_integer)';

  ///Table Event Types Categories
  static const tableEventTypesCategories = "event_types_categories";
  static const eventTypesCategoriesId = "event_types_categories_id";
  static const eventTypesCategoriesName = "event_types_categories_name";

  static const createTableEventTypesCategories =
      '$_createTable $tableEventTypesCategories ('
      '$eventTypesCategoriesId $_integer $_primaryKey,'
      '$eventTypesCategoriesName $_text)';

  ///Table Event Types Sub Categories
  static const tableEventTypesSubCategories = "event_types_sub_categories";
  static const eventTypesSubCategoriesId = "event_types_sub_categories_id";
  static const eventTypesSubCategoriesName = "event_types_sub_categories_name";

  static const createTableEventTypesSubCategories =
      '$_createTable $tableEventTypesSubCategories ('
      '$eventTypesSubCategoriesId $_integer $_primaryKey,'
      '$eventTypesCategoriesId $_integer,'
      '$eventTypesCategoriesName $_text)';

  ///Table Country Codes
  static const tableCountryCodes = "country_codes";
  static const countryCodesId = "country_codes_id";
  static const countryCodesName = "country_name";
  static const countryCodesCode = "country_code";

  static const createTableCountryCodes = '$_createTable $tableCountryCodes ('
      '$countryCodesId $_integer $_primaryKey,'
      '$countryCodesName $_text,'
      '$countryCodesCode $_text)';

  ///Table Address
  static const tableAddress = "address";
  static const addressId = "id";
  static const addressStreet = "street";
  static const addressLocality = "locality";
  static const addressCity = "city";
  static const addressDistrict = "district";
  static const addressState = "state";
  static const addressCountry = "country";
  static const addressPinCode = "pincode";
  static const addressWebSite = "website";

  static const createTableAddress = '$_createTable $tableAddress ('
      '$addressId $_integer $_primaryKey,'
      '$addressStreet $_text,'
      '$addressLocality $_text,'
      '$addressCity $_text,'
      '$addressDistrict $_text,'
      '$addressState $_text,'
      '$addressCountry $_text,'
      '$addressPinCode $_integer,'
      '$addressWebSite $_text)';

  ///Table Phone Numbers
  static const tablePhoneNumbers = 'phone_numbers';
  static const phoneNumbersId = "id";
  static const phoneNumber = "phone_number";

  static const createTablePhoneNumbers = '$_createTable $tablePhoneNumbers ('
      '$phoneNumbersId $_integer $_primaryKey,'
      '$phoneNumber $_text)';

  ///Table Email Addresses
  static const tableEmailAddresses = 'email_addresses';
  static const emailAddressesId = 'id';
  static const emailAddress = 'address';

  static const createTableEmailAddresses =
      '$_createTable $tableEmailAddresses ('
      '$emailAddressesId $_integer $_primaryKey,'
      '$emailAddress $_text'
      ')';

  ///Table Users
  static const tableUsers = 'users';
  static const userId = 'id';
  static const userEmailAddress = 'userEmail';
  static const userName = 'userName';
  static const userPhoneNumber = 'userPhoneNumber';
  static const userProfileImagePath = 'userProfileImagePath';
  static const emailVerificationStatus = 'emailVerificationStatus';

  static const createTableUsers =
      '$_createTable $tableUsers ('
      '$userId $_integer $_primaryKey,'
      '$userName $_text,'
      '$userEmailAddress $_text,'
      '$userPhoneNumber $_text,'
      '$userProfileImagePath $_text,'
      '$emailVerificationStatus $_integer'
      ')';
  ///Table UsersJsonData
  static const tableUsersJson = 'usersJson';
  static const userJsonId = 'id';
  static const userJsonData = 'userJsonData';

  static const createTableUsersJson =
      '$_createTable $tableUsersJson ('
      '$userJsonId $_integer $_primaryKey,'
      '$userJsonData $_text,'
      ')';

  ///Table Social Profiles
  static const tableSocialProfiles = 'social_profiles';
  static const socialProfilesId = 'id';
  static const socialProfilesType = 'type';
  static const socialProfilesUrl = 'url';

  static const createTableSocialProfiles =
      '$_createTable $tableSocialProfiles ('
      '$socialProfilesId $_integer $_primaryKey,'
      '$socialProfilesType $_integer,'
      '$socialProfilesUrl $_text)';
}
