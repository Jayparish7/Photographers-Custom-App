package `in`.photomall.photomall_flutter.appUtils

import `in`.photomall.photomall_flutter.database.DBStatics
import `in`.photomall.photomall_flutter.database.DbHelper
import android.annotation.SuppressLint
import android.database.Cursor
import com.google.gson.JsonArray
import com.google.gson.JsonObject

object GetUnDownloadedImages {

    fun getCursor(dbHelper: DbHelper, albumId: String): Cursor {
        return dbHelper.totalOriginalImagesUnDownloadedForGenerateJson(albumId)
    }
    
    @SuppressLint("Range")
    fun getJson(dbHelper: DbHelper, albumId: String): JsonObject {
        val cursor = getCursor(dbHelper, albumId)

        val imageIdsArray = JsonArray()
        val imageIdsJsonObject = JsonObject()

        if (cursor.count > 0 && cursor.moveToFirst()) {
            do {
                val id = JsonObject()
                id.addProperty("id", cursor.getInt(cursor.getColumnIndex(DBStatics.OPjvtFileCode)))
                id.addProperty("type", 2)
                imageIdsArray.add(id)
            } while (cursor.moveToNext())
            imageIdsJsonObject.add("image_ids", imageIdsArray)
        }
        return imageIdsJsonObject
    }
}