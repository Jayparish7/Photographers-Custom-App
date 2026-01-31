package `in`.photomall.photomall_flutter.roomDatabase

//import android.database.Cursor
//import androidx.lifecycle.LiveData
//import androidx.paging.DataSource
//import androidx.room.*
//import com.photomall.photoalbum.photomallUser.model.apiAdapter.GalleryVideos
//import com.photomall.photoalbum.photomallUser.model.roomDatabaseModels.*
//import com.photomall.photoalbum.photomallUser.model.uiAdapter.AlbumImageDataModel
//import com.photomall.photoalbum.photomallUser.model.uiAdapter.GalleryParentCatagoryAlbumList
//
//
//@Dao
//interface PhotomallDao {
//
//
//    /********************** Pre-designed Album and its Images **********************/
//
//    @Insert(onConflict = OnConflictStrategy.REPLACE)
//    fun insertPdAlbum(vararg users: PreDesignedAlbums)
//
//    @Insert(onConflict = OnConflictStrategy.REPLACE)
//    fun insertPdAlbumImages(vararg users: PreDesignedAlbumImages)
//
//    @Update(onConflict = OnConflictStrategy.REPLACE)
//    fun updatePdAlbumImages(vararg users: PreDesignedAlbumImages)
//
//    @Query("SELECT p_updated_at FROM p_albums WHERE p_albums_id IN (:albumId)")
//    fun getPredesignedAlbumLastUpdatedAt(albumId: Int): Int
//
//    @Query("SELECT * FROM p_albums WHERE p_albums_id = :albumId")
//    fun getPDAlbum(albumId: Int): PreDesignedAlbums
//
//    @Query("SELECT * FROM p_album_images WHERE p_image_id IN (:imageId)")
//    fun isAlreadyExistsInPdImages(imageId: Int): List<PreDesignedAlbumImages>
//
//    @Query("DELETE FROM p_album_images WHERE p_image_id = :imageId")
//    fun deleteFromPDAlbumImages(imageId: Int)
//
//    @Query("UPDATE p_albums SET p_album_name=:albumName, p_updated_at=:lastUpdatedAt, p_album_size=:albumSize WHERE p_albums_id = :albumId")
//    fun updatePreDesignedAlbum(albumId: Int, albumName: String, lastUpdatedAt: Long, albumSize: Long)
//
//    @Query("UPDATE p_albums SET status=:status WHERE p_albums_id = :albumId")
//    fun changePredesignedAlbumStatus(albumId: Int, status: Int)
//
//    @Query("SELECT * FROM p_albums WHERE predesigned_album_is_demo_or_not = 1")
//    fun getDemoPredesignedAlbum(): List<PreDesignedAlbums>
//
//    @Query("SELECT * FROM p_album_images INNER JOIN p_albums ON p_album_images.p_image_id = p_albums.p_cover_image_id WHERE p_album_images.p_original = 0")
//    fun viewPredesignedAlbumsPageDownloadableImages(): List<PreDesignedAlbumImages>
//
//    @Query("SELECT * FROM p_albums WHERE p_album_type = :albumType AND deleted_status = :deletedStatus AND predesigned_album_is_demo_or_not = :demoOrNot")
//    fun getPredesignedAlbums(albumType: Int, deletedStatus: Int, demoOrNot: Int): List<PreDesignedAlbums>
//
//    @Query("SELECT * FROM p_albums WHERE predesigned_album_is_demo_or_not = :demoOrNot")
//    fun getDemoPredesignedAlbums(demoOrNot: Int): List<PreDesignedAlbums>
//
//    @Query("SELECT p_image FROM p_album_images WHERE p_image_id = :imageId")
//    fun getPredesignedImageUrlUsingId(imageId: Int): String
//
//    @Query("SELECT * FROM p_album_images WHERE p_image_id = :imageId")
//    fun getPredesignedImageDetailsUsingId(imageId: Int): List<PreDesignedAlbumImages>
//
//    @Query("SELECT p_image_extension FROM p_album_images WHERE p_image_id = :imageId")
//    fun getPredesignedImageUrlExtensionUsingId(imageId: Int): String
//
//    @Query("UPDATE p_albums SET visible_status=:status WHERE p_albums_id = :albumId")
//    fun upDatePredesignedVisibleStatus(albumId: Int, status: Int)
//
//    @Query("UPDATE p_album_images SET original_url = :originalUrl, thumb_url = :thumbUrl WHERE p_image_id = :imageId")
//    fun insertRefreshedPredesignedImageUrl(imageId: Int, originalUrl: String, thumbUrl: String)
//
//    @Query("SELECT status FROM p_albums WHERE p_albums_id = :albumId")
//    fun getPredesignedAlbumStatus(albumId: Int): Int
//
//    @Query("SELECT p_updated_at FROM p_albums WHERE p_albums_id = :albumId")
//    fun getLastUpdateAtInPreDesignedAlbum(albumId: Int): Int
//
//    @Query("SELECT * FROM p_album_images WHERE p_album_id = :albumId AND status = :imageStatus")
//    fun getSelectionProcessAlbumDetails(albumId: Int, imageStatus: Int): List<PreDesignedAlbumImages>
//
//    @Query("SELECT p_image FROM p_album_images WHERE p_album_id = :albumId AND p_original = 0")
//    fun getSinglePredesignedAlbumOriginalPhotoUrl(albumId: Int): List<String>
//
//    @Query("SELECT * FROM p_album_images WHERE p_album_id = :albumId")
//    fun getAllPredesignedAlbumImages(albumId: Int): List<PreDesignedAlbumImages>
//
//    /*@Query("SELECT * FROM p_album_images WHERE p_album_id = :albumId AND p_original = 0")
//    fun totalPredesignedOriginalImagesUnDownloaded(albumId: Int): List<PreDesignedAlbumImages>*/
//
//    @Query("SELECT * FROM p_album_images WHERE p_original = 1 AND p_image = :image")
//    fun isSinglePredesignedOriginalImageDownload(image: String): List<PreDesignedAlbumImages>
//
//    @Query("UPDATE p_albums SET visible_status=:status WHERE p_albums_id = :albumId")
//    fun addOriginalInfo(albumId: Int, status: Int)
//
//    @Query("SELECT p_image_id FROM p_album_images WHERE p_image_id = :imageId")
//    fun hasImageInPredesignedAlbumImages(imageId: Int): List<Int>
//
//    @Query("SELECT * FROM p_album_images WHERE p_original = 0 AND p_album_id = :albumId")
//    fun totalPredesignedOriginalImagesUnDownloadedForGenerateJson(albumId: Int): List<PreDesignedAlbumImages>
//
//    @Query("SELECT original_url FROM p_album_images WHERE p_image = :image")
//    fun getPredesignedAlbumOriginalImageUrl(image: String): String
//
//    @Query("SELECT * FROM p_album_images WHERE p_image = :image")
//    fun getPredesignedAlbumImageId(image: String): PreDesignedAlbumImages
//
//    @Query("UPDATE p_album_images SET p_original = :t WHERE p_image = :image")
//    fun addPredesignedOriginalInfo(t: Int, image: String)
//
//    /*@get:Query("SELECT * FROM p_album_images WHERE p_album_id = :")
//    val all: DataSource.Factory<Int, PreDesignedAlbumImages>*/
//
//    @Query("SELECT * FROM p_album_images WHERE p_album_id = :albumId AND status = :imageStatus")
//    fun getPdImageSource(albumId: Int, imageStatus: Int): DataSource.Factory<Int, PreDesignedAlbumImages>
//
//    @Query("SELECT * FROM p_album_images WHERE p_album_id = :albumId AND status = :imageStatus")
//    fun getPdImageSource1(albumId: Int, imageStatus: Int): List<PreDesignedAlbumImages>
//
//    /* @Query("SELECT * FROM p_album_images WHERE p_album_id = :albumId AND update_status = :imageStatus LIMIT 10")
//     fun getPdImageSource2(albumId: Int, imageStatus: Int): LiveData<List<PreDesignedAlbumImages>>*/
//
//    @Query("SELECT * FROM p_album_images WHERE p_album_id = :albumId AND status = :imageStatus LIMIT 10")
//    fun getPdImageSource2(albumId: Int, imageStatus: Int): List<PreDesignedAlbumImages>
//
//    /*@Query("SELECT * FROM p_album_images WHERE p_album_id = :albumId AND update_status = :imageStatus LIMIT 10 OFFSET (:page * 10)")
//    fun getNext10PdImages(albumId: Int, imageStatus: Int, page: Int): LiveData<List<PreDesignedAlbumImages>>*/
//
//    @Query("SELECT * FROM p_album_images WHERE p_album_id = :albumId AND status = :imageStatus LIMIT 10 OFFSET (:page * 10)")
//    fun getNext10PdImages(albumId: Int, imageStatus: Int, page: Int): List<PreDesignedAlbumImages>
//
//    @Query("UPDATE p_album_images SET status = :imageStatus WHERE p_image_id = :imageId")
//    fun moveToAnotherState(imageId: Int, imageStatus: Int)
//
//    @Query("SELECT * FROM p_album_images WHERE p_album_id = :albumId AND p_original = 0 AND status = :imageStatus")
//    fun getPDImages(albumId: Int, imageStatus: Int): List<PreDesignedAlbumImages>
//
//    @Query("SELECT * FROM p_album_images WHERE p_album_id = :albumId AND status = :imageStatus")
//    fun getSelectedPDImages(albumId: Int, imageStatus: Int): List<PreDesignedAlbumImages>
//
//    @Query("SELECT * FROM p_album_images WHERE p_album_id = :albumId AND original_url = :originalUrl AND status = :imageStatus")
//    fun getPDImagesForOnlyShow(albumId: Int, imageStatus: Int, originalUrl: String = ""): List<PreDesignedAlbumImages>
//
//    /*@Query("SELECT * FROM p_album_images WHERE p_album_id = :albumId AND p_original = 0 AND status = :imageStatus AND original_url IS NULL")
//    fun getPDImages(albumId: Int, imageStatus: Int): List<PreDesignedAlbumImages>*/
//
//    @Query("UPDATE p_album_images SET original_url = :originalUrl WHERE p_album_id = :albumId AND status = :imageStatus")
//    fun setPDImagesOriginalUrlToNull(albumId: Int, imageStatus: Int, originalUrl: String = "")
//
//    @Query("SELECT * FROM p_album_images WHERE p_album_id = :albumId AND p_original = 0 AND status = :imageStatus LIMIT 3")
//    fun getFirstWaitPDImages(albumId: Int, imageStatus: Int): List<PreDesignedAlbumImages>
//
//    @Query("SELECT * FROM p_album_images WHERE p_album_id = :albumId")
//    fun getAllPDImagesInAlbum(albumId: Int): List<PreDesignedAlbumImages>
//
//    @Query("SELECT * FROM p_album_images WHERE p_album_id = :albumId AND p_original = 0 AND status = :imageStatus AND original_url IS NOT NULL")
//    fun getOriginalUrlInPDImages(albumId: Int, imageStatus: Int): LiveData<List<PreDesignedAlbumImages>>
//
//    @Query("SELECT * FROM p_album_images WHERE p_image_id = :imageId")
//    fun getPDImage(imageId: Int): PreDesignedAlbumImages
//
//    @Query("SELECT * FROM p_album_images WHERE p_original = :downloadStatus AND p_album_id = :albumId")
//    fun checkDownloadedOrUnDownloaded(albumId: Int, downloadStatus: Int): List<PreDesignedAlbumImages> // downloadStatus -> 0 or 1
//
//    @Query("SELECT * FROM p_album_images WHERE p_album_id = :albumId AND status = :imageStatus AND p_original = :downloadStatus")
//    fun getUnDownloadedPdImages(albumId: Int, imageStatus: Int, downloadStatus: Int): List<PreDesignedAlbumImages>
//
//    @Query("DELETE FROM p_albums WHERE p_cover_image_id = :imageId")
//    fun deletePdAlbumUsingCoverImageId(imageId: Int)
//
//    /*@Query("SELECT * FROM p_album_images")
//    fun getAllPDImages(): List<PreDesignedAlbumImages>*/
//
//    @Query("SELECT * FROM p_album_images pai INNER JOIN p_albums pa ON pai.p_album_id = pa.p_albums_id WHERE pa.predesigned_album_is_demo_or_not = :userPredesignedAlbum")
//    fun getAllPDImages(userPredesignedAlbum: Int): List<PreDesignedAlbumImages>
//
//    @Query("DELETE FROM p_albums WHERE p_album_type = :albumType")
//    fun deletePdAlbums(albumType: Int)
//
//    /*@Query("DELETE FROM p_albums WHERE predesigned_album_is_demo_or_not = :userPredesignedAlbum")
//    fun deletePdAlbums(userPredesignedAlbum: Int)*/
//
//    @Query("DELETE FROM p_albums WHERE p_albums_id = :albumId")
//    fun deletePdAlbum(albumId: Int)
//
//    /*@Query("DELETE FROM p_album_images")
//    fun deletePdAlbumImages()*/
//
//    //@Query("DELETE FROM p_album_images pai INNER JOIN p_albums pa ON pai.p_album_id = pa.p_albums_id WHERE pa.predesigned_album_is_demo_or_not = :userPredesignedAlbum")
//    /*@Query("DELETE FROM p_album_images WHERE p_album_id = (SELECT p_albums_id FROM p_albums WHERE predesigned_album_is_demo_or_not = :userPredesignedAlbum)")
//    fun deletePdAlbumImages(userPredesignedAlbum: Int)*/
//
//    @Query("DELETE FROM p_album_images WHERE p_album_id IN (SELECT p_albums_id FROM p_albums WHERE p_album_type = :albumType)")
//    fun deletePdAlbumImages(albumType: Int)
//
//    @Query("UPDATE p_album_images SET p_image_importance_level = :importanceLevel WHERE p_image_id = :imageId")
//    fun modifyImportanceLevelOfImage(imageId: Int, importanceLevel: Int)
//
//    @Query("SELECT p_image_importance_level FROM p_album_images WHERE p_image_id = :imageId")
//    fun getImportanceLevelOfImage(imageId: Int): Int
//
//    /************************* Recent Edited Pre-designed Images *************************/
//
//    @Insert(onConflict = OnConflictStrategy.REPLACE)
//    fun insertRecentPdImages(vararg users: RecentEditedPdImages)
//
//    @Query("SELECT * FROM recent_edited_pd_images WHERE p_album_id = :albumId")
//    fun getRecentEditedPDImages(albumId: Int): List<RecentEditedPdImages>
//
//    @Query("DELETE FROM recent_edited_pd_images WHERE p_album_id = :albumId")
//    fun deleteRecentEditedPdImages(albumId: Int)
//
//    @Query("DELETE FROM recent_edited_pd_images")
//    fun deleteAllRecentEditedPdImages()
//
//    /****************** Recent Edited Pre-designed Album Images Importance level ******************/
//
//    @Insert(onConflict = OnConflictStrategy.REPLACE)
//    fun insertRecentModifyImportanceLevelOfImage(vararg users: RecentEditedPdImagesImportanceLevel)
//
//    @Query("SELECT * FROM recent_edited_pd_images_importance_level WHERE p_album_id = :albumId")
//    fun getRecentModifyImportanceLevelOfImage(albumId: Int): List<RecentEditedPdImagesImportanceLevel>
//
//    @Query("DELETE FROM recent_edited_pd_images_importance_level WHERE p_album_id = :albumId")
//    fun deleteRecentModifyImportanceLevelOfImages(albumId: Int)
//
//    @Query("DELETE FROM recent_edited_pd_images_importance_level")
//    fun deleteAllRecentModifyImportanceLevelOfImages()
//
//    /************************* Pre-designed Album Images Comments *************************/
//
//    @Query("SELECT comment FROM p_album_images_comments WHERE id = :imageId")
//    fun getCommentOfImage(imageId: Int): String
//
//    @Query("SELECT * FROM p_album_images_comments WHERE p_album_id = :albumId AND is_recently_modify_or_not = 1")
//    fun getRecentlyModifyCommentsOfSingleAlbum(albumId: Int): List<PreDesignedAlbumImagesComments>
//
//    @Insert(onConflict = OnConflictStrategy.REPLACE)
//    fun insertCommentOfImage(comment: PreDesignedAlbumImagesComments)
//
//    @Query("DELETE FROM p_album_images_comments WHERE id = :imageId")
//    fun deleteSingleCommentsOfImage(imageId: Int)
//
//    @Query("DELETE FROM p_album_images_comments")
//    fun deleteAllCommentsOfImages()
//
//    @Query("UPDATE p_album_images_comments SET is_recently_modify_or_not = 0 WHERE p_album_id = :albumId")
//    fun updateRecentEditedComments(albumId: Int)
//
//    /*******************************Event- studio gallery queries***************************************/
//
//    @Insert(onConflict = OnConflictStrategy.REPLACE)
//    fun insertIntoEventsTable(vararg events: Events)
//
//    @Query("SELECT last_updated_at FROM events")
//    fun getLastUpdatedAtForEvent(): Long
//
//    @Query("SELECT id,event_name FROM events")
//    fun galleryEventCatagoryList(): List<GalleryParentCatagoryAlbumList>
//
//    //@Query("SELECT albums.album_id,albums.event_id,albums.album_name,albums.cover_image_id, albums.album_type,albums.music,albums.last_updated_at,albums.album_orientation_type,albums.number_of_half_images,albums.album_image_size,albums.album_size,album_images.image_extension,album_images.name FROM albums INNER JOIN album_images ON album_images.album_id=albums.album_id WHERE albums.event_id =:eventId ")
//    //@Query("SELECT albums.album_id,albums.event_id,albums.album_name,albums.cover_image_id, albums.album_type,albums.music_id, albums.last_updated_at,albums.album_orientation_type,albums.number_of_half_images,albums.album_image_size,albums.album_size,album_images.image_extension FROM albums INNER JOIN album_images ON album_images.album_id=albums.album_id WHERE albums.event_id =:eventId ")
//    //fun getGalleryChildAlbumList(eventId: Int): List<GalleryChildAlbumListModel>
//
//    @Insert(onConflict = OnConflictStrategy.REPLACE)
//    fun insertIntoAlbumsTable(vararg albums: Albums)
//
//    @Insert(onConflict = OnConflictStrategy.REPLACE)
//    fun insertIntoAlbumsImagesTable(vararg albumImages: AlbumImages)
//
//    @Insert(onConflict = OnConflictStrategy.REPLACE)
//    fun insertIntoAlbumsMusicsTable(vararg albumImages: AlbumMusics)
//
//    @Query("UPDATE albums SET music_id = :musicId WHERE album_id = :albumId")
//    fun updateAlbumMusicIdInAlbums(musicId: Int, albumId: Int)
//
//    @Query("SELECT * FROM album_musics WHERE music_id = :musicId")
//    fun getAlbumMusic(musicId: Int): List<AlbumMusics>
//
//    @Query("SELECT * FROM album_musics WHERE music_id = :musicId")
//    fun getAlbumMusicName(musicId: Int): AlbumMusics?
//
//    @Query("DELETE FROM album_musics WHERE music_id = :musicId")
//    fun deleteFromAlbumMusics(musicId: Int)
//
//    @Query("SELECT music_id FROM albums WHERE album_id = :albumId")
//    fun getAlbumMusicId(albumId: Int): Int
//
//    /*@Query("SELECT music_id FROM albums WHERE album_id = :albumId")
//    fun getAlbumMusic(albumId: Int): Int*/
//
//    @Query("DELETE FROM albums WHERE album_id = :albumId")
//    fun deleteFromAlbumsTable(albumId: Int)
//
//    @Query("DELETE FROM album_images WHERE image_id = :imageId")
//    fun deleteImageFromAlbumImagesTable(imageId: Int)
//
//    @Query("DELETE FROM album_images WHERE album_id = :albumId")
//    fun deleteAlbumFromAlbumImagesTable(albumId: Int)
//
//    @Query("SELECT image,image_extension FROM album_images WHERE album_id=:albumId")
//    fun deleteAlbumImages(albumId: Int): List<AlbumImageDataModel>
//
//    @Insert(onConflict = OnConflictStrategy.REPLACE)
//    fun insertIntoAlbumsVideosTable(vararg videos: Videos)
//
//    @Query("DELETE FROM videos WHERE video_id =:id")
//    fun deleteGalleryVideo(id: Int)
//
//    @Query("DELETE FROM videos WHERE video_event_id =:eventId")
//    fun deleteAllGalleryVideo(eventId: Int)
//
//    @Query("DELETE FROM albums WHERE event_id =:eventId")
//    fun deleteAllGalleryAlbum(eventId: Int)
//
//    @Query("SELECT * FROM events WHERE event_type = :albumType")
//    fun getGalleryEvents(albumType: Int): List<Events>
//
//    @Query("SELECT * FROM albums WHERE event_id = :eventId")
//    fun getGalleryEventAlbums(eventId: Int): List<Albums>
//
//    @Query("SELECT * FROM videos WHERE video_event_id = :eventId")
//    fun getGalleryEventVideos(eventId: Int): List<Videos>
//
//    @Query("SELECT * FROM album_images WHERE album_id = :albumId")
//    fun getGalleryAlbumImages(albumId: Int): List<AlbumImages>
//
//    @Query("DELETE FROM events WHERE id=:id")
//    fun deleteGalleryEvent(id: Int)
//
//    @Query("SELECT id, event_name FROM events WHERE event_type = :albumType AND publish_status = 1")
//    fun getStudioGalleryAlbums(albumType: Int): LiveData<List<GalleryParentCatagoryAlbumList>>
//
//    @Query("SELECT id, event_name FROM events WHERE event_type = :albumType AND publish_status = 1")
//    fun getStudioGalleryAlbums1(albumType: Int): List<GalleryParentCatagoryAlbumList>
//
//    /*@Query("SELECT id, event_name FROM events WHERE event_type = :albumType AND id = (SELECT event_id FROM )")
//    fun getAvailableAlbumsInEvents(albumType: Int): List<GalleryParentCatagoryAlbumList>*/
//
//    /*@Query("SELECT video_name, video_url FROM videos WHERE video_event_id = (SELECT id FROM events WHERE event_type = :albumType)")
//    fun getStudioGalleryVideos(albumType: Int): LiveData<List<GalleryVideos>>*/
//
//    @Query("SELECT v.video_name, v.video_url FROM videos v INNER JOIN events e on v.video_event_id = e.id WHERE e.event_type = :albumType AND v.publish_status = 1")
//    fun getStudioGalleryVideos(albumType: Int): LiveData<List<GalleryVideos>>
//
//    @Query("SELECT v.video_name, v.video_url FROM videos v INNER JOIN events e on v.video_event_id = e.id WHERE e.event_type = :albumType AND v.publish_status = 1")
//    fun getStudioGalleryVideos1(albumType: Int):List<GalleryVideos>
//
//    /*@Query("SELECT album_id, event_id, album_name, cover_image_id, album_type, music, last_updated_at, album_orientation_type, number_of_half_images, album_image_size, album_size, image, image_extension FROM albums a, album_images ai WHERE a.cover_image_id = ai.image_id AND a.event_id = :eventInt")
//    fun getAlbumsForEvent(eventInt: Int): LiveData<List<GalleryChildAlbumListModel>>*/
//
//    /*@Query("SELECT album_id, event_id, album_name, cover_image_id, album_type, music, last_updated_at, album_orientation_type, number_of_half_images, album_image_size, album_size, image, image_extension FROM albums a, album_images ai WHERE a.cover_image_id = ai.image_id AND a.event_id = :eventInt")
//    fun getAlbumsForEvent(eventInt: Int): List<GalleryChildAlbumListModel>*/
//
//    @Query("SELECT * FROM albums WHERE event_id = :eventInt AND publish_status = 1")
//    fun getAlbumsForEvent1(eventInt: Int): List<Albums>
//
//    @Query("SELECT * FROM album_images WHERE image_id = :imageId")
//    fun getAlbumImage(imageId: Int): AlbumImages
//
//    @Query("SELECT * FROM album_images WHERE image = :image")
//    fun getAlbumImageId(image: String): AlbumImages
//
//    @Query("SELECT * FROM album_images ai, albums a WHERE ai.image_id = a.cover_image_id AND original = 0 AND a.publish_status = 1")
//    fun getUnDownloadedGalleryAlbumsCoverImages(): List<AlbumImages>
//
//    @Query("UPDATE album_images SET original = :t WHERE image = :image")
//    fun addAlbumsOriginalInfo(t: Int, image: String)
//
//    /*fun getAlbumStorageSize(albumId: Int): Int{
//        var df = dbWritable.query(DBStatics.TABLE_ALBUMS, arrayOf(DBStatics.ALBUMS_ALBUM_SIZE), DBStatics.ALBUMS_ID + "=?", arrayOf(albumId.toString()), null, null, null)
//        df.moveToFirst()
//        return df.getInt(df.getColumnIndex(DBStatics.ALBUMS_ALBUM_SIZE))
//    }*/
//
//    @Query("SELECT album_size FROM albums WHERE album_id=:albumId")
//    fun getAlbumStorageSize(albumId: Int): Int
//
//    /*fun isOriginalsDownload(albumId: Int): Boolean {
//        val df = dbWritable.query(DBStatics.TABLE_ALBUM_IMAGES, arrayOf(DBStatics.ALBUM_IMAGES_IMAGE), DBStatics.ALBUM_IMAGES_ORIGINAL + "=? AND " + DBStatics.ALBUM_ID + "=?", arrayOf(0.toString(), albumId.toString()), null, null, null, 1.toString()).count
//        return df <= 0
//    }*/
//
//    @Query("SELECT COUNT(image) FROM album_images WHERE original=0 AND album_id=:albumId")
//    fun isOriginalsDownload(albumId: Int): Boolean  // COUNT
//
//
//    /*fun getClickedAlbumImages(categoryId: Int): Cursor {
//        return dbWritable.query(DBStatics.TABLE_ALBUM_IMAGES, arrayOf(DBStatics.ALBUM_IMAGES_IMAGE, DBStatics.ALBUM_IMAGES_IMAGE_EXTENSION, DBStatics.ALBUM_IMAGES_NAME, DBStatics.ALBUM_IMAGES_LIST_ORDER), DBStatics.ALBUM_ID + "=?", arrayOf(categoryId.toString()), null, null, DBStatics.ALBUM_IMAGES_LIST_ORDER)
//    }*/
//
//    @Query("SELECT image,image_extension,list_order FROM album_images WHERE album_id=:albumId ORDER BY list_order")
//    fun getClickedAlbumImages(albumId: Int): List<ClickedAlbumImagesList> //count
//
//
//    /*fun getCountOfTotalAlbumPages(albumId: Int): Int {
//        return dbReadable.rawQuery("SELECT ${DBStatics.ALBUM_IMAGES_NAME} ,count(${DBStatics.ALBUM_IMAGES_LIST_ORDER}) FROM ${DBStatics.TABLE_ALBUM_IMAGES} where ${DBStatics.ALBUM_ID} = $albumId GROUP BY ${DBStatics.ALBUM_IMAGES_LIST_ORDER};", null).count
//    }*/
//
//    @Query("SELECT COUNT(list_order) FROM album_images WHERE album_id=:albumId GROUP BY list_order")
//    fun getCountOfTotalAlbumPages(albumId: Int): List<Int>
//
//
///*        fun getLastUpdatedAtInAlbum(albumId: Int): Int {
//            val df = dbWritable.query(DBStatics.TABLE_ALBUMS, arrayOf(DBStatics.ALBUMS_UPDATED_AT), DBStatics.ALBUMS_ID + "=?", arrayOf(albumId.toString()), null, null, null)
//            df.moveToFirst()
//            return df.getInt(df.getColumnIndex(DBStatics.ALBUMS_UPDATED_AT))
//        }*/
//
//    @Query("SELECT last_updated_at FROM albums WHERE album_id=:albumId")
//    fun getLastUpdatedAtInAlbum(albumId: Int): Int
//
//    /*  fun isAllImagesDownloaded(albumId: Int): Boolean {
//          val totalDownloadedImages = dbWritable.query(DBStatics.TABLE_ALBUM_IMAGES, arrayOf(DBStatics.ALBUM_ID), DBStatics.ALBUM_ID + "=? AND " + DBStatics.ALBUM_IMAGES_ORIGINAL + "=?", arrayOf(albumId.toString(), 1.toString()), null, null, null).count
//          val totalImages = dbWritable.query(DBStatics.TABLE_ALBUM_IMAGES, arrayOf(DBStatics.ALBUM_ID), DBStatics.ALBUM_ID + "=?", arrayOf(albumId.toString()), null, null, null).count
//          return totalDownloadedImages == totalImages
//      }
//*/
//    @Query("SELECT COUNT(album_id) FROM album_images WHERE album_id=:albumId AND original=1") // COUNT
//    fun totalDownloadedImages(albumId: Int): Int
//
//    @Query("SELECT COUNT(album_id) FROM album_images WHERE album_id=:albumId") //count merge totalDownloadedImages AND totalimages in isAllImagesDownloaded
//    fun totalImages(albumId: Int): Int
//
///*
//        fun isAllImagesDownloaded(albumId: Int): Boolean {
//            return (totalDownloadedImages(albumId) == totalImages(albumId))
//        }*/
//
//    /*fun isEligibleForViewAlbum(categoryId: Int): Boolean {
//        val sd = dbReadable.query(DBStatics.TABLE_ALBUM_IMAGES, arrayOf(DBStatics.ALBUM_IMAGES_IMAGE, DBStatics.ALBUM_IMAGES_IMAGE_EXTENSION), DBStatics.ALBUM_ID + "=? and " + DBStatics.ALBUM_IMAGES_ORIGINAL + "=?", arrayOf(categoryId.toString(), "1"), null, null, DBStatics.ALBUM_IMAGES_NAME).count
//        var df = !(sd == 2 || sd == 1)
//        DLog("DbHelper: ","isEligibleForViewAlbum() $df")
//        //return !(sd == 2 || sd == 1)
//        return df
//    }*/
//
//    @Query("SELECT image,image_extension FROM album_images WHERE album_id=:albumId AND original=1") //COUNT
//    fun isEligibleForViewAlbumCount(albumId: Int): List<EligibleForViewAlbum>
//
//    /*fun isEligibleForViewAlbum(albumId: Int): Boolean {
//        return !(isEligibleForViewAlbumCount(albumId).size == 2 || isEligibleForViewAlbumCount(albumId).size == 1)
//    }*/
//
//    /*fun insertRefreshedAlbumImagesAndEventCoverImageUrl(id: Int, originalUrl: String, thumbUrl: String) {
//        val contentValues = ContentValues()
//        contentValues.put(DBStatics.ALBUM_IMAGES_ORIGINAL_URL, originalUrl)
//        contentValues.put(DBStatics.ALBUM_IMAGES_THUMB_URL, thumbUrl)
//        dbWritable.update(DBStatics.TABLE_ALBUM_IMAGES, contentValues, DBStatics.ALBUM_IMAGES_ID + "=?", arrayOf(id.toString()))
//    }*/
//
//    @Query("UPDATE album_images SET original_url=:originalUrl,thumb_url=:thumbUrl WHERE image_id=:id")
//    fun insertRefreshedAlbumImagesAndEventCoverImageUrl(id: Int, originalUrl: String, thumbUrl: String)
//
//    /*fun deleteAlbumImagesAndEventCoverImage(id: Int) {
//        val db = this.writableDatabase
//        db.delete(DBStatics.TABLE_ALBUM_IMAGES, DBStatics.ALBUM_IMAGES_ID + "=?", arrayOf(id.toString()))
//    }*/
//
//    @Query("DELETE FROM album_images WHERE image_id=:id")
//    fun deleteAlbumImagesAndEventCoverImage(id: Int)
//
//    /*fun isOriginalsDownloadInAlbum(albumId: Int): Boolean {
//        val cursor = dbWritable.query(DBStatics.TABLE_ALBUM_IMAGES, arrayOf(DBStatics.ALBUM_ID), DBStatics.ALBUM_ID + "=? AND " + DBStatics.ALBUM_IMAGES_ORIGINAL + "=?", arrayOf(albumId.toString(), 0.toString()), null, null, null).count
//        return cursor == 0
//    }*/
//
//    @Query("SELECT COUNT(album_id) FROM album_images WHERE album_id=:albumId AND original=0") // COUNT
//    fun isOriginalsDownloadInAlbum(albumId: Int): Int
//
//    /*fun getSingleAlbumOriginalPhotoUrl(categoryId: Int): Cursor {
//        return dbReadable.query(DBStatics.TABLE_ALBUM_IMAGES, arrayOf(DBStatics.ALBUM_IMAGES_IMAGE, DBStatics.ALBUM_IMAGES_IMAGE_EXTENSION), DBStatics.ALBUM_ID + "=? and " + DBStatics.ALBUM_IMAGES_ORIGINAL + "=?", arrayOf(categoryId.toString(), "0"), null, null, DBStatics.ALBUM_IMAGES_NAME)
//    }*/
//
//    //@Query("SELECT image,image_extension FROM album_images WHERE album_id=:albumId AND original=0  ORDER BY name")
//    @Query("SELECT image,image_extension FROM album_images WHERE album_id=:albumId AND original=0")
//    fun getSingleAlbumOriginalPhotoUrl(albumId: Int): List<SingleAlbumOriginalPhotoUrl>
//
//
//    /*fun getSingleAlbumThumbPhotoUrl(categoryId: Int): Cursor {
//        return dbReadable.query(DBStatics.TABLE_ALBUM_IMAGES, arrayOf(DBStatics.ALBUM_IMAGES_IMAGE, DBStatics.ALBUM_IMAGES_IMAGE_EXTENSION, DBStatics.ALBUM_IMAGES_NAME), DBStatics.ALBUM_ID + "=? and " + DBStatics.ALBUM_IMAGES_THUMB + "=?", arrayOf(categoryId.toString(), "0"), null, null, DBStatics.ALBUM_IMAGES_LIST_ORDER)
//    }*/
//
//    @Query("SELECT image,image_extension FROM album_images WHERE album_id=:albumId AND original=0 ORDER BY list_order")
//    fun getSingleAlbumThumbPhotoUrl(albumId: Int): Cursor
//
//    /*fun getNumberOfHalfImagesInAlbum(albumId: Int): Int {
//        try {
//            var df = dbWritable.query(DBStatics.TABLE_ALBUMS, arrayOf(DBStatics.ALBUMS_ALBUM_NUMBER_OF_HALF_IMAGES), DBStatics.ALBUMS_ID + "=?", arrayOf(albumId.toString()), null, null, null)
//            df.moveToFirst()
//            return df.getInt(df.getColumnIndex(DBStatics.ALBUMS_ALBUM_NUMBER_OF_HALF_IMAGES))
//        } catch (e: Exception) {
//            return 0
//        }
//    }*/
//
//    @Query("SELECT number_of_half_images FROM albums WHERE album_id=:albumId")
//    fun getNumberOfHalfImagesInAlbum(albumId: Int): Int
//
//
//    /*fun isTemporaryUrlAvailable(categoryId: Int): Boolean {
//        var df = DbHelper.dbReadable.query(DBStatics.TABLE_ALBUM_IMAGES, arrayOf(DBStatics.ALBUM_IMAGES_ORIGINAL_URL), DBStatics.ALBUM_ID + "=? and " + DBStatics.ALBUM_IMAGES_ORIGINAL + "=?", arrayOf(categoryId.toString(), "0"), null, null, DBStatics.ALBUM_IMAGES_NAME)
//        var isNull = true
//        if(df.count != 0) {
//            df.moveToFirst()
//            do{
//                if(df.getString(df.getColumnIndex(DBStatics.ALBUM_IMAGES_ORIGINAL_URL)) == "0"){
//                    Others.DLog("DbHelper: ", "inside isTemporaryUrlAvailable if")
//                    isNull = false
//                }
//            }while (df.moveToNext())
//        }
//        return isNull
//    }*/
//
//    //@Query("SELECT original_url FROM album_images WHERE album_id=:albumId AND original=0 ORDER BY name")
//    @Query("SELECT original_url FROM album_images WHERE album_id=:albumId AND original=0")
//    fun temporaryUrlAvailableCount(albumId: Int): List<OriginalImagesCount>
//
//    //@Query("SELECT * FROM album_images WHERE album_id=:albumId AND original=0 ORDER BY name")
//    @Query("SELECT * FROM album_images WHERE album_id=:albumId AND original=0")
//    fun getAlbumImages(albumId: Int): List<AlbumImages>
//
//    @Query("UPDATE album_images SET original_url = :originalUrl WHERE image_id = :imageId")
//    fun updateAlbumImagesUrl(imageId: Int, originalUrl: String)
//
//    @Query("UPDATE album_musics SET download_status = :downloadStatus WHERE music_id = :musicId")
//    fun updateAlbumMusicDownloadStatus(musicId: Int,downloadStatus: Int)
//
//    /*fun isTemporaryUrlAvailable(albumId: Int):Boolean{
//        var isNull = true
//        val tempUrlCount=temporaryUrlAvailableCount(albumId)
//        if(tempUrlCount.size!=0){
//            tempUrlCount.forEach {
//                if(it.original_url == "0"){
//                    Others.DLog("DbHelper: ", "inside isTemporaryUrlAvailable if")
//                    isNull = false
//                }
//            }
//        }
//        return isNull
//    }
//*/
//
//
//    /*  val df = DbHelper.dbReadable.query(DBStatics.TABLE_ALBUM_IMAGES, arrayOf(DBStatics.ALBUM_IMAGES_ORIGINAL_URL), DBStatics.ALBUM_ID + "=? and " + DBStatics.ALBUM_IMAGES_ORIGINAL + "=?", arrayOf(categoryId.toString(), "0"), null, null, DBStatics.ALBUM_IMAGES_NAME)
//      var isNull = true
//      if(df.count != 0) {
//          df.moveToFirst()
//          do{
//              if(df.getString(df.getColumnIndex(DBStatics.ALBUM_IMAGES_ORIGINAL_URL)) == "0"){
//                  Others.DLog("DbHelper: ", "inside isTemporaryUrlAvailable if")
//                  isNull = false
//              }
//          }while (df.moveToNext())
//      }
//      return isNull*/
//
//
//    /* fun ifAlbumImageExistsOrNot(albumId: Int): Boolean {
//         try {
//             val df = DbHelper.dbWritable.query(DBStatics.TABLE_ALBUM_IMAGES, null, DBStatics.ALBUM_ID + "=?", arrayOf(albumId.toString()), null, null, null)
//
//             return df.count > 0
//
//         } catch (e: Exception) {
//             return false
//         }
//     }*/
//
//
//    @Query("SELECT COUNT(*) FROM album_images WHERE album_id=:albumId ")
//    fun ifAlbumImageExistsOrNotCount(albumId: Int): Int
//
//
//    /*fun totalAlbumsViewUndownloadedCoverImages(eventId: Int): Cursor {
//        val MY_QUERY = "SELECT " + DBStatics.ALBUM_IMAGES_IMAGE + "," + DBStatics.ALBUM_IMAGES_ID + "," + DBStatics.ALBUM_IMAGES_IMAGE_EXTENSION + " FROM " + DBStatics.TABLE_ALBUM_IMAGES + " a INNER JOIN " + DBStatics.TABLE_ALBUMS + " b ON a." + DBStatics.ALBUM_IMAGES_ID + "=b." + DBStatics.ALBUMS_COVER_IMAGE_ID + " WHERE a." + DBStatics.ALBUM_IMAGES_ORIGINAL + "=0 and b." + DBStatics.ALBUMS_EVENTS_ID + "=$eventId"
//        val cursor = DbHelper.dbReadable.rawQuery(MY_QUERY, null)
//        return cursor
//    }*/
//
//    /*fun totalOriginalImagesUnDownloadedForGenerateJson(albumId: Int): Cursor {
//        return DbHelper.dbWritable.query(DBStatics.TABLE_ALBUM_IMAGES, arrayOf(DBStatics.ALBUM_IMAGES_ID, DBStatics.ALBUM_IMAGES_IMAGE, DBStatics.ALBUM_IMAGES_IMAGE_EXTENSION), DBStatics.ALBUM_ID + "=? AND " + DBStatics.ALBUM_IMAGES_ORIGINAL + "=?", arrayOf(albumId.toString(), 0.toString()), null, null, null, null)
//    }*/
//
//    @Query("SELECT image,image_extension,image_id FROM album_images INNER JOIN  albums ON album_images.image_id = albums.cover_image_id WHERE album_images.original=0 AND albums.event_id =:eventId")
//    fun totalAlbumsViewUndownloadedCoverImages(eventId: Int): List<UnDownloadedCoverImages>
//
//    @Query("SELECT image_id,image,image_extension FROM album_images WHERE album_id=:id")
//    fun totalOriginalImagesUnDownloadedForGenerateJson(id: Int): List<UnDownloadedCoverImages>
//
//    /* fun updateAlbumName(id: Int, albumName: String, lastUpdatedAt: Int) {
//         val contentValues = ContentValues()
//         contentValues.put(DBStatics.ALBUMS_ALBUM_NAME, albumName)
//         contentValues.put(DBStatics.ALBUMS_UPDATED_AT, lastUpdatedAt)
//         DbHelper.dbWritable.update(DBStatics.TABLE_ALBUMS, contentValues, DBStatics.ALBUMS_ID + "=?", arrayOf(id.toString()))
//     }
//
//   */
//
//    /*fun updateAlbumStorageSize(albumSize: Int, albumId: Int){
//        val contentValues = ContentValues()
//        contentValues.put(DBStatics.ALBUMS_ALBUM_SIZE, albumSize)
//        DbHelper.dbWritable.update(DBStatics.TABLE_ALBUMS, contentValues, DBStatics.ALBUMS_ID + "=?", arrayOf(albumId.toString()))
//    }*/
//
//    @Query("UPDATE albums SET album_name = :albumName,last_updated_at=:lastUpdatedAt WHERE album_id = :id")
//    fun updateAlbumName(id: Int, albumName: String, lastUpdatedAt: Long)
//
//    @Query("UPDATE albums SET album_size=:albumSize WHERE  album_id = :albumId")
//    fun updateAlbumStorageSize(albumSize: Int, albumId: Int)
//
//
//    /*  fun getCompletedAlbumOriginalImageUrl(imageName: String): String {
//          val cursor = DbHelper.dbWritable.query(DBStatics.TABLE_ALBUM_IMAGES, arrayOf(DBStatics.ALBUM_IMAGES_ORIGINAL_URL), DBStatics.ALBUM_IMAGES_IMAGE + "=? ", arrayOf(imageName), null, null, null)
//          if (cursor.count == 1) {
//              cursor.moveToFirst()
//              return cursor.getString(cursor.getColumnIndex(DBStatics.ALBUM_IMAGES_ORIGINAL_URL))
//          }
//          return ""
//      }*/
//
//    @Query("SELECT original_url FROM album_images WHERE image=:imageName")
//    fun getCompletedAlbumOriginalImageUrl(imageName: String): String
//
///*
//    fun addOriginalInfo(t: Int, url: String) {
//        val contentValues = ContentValues()
//        contentValues.put(DBStatics.ALBUM_IMAGES_ORIGINAL, t)
//        DbHelper.dbWritable.update(DBStatics.TABLE_ALBUM_IMAGES, contentValues, DBStatics.ALBUM_IMAGES_IMAGE + "=?", arrayOf(url))
//    }
//
//*/
//
//    @Query("UPDATE album_images SET original=:t WHERE image=:url ")
//    fun addOriginalInfo(t: Int, url: String)
//
//    /*fun getCoverImageOfAlbum(albumId: Int): String{
//        try {
//            val coverImageIdInCursor = DbHelper.dbWritable.query(DBStatics.TABLE_ALBUMS, arrayOf(DBStatics.ALBUMS_COVER_IMAGE_ID), DBStatics.ALBUMS_ID + "=?", arrayOf(albumId.toString()), null, null, null)
//            coverImageIdInCursor.moveToFirst()
//            val coverImageId = coverImageIdInCursor.getInt(coverImageIdInCursor.getColumnIndex(DBStatics.ALBUMS_COVER_IMAGE_ID))
//            val df = DbHelper.dbWritable.query(DBStatics.TABLE_ALBUM_IMAGES, arrayOf(DBStatics.ALBUM_IMAGES_IMAGE, DBStatics.ALBUM_IMAGES_IMAGE_EXTENSION), DBStatics.ALBUM_IMAGES_ID + "=?", arrayOf(coverImageId.toString()), null, null, null)
//            df.moveToFirst()
//            return "${df.getString(df.getColumnIndex(DBStatics.ALBUM_IMAGES_IMAGE))}${df.getString(df.getColumnIndex(DBStatics.ALBUM_IMAGES_IMAGE_EXTENSION))}"
//        }catch (e: Exception){
//            return ""
//        }
//    }*/
//
//    @Query("SELECT cover_image_id FROM albums WHERE album_id=:albumId")
//    fun getCoverImageOfAlbumId(albumId: Int): Int
//
//    @Query("SELECT image,image_extension FROM album_images WHERE image_id=:coverImageId")
//    fun getCoverImageOfAlbum(coverImageId: Int): SingleAlbumOriginalPhotoUrl
//
//
//    /* fun addOriginalInfo(t: Int, url: String) {
//         val contentValues = ContentValues()
//         contentValues.put(DBStatics.ALBUM_IMAGES_ORIGINAL, t)
//         DbHelper.dbWritable.update(DBStatics.TABLE_ALBUM_IMAGES, contentValues, DBStatics.ALBUM_IMAGES_IMAGE + "=?", arrayOf(url))
//     }
// */
//    /*fun addThumbInfo(t: Int, url: String) {
//        val contentValues = ContentValues()
//        contentValues.put(DBStatics.ALBUM_IMAGES_THUMB, t)
//        DbHelper.dbWritable.update(DBStatics.TABLE_ALBUM_IMAGES, contentValues, DBStatics.ALBUM_IMAGES_IMAGE + "=?", arrayOf(url))
//    }*/
//
//
//    @Query("UPDATE album_images SET thumb=:t WHERE image=:url")
//    fun addThumbInfo(t: Int, url: String)
//
//    /*fun totalOriginalImagesDownloaded(albumId: Int): Cursor {
//        return DbHelper.dbWritable.query(DBStatics.TABLE_ALBUM_IMAGES, arrayOf(DBStatics.ALBUM_IMAGES_IMAGE), DBStatics.ALBUM_IMAGES_ORIGINAL + "=? and " + DBStatics.ALBUM_ID + "=?", arrayOf(1.toString(), albumId.toString()), null, null, null, null)
//    }*/
//
//    /* fun totalOriginalImagesUnDownloaded(albumId: Int): Cursor {
//         return DbHelper.dbWritable.query(DBStatics.TABLE_ALBUM_IMAGES, arrayOf(DBStatics.ALBUM_IMAGES_ID, DBStatics.ALBUM_IMAGES_IMAGE, DBStatics.ALBUM_IMAGES_IMAGE_EXTENSION), DBStatics.ALBUM_ID + "=?", arrayOf(albumId.toString()), null, null, null, null)
//     }*/
//
//
//    @Query("SELECT image_id,image,image_extension FROM album_images WHERE album_id=:id")
//    fun totalOriginalImagesUnDownloaded(id: Int): List<UnDownloadedCoverImages>
//
//
//    @Query("SELECT image FROM album_images WHERE original=1 AND album_id=:albumId")
//    fun totalOriginalImagesDownloaded(albumId: Int): List<DownloadedImagesList>
//
//    @Query("SELECT * FROM album_images WHERE album_id = (SELECT album_id FROM albums WHERE event_id = (SELECT id FROM events WHERE event_type = 2))")
//    fun getStudioGalleryAlbumImages(): List<AlbumImages>
//
//    //@Query("SELECT * FROM album_images ai inner join albums a on ai.image_id = a.cover_image_id")
//    @Query("SELECT * FROM album_images ai, albums a WHERE ai.image_id = a.cover_image_id")
//    fun getStudioGalleryAlbumCoverImages(): List<AlbumImages>
//
//    @Query("UPDATE album_images SET thumb = 0 , original = 0 WHERE album_id = (SELECT album_id FROM albums WHERE event_id = (SELECT event_id FROM events WHERE event_type = 2))")
//    fun updateGalleryAlbumImagesStatusToZero()
//
//    @Query("UPDATE album_images SET thumb = 0 , original = 0 WHERE album_id = (SELECT id FROM events WHERE event_type = 2)")
//    fun updateGalleryAlbumCoverImagesStatusToZero()
//
//    @Query("SELECT * FROM album_images")
//    fun getAllStudioGalleryAlbumImages(): List<AlbumImages>
//
//    @Query("DELETE FROM album_images")
//    fun deleteAlbumImages()
//
//    @Query("DELETE FROM albums")
//    fun deleteAlbums()
//
//    @Query("DELETE FROM videos")
//    fun deleteEventVideos()
//
//    @Query("DELETE FROM events")
//    fun deleteEvents()
//
//  /*  fun getTobeDeletedImagesIdFromPredesignedAblumsTable(eventId: Int): List<SingleAlbumOriginalPhotoUrl> {
//        val MY_QUERY = "SELECT ${DBStatics.PREDESIGNED_ALBUM_IMAGES_IMAGE},${DBStatics.PREDESIGNED_ALBUM_IMAGES_EXTENSION} FROM ${DBStatics.TABLE_PREDESIGNED_ALBUM_IMAGES} WHERE ${DBStatics.PREDESIGNED_ALBUM_ID} IN (SELECT ${DBStatics.PREDESIGNED_ALBUM_ID} FROM ${DBStatics.TABLE_PREDESIGNED_ALBUM} WHERE ${DBStatics.PREDESIGNED_ALBUMS_EVENT_ID} = ${eventId})"
//        Others.DLog("DBHelper:", "getTobeDeletedImagesId: Q : $MY_QUERY")
//        return DbHelper.dbReadable.rawQuery(MY_QUERY, null)
//    }*/
//
//  /*  dbWritable.rawQuery("DELETE FROM ${DBStatics.TABLE_PREDESIGNED_ALBUM_IMAGES} WHERE ${DBStatics.PREDESIGNED_ALBUM_ID} IN (SELECT ${DBStatics.PREDESIGNED_ALBUMS_ID} FROM ${DBStatics.TABLE_PREDESIGNED_ALBUM} WHERE ${DBStatics.PREDESIGNED_ALBUMS_EVENT_ID} = ${eventId} )", null)*/
//
//    @Query("SELECT p_image,p_image_extension,p_album_id FROM p_album_images WHERE p_album_id = (SELECT p_album_id FROM p_albums WHERE p_albums_event_id =:eventId)")
//    fun getTobeDeletedImagesIdFromPredesignedAblumsTable(eventId: Int):List<PhotoselectionImageUrl>
//
//    @Query("DELETE FROM p_album_images WHERE p_album_id = (SELECT p_album_id FROM p_albums WHERE p_albums_event_id =:eventId)")
//    fun deletePhotoselectionImagesFromTable(eventId: Int)
//
//    @Query("DELETE FROM p_albums WHERE p_albums_event_id =:eventId")
//    fun deletePhotoselectionEventData(eventId:Int)
//
//    @Query("UPDATE p_albums SET deleted_status =:status WHERE p_albums_event_id=:eventId")
//    fun updatePredesignedDeletedStatus(eventId: Int, status: Int)
//
//    @Query("SELECT deleted_status FROM p_albums WHERE p_albums_event_id=:eventId")
//    fun getdeletedStatus(eventId:Int):Int
//
//
//
//    /*fun updatePredesignedDeletedStatus(eventId: Int, status: Int) {
//
//        val contentValues = ContentValues()
//        if (getPredesignedAlbumExistsOrNot(eventId)) {
//            Others.DLog("SettingsFragment--:", "${status} -- ${eventId}")
//            contentValues.put(DBStatics.PREDESIGNED_ALBUMS_DELETED_STATUS, status)// 1 --> Event deleted , 0--> event not deleted
//            DbHelper.dbWritable.update(DBStatics.TABLE_PREDESIGNED_ALBUM, contentValues, DBStatics.PREDESIGNED_ALBUMS_EVENT_ID + "=?", arrayOf(eventId.toString()))
//        }
//    }*/
//
//  //  dbWritable.delete(DBStatics.TABLE_PREDESIGNED_ALBUM, DBStatics.PREDESIGNED_ALBUMS_EVENT_ID + "=?", arrayOf(eventId.toString()))
//
//
//
//}