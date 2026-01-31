package com.photomall.photoalbum.photomallUser.appUtils.downloadImagesUtils

import `in`.photomall.photomall_flutter.database.DBStatics
import `in`.photomall.photomall_flutter.database.DbHelper
import `in`.photomall.photomall_flutter.utils.Others.DLog
import android.annotation.SuppressLint
import android.content.Context
import android.database.Cursor
import com.google.gson.JsonArray
import com.google.gson.JsonObject

object DownloadTempImages {

    fun getUnDownloadedTempImagesCursor(page_status: Int, code: String, dbHelper: DbHelper): Cursor {

        var cursor: Cursor? = null


        when (page_status) {// id --> may be event id or album id, page update_status--> its represents where it is from .
            //0 -> cursor = dbHelper!!.viewAlbumsPageDownloadableImages()
            ///0 -> cursor = dbHelper.totalEventsPageUnDownloadableImagesForGenerateJson()// Thumb for all events
            ///1 -> cursor = dbHelper.totalInvitationsPageUnDownloadableImages(id)
            2 -> cursor = dbHelper.totalOriginalImagesUnDownloadedForGenerateJson(code) // all original for completed album
            3 -> cursor = dbHelper.totalOriginalImagesUnDownloadedForGenerateJson(code)
            //4 -> cursor = dbHelper!!.totalPredesignedOriginalImagesUnDownloaded(albumId!!) // all original for predesigned album
            ///4 -> cursor = dbHelper.totalPredesignedAlbumsViewUndownloadedOriginalImagesForGenerateJson() // all original for predesigned album
            ///5 -> cursor = dbHelper.totalPredesignedOriginalImagesUnDownloadedForGenerateJson(id) // single thumb for studio album
            ///6 -> cursor = dbHelper.totalStudioGalleryEventsPageUnDownloadableImagesForGenerateJson()
            //PageConst.ALBUM_THUMB_IMAGES -> cursor = dbHelper.totalThumbImagesUnDownloadedForGenerateJson(id)

            else -> {

            }
        }
        return cursor!!
    }


    @SuppressLint("Range")
    fun getImagesIdAndAddToJsonObject(page_status: Int, code: String, dbHelper: DbHelper, context: Context): JsonObject {

        val imageIdsArray = JsonArray()
        val imageIdsJsonObject = JsonObject()

        //val photomallDao = PhotomallDB.getInstance(context).photomallDao()
        /*val images: List<PreDesignedAlbumImages>
        if (page_status == 4 || page_status == 5) {
            images = if (page_status == 4) {
                runBlocking { withContext(Dispatchers.Default) { photomallDao.viewPredesignedAlbumsPageDownloadableImages() } }
            } else {
                runBlocking { withContext(Dispatchers.Default) { photomallDao.totalPredesignedOriginalImagesUnDownloadedForGenerateJson(id) } }
            }

            if (images.isNotEmpty()) {
                images.forEach {
                    if(it.pdAlbumImagesAccessType == 0) {
                        val id = JsonObject()
                        id.addProperty("id", it.pdAlbumImagesId)
                        id.addProperty("type", 4)
                        imageIdsArray.add(id)
                    }
                }
                imageIdsJsonObject.add("image_ids", imageIdsArray)
            }
        }*/

        val cursor = getUnDownloadedTempImagesCursor(page_status, code, dbHelper)

        DLog("DownloadTempImages", "${cursor.count}")

       /* if (page_status == 0 || page_status == 6 || page_status == PageConst.ALBUM_THUMB_IMAGES) {
            if (cursor.count > 0 && cursor.moveToFirst()) {
                do {
                    val id = JsonObject()
                    //if(cursor.getInt(cursor.getColumnIndex(DBStatics.ALBUM_IMAGES_ID)) != 0) {
                    id.addProperty("id", cursor.getInt(cursor.getColumnIndex(DBStatics.imageId)))
                    id.addProperty("type", 0)
                    imageIdsArray.add(id)
                    //}
                } while (cursor.moveToNext())
                imageIdsJsonObject.add("image_ids", imageIdsArray)
            }
        }*/
        if (page_status == 1) {
            DLog("DownloadTempImages", "FromEventDetailsActivity")
            /*if (cursor.count > 0 && cursor.moveToFirst()) {
                do {
                    if (cursor.getInt(cursor.getColumnIndex(DBStatics.INVITATIONS_IMAGE_ACCESS_TYPE)) == 0) {
                        val id = JsonObject()
                        id.addProperty("id", cursor.getInt(cursor.getColumnIndex(DBStatics.INVITATIONS_IMAGE_ID)))
                        id.addProperty("type", 11)
                        imageIdsArray.add(id)
                    }
                } while (cursor.moveToNext())
            }*/
            val albumCursor = dbHelper.totalAlbumsViewUnDownloadedCoverImages(code)
            if (albumCursor.count > 0 && albumCursor.moveToFirst()) {
//                do {
//                    if (albumCursor.getInt(cursor.getColumnIndex(DBStatics.imageAccessType)) == 0) {
//                        val id = JsonObject()
//                        id.addProperty("id", albumCursor.getInt(albumCursor.getColumnIndex(DBStatics.imageId)))
//                        id.addProperty("type", 12)
//                        imageIdsArray.add(id)
//                    }
//                } while (albumCursor.moveToNext())`
            }
            imageIdsJsonObject.add("image_ids", imageIdsArray)
        }
        if (page_status == 2) {
            DLog("FromCurlActivity", "FromCurlActivity")
            if (cursor.count > 0 && cursor.moveToFirst()) {
                do {
                    if (cursor.getInt(cursor.getColumnIndex(DBStatics.OPjvtFileMode)) == 0) {
                        val id = JsonObject()
                        id.addProperty("id", cursor.getInt(cursor.getColumnIndex(DBStatics.OPjvtFileCode)))
                        id.addProperty("type", 2)
                        imageIdsArray.add(id)
                    }
                } while (cursor.moveToNext())

                DLog("imageIdsArray", "$imageIdsArray")
                imageIdsJsonObject.add("image_ids", imageIdsArray)
            }
        }
        /*if (page_status == 4 || page_status == 5) {
            Others.DLog("DownloadImagesActivty :", "predesigned : ${DatabaseUtils.dumpCursorToString(cursor)}")
            if (cursor.count > 0 && cursor.moveToFirst()) {
                do {
                    val id = JsonObject()
                    id.addProperty("id", cursor.getInt(cursor.getColumnIndex(DBStatics.PREDESIGNED_ALBUM_IMAGES_ID)))
                    id.addProperty("type", 4)
                    imageIdsArray.add(id)
                } while (cursor.moveToNext())
            }
            imageIdsJsonObject.add("image_ids", imageIdsArray)
        }*/

        return imageIdsJsonObject
    }

}