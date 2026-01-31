package `in`.photomall.photomall_flutter.database

/**
 * Created by Jovee-2 on 16-Jul-17.
 */

object DBStatics {
    
    /*********************************** Table Events ******************************************/
    
    const val OPtableEvents = "events"
    const val OPeventCode = "code"
    const val OPeventName = "name"
    const val OPeventCategoryName = "category_name"
    const val OPeventPublished = "published"
    const val OPeventType = "type" // 1 -> User event, 2 -> Studio Event, 3 -> Gallery Event
    const val OPeventLoginRequired = "login_required"
    const val OPeventNewlyAdded = "newly_added"
    const val OPeventArchived = "archived";
    const val OPeventOwnedByUser = "owned_by_user"

    /*********************************** Table Albums ******************************************/
    
    const val OPtableAlbums = "albums"
    const val OPalbumCode = "code"
    const val OPalbumEventCode = "event_code"
    const val OPalbumName = "name"
    const val OPalbumType = "type" //1-Photo Selection,2-e-Photobook,4- Invitation 5-Photo Album
    const val OPalbumSize = "size"
    const val OPalbumPublished = "published"
    //const val OPalbumLastUpdatedAt = "last_updated_at"
    const val OPalbumPriorityScore = "priorityScore"
    const val OPalbumOrders = "orders"
    const val OPalbumCoverImage = "cover_image"
    const val OPalbumMusic = "music"

    /*********************************** Table Orders ******************************************/
    
    /*const val OPtableOrders = "orders";
    const val OPorderCode = "code"
    const val OPorderAlbumCode = "album_code"
    const val OPorderPriority = "priority"
    const val OPorderImageType = "image_type"
    const val OPorderLastUpdatedAt = "last_updated_at"*/


    /****************************** Table File Connectors **************************************/
    
    const val OPtableJvtFileConnectors = "jvt_file_connectors"
    const val OPjvtFileConnectorCode = "code"
    const val OPjvtFileConnectorAbleCode = "able_code"
    const val OPjvtFileConnectorAbleType = "able_type"
    const val OPjvtFileConnectorTag = "tag"
    const val OPjvtFileConnectorJvtFileCode = "jvt_file_code"

    /************************************ Table Files ******************************************/

    const val OPtableJvtFiles = "jvt_files"
    const val OPjvtFileCode = "code"
    const val OPjvtFileName = "name"
    const val OPjvtFileMode = "mode" //0->public  1-> private
    const val OPjvtFileExtension = "extension"
    const val OPjvtFileDownloaded = "downloaded"
    const val OPjvtFileSize = "size"
    const val OPjvtFileAttempt = "attempt"
    const val OPjvtFilePriority = "priority"


    


    /*///Table Images
    const val tableImages = "images"
        const val imageId = "image_id"
    //either album id,photo selection id, event id, user id
    const val referenceId = "reference_id"
    const val imageName = "name"
    const val imageOriginalUrl = "original_url"
    const val imageThumbUrl = "thumb_url"
    const val imageThumbDownloadStatus = "thumb_image_download_status"
    const val imageOriginalDownloadStatus = "original_image_download_status"
    const val imageSize = "image_size"
    // 0->event, 1->completed album, 2->photo selection, 3->invitation, 4->profile
    const val imageType = "image_type"
    const val imageAccessType = "image_access_type"*/



    ///Table Completed Album Images
    const val tableCompletedAlbumImages = "completed_album_images"
    const val completedAlbumImageID = "image_id"
    const val completedAlbumID = "completed_album_id"
    const val completedAlbumImageOrder = "completed_album_images_order"

    
    ///Table Albums -> common table for completed album & photo selection
    const val tableAlbums = "albums"
    const val albumID = "album_id"
    const val eventID = "event_id"
    const val albumName = "album_name"
    const val albumCoverImageID = "cover_image_id"
    //1-Pre-designed album,2-Completed album,3-Studio Gallery,4- Invitation,5-demo preDesign
    const val albumType = "album_type"
    const val albumSize = "album_size"
    const val albumLastUpdatedAt = "last_updated_at"


    /// Table Events
    const val tableEvents = "events"
    const val eventsId = "id"
    const val eventName = "event_name"
    const val eventCoverImageId = "cover_image_id"
    const val eventCategoryName = "event_category_name"
    const val eventType = "event_type" // 1 -> User event, 2 -> Studio Event, 3 -> Gallery Event
    const val eventKey = "event_key"
    const val eventLastUpdatedAt = "last_updated_at"
    const val eventStudioId = "events_studio_id"
    const val eventIsSharableOrNot = "events_is_sharable"
    const val eventTotalViewCount = "total_view_count"
    const val eventAlreadyViewedCount = "already_viewed_count"
    const val eventDownloadAfterOrBeforeLogin = "download_after_or_before_login" // If user add event after login, set value 1 otherwise 0
    const val eventNewTagVisible = "events_visible_status" // If new event occur set value 1 otherwise 0
    const val eventDeleteStatus = "events_delete_status"
    const val eventPhotoSelectionStatus = "photo_selection_status"


    ///Table Completed Album Details
    const val tableCompletedAlbumDetails = "completed_album_details"
    const val completedAlbumDetailsID = "completed_album_id"
    const val completedAlbumDetailsOrientation = "completed_album_orientation"
    const val completedAlbumDetailsMusic = "completed_album_music"
    const val completedAlbumDetailsRatio = "completed_album_ratio"


    const val TABLE_STUDIO_RANDOM_URL = "studio_random_url"
    const val STUDIO_ID = "id"
    const val STUDIO_EVENT_ID = "event_id"
    const val STUDIO_RANDOM_URL = "random_url"


    const val TABLE_ALBUM_MUSICS = "album_musics"
    const val ALBUM_MUSIC_ID = "music_id"
    const val ALBUM_MUSIC_ALBUM_ID = "album_id"
    const val ALBUM_MUSIC_NAME = "name"
    const val ALBUM_MUSIC_EXTENSION = "extension"
    const val ALBUM_MUSIC_URL = "url"
    const val ALBUM_MUSIC_DOWNLOAD_STATUS = "download_status"
    const val ALBUM_MUSIC_SIZE = "size"
    const val ALBUM_MUSIC_ACCESS_TYPE = "access_type" // 0 -> Private, 1 -> Public
    

}


