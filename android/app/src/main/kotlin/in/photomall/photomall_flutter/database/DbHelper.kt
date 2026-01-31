package `in`.photomall.photomall_flutter.database

import `in`.photomall.photomall_flutter.model.other.AlbumOrdersModel
import `in`.photomall.photomall_flutter.model.other.AlbumOrdersModelItem
import `in`.photomall.photomall_flutter.model.other.JvtFile
import `in`.photomall.photomall_flutter.model.other.JvtFileConnector
import `in`.photomall.photomall_flutter.utils.Others.DLog
import `in`.photomall.photomall_flutter.view.activity.CurlActivity
import `in`.photomall.photomall_flutter.view.activity.MainActivity
import android.annotation.SuppressLint
import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import com.google.gson.Gson
import org.json.JSONArray

/**
 * Created by Jovee-2 on 07-Jul-17.
 */

//class DbHelper(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {
class DbHelper(var context: Context?) {

    private val dbPath = context!!.getDatabasePath(DATABASE_NAME).path
    private var sqliteDatabase: SQLiteDatabase

    var dbWritable: SQLiteDatabase
    var dbReadable: SQLiteDatabase

    init {
        sqliteDatabase = SQLiteDatabase.openDatabase(dbPath, null,
                SQLiteDatabase.OPEN_READWRITE)
        dbWritable = sqliteDatabase
        dbReadable = sqliteDatabase
    }

    companion object {
        @Synchronized
        fun getInstance(context: Context): DbHelper {
            if (instance == null) instance = DbHelper(context)
            return instance as DbHelper
        }

        var instance: DbHelper? = null
        private const val DATABASE_NAME = "photomallMobile.db"
    }

    fun updateAlbumStorageSize(albumSize: Int, albumId: Int) {
        val contentValues = ContentValues()
        contentValues.put(DBStatics.albumSize, albumSize)
        dbWritable.update(DBStatics.tableAlbums, contentValues, DBStatics.albumID + "=?", arrayOf(albumId.toString()))
    }



    @SuppressLint("Range")
    fun getAlbumStorageSize(albumCode: String): Int {

        /*SELECT files.code, files.name, files.size from jvt_files files INNER JOIN jvt_file_connectors
        jvtFileConnectors ON files.code = jvtFileConnectors.jvt_file_code AND jvtFileConnectors.able_type = "orders"
        AND jvtFileConnectors.able_code = (SELECT code from orders WHERE album_code = "edtbcqmf")*/

        /*SELECT files.code, files.name, files.size, orde.priority from jvt_files files
        INNER JOIN jvt_file_connectors jvtFileConnectors
                ON files.code = jvtFileConnectors.jvt_file_code AND jvtFileConnectors.able_type = "orders" AND jvtFileConnectors.tag = "original"
        INNER JOIN orders orde
                ON jvtFileConnectors.able_code = orde.code AND orde.album_code = "edtbcqmf" ORDER BY orde.priority DESC*/

        /*val  query = "SELECT jvtFiles.${DBStatics.OPjvtFileCode}, jvtFiles.${DBStatics.OPjvtFileName}, jvtFiles.${DBStatics.OPjvtFileSize} from ${DBStatics.OPtableJvtFiles} jvtFiles " +
                "INNER JOIN ${DBStatics.OPtableJvtFileConnectors} jvtFileConnectors " +
                "ON jvtFiles.${DBStatics.OPjvtFileCode} = jvtFileConnectors.${DBStatics.OPjvtFileConnectorJvtFileCode} AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleType} = \"${TransportDataKeys.orders}\" /*AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorTag} = \"${TransportDataKeys.originalImage}\"*/ " +
                "INNER JOIN ${DBStatics.OPtableOrders} orde " +
                "ON jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleCode} = orde.${DBStatics.OPorderCode} AND orde.${DBStatics.OPorderAlbumCode} = \"$albumCode\" ORDER BY orde.${DBStatics.OPorderPriority} DESC"
        val df = dbWritable.rawQuery(query, null)
        var size = 0;
        if (df.count != 0) {
            df.moveToFirst()
            do {
                size += df.getInt(df.getColumnIndex(DBStatics.OPjvtFileSize))
            } while (df.moveToNext())
        }*/
        val ordersModel: AlbumOrdersModel? = getClickedAlbumImages2(albumCode)
        var size = 0;
        ordersModel?.forEach {
            size += it.jvt_file_connectors?.first()?.jvt_file?.size ?: 0
        }
        //if(df.getString(df.getColumnIndex(DBStatics.albumSize)))
        //return df.getInt(df.getColumnIndex(DBStatics.albumSize))
        return if (size != 0) (size / 1024) / 1024 else 1
    }

    fun getAlbumCommonDetails(albumId: String): Cursor {
        return dbWritable.query(DBStatics.OPtableAlbums, arrayOf(DBStatics.OPalbumEventCode, DBStatics.OPalbumSize, DBStatics.OPalbumType),
            DBStatics.OPalbumCode + "=? ", arrayOf(albumId), null, null, null)
    }

    fun getAlbumDetails(albumCode: String): Cursor {
        /*SELECT files.code, files.name, files.size from jvt_files files
        INNER JOIN jvt_file_connectors jvtFileConnectors
                ON files.code = jvtFileConnectors.jvt_file_code AND jvtFileConnectors.able_type = "albums" AND jvtFileConnectors.tag = "album-music" AND jvtFileConnectors.able_code = "edtbcqmf"*/
        val query = "SELECT files.${DBStatics.OPjvtFileCode}, files.${DBStatics.OPjvtFileName}, files.${DBStatics.OPjvtFileSize} from ${DBStatics.OPtableJvtFiles} files " +
                "INNER JOIN ${DBStatics.OPtableJvtFileConnectors} jvtFileConnectors " +
                "ON files.${DBStatics.OPjvtFileCode} = jvtFileConnectors.${DBStatics.OPjvtFileConnectorJvtFileCode} AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleType} = \"${TransportDataKeys.albums}\" AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorTag} = \"${TransportDataKeys.albumMuic}\" AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleCode} = \"$albumCode\""
        return dbWritable.rawQuery(query, null)
    }

    fun getAlbumMusicName(albumCode: String) : Cursor{
        return dbWritable.query(DBStatics.OPtableAlbums, arrayOf(DBStatics.OPalbumMusic),
            DBStatics.OPalbumCode + "=? ", arrayOf(albumCode), null, null, null)
    }

    fun totalOriginalImagesDownloaded(albumCode: String): Int {
//        val  query = "SELECT jvtFiles.${DBStatics.OPjvtFileCode}, jvtFiles.${DBStatics.OPjvtFileName}, jvtFiles.${DBStatics.OPjvtFileSize} from ${DBStatics.OPtableJvtFiles} jvtFiles " +
//                "INNER JOIN ${DBStatics.OPtableJvtFileConnectors} jvtFileConnectors " +
//                "ON jvtFiles.${DBStatics.OPjvtFileCode} = jvtFileConnectors.${DBStatics.OPjvtFileConnectorJvtFileCode} AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleType} = \"${TransportDataKeys.orders}\" /*AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorTag} = \"${TransportDataKeys.originalImage}\"*/ AND jvtFiles.${DBStatics.OPjvtFileDownloaded} = 1 " +
//                "INNER JOIN ${DBStatics.OPtableOrders} orde " +
//                "ON jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleCode} = orde.${DBStatics.OPorderCode} AND orde.${DBStatics.OPorderAlbumCode} = \"$albumCode\" ORDER BY orde.${DBStatics.OPorderPriority} DESC"
//        return dbWritable.rawQuery(query, null)
        return CurlActivity.imageDownloadStatusMap.filter { it.value }.size
    }

    fun totalOriginalImagesUnDownloaded(albumCode: String): Int {
//        val  query = "SELECT jvtFiles.${DBStatics.OPjvtFileCode}, jvtFiles.${DBStatics.OPjvtFileName}, jvtFiles.${DBStatics.OPjvtFileSize} from ${DBStatics.OPtableJvtFiles} jvtFiles " +
//                "INNER JOIN ${DBStatics.OPtableJvtFileConnectors} jvtFileConnectors " +
//                "ON jvtFiles.${DBStatics.OPjvtFileCode} = jvtFileConnectors.${DBStatics.OPjvtFileConnectorJvtFileCode} AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleType} = \"${TransportDataKeys.orders}\" /*AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorTag} = \"${TransportDataKeys.originalImage}\"*/ " +
//                "INNER JOIN ${DBStatics.OPtableOrders} orde " +
//                "ON jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleCode} = orde.${DBStatics.OPorderCode} AND orde.${DBStatics.OPorderAlbumCode} = \"$albumCode\" ORDER BY orde.${DBStatics.OPorderPriority} DESC"
        //return dbWritable.rawQuery(query, null)
        return CurlActivity.imageDownloadStatusMap.filter { !it.value }.size
    }

    fun totalOriginalImagesUnDownloadedForGenerateJson(albumCode: String): Cursor {
//        val  query = "SELECT jvtFiles.${DBStatics.OPjvtFileCode}, jvtFiles.${DBStatics.OPjvtFileName}, jvtFiles.${DBStatics.OPjvtFileSize}, jvtFiles.${DBStatics.OPjvtFileMode} from ${DBStatics.OPtableJvtFiles} jvtFiles " +
//                "INNER JOIN ${DBStatics.OPtableJvtFileConnectors} jvtFileConnectors " +
//                "ON jvtFiles.${DBStatics.OPjvtFileCode} = jvtFileConnectors.${DBStatics.OPjvtFileConnectorJvtFileCode} AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleType} = \"${TransportDataKeys.orders}\" /*AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorTag} = \"${TransportDataKeys.originalImage}\"*/ AND jvtFiles.${DBStatics.OPjvtFileDownloaded} = 0 " +
//                "INNER JOIN ${DBStatics.OPtableOrders} orde " +
//                "ON jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleCode} = orde.${DBStatics.OPorderCode} AND orde.${DBStatics.OPorderAlbumCode} = \"$albumCode\" ORDER BY orde.${DBStatics.OPorderPriority} DESC"
        return dbWritable.rawQuery("", null)
    }

    fun isOriginalsDownload(albumCode: String): Boolean {
//        val  query = "SELECT jvtFiles.${DBStatics.OPjvtFileCode}, jvtFiles.${DBStatics.OPjvtFileName}, jvtFiles.${DBStatics.OPjvtFileSize} from ${DBStatics.OPtableJvtFiles} jvtFiles " +
//                "INNER JOIN ${DBStatics.OPtableJvtFileConnectors} jvtFileConnectors " +
//                "ON jvtFiles.${DBStatics.OPjvtFileCode} = jvtFileConnectors.${DBStatics.OPjvtFileConnectorJvtFileCode} AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleType} = \"${TransportDataKeys.orders}\" /*AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorTag} = \"${TransportDataKeys.originalImage}\"*/ AND jvtFiles.${DBStatics.OPjvtFileDownloaded} = 0 " +
//                "INNER JOIN ${DBStatics.OPtableOrders} orde " +
//                "ON jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleCode} = orde.${DBStatics.OPorderCode} AND orde.${DBStatics.OPorderAlbumCode} = \"$albumCode\" ORDER BY orde.${DBStatics.OPorderPriority} DESC"
//        val df = dbWritable.rawQuery(query, null).count
//        return df <= 0
        return CurlActivity.imageDownloadStatusMap.filter { !it.value }.isEmpty()
    }

    fun insertInToAlbumImagesTable(id: Int, albumId: Int, image_url: String, imageExtension: String, thumbImageExistingStatus: Int, originalImageExistingStatus: Int, imageOrder: Int) {
        //dbWritable.beginTransaction()
//        val contentValues1 = ContentValues()
//        contentValues1.put(DBStatics.imageId, id)
//        contentValues1.put(DBStatics.referenceId, albumId)
//        contentValues1.put(DBStatics.imageName, "$image_url$imageExtension")
//        contentValues1.put(DBStatics.imageThumbDownloadStatus, thumbImageExistingStatus)
//        contentValues1.put(DBStatics.imageOriginalDownloadStatus, originalImageExistingStatus)
//        contentValues1.put(DBStatics.imageType, 1)
//        dbWritable.insertWithOnConflict(DBStatics.tableImages, null, contentValues1, SQLiteDatabase.CONFLICT_REPLACE)
//        /*dbWritable.setTransactionSuccessful()
//        dbWritable.endTransaction()*/
//
//        val contentValues = ContentValues()
//        contentValues.put(DBStatics.completedAlbumImageID, id)
//        contentValues.put(DBStatics.completedAlbumID, albumId)
//        contentValues.put(DBStatics.completedAlbumImageOrder, imageOrder)
//        dbWritable.insertWithOnConflict(DBStatics.tableCompletedAlbumImages, null, contentValues, SQLiteDatabase.CONFLICT_REPLACE)
    }

    fun getEventTypeAndKey(eventCode: String): Cursor {
        return dbWritable.query(DBStatics.OPtableEvents, arrayOf(DBStatics.OPeventType), DBStatics.OPeventCode + "=?", arrayOf(eventCode.toString()), null, null, null)
    }

    //to update value in Thumbnail column in Album Images Table
    fun addThumbnailInfo(t: Int, url: String) {
        val contentValues = ContentValues()
        contentValues.put(DBStatics.OPjvtFileDownloaded, t)
        dbWritable.update(DBStatics.OPtableJvtFiles, contentValues, DBStatics.OPjvtFileName + "=?", arrayOf(url))
    }

    //to update value in Original source column in Album Images Table
    fun addOriginalInfo(t: Int, url: String) {
        /*val contentValues = ContentValues()
        contentValues.put(DBStatics.OPjvtFileDownloaded, t)
        dbWritable.update(DBStatics.OPtableJvtFiles, contentValues, DBStatics.OPjvtFileName + "=?", arrayOf(url))*/
        CurlActivity.imageDownloadStatusMap[url] = t == 1
    }

    fun getClickedAlbumImages1(albumCode: String): Cursor {
        /*val query = "select timg.${DBStatics.imageName}, tcaimg.${DBStatics.completedAlbumImageOrder} from ${DBStatics.tableImages} timg " +
                "inner join ${DBStatics.tableCompletedAlbumImages} tcaimg on timg.${DBStatics.imageId} = tcaimg.${DBStatics.completedAlbumImageID} " +
                "where timg.${DBStatics.referenceId} = $albumCode AND timg.${DBStatics.imageType} = 1 ORDER BY tcaimg.${DBStatics.completedAlbumImageOrder}"*/
//        val  query = "SELECT jvtFiles.${DBStatics.OPjvtFileName}, jvtFiles.${DBStatics.OPjvtFileExtension}, orde.${DBStatics.OPorderImageType} from ${DBStatics.OPtableJvtFiles} jvtFiles " +
//                "INNER JOIN ${DBStatics.OPtableJvtFileConnectors} jvtFileConnectors " +
//                "ON jvtFiles.${DBStatics.OPjvtFileCode} = jvtFileConnectors.${DBStatics.OPjvtFileConnectorJvtFileCode} AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleType} = \"${TransportDataKeys.orders}\" /*AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorTag} = \"${TransportDataKeys.originalImage}\"*/ " +
//                "INNER JOIN ${DBStatics.OPtableOrders} orde " +
//                "ON jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleCode} = orde.${DBStatics.OPorderCode} AND orde.${DBStatics.OPorderAlbumCode} = \"$albumCode\" ORDER BY orde.${DBStatics.OPorderPriority} DESC"
        return dbWritable.rawQuery("", null)
    }

    @SuppressLint("Range")
    fun getClickedAlbumImages2(albumCode: String): AlbumOrdersModel {
        /*val query = "select timg.${DBStatics.imageName}, tcaimg.${DBStatics.completedAlbumImageOrder} from ${DBStatics.tableImages} timg " +
                "inner join ${DBStatics.tableCompletedAlbumImages} tcaimg on timg.${DBStatics.imageId} = tcaimg.${DBStatics.completedAlbumImageID} " +
                "where timg.${DBStatics.referenceId} = $albumCode AND timg.${DBStatics.imageType} = 1 ORDER BY tcaimg.${DBStatics.completedAlbumImageOrder}"*/
        val query = "SELECT ${DBStatics.OPalbumOrders} from ${DBStatics.OPtableAlbums} where ${DBStatics.OPalbumCode} = \"$albumCode\""
        val cursor = dbWritable.rawQuery(query, null)
        if (cursor.count != 0) {
            cursor.moveToFirst()
            val ordersJson = cursor.getString(cursor.getColumnIndex(DBStatics.OPalbumOrders))
            DLog("DbHelper: ", "inside isTemporaryUrlAvailable if $ordersJson")


            //val albumOrdersModel = Gson().fromJson("""$ordersJson""", AlbumOrdersModel::class.java)
            val albumOrdersModel = parseAlbumOrdersModel(ordersJson)
            for (order in albumOrdersModel) {
                //val jvtFileConnectors = mutableListOf<List<JvtFileConnector?>>()
                order.jvt_file_connectors = order.jvt_file_connectors?.filter { it?.screen_display == MainActivity.screenDisplay }
                //order.jvt_file_connectors?.filterTo(jvtFileConnectors, {it.screen_display == MainActivity.screenDisplay})
                //order.jvt_file_connectors.filterList {  }
            }
            albumOrdersModel.removeAll { it.jvt_file_connectors!!.isEmpty() }
            return albumOrdersModel
        }
        /*var df = listOf<AlbumOrdersModelItem>()
        return listOf<AlbumOrdersModelItem>()*/
        return Gson().fromJson("[]", AlbumOrdersModel::class.java)
    }

    private fun parseAlbumOrdersModel(ordersJson: String): AlbumOrdersModel {
        val albumOrdersModel = AlbumOrdersModel()
        val jsonArray = JSONArray(ordersJson)
        for (jsonIndex in 0 until jsonArray.length()) {
            val jvtFileConnectorJSONArray =
                jsonArray.getJSONObject(jsonIndex).getJSONArray("jvt_file_connectors")
            val jvtFileConnectors = mutableListOf<JvtFileConnector>()
            for (jsonIndex1 in 0 until jvtFileConnectorJSONArray.length()) {
                jvtFileConnectors.add(
                    JvtFileConnector(
                        code = jvtFileConnectorJSONArray.getJSONObject(jsonIndex1)
                            .getString("code"),
                        jvt_file = JvtFile(
                            code = jvtFileConnectorJSONArray.getJSONObject(jsonIndex1)
                                .getJSONObject("jvt_file").getString("code"),
                            extension = jvtFileConnectorJSONArray.getJSONObject(jsonIndex1)
                                .getJSONObject("jvt_file").getString("extension"),
                            mode = jvtFileConnectorJSONArray.getJSONObject(jsonIndex1)
                                .getJSONObject("jvt_file").getInt("mode"),
                            name = jvtFileConnectorJSONArray.getJSONObject(jsonIndex1)
                                .getJSONObject("jvt_file").getString("name"),
                            size = jvtFileConnectorJSONArray.getJSONObject(jsonIndex1)
                                .getJSONObject("jvt_file").getInt("size")
                        ),
                        name = jvtFileConnectorJSONArray.getJSONObject(jsonIndex1)
                            .getString("name"),
                        screen_display = jvtFileConnectorJSONArray.getJSONObject(jsonIndex1)
                            .getInt("screen_display"),
                    )
                )
            }
            albumOrdersModel.add(
                AlbumOrdersModelItem(
                    code = jsonArray.getJSONObject(jsonIndex).getString("code"),
                    image_type = jsonArray.getJSONObject(jsonIndex).getInt("image_type"),
                    jvt_file_connectors = jvtFileConnectors,
                    priority = jsonArray.getJSONObject(jsonIndex).getInt("priority"),
                    last_updated_at = jsonArray.getJSONObject(jsonIndex)
                        .getInt("last_updated_at"),
                    original_file_name = jsonArray.getJSONObject(jsonIndex)
                        .getString("original_file_name")
                )
            )
            //Log.d("JSON", jsonArray.getJSONObject(jsonIndex).getString("title"))
        }
        return albumOrdersModel
    }

    fun getCountOfTotalAlbumPages(albumCode: String): Int {
//        val  query = "SELECT jvtFiles.${DBStatics.OPjvtFileCode}, jvtFiles.${DBStatics.OPjvtFileName}, jvtFiles.${DBStatics.OPjvtFileSize} from ${DBStatics.OPtableJvtFiles} jvtFiles " +
//                "INNER JOIN ${DBStatics.OPtableJvtFileConnectors} jvtFileConnectors " +
//                "ON jvtFiles.${DBStatics.OPjvtFileCode} = jvtFileConnectors.${DBStatics.OPjvtFileConnectorJvtFileCode} AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleType} = \"${TransportDataKeys.orders}\" /*AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorTag} = \"${TransportDataKeys.originalImage}\"*/ " +
//                "INNER JOIN ${DBStatics.OPtableOrders} orde " +
//                "ON jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleCode} = orde.${DBStatics.OPorderCode} AND orde.${DBStatics.OPorderAlbumCode} = \"$albumCode\" ORDER BY orde.${DBStatics.OPorderPriority} DESC"
        //return dbWritable.rawQuery(query, null).count
        return  getClickedAlbumImages2(albumCode).size ?: 0
    }

    fun getAlbumImages(albumCode: String): Cursor {
//        val  query = "SELECT jvtFiles.${DBStatics.OPjvtFileCode}, jvtFiles.${DBStatics.OPjvtFileName}, jvtFiles.${DBStatics.OPjvtFileSize} from ${DBStatics.OPtableJvtFiles} jvtFiles " +
//                "INNER JOIN ${DBStatics.OPtableJvtFileConnectors} jvtFileConnectors " +
//                "ON jvtFiles.${DBStatics.OPjvtFileCode} = jvtFileConnectors.${DBStatics.OPjvtFileConnectorJvtFileCode} AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleType} = \"${TransportDataKeys.orders}\" /*AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorTag} = \"${TransportDataKeys.originalImage}\"*/ " +
//                "INNER JOIN ${DBStatics.OPtableOrders} orde " +
//                "ON jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleCode} = orde.${DBStatics.OPorderCode} AND orde.${DBStatics.OPorderAlbumCode} = \"$albumCode\" ORDER BY orde.${DBStatics.OPorderPriority} DESC"
        return dbWritable.rawQuery("", null)
    }

    fun insertRefreshedAlbumImagesAndEventCoverImageUrl(id: Int, originalUrl: String, thumbUrl: String) { // need to check
    }

    fun deleteAlbumImagesAndEventCoverImage(id: Int) { // need to check
        dbWritable.delete(DBStatics.OPtableJvtFiles, DBStatics.OPjvtFileCode + "=?", arrayOf(id.toString()))
    }

    fun getSingleAlbumOriginalPhotoUrl(albumCode: String): List<String> {
//        val  query = "SELECT jvtFiles.${DBStatics.OPjvtFileName} from ${DBStatics.OPtableJvtFiles} jvtFiles " +
//                "INNER JOIN ${DBStatics.OPtableJvtFileConnectors} jvtFileConnectors " +
//                "ON jvtFiles.${DBStatics.OPjvtFileCode} = jvtFileConnectors.${DBStatics.OPjvtFileConnectorJvtFileCode} AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleType} = \"${TransportDataKeys.orders}\" /*AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorTag} = \"${TransportDataKeys.originalImage}\" */AND jvtFiles.${DBStatics.OPjvtFileDownloaded} = 0 " +
//                "INNER JOIN ${DBStatics.OPtableOrders} orde " +
//                "ON jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleCode} = orde.${DBStatics.OPorderCode} AND orde.${DBStatics.OPorderAlbumCode} = \"$albumCode\" ORDER BY orde.${DBStatics.OPorderPriority} DESC"
        return  CurlActivity.imageDownloadStatusMap.filter { !it.value }.keys.toList()
        //return dbWritable.rawQuery(query, null)
    }

    @SuppressLint("Range")
    fun isTemporaryUrlAvailable(categoryId: String): Boolean { // need to check
        /*val df = dbReadable.query(DBStatics.OPtableJvtFiles, arrayOf(DBStatics.imageOriginalUrl), DBStatics.referenceId + "=? and " + DBStatics.imageOriginalDownloadStatus + "=?", arrayOf(categoryId.toString(), "0"), null, null, null)
        var isNull = true
        if (df.count != 0) {
            df.moveToFirst()
            do {
                if (df.getString(df.getColumnIndex(DBStatics.imageOriginalUrl)) == "") {
                    DLog("DbHelper: ", "inside isTemporaryUrlAvailable if")
                    isNull = false
                }
            } while (df.moveToNext())
        }
        return isNull*/
        return true
    }

    fun isAllImagesDownloaded(albumCode: String): Boolean {
//        val totalDownloadedImagesQuery = "SELECT jvtFiles.${DBStatics.OPjvtFileName} from ${DBStatics.OPtableJvtFiles} jvtFiles " +
//                "INNER JOIN ${DBStatics.OPtableJvtFileConnectors} jvtFileConnectors " +
//                "ON jvtFiles.${DBStatics.OPjvtFileCode} = jvtFileConnectors.${DBStatics.OPjvtFileConnectorJvtFileCode} AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleType} = \"${TransportDataKeys.orders}\" /*AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorTag} = \"${TransportDataKeys.originalImage}\" */AND jvtFiles.${DBStatics.OPjvtFileDownloaded} = 1 " +
//                "INNER JOIN ${DBStatics.OPtableOrders} orde " +
//                "ON jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleCode} = orde.${DBStatics.OPorderCode} AND orde.${DBStatics.OPorderAlbumCode} = \"$albumCode\" ORDER BY orde.${DBStatics.OPorderPriority} DESC"
//        val totalDownloadedImages = dbWritable.rawQuery(totalDownloadedImagesQuery, null).count
//        val totalImagesQuery = "SELECT jvtFiles.${DBStatics.OPjvtFileName} from ${DBStatics.OPtableJvtFiles} jvtFiles " +
//                "INNER JOIN ${DBStatics.OPtableJvtFileConnectors} jvtFileConnectors " +
//                "ON jvtFiles.${DBStatics.OPjvtFileCode} = jvtFileConnectors.${DBStatics.OPjvtFileConnectorJvtFileCode} AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleType} = \"${TransportDataKeys.orders}\" /*AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorTag} = \"${TransportDataKeys.originalImage}\"*/ " +
//                "INNER JOIN ${DBStatics.OPtableOrders} orde " +
//                "ON jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleCode} = orde.${DBStatics.OPorderCode} AND orde.${DBStatics.OPorderAlbumCode} = \"$albumCode\" ORDER BY orde.${DBStatics.OPorderPriority} DESC"
//        val totalImages = dbWritable.rawQuery(totalImagesQuery, null).count
//        return totalDownloadedImages == totalImages
        return CurlActivity.imageDownloadStatusMap.filter { !it.value }.isEmpty()
    }

    fun updateAlbumName(id: Int, albumName: String, lastUpdatedAt: Int) { // need to check
        val contentValues = ContentValues()
        contentValues.put(DBStatics.albumName, albumName)
        contentValues.put(DBStatics.albumLastUpdatedAt, lastUpdatedAt)
        dbWritable.update(DBStatics.tableAlbums, contentValues, DBStatics.albumID + "=?", arrayOf(id.toString()))
    }

    fun isOriginalsDownloadInAlbum(albumCode: String): Boolean {
        return getSingleAlbumOriginalPhotoUrl(albumCode).isEmpty()
        //return cursor == 0
    }

    @SuppressLint("Range")
    fun getCompletedAlbumOriginalImageUrl(imageName: String): String { // need to check
//        val cursor = dbWritable.query(DBStatics.tableImages, arrayOf(DBStatics.imageOriginalUrl), DBStatics.imageName + "=? ", arrayOf(imageName), null, null, null)
//        if (cursor.count == 1) {
//            cursor.moveToFirst()
//            var dg =  cursor.getString(cursor.getColumnIndex(DBStatics.imageOriginalUrl))
//            DLog("DbHelper:", "getCompletedAlbumOriginalImageUrl() if dg: $dg")
//            return dg
//        }
        DLog("DbHelper:", "getCompletedAlbumOriginalImageUrl() end")
        return ""
    }

    @SuppressLint("Range")
    fun isReadyForShareAlbum(eventCode: String): Boolean {
        val dfg = dbWritable.query(DBStatics.OPtableEvents, arrayOf(DBStatics.OPeventLoginRequired), DBStatics.OPeventCode + "=?", arrayOf(eventCode), null, null, null)
        dfg.moveToFirst()
        return dfg.getInt(dfg.getColumnIndex(DBStatics.OPeventLoginRequired)) == 0
    }

    fun ifAlbumImageExistsOrNot(albumCode: String): Boolean {
        return try {
            //val df = dbWritable.query(DBStatics.tableImages, null, DBStatics.referenceId + "=?", arrayOf(albumId.toString()), null, null, null)
//            val df = totalOriginalImagesUnDownloaded(albumCode)
//            df.count > 0
            CurlActivity.imageDownloadStatusMap.size > 0
        } catch (e: Exception) {
            false
        }
    }

    @SuppressLint("Range")
    fun getEventNameUsingEventId(eventCode: String): String {
        val cursor = getEventName(eventCode)
        var eventName = ""
        if (cursor.count > 0) {
            cursor.moveToFirst()
            do {
                eventName = cursor.getString(cursor.getColumnIndex(DBStatics.OPeventName))
            } while (cursor.moveToNext())
        }
        return eventName
    }

    fun getEventName(eventCode: String): Cursor {
        return dbWritable.query(DBStatics.OPtableEvents, arrayOf(
            DBStatics.OPeventName
        ), DBStatics.OPeventCode + "=?", arrayOf(eventCode.toString()), null, null, null)
    }

    fun getEventsUnDownloadedCoverImages(): Cursor { // need to check
        //val MY_QUERY = "SELECT " + DBStatics.ALBUM_IMAGES_IMAGE + " FROM " + DBStatics.TABLE_ALBUM_IMAGES + " a INNER JOIN " + DBStatics.TABLE_ALBUMS + " b ON a." + DBStatics.ALBUM_IMAGES_ID + "=b." + DBStatics.ALBUMS_COVER_IMAGE_ID + " WHERE a." + DBStatics.ALBUM_IMAGES_THUMB + "=?"
        //val MY_QUERY = "SELECT " + DBStatics.ALBUM_IMAGES_IMAGE + "," + DBStatics.ALBUM_IMAGES_ID + "," + DBStatics.ALBUM_IMAGES_IMAGE_EXTENSION + " FROM " + DBStatics.TABLE_ALBUM_IMAGES + " a INNER JOIN " + DBStatics.TABLE_EVENTS + " b ON a." + DBStatics.ALBUM_IMAGES_ID + "=b." + DBStatics.EVENTS_COVER_IMAGE_ID + " WHERE " + DBStatics.ALBUMS_ALBUM_TYPE + "=$USER_ALBUMS OR " + DBStatics.ALBUMS_ALBUM_TYPE + "=$DEMO_ALBUM"
        //val MY_QUERY = "SELECT " + DBStatics.imageName + "," + DBStatics.imageId + "," + " FROM " + DBStatics.tableImages + " a INNER JOIN " + DBStatics.tableEvents + " b ON a." + DBStatics.imageId + "=b." + DBStatics.eventCoverImageId + " WHERE (b." + DBStatics.eventType + "=$USER_EVENT OR b." + DBStatics.eventType + "=$DEMO_EVENT) AND a.${DBStatics.imageOriginalUrl}=0"
        val MY_QUERY = ""
        return dbReadable.rawQuery(MY_QUERY, null)
    }

    fun totalAlbumsViewUnDownloadedCoverImages(eventId: String): Cursor { // need to check
        //val MY_QUERY = "SELECT " + DBStatics.imageName + "," + DBStatics.imageId + "," + "," + DBStatics.imageAccessType + " FROM " + DBStatics.tableImages + " a INNER JOIN " + DBStatics.tableAlbums + " b ON a." + DBStatics.referenceId + "=b." + DBStatics.albumCoverImageID + " WHERE a." + DBStatics.imageOriginalUrl + "=0 and b." + DBStatics.eventID + "=$eventId"
        val MY_QUERY = ""
        return dbReadable.rawQuery(MY_QUERY, null)
    }

    fun insertRefreshedAlbumMusicUrl(id: Int, originalUrl: String, size: Long, extension: String) { // need to check
        val contentValues = ContentValues()
        contentValues.put(DBStatics.ALBUM_MUSIC_URL, originalUrl)
        contentValues.put(DBStatics.ALBUM_MUSIC_SIZE, size)
        contentValues.put(DBStatics.ALBUM_MUSIC_EXTENSION, extension)
        dbWritable.update(DBStatics.TABLE_ALBUM_MUSICS, contentValues, DBStatics.ALBUM_MUSIC_ID + "=?", arrayOf(id.toString()))
    }

    fun deleteAlbumMusic(id: Int) {
        //val db = this.writableDatabase
        dbWritable.delete(DBStatics.TABLE_ALBUM_MUSICS, DBStatics.ALBUM_MUSIC_ID + "=?", arrayOf(id.toString()))
    }

    @SuppressLint("Range")
    fun getAlbumMusicId(albumCode: String): String? {

        val query = "SELECT files.${DBStatics.OPjvtFileCode} from ${DBStatics.OPtableJvtFiles} files " +
                "INNER JOIN ${DBStatics.OPtableJvtFileConnectors} jvtFileConnectors " +
                "ON files.${DBStatics.OPjvtFileCode} = jvtFileConnectors.${DBStatics.OPjvtFileConnectorJvtFileCode} AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleType} = \"${TransportDataKeys.albums}\" AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorTag} = \"${TransportDataKeys.albumMuic}\" AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleCode} = \"$albumCode\""
        val cursor = dbWritable.rawQuery(query, null)
        if(cursor.count > 0 && cursor.moveToFirst()){
            return cursor.getString(cursor.getColumnIndex(DBStatics.OPjvtFileCode))
        }
        return "";
    }

    fun getAlbumMusic(albumCode: String): Cursor? { // need to check
        /*SELECT files.code, files.name, files.size from jvt_files files
        INNER JOIN jvt_file_connectors jvtFileConnectors
                ON files.code = jvtFileConnectors.jvt_file_code AND jvtFileConnectors.able_type = "albums" AND jvtFileConnectors.able_code = "edtbcqmf" AND jvtFileConnectors.tag = "album-music"*/
        val query = "SELECT files.${DBStatics.OPjvtFileCode}, files.${DBStatics.OPjvtFileName}, files.${DBStatics.OPjvtFileSize}, files.${DBStatics.OPjvtFileExtension}, files.${DBStatics.OPjvtFileDownloaded} from ${DBStatics.OPtableJvtFiles} files " +
                "INNER JOIN ${DBStatics.OPtableJvtFileConnectors} jvtFileConnectors " +
                "ON files.${DBStatics.OPjvtFileCode} = jvtFileConnectors.${DBStatics.OPjvtFileConnectorJvtFileCode} AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleType} = \"${TransportDataKeys.albums}\" AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorTag} = \"${TransportDataKeys.albumMuic}\" AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleCode} = \"$albumCode\""
        return dbWritable.rawQuery(query, null)
    }

    fun updateDownloadStatus(musicId: Int, downloadStatus: Int) {
        val contentValues = ContentValues()
        contentValues.put(DBStatics.ALBUM_MUSIC_DOWNLOAD_STATUS, downloadStatus)
        dbWritable.update(DBStatics.TABLE_ALBUM_MUSICS, contentValues, DBStatics.ALBUM_MUSIC_ID + "=?", arrayOf(musicId.toString()))
    }

    fun getStudioCoverLogo(): Cursor? { // need to check
        val query = "SELECT files.${DBStatics.OPjvtFileCode}, files.${DBStatics.OPjvtFileName}, files.${DBStatics.OPjvtFileSize}, files.${DBStatics.OPjvtFileExtension}, files.${DBStatics.OPjvtFileDownloaded} from ${DBStatics.OPtableJvtFiles} files " +
                "INNER JOIN ${DBStatics.OPtableJvtFileConnectors} jvtFileConnectors " +
                "ON files.${DBStatics.OPjvtFileCode} = jvtFileConnectors.${DBStatics.OPjvtFileConnectorJvtFileCode} AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorTag} = \"${TransportDataKeys.studioCover}\""
        return dbWritable.rawQuery(query, null)
    }

}

object TransportDataKeys {
    val userData = "user_data";

    val studioData = "studio_data";

    val photoSelectionData = "photo_selection_data";

    val albumTemporaryUrl = "album_temporary_urls";

    val folderTemporaryUrl = "folder_temporary_urls";

    val deviceData = "device_data";

    val designData = "design_data";


    val eventData = "event_data";
    val videos = "videos";
    val albums = "albums"
    val orders = "orders"
    val folders = "folders"
    val photoSelection = "photo_selection_images"
    val temporaryUrls = "temporary_urls"
    //val originalImage = "original"
    val originalImage = ""
    val albumCover = "album-cover"
    val albumMuic = "album-music"
    val studioCover = "studio-cover"
    val studioLogo = "studio-logo"
    val eventCover = "event-cover"
    val carousel = "carousel"
    val mobileCarousel = "carousel-1024"
    val webCarousel = "carousel-1920"
}

object AlbumImageType {
    //image_type
    //0->landscape, 1->potrait, 3->full_image, 4->half_image
    val landscape = 0
    val potrait = 1
    val full = 3
    val half = 4
}
