package `in`.photomall.photomall_flutter.appUtils

import `in`.photomall.photomall_flutter.api.WebConstants
import `in`.photomall.photomall_flutter.database.DbHelper
import `in`.photomall.photomall_flutter.model.api.eventAlbums.EventAlbumImagesResult
import `in`.photomall.photomall_flutter.utils.Others.DLog
import com.google.gson.Gson
import java.io.File

object InsertAlbums {
    
    fun updateAlbumImages(albumData: String, dbHelper: DbHelper, projectFolder: File) {
        DLog("InsertAlbums :", "inside updateAlbumImages() step 1")
        val result = Gson().fromJson(albumData, EventAlbumImagesResult::class.java).data.album

        DLog("InsertAlbums :", "inside updateAlbumImages() step 2")
        dbHelper.updateAlbumName(result.id, result.name, result.last_updated_at)
        //dbHelper.updateAlbumName(result.id, result.name, 0)

        DLog("InsertAlbums :", "inside updateAlbumImages() step 4")
        //dbHelper.insertNumberOfHalfImages(result.data.number_of_half_image, result.id)
        val size = (getAlbumSize(albumData) / 1024) / 1024 // In MB
        dbHelper.updateAlbumStorageSize(size.toInt(), result.id)
        result.images.forEach {
            if (it.update_status == WebConstants.INSERT) {
                DLog("InsertAlbums :", "inside updateAlbumImages() INSERT ${it.data.id}")
                insert(it.data.id, result.id, it.data.image, getExtension(it.data.image), dbHelper, it.data.image_order)
                
            } else if (it.update_status == WebConstants.UPDATE) {
                DLog("InsertAlbums :", "inside updateAlbumImages() UPDATE ${it.data.id}")
                update(it.data.id, result.id, it.data.image, getExtension(it.data.image), dbHelper, projectFolder, it.data.image_order)
            } else if (it.update_status == WebConstants.DELETE) { // delete
                delete(it.id, dbHelper, projectFolder)
            }
        }
    }
    
    fun deleteAlbumImages(imageUrl: String, imageExtension: String, projectFolder: File) {
        if (File(projectFolder, imageUrl + imageExtension).exists()) {
            File(projectFolder, imageUrl + imageExtension).delete()
        }
    }

    private fun getExtension(coverImage1: String): String {
        // DLog("InsertAlbums :", "getExtension : $coverImage1")
        val imageExtension = coverImage1.substring(coverImage1.lastIndexOf(".") + 1, coverImage1.length)
        return if (imageExtension.endsWith("jpg") || imageExtension!!.endsWith("jpeg")) {
            ".jpg"
        } else if (imageExtension.endsWith("png")) {
            ".png"
        } else if (imageExtension.endsWith("webp")) {
            ".webp"
        } else {
            ".jpg"
        }
        //return ".png"
    }

    private fun insert(id: Int, albumId: Int, image_url: String, imageExtension: String, dbHelper: DbHelper, imageOrder: Int) {
        //val imageDownloadStatus = dbHelper.getDownloadStatusOfCompletedImage(id)
        //dbHelper.insertInToAlbumImagesTable(id, albumId, image_url, imageExtension, imageDownloadStatus, imageDownloadStatus, imageOrder)
        //DLog("InsertAlbums:", "insert() end")
    }

    fun update(id: Int, albumId: Int, image_url: String, imageExtension: String, dbHelper: DbHelper, projectFolder: File, imageOrder: Int) {
        deleteImage(image_url, projectFolder)
        dbHelper.insertInToAlbumImagesTable(id, albumId, image_url, imageExtension, 0, 0, imageOrder)
    }

    fun delete(id: Int, dbHelper: DbHelper, projectFolder: File) {
//        val image = dbHelper.getAlbumImage(id)
//        if (image != null && image.moveToFirst()) {
//            deleteImage(image.getString(image.getColumnIndex(DBStatics.imageName)), projectFolder)
//            dbHelper.deleteFromAlbumImages(id)
//        }
    }

    private fun deleteImage(imageUrl: String, projectFolder: File) {
        if (File(projectFolder, imageUrl).exists()) {
            File(projectFolder, imageUrl).delete()
        }
    }

    fun getAlbumSize(album: String): Long {
        var albumSize = 0L
        val result = Gson().fromJson(album, EventAlbumImagesResult::class.java).data.album
        result.images.forEach {
            if (it.update_status == WebConstants.INSERT || it.update_status == WebConstants.UPDATE) {
                //DLog("InsertAlbums: ", "getAlbumSize: ${it.data.image}: ${(it.data.original_size / 1024) / 1024} MB : ${(it.data.original_size / 1024)} KB")
                albumSize += it.data.original_size
            }
        }
        return albumSize
    }
}