package `in`.photomall.photomall_flutter.api

/**
 * Created by Jovee-2 on 10-Jun-17.
 */

object Api {
    //General keys
    val KEY_USER_ID = "user_id"
    val KEY_APP_ID = "app_id"
    val KEY_EVENT_TYPE_NAME = "event_type_name"
    val KEY_EVENT_DATE = "event_date"
    val KEY_EVENT_DESCRIPTION = "event_description"
    val KEY_PASSWORD = "password"
    val KEY_STUDIO_ID = "Xc2df90Jk1snmaO"
    val KEY_EMAIL_ADDRESS = "email_address"
    val KEY_LAST_UPDATED_AT = "last_updated_at"
    val KEY_OTP_VERIFICATION = "otp"
    val KEY_ALBUM_TYPE = "album_type"
    val KEY_ALBUM_ID = "album_id"
    val KEY_ALBUM_URL = "photomall_event_random_id"
    val KEY_DEVICE_ID = "device_id"
    val SHARED_PREFERENCE_NAME = "FlutterSharedPreferences"
    val LAST_UPDATED_AT = "last_updated_at"

    val REGISTER_KEY_ANDROID_DEVICE_ID="device_id"
    val REGISTER_KEY_MANUFACTURER="device_manufacturer"
    val REGISTER_KEY_MODEL_NAME="device_model_name"
    val REGISTER_KEY_ANDROID_VERSION="android_version"
    val REGISTER_KEY_GOOGLE_ADVERTISING_ID = "google_advertising_id"

    val NOTIFICATION_TOKEN="notification_token"

    // Register Api & Api Key values

    val REGISTER_KEY_PHONE_NUMBER = "phone_number"
    val REGISTER_KEY_GENDER = "gender"
    val REGISTER_KEY_EMAIL = "email"
    val HASH_SIGNATURE = "otp_signature"

    val NAME = "name"

    //STUDIO ALBUM ID

    var STUDIO_ID: Int = 0
    val USER_NAME = "username"
    val PASSWORD = "password"
    val SCOPE = "scope"

    //val TRUE_PROFILE_NAME = "trueProfileName"

    //Login Api & Api Key values
    val LOGIN_KEY_MOBILE_NUMBER = "phone_number"
    val LOGIN_KEY_PASSWORD = "password"
    val KEY_CLIENT_ID: String = "client_id"
    val KEY_PHONE_NUMBER: String = "phone_number"

    var IS_CHANGE_GOOGLE_ADVERTISING_ID = "is_change_google_advertising_id"

    //Set Address Details
    val KEY_STREET_NAME = "street"
    val KEY_LOCALITY_NAME = "locality"
    val KEY_CITY_NAME = "city"
    val KEY_DISTRICT_NAME = "district"
    val KEY_STATE_NAME = "state"
    val KEY_COUNTRY_NAME = "country"
    val KEY_PINCODE = "pincode"
    val KEY_CLIENT_SECRET = "client_secret"
    val GRANT_TYPE = "grant_type"
    val REFRESH_TOKEN = "refresh_token"
    val APP_VERSION_CODE = "app_version"

    var FIRST_NAME = "first_name"
    var LAST_NAME = "last_name"
    var GENDER = "gender"
    var EMAIL = "email"
    var PHONE_NUMBER = "phone_number"
    var PROFILE = "profile_image_url"

    var IS_PHONE_NUMBER = "isPhoneNumber"

    var SEND_SMS = "send_sms"
    //var TRUE_CALLER_SMS = "true_caller_sms"

    // Change Password
    const val OLD_PASSWORD = "old_password"
    const val NEW_PASSWORD = "new_password"
    const val REGISTER_KEY_COUNTRY_CODE_ID: String = "country_code_id"

    const val EVENT_TYPE_ID = "category_id"
    const val DATE = "date"
    const val START_TIME = "start_time"
    const val END_TIME = "end_time"
    const val LOCATION = "location"

    const val COUNTRY_CODE_ID = "country_code_id"

    const val PRE_DESIGNED_ALBUMS_COUNT = "pre_designed_albums_count"
    const val COMPLETED_ALBUMS_COUNT = "completed_albums_count"

    const val ALBUM_VIEW_ALLOWANCE_COUNT:Int=5

    const val EVENT_ID = "event_id"

    const val EVENT_OR_ALBUM_ID="id"

    const val PAGE_STATUS = "page_status"

    const val KEY_RANDOM_URL = "random_url"

    const val TYPE = "type"

    ////////////////////////****************** Keys of intents and worker data //////////////////////////////

    const val UPDATE_EVENT_DETAILS_WORKER_OUTPUT_DATA="update_event"

    const val UPDATE_ALBUM_WORKER_OUTPUT_DATA="update_album"

    const val UPDATE_IMAGES_WORKER_OUTPUT_DATA="update_image"

    const val UPDATE_OR_DELETE_EVENTS_LIST ="update_del_events"

    //const val UPDATE_ALBUM_WORKER_OUTPUT_DATA="update_image"

    const val INSUFFICIENT_STORAGE="storage"

    const val TYPE_OF_NOTIFICATION_DATA="type"

    const val CONTENT_TYPE_DATA ="content_type"

    const val EVENT_NAME_DATA="event_name"

    const val IMAGE_ID_DATA="image_id"

    const val USER_RANDOM_ID = "user_random_id"

    const val IS_COME_FROM_GALLERY = "isComeFromGallery"

    const val IS_COME_FROM_BOOK_ME_BEFORE_LOGIN = "isComeFromBookMeBeforeLogin"

    const val FILE_ID_DATA="file_id"

}

