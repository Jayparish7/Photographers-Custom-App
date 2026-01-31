//package `in`.photomall.photomall_flutter.view.activity
//
//import `in`.photomall.photomall_flutter.R
//import `in`.photomall.photomall_flutter.adapter.ImageViewSliderAdapter1
//import `in`.photomall.photomall_flutter.api.*
//import `in`.photomall.photomall_flutter.api.AppConst.IS_LOG_ENABLED
//import `in`.photomall.photomall_flutter.api.SharedPreferenceConst.FIRST_IMAGE_ZOOM
//import `in`.photomall.photomall_flutter.api.SharedPreferenceConst.SECOND_IMAGE_ZOOM
//import `in`.photomall.photomall_flutter.appUtils.FileIO.getBitmapFromFile
//import `in`.photomall.photomall_flutter.appUtils.GetUnDownloadedImages
//import `in`.photomall.photomall_flutter.appUtils.InsertAlbums
//import `in`.photomall.photomall_flutter.database.DBStatics
//import `in`.photomall.photomall_flutter.database.DbHelper
//import `in`.photomall.photomall_flutter.interfaces.AlbumThumbnailDownloadCompletedListener
//import `in`.photomall.photomall_flutter.interfaces.ImageDownloadCompleted
//import `in`.photomall.photomall_flutter.model.api.RefreshImageUrl
//import `in`.photomall.photomall_flutter.model.api.eventAlbums.EventAlbumImagesResult
//import `in`.photomall.photomall_flutter.retrofitHelper.APICall
//import `in`.photomall.photomall_flutter.retrofitHelper.APICallForJson
//import `in`.photomall.photomall_flutter.retrofitHelper.APIListener
//import `in`.photomall.photomall_flutter.threadPool.DownloadManager
//import `in`.photomall.photomall_flutter.threadPool.DownloadResultUpdateTask
//import `in`.photomall.photomall_flutter.threadPool.DownloadResultUpdateTaskListener
//import `in`.photomall.photomall_flutter.threadPool.DownloadTask
//import `in`.photomall.photomall_flutter.utils.NetworkConnectionLiveData
//import `in`.photomall.photomall_flutter.utils.Network_check
//import `in`.photomall.photomall_flutter.utils.Others
//import `in`.photomall.photomall_flutter.utils.Others.DLog
//import `in`.photomall.photomall_flutter.utils.Others.getImageName
//import `in`.photomall.photomall_flutter.utils.Others.isAvailableExternalMemorySize
//import `in`.photomall.photomall_flutter.utils.Share
//import `in`.photomall.photomall_flutter.utils.SharedPreferenceHelper.Companion.getBooleanPreference
//import `in`.photomall.photomall_flutter.utils.SharedPreferenceHelper.Companion.getIntPreference
//import `in`.photomall.photomall_flutter.utils.SharedPreferenceHelper.Companion.setBooleanPreference
//import `in`.photomall.photomall_flutter.utils.SharedPreferenceHelper.Companion.setIntPreference
//import `in`.photomall.photomall_flutter.utils.SharedPreferenceHelper.Companion.setStringPreference
//import `in`.photomall.photomall_flutter.utils.bitmapHandler.BitmapImageCache
//import `in`.photomall.photomall_flutter.utils.bitmapHelper.ImageCache1
//import `in`.photomall.photomall_flutter.utils.bubbleShowCase.BubbleShowCase
//import `in`.photomall.photomall_flutter.utils.bubbleShowCase.BubbleShowCaseBuilder
//import `in`.photomall.photomall_flutter.utils.bubbleShowCase.BubbleShowCaseListener
//import `in`.photomall.photomall_flutter.utils.bubbleShowCase.BubbleShowCaseSequence
//import `in`.photomall.photomall_flutter.utils.curl.CurlPage
//import `in`.photomall.photomall_flutter.utils.curl.CurlPage.*
//import `in`.photomall.photomall_flutter.utils.curl.CurlView
//import `in`.photomall.photomall_flutter.view.dialogFragment.ZoomImageDialogFragment
//import `in`.photomall.photomall_flutter.worker.GetUnDownloadedImageUrlworker
//import `in`.photomall.photomall_flutter.worker.UpdateAlbumImagesWorker
//import android.animation.Animator
//import android.annotation.SuppressLint
//import android.app.Activity
//import androidx.lifecycle.Observer
//import android.content.Context
//import android.content.Intent
//import android.content.res.AssetFileDescriptor
//import android.database.Cursor
//import android.database.CursorIndexOutOfBoundsException
//import android.database.DatabaseUtils
//import android.graphics.*
//import android.graphics.drawable.BitmapDrawable
//import android.media.AudioAttributes
//import android.media.AudioManager
//import android.media.MediaPlayer
//import android.os.*
//import androidx.constraintlayout.widget.ConstraintLayout
//import androidx.core.content.ContextCompat
//import androidx.appcompat.app.AppCompatActivity
//import androidx.appcompat.app.AlertDialog
//import android.util.DisplayMetrics
//import android.view.MotionEvent
//import android.view.View
//import android.view.ViewTreeObserver
//import android.view.WindowManager
//import android.widget.Toast
//import androidx.work.Data
//import androidx.work.OneTimeWorkRequest
//import androidx.work.WorkInfo
//import androidx.work.WorkManager
//import com.google.gson.Gson
//import com.google.gson.JsonObject
//import kotlinx.android.synthetic.main.activity_curl_landscape.activity_curl_small_studioLogo_imageView
//import kotlinx.android.synthetic.main.activity_curl_landscape.activity_curl_studioLogo_imageView
//import kotlinx.android.synthetic.main.activity_curl_landscape.back_arrow_fab
//import kotlinx.android.synthetic.main.activity_curl_landscape.back_arrow_fabLayout
//import kotlinx.android.synthetic.main.activity_curl_landscape.curl_view
//import kotlinx.android.synthetic.main.activity_curl_landscape.fab
//import kotlinx.android.synthetic.main.activity_curl_landscape.fab1
//import kotlinx.android.synthetic.main.activity_curl_landscape.fab2
//import kotlinx.android.synthetic.main.activity_curl_landscape.fab3
//import kotlinx.android.synthetic.main.activity_curl_landscape.fab4
//import kotlinx.android.synthetic.main.activity_curl_landscape.fab5
//import kotlinx.android.synthetic.main.activity_curl_landscape.fab6
//import kotlinx.android.synthetic.main.activity_curl_landscape.fabLayout2
//import kotlinx.android.synthetic.main.activity_curl_landscape.fabLayout3
//import kotlinx.android.synthetic.main.activity_curl_landscape.fabLayout4
//import kotlinx.android.synthetic.main.activity_curl_landscape.fabLayout5
//import kotlinx.android.synthetic.main.activity_curl_landscape.fabLayout6
//import kotlinx.android.synthetic.main.activity_curl_landscape.fabLayout7
//import kotlinx.android.synthetic.main.activity_curl_landscape.imageview_slider_recyclerView
//import kotlinx.android.synthetic.main.activity_curl_landscape.progressBar
//import kotlinx.android.synthetic.main.activity_curl_landscape.progressBar_constraint
//import kotlinx.android.synthetic.main.activity_curl_landscape.progress_textView
//import kotlinx.android.synthetic.main.activity_curl_portrait.fab7
//import kotlinx.android.synthetic.main.activity_curl_portrait.fab_layout
//import kotlinx.android.synthetic.main.activity_curl_square.fabLayout1
//import java.io.*
//import java.lang.NullPointerException
//import java.lang.ref.SoftReference
//import java.net.HttpURLConnection
//import java.net.URL
//import java.util.*
//import kotlin.collections.ArrayList
//import kotlin.collections.HashMap
//import kotlin.collections.LinkedHashMap
//
//class CurlActivityOld : AppCompatActivity(), ImageDownloadCompleted, AlbumThumbnailDownloadCompletedListener, DownloadResultUpdateTaskListener, APIListener {
//
//    private var albumName: String? = null
//    private var clickedPositon: Int = 0
//    var albumId: Int? = null
//    var albumType: Int? = null
//    var lastUpdatedAt: Int? = null
//    internal var dbHelper: DbHelper? = null
//    internal var mContext: Context? = null
//    var k: Int = 0
//    var a = 1
//    var isShowAlbum = true
//    private var y: Bitmap? = null
//
//    var imageNames: Cursor? = null
//
//    var imageNamesArrayList = ArrayList<String>()
//    var imageNamesArrayListSize: Int = 0
//    var bitmapHashMap = LinkedHashMap<String, Bitmap>()
//    var bitmapHashMap1 = LinkedHashMap<String, SoftReference<Bitmap>>()
//    var totalUndownloadedImages: Int? = 1
//    var totalDownloadedImages: Int? = null
//
//    lateinit var curl: CurlView
//
//    private var isUp: Boolean = false
//
//    var imageArrayList = ArrayList<String>()
//
//    var mStateOfCurl: String = "0"
//    var currentIndexValue: Int = 0
//
//    var onBackPressedValue: Boolean = false
//
//    var mWakeLock: PowerManager.WakeLock? = null
//
//    internal var isFABOpen = false
//
//    var music: String? = null
//
//    var mPlayer: MediaPlayer? = null
//
//    var afd: AssetFileDescriptor? = null
//
//    var i = 0
//
//    var guideView1: Int = 0
//
//    //Merge Images variables
//    var bitmapImage: Bitmap? = null
//    var result: Bitmap? = null
//    var canvas: Canvas? = null
//    var image: File? = null
//    lateinit var albumSize: String
//    var folderPath: String? = null
//    var mergedBitmapImageNameArrayList = ArrayList<Bitmap>()
//    var musicPlay: Boolean = false
//    var length: Int = 0
//    var projectFolder: File? = null
//    var albumOrientation = 0
//    var eventsRandomId: String? = null
//    var eventsPasscode: Int = 0
//    var eventsUrl: String? = null
//    var eventsType: Int = 0
//    var eventId: Int? = null
//    var isAlbumVisible: Boolean = false
//    var orientation: String? = null
//    var insufficientStorage: Boolean = true
//    var numberOfHalfImages = 0
//    var totalAlbumPaperSize = 0
//    var albumImagesMap = LinkedHashMap<String, ArrayList<String>>()
//    var isActivityForeground: Boolean = true
//    var tmp: Bitmap? = null
//    var b: Bitmap? = null
//    var curlViewGoneThread: Thread? = null
//    var cache: BitmapImageCache? = null
//
//    var imageCache1: ImageCache1? = null
//
//    var imageDecodeImage: ImageDecodeImage? = null
//
//    var curlViewWidth: Int? = null
//
//    var curlViewHeight: Int? = null
//
//    var sampleBitmap: Bitmap? = null
//
//    var isMusicStopped: Boolean = false
//
//    @SuppressLint("ClickableViewAccessibility", "InvalidWakeLockTag")
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//
//        //Couldn't Capture Screenshot
//        if (!IS_LOG_ENABLED) {
//            window.setFlags(WindowManager.LayoutParams.FLAG_SECURE,
//                WindowManager.LayoutParams.FLAG_SECURE)
//        }
//
//        albumName = if (intent.hasExtra("albumName")) {
//            intent.extras!!.getString("albumName")
//        } else {
//            ""
//        }
//
//        eventId = if (intent.hasExtra("eventId")) {
//            intent.extras!!.getInt("eventId")
//        } else {
//            0
//        }
//
//        albumId = if (intent.hasExtra("albumId")) {
//            intent.extras!!.getInt("albumId")
//        } else {
//            1
//        }
//
//        albumType = if (intent.hasExtra("albumType")) {
//            intent.extras!!.getInt("albumType")
//        } else {
//            1
//        }
//
//        lastUpdatedAt = if (intent.hasExtra("updatedAt")) {
//            intent.extras!!.getInt("updatedAt")
//        } else {
//            1
//        }
//
//        music = if (intent.hasExtra("music")) {
//            intent.extras!!.getString("music")
//        } else {
//            ""
//        }
//
//        albumSize = if (intent.hasExtra("albumSize")) {
//            intent?.extras?.getString("albumSize")!!
//        } else {
//            ""
//        }
//
//        eventsRandomId = if (intent.hasExtra("eventsRandomId")) {
//            intent?.extras?.getString("eventsRandomId")
//        } else {
//            ""
//        }
//
//        eventsPasscode = if (intent.hasExtra("eventsPasscode")) {
//            intent.extras!!.getInt("eventsPasscode")
//        } else {
//            1
//        }
//
//        eventsUrl = if (intent.hasExtra("eventUrl")) {
//            intent?.extras?.getString("eventUrl")
//        } else {
//            ""
//        }
//
//        eventsType = if (intent.hasExtra("eventType")) {
//            intent.extras!!.getInt("eventType")
//        } else {
//            WebConstants.STUDIO_GALLERY_EVENT
//        }
//
//        albumOrientation = if (intent.hasExtra("orientation")) {
//            when {
//                intent?.extras?.getString("orientation")!! == "Landscape" -> {
//                    orientation = "Landscape"
//                    1 //landscape
//                }
//                intent?.extras?.getString("orientation")!! == "Portrait" -> {
//                    orientation = "Portrait"
//                    2 //portrait
//                }
//                else -> {
//                    orientation = "Square"
//                    3 //square
//                }
//            }
//        } else {
//            3
//        }
//
//        //DLog("CurlActivityOld :", "randomId:$eventsRandomId : pass:$eventsPasscode $eventsUrl , ori:$orientation : ")
//        DLog("CurlActivityOld :", "EventUrl:$eventsUrl :: ori:$orientation ")
//        DLog("CurlActivityOld :", "albumName: $albumName")
//        DLog("CurlActivityOld :", "eventId: $eventId")
//        DLog("CurlActivityOld :", "albumId: $albumId")
//        DLog("CurlActivityOld :", "albumType: $albumType")
//        DLog("CurlActivityOld :", "lastUpdatedAt: $lastUpdatedAt")
//        DLog("CurlActivityOld :", "music: $music")
//        DLog("CurlActivityOld :", "albumSize: $albumSize")
//        DLog("CurlActivityOld :", "eventsUrl: $eventsUrl")
//        DLog("CurlActivityOld :", "eventsType: $eventsType")
//        DLog("CurlActivityOld :", "albumOrientation: $albumOrientation")
//
//        when (albumOrientation) {
//            1 -> setContentView(R.layout.activity_curl_landscape)
//            2 -> setContentView(R.layout.activity_curl_portrait)
//            else -> setContentView(R.layout.activity_curl_square)
//        }
//
//        mContext = this@CurlActivityOld
//
//        dbHelper = DbHelper(this)
//
//        val cacheParams = ImageCache1.ImageCacheParams(this, ".images/ai")
//
//        /*if (dbHelper?.getAlbumStorageSize(albumId!!)!! != 0) {
//            cacheParams.setDiskCacheSizePercent((dbHelper?.getAlbumStorageSize(albumId!!)!! * 2))
//        }*/
//
//        cacheParams.setDiskCacheSizePercent(20)
//
//        imageCache1 = ImageCache1(cacheParams)
//        CacheAsyncTask().execute(MESSAGE_INIT_DISK_CACHE)
//
//        //saveWidthAndHeightInPreference()
//
//        curl = findViewById(R.id.curl_view)
//
//        isMusicStopped = getBooleanPreference(mContext!!, SharedPreferenceConst.isMusicStopped, false)
//
//        //getCurlActivityData()
//
//        //projectFolder = File(this.getExternalFilesDir(null)?.absolutePath, this.getString(R.string.main_folder_name))
//        projectFolder = File("${applicationContext.applicationInfo.dataDir}/app_flutter")
//
//        progressBar!!.progressDrawable.setColorFilter(
//            ContextCompat.getColor(mContext!!, R.color.white), PorterDuff.Mode.SRC_IN)
//
//        val sizeArray = albumSize.split("x").toTypedArray()
//
//        sizeArray.forEach {
//            DLog("CurlActivity: ", "sizeArray: $it")
//        }
//
//        DLog("ratio", "${sizeArray.size} ${sizeArray[0]} ")
//
//        val width = sizeArray[0].toInt()
//        val height = sizeArray[1].toInt()
//        calculateRatio(width, height)
//
//        DLog("ratio", "$width,$height")
//        clickedPositon = 1
//
//        curl.currentIndex = 0
//
//        curl.setOnClickListener {
//            DLog("Curl", "Curl")
//        }
//
//        isUp = false
//
//        imageview_slider_recyclerView.visibility = View.INVISIBLE
//
//        //DLog("imageview_slider_recyclerView :", "${dbHelper!!.isOriginalsDownload(albumId!!)}")
//        fab.setOnClickListener {
//            if (!isFABOpen) {
//                DLog("is album opened", "opened")
//                isFABOpen = true
//                if (albumOrientation == 1) {
//                    showFABMenuIfLandscape()
//
//                } else {
//                    showFABMenu()
//                }
//                if (getIntPreference(this, SharedPreferenceConst.GUIDEVIEW_COMPLETED_ALBUM_LANDSCAPE) == 1) {
//                    //GuideView Function
//                    getSequence().show()
//                    setIntPreference(this, SharedPreferenceConst.GUIDEVIEW_COMPLETED_ALBUM_LANDSCAPE, 2)
//                }
//                fab.setImageDrawable(ContextCompat.getDrawable(mContext!!, R.drawable.ic_close_menu_24dp))
//            } else {
//                DLog("is album opened", "closed")
//                slideDown(imageview_slider_recyclerView)
//                isUp = !isUp
//                isFABOpen = false
//                if (albumOrientation == 1) {
//                    closeFABMenuIfLandscape()
//                } else {
//                    closeFABMenu()
//                }
//                fab.setImageDrawable(ContextCompat.getDrawable(mContext!!, R.drawable.ic_menu))
//            }
//        }
//
//        back_arrow_fab.setOnClickListener {
//            this.finish()
//        }
//
//        fab1.setOnClickListener {
//            DLog("isUpzzz", "${isUp}")
//            if (isUp) {
//                DLog("isUp", "onPause  if")
//                slideDown(imageview_slider_recyclerView)
//            } else {
//                DLog("isDown", "onPause  else")
//                slideUp(imageview_slider_recyclerView)
//            }
//            isUp = !isUp
//        }
//
//        val vto = curl_view.getViewTreeObserver()
//        vto.addOnPreDrawListener(object : ViewTreeObserver.OnPreDrawListener {
//            override fun onPreDraw(): Boolean {
//                curl_view.getViewTreeObserver().removeOnPreDrawListener(this)
//                curlViewHeight = curl_view.getMeasuredHeight()
//                curlViewWidth = curl_view.getMeasuredWidth() / 2
//                DLog("CurlActivity :", "addOnPreDrawListener() CURL: W : ${curlViewWidth!! / 2} : $curlViewHeight")
//                sampleBitmap = Bitmap.createBitmap(curlViewWidth!!, curlViewHeight!!, Bitmap.Config.ARGB_8888)
//                //var bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
//                var canvas = Canvas(sampleBitmap!!)
//                var paint = Paint()
//                paint.color = Color.WHITE
//                canvas.drawRect(0F, 0F, curlViewWidth!!.toFloat(), curlViewHeight!!.toFloat(), paint)
//
//                //val conf = Bitmap.Config.ARGB_8888 // see other conf types
//                //sampleBitmap = Bitmap.createBitmap(curlViewWidth!!, curlViewHeight!!, conf)
//
//                return true
//            }
//        })
//
//        fab2.setOnClickListener {
//            val vto = curl_view.getViewTreeObserver()
//            vto.addOnPreDrawListener(object : ViewTreeObserver.OnPreDrawListener {
//                override fun onPreDraw(): Boolean {
//                    curl_view.getViewTreeObserver().removeOnPreDrawListener(this)
//                    val height = curl_view.getMeasuredHeight()
//                    val width = curl_view.getMeasuredWidth()
//                    DLog("ViewEventAlbumsAdapter :", "inside bind onGlobalLayout $width : $height")
//
//                    val dialog = ZoomImageDialogFragment()
//                    val bundle = Bundle()
//                    bundle.putInt("arraylist_size", imageNamesArrayListSize)
//                    bundle.putInt("width", width)
//                    bundle.putInt("height", height)
//                    bundle.putInt("typeOfScreen", 1)   // 1-->curl activity , 2--> GalleryCurl activity
//                    dialog.arguments = bundle
//                    dialog.show(supportFragmentManager, "image")
//                    return true
//                }
//            })
//        }
//
//        fab3.setOnClickListener {
//            loadNextPageWithFlipAnimationRightToLeft()
//        }
//
//        fab4.setOnClickListener {
//            loadNextPageWithFlipAnimationLeftToRight()
//        }
//
//        if (isMusicStopped) {
//            fab5.setImageResource(R.drawable.ic_music_stop_note_black_24dp)
//            i = 2
//        } else {
//            fab5.setImageResource(R.drawable.ic_music_note_black_24dp)
//            i = 0
//        }
//
//        fab5.setOnClickListener {
//            try {
//                DLog("setOnClickListener", "${i}")
//                if (i == 0) {
//                    fab5.setImageResource(R.drawable.ic_music_stop_note_black_24dp)
//                    DLog("CurlActivitysetOnClickListener", "MusicStopped")
//                    mPlayer?.pause()
//                    i = 2
//                    setBooleanPreference(mContext!!, SharedPreferenceConst.isMusicStopped, true)
//                } else if (i == 2) {
//                    fab5.setImageResource(R.drawable.ic_music_note_black_24dp)
//                    DLog("CurlActivitysetOnClickListener", "MusicOn")
//                    mPlayer?.start()
//                    i = 0
//                    setBooleanPreference(mContext!!, SharedPreferenceConst.isMusicStopped, false)
//                }
//            } catch (e: Exception) {
//            }
//        }
//
//        fab6.setOnClickListener {
//            DLog("ShowHelpInCur", "${albumOrientation}")
//            if (albumOrientation == 1)
//                getSequence2(1).show()
//            else
//                getSequence2(2).show()
//        }
//
//        fab7.setOnClickListener {
//            if (eventsType == WebConstants.DEMO_EVENT || eventsType == WebConstants.STUDIO_GALLERY_EVENT) {
//                Share.app(this, this)
//            } else {
//                //Share.event(this@CurlActivityOld, this, eventsUrl!!, eventId!!,  0, "")
//            }
//        }
//        DLog("CurlActivity : ", "end of the onCreate()")
//    }
//
//    fun setImagesInImageArrayList1() { //
//        imageNames = dbHelper?.getClickedAlbumImages(albumId!!)
//        DLog("CurlActivityLandscape : ", "inside setImagesInImageArrayList ${DatabaseUtils.dumpCursorToString(imageNames)}")
//        imageNamesArrayList.clear()
//        albumImagesMap.clear()
//
//        try {
//            if (imageNames?.count!! > 0) {
//                if (imageNames!!.moveToFirst()) {
//                    do {
//                        imageNamesArrayList.add(imageNames!!.getString(0))
//                        if (imageNames!!.getString(1) in albumImagesMap.keys) {
//                            if (getImageName(imageNames!!.getString(0)).endsWith("a")) {
//                                albumImagesMap[imageNames!!.getString(1)]!!.set(0, imageNames!!.getString(0))
//                            } else {
//                                albumImagesMap[imageNames!!.getString(1)]!!.set(1, imageNames!!.getString(0))
//                            }
//                        } else {
//                            val newList = ArrayList<String>()
//                            if (getImageName(imageNames!!.getString(0)).endsWith("a")) {
//                                newList.add(0, imageNames!!.getString(0))
//                                newList.add(1, "")
//                            } else {
//                                newList.add(0, "")
//                                newList.add(1, imageNames!!.getString(0))
//                            }
//                            albumImagesMap[imageNames!!.getString(1)] = newList
//                        }
//                        DLog("CurlActivity: ", "albumImagesMap8 : ${Gson().toJson(albumImagesMap)}")
//
//                    } while (imageNames!!.moveToNext())
//                }
//            }
//        } catch (e: CursorIndexOutOfBoundsException) {
//        }
//
//        DLog("CurlActivity: ", "albumImagesMap : ${Gson().toJson(albumImagesMap)}")
//
//        imageNamesArrayListSize = imageNamesArrayList.size
//
//        try {
//            val index = imageNamesArrayList.indexOf(imageNamesArrayList[0])
//            val index1 = imageNamesArrayList[0]
//            imageNamesArrayList.removeAt(index)
//            imageNamesArrayList.add(imageNamesArrayList.size, index1)
//        } catch (e: IndexOutOfBoundsException) {
//            DLog("CurlActivity:", e.message.toString())
//        }
//
//        totalAlbumPaperSize = dbHelper!!.getCountOfTotalAlbumPages(albumId!!)
//
//        DLog("totalAlbumPaperSizecurl:", "${totalAlbumPaperSize}")
//    }
//
//    private fun calculateRatio(width: Int, height: Int) {
//        val metrics: DisplayMetrics = this.resources.displayMetrics
//        if (metrics.widthPixels > metrics.heightPixels) {
//            (curl_view.layoutParams as ConstraintLayout.LayoutParams).dimensionRatio = "$width:$height"
//        } else {
//            (curl_view.layoutParams as ConstraintLayout.LayoutParams).dimensionRatio = "$height:$width"
//        }
//    }
//
//    override fun onStart() {
//        super.onStart()
//        DLog("On Start", "On start")
//        onStartContent()
//    }
//
//    private fun onStartContent() {
//        // original -> 27s 68ms , thumb -> 8s 41ms (56)
//        val lastUpdatedAt = dbHelper?.getLastUpdatedAtInAlbum(albumId!!)
//
//        if (lastUpdatedAt != 0) {
//            DLog("CurlActivity: ", "onStartContent() step 1")
//            if (dbHelper?.isAllImagesDownloaded(albumId!!)!!) {
//                DLog("CurlActivity: ", "onStartContent() step 2")
//                activity_curl_studioLogo_imageView.visibility = View.VISIBLE
//                //getMergedImageNameArrayList()
//                if (Network_check.isNetworkAvailable(this)) {
//                    DLog("CurlActivity: ", "onStartContent() step 21")
//                    startAlbumUpdateWorker(lastUpdatedAt!!)
//                }
//                checkForExistingAlbumImages(lastUpdatedAt!!)
//                DLog("CurlActivity: ", "onStartContent() step 3")
//            } else {
//                DLog("CurlActivity: ", "onStartContent() step 4")
//                if (Network_check.isNetworkAvailable(this)) {
//                    DLog("CurlActivity: ", "onStartContent() step 5")
//                    checkImages()
//                    //startAlbumUpdateWorker(lastUpdatedAt!!)
//                    DLog("CurlActivity: ", "onStartContent() step 6")
//                } else {
//                    DLog("CurlActivity: ", "onStartContent() step 7")
//                    //checkInternet()
//                    checkImages()
//                    listenNetworkState()
//                    Others.showAlertSnackbar(this, getString(R.string.try_to_connect))
//                    DLog("CurlActivity: ", "onStartContent() step 8")
//                }
//                DLog("CurlActivity: ", "onStartContent() step 9")
//            }
//            DLog("CurlActivity: ", "onStartContent() step 10")
//        } else if (Network_check.isNetworkAvailable(this)) {
//            DLog("CurlActivity: ", "onStartContent() step 11")
//            progressBar_constraint.visibility = View.GONE
//            callApiForGetAlbumImages(lastUpdatedAt, true)
//        } else {
//            DLog("CurlActivity: ", "onStartContent() step 12")
//            checkInternet()
//        }
//    }
//
//    private fun listenNetworkState() {
//        NetworkConnectionLiveData(applicationContext).observe(this, Observer {
//            if (it.isConnected) {
//                Others.showNormalSnackbar(this, "Back to online")
//                onStartContent()
//            }
//        })
//    }
//
//    private fun startAlbumUpdateWorker(lastUpdatedAt: Int) {
//        val updateAlbumWorkerData = Data.Builder()
//            .putInt(Api.KEY_ALBUM_ID, albumId!!)
//            .putString(Api.LAST_UPDATED_AT, lastUpdatedAt.toString())
//            .putBoolean(Api.IS_COME_FROM_GALLERY, false)
//            .build()
//
//        val getUnDownloadedImageUrlworkerData = Data.Builder()
//            .putInt(Api.EVENT_OR_ALBUM_ID, albumId!!)
//            .putInt(Api.PAGE_STATUS, 2)
//            .putBoolean(Api.INSUFFICIENT_STORAGE, insufficientStorage)
//            .build()
//
//        val firstWorkrequest = OneTimeWorkRequest.Builder(UpdateAlbumImagesWorker::class.java)
//            .setInputData(updateAlbumWorkerData)
//            .build()
//
//        val secondWorkManager = OneTimeWorkRequest.Builder(GetUnDownloadedImageUrlworker::class.java)
//            .setInputData(getUnDownloadedImageUrlworkerData)
//            .addTag(Api.UPDATE_ALBUM_WORKER_OUTPUT_DATA)
//            .build()
//
//        val workManager = WorkManager.getInstance()
//        workManager.beginWith(firstWorkrequest).then(secondWorkManager).enqueue()
//
//        workManager.getWorkInfoByIdLiveData(firstWorkrequest.id).observe(this, Observer {
//            DLog("CurlActivityWorker", "${it}")
//            val stateValue = it!!.state
//
//            if (stateValue == null)
//                return@Observer
//
//            val successOutputData = it.outputData
//            when (stateValue) {
//                WorkInfo.State.SUCCEEDED -> {
//                    when (successOutputData.getInt(Api.UPDATE_ALBUM_WORKER_OUTPUT_DATA, 0)) {
//                        4 -> {
//                            insufficientStorage = false
//                            showStorageError()// dont call refresh image url
//                        }
//                        else -> {
//                            insufficientStorage = true // call refresh image url
//
//                        }
//                    }
//                }
//                WorkInfo.State.FAILED -> {
//                }
//                else -> {
//                }
//            }
//        })
//
//        workManager.getWorkInfoByIdLiveData(secondWorkManager.id).observe(this, Observer {
//            DLog("CurlActivityImagesDownloadWorker", "$it")
//            val workInfo = it!!.state
//            if (workInfo == null)
//                return@Observer
//            val successOutputData = it.outputData
//            when (workInfo) {
//                WorkInfo.State.SUCCEEDED -> {
//                    when (successOutputData.getInt(Api.UPDATE_IMAGES_WORKER_OUTPUT_DATA, 0)) {
//                        1 -> {
//                            DLog("CurlActivityCheckImgas", "CurlActivityCheckImgas")
//                            checkImages()
//                        }
//                        2 -> {
//
//                        }
//                        3 -> {
//
//                        }
//                        4 -> {
//                            insufficientStorage = false
//                            showStorageError()// dont call refresh image url
//                        }
//                        5 -> {
//
//                        }
//                        else -> {
//                            insufficientStorage = true
//                        }
//                    }
//                }
//                WorkInfo.State.FAILED -> {
//
//                }
//                else -> {
//
//                }
//            }
//        })
//    }
//
//    private fun callApiForGetAlbumImages(lastUpdatedAt: Int, visibleProgress: Boolean) {
//        val hashMap = HashMap<String, String>()
//        hashMap[Api.KEY_ALBUM_ID] = albumId.toString()
//        hashMap[Api.KEY_LAST_UPDATED_AT] = lastUpdatedAt.toString()
//        //hashMap.put(Api.KEY_LAST_UPDATED_AT, "0")
//        APICall(this).APIRequest(ApiUrls.UPDATE_ALBUM, hashMap, EventAlbumImagesResult::class.java, this, 1, "", visibleProgress)
//    }
//
//    override fun onSuccess(from: Int, response: Any) {
//
//        when (from) {
//            1 -> {
//                val result = Gson().toJson(response)
//                if (isAvailableExternalMemorySize(this, InsertAlbums.getAlbumSize(Gson().toJson(response)))) {
//                    InsertAlbums.updateAlbumImages(Gson().toJson(response), dbHelper!!, projectFolder!!)
//                    checkImages()
//                } else {
//                    showStorageError()
//                }
//            }
//            2 -> {
//                val result = response as RefreshImageUrl
//                DLog("DownloadImagesActivity :", "inside onSuccess 1")
//                result.data.images.forEach {
//                    if (it.status == "success") {
//                        DLog("USER_ALBUMS :", " ${it.id} ${it.type}")
//                        if (it.type == 2) {
//                            dbHelper?.insertRefreshedAlbumImagesAndEventCoverImageUrl(it.id, it.detail.original_url, it.detail.thumb_url)
//                        }
//                    } else {
//                        if (it.type == 12 || it.type == 2) { // album and event cover images
//                            dbHelper?.deleteAlbumImagesAndEventCoverImage(it.id)
//                        }
//                    }
//                }
//                //recreate()
//                val intent = Intent(mContext, CurlActivity::class.java)
//                intent.putExtra("albumName", albumName)
//                intent.putExtra("eventId", eventId)
//                intent.putExtra("albumId", albumId)
//                intent.putExtra("albumType", albumType)
//                intent.putExtra("updatedAt", lastUpdatedAt)
//                intent.putExtra("music", music)
//                intent.putExtra("albumSize", albumSize)
//                intent.putExtra("eventUrl", eventsUrl)
//                intent.putExtra("eventType", eventsType)
//                intent.putExtra("orientation", orientation)
//
//                /*intentViewSingleAlbum.putExtra("album_id", albumId!!)
//                intentViewSingleAlbum.putExtra("albumName", albumName)
//                intentViewSingleAlbum.putExtra("music", music)
//                intentViewSingleAlbum.putExtra("album_size", albumSize)
//                intentViewSingleAlbum.putExtra("album_type", albumType)
//                intentViewSingleAlbum.putExtra("updated_at", lastUpdatedAt)
//                intentViewSingleAlbum.putExtra("orientation", orientation)
//                intentViewSingleAlbum.putExtra("eventsRandomId", eventsRandomId)
//                intentViewSingleAlbum.putExtra("eventsPasscode", eventsPasscode)
//                intentViewSingleAlbum.putExtra("eventsUrl", eventsUrl)
//                intentViewSingleAlbum.putExtra("eventType", eventsType)
//                intentViewSingleAlbum.putExtra("eventId", eventId)*/
//                startActivity(intent)
//                finish()
//            }
//        }
//    }
//
//    private fun showStorageError() {
//        if (isAlbumVisible) { // show update
//            AlertDialog.Builder(this, R.style.AlertDialogTheme).setTitle(getString(R.string.unable_to_download_album)).setMessage(getString(R.string.unable_to_download_updated_album_message))
//                .setCancelable(false)
//                .setPositiveButton(resources.getString(R.string.retry)) { dialog, which ->
//                    onStartContent()
//                }
//                .setNegativeButton(resources.getString(R.string.cancel)) { dialog, which ->
//                    dialog.dismiss()
//                }.show()
//        } else {
//            AlertDialog.Builder(this, R.style.AlertDialogTheme).setTitle(getString(R.string.unable_to_download_album)).setMessage(getString(R.string.unable_to_download_album_message))
//                .setCancelable(false)
//                .setPositiveButton(resources.getString(R.string.retry)) { dialog, which ->
//                    onStartContent()
//                }
//                .setNegativeButton(resources.getString(R.string.cancel)) { dialog, which ->
//                    dialog.dismiss()
//                    closeActivity()
//                }.show()
//        }
//    }
//
//    fun closeActivity() = finish()
//
//    override fun onFailure(from: Int, response: Any) {}
//
//    override fun onNetworkFailure(from: Int) {}
//
//    // Get album category for display in Page.
//    @SuppressLint("InvalidWakeLockTag")
//    private fun checkImages() {
//        DLog("checkImages", "${dbHelper?.getAlbumStorageSize(albumId!!)!!}")
//        if (!dbHelper?.isOriginalsDownloadInAlbum(albumId!!)!!) {
//            DLog("CurlActivityLandscape: ", "inside isOriginalsDownloadInSingleAlbum if 1")
//            if (Network_check.isNetworkAvailable(this)) {
//                val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
//                mWakeLock = pm?.newWakeLock(PowerManager.SCREEN_DIM_WAKE_LOCK, "MyTag")
//                mWakeLock?.acquire()
//            } // not lock if download images are not downloaded
//        }
//
//        if (!dbHelper!!.isTemporaryUrlAvailable(albumId!!)) {
//            DLog("CurlActivity: ", "checkImages inside if")
//            if(albumType == WebConstants.STUDIO_GALLERY_ALBUMS) {
//                setOrignakUrlForGalleryAlbumImages()
//            }else{
//                APICallForJson(this).APIRequestForJson(ApiUrls.REFRESH_IMAGE_URL, getJsonObject(), RefreshImageUrl::class.java, this, 2)
//            }
//        } else {
//            DLog("CurlActivity: ", "checkImages inside if else  -- ${dbHelper?.getAlbumStorageSize(albumId!!)}")
//            setImagesInImageArrayList1()
//            if (Others.isAbleToViewAlbumWithOriginalImages(this, dbHelper?.getAlbumStorageSize(albumId!!)!!)) {
//                getModelList()
//            } else {
//                showStorageError()
//            }
//            downloadOriginalAlbumImages()
//        }
//        DLog("Step", "3ii")
//        DLog("Step", "8")
//    }
//
//    private fun getJsonObject(): JsonObject {
//        return GetUnDownloadedImages.getJson(dbHelper!!, albumId!!)
//    }
//
//    @SuppressLint("Range")
//    private fun setOrignakUrlForGalleryAlbumImages(){
//        val albumImagesCursor = dbHelper!!.getAlbumImages(albumId!!)
//        if(albumImagesCursor.count > 0 && albumImagesCursor.moveToFirst()){
//            do{
//                val url = Others.getPublicUrlForGallery(albumId!!, getImageName(albumImagesCursor.getString(albumImagesCursor.getColumnIndex(DBStatics.imageName))))
//                dbHelper?.insertRefreshedAlbumImagesAndEventCoverImageUrl(albumImagesCursor.getInt(albumImagesCursor.getColumnIndex(DBStatics.imageId)), url, "")
//            }while (albumImagesCursor.moveToNext())
//        }
//
//        val intent = Intent(mContext, CurlActivity::class.java)
//        intent.putExtra("albumName", albumName)
//        intent.putExtra("eventId", eventId)
//        intent.putExtra("albumId", albumId!!)
//        intent.putExtra("albumType", albumType)
//        intent.putExtra("updatedAt", lastUpdatedAt)
//        intent.putExtra("music", music)
//        intent.putExtra("albumSize", albumSize)
//        intent.putExtra("eventUrl", eventsUrl)
//        intent.putExtra("eventType", eventsType)
//        intent.putExtra("orientation", orientation)
//        startActivity(intent)
//        finish()
//    }
//
//    private fun downloadOriginalAlbumImages() {
//        val cursor: Cursor? = dbHelper!!.getSingleAlbumOriginalPhotoUrl(albumId!!)
//        DLog("CurlActivity:", "downloadOriginalAlbumImages() : ${DatabaseUtils.dumpCursorToString(cursor)}")
//        if (cursor != null && cursor.count == 0) {
//            if (albumOrientation == 1) {
//                setInvisibleProgressBarIfLandscape()
//            } else {
//                setInvisibleProgressBar()
//            }
//        } else {
//            progressBar_constraint.visibility = View.VISIBLE
//            activity_curl_studioLogo_imageView.visibility = View.INVISIBLE
//            Handler().postDelayed({
//                if (Network_check.isNetworkAvailable(this)) {
//                    progress_textView.text = "0%"
//                    cursor?.moveToFirst()
//                    DLog("DownloadImages in CL: ", "${cursor?.getString(0)}")
//                    do {
//                        DLog("CurlActivity: inside do while", "${cursor?.getString(0)}")
//                        val drUpdateTask = DownloadResultUpdateTask(this)
//                        val downloadTask = DownloadTask(cursor?.getString(0)!!, 2, this, drUpdateTask)
//                        DownloadManager.downloadManager?.runDownloadFile(downloadTask)
//                    } while (cursor!!.moveToNext())
//                } else {
//                    noInternetConnection()
//                }
//            }, 1000)
//        }
//    }
//
//    // If all images are download, get list for set page that goes to ImageForAlbum
//    private fun getModelList1() {
//        try {
//            var i = 1
//            if (isShowAlbum) {
//                imageArrayList.clear()
//                DLog("CurlActivty:", "inside getModelList: [${imageNamesArrayList.size}]")
//                //for ((index, value) in imageNamesArrayList.withIndex()) {
//                for ((index, value) in imageNamesArrayList.withIndex()) {
//                    DLog("CurlActivty:", "inside getModelList: ${imageNamesArrayList.get(index)} [$i]")
//                    i = i.plus(1)
//                    val imageName = imageNamesArrayList.get(index)
//                    var file: File? = null
//
//                    if (imageNamesArrayList.size <= 4) {
//                        if (index == 0 || index == imageNamesArrayList.size - 1) {
//                            if (File(getExternalFilesDir(null)?.toString(), getString(R.string.main_folder_name) + "/" + imageName).exists()) {
//                                file = File(getExternalFilesDir(null)?.toString(), getString(R.string.main_folder_name) + "/" + imageName)
//                            }
//                            if (file != null) {
//                                val tmp = getBitmapFromFile(file, mContext!!)
//                                imageCache1?.addBitmapToCache(imageName, tmp)
//                            } else {
//                                when (albumOrientation) {
//                                    1 -> imageCache1?.addBitmapToCache(imageName, BitmapFactory.decodeResource(resources, R.drawable.image_load_landscape))
//                                    2 -> imageCache1?.addBitmapToCache(imageName, BitmapFactory.decodeResource(resources, R.drawable.image_load_portrait))
//                                    else -> imageCache1?.addBitmapToCache(imageName, BitmapFactory.decodeResource(resources, R.drawable.image_load_square))
//                                }
//                            }
//                        }
//                    } else if (index == 0) {
//                        if (File(getExternalFilesDir(null)?.toString(), getString(R.string.main_folder_name) + "/" + imageName).exists()) {
//                            file = File(getExternalFilesDir(null)?.toString(), getString(R.string.main_folder_name) + "/" + imageName)
//                        }
//                        if (file != null) {
//                            val tmp = getBitmapFromFile(file, mContext!!)
//                            imageCache1?.addBitmapToCache(imageName, tmp)
//                        } else {
//                            when (albumOrientation) {
//                                1 -> imageCache1?.addBitmapToCache(imageName, BitmapFactory.decodeResource(resources, R.drawable.image_load_landscape))
//                                2 -> imageCache1?.addBitmapToCache(imageName, BitmapFactory.decodeResource(resources, R.drawable.image_load_portrait))
//                                else -> imageCache1?.addBitmapToCache(imageName, BitmapFactory.decodeResource(resources, R.drawable.image_load_square))
//                            }
//                        }
//                    } else {
//                        when (albumOrientation) {
//                            1 -> imageCache1?.addBitmapToCache(imageName, BitmapFactory.decodeResource(resources, R.drawable.image_load_landscape))
//                            2 -> imageCache1?.addBitmapToCache(imageName, BitmapFactory.decodeResource(resources, R.drawable.image_load_portrait))
//                            else -> imageCache1?.addBitmapToCache(imageName, BitmapFactory.decodeResource(resources, R.drawable.image_load_square))
//                        }
//                    }
//                }
//
//                DLog("Step", "4")
//                fillPage()
//                imageDecodeImage = ImageDecodeImage()
//                imageDecodeImage?.execute("")
//                DLog("Step", "7")
//            }
//        } catch (e: OutOfMemoryError) {
//            DLog("CurlActivity : ", "error : ${e.message}")
//        } catch (e: NullPointerException) {
//            DLog("CurlActivity  : ", "error : 'int android.graphics.Bitmap.getWidth() : ${e.message}")
//            getModelList()
//        }
//    }
//
//    private fun getModelList() {
//        try {
//            var i = 1
//            if (isShowAlbum) {
//                imageArrayList.clear()
//                DLog("CurlActivty:", "inside getModelList: [${imageNamesArrayList.size}]")
//                //for ((index, value) in imageNamesArrayList.withIndex()) {
//                for ((index, value) in imageNamesArrayList.withIndex()) {
//                    DLog("CurlActivty:", "inside getModelList: ${imageNamesArrayList.get(index)} [$i]")
//                    i = i.plus(1)
//                    val imageName = imageNamesArrayList.get(index)
//                    var file: File? = null
//
//                    if (imageNamesArrayList.size <= 4) {
//                        if (index == 0 || index == imageNamesArrayList.size - 1) {
//                            /*if (File(getExternalFilesDir(null)?.toString(), getString(R.string.main_folder_name) + "/" + imageName).exists()) {
//                                file = File(getExternalFilesDir(null)?.toString(), getString(R.string.main_folder_name) + "/" + imageName)
//                            }*/
//                            file = getFile(imageName)
//                            if (file.exists()) {
//                                val tmp = getBitmapFromFile(file, mContext!!)
//                                imageCache1?.addBitmapToCache(imageName, tmp)
//                            } else {
//                                getLoadingBitmapBasedOnOrientation(imageName)
//                            }
//                        }
//                    } else if (index == 0) {
//                        /*if (File(getExternalFilesDir(null)?.toString(), getString(R.string.main_folder_name) + "/" + imageName).exists()) {
//                            file = File(getExternalFilesDir(null)?.toString(), getString(R.string.main_folder_name) + "/" + imageName)
//                        }*/
//                        file = getFile(imageName)
//                        /*val applicationDirectory = applicationContext.applicationInfo.dataDir
//                        file = File("$applicationDirectory/$imageName")*/
//                        if (file.exists()) {
//                            DLog("CurlActivity: ","getModelList() if")
//                            val tmp = getBitmapFromFile(file, mContext!!)
//                            imageCache1?.addBitmapToCache(imageName, tmp)
//                        } else {
//                            DLog("CurlActivity: ","getModelList() if else")
//                            getLoadingBitmapBasedOnOrientation(imageName)
//                        }
//                    } else {
//                        getLoadingBitmapBasedOnOrientation(imageName)
//                    }
//                }
//
//                DLog("Step", "4")
//                fillPage()
//                imageDecodeImage = ImageDecodeImage()
//                imageDecodeImage?.execute("")
//                DLog("Step", "7")
//            }
//        } catch (e: OutOfMemoryError) {
//            DLog("CurlActivity : ", "error : ${e.message}")
//        } catch (e: NullPointerException) {
//            DLog("CurlActivity  : ", "error : 'int android.graphics.Bitmap.getWidth() : ${e.message}")
//            getModelList()
//        }
//    }
//
//    private fun getLoadingBitmapBasedOnOrientation(imageName: String) {
//        when (albumOrientation) {
//            1 -> imageCache1?.addBitmapToCache(imageName, BitmapFactory.decodeResource(resources, R.drawable.image_load_landscape))
//            2 -> imageCache1?.addBitmapToCache(imageName, BitmapFactory.decodeResource(resources, R.drawable.image_load_portrait))
//            else -> imageCache1?.addBitmapToCache(imageName, BitmapFactory.decodeResource(resources, R.drawable.image_load_square))
//        }
//    }
//
//    fun getResizedBitmap(bitmap: Bitmap): Bitmap {
//        val metrics = DisplayMetrics()
//        (this).getWindowManager().getDefaultDisplay().getMetrics(metrics)
//        val screenWidth = metrics.widthPixels
//        val screenHeight = metrics.heightPixels
//        return Bitmap.createScaledBitmap(bitmap, screenWidth, screenHeight, true)
//    }
//
//    fun method1() {
//        var originalName: String
//        for ((index, value) in imageNamesArrayList.withIndex()) {
//            DLog("CurlActivity:", "inside getModelList1: ${imageNamesArrayList.get(index)}")
//            val imageName = imageNamesArrayList.get(index)
//
//            //val file = File(getExternalFilesDir(null)?.toString(), getString(R.string.main_folder_name) + "/" + imageName)
//            val file = getFile(imageName)
//
//            val options = BitmapFactory.Options()
//            options.inSampleSize = 2
//            val bitmap = BitmapFactory.decodeStream(file.inputStream(), null, options)
//            bitmapHashMap.put(imageName, getResizedBitmap(bitmap!!))
//        }
//        fillPage()
//    }
//
//    fun scaleDown(realImage: Bitmap, maxImageSize: Float, filter: Boolean): Bitmap {
//        val ratio = Math.min(maxImageSize / realImage.width, maxImageSize / realImage.height)
//        val width = Math.round(ratio * realImage.width)
//        val height = Math.round(ratio * realImage.height)
//        val newBitmap = Bitmap.createScaledBitmap(realImage, width, height, filter)
//        return newBitmap
//    }
//
//    //@SuppressLint("StaticFieldLeak")
//    inner class ImageDecodeImage : AsyncTask<String, Int, String>() {
//
//        override fun doInBackground(vararg params: String): String? {
//
//            try {
//                DLog("CurlActivty:", "inside ImageDecodeImage: ${imageNamesArrayList.size}")
//                imageArrayList.clear()
//                for ((index, value) in imageNamesArrayList.withIndex()) {
//                    DLog("CurlActivty:", "inside ImageDecodeImage: ${imageNamesArrayList.get(index)}")
//                    val imageName = imageNamesArrayList.get(index)
//                    var file: File? = null
//
//                    /*if (File(getExternalFilesDir(null)?.toString(), getString(R.string.main_folder_name) + "/" + imageName).exists()) {
//                        file = File(getExternalFilesDir(null)?.toString(), getString(R.string.main_folder_name) + "/" + imageName)
//                    } */
//                    file = getFile(imageName)
//                    if (file.exists()) {
//                        val tmp = getBitmapFromFile(file, mContext!!)
//                        imageCache1?.removeKey(imageName)
//                        imageCache1?.addBitmapToCache(imageName, tmp)
//                    }
//                    if (isCancelled) {
//                        break
//                    }
//                }
//                DLog("Step", "4")
//                DLog("Step", "7")
//            } catch (e: OutOfMemoryError) {
//                DLog("CurlActivity : ", "error : ${e.message}")
//            } catch (e: NullPointerException) {
//                DLog("CurlActivity  : ", "error : 'int android.graphics.Bitmap.getWidth() : ${e.message}")
//            }
//            return null
//        }
//
//        override fun onPostExecute(s: String?) {
//            super.onPostExecute(s)
//            //fillPage()
//        }
//    }
//
//    inner class DownloadAlbumMusic : AsyncTask<String, Int, Boolean>() {
//
//        override fun doInBackground(vararg params: String): Boolean? {
//
//            //val projectFolder = File(getExternalFilesDir(null)?.absolutePath, resources.getString(R.string.main_folder_name))
//            val projectFolder = File("${applicationContext.applicationInfo.dataDir}/app_flutter")
//
//            if (!projectFolder.exists()) {
//                projectFolder.mkdir()
//            }
//
//            val thumbFolder = File(projectFolder, "/")
//            if (!thumbFolder.exists()) {
//                thumbFolder.mkdir()
//            }
//
//            //val audioUrl = "${AppConst.STORAGE_URL}${dbHelper?.getStudioId(eventId!!)}/${albumId}/audio/$music"
//            val audioUrl = "https://jvtpm.sgp1.digitaloceanspaces.com/euwfzm95/1099/audio/App-mr-and-mrs-k8t"
//            DLog("CurlActivity : ", "DownloadAlbumMusic()  $audioUrl ")
//            val file = File(thumbFolder, music)
//            try {
//                val policy = StrictMode.ThreadPolicy.Builder().permitAll().build()
//                StrictMode.setThreadPolicy(policy)
//
//                if (!file.exists()) {
//                    //file.mkdir()
//                    val url = URL(audioUrl)
//                    DLog("CurlActivity : ", "DownloadAlbumMusic() inside if() $audioUrl ")
//                    val connection = url.openConnection() as HttpURLConnection
//                    connection.requestMethod = "GET"
//                    connection.doInput = true
//                    connection.connect()
//                    DLog("CurlActivity: ", "AUDIO: ${connection.inputStream}")
//                    connection.inputStream.use { input ->
//                        file.outputStream().use { fileOut ->
//                            input.copyTo(fileOut, 1024)
//                        }
//                    }
//                    return true
//                }
//            } catch (e: Exception) {
//                Others.DLog("Exception 1: ", "${e.message}  ${file}")
//            }
//            return false
//        }
//
//        override fun onPostExecute(isDownload: Boolean?) {
//            super.onPostExecute(isDownload)
//            try {
//                //val musicFilePath = getExternalFilesDir(null)?.absolutePath + "/${resources.getString(R.string.main_folder_name)}/$music"
//                val musicFilePath = "${applicationContext.applicationInfo.dataDir}/app_flutter/$music"
//                if (isDownload!!)
//                    playFromLocale(musicFilePath)
//                else
//                    playFromAsset()
//            } catch (e: java.lang.Exception) {
//            }
//        }
//    }
//
//    // set a Images in PageFlipping Curl
//    private fun fillPage() {
//        isAlbumVisible = true
//        window.setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
//            WindowManager.LayoutParams.FLAG_FULLSCREEN)
//        curl.setPageProvider(PageProvider(/*viewSingleAlbumActivityModelList*/))
//        curl.setSizeChangedObserver(SizeChangedObserver())
//        when {
//            clickedPositon == 1 -> curl.currentIndex = 0
//            clickedPositon == 2 -> curl.currentIndex = 1
//            clickedPositon % 2 == 0 -> curl.currentIndex = (clickedPositon / 2)
//            clickedPositon % 2 != 0 -> {
//                val clickedPosition = clickedPositon - 1
//                curl.currentIndex = (clickedPosition / 2) + 1
//            }
//            else -> curl.currentIndex = 0
//        }
//        curl.setBackgroundColor(-0x000000)
//    }
//
//    //ImageViewSlider
//    private fun showRecyclerView() {
//        val customThumbnailAdapter = ImageViewSliderAdapter1(this, albumImagesMap!!)
//        if (albumOrientation == 1) {
//            imageview_slider_recyclerView.layoutManager = androidx.recyclerview.widget.LinearLayoutManager(this, androidx.recyclerview.widget.LinearLayoutManager.HORIZONTAL, false)
//        } else {
//            imageview_slider_recyclerView.layoutManager = androidx.recyclerview.widget.LinearLayoutManager(this, androidx.recyclerview.widget.LinearLayoutManager.VERTICAL, false)
//        }
//        customThumbnailAdapter.setOnItemclickListener(this)
//        imageview_slider_recyclerView.adapter = customThumbnailAdapter
//    }
//
//    private fun createSingleImageFromMultipleImages(firstImage: Bitmap, secondImage: Bitmap): Bitmap {
//        DLog("Width", "${firstImage.width} ${secondImage.width} ${firstImage.height} ${secondImage.height}")
//        result = Bitmap.createBitmap((firstImage.width + secondImage.width), secondImage.height, secondImage.config)
//        canvas = Canvas(result!!)
//        canvas!!.drawBitmap(firstImage, 0f, 0f, null)
//        canvas!!.drawBitmap(secondImage, firstImage.width.toFloat(), 0f, null)
//        return result!!
//    }
//
//    // slide the view from below itself to the current position
//    private fun slideUp(recyclerView: androidx.recyclerview.widget.RecyclerView) {
//        DLog("slideUp", "slideUp  if")
//        showRecyclerView()
//        recyclerView.visibility = View.VISIBLE
//    }
//
//    // slide the view from its current position to below itself
//    private fun slideDown(view: androidx.recyclerview.widget.RecyclerView) {
//        view.visibility = View.INVISIBLE
//    }
//
//    public override fun onPause() {
//        isActivityForeground = false
//        imageDecodeImage?.cancel(true)
//        AppConst.DISABLE_OR_ENABLE_CURL_ACTIVITY_CARD = true
//        DLog("CurlActivity: ", "AlbumMusic onPause() step 1")
//        DLog("CurlActivity: ", "${AppConst.DISABLE_OR_ENABLE_CURL_ACTIVITY_CARD}")
//
//        DLog("CurlActivity: ", "AlbumMusic onPause() step 2")
//        if (onBackPressedValue) {
//            setIntPreference(mContext!!, SharedPreferenceConst.CURRENT_INDEX, 0)
//        } else {
//            setIntPreference(mContext!!, SharedPreferenceConst.CURRENT_INDEX, currentIndexValue)
//        }
//
//        DLog("CurlActivity: ", "AlbumMusic onPause() step 3")
//        DLog("On pause", "on pause $mPlayer")
//        DLog("CurlActivity: ", "AlbumMusic onPause() step 4")
//        try {
//            if (mPlayer != null) {
//                DLog("CurlActivity: ", "AlbumMusic onPause() step 5")
//                // mPlayer?.stop()
//                if (i == 0) {
//                    DLog("CurlActivity: ", "AlbumMusic onPause() step 6")
//                    fab5.setImageResource(R.drawable.ic_music_stop_note_black_24dp)
//                    i = 2
//                    mPlayer!!.pause()
//                    DLog("CurlActivity: ", "AlbumMusic onPause() step 7")
//                    length = mPlayer!!.currentPosition
//                    //mPlayer?.release()
//                    musicPlay = true
//                    DLog("CurlActivity: ", "AlbumMusic onPause() step 8")
//                } else if (i == 2) {
//                    DLog("CurlActivity: ", "AlbumMusic onPause() step 9")
//                    i = 0
//                }
//            }
//        } catch (e: Exception) {
//        }
//        curl.onPause()
//        DLog("CurlActivity: ", "AlbumMusic onPause() step 10")
//        super.onPause()
//        CacheAsyncTask().execute(MESSAGE_FLUSH)
//    }
//
//    fun checkForExistingAlbumImages(lastUpdatedAt: Int) {
//        if (dbHelper!!.ifAlbumImageExistsOrNot(albumId!!)) {
//            checkImages()
//            //startAlbumUpdateWorker(lastUpdatedAt)
//        } else {
//            this.finish()
//            //CustomToast.alert(this, resources.getString(R.string.no_images_available_in_album))
//            Toast.makeText(this, resources.getString(R.string.no_images_available_in_album), Toast.LENGTH_LONG).show()
//        }
//    }
//
//    public override fun onResume() {
//        isActivityForeground = true
//        DLog("CurlActivity: ", "AlbumMusic onResume() step 1")
//        curl.currentIndex = getIntPreference(mContext!!, SharedPreferenceConst.CURRENT_INDEX)
//
//        DLog("CurlActivity: ", "isFABOpen: $isFABOpen")
//        if (isFABOpen) {
//            DLog("CurlActivity: ", "AlbumMusic onResume() step 2")
//            activity_curl_studioLogo_imageView.visibility = View.INVISIBLE
//            activity_curl_small_studioLogo_imageView.visibility = View.GONE
//        } else {
//            DLog("CurlActivity: ", "AlbumMusic onResume() step 3")
//            if (dbHelper?.isAllImagesDownloaded(albumId!!)!!) {
//                activity_curl_studioLogo_imageView.visibility = View.VISIBLE
//            } else {
//                activity_curl_studioLogo_imageView.visibility = View.INVISIBLE
//            }
//            activity_curl_small_studioLogo_imageView.visibility = View.GONE
//        }
//        DLog("CurlActivity: ", "AlbumMusic onResume() step 4")
//        if (mPlayer != null) {
//            DLog("CurlActivity: ", "AlbumMusic onResume() step 5")
//            DLog("Onresume", "onresume")
//            if (musicPlay) {
//                DLog("CurlActivity: ", "AlbumMusic onResume() step 6")
//                DLog("musicPlay", "true")
//                if (i == 2) {
//                    DLog("CurlActivity: ", "AlbumMusic onResume() step 7")
//                    fab5.setImageResource(R.drawable.ic_music_note_black_24dp)
//                    mPlayer!!.seekTo(length)
//                    mPlayer!!.start()
//                    i = 0
//                } else if (i == 0) {
//                    DLog("CurlActivity: ", "AlbumMusic onResume() step 8")
//                    fab5.setImageResource(R.drawable.ic_music_stop_note_black_24dp)
//                    mPlayer?.pause()
//                    i = 2
//                }
//                DLog("CurlActivity: ", "AlbumMusic onResume() step 9")
//            }
//            DLog("CurlActivity: ", "AlbumMusic onResume() step 10")
//        }
//        DLog("CurlActivity: ", "AlbumMusic onResume() step 11")
//        super.onResume()
//        curl.onResume()
//    }
//
//    override fun onRetainCustomNonConfigurationInstance(): Any = curl.currentIndex
//
//    private inner class PageProvider : CurlView.PageProvider {
//        override fun getPageCount(): Int {
//            return totalAlbumPaperSize
//        }
//
//        private fun loadBitmap(width: Int, height: Int, index: Int, bitmap: Bitmap): Bitmap {
//            DLog("CurlActivity: ", "inside PageProvider loadBitmap")
//
//            val b = Bitmap.createBitmap(width, height,
//                Bitmap.Config.ARGB_8888)
//            b.eraseColor(-0x1)
//            val c = Canvas(b)
//            val d = BitmapDrawable(resources, bitmap)
//            val margin = 0
//            val border = 0
//            val r = Rect(margin, margin, width - margin, height - margin)
//
//            val p = Paint()
//            p.color = Color.rgb(151, 124, 83)
//            c.drawRect(r, p)
//            r.left += border
//            r.right -= border
//            r.top += border
//            r.bottom -= border
//
//            d.bounds = r
//            d.draw(c)
//            return b
//        }
//
//        private fun loadBitmap1(width: Int, height: Int, index: Int, bitmap: Bitmap): Bitmap {
//            DLog("CurlActivity: ", "inside PageProvider loadBitmap 1")
//            val b = Bitmap.createBitmap(width, height,
//                Bitmap.Config.ARGB_8888)
//            b.eraseColor(-0x1)
//            val c = Canvas(b)
//            val bOutput: Bitmap
//            val matrix = Matrix()
//            matrix.preScale(-1.0f, 1.0f)
//            bOutput = Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
//            val d = BitmapDrawable(resources, bOutput)
//            val margin = 0
//            val border = 0
//            val r = Rect(margin, margin, width - margin, height - margin)
//
//            val p = Paint()
//            p.color = Color.rgb(151, 124, 83)
//            c.drawRect(r, p)
//            r.left += border
//            r.right -= border
//            r.top += border
//            r.bottom -= border
//            d.bounds = r
//            d.draw(c)
//            return b
//        }
//
//        override fun getCurlState(state: String?) {
//            mStateOfCurl = if (state != null) {
//                state
//            } else {
//                "0"
//            }
//        }
//
//        override fun updatePage(page: CurlPage, width: Int, height: Int, k: Int) {
//            var even = 0
//            var odd = 0
//            currentIndexValue = k
//            val albumImagesMapKeyArray = albumImagesMap.keys.toTypedArray()
//            DLog("CurlActivity :", "updatePage Key Array : " + Arrays.toString(albumImagesMapKeyArray))
//            val imageList = albumImagesMap[albumImagesMapKeyArray.get(k)]
//            DLog("CurlActivity :", "K Value: $k  -- ${mStateOfCurl}")
//            try {
//                if (mStateOfCurl.equals("0")) {
//                    when (k) {
//                        0, 1 -> {
//                            var list = try {
//                                albumImagesMap[albumImagesMapKeyArray.get(1)]!!
//                            } catch (e: java.lang.IndexOutOfBoundsException) {
//                                albumImagesMap[albumImagesMapKeyArray.get(0)]!!
//                            }
//                            if (list!!.get(0).isNotEmpty() && list.get(1).isNotEmpty()) {
//                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list.get(0))
//                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list.get(1))
//                            } else if (list.get(0).isNotEmpty() && list.get(1).isEmpty()) {
//                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, albumImagesMap[albumImagesMapKeyArray.get(0)]!!.get(1))
//                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list.get(0))
//                            } else if (list.get(0).isEmpty() && list.get(1).isNotEmpty()) {
//                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, albumImagesMap[albumImagesMapKeyArray.get(0)]!!.get(1))
//                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list.get(1))
//                            }
//                        }
//                        totalAlbumPaperSize - 2 -> {
//                            val newKValue = totalAlbumPaperSize - 1
//                            val list = albumImagesMap[albumImagesMapKeyArray.get(newKValue)]
//                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list!![0])
//                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])
//
//                            if (list[0].isNotEmpty() && list[1].isNotEmpty()) {
//                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[0])
//                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])
//                            } else if (list[0].isNotEmpty() && list[1].isEmpty()) {
//                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[0])
//                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, albumImagesMap[albumImagesMapKeyArray.get(0)]!!.get(0))
//                            } else if (list[0].isEmpty() && list[1].isNotEmpty()) {
//                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[1])
//                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, albumImagesMap[albumImagesMapKeyArray.get(0)]!!.get(0))
//                            } else {
//                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[0])
//                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])
//                            }
//                        }
//                        else -> {
//                            val previousImageList = albumImagesMap[albumImagesMapKeyArray.get(k + 1)]
//                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, previousImageList!![0])
//                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, previousImageList[1])
//                        }
//                    }
//                } else if (mStateOfCurl.equals("1")) {
//                    when (k) {
//                        0 -> {
//                            val list = albumImagesMap[albumImagesMapKeyArray.get(0)]
//                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list!![0])
//                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])
//                        }
//                        totalAlbumPaperSize - 1 -> {
//                            val newKValue = totalAlbumPaperSize - 1
//                            val list = albumImagesMap[albumImagesMapKeyArray.get(newKValue)]
//                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list!![0])
//                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])
//
//                            if (list[0].isNotEmpty() && list[1].isNotEmpty()) {
//                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[0])
//                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])
//                            } else if (list[0].isNotEmpty() && list[1].isEmpty()) {
//                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[0])
//                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, albumImagesMap[albumImagesMapKeyArray.get(0)]!!.get(0))
//                            } else if (list[0].isEmpty() && list[1].isNotEmpty()) {
//                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[1])
//                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, albumImagesMap[albumImagesMapKeyArray.get(0)]!!.get(0))
//                            } else {
//                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[0])
//                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])
//                            }
//                        }
//                        else -> {
//                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageList!![0])
//                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageList[1])
//                        }
//                    }
//                }
//            } catch (e: ArrayIndexOutOfBoundsException) {
//                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageList!![0])
//                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageList[1])
//            }
//
//            DLog("CurlActivity :", "totalAlbumPaperSize : $totalAlbumPaperSize , k : $k")
//            if (totalAlbumPaperSize - 1 == k) {
//                try {
//                    if (albumImagesMap[albumImagesMapKeyArray.get(k)]!!.get(0) == "" || albumImagesMap[albumImagesMapKeyArray.get(k)]!!.get(1) == "") {
//                        DLog("CurlActivity : ", "updatePage : if step 1 K::$k")
//                        page.setColor(Color.rgb(180, 180, 180), SIDE_FRONT)
//                    } else {
//                        DLog("CurlActivity : ", "updatePage : if step 2 K::$k")
//                        page.setTexture(loadBitmap(width, height, k, getBitmapFromIndex1(imageList?.get(1)!!)), SIDE_FRONT)
//                    }
//                } catch (e: OutOfMemoryError) {
//                    page.setTexture(loadBitmap(width, height, k, getSampleEmptyBitmap()), SIDE_FRONT)
//                }
//
//                try {
//                    val imageList = albumImagesMap[albumImagesMapKeyArray.get(0)]
//                    page.setTexture(loadBitmap1(width, height, k, getBitmapFromIndex1(imageList?.get(0)!!)), SIDE_BACK)
//                } catch (e: OutOfMemoryError) {
//                    page.setTexture(loadBitmap1(width, height, k, getSampleEmptyBitmap()), SIDE_BACK)
//                }
//            } else if (k == 0) {
//
//                try {
//                    if (albumImagesMap[albumImagesMapKeyArray.get(k)]!!.get(1) == "") {
//                        DLog("CurlActivity : ", "updatePage : if else step 1")
//                        page.setColor(Color.rgb(180, 180, 180), SIDE_FRONT)
//                    } else {
//                        DLog("CurlActivity : ", "updatePage : if else step 2 K::$k : ${imageList!![1]}")
//                        page.setTexture(loadBitmap(width, height, k, getBitmapFromIndex1(imageList?.get(1)!!)), SIDE_FRONT)
//                    }
//                } catch (e: OutOfMemoryError) {
//                    page.setTexture(loadBitmap(width, height, k, getSampleEmptyBitmap()), SIDE_FRONT)
//                }
//
//                try {
//                    if (albumImagesMap[albumImagesMapKeyArray.get(k + 1)]!!.get(0) != "" && albumImagesMap[albumImagesMapKeyArray.get(k + 1)]!!.get(1) != "") {
//                        DLog("CurlActivity : ", "updatePage : if else step 3 K::$k")
//                        var nextImageList = albumImagesMap[albumImagesMapKeyArray.get(k + 1)]
//                        page.setTexture(loadBitmap1(width, height, k, getBitmapFromIndex1(nextImageList!![0])), SIDE_BACK)
//                    } else {
//                        page.setColor(Color.rgb(180, 180, 180), SIDE_BACK)
//                    }
//                } catch (e: OutOfMemoryError) {
//                    page.setTexture(loadBitmap1(width, height, k, getSampleEmptyBitmap()), SIDE_BACK)
//                }
//
//            } else if (k == 1) {
//
//                try {
//                    if (albumImagesMap[albumImagesMapKeyArray.get(k)]!!.get(1) == "") {
//                        DLog("CurlActivity : ", "updatePage : if else step 1")
//                        page.setColor(Color.rgb(180, 180, 180), SIDE_FRONT)
//                    } else {
//                        DLog("CurlActivity : ", "updatePage : if else step 2 K::$k : ${imageList!![0]}")
//                        page.setTexture(loadBitmap(width, height, k, getBitmapFromIndex1(imageList?.get(1)!!)), SIDE_FRONT)
//                    }
//                } catch (e: OutOfMemoryError) {
//                    page.setTexture(loadBitmap(width, height, k, getSampleEmptyBitmap()), SIDE_FRONT)
//                }
//
//                try {
//                    if (albumImagesMap[albumImagesMapKeyArray.get(k + 1)]!!.get(0) == "") {
//                        if (albumImagesMap[albumImagesMapKeyArray.get(k + 1)]!!.get(1) != "") {
//                            var nextImageList = albumImagesMap[albumImagesMapKeyArray.get(k + 1)]
//                            DLog("CurlActivity : ", "updatePage : if else step 4 K::$k : ${nextImageList!![1]}")
//                            page.setTexture(loadBitmap1(width, height, k, getBitmapFromIndex1(nextImageList!![1])), SIDE_BACK)
//                        }
//                    } else {
//                        var nextImageList = albumImagesMap[albumImagesMapKeyArray.get(k + 1)]
//                        DLog("CurlActivity : ", "updatePage : if else step 4 K::$k : ${nextImageList!![0]}")
//                        page.setTexture(loadBitmap1(width, height, k, getBitmapFromIndex1(nextImageList!![0])), SIDE_BACK)
//                    }
//                } catch (e: OutOfMemoryError) {
//                    page.setTexture(loadBitmap1(width, height, k, getSampleEmptyBitmap()), SIDE_BACK)
//                }
//
//            } else {
//
//                try {
//                    if (albumImagesMap[albumImagesMapKeyArray.get(k)]!!.get(0) != "" && albumImagesMap[albumImagesMapKeyArray.get(k)]!!.get(1) != "") {
//                        DLog("CurlActivity : ", "updatePage : if else step 2 K::$k : ${imageList!![0]}")
//                        page.setTexture(loadBitmap(width, height, k, getBitmapFromIndex1(imageList?.get(1)!!)), SIDE_FRONT)
//                    } else {
//                        DLog("CurlActivity : ", "updatePage : if else step 1")
//                        page.setColor(Color.rgb(180, 180, 180), SIDE_FRONT)
//                    }
//                } catch (e: OutOfMemoryError) {
//                    page.setTexture(loadBitmap(width, height, k, getSampleEmptyBitmap()), SIDE_FRONT)
//                }
//
//
//                try {
//                    if (albumImagesMap[albumImagesMapKeyArray.get(k + 1)]!!.get(0) == "") {
//                        if (albumImagesMap[albumImagesMapKeyArray.get(k + 1)]!!.get(1) != "") {
//                            var nextImageList = albumImagesMap[albumImagesMapKeyArray.get(k + 1)]
//                            DLog("CurlActivity : ", "updatePage : if else step 4 K::$k : ${nextImageList!![1]}")
//                            page.setTexture(loadBitmap1(width, height, k, getBitmapFromIndex1(nextImageList!![1])), SIDE_BACK)
//                        }
//                    } else {
//                        var nextImageList = albumImagesMap[albumImagesMapKeyArray.get(k + 1)]
//                        DLog("CurlActivity : ", "updatePage : if else step 4 K::$k : ${nextImageList!![0]}")
//                        page.setTexture(loadBitmap1(width, height, k, getBitmapFromIndex1(nextImageList!![0])), SIDE_BACK)
//                    }
//                } catch (e: OutOfMemoryError) {
//                    page.setTexture(loadBitmap1(width, height, k, getSampleEmptyBitmap()), SIDE_BACK)
//                }
//            }
//        }
//    }
//
//    fun getBitmapFromIndex(index: Int): Bitmap {
//        return bitmapHashMap[bitmapHashMap.keys.toTypedArray().get(index)]!!
//    }
//
//    fun getBitmapFromIndex1(imageUrl: String): Bitmap {
//        try {
//            return imageCache1!!.getBitmapFromDiskCache(imageUrl)
//        } catch (e: IllegalStateException) {
//            DLog("CurlActivity :", "inside getBitmapFromIndex1 ERROR: ${e.toString()}")
//
//            /*val file = if (File(getExternalFilesDir(null)?.toString(), getString(R.string.main_folder_name) + "/" + imageUrl).exists()) {
//                File(getExternalFilesDir(null)?.toString(), getString(R.string.main_folder_name) + "/" + imageUrl)
//            } else {
//                File(getExternalFilesDir(null)?.toString(), getString(R.string.main_folder_name) + "/thumb/" + imageUrl)
//            }*/
//            val file = getFile(imageUrl)
//            val tmp: Bitmap = if (file.exists()) {
//                getBitmapFromFile(file, this)
//            } else {
//                when (albumOrientation) {
//                    1 -> BitmapFactory.decodeResource(resources, R.drawable.image_load_landscape)
//                    2 -> BitmapFactory.decodeResource(resources, R.drawable.image_load_portrait)
//                    else -> BitmapFactory.decodeResource(resources, R.drawable.image_load_square)
//                }
//            }
//
//            bitmapHashMap.put(imageUrl, getSampleEmptyBitmap())
//            imageCache1?.removeKey(imageUrl)
//            imageCache1?.addBitmapToCache(imageUrl, tmp)
//            try {
//                return imageCache1!!.getBitmapFromDiskCache(imageUrl)
//            } catch (e: IllegalStateException) {
//                return getSampleEmptyBitmap()
//            }
//        } catch (e: OutOfMemoryError) {
//            return getSampleEmptyBitmap()
//        }
//    }
//
//    private inner class SizeChangedObserver : CurlView.SizeChangedObserver {
//        override fun onSizeChanged(w: Int, h: Int) {
//            if (w > h) {
//                curl.setViewMode(CurlView.SHOW_TWO_PAGES)
//                curl.setMargins(.0f, .0f, .0f, .0f)
//            } else {
//                curl.setViewMode(CurlView.SHOW_ONE_PAGE)
//                curl.setMargins(.1f, .1f, .1f, .1f)
//            }
//        }
//    }
//
//    @Throws(IOException::class)
//    fun drawableFromUrl(url: String) {
//        val policy = StrictMode.ThreadPolicy.Builder().permitAll().build()
//        StrictMode.setThreadPolicy(policy)
//        val connection = URL(url).openConnection() as HttpURLConnection
//        connection.connect()
//        val input = connection.inputStream
//        y = BitmapFactory.decodeStream(input)
//    }
//
//    override fun downloadCompleteListener() = checkImages()
//
//    override fun singleImageClickListener(position: Int, imageList: ArrayList<String>) {
//        curl.currentIndex = position
//
//        if (position != 0 && position != mergedBitmapImageNameArrayList.size - 1) {
//            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageList[0])
//            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageList[1])
//        }
//    }
//
//    override fun getBitmapListener(imageUrl: String): Bitmap {
//        return getBitmapFromIndex1(imageUrl)
//    }
//
//    override fun deleteImageListener(position: Int, it: View) {}
//
//    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
//        super.onActivityResult(requestCode, resultCode, data)
//        if (requestCode == 1 && resultCode == Activity.RESULT_OK) {
//            DLog("CurlActivity : ", "inside onActivityResult 1")
//            if (dbHelper!!.ifAlbumImageExistsOrNot(albumId!!)) {
//                val intent = Intent(mContext, CurlActivity::class.java)
//                intent.putExtra("albumName", albumName)
//                intent.putExtra("eventId", eventId)
//                intent.putExtra("albumId", albumId!!)
//                intent.putExtra("albumType", albumType)
//                intent.putExtra("updatedAt", lastUpdatedAt)
//                intent.putExtra("music", music)
//                intent.putExtra("albumSize", albumSize)
//                intent.putExtra("eventUrl", eventsUrl)
//                intent.putExtra("eventType", eventsType)
//                intent.putExtra("orientation", orientation)
//
//                /*intentViewSingleAlbum.putExtra("album_id", albumId!!)
//                intentViewSingleAlbum.putExtra("album_name", albumName)
//                intentViewSingleAlbum.putExtra("music", music)
//                intentViewSingleAlbum.putExtra("album_size", albumSize)
//                intentViewSingleAlbum.putExtra("album_type", albumType)
//                intentViewSingleAlbum.putExtra("updated_at", lastUpdatedAt)
//                intentViewSingleAlbum.putExtra("orientation", orientation)
//                intentViewSingleAlbum.putExtra("eventsRandomId", eventsRandomId)
//                intentViewSingleAlbum.putExtra("eventsPasscode", eventsPasscode)
//                intentViewSingleAlbum.putExtra("eventsUrl", eventsUrl)
//                intentViewSingleAlbum.putExtra("eventType", eventsType)
//                intentViewSingleAlbum.putExtra("eventId", eventId)*/
//                startActivity(intent)
//                finish()
//            } else {
//                this.finish()
//                //CustomToast.alert(this, resources.getString(R.string.no_images_available_in_album))
//                Toast.makeText(this, resources.getString(R.string.no_images_available_in_album), Toast.LENGTH_LONG).show()
//            }
//        } else {
//            DLog("CurlActivity : ", "inside onActivityResult 2")
//            //isNotComeFromBackPressed = false
//            finish()
//        }
//    }
//
//    private fun checkInternet() {
//        val alertDialog = AlertDialog.Builder(this, R.style.AlertDialogTheme).create()
//        alertDialog.setTitle(this.resources.getString(R.string.you_are_offline))
//        alertDialog.setMessage(this.resources.getString(R.string.check_connection))
//        alertDialog.setCanceledOnTouchOutside(false)
//        alertDialog.setButton(AlertDialog.BUTTON_POSITIVE, "Retry") { dialogInterface, i ->
//            if (Network_check.isNetworkAvailable(this)) {
//                alertDialog.dismiss()
//                //setCustomProgressBar()
//                onStartContent()
//            } else {
//                checkInternet()
//            }
//        }
//        alertDialog.show()
//    }
//
//    private fun noInternetConnection() {
//        if (!dbHelper!!.isOriginalsDownload(albumId!!)) {
//            val alertDialog = AlertDialog.Builder(this, R.style.AlertDialogTheme).create()
//            alertDialog.setTitle(this.resources.getString(R.string.you_are_offline))
//            alertDialog.setMessage(this.resources.getString(R.string.check_connection))
//            alertDialog.setCanceledOnTouchOutside(false)
//            alertDialog.setButton(AlertDialog.BUTTON_POSITIVE, "Retry") { dialogInterface, i ->
//                if (Network_check.isNetworkAvailable(this)) {
//                    alertDialog.dismiss()
//                    downloadOriginalAlbumImages()
//                }
//            }
//            alertDialog.setButton(AlertDialog.BUTTON_NEGATIVE, "Cancel") { dialogInterface, i ->
//                alertDialog.dismiss()
//            }
//            alertDialog.show()
//        }
//    }
//
//    override fun setPercent(imageUrl: String, imageBitmap: Bitmap) {
//
//        //val imageOriginalFile = File(getExternalFilesDir(null), getString(R.string.main_folder_name) + "/" + imageUrl)
//        val imageOriginalFile = getFile(imageUrl)
//        var originalBitmap: Bitmap? = null
//
//        if (imageOriginalFile.exists()) {
//            DLog("CurlActivity:", "setPercent() if file exists")
//            try {
//                imageCache1?.removeKey(imageUrl)
//                //imageCache1?.addBitmapToCache(imageUrl, Bitmap.createBitmap(tmp))
//                imageCache1?.addBitmapToCache(imageUrl, imageBitmap)
//            } catch (e: IllegalStateException) {
//                DLog("CurlActivityLandscape ERROR :", e.message.toString())
//            }
//        } else {
//            DLog("CurlActivity:", "setPercent() if else file not exists")
//            val tmp = when (albumOrientation) {
//                1 -> BitmapFactory.decodeResource(resources, R.drawable.image_load_landscape)
//                2 -> BitmapFactory.decodeResource(resources, R.drawable.image_load_portrait)
//                else -> BitmapFactory.decodeResource(resources, R.drawable.image_load_square)
//            }
//            imageCache1?.removeKey(imageUrl)
//            //imageCache1?.addBitmapToCache(imageUrl, Bitmap.createBitmap(tmp))
//            imageCache1?.addBitmapToCache(imageUrl, tmp)
//            /*val imageThumbfile = File(getExternalFilesDir(null), getString(R.string.main_folder_name) + "/thumb/" + imageUrl)*//*File(Environment.getDataDirectory(), getString(R.string.main_folder_name) + "/thumb/" + imageUrl)*//*
//            if (readBitmapInFo(imageThumbfile) > megaBytesFree()) {
//                originalBitmap = subSampleImage(32, imageThumbfile)
//            } else {
//                originalBitmap = BitmapFactory.decodeFile(imageThumbfile.absolutePath)
//            }
//            originalBitmap = BitmapFactory.decodeFile(imageThumbfile.absolutePath)*/
//        }
//        /*if (originalBitmap != null) {
//            imageCache1?.removeKey(imageUrl)
//            imageCache1?.addBitmapToCache(imageUrl, tmp)
//        }*/
//        val cursor = dbHelper!!.totalOriginalImagesDownloaded(albumId!!)
//        totalUndownloadedImages = dbHelper!!.totalOriginalImagesUnDownloaded(albumId!!).count
//        totalDownloadedImages = cursor.count
//        if (totalDownloadedImages == 0) {
//            totalDownloadedImages = 1
//        }
//        var percent: Int = 1
//        try {
//            percent = (totalDownloadedImages!! * 100) / totalUndownloadedImages!!
//        } catch (e: ArithmeticException) {
//            DLog("DownloadImagesFragment :", e.message.toString())
//        }
//        activity_curl_studioLogo_imageView.visibility = View.INVISIBLE
//        progressBar.setProgress(percent)
//        progress_textView.text = "$percent%"
//
//        if (isActivityForeground) {
//            if (percent >= 100) {
//                //getMergedImageNameArrayList()
//                activity_curl_studioLogo_imageView.visibility = View.VISIBLE
//                if (albumOrientation == 1) {
//                    setInvisibleProgressBarIfLandscape()
//                } else {
//                    setInvisibleProgressBar()
//                }
//                if (mWakeLock!!.isHeld()) {
//                    DLog("CurlActivityLandscape: ", "inside isOriginalsDownloadInSingleAlbum if 2")
//                    mWakeLock!!.release()
//                }
//            }
//        }
//    }
//
//    private fun setInvisibleProgressBarIfLandscape() {
//        progressBar_constraint.visibility = View.GONE
//        activity_curl_studioLogo_imageView.visibility = View.VISIBLE
//        fab_layout.visibility = View.VISIBLE
//        fabLayout4.visibility = View.VISIBLE
//        fabLayout3.visibility = View.VISIBLE
//        fabLayout5.visibility = View.VISIBLE
//        fabLayout6.visibility = View.VISIBLE
//        fabLayout7.visibility = View.VISIBLE
//        playMusic()
//        guideView1 = getIntPreference(this, SharedPreferenceConst.GUIDEVIEW_COMPLETED_ALBUM_LANDSCAPE)
//        if (guideView1.equals(0)) {
//            if (albumOrientation == 1) {
//                getSequence1().show()
//            }
//            setIntPreference(this, SharedPreferenceConst.GUIDEVIEW_COMPLETED_ALBUM_LANDSCAPE, 1)
//        }
//    }
//
//    private fun setInvisibleProgressBar() {
//        progressBar_constraint.visibility = View.GONE
//        activity_curl_studioLogo_imageView.visibility = View.VISIBLE
//        fab_layout.visibility = View.VISIBLE
//        playMusic()
//    }
//
//    override fun onBackPressed() {
//        super.onBackPressed()
//        imageDecodeImage?.cancel(true)
//        DLog("CurlActivity: ", "onBackPressed()")
//        isActivityForeground = false
//        onBackPressedValue = true
//        if (mPlayer != null) {
//            try {
//                //  mPlayer!!.pause()
//                mPlayer!!.release()
//            } catch (e: java.lang.IllegalStateException) {
//
//            }
//        }
//        CacheAsyncTask().execute(MESSAGE_CLEAR)
//    }
//
//    fun visibleFabLayout() {
//        fabLayout1.visibility = View.VISIBLE
//        fabLayout2.visibility = View.VISIBLE
//        fabLayout3.visibility = View.VISIBLE
//        fabLayout4.visibility = View.VISIBLE
//        fabLayout5.visibility = View.VISIBLE
//        fabLayout6.visibility = View.VISIBLE
//        fabLayout7.visibility = View.VISIBLE
//        back_arrow_fabLayout.visibility = View.VISIBLE
//    }
//
//    private fun showFABMenuIfLandscape() {
//
//        DLog("showFABMenuIfLandscape", "showFAb")
//        activity_curl_studioLogo_imageView.visibility = View.GONE
//        activity_curl_small_studioLogo_imageView.visibility = View.GONE
//        isFABOpen = true
//        fabLayout1.visibility = View.VISIBLE
//        fabLayout2.visibility = View.VISIBLE
//        //fabLayout3.visibility = View.VISIBLE
//        //fabLayout4.visibility = View.VISIBLE
//        fabLayout5.visibility = View.VISIBLE
//        fabLayout6.visibility = View.VISIBLE
//        fabLayout7.visibility = View.VISIBLE
//        back_arrow_fabLayout.visibility = View.VISIBLE
//
//        fab.animate().rotationBy(180f).setListener(object : Animator.AnimatorListener {
//            override fun onAnimationStart(animator: Animator) {}
//            override fun onAnimationEnd(animator: Animator) {
//                if (fab.rotation != 180f) {
//
//                    fab.rotation = 180f
//                }
//            }
//
//            override fun onAnimationCancel(animator: Animator) {}
//            override fun onAnimationRepeat(animator: Animator) {}
//        })
//
//        back_arrow_fabLayout.animate().translationX(resources.getDimension(R.dimen.standard_60))
//        fabLayout1.animate().translationX(resources.getDimension(R.dimen.standard_120))
//        fabLayout2.animate().translationX(resources.getDimension(R.dimen.standard_170))
//        fabLayout5.animate().translationX(resources.getDimension(R.dimen.standard_220))
//        fabLayout7.animate().translationX(resources.getDimension(R.dimen.standard_270))
//        fabLayout6.animate().translationX(resources.getDimension(R.dimen.standard_320))
//        /*********4.44pm************/
//    }
//
//    private fun closeFABMenuIfLandscape() {
//        activity_curl_studioLogo_imageView.visibility = View.VISIBLE
//        activity_curl_small_studioLogo_imageView.visibility = View.GONE
//        fab.animate().rotationBy(-180f)
//        back_arrow_fabLayout.animate().translationX(0f)
//        fabLayout1.animate().translationX(0f)
//        fabLayout2.animate().translationX(0f)
//        fabLayout5.animate().translationX(0f)
//        fabLayout7.animate().translationX(0f)
//        fabLayout6.animate().translationX(0f).setListener(object : Animator.AnimatorListener {
//            override fun onAnimationStart(animator: Animator) {
//
//            }
//
//            override fun onAnimationEnd(animator: Animator) {
//                if (!isFABOpen) {
//                    fabLayout1.visibility = View.GONE
//                    fabLayout2.visibility = View.GONE
//                    //fabLayout3.visibility = View.GONE
//                    //fabLayout4.visibility = View.GONE
//                    fabLayout5.visibility = View.GONE
//                    fabLayout7.visibility = View.GONE
//                    fabLayout6.visibility = View.GONE
//                    back_arrow_fabLayout.visibility = View.GONE
//                }
//                if (fab.rotation != 180f) {
//                    fab.rotation = 180f
//                }
//            }
//
//            override fun onAnimationCancel(animator: Animator) {
//
//            }
//
//            override fun onAnimationRepeat(animator: Animator) {
//            }
//        })
//    }
//
//    private fun showFABMenu() {
//        activity_curl_studioLogo_imageView.visibility = View.GONE
//        activity_curl_small_studioLogo_imageView.visibility = View.GONE
//        fabLayout1.visibility = View.VISIBLE
//        fabLayout2.visibility = View.VISIBLE
//        fabLayout3.visibility = View.VISIBLE
//        fabLayout4.visibility = View.VISIBLE
//        fabLayout5.visibility = View.VISIBLE
//        fabLayout6.visibility = View.VISIBLE
//        fabLayout7.visibility = View.VISIBLE
//        back_arrow_fabLayout.visibility = View.VISIBLE
//        fab.animate().rotationBy(180f).setListener(object : Animator.AnimatorListener {
//            override fun onAnimationStart(animator: Animator) {}
//            override fun onAnimationEnd(animator: Animator) {
//                if (fab.rotation != 180f) {
//                    fab.rotation = 180f
//                }
//            }
//
//            override fun onAnimationCancel(animator: Animator) {}
//            override fun onAnimationRepeat(animator: Animator) {}
//        })
//
//        if (albumOrientation == 2) {
//            fabLayout1.animate().translationY(resources.getDimension(R.dimen.portrait_image_icon_y_axis))//image standard_70
//            fabLayout2.animate().translationY(resources.getDimension(R.dimen.portrait_zoom_icon_y_axis))//zoom standard_130
//            fabLayout3.animate().translationY(resources.getDimension(R.dimen.portrait_right_icon_y_axis))//right arrow standard_250
//            fabLayout4.animate().translationY(resources.getDimension(R.dimen.portrait_left_icon_y_axis))//left arrow standard_190
//            fabLayout5.animate().translationX(resources.getDimension(R.dimen.portrait_music_icon_x_axis))//music standard
//            fabLayout7.animate().translationX(resources.getDimension(R.dimen.portrait_share_icon_x_axis))//share standard1
//            fabLayout6.animate().translationX(resources.getDimension(R.dimen.portrait_help_icon_x_axis))//help standard2
//            back_arrow_fabLayout.animate().translationX(resources.getDimension(R.dimen.portrait_back_arrow_icon_x_axis))//back arrow
//        } else {
//            fabLayout1.animate().translationY(resources.getDimension(R.dimen.square_image_icon_y_axis))//image standard_70
//            fabLayout2.animate().translationY(resources.getDimension(R.dimen.square_zoom_icon_y_axis))//zoom standard_130
//            fabLayout3.animate().translationY(resources.getDimension(R.dimen.square_right_icon_y_axis))//right arrow standard_250
//            fabLayout4.animate().translationY(resources.getDimension(R.dimen.square_left_icon_y_axis))//left arrow standard_190
//            fabLayout5.animate().translationX(resources.getDimension(R.dimen.square_music_icon_x_axis))//music standard
//            fabLayout7.animate().translationX(resources.getDimension(R.dimen.square_share_icon_x_axis))//share standard1
//            fabLayout6.animate().translationX(resources.getDimension(R.dimen.square_help_icon_x_axis))//help standard2
//            back_arrow_fabLayout.animate().translationX(resources.getDimension(R.dimen.square_back_arrow_icon_x_axis))//back arrow
//        }
//
//    }
//
//    private fun closeFABMenu() {
//        activity_curl_studioLogo_imageView.visibility = View.VISIBLE
//        activity_curl_small_studioLogo_imageView.visibility = View.GONE
//        slideDown(imageview_slider_recyclerView)
//        fab.animate().rotationBy(-180f)
//        back_arrow_fabLayout.animate().translationX(0f)
//        fabLayout1.animate().translationY(0f)
//        fabLayout2.animate().translationY(0f)
//        fabLayout3.animate().translationY(0f)
//        fabLayout4.animate().translationY(0f)/*.setListener(object : Animator.AnimatorListener {*/
//        fabLayout5.animate().translationX(0f)
//        fabLayout7.animate().translationX(0f)
//        fabLayout6.animate().translationX(0f).setListener(object : Animator.AnimatorListener {
//            override fun onAnimationStart(animator: Animator) {
//            }
//
//            override fun onAnimationEnd(animator: Animator) {
//                if (!isFABOpen) {
//                    fabLayout1.visibility = View.GONE
//                    fabLayout2.visibility = View.GONE
//                    fabLayout3.visibility = View.GONE
//                    fabLayout4.visibility = View.GONE
//                    fabLayout5.visibility = View.GONE
//                    fabLayout7.visibility = View.GONE
//                    fabLayout6.visibility = View.GONE
//                    back_arrow_fabLayout.visibility = View.GONE
//                }
//                if (fab.rotation != -180f) {
//                    fab.rotation = -180f
//                }
//            }
//
//            override fun onAnimationCancel(animator: Animator) {
//            }
//
//            override fun onAnimationRepeat(animator: Animator) {
//            }
//        })
//    }
//
//    override fun onDestroy() {
//        super.onDestroy()
//        mPlayer?.release()
//        CacheAsyncTask().execute(MESSAGE_CLOSE)
//    }
//
//    fun playMusic() {
//        DLog("CurlActivity: ", "playMusic() step 1 $music")
//        try {
//            if (mPlayer == null) {
//                mPlayer = MediaPlayer()
//                mPlayer!!.isLooping = true
//            }
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//                DLog("CurlActivity: ", "playMusic() step 1")
//                val audioAttrib = AudioAttributes.Builder()
//                    .setLegacyStreamType(AudioManager.STREAM_MUSIC)
//                    .setUsage(AudioAttributes.USAGE_MEDIA)
//                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
//                    .build()
//                DLog("CurlActivity: ", "playMusic() step 2")
//                mPlayer?.setAudioAttributes(audioAttrib)
//                DLog("CurlActivity: ", "playMusic() step 3")
//            } else {
//                DLog("CurlActivity: ", "playMusic() step 4")
//                mPlayer?.setAudioStreamType(AudioManager.STREAM_MUSIC)
//            }
//
//            DLog("isMusicStopped", "$isMusicStopped")
//
//            if (music != "") {
//                //var musicFilePath = getExternalFilesDir(null)?.absolutePath + "/${resources.getString(R.string.main_folder_name)}/$music"
//                val musicFilePath = "${applicationContext.applicationInfo.dataDir}/app_flutter/$music"
//                val musicFile = File(musicFilePath)
//                if (musicFile.exists()) {
//                    playFromLocale(musicFilePath)
//                } else {
//                    if (Network_check.isNetworkAvailable(this) && isAvailableExternalMemorySize(this, (1 * 1024 * 1024))) {
//                        DownloadAlbumMusic().execute()
//                    } else {
//                        DLog("CurlActivity: ", "playMusic() step 5")
//                        playFromAsset()
//                    }
//                }
//            } else {
//                DLog("CurlActivity: ", "playMusic() step 6")
//                playFromAsset()
//            }
//        } catch (e: IllegalStateException) {
//        }
//    }
//
//    fun playFromLocale(musicFilePath: String) {
//        try {
//            val musicFile = FileInputStream(File(musicFilePath))
//            mPlayer?.setDataSource(musicFile.fd)
//            mPlayer?.prepare()
//
//            if (!isMusicStopped) {
//                mPlayer?.start()
//            }
//            mPlayer?.setOnCompletionListener {
//            }
//            mPlayer?.setOnPreparedListener {
//                if (!isMusicStopped) {
//                    mPlayer?.start()
//                }
//            }
//        } catch (e: IllegalStateException) {
//        } catch (e: IOException) {
//            playFromAsset()
//        }
//    }
//
//    fun playFromAsset() {
//        afd = assets.openFd("music.mp3")
//        mPlayer?.setDataSource(afd!!.fileDescriptor, afd!!.startOffset, afd!!.length)
//        mPlayer?.prepare()
//        if (!isMusicStopped) {
//            mPlayer?.start()
//        }
//
//        mPlayer?.setOnPreparedListener {
//            if (!isMusicStopped) {
//                mPlayer?.start()
//            }
//        }
//        mPlayer?.setOnCompletionListener {
//
//        }
//    }
//
//    private fun showImageViewSliderLandscapeView(): BubbleShowCaseBuilder {
//        return BubbleShowCaseBuilder(this)
//            .title(getString(R.string.show_image_view_slider_title))
//            .description(getString(R.string.show_image_view_slider_description))
//            .backgroundColor(ContextCompat.getColor(this, R.color.curl_guideView_color))
//            .image(ContextCompat.getDrawable(this, R.drawable.ic_photo_library)!!)
//            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
//            .textColor(ContextCompat.getColor(this, R.color.curl_guideView_text_color))
//            .targetView(fab1)
//            .listener(object : BubbleShowCaseListener { //Listener for user actions
//                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the target
//                }
//
//                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the close button
//                }
//
//                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the bubble
//                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
//                }
//
//                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the background dim
//                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
//                }
//            })
//    }
//
//    private fun showImageViewSlider(position: BubbleShowCase.ArrowPosition): BubbleShowCaseBuilder {
//        return BubbleShowCaseBuilder(this)
//            .title(getString(R.string.show_image_view_slider_title))
//            .description(getString(R.string.show_image_view_slider_description))
//            .arrowPosition(position)
//            .backgroundColor(ContextCompat.getColor(this, R.color.curl_guideView_color))
//            .image(ContextCompat.getDrawable(this, R.drawable.ic_photo_library)!!)
//            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
//            .textColor(ContextCompat.getColor(this, R.color.curl_guideView_text_color))
//            .targetView(fab1)
//            .listener(object : BubbleShowCaseListener { //Listener for user actions
//                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the target
//                }
//
//                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the close button
//                }
//
//                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the bubble
//                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
//                }
//
//                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the background dim
//                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
//                }
//            })
//    }
//
//    private fun zoomImageViewLandscapeView(): BubbleShowCaseBuilder {
//        return BubbleShowCaseBuilder(this)
//            .title(getString(R.string.zoom_image_view_title))
//            .description(getString(R.string.zoom_image_view_description))
//            .backgroundColor(ContextCompat.getColor(this, R.color.curl_guideView_color))
//            .image(ContextCompat.getDrawable(this, R.drawable.ic_zoom)!!)
//            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
//            .textColor(ContextCompat.getColor(this, R.color.curl_guideView_text_color))
//            .targetView(fab2)
//            .listener(object : BubbleShowCaseListener { //Listener for user actions
//                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the target
//                }
//
//                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the close button
//                }
//
//                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the bubble
//                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
//                }
//
//                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the background dim
//                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
//                }
//            })
//    }
//
//    private fun zoomImageView(position: BubbleShowCase.ArrowPosition): BubbleShowCaseBuilder {
//        return BubbleShowCaseBuilder(this)
//            .title(getString(R.string.zoom_image_view_title))
//            .description(getString(R.string.zoom_image_view_description))
//            .arrowPosition(position)
//            .backgroundColor(ContextCompat.getColor(this, R.color.curl_guideView_color))
//            .image(ContextCompat.getDrawable(this, R.drawable.ic_zoom)!!)
//            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
//            .textColor(ContextCompat.getColor(this, R.color.curl_guideView_text_color))
//            .targetView(fab2)
//            .listener(object : BubbleShowCaseListener { //Listener for user actions
//                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the target
//                }
//
//                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the close button
//                }
//
//                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the bubble
//                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
//                }
//
//                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the background dim
//                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
//                }
//            })
//    }
//
//    private fun moveLeftAlbumViewPage(position: BubbleShowCase.ArrowPosition): BubbleShowCaseBuilder {
//        return BubbleShowCaseBuilder(this)
//            .title(getString(R.string.move_left_album_view_page_title))
//            .description(getString(R.string.move_left_album_view_page_description))
//            .arrowPosition(position)
//            .backgroundColor(ContextCompat.getColor(this, R.color.curl_guideView_color))
//            .image(ContextCompat.getDrawable(this, R.drawable.ic_chevron_left_arrow)!!)
//            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
//            .textColor(ContextCompat.getColor(this, R.color.curl_guideView_text_color))
//            .targetView(fab4)
//            .listener(object : BubbleShowCaseListener { //Listener for user actions
//                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the target
//                }
//
//                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the close button
//                }
//
//                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the bubble
//                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
//                }
//
//                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the background dim
//                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
//                }
//            })
//    }
//
//    private fun moveRightAlbumViewPage(position: BubbleShowCase.ArrowPosition): BubbleShowCaseBuilder {
//        return BubbleShowCaseBuilder(this)
//            .title(getString(R.string.move_right_album_view_page_title))
//            .description(getString(R.string.move_right_album_view_page_description))
//            .arrowPosition(position)
//            .backgroundColor(ContextCompat.getColor(this, R.color.curl_guideView_color))
//            .image(ContextCompat.getDrawable(this, R.drawable.ic_launcher_right_arrow)!!)
//            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
//            .textColor(ContextCompat.getColor(this, R.color.curl_guideView_text_color))
//            .targetView(fab3)
//            .listener(object : BubbleShowCaseListener { //Listener for user actions
//                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the target
//                }
//
//                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the close button
//                }
//
//                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the bubble
//                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
//                }
//
//                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the background dim
//                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
//                }
//            })
//    }
//
//    private fun listenMusicLandcapeView(): BubbleShowCaseBuilder {
//        return BubbleShowCaseBuilder(this)
//            .title(getString(R.string.listen_music_title))
//            .description(getString(R.string.listen_music_description))
//            .backgroundColor(ContextCompat.getColor(this, R.color.curl_guideView_color))
//            .image(ContextCompat.getDrawable(this, R.drawable.ic_music_note_black_24dp)!!)
//            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
//            .textColor(ContextCompat.getColor(this, R.color.curl_guideView_text_color))
//            .targetView(fab5)
//            .listener(object : BubbleShowCaseListener { //Listener for user actions
//                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the target
//                }
//
//                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the close button
//                }
//
//                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the bubble
//                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
//                }
//
//                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the background dim
//                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
//                }
//            })
//    }
//
//    private fun listenMusic(position: BubbleShowCase.ArrowPosition): BubbleShowCaseBuilder {
//        return BubbleShowCaseBuilder(this)
//            .title(getString(R.string.listen_music_title))
//            .description(getString(R.string.listen_music_description))
//            .arrowPosition(position)
//            .backgroundColor(ContextCompat.getColor(this, R.color.curl_guideView_color))
//            .image(ContextCompat.getDrawable(this, R.drawable.ic_music_note_black_24dp)!!)
//            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
//            .textColor(ContextCompat.getColor(this, R.color.curl_guideView_text_color))
//            .targetView(fab5)
//            .listener(object : BubbleShowCaseListener { //Listener for user actions
//                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the target
//                }
//
//                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the close button
//                }
//
//                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the bubble
//                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
//                }
//
//                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the background dim
//                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
//                }
//            })
//    }
//
//    fun bubbleShowbackPressLandscapeView(): BubbleShowCaseBuilder {
//        return BubbleShowCaseBuilder(this).title(getString(R.string.back_press_title))
//            .backgroundColor(ContextCompat.getColor(this, R.color.curl_guideView_color))
//            .image(ContextCompat.getDrawable(this, R.drawable.ic_back_arrow)!!)
//            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
//            .textColor(ContextCompat.getColor(this, R.color.curl_guideView_text_color))
//            .targetView(back_arrow_fab)
//            .listener(object : BubbleShowCaseListener { //Listener for user actions
//                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the target
//                }
//
//                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the close button
//                }
//
//                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the bubble
//                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
//                }
//
//                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the background dim
//                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
//                }
//            })
//    }
//
//    private fun shareEventLandscapeView(): BubbleShowCaseBuilder {
//        return BubbleShowCaseBuilder(this)
//            .title(getString(R.string.share_event_title))
//            .description(getString(R.string.share_event_description))
//            .backgroundColor(ContextCompat.getColor(this, R.color.curl_guideView_color))
//            .image(ContextCompat.getDrawable(this, R.drawable.ic_share_black_24dp)!!)
//            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
//            .textColor(ContextCompat.getColor(this, R.color.curl_guideView_text_color))
//            .targetView(fab7)
//            .listener(object : BubbleShowCaseListener { //Listener for user actions
//                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the target
//                }
//
//                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks the close button
//                }
//
//                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the bubble
//                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
//                }
//
//                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
//                    //Called when the user clicks on the background dim
//                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
//                }
//            })
//    }
//
//    private fun getSequence(): BubbleShowCaseSequence {
//        DLog("Success", "Ok1")
//        if (albumOrientation == 1) {
//            return BubbleShowCaseSequence().addShowCases(listOf(
//                bubbleShowbackPressLandscapeView(),
//                showImageViewSliderLandscapeView(),
//                zoomImageViewLandscapeView(),
//                listenMusicLandcapeView(),
//                shareEventLandscapeView()
//            ))
//        } else {
//            return BubbleShowCaseSequence().addShowCases(listOf(
//                showImageViewSlider(BubbleShowCase.ArrowPosition.LEFT),
//                zoomImageView(BubbleShowCase.ArrowPosition.LEFT),
//                moveLeftAlbumViewPage(BubbleShowCase.ArrowPosition.LEFT),
//                moveRightAlbumViewPage(BubbleShowCase.ArrowPosition.LEFT),
//                bubbleShowbackPressLandscapeView(),
//                listenMusicLandcapeView(),
//                shareEventLandscapeView()
//            ))
//        }
//    }
//
//    private fun getSequence1(): BubbleShowCaseSequence {
//        return BubbleShowCaseSequence().addShowCases(listOf(
//            moveLeftAlbumViewPage(BubbleShowCase.ArrowPosition.RIGHT),
//            moveRightAlbumViewPage(BubbleShowCase.ArrowPosition.RIGHT)
//        ))
//    }
//
//    private fun getSequence2(position: Int): BubbleShowCaseSequence {
//        DLog("Success", "Ok1")
//        if (position == 1) {
//            return BubbleShowCaseSequence().addShowCases(listOf(
//                moveLeftAlbumViewPage(BubbleShowCase.ArrowPosition.RIGHT),
//                moveRightAlbumViewPage(BubbleShowCase.ArrowPosition.RIGHT),
//                bubbleShowbackPressLandscapeView(),
//                showImageViewSliderLandscapeView(),
//                zoomImageViewLandscapeView(),
//                listenMusicLandcapeView(),
//                shareEventLandscapeView()
//            ))
//        } else {
//            return BubbleShowCaseSequence().addShowCases(listOf(
//                showImageViewSlider(BubbleShowCase.ArrowPosition.LEFT),
//                zoomImageView(BubbleShowCase.ArrowPosition.LEFT),
//                moveLeftAlbumViewPage(BubbleShowCase.ArrowPosition.LEFT),
//                moveRightAlbumViewPage(BubbleShowCase.ArrowPosition.LEFT),
//                bubbleShowbackPressLandscapeView(),
//                listenMusicLandcapeView(),
//                shareEventLandscapeView()
//            ))
//        }
//    }
//
//    private fun loadNextPageWithFlipAnimationRightToLeft() {
//        fab3.isClickable = false
//        val fromXPosition = intArrayOf(curl.right)
//        val fromYPosition = curl.top
//        val toXPosition = curl.left
//        val downTime = SystemClock.uptimeMillis()
//        val eventTime = SystemClock.uptimeMillis()
//        val me = arrayOf(MotionEvent.obtain(downTime, eventTime, MotionEvent.ACTION_DOWN, fromXPosition[0].toFloat(), fromYPosition.toFloat(), 0))
//
//        DLog("FAB3 current index", "$fromXPosition $fromYPosition ${toXPosition}")
//        curl.dispatchTouchEvent(me[0])
//        val handler = Handler()
//        handler.postDelayed(object : Runnable {
//            override fun run() {
//                var me = MotionEvent.obtain(downTime, eventTime, MotionEvent.ACTION_MOVE, fromXPosition[0].toFloat(), fromYPosition.toFloat(), 0)
//                curl.dispatchTouchEvent(me)
//                fromXPosition[0] = fromXPosition[0] - 10
//                if (fromXPosition[0] > toXPosition) {
//                    handler.postDelayed(this, 2)
//                    DLog("inside if", "inside")
//                } else {
//                    DLog("inside else", "else")
//                    me = MotionEvent.obtain(downTime, eventTime, MotionEvent.ACTION_UP, fromXPosition[0].toFloat(), fromYPosition.toFloat(), 0)
//                    curl.dispatchTouchEvent(me)
//                    fab3.isClickable = true
//                }
//                DLog("delay mills", "delay")
//            }
//        }, 1)
//    }
//
//    private fun loadNextPageWithFlipAnimationLeftToRight() {
//        fab4.isClickable = false
//        val fromXPosition = intArrayOf(curl.left)
//        val fromYPosition = curl.bottom
//        val toXPosition = curl.right
//        val downTime = SystemClock.uptimeMillis()
//        val eventTime = SystemClock.uptimeMillis()
//        DLog("FAB4 current index", "${fromXPosition} ${fromYPosition} ${toXPosition}")
//
//        val me = arrayOf(MotionEvent.obtain(downTime, eventTime, MotionEvent.ACTION_DOWN, fromXPosition[0].toFloat(), fromYPosition.toFloat(), 0))
//        curl.dispatchTouchEvent(me[0])
//        val handler = Handler()
//        handler.postDelayed(object : Runnable {
//            override fun run() {
//                var me = MotionEvent.obtain(downTime, eventTime, MotionEvent.ACTION_MOVE, fromXPosition[0].toFloat(), fromYPosition.toFloat(), 0)
//                curl.dispatchTouchEvent(me)
//                fromXPosition[0] = fromXPosition[0] + 10
//                if (fromXPosition[0] < toXPosition) {
//                    handler.postDelayed(this, 2)
//                } else {
//                    me = MotionEvent.obtain(downTime, eventTime, MotionEvent.ACTION_UP, fromXPosition[0].toFloat(), fromYPosition.toFloat(), 0)
//                    curl.dispatchTouchEvent(me)
//                    fab4.isClickable = true
//                }
//            }
//        }, 1)
//    }
//
//    fun autoPlayPage() {
//        val fromXPosition = intArrayOf(curl.getRight())
//        val fromYPosition = curl.getTop()
//        val toXPosition = curl.getLeft()
//        val downTime = SystemClock.uptimeMillis()
//        val eventTime = SystemClock.uptimeMillis()
//        val me = arrayOf(MotionEvent.obtain(downTime, eventTime, MotionEvent.ACTION_DOWN, fromXPosition[0].toFloat(), fromYPosition.toFloat(), 0))
//        curl.dispatchTouchEvent(me[0])
//
//        for (images in 0 until imageNamesArrayList.size / 2) {
//            DLog("FAB3 current index", "${images} ")
//            val handler = Handler()
//            handler.postDelayed(object : Runnable {
//                override fun run() {
//                    var me = MotionEvent.obtain(downTime, eventTime, MotionEvent.ACTION_MOVE, fromXPosition[0].toFloat(), fromYPosition.toFloat(), 0)
//                    curl.dispatchTouchEvent(me)
//                    fromXPosition[0] = fromXPosition[0] - 10
//                    if (fromXPosition[0] > toXPosition) {
//                        handler.postDelayed(this, 2)
//                    } else {
//                        me = MotionEvent.obtain(downTime, eventTime, MotionEvent.ACTION_UP, fromXPosition[0].toFloat(), fromYPosition.toFloat(), 0)
//                        curl.dispatchTouchEvent(me)
//                    }
//                }
//            }, 1)
//        }
//        DLog("FAB3 current index", "${fromXPosition} ${fromYPosition} ${toXPosition}")
//    }
//
//    private val MESSAGE_CLEAR = 0
//    private val MESSAGE_INIT_DISK_CACHE = 1
//    private val MESSAGE_FLUSH = 2
//    private val MESSAGE_CLOSE = 3
//
//    inner class CacheAsyncTask : AsyncTask<Any, Void, Void>() {
//
//        override fun doInBackground(vararg params: Any): Void? {
//            when (params[0] as Int) {
//                MESSAGE_CLEAR -> imageCache1?.clearCache()
//                MESSAGE_INIT_DISK_CACHE -> imageCache1?.initDiskCache()
//                MESSAGE_FLUSH -> imageCache1?.flush()
//                MESSAGE_CLOSE -> imageCache1?.close()
//            }
//            return null
//        }
//    }
//
//    fun getSampleEmptyBitmap(): Bitmap {
//        var bitmap = Bitmap.createBitmap(320, 426, Bitmap.Config.ARGB_8888)
//        var canvas = Canvas(bitmap)
//        var paint = Paint()
//        paint.color = Color.WHITE
//        canvas.drawRect(0F, 0F, 320.toFloat(), 426.toFloat(), paint)
//        return bitmap
//    }
//
//    fun drawTextToBitmap(bitmap: Bitmap): Bitmap {
//        var text = "Loading..."
//        var scale = resources.displayMetrics.density
//        var bitmapConfig = bitmap.config
//        // set default bitmap config if none
//        if (bitmapConfig == null) {
//            bitmapConfig = Bitmap.Config.ARGB_8888
//        }
//        // resource bitmaps are imutable,
//        // so we need to convert it to mutable one
//        var newBitmap = bitmap.copy(bitmapConfig, true)
//        var canvas = Canvas(newBitmap)
//        // new antialised Paint
//        var paint = Paint(Paint.ANTI_ALIAS_FLAG)
//        // text color - #3D3D3D
//        //paint.color = Color.rgb(61, 61, 61)
//        paint.color = Color.BLACK
//        // text size in pixels
//        paint.textSize = 25 * scale
//        // text shadow
//        paint.setShadowLayer(1f, 0f, 1f, Color.WHITE)
//        // draw text to the Canvas center
//        var bounds = Rect()
//        paint.getTextBounds(text, 0, text.length, bounds)
//        var x = (bitmap.width - bounds.width()) / 2
//        var y = (bitmap.height + bounds.height()) / 2
//        canvas.drawText(text, x.toFloat(), y.toFloat(), paint)
//        return newBitmap
//    }
//
//    fun drawTextToBitmap1(bitmapOriginal: Bitmap): Bitmap {
//        var textToDraw = "Loading..."
//        var newBitmap = bitmapOriginal.copy(bitmapOriginal.config, true)
//        var newCanvas = Canvas(newBitmap)
//        var paint = Paint(Paint.ANTI_ALIAS_FLAG)
//        paint.color = Color.RED
//        paint.textSize = 50.toFloat()
//        var bounds = Rect()
//        paint.getTextBounds(textToDraw, 0, textToDraw.length, bounds)
//        var x = 0
//        var y = newBitmap.height
//        newCanvas.drawText(textToDraw, x.toFloat(), y.toFloat(), paint)
//        return newBitmap
//    }
//
//    fun drawTextToBitmap2(): Bitmap {
//        var bitmapOriginal = BitmapFactory.decodeResource(resources, R.drawable.image_load_landscape)
//        var textToDraw = "Loading..."
//        var newBitmap = bitmapOriginal.copy(bitmapOriginal.config, true)
//        var newCanvas = Canvas(newBitmap)
//        var paint = Paint(Paint.ANTI_ALIAS_FLAG or Paint.LINEAR_TEXT_FLAG)
//        paint.color = Color.RED
//        paint.textSize = 1500.toFloat()
//        var bounds = Rect()
//        paint.getTextBounds(textToDraw, 0, textToDraw.length, bounds)
//        var x = 0
//        //var y = newBitmap.height
//        var y = 0
//        newCanvas.drawText(textToDraw, x.toFloat(), y.toFloat(), paint)
//        return newBitmap
//    }
//
//    fun getFile(imageName: String): File {
//        val applicationDirectory = applicationContext.applicationInfo.dataDir
//        return File("$applicationDirectory/app_flutter/$imageName")
//    }
//
//}