package `in`.photomall.photomall_flutter.api

object AppConst {

    const val PHOTOMALL_API_VERSION = "v16"

    const val STUDIO_API_VERSION = "v16" //06-07-l19

    const val IS_LOG_ENABLED = false

    const val DB_VERSION = 37  // OLD Db version 28 update DB Version 29 date 06-09-2019    36

    const val ROOM_DB_VERSION = 4 // Need to check room db version in setLastUpdatedValueOnRoomDbUpgrade in gallery fragment

    var INVITATION_IMAGES = "invitaionImages"

    var INVITATION_NAME = "invitationName"

    const val GOOGLE_YOUTUBE_API_KEY = "AIzaSyAVypfBBf_R sBpPDvKgzEtIAsVt0LlEBgQ"

    const val SHARE_ALBUM_LINK = /*"https://photomall.in/show-album/"*/"https://ptml.in"

    const val PLAY_STORE_LINK_1 = "market://details?id="

    const val PLAY_STORE_LINK_2 = "https://play.google.com/store/apps/details?id="

    var DISABLE_OR_ENABLE_CURL_ACTIVITY_CARD = true

    var showAppUpdatePopup = false

    var STORAGE_URL = "https://jvtpm.sgp1.digitaloceanspaces.com/"

    var PROFILE_IMAGE_URL = "https://${CommonConst.IP_ADDRESS}/storage/images/profile/"

    var IMAGE_DOWNLOAD_URL = "http://photomall.in/storage/images/albumPhotos"

    var ABOUT_US_WEB_VIEW_URL = "https://${CommonConst.IP_ADDRESS}/api/${PHOTOMALL_API_VERSION}/photomall/about-us"

    //"https://jvtpm.sgp1.digitaloceanspaces.com/euwfzm95/171/audio/App-sample-studio-event-M15"
}