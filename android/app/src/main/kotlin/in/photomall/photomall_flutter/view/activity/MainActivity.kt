package `in`.photomall.photomall_flutter.view.activity

//import `in`.photomall.photomall_flutter.roomDatabase.PhotomallDB
import `in`.photomall.photomall_flutter.database.DBStatics
import `in`.photomall.photomall_flutter.database.DbHelper
import `in`.photomall.photomall_flutter.model.other.AlbumOrdersModel
import `in`.photomall.photomall_flutter.model.other.AlbumOrdersModelItem
import `in`.photomall.photomall_flutter.model.other.JvtFile
import `in`.photomall.photomall_flutter.model.other.JvtFileConnector
import `in`.photomall.photomall_flutter.utils.Others.DLog
import `in`.photomall.photomall_flutter.utils.StorageUtils
import android.annotation.SuppressLint
import android.content.Intent
import android.content.SharedPreferences
import android.provider.Settings
import android.os.Build
import android.view.WindowManager
import android.widget.Toast
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.android.FlutterFragmentActivity
//import net.touchcapture.qr.flutterqr.QrShared.activity
import org.json.JSONArray
import java.io.File


class MainActivity : FlutterFragmentActivity() {

    private val channel = "photomallNative"


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {

        val mPrefs: SharedPreferences =
            getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE)
        val value: Boolean = mPrefs.getBoolean("flutter." + "screen_shot", false)

        GeneratedPluginRegistrant.registerWith(flutterEngine)
        /*if (!value) {
            window.setFlags(
                WindowManager.LayoutParams.FLAG_SECURE,
                WindowManager.LayoutParams.FLAG_SECURE
            )
        }*/
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->
            // Note: this method is invoked on the main thread.
            when (call.method) {
                "showCurlAlbum" -> {
                    //val text = call.argument<String>("key")  // hello world
                    val albumCode = call.argument<String>("albumCode")!!
                    studioId = call.argument<String>("studioId")!!
                    publicPath = call.argument<String>("public_path")!!
                    screenDisplay = call.argument<Int>("screen_display")!!
                    albumViewBackgroundColor =
                        call.argument<String>("album_view_background_color")!!
                    iconColor = call.argument<String>("icon_color")!!
                    iconBackgroundColor = call.argument<String>("icon_background_color")!!
                    studioLogoBackgroundColor =
                        call.argument<String>("studio_logo_background_color")!!
                    progressBarColor = call.argument<String>("progress_bar_color")!!
                    canTakeScreenshot = call.argument<Boolean>("can_take_screenshot")!!
                    //Toast.makeText(this, "showCurlAlbumd dfgdfg", Toast.LENGTH_LONG).show()
                    //val key = call.argument<String>("key")!!
                    //EncryptAndDecryptFiles.encryptionAndDecryptionKey = ""
                    /*val file = StorageUtils.getFile(this, "c2f6c880-c016-11ed-b83a-ffc3f1a5359e.jpg")
                    DLog(
                        "MainActivity:",
                        "MethodChannel, albumCode: $albumCode :: exists :: ${file.exists()}"
                    )*/
                    showAlbum(albumCode)
                    /*val intent = Intent(applicationContext, SampleActivity::class.java)
                    intent.putExtra("key", text.toString())
                    intent.putExtra("albumId", albumId)
                    activity.startActivity(intent)*/


                    //Toast.makeText(context, text.toString(), Toast.LENGTH_LONG).show()
                    //Log.e("mapList Main activity", text.toString())

                }
                "isDeveloperModeEnabled" -> {
                    try {
                        val devOptions: Int = Settings.Secure.getInt(
                            this.contentResolver,
                            Settings.Global.DEVELOPMENT_SETTINGS_ENABLED,
                            0
                        )
                        DLog("MainActivity", "isDeveloperModeEnabled $devOptions")
                        result.success(devOptions == 1)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }
                "isRunningOnEmulator" -> {
                    try {
                        result.success(isRunningOnEmulator())
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }
                "sample" -> {
                    val dbHelper = DbHelper.getInstance(this)
                    //var photomallDao = PhotomallDB.getInstance(this).photomallDao()
                    //var count = runBlocking { withContext(Dispatchers.Default) { photomallDao.getPredesignedAlbumLastUpdatedAt() } }
                    //DLog("MainActivity ", "sample() STEP 1 DATA() :: $count")

//                    var df = dbHelper.dbReadable.query(DBStatics.OPtableAlbums, arrayOf(DBStatics.OPalbumCode, DBStatics.OPalbumName), null, null, null, null, null);
                    /*val query =
                        "SELECT jvtFiles.${DBStatics.OPjvtFileCode}, jvtFiles.${DBStatics.OPjvtFileName}, jvtFiles.${DBStatics.OPjvtFileSize} from ${DBStatics.OPtableJvtFiles} jvtFiles " +
                                "INNER JOIN ${DBStatics.OPtableJvtFileConnectors} jvtFileConnectors " +
                                "ON jvtFiles.${DBStatics.OPjvtFileCode} = jvtFileConnectors.${DBStatics.OPjvtFileConnectorJvtFileCode} AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleType} = \"${TransportDataKeys.orders}\" /*AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorTag} = \"${TransportDataKeys.originalImage}\" */" +
                                "INNER JOIN ${DBStatics.OPtableOrders} orde " +
                                "ON jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleCode} = orde.${DBStatics.OPorderCode} AND orde.${DBStatics.OPorderAlbumCode} = \"edtbcqmf\" ORDER BY orde.${DBStatics.OPorderPriority} DESC"
                    val df = dbHelper.dbWritable.rawQuery(query, null)
                    DLog(
                        "MainActivity ",
                        "sample() DATA() :: ${DatabaseUtils.dumpCursorToString(df)}"
                    )*/
                    result.success(null)
                }
                "saveFile" -> {
                    //try {
                    val fileName = call.argument<String>("fileName")!!
                    val fileData = call.argument<ByteArray>("fileData")!!
                    StorageUtils.saveFile(this, fileName, fileData)
                    result.success(true)
//                    } catch (e: Exception) {
//                        result.success(false)
//                    }
                }
                "getFile" -> {
                    //try{
                    val fileName = call.argument<String>("fileName")!!
                    result.success(StorageUtils.getFileAsBytes(this, fileName))
//                    }catch (e: Exception){
//                        result.error("0", e.message!!, null)
//                    }

                }
            }
        }
    }

    override fun getBackgroundMode(): FlutterActivityLaunchConfigs.BackgroundMode {
        return FlutterActivityLaunchConfigs.BackgroundMode.transparent
    }

    @SuppressLint("Range")
    private fun showAlbum(albumCode: String) {
        DLog("MainActivity :: ", "showAlbum :: studioId = ${MainActivity.studioId}")
        DLog("MainActivity :: ", "showAlbum :: publicPath = ${MainActivity.publicPath}")
        DLog("MainActivity :: ", "showAlbum :: screenDisplay = ${MainActivity.screenDisplay}")
        DLog(
            "MainActivity :: ",
            "showAlbum :: albumViewBackgroundColor = ${MainActivity.albumViewBackgroundColor}"
        )
        DLog("MainActivity :: ", "showAlbum :: iconColor = ${MainActivity.iconColor}")
        DLog(
            "MainActivity :: ",
            "showAlbum :: iconBackgroundColor = ${MainActivity.iconBackgroundColor}"
        )
        DLog(
            "MainActivity :: ",
            "showAlbum :: studioLogoBackgroundColor = ${MainActivity.studioLogoBackgroundColor}"
        )
        var eventCode: String? = null
        var lastUpdatedAt: Int? = null
        var albumOrientation: String? = null
        var albumMusicCode: String? = null
        var albumSize: String? = null
        var eventType: Int? = null
        var albumType: Int? = null

        val dbHelper = DbHelper.getInstance(this)
        val albumCommonDetailsCursor = dbHelper.getAlbumCommonDetails(albumCode)
        if (albumCommonDetailsCursor.count > 0 && albumCommonDetailsCursor.moveToFirst()) {
            eventCode =
                albumCommonDetailsCursor.getString(albumCommonDetailsCursor.getColumnIndex(DBStatics.OPalbumEventCode))
                    ?: ""
            albumType =
                albumCommonDetailsCursor.getInt(albumCommonDetailsCursor.getColumnIndex(DBStatics.OPalbumType))
                    ?: 2
            //lastUpdatedAt = albumCommonDetailsCursor.getInt(albumCommonDetailsCursor.getColumnIndex(DBStatics.OPalbumLastUpdatedAt)) ?: 0
            lastUpdatedAt = 10
            albumSize =
                albumCommonDetailsCursor.getString(albumCommonDetailsCursor.getColumnIndex(DBStatics.OPalbumSize))
                    ?: ""
            val sizeList = albumSize.split('x')
            albumOrientation = if (sizeList[0].toInt() > sizeList[1].toInt()) {
                "Landscape"
            } else if (sizeList[0].toInt() < sizeList[1].toInt()) {
                "Portrait"
            } else {
                "Square"
            }
        }

        albumMusicCode = ""
        val albumDetailsCursor = dbHelper.getAlbumMusicName(albumCode)
        if (albumDetailsCursor.count > 0 && albumDetailsCursor.moveToFirst()) {
            albumMusicCode =
                albumDetailsCursor.getString(albumDetailsCursor.getColumnIndex(DBStatics.OPalbumMusic))
                    ?: ""
        }

        val eventTypeAndKeyCursor = dbHelper.getEventTypeAndKey(eventCode!!)
        if (eventTypeAndKeyCursor.count > 0 && eventTypeAndKeyCursor.moveToFirst()) {
            eventType =
                eventTypeAndKeyCursor.getInt(eventTypeAndKeyCursor.getColumnIndex(DBStatics.OPeventType))
                    ?: 2
            //eventUrl = eventTypeAndKeyCursor.getString(eventTypeAndKeyCursor.getColumnIndex(DBStatics.eventKey)) ?: ""
        }

        CurlActivity.imageDownloadStatusMap.clear()
        CurlActivity.imageTypeMap.clear()

        val ordersModel: AlbumOrdersModel = dbHelper.getClickedAlbumImages2(albumCode)
        ordersModel.forEach {
            val jvtFile = it.jvt_file_connectors?.first()?.jvt_file
            CurlActivity.imageTypeMap["${jvtFile?.name}${jvtFile?.extension}"] = it.image_type!!
            //CurlActivity.imageDownloadStatusMap["${jvtFile?.name}${jvtFile?.extension}"] = true
            CurlActivity.imageDownloadStatusMap["${jvtFile?.name}${jvtFile?.extension}"] =
                StorageUtils.getFile(this, "${jvtFile?.name}${jvtFile?.extension}").exists()
            DLog(
                "MainActivity :: ",
                "CurlActivity.imageDownloadStatusMap :: Hasmap-> ${jvtFile?.name} :: ${jvtFile?.extension}"
            )

            DLog(
                "MainActivity :: ",
                "CurlActivity.imageDownloadStatusMap :: Hasmap-> ${
                    StorageUtils.getFile(
                        this,
                        "${jvtFile?.name}${jvtFile?.extension}"
                    ).path
                }"
            )
            DLog(
                "MainActivity :: ",
                "CurlActivity.imageDownloadStatusMap :: Hasmap-> ${
                    StorageUtils.getFile(
                        this,
                        "${jvtFile?.name}${jvtFile?.extension}"
                    ).absolutePath
                }"
            )
        }
        //DLog("MainActivity :: ", "CurlActivity.imageDownloadStatusMap :: Hasmap-> " + Gson().toJson(CurlActivity.imageDownloadStatusMap))

        val intent = Intent(applicationContext, CurlActivity::class.java)
        //intent.putExtra("albumName", albumName)
        intent.putExtra("eventCode", eventCode)
        intent.putExtra("albumCode", albumCode)
        intent.putExtra("albumType", albumType)
        intent.putExtra("updatedAt", lastUpdatedAt)
        intent.putExtra("musicFileName", albumMusicCode)
        intent.putExtra("albumSize", albumSize)
        //intent.putExtra("eventUrl", eventUrl)
        intent.putExtra("eventType", eventType)
        intent.putExtra("orientation", albumOrientation)
        intent.putExtra("isNeedToRefresh", true)
        intent.putExtra("canTakeScreenshot", canTakeScreenshot)
        startActivity(intent)
    }

    fun isRunningOnEmulator(): Boolean {
        // Android SDK emulator
        return ((Build.FINGERPRINT.startsWith("google/sdk_gphone_")
                && Build.FINGERPRINT.endsWith(":user/release-keys")
                && Build.MANUFACTURER == "Google" && Build.PRODUCT.startsWith("sdk_gphone_") && Build.BRAND == "google"
                && Build.MODEL.startsWith("sdk_gphone_"))
                || Build.FINGERPRINT.contains("generic")
                || Build.FINGERPRINT.contains("unknown")
                || Build.MODEL.contains("google_sdk")
                || Build.MODEL.contains("Emulator")
                || Build.MODEL.contains("Android SDK built for x86")
                //bluestacks
                || "QC_Reference_Phone" == Build.BOARD && !"Xiaomi".equals(
            Build.MANUFACTURER,
            ignoreCase = true
        ) //bluestacks
                || Build.MANUFACTURER.contains("Genymotion")
                || Build.HOST.startsWith("Build") //MSI App Player
                || Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic")
                || Build.PRODUCT == "google_sdk")
    }

    companion object {
        var studioId: String = ""
        var publicPath: String = "https://cdn.ptml.in/photomall/"
        var screenDisplay: Int = 2
        var albumViewBackgroundColor: String = ""
        var iconColor: String = ""
        var iconBackgroundColor: String = ""
        var studioLogoBackgroundColor: String = ""
        var progressBarColor: String = ""
        var canTakeScreenshot: Boolean = false
    }
}


/*
data class CurlImageDataModel(
    val images: List<Image>
)

data class Image(
    val index: Int,
    val left_image: String,
    val right_image: String
)*/
