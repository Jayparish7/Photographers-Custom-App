class PageConstants {
  static const GALLERY = 1;
  static const EVENT_LIST = 2;
  static const PROFILE = 3;
  static const PHOTO_SELECTION_LIST = 4;
  static const PHOTO_SELECTION = 5;
  static const EVENT_INFO = 6;
  static const EVENT_ALBUM = 7;
  static const ALBUM_PAGE_VIEW = 8;
  static const SAMPLE_IMAGE_MERGE = 9;
  static const DOWNLOAD_IMAGE_FILE_FOR_EVENTS = 10;
  static const AUDIO = 11;
  static const ALBUM_IMAGE_API = 12;

  // static const ERROR_IN_TRUE_CALLER = "1";
  static const ERROR_403_WHILE_IMAGE_DOWNLOAD = "2"; // image
  static const ERROR_FAILED_FROM_IMAGE_RESPONSE =
      "3"; // album/images => status = "failed"
  static const ERROR_403_WHILE_FILE_DOWNLOAD =
      "4"; // event cover image, music, profile image
  static const ERROR_FAILED_FROM_FILE_RESPONSE =
      "5"; // jvt-files/index => status = 2

  static const IMAGE_ID_DATA = "image_id";
  static const FILE_ID_DATA = "file_id";
  static const TYPE = "type";
}
