package `in`.photomall.photomall_flutter.view.activity

//import com.photomall.photoalbum.photomallUser.decodeImageThreadPool.DecodeImageResultUpdateTaskListener
import `in`.photomall.photomall_flutter.R
//import `in`.photomall.photomall_flutter.adapter.ImageViewSliderAdapter1
import `in`.photomall.photomall_flutter.api.*
import `in`.photomall.photomall_flutter.api.AppConst.IS_LOG_ENABLED
import `in`.photomall.photomall_flutter.api.SharedPreferenceConst.FIRST_IMAGE_ZOOM
import `in`.photomall.photomall_flutter.api.SharedPreferenceConst.SECOND_IMAGE_ZOOM
import `in`.photomall.photomall_flutter.appUtils.InsertAlbums
import `in`.photomall.photomall_flutter.appUtils.memoryManagement.MemUtils.megaBytesFree
import `in`.photomall.photomall_flutter.appUtils.memoryManagement.MemUtils.readBitmapInFo
import `in`.photomall.photomall_flutter.appUtils.memoryManagement.MemUtils.subSampleImage
import `in`.photomall.photomall_flutter.asyncTask.GetUnDownloadedImageUrlWorker
import `in`.photomall.photomall_flutter.database.AlbumImageType
import `in`.photomall.photomall_flutter.database.DBStatics
import `in`.photomall.photomall_flutter.database.DbHelper
import `in`.photomall.photomall_flutter.database.TransportDataKeys
import `in`.photomall.photomall_flutter.interfaces.AlbumThumbnailDownloadCompletedListener
import `in`.photomall.photomall_flutter.interfaces.ImageDownloadCompleted
import `in`.photomall.photomall_flutter.model.api.RefreshImageUrl
import `in`.photomall.photomall_flutter.model.api.jvtFilesUrl.JvtFilesTemporaryUrl
import `in`.photomall.photomall_flutter.model.other.AlbumOrdersModel
import `in`.photomall.photomall_flutter.retrofitHelper.APICall
import `in`.photomall.photomall_flutter.retrofitHelper.APICallForJson
import `in`.photomall.photomall_flutter.retrofitHelper.APIListener
import `in`.photomall.photomall_flutter.threadPool.DownloadManager
import `in`.photomall.photomall_flutter.threadPool.DownloadResultUpdateTask
import `in`.photomall.photomall_flutter.threadPool.DownloadResultUpdateTaskListener
import `in`.photomall.photomall_flutter.threadPool.DownloadTask
import `in`.photomall.photomall_flutter.utils.*
import `in`.photomall.photomall_flutter.utils.EncryptAndDecryptFiles.decodeFileWithSplit
import `in`.photomall.photomall_flutter.utils.Others.DLog
import `in`.photomall.photomall_flutter.utils.Others.isAvailableExternalMemorySize
import `in`.photomall.photomall_flutter.utils.SharedPreferenceHelper.Companion.getIntPreference
import `in`.photomall.photomall_flutter.utils.SharedPreferenceHelper.Companion.setIntPreference
import `in`.photomall.photomall_flutter.utils.SharedPreferenceHelper.Companion.setStringPreference
import `in`.photomall.photomall_flutter.utils.appColors.AppColors
import `in`.photomall.photomall_flutter.utils.bitmapHandler.BitmapImageCache
import `in`.photomall.photomall_flutter.utils.bitmapHelper.ImageCache1
import `in`.photomall.photomall_flutter.utils.bubbleShowCase.BubbleShowCase
import `in`.photomall.photomall_flutter.utils.bubbleShowCase.BubbleShowCaseBuilder
import `in`.photomall.photomall_flutter.utils.bubbleShowCase.BubbleShowCaseListener
import `in`.photomall.photomall_flutter.utils.bubbleShowCase.BubbleShowCaseSequence
import `in`.photomall.photomall_flutter.utils.curl.CurlPage
import `in`.photomall.photomall_flutter.utils.curl.CurlView
import `in`.photomall.photomall_flutter.view.dialogFragment.ZoomImageDialogFragment
import `in`.photomall.photomall_flutter.worker.UpdateAlbumImagesWorker
import android.animation.Animator
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.res.AssetFileDescriptor
import android.content.res.ColorStateList
import android.database.Cursor
import android.database.CursorIndexOutOfBoundsException
import android.database.DatabaseUtils
import android.graphics.*
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.GradientDrawable
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaPlayer
import android.os.*
import android.util.DisplayMetrics
import android.view.MotionEvent
import android.view.View
import android.view.ViewTreeObserver
import android.view.WindowManager
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import androidx.lifecycle.Observer
import androidx.viewbinding.ViewBinding
import androidx.work.Data
import androidx.work.OneTimeWorkRequest
import androidx.work.WorkInfo
import androidx.work.WorkManager
import com.google.android.material.floatingactionbutton.FloatingActionButton
import com.google.gson.Gson
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import com.photomall.photoalbum.photomallUser.appUtils.downloadImagesUtils.DownloadTempImages
import `in`.photomall.photomall_flutter.adapter.ImageViewSliderAdapter1
import `in`.photomall.photomall_flutter.databinding.ActivityCurlLandscapeBinding
import `in`.photomall.photomall_flutter.databinding.ActivityCurlPortraitBinding
import `in`.photomall.photomall_flutter.databinding.ActivityCurlSquareBinding
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.time.delay
//import kotlinx.android.synthetic.main.activity_curl_landscape.*
//import kotlinx.android.synthetic.main.activity_curl_portrait.fab7
//import kotlinx.android.synthetic.main.activity_curl_portrait.fab_layout
//import kotlinx.android.synthetic.main.activity_curl_square.fabLayout1
//import kotlinx.android.synthetic.main.activity_sample.*
import java.io.File
import java.io.FileInputStream
import java.io.IOException
import java.lang.ref.SoftReference
import java.net.HttpURLConnection
import java.net.URL
import java.time.Duration
import java.util.*

data class SinglePageData(
    val imageType: Int,
    val imageName: String,
    val extension: String,
)

class CurlActivity : AppCompatActivity(), ImageDownloadCompleted,
    AlbumThumbnailDownloadCompletedListener, DownloadResultUpdateTaskListener, APIListener {
    //DecodeImageResultUpdateTaskListener {

    //internal var albumName: String? = null
    private var clickedPositon: Int = 0
    var albumCode: String? = null
    var albumType: Int? = null
    var lastUpdatedAt: Int? = null
    internal var viewPager: androidx.viewpager.widget.ViewPager? = null
    internal var mToolbar: Toolbar? = null
    internal var dbHelper: DbHelper? = null
    internal var mContext: Context? = null
    var k: Int = 0
    var a = 1
    var isShowAlbum = true

    //private var mCurlView: CurlView? = null
    var indexvalue: Int? = 0
    private var y: Bitmap? = null

    var imageNames: Cursor? = null

    var clickedPosition: Int = 0

    var imageNamesArrayList = ArrayList<SinglePageData>()
    var imageNamesArrayListSize: Int = 0
    var bitmapHashMap = LinkedHashMap<String, Bitmap>()
    var bitmapHashMap1 = LinkedHashMap<String, SoftReference<Bitmap>>()
    var totalUndownloadedImages: Int? = 1
    var totalDownloadedImages: Int? = null

    lateinit var curl: CurlView

    //private var isUp: Boolean = false
    private var isUp: Boolean = true

    var imageArrayList = ArrayList<String>()

    var mStateOfCurl: String = "0"
    var currentIndexValue: Int = 0

    var onBackPressedValue: Boolean = false

    var mWakeLock: PowerManager.WakeLock? = null

    internal var isFABOpen = false

    var music: String? = null
    var musicCode: String? = null

    var mPlayer: MediaPlayer? = null

    var afd: AssetFileDescriptor? = null

    var i = 0
    //var gifImageView: GifImageView? = null

    var guideView: Boolean = false
    var guideView1: Int = 0


    //Merge Images variables
    var filePath: String? = null
    var bitmapImage: Bitmap? = null
    var filePath1: String? = null
    var bitmapImage1: Bitmap? = null
    var mergedImages: Bitmap? = null

    var result: Bitmap? = null
    var canvas: Canvas? = null
    var resized: Bitmap? = null
    var photoUrl: String? = null
    var image: File? = null
    var image1: File? = null
    lateinit var albumSize: String
    var folderPath: String? = null
    var mergedBitmapImageNameArrayList = ArrayList<Bitmap>()

    //    var albumUrl: String? = null
//    var passcode: String? = null
    var musicPlay: Boolean = false
    var length: Int = 0

    //var pm: PowerManager? = null
    var projectFolder: File? = null

    var albumOrientation = 0

    //var eventsRandomId: String? = null
    var eventsPasscode: Int = 0
    var eventsUrl: String? = null
    var eventsType: Int = 0
    var isNeedToRefresh: Boolean? = null
    var eventCode: String? = null
    var canTakeScreenshot: Boolean? = null

    var isAlbumVisible: Boolean = false
    var orientation: String? = null

    var insufficientStorage: Boolean = true

    var numberOfHalfImages = 0
    var totalAlbumPaperSize = 0
    var albumImagesMap = LinkedHashMap<String, ArrayList<String>>()
    var isActivityForeground: Boolean = true
    var tmp: Bitmap? = null
    var b: Bitmap? = null
    var curlViewGoneThread: Thread? = null
    var cache: BitmapImageCache? = null

    var imageCache1: ImageCache1? = null
    var decodedImagesCount: Int = 0

    var loadBitmap: Bitmap? = null

    var imageDecodeImage: ImageDecodeImage? = null

    var curlViewWidth: Int? = null

    var curlViewHeight: Int? = null

    var sampleBitmap: Bitmap? = null

    var isMusicStopped: Boolean = false
    var isSlideShowStopped: Boolean = true

    var apiCall: APICall? = null
    var apiCallForJson: APICallForJson? = null
    private lateinit var activityCurlLandscapeBinding: ActivityCurlLandscapeBinding
    private lateinit var activityCurlPortraitBinding: ActivityCurlPortraitBinding
    private lateinit var activityCurlSquareBinding: ActivityCurlSquareBinding
    fun getView(): ViewBinding {
        return if (albumOrientation == 1) {
            activityCurlLandscapeBinding
        } else if (albumOrientation == 2) {
            activityCurlPortraitBinding
        } else {
            activityCurlSquareBinding
        }
    }

    @SuppressLint("ClickableViewAccessibility", "InvalidWakeLockTag")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        canTakeScreenshot = if (intent.hasExtra("canTakeScreenshot")) {
            intent.extras!!.getBoolean("canTakeScreenshot")
        } else {
            false
        }
        //Couldn't Capture Screenshot
        //if (!IS_LOG_ENABLED) {
        if (!canTakeScreenshot!!) {
            window.setFlags(
                WindowManager.LayoutParams.FLAG_SECURE,
                WindowManager.LayoutParams.FLAG_SECURE
            )
        }

        /*albumName = if (intent.hasExtra("album_name")) {
            intent.extras!!.getString("album_name")
        } else {
            ""
        }*/

        eventCode = if (intent.hasExtra("eventCode")) {
            intent.extras!!.getString("eventCode")
        } else {
            ""
        }



        albumCode = if (intent.hasExtra("albumCode")) {
            intent.extras!!.getString("albumCode")
        } else {
            ""
        }

        albumType = if (intent.hasExtra("albumType")) {
            intent.extras!!.getInt("albumType")
        } else {
            1
        }

        lastUpdatedAt = if (intent.hasExtra("updatedAt")) {
            intent.extras!!.getInt("updatedAt")
        } else {
            1
        }

        musicCode = if (intent.hasExtra("musicFileName")) {
            intent.extras!!.getString("musicFileName")
        } else {
            ""
        }
        //music = ""

        albumSize = if (intent.hasExtra("albumSize")) {
            intent?.extras?.getString("albumSize")!!
        } else {
            ""
        }

        eventsType = if (intent.hasExtra("eventType")) {
            intent.extras!!.getInt("eventType")
        } else {
            WebConstants.STUDIO_GALLERY_EVENT
        }

        isNeedToRefresh = if (intent.hasExtra("isNeedToRefresh")) {
            intent.extras!!.getBoolean("isNeedToRefresh")
        } else {
            false
        }


        albumOrientation = if (intent.hasExtra("orientation")) {

            when {
                intent?.extras?.getString("orientation")!! == "Landscape" -> {
                    orientation = "Landscape"
                    1 //landscape
                }

                intent?.extras?.getString("orientation")!! == "Portrait" -> {
                    orientation = "Portrait"
                    2 //portrait
                }

                else -> {
                    orientation = "Square"
                    3 //square
                }
            }
        } else {
            3
        }


        when (albumOrientation) {
            1 -> {
                activityCurlLandscapeBinding = ActivityCurlLandscapeBinding.inflate(layoutInflater)
                val view = activityCurlLandscapeBinding.root
                setContentView(view)
                //setContentView(R.layout.activity_curl_landscape)
            }

            2 -> {
                activityCurlPortraitBinding = ActivityCurlPortraitBinding.inflate(layoutInflater)
                val view = activityCurlPortraitBinding.root
                setContentView(view)
                // setContentView(R.layout.activity_curl_portrait)
            }

            else -> {
                activityCurlSquareBinding = ActivityCurlSquareBinding.inflate(layoutInflater)
                val view = activityCurlSquareBinding.root
                setContentView(view)
                //setContentView(R.layout.activity_curl_square)
            }
        }

        mContext = this@CurlActivity
        //dbHelper = DbHelper.getInstance(mContext!!.applicationContext)
        dbHelper = DbHelper(mContext!!)

        apiCall = APICall(this)
        apiCallForJson = APICallForJson(this)

        val cacheParams = ImageCache1.ImageCacheParams(this, ".images/ai")
        //cacheParams.setMemCacheSizePercent(0.99f) // Set memory cache to 25% of app memory

        if (dbHelper?.getAlbumStorageSize(albumCode!!)!! != 0) {
            cacheParams.setDiskCacheSizePercent((dbHelper?.getAlbumStorageSize(albumCode!!)!! * 2))
        }

        imageCache1 = ImageCache1(cacheParams)
        CacheAsyncTask().execute(MESSAGE_INIT_DISK_CACHE)

        saveWidthAndHeightInPreference()

       curl = findViewById(R.id.curl_view)

        isMusicStopped = SharedPreferenceHelper.getBooleanPreference(
            mContext!!,
            SharedPreferenceConst.isMusicStopped,
            false
        )

        //getCurlActivityData()

        projectFolder = StorageUtils.getCacheFolder(this)

        /*progressBar!!.progressDrawable.setColorFilter(
            ContextCompat.getColor(mContext!!, R.color.white), PorterDuff.Mode.SRC_IN
        )*/

        val sizeArray = albumSize.split("x").toTypedArray()
        DLog("ratio", "${sizeArray.size} ${sizeArray[0]} ")

        val width = sizeArray[0].toInt()
        val height = sizeArray[1].toInt()
        calculateRatio(width, height)

        DLog("ratio", "$width,$height")
        clickedPositon = 1

        curl.currentIndex = 0

        curl.setOnClickListener {
            DLog("Curl", "Curl")
        }

        //isUp = false
        isUp = true

        DLog("imageView_slider_recyclerView :", "${dbHelper!!.isOriginalsDownload(albumCode!!)}")
        activityCurlLandscapeBinding.fab.setOnClickListener {
           // activityCurlLandscapeBinding.fab8.visibility =
               // if (activityCurlLandscapeBinding.fab8.visibility == View.VISIBLE) View.GONE else View.VISIBLE

            openMenu()
        }

        activityCurlLandscapeBinding.backArrowFab.setOnClickListener {
            this.finish()
        }

        activityCurlLandscapeBinding.fab1.setOnClickListener {
            DLog("isUpzzz", "$isUp")
            if (isUp) {
                DLog("isUp", "onPause  if")
                slideDown(activityCurlLandscapeBinding.imageviewSliderRecyclerView)
                //imageview_slider_recyclerView.visibility = View.GONE
                //   loadNextPageWithFlipAnimationRightToLeft()
            } else {
                DLog("isDown", "onPause  else")
                slideUp(activityCurlLandscapeBinding.imageviewSliderRecyclerView)
                // loadNextPageWithFlipAnimationLeftToRight()
            }
            //isUp = !isUp
        }

        fun setUserInteractionEnabled(enabled: Boolean) {
            activityCurlLandscapeBinding.curlView.setOnTouchListener { _, _ -> !enabled }
        }
        var job: Job? = null // Job reference to control execution
        var job1: Job? = null // Job reference to control execution

        fun runFab8ClickPeriodically() {
            job?.cancel()
            job1?.cancel()

            job = CoroutineScope(Dispatchers.Main).launch {
                var index =curl.currentIndex+1
                DLog("play button :", "play button current index $index")

                repeat(imageNamesArrayList.size+imageNamesArrayList.size+imageNamesArrayList.size) {
                    DLog("play button :"," loadNextPageWithFlipAnimationRightToLeft current index $index")

                    DLog("play button :", "play button clicked")
                    if (!isSlideShowStopped && index != imageNamesArrayList.size ) {
                        loadNextPageWithFlipAnimationRightToLeft()
                        index =curl.currentIndex
                        delay(Duration.ofSeconds(3))
                    }// Wait for 1 second before the next click
                }
                job = null // Reset job after completion

                // Start the second loop **after** the first one is fully completed
                job1 = launch {
                    repeat(imageNamesArrayList.size+imageNamesArrayList.size+imageNamesArrayList.size) {
                        DLog("play button :"," loadNextPageWithFlipAnimationLeftToRight current index $index")

                        if (!isSlideShowStopped && index != 0) {

                            DLog("play button :", "play button clicked")
                            loadNextPageWithFlipAnimationLeftToRight()
                            index =curl.currentIndex
                            delay(Duration.ofSeconds(3)) // Wait for 1 second before the next click
                        }
                    }
                    isSlideShowStopped = true
                    activityCurlLandscapeBinding.fab8.setImageResource(if (isSlideShowStopped) R.drawable.play_icon else R.drawable.pause_icon)
                    setColors()

                    job1 = null // Reset job after completion
                }
            }
        }
        activityCurlLandscapeBinding.fab8.setOnClickListener {
            isSlideShowStopped = !isSlideShowStopped
            activityCurlLandscapeBinding.fab8.setImageResource(if (isSlideShowStopped) R.drawable.play_icon else R.drawable.pause_icon)
            setColors()

            DLog(
                "play button :",
                    "setColors play button clicked ${imageArrayList.size} ${imageNamesArrayList.size}"
            )
            runFab8ClickPeriodically()


        }
        val vto = activityCurlLandscapeBinding.curlView.viewTreeObserver
        vto.addOnPreDrawListener(object : ViewTreeObserver.OnPreDrawListener {
            override fun onPreDraw(): Boolean {
                activityCurlLandscapeBinding.curlView.viewTreeObserver.removeOnPreDrawListener(this)
                /*val height = curl_view.getMeasuredHeight()
                val width = curl_view.getMeasuredWidth()*/
                curlViewHeight = activityCurlLandscapeBinding.curlView.measuredHeight
                curlViewWidth = activityCurlLandscapeBinding.curlView.measuredWidth / 2
                DLog(
                    "CurlActivity :",
                    "addOnPreDrawListener() CURL: W : ${curlViewWidth!! / 2} : $curlViewHeight"
                )

                sampleBitmap =
                    Bitmap.createBitmap(curlViewWidth!!, curlViewHeight!!, Bitmap.Config.ARGB_8888)
                //var bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
                val canvas = Canvas(sampleBitmap!!)
                val paint = Paint()
                paint.color = Color.WHITE
                canvas.drawRect(
                    0F,
                    0F,
                    curlViewWidth!!.toFloat(),
                    curlViewHeight!!.toFloat(),
                    paint
                )

                //val conf = Bitmap.Config.ARGB_8888 // see other conf types
                //sampleBitmap = Bitmap.createBitmap(curlViewWidth!!, curlViewHeight!!, conf)

                return true
            }
        })
        activityCurlLandscapeBinding.fab2.setOnClickListener {
            val vto = activityCurlLandscapeBinding.curlView.viewTreeObserver
            vto.addOnPreDrawListener(object : ViewTreeObserver.OnPreDrawListener {
                override fun onPreDraw(): Boolean {
                    activityCurlLandscapeBinding.curlView.viewTreeObserver.removeOnPreDrawListener(
                        this
                    )
                    val height = activityCurlLandscapeBinding.curlView.measuredHeight
                    val width = activityCurlLandscapeBinding.curlView.measuredWidth
                    DLog("ViewEventAlbumsAdapter :", "inside bind onGlobalLayout $width : $height")

                    val dialog = ZoomImageDialogFragment()
                    val bundle = Bundle()
                    //bundle.putInt("Album_Size", albumOrientation)
                    //bundle.putInt("arraylist_size", imageNamesArrayListSize)
                    bundle.putInt("width", width)
                    bundle.putInt("height", height)
                    bundle.putInt(
                        "typeOfScreen",
                        1
                    )   // 1-->curl activity , 2--> GalleryCurl activity
                    dialog.arguments = bundle
                    //dialog.setLisener(this)
                    dialog.show(supportFragmentManager, "image")

                    return true
                }
            })
        }


        activityCurlLandscapeBinding.fab3.setOnClickListener {
            // right to left curl
            // showToast()
            isSlideShowStopped =true
            loadNextPageWithFlipAnimationRightToLeft()
        }

        activityCurlLandscapeBinding.fab4.setOnClickListener {
            //left to right curl
            //showToast()
            isSlideShowStopped = true;
            loadNextPageWithFlipAnimationLeftToRight()
        }

        if (isMusicStopped) {
            activityCurlLandscapeBinding.fab5.setImageResource(R.drawable.ic_music_stop_note_black_24dp)
            i = 2
        } else {
            activityCurlLandscapeBinding.fab5.setImageResource(R.drawable.ic_music_note_black_24dp)
            i = 0
        }


        setColors()

        activityCurlLandscapeBinding.fab5.setOnClickListener {
            try {
                DLog("setOnClickListener", "${i}")
                if (i == 0) {
                    activityCurlLandscapeBinding.fab5.setImageResource(R.drawable.ic_music_stop_note_black_24dp)
                    DLog("CurlActivitySetOnClickListener", "MusicStopped")
                    mPlayer?.pause()
                    i = 2
                    SharedPreferenceHelper.setBooleanPreference(
                        mContext!!,
                        SharedPreferenceConst.isMusicStopped,
                        true
                    )
                } else if (i == 2) {
                    activityCurlLandscapeBinding.fab5.setImageResource(R.drawable.ic_music_note_black_24dp)

                    DLog("CurlActivitySetOnClickListener", "MusicOn")
                    mPlayer?.start()
                    i = 0
                    SharedPreferenceHelper.setBooleanPreference(
                        mContext!!,
                        SharedPreferenceConst.isMusicStopped,
                        false
                    )
                }
                activityCurlLandscapeBinding.fab5.backgroundTintList = ColorStateList.valueOf(
                    AppColors.getColor(
                        this,
                        "#${MainActivity.iconBackgroundColor}"
                    )
                )
                activityCurlLandscapeBinding.fab5.setColorFilter(
                    AppColors.getColor(
                        this,
                        "#${MainActivity.iconColor}"
                    )
                )
            } catch (e: Exception) {
            }
        }

        activityCurlLandscapeBinding.fab6.setOnClickListener {
            //shareAlbum(albumUrl!!,passcode!!)
            //getSequence().show()

            DLog("ShowHelpInCur", "$albumOrientation")
            if (albumOrientation == 1)
                getSequence2(1).show()
            else
                getSequence2(2).show()
        }

        activityCurlLandscapeBinding.fab7.setOnClickListener {
            if (eventsType == WebConstants.DEMO_EVENT || eventsType == WebConstants.STUDIO_GALLERY_EVENT) {
                Share.app(this, this)
            } else {
                val eventName = dbHelper?.getEventNameUsingEventId(eventCode!!)
                Share.event(
                    this@CurlActivity,
                    this,
                    //eventsPasscode,
                    //eventsUrl!!,
                    eventCode!!,
                    eventName!!
                )
            }
        }

        DLog("CurlActivity : ", "end of the onCreate()")

        if (activityCurlLandscapeBinding.imageviewSliderRecyclerView.visibility == View.VISIBLE) {
            DLog("CurlActivity", "onCreate() :: imageView_slider_recyclerView opened")
        } else {
            DLog("CurlActivity", "onCreate() :: imageView_slider_recyclerView closed")
        }

        //openMenu()
    }

    private fun openMenu() {
        if (!isFABOpen) {
            DLog("is album opened", "opened")
            isFABOpen = true
            if (albumOrientation == 1) {
                showFABMenuIfLandscape()
            } else {
                showFABMenu()
            }
            if (getIntPreference(
                    this,
                    SharedPreferenceConst.GUIDEVIEW_COMPLETED_ALBUM_LANDSCAPE
                ) == 1
            ) {
                //GuideView Function
                getSequence().show()
                setIntPreference(
                    this,
                    SharedPreferenceConst.GUIDEVIEW_COMPLETED_ALBUM_LANDSCAPE,
                    2
                )
            }
            activityCurlLandscapeBinding.fab.setImageDrawable(
                ContextCompat.getDrawable(
                    mContext!!,
                    R.drawable.ic_close_menu_24dp
                )
            )
        } else {
            DLog("is album opened", "closed")
            slideDown(activityCurlLandscapeBinding.imageviewSliderRecyclerView)
            //isUp = !isUp
            isFABOpen = false
            if (albumOrientation == 1) {
                closeFABMenuIfLandscape()
            } else {
                closeFABMenu()
            }
            activityCurlLandscapeBinding.fab.setImageDrawable(
                ContextCompat.getDrawable(
                    mContext!!,
                    R.drawable.ic_menu
                )
            )
        }
    }

    /*fun setImagesInImageArrayList() {
        imageNames = dbHelper?.getClickedAlbumImages(albumId!!)
        DLog(
            "CurlActivityLandscape : ",
            "inside setImagesInImageArrayList ${DatabaseUtils.dumpCursorToString(imageNames)}"
        )
        imageNamesArrayList.clear()
        if (imageNames?.count!! > 0) {
            if (imageNames!!.moveToFirst()) {
                do {
                    imageNamesArrayList.add(imageNames!!.getString(0) + imageNames!!.getString(1))
                } while (imageNames!!.moveToNext())
            }
        }

        imageNamesArrayListSize = imageNamesArrayList.size

        try {
            val index = imageNamesArrayList.indexOf(imageNamesArrayList[0])
            val index1 = imageNamesArrayList[0]
            imageNamesArrayList.removeAt(index)
            imageNamesArrayList.add(imageNamesArrayList.size, index1)
        } catch (e: IndexOutOfBoundsException) {
            DLog("CurlActivity:", e.message.toString())
        }
    }*/

//    private fun setImagesInImageArrayList1() { //
//        imageNames = dbHelper?.getClickedAlbumImages(albumCode!!)
//        DLog(
//            "CurlActivityLandscape : ",
//            "inside setImagesInImageArrayList ${DatabaseUtils.dumpCursorToString(imageNames)}"
//        )
//        imageNamesArrayList.clear()
//        albumImagesMap.clear()
//        var newlyAddedImages = ArrayList<String>()
//
//        try {
//            if (imageNames?.count!! > 0) {
//                if (imageNames!!.moveToFirst()) {
//                    do {
//                        //arrayOf(DBStatics.ALBUM_IMAGES_IMAGE (0), DBStatics.ALBUM_IMAGES_IMAGE_EXTENSION (1), DBStatics.ALBUM_IMAGES_NAME (2), DBStatics.ALBUM_IMAGES_LIST_ORDER (3))
//                        //arrayOf(DBStatics.ALBUM_IMAGES_IMAGE (0), DBStatics.ALBUM_IMAGES_IMAGE_EXTENSION (1), DBStatics.ALBUM_IMAGES_LIST_ORDER)
//                        //imageNamesArrayList.add(imageNames!!.getString(0) + imageNames!!.getString(1))
//
//                        if (imageNames!!.getString(2) in albumImagesMap.keys) {
//                            if (imageNames!!.getString(0).endsWith("a")) {
//                                //addTemporaryLoadingImageByPage("a",imageNames!!.getString(0) + imageNames!!.getString(1))
//                                albumImagesMap[imageNames!!.getString(2)]!!.set(
//                                    0,
//                                    imageNames!!.getString(0) + imageNames!!.getString(1)
//                                )
//                            } else {
//                                //addTemporaryLoadingImageByPage("b",imageNames!!.getString(0) + imageNames!!.getString(1))
//                                albumImagesMap[imageNames!!.getString(2)]!!.set(
//                                    1,
//                                    imageNames!!.getString(0) + imageNames!!.getString(1)
//                                )
//                            }
//                        } else {
//                            val newList = ArrayList<String>()
//                            if (imageNames!!.getString(0).endsWith("a")) {
//                                //addTemporaryLoadingImageByPage("a",imageNames!!.getString(0) + imageNames!!.getString(1))
//                                newList.add(
//                                    0,
//                                    imageNames!!.getString(0) + imageNames!!.getString(1)
//                                )
//                                newList.add(1, "")
//                            } else {
//                                //addTemporaryLoadingImageByPage("b",imageNames!!.getString(0) + imageNames!!.getString(1))
//                                newList.add(0, "")
//                                newList.add(
//                                    1,
//                                    imageNames!!.getString(0) + imageNames!!.getString(1)
//                                )
//                            }
//                            albumImagesMap.put(imageNames!!.getString(2), newList)
//                        }
//
//
//                        /*if (imageNames!!.getString(3) in albumImagesMap.keys) {
//                        var newlyAddedImages1 = albumImagesMap[imageNames!!.getString(3)]!!
//
//                        newlyAddedImages1?.add(imageNames!!.getString(0) + imageNames!!.getString(1))
//
//                        DLog("CurlActivity: ", "setImagesInImageArrayList1 (a) if ${imageNames!!.getString(3)} :List : $newlyAddedImages")
//
//                        albumImagesMap.put(imageNames!!.getString(3), newlyAddedImages1)
//                    } else {
//                        //DLog("CurlActivity: ","setImagesInImageArrayList1 if else ${imageNames!!.getString(3)} ")
//                        //newlyAddedImages.clear()
//                        var newlyAddedImages2 = ArrayList<String>()
//
//                        newlyAddedImages2.add(imageNames!!.getString(0) + imageNames!!.getString(1))
//
//                        DLog("CurlActivity: ", "setImagesInImageArrayList1 (a) if else ${imageNames!!.getString(3)}: List : $newlyAddedImages")
//
//                        albumImagesMap.put(imageNames!!.getString(3), newlyAddedImages2)
//                    }*/
//
//                        DLog("CurlActivity: ", "albumImagesMap8 : ${Gson().toJson(albumImagesMap)}")
//
//                    } while (imageNames!!.moveToNext())
//
//                    var i = 0
//                    val albumImageMapList = albumImagesMap.entries.toList()
//                    while (i < albumImagesMap.entries.size) {
//                        if (albumImageMapList[i].value.size == 2) {
//                            if (i != 1) {
//                                if (albumImageMapList[i].value[0] == "") {
//                                    addTemporaryLoadingImageByPage(
//                                        "a",
//                                        albumImageMapList[i].value[1]
//                                    )
//                                } else {
//                                    addTemporaryLoadingImageByPage(
//                                        "a",
//                                        albumImageMapList[i].value[0]
//                                    )
//                                    addTemporaryLoadingImageByPage(
//                                        "b",
//                                        albumImageMapList[i].value[1]
//                                    )
//                                }
//                            } else {
//                                addTemporaryLoadingImageByPage("a", albumImageMapList[i].value[0])
//                                addTemporaryLoadingImageByPage("b", albumImageMapList[i].value[1])
//                            }
//                        }
//                        i += 1
//                    }
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
//        totalAlbumPaperSize = dbHelper!!.getCountOfTotalAlbumPages(albumCode!!)
//
//        DLog("totalAlbumPaperSizecurl:", "$totalAlbumPaperSize")
//        /*  var paper = 0
//          var pageImages = ArrayList<String>()
//          var map = HashMap<Int, ArrayList<String>>()
//          map.put(0, arrayListOf(imageNamesArrayList[0]))
//          imageNamesArrayList.forEach {
//              pageImages.clear()
//              if()
//              pageImages.add()
//              map.put(paper, )
//          }
//          map.put(totalAlbumPaperSize, arrayListOf(imageNamesArrayList[imageNamesArrayList.size-1]))*/
//    }

    @SuppressLint("Range")
    fun setStudioCoverImage() {
        //return
        val studioCover: Cursor? = dbHelper?.getStudioCoverLogo()
        DLog(
            "CurlActivityLandscape : ",
            "inside setStudioCoverImage ${DatabaseUtils.dumpCursorToString(studioCover)}"
        )
        if (studioCover != null) {
            if (studioCover.count > 0) {
                if (studioCover.moveToFirst()) {
                    val fileName =
                        studioCover.getString(studioCover.getColumnIndex(DBStatics.OPjvtFileName))
                    val extension =
                        studioCover.getString(studioCover.getColumnIndex(DBStatics.OPjvtFileExtension))
                    val file = StorageUtils.getFile(this, "$fileName$extension")
                    if (file.exists()) {
                        activityCurlLandscapeBinding.activityCurlStudioLogoImageView.setBackgroundColor(
                            Color.parseColor("#${MainActivity.studioLogoBackgroundColor}")
                        )
                        imageCache1?.addBitmapToCache(
                            TransportDataKeys.studioLogo,
                            EncryptAndDecryptFiles.decodeFileWithoutSplit(file, this)
                        )
                        try {
                            activityCurlLandscapeBinding.activityCurlStudioLogoImageView.setImageBitmap(
                                imageCache1!!.getBitmapFromDiskCache(
                                    TransportDataKeys.studioLogo
                                )
                            )
                        } catch (e: IllegalStateException) {
                            val bitmap = Bitmap.createBitmap(320, 426, Bitmap.Config.ARGB_8888)
                            val canvas = Canvas(bitmap)
                            val paint = Paint()
                            paint.color = Color.BLACK
                            canvas.drawRect(0F, 0F, 320.toFloat(), 426.toFloat(), paint)
                            activityCurlLandscapeBinding.activityCurlStudioLogoImageView.setImageBitmap(
                                bitmap
                            )
                        } catch (e: Exception) {
                            val bitmap = Bitmap.createBitmap(320, 426, Bitmap.Config.ARGB_8888)
                            val canvas = Canvas(bitmap)
                            val paint = Paint()
                            paint.color = Color.BLACK
                            canvas.drawRect(0F, 0F, 320.toFloat(), 426.toFloat(), paint)
                            activityCurlLandscapeBinding.activityCurlStudioLogoImageView.setImageBitmap(
                                bitmap
                            )
                        }
                    } else {
                        DownloadStudioLogo(this, fileName, extension).execute()
                    }
                }
            }
        }
    }

    @SuppressLint("Range")
    private fun setImagesInImageArrayList2() { //
        setStudioCoverImage()
        imageNames = dbHelper?.getClickedAlbumImages1(albumCode!!)
        /*DLog(
            "CurlActivityLandscape : ",
            "inside setImagesInImageArrayList ${DatabaseUtils.dumpCursorToString(imageNames)}"
        )*/
        imageNamesArrayList.clear()
        albumImagesMap.clear()
        var newlyAddedImages = ArrayList<String>()
        var page = 0;
        try {
            if (imageNames?.count!! > 0) {
                if (imageNames!!.moveToFirst()) {
                    do {
                        //arrayOf(DBStatics.ALBUM_IMAGES_IMAGE (0), DBStatics.ALBUM_IMAGES_IMAGE_EXTENSION (1), DBStatics.ALBUM_IMAGES_NAME (2), DBStatics.ALBUM_IMAGES_LIST_ORDER (3))
                        //arrayOf(DBStatics.ALBUM_IMAGES_IMAGE (0), DBStatics.ALBUM_IMAGES_IMAGE_EXTENSION (1), DBStatics.ALBUM_IMAGES_LIST_ORDER)
                        //jvtFiles.${DBStatics.OPjvtFileName}, jvtFiles.${DBStatics.OPjvtFileExtension}, orde.${DBStatics.OPorderImageType}
                        //imageNamesArrayList.add(imageNames!!.getString(imageNames!!.getColumnIndex(DBStatics.OPjvtFileName)) + imageNames!!.getString(imageNames!!.getColumnIndex(DBStatics.OPjvtFileExtension)))
                        val imageType =
                            imageNames!!.getInt(imageNames!!.getColumnIndex("DBStatics.OPorderImageType"))
                        val imageName =
                            imageNames!!.getString(imageNames!!.getColumnIndex(DBStatics.OPjvtFileName))
                        val extension =
                            imageNames!!.getString(imageNames!!.getColumnIndex(DBStatics.OPjvtFileExtension))
                        imageNamesArrayList.add(
                            SinglePageData(
                                imageType = imageType,
                                imageName = imageName,
                                extension = extension
                            )
                        )

                        page += 1
                        if (imageType == AlbumImageType.full) {
                            val newList = ArrayList<String>()
                            newList.add("$imageName-a$extension")
                            newList.add("$imageName-b$extension")
                            newList.add(imageType.toString())
                            albumImagesMap[page.toString()] = newList
                        } else {
                            val newList = ArrayList<String>()
                            if (page == 2) {
                                newList.add("")
                                newList.add("$imageName-b$extension")
                            } else {
                                newList.add("$imageName-a$extension")
                                newList.add("")
                            }
                            newList.add(imageType.toString())
                            albumImagesMap[page.toString()] = newList
                        }


                        /*if (imageNames!!.getString(2) in albumImagesMap.keys) {
                            if (imageNames!!.getString(0).endsWith("a")) {
                                //addTemporaryLoadingImageByPage("a",imageNames!!.getString(0) + imageNames!!.getString(1))
                                albumImagesMap[imageNames!!.getString(2)]!!.set(
                                    0,
                                    imageNames!!.getString(0) + imageNames!!.getString(1)
                                )
                            } else {
                                //addTemporaryLoadingImageByPage("b",imageNames!!.getString(0) + imageNames!!.getString(1))
                                albumImagesMap[imageNames!!.getString(2)]!!.set(
                                    1,
                                    imageNames!!.getString(0) + imageNames!!.getString(1)
                                )
                            }
                        } else {
                            val newList = ArrayList<String>()
                            if (imageNames!!.getString(0).endsWith("a")) {
                                //addTemporaryLoadingImageByPage("a",imageNames!!.getString(0) + imageNames!!.getString(1))
                                newList.add(
                                    0,
                                    imageNames!!.getString(0) + imageNames!!.getString(1)
                                )
                                newList.add(1, "")
                            } else {
                                //addTemporaryLoadingImageByPage("b",imageNames!!.getString(0) + imageNames!!.getString(1))
                                newList.add(0, "")
                                newList.add(
                                    1,
                                    imageNames!!.getString(0) + imageNames!!.getString(1)
                                )
                            }
                            albumImagesMap.put(imageNames!!.getString(2), newList)
                        }*/


                        /*if (imageNames!!.getString(3) in albumImagesMap.keys) {
                        var newlyAddedImages1 = albumImagesMap[imageNames!!.getString(3)]!!

                        newlyAddedImages1?.add(imageNames!!.getString(0) + imageNames!!.getString(1))

                        DLog("CurlActivity: ", "setImagesInImageArrayList1 (a) if ${imageNames!!.getString(3)} :List : $newlyAddedImages")

                        albumImagesMap.put(imageNames!!.getString(3), newlyAddedImages1)
                    } else {
                        //DLog("CurlActivity: ","setImagesInImageArrayList1 if else ${imageNames!!.getString(3)} ")
                        //newlyAddedImages.clear()
                        var newlyAddedImages2 = ArrayList<String>()

                        newlyAddedImages2.add(imageNames!!.getString(0) + imageNames!!.getString(1))

                        DLog("CurlActivity: ", "setImagesInImageArrayList1 (a) if else ${imageNames!!.getString(3)}: List : $newlyAddedImages")

                        albumImagesMap.put(imageNames!!.getString(3), newlyAddedImages2)
                    }*/

                        DLog("CurlActivity: ", "albumImagesMap8 : ${Gson().toJson(albumImagesMap)}")

                    } while (imageNames!!.moveToNext())

                    var i = 0
                    val albumImageMapList = albumImagesMap.entries.toList()
                    while (i < albumImagesMap.entries.size) {
                        if (albumImageMapList[i].value.size == 2) {
                            if (i != 1) {
                                if (albumImageMapList[i].value[0] == "") {
                                    addTemporaryLoadingImageByPage(
                                        "a",
                                        albumImageMapList[i].value[1]
                                    )
                                } else {
                                    addTemporaryLoadingImageByPage(
                                        "a",
                                        albumImageMapList[i].value[0]
                                    )
                                    addTemporaryLoadingImageByPage(
                                        "b",
                                        albumImageMapList[i].value[1]
                                    )
                                }
                            } else {
                                addTemporaryLoadingImageByPage("a", albumImageMapList[i].value[0])
                                addTemporaryLoadingImageByPage("b", albumImageMapList[i].value[1])
                            }
                        }
                        i += 1
                    }
                }
            }
        } catch (e: CursorIndexOutOfBoundsException) {
        }

        DLog("CurlActivity: ", "albumImagesMap : ${Gson().toJson(albumImagesMap)}")

        imageNamesArrayListSize = imageNamesArrayList.size

//        try {
//            val index = imageNamesArrayList.indexOf(imageNamesArrayList[0])
//            val index1 = imageNamesArrayList[0]
//            imageNamesArrayList.removeAt(index)
//            imageNamesArrayList.add(imageNamesArrayList.size, index1)
//        } catch (e: IndexOutOfBoundsException) {
//            DLog("CurlActivity:", e.message.toString())
//        }

        totalAlbumPaperSize = dbHelper!!.getCountOfTotalAlbumPages(albumCode!!)

        DLog("totalAlbumPaperSizecurl:", "$totalAlbumPaperSize")
        /*  var paper = 0
          var pageImages = ArrayList<String>()
          var map = HashMap<Int, ArrayList<String>>()
          map.put(0, arrayListOf(imageNamesArrayList[0]))
          imageNamesArrayList.forEach {
              pageImages.clear()
              if()
              pageImages.add()
              map.put(paper, )
          }
          map.put(totalAlbumPaperSize, arrayListOf(imageNamesArrayList[imageNamesArrayList.size-1]))*/
    }

    @SuppressLint("Range")
    private fun setImagesInImageArrayList3() { //
        setStudioCoverImage()
        val ordersModel: AlbumOrdersModel? = dbHelper?.getClickedAlbumImages2(albumCode!!)
        if (ordersModel == null) return;
        /*DLog(
            "CurlActivityLandscape : ",
            "inside setImagesInImageArrayList ${DatabaseUtils.dumpCursorToString(imageNames)}"
        )*/
        imageNamesArrayList.clear()
        albumImagesMap.clear()
        var newlyAddedImages = ArrayList<String>()
        var page = 0;
        try {
            if (ordersModel.isNotEmpty()) {
                for (it in ordersModel) {
                    val imageType = it.image_type
                    val imageName = it.jvt_file_connectors?.first()?.jvt_file?.name
                    val extension = it.jvt_file_connectors?.first()?.jvt_file?.extension
                    imageNamesArrayList.add(
                        SinglePageData(
                            imageType = imageType!!,
                            imageName = imageName!!,
                            extension = extension!!
                        )
                    )

                    page += 1
                    if (imageType == AlbumImageType.full) {
                        val newList = ArrayList<String>()
                        newList.add("$imageName-a$extension")
                        newList.add("$imageName-b$extension")
                        addTemporaryLoadingImageByPage(
                            "a",
                            "$imageName-a$extension"
                        )
                        addTemporaryLoadingImageByPage(
                            "b",
                            "$imageName-b$extension"
                        )
                        newList.add(imageType.toString())
                        albumImagesMap[page.toString()] = newList
                    } else {
                        val newList = ArrayList<String>()
                        if (page == 1) {
                            newList.add("$imageName-a$extension")
                            newList.add("$imageName-b$extension")
                            addTemporaryLoadingImageByPage(
                                "a",
                                "$imageName-a$extension"
                            )
                            addTemporaryLoadingImageByPage(
                                "b",
                                "$imageName-b$extension"
                            )
                        } else if (page == 2) {
                            newList.add("")
                            newList.add("$imageName-b$extension")
                            addTemporaryLoadingImageByPage(
                                "b",
                                "$imageName-b$extension"
                            )
                        } else {
                            newList.add("$imageName-a$extension")
                            newList.add("")
                            addTemporaryLoadingImageByPage(
                                "a",
                                "$imageName-a$extension"
                            )
                        }
                        newList.add(imageType.toString())
                        albumImagesMap[page.toString()] = newList
                    }
                    DLog("CurlActivity: ", "albumImagesMap8 : ${Gson().toJson(albumImagesMap)}")
                    //{"1":["b8517fb1-3dc5-4de8-a45b-050f11379f6f-a.jpg","b8517fb1-3dc5-4de8-a45b-050f11379f6f-b.jpg","3"],"2":["","1504075a-701d-43bc-8f73-b5480faf062b-b.jpg","4"],"3":["97267b14-5d41-483c-873d-f81e7589236d-a.jpg","","4"],"4":["1f362b94-2fdf-4907-b505-f35c9e84bf3d-a.jpg","1f362b94-2fdf-4907-b505-f35c9e84bf3d-b.jpg","3"],"5":["2cbef8c9-4a13-4126-af2b-fc65d01f3e74-a.jpg","2cbef8c9-4a13-4126-af2b-fc65d01f3e74-b.jpg","3"],"6":["074ac32e-b4ec-474d-923c-624d38000f5d-a.jpg","074ac32e-b4ec-474d-923c-624d38000f5d-b.jpg","3"]}
                }

                /*var i = 0
                val albumImageMapList = albumImagesMap.entries.toList()
                while (i < albumImagesMap.entries.size) {
                    if (albumImageMapList[i].value.size == 3) {
                        if (i != 1) {
                            if (albumImageMapList[i].value[0] == "") {
                                addTemporaryLoadingImageByPage(
                                    "a",
                                    albumImageMapList[i].value[1]
                                )
                            } else {
                                addTemporaryLoadingImageByPage(
                                    "a",
                                    albumImageMapList[i].value[0]
                                )
                                addTemporaryLoadingImageByPage(
                                    "b",
                                    albumImageMapList[i].value[1]
                                )
                            }
                        } else {
                            addTemporaryLoadingImageByPage("a", albumImageMapList[i].value[0])
                            addTemporaryLoadingImageByPage("b", albumImageMapList[i].value[1])
                        }
                    }
                    i += 1
                }*/
            }
        } catch (e: CursorIndexOutOfBoundsException) {
        }

        DLog("CurlActivity: ", "albumImagesMap : ${Gson().toJson(albumImagesMap)}")

        imageNamesArrayListSize = imageNamesArrayList.size
        totalAlbumPaperSize = dbHelper!!.getCountOfTotalAlbumPages(albumCode!!)

        DLog("totalAlbumPaperSizecurl:", "$totalAlbumPaperSize")
    }

    private fun calculateRatio(width: Int, height: Int) {
        val metrics: DisplayMetrics = this.resources.displayMetrics
        if (metrics.widthPixels > metrics.heightPixels) {
            (activityCurlLandscapeBinding.curlView.layoutParams as ConstraintLayout.LayoutParams).dimensionRatio =
                "$width:$height"
        } else {
            (activityCurlLandscapeBinding.curlView.layoutParams as ConstraintLayout.LayoutParams).dimensionRatio =
                "$height:$width"
        }
    }

    override fun onStart() {
        super.onStart()
        /*curlViewGoneThread = Thread(Runnable {
            curl_view.visibility = View.GONE
        })
        curlViewGoneThread?.start()*/
        DLog("On Start", "On start")
        onStartContent()
    }

    private fun onStartContent() {
        // original -> 27s 68ms , thumb -> 8s 41ms (56)
        //val lastUpdatedAt = dbHelper?.getLastUpdatedAtInAlbum(albumCode!!)
        val lastUpdatedAt = 10
        if (lastUpdatedAt != 0) {
            DLog("CurlActivity: ", "onStartContent() step 1")
            if (dbHelper?.isAllImagesDownloaded(albumCode!!)!!) {
                DLog("CurlActivity: ", "onStartContent() step 2")
                activityCurlLandscapeBinding.activityCurlStudioLogoImageView.visibility =
                    View.VISIBLE
                //getMergedImageNameArrayList()
                if (Network_check.isNetworkAvailable(this)) {
                    DLog("CurlActivity: ", "onStartContent() step 21")
                    //startAlbumUpdateWorker(lastUpdatedAt!!)
                }
                checkForExistingAlbumImages(lastUpdatedAt!!)
                DLog("CurlActivity: ", "onStartContent() step 3")
            } else {
                DLog("CurlActivity: ", "onStartContent() step 4")
                if (Network_check.isNetworkAvailable(this)) {
                    DLog("CurlActivity: ", "onStartContent() step 5")
                    checkImages()
                    //startAlbumUpdateWorker(lastUpdatedAt!!)
                    DLog("CurlActivity: ", "onStartContent() step 6")
                } else {
                    DLog("CurlActivity: ", "onStartContent() step 7")
                    //checkInternet()
                    checkImages()
                    listenNetworkState()
                    Others.showAlertSnackBar(this, getString(R.string.try_to_connect))
                    DLog("CurlActivity: ", "onStartContent() step 8")
                }
                DLog("CurlActivity: ", "onStartContent() step 9")
            }
            DLog("CurlActivity: ", "onStartContent() step 10")
        } else if (Network_check.isNetworkAvailable(this)) {
            DLog("CurlActivity: ", "onStartContent() step 11")
            activityCurlLandscapeBinding.progressBarConstraint.visibility = View.GONE
            callApiForGetAlbumImages(lastUpdatedAt, true)
        } else {
            DLog("CurlActivity: ", "onStartContent() step 12")
            // var df = dbHelper?.getSingleAlbumOriginalPhotoUrl(albumId!!)
            // DLog("CurlActivity :", "inside onStart: ${DatabaseUtils.dumpCursorToString(df)}")

//            if (dbHelper?.isEligibleForViewAlbum(albumId!!)!!) {
//                checkImages()
//            } else {
//                checkInternet()
//            }
            checkInternet()
        }
    }

    private fun listenNetworkState() {
        NetworkConnectionLiveData(applicationContext).observe(this, Observer {
            if (it.isConnected) {
                Others.showNormalSnackBar(this, "Back to online")
                //downloadOriginalAlbumImages()
                onStartContent()
                /*when(it.type){
                    ConnectivityManager.TYPE_WIFI -> {}
                    ConnectivityManager.TYPE_MOBILE -> {}
                    else -> {}
                }*/
            } else {

            }
        })
    }

    /*private fun startAlbumUpdateWorker(lastUpdatedAt: Int) { // need to check

        val updateAlbumWorkerData = Data.Builder()
            .putString(Api.KEY_ALBUM_ID, albumCode!!) // need to check
            .putString(Api.LAST_UPDATED_AT, lastUpdatedAt.toString())
            .putBoolean(Api.IS_COME_FROM_GALLERY, false)
            .build()

        val getUnDownloadedImageUrlWorkerData = Data.Builder()
            .putString(Api.EVENT_OR_ALBUM_ID, albumCode!!) // need to check
            .putInt(Api.PAGE_STATUS, 2)
            .putBoolean(Api.INSUFFICIENT_STORAGE, insufficientStorage)
            .build()

        val firstWorkRequest =
            OneTimeWorkRequest.Builder(UpdateAlbumImagesWorker::class.java) // need to check
                .setInputData(updateAlbumWorkerData)
//http://192.168.1.19/api/v7/studio-user/euwfzm95/albums/pre-designed
                .build()

        val secondWorkManager =
            OneTimeWorkRequest.Builder(GetUnDownloadedImageUrlWorker::class.java)
                .setInputData(getUnDownloadedImageUrlWorkerData)
                .addTag(Api.UPDATE_ALBUM_WORKER_OUTPUT_DATA)
                .build()

        val workManager = WorkManager.getInstance(this)

        workManager.beginWith(firstWorkRequest).then(secondWorkManager).enqueue()

        workManager.getWorkInfoByIdLiveData(firstWorkRequest.id).observe(this, Observer {

            DLog("CurlActivityWorker", "$it")
            val stateValue = it!!.state

            if (stateValue == null)
                return@Observer

            val successOutputData = it.outputData
            when (stateValue) {
                WorkInfo.State.SUCCEEDED -> {
                    when (successOutputData.getInt(Api.UPDATE_ALBUM_WORKER_OUTPUT_DATA, 0)) {
                        4 -> {
                            insufficientStorage = false
                            showStorageError()// dont call refresh image url
                            DLog("CurlActivity", "startAlbumUpdateWorker :: STEP 1")
                            playMusic()
                        }
                        1, 2, 3 -> {
                            DLog("CurlActivity", "startAlbumUpdateWorker :: STEP 2")
                            playMusic()
                        }
                        else -> {
                            DLog("CurlActivity", "startAlbumUpdateWorker :: STEP 3")
                            insufficientStorage = true // call refresh image url
                            playMusic()
                        }
                    }
                }
                WorkInfo.State.FAILED -> {

                }
                else -> {

                }
            }

        })

        workManager.getWorkInfoByIdLiveData(secondWorkManager.id).observe(this, Observer {
            DLog("CurlActivityImagesDownloadWorker", "$it")

            // val stateValue = it!!.state

            val workInfo = it!!.state

            if (workInfo == null)
                return@Observer

            val successOutputData = it.outputData
            when (workInfo) {
                WorkInfo.State.SUCCEEDED -> {
                    when (successOutputData.getInt(Api.UPDATE_IMAGES_WORKER_OUTPUT_DATA, 0)) {
                        1 -> {
                            DLog("CurlActivityCheckImgas", "CurlActivityCheckImgas")
                            this.lastUpdatedAt = 0
                            checkImages()
                        }
                        2 -> {

                        }
                        3 -> {

                        }
                        4 -> {
                            insufficientStorage = false
                            showStorageError()// dont call refresh image url
                        }
                        5 -> {
                            //playMusic()
                        }
                        else -> {
                            insufficientStorage = true
                        }
                    }
                }
                WorkInfo.State.FAILED -> {

                }
                else -> {

                }
            }
        })

    }*/

    private fun callApiForGetAlbumImages(lastUpdatedAt: Int, visibleProgress: Boolean) {
        /*val hashMap = HashMap<String, String>()
        hashMap[Api.KEY_ALBUM_ID] = albumCode.toString()
        hashMap[Api.KEY_LAST_UPDATED_AT] = lastUpdatedAt.toString()
        apiCall?.APIRequest(
            ApiUrls.UPDATE_ALBUM,
            hashMap,
            EventAlbumImagesResult::class.java,
            this,
            1,
            "",
            visibleProgress
        )*/
    }

    override fun onSuccess(from: Int, response: Any) {

        when (from) {
            1 -> {
                //val result = (response as EventAlbumImagesResult).data.album
                val result = Gson().toJson(response)

                /*var albumSize = 0L
         if (result.update_status == WebConstants.INSERT || result.update_status == WebConstants.UPDATE) {
             result.data.images.forEach {
                 if (it.update_status == WebConstants.INSERT || it.update_status == WebConstants.UPDATE) {
                     albumSize += it.data.original_size
                 }
             }
         }*/

                if (isAvailableExternalMemorySize(
                        this,
                        InsertAlbums.getAlbumSize(Gson().toJson(response))
                    )
                ) {
                    /* if (result.update_status == WebConstants.INSERT) {
                 dbHelper?.updateAlbumName(result.id, result.data.name, result.data.last_updated_at)
             }
             result.data.images.forEach {
                 if (it.update_status == WebConstants.INSERT) {
                    InsertAlbums.insert(it.data.id, result.id, it.data.name, it.data.image, InsertAlbums.getExtension(it.data.image), 0, 0,projectFolder!!,dbHelper!!)
                     //dbHelper?.insertInToAlbumImagesTable(it.data.id, result.id, it.data.name, it.data.image, InsertAlbums().getExtension(it.data.image),0,0)
                 } else if (it.update_status == WebConstants.UPDATE) {
                     InsertAlbums.update(it.data.id, result.id, it.data.name, it.data.image, InsertAlbums.getExtension(it.data.image), 0, 0,dbHelper!!,projectFolder!!)
                 } else { // delete
                     InsertAlbums.delete(it.data.id, it.data.image, InsertAlbums.getExtension(it.data.image),dbHelper!!,projectFolder!!)
                 }
             }*/

                    InsertAlbums.updateAlbumImages(
                        Gson().toJson(response),
                        dbHelper!!,
                        projectFolder!!
                    )

                    //setImagesInImageArrayList()
                    checkImages()
                } else {
                    showStorageError()
                }
            }

            2 -> {
                val result = response as RefreshImageUrl
                DLog("DownloadImagesActivity :", "inside onSuccess 1")
                result.data.images.forEach {
                    if (it.status == "success") {
                        DLog("USER_ALBUMS :", " ${it.id} ${it.type}")
                        if (it.type == 12 || it.type == 0 || it.type == 2 || it.type == 6 /*|| it.type == PageConst.ALBUM_THUMB_IMAGES*/) { // album and event cover images
                            dbHelper?.insertRefreshedAlbumImagesAndEventCoverImageUrl(
                                it.id,
                                it.detail.original_url,
                                it.detail.thumb_url
                            )
                        }
                    } else {
                        if (it.type == 12 || it.type == 2) { // album and event cover images
                            dbHelper?.deleteAlbumImagesAndEventCoverImage(it.id)
                        }
                    }
                }
                //recreate()
                reCreateActivity()
                /*setImagesInImageArrayList1()
                if(Others.isAbleToViewAlbumWithOriginalImages(this, dbHelper?.getAlbumStorageSize(albumId!!)!!)) {
                    getModelList()
                } else {
                    showStorageError()
                }
                downloadOriginalAlbumImages()*/
            }

            3 -> {
                val result = response as JvtFilesTemporaryUrl
                result.files.forEach {
                    when (it.status) {
                        WebConstants.ABLE_TO_DOWNLOAD -> {
                            dbHelper?.insertRefreshedAlbumMusicUrl(
                                it.id,
                                it.detail.file,
                                it.detail.size,
                                it.detail.extension
                            )
                            DownloadAlbumMusic(this, it.id, music!!, it.detail.file).execute()
                        }

                        WebConstants.NOT_ABLE_TO_DOWNLOAD -> sendSlackNotification(
                            it.id,
                            WebConstants.ERROR_FAILED_FROM_FILE_RESPONSE
                        )

                        WebConstants.DELETE -> dbHelper?.deleteAlbumMusic(it.id)
                    }
                }
            }
        }
    }

    fun reCreateActivity() {
        val intentViewSingleAlbum = Intent(mContext, CurlActivity::class.java)
        intentViewSingleAlbum.putExtra("albumCode", albumCode!!)
        //intentViewSingleAlbum.putExtra("album_name", albumName)
        intentViewSingleAlbum.putExtra("musicCode", musicCode)
        intentViewSingleAlbum.putExtra("albumSize", albumSize)
        intentViewSingleAlbum.putExtra("albumType", albumType)
        intentViewSingleAlbum.putExtra("updatedAt", lastUpdatedAt)
        intentViewSingleAlbum.putExtra("orientation", orientation)
        //intentViewSingleAlbum.putExtra("eventsRandomId", eventsRandomId)
        intentViewSingleAlbum.putExtra("eventsPasscode", eventsPasscode)
        intentViewSingleAlbum.putExtra("eventsUrl", eventsUrl)
        intentViewSingleAlbum.putExtra("eventType", eventsType)
        intentViewSingleAlbum.putExtra("eventId", eventCode)
        intentViewSingleAlbum.putExtra("isNeedToRefresh", false)
        intentViewSingleAlbum.putExtra("canTakeScreenshot", canTakeScreenshot)
        startActivity(intentViewSingleAlbum)
        finish()
    }

    private fun sendSlackNotification(musicId: Int, errorType: String) {
        val hashMap = HashMap<String, String>()
        hashMap[Api.TYPE] = errorType
        hashMap[Api.FILE_ID_DATA] = musicId.toString()
        //apiCall!!.APIRequest(ApiUrls.SLACK_NOTIFICATION, hashMap, SlackNotificationResponse::class.java, this, 4, "", false)
        NotifyToSlack(this, hashMap).execute()
    }

    private fun showStorageError() {
        if (isAlbumVisible) { // show update
            AlertDialog.Builder(this, R.style.AlertDialogTheme)
                .setTitle(getString(R.string.unable_to_download_album))
                .setMessage(getString(R.string.unable_to_download_updated_album_message))
                .setCancelable(false)
                .setPositiveButton(resources.getString(R.string.retry)) { dialog, which ->
                    onStartContent()
                }
                .setNegativeButton(resources.getString(R.string.cancel)) { dialog, which ->
                    dialog.dismiss()
                }.show()
        } else {
            AlertDialog.Builder(this, R.style.AlertDialogTheme)
                .setTitle(getString(R.string.unable_to_download_album))
                .setMessage(getString(R.string.unable_to_download_album_message))
                .setCancelable(false)
                .setPositiveButton(resources.getString(R.string.retry)) { dialog, which ->
                    onStartContent()
                }
                .setNegativeButton(resources.getString(R.string.cancel)) { dialog, which ->
                    dialog.dismiss()
                    closeActivity()
                }.show()
        }
    }

    private fun closeActivity() = finish()

    override fun onFailure(from: Int, response: Any) {}

    override fun onNetworkFailure(from: Int) {}

    // Check Permission for Storage if Permission granted, goto the check images
    private fun checkPermission() = checkImages()

    // Get album category for display in Page.
    @SuppressLint("InvalidWakeLockTag")
    private fun checkImages() {
        //Merged Image Name ArrayList
        DLog("checkImages", "${dbHelper?.getAlbumStorageSize(albumCode!!)!!}")
        if (!dbHelper?.isOriginalsDownloadInAlbum(albumCode!!)!!) {
            DLog("CurlActivityLandscape: ", "inside isOriginalsDownloadInSingleAlbum if 1")
            if (Network_check.isNetworkAvailable(this)) {
                val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
                mWakeLock = pm?.newWakeLock(PowerManager.SCREEN_DIM_WAKE_LOCK, "MyTag")
                mWakeLock?.acquire()
            } // not lock if download images are not downloaded
            /*if(isNeedToRefresh!!){
                Handler().postDelayed({
                    //setOrignakUrlForGalleryAlbumImages()
                    reCreateActivity()
                }, 100)
            }*/
            slideDown(activityCurlLandscapeBinding.imageviewSliderRecyclerView)
        } else {
            //openMenu()
            slideUp(activityCurlLandscapeBinding.imageviewSliderRecyclerView)
        }

        /*if (dbHelper?.getSingleAlbumOriginalPhotoUrl(albumCode!!)!!.count == 0) {
            //getMergedImageNameArrayList() // For recycler view in bottom
        }*/

        //val cursor: Cursor? = dbHelper!!.getSingleAlbumOriginalPhotoUrl(albumId!!)
        //if (cursor!!.count != 0) {
        /*if (!dbHelper!!.isTemporaryUrlAvailable(albumCode!!)) {
            DLog("CurlActivity: ", "checkImages inside if")
            if (albumType == WebConstants.STUDIO_GALLERY_ALBUMS) {
                setOrignakUrlForGalleryAlbumImages()
            } else {
                apiCallForJson?.APIRequestForJson(
                    ApiUrls.REFRESH_IMAGE_URL,
                    getJsonObject(),
                    RefreshImageUrl::class.java,
                    this,
                    2
                )
            }
        } else {*/
        DLog(
            "CurlActivity: ",
            "checkImages inside if else  --${dbHelper?.getAlbumStorageSize(albumCode!!)}"
        )
        /*if (eventsType == WebConstants.DEMO_EVENT) {
            if (isNeedToRefresh!!) {
                Handler().postDelayed({
                    reCreateActivity()
                }, 100)
            } else {
                setImagesInImageArrayList3()
                if (Others.isAbleToViewAlbumWithOriginalImages(
                        this,
                        dbHelper?.getAlbumStorageSize(albumCode!!)!!
                    )
                ) {
                    getModelList()
                } else {
                    showStorageError()
                }
                downloadOriginalAlbumImages()
            }
        } else {*/
        setImagesInImageArrayList3()
        if (Others.isAbleToViewAlbumWithOriginalImages(
                this,
                dbHelper?.getAlbumStorageSize(albumCode!!)!!
            )
        ) {
            getModelList()
        } else {
            showStorageError()
        }
        downloadOriginalAlbumImages()
        //}
        //}
        DLog("Step", "3ii")
        DLog("Step", "8")
    }

    @SuppressLint("Range")
    private fun setOrignakUrlForGalleryAlbumImages() {
        /*val albumImagesCursor = dbHelper!!.getAlbumImages(albumCode!!)
        if (albumImagesCursor.count > 0 && albumImagesCursor.moveToFirst()) {
            do {
                val url = Others.getPublicUrlForGallery(
                    albumCode!!,
                    Others.getImageName(
                        albumImagesCursor.getString(
                            albumImagesCursor.getColumnIndex(DBStatics.OPjvtFileName)
                        )
                    )
                )
                dbHelper?.insertRefreshedAlbumImagesAndEventCoverImageUrl(
                    albumImagesCursor.getInt(
                        albumImagesCursor.getColumnIndex(DBStatics.OPjvtFileCode)
                    ), url, ""
                )
            } while (albumImagesCursor.moveToNext())
        }*/

        val intent = Intent(mContext, CurlActivity::class.java)
        //intent.putExtra("albumName", albumName)
        //intent.putExtra("eventId", eventId)
        intent.putExtra("eventCode", eventCode)
        intent.putExtra("albumCode", albumCode!!)
        intent.putExtra("albumType", albumType)
        intent.putExtra("updatedAt", lastUpdatedAt)
        intent.putExtra("musicFileName", musicCode)
        intent.putExtra("albumSize", albumSize)
        //intent.putExtra("eventUrl", eventsUrl)
        intent.putExtra("eventType", eventsType)
        intent.putExtra("orientation", orientation)
        intent.putExtra("canTakeScreenshot", canTakeScreenshot)
        startActivity(intent)
        finish()
    }

    private fun getJsonObject(): JsonObject {
        //DLog("getJsonObject", "${PageConst.ALBUM_THUMB_IMAGES} $eventId ")
        return DownloadTempImages.getImagesIdAndAddToJsonObject(
            2,
            albumCode!!,
            dbHelper!!,
            mContext!!
        )
    }

    @SuppressLint("Range")
    private fun downloadOriginalAlbumImages() {
        val cursor = dbHelper!!.getSingleAlbumOriginalPhotoUrl(albumCode!!)
        if (cursor.isEmpty()) {
            /*Handler().postDelayed({
                slideUp(imageview_slider_recyclerView)
                Handler().postDelayed({
                    if (isUp)
                        slideUp(imageview_slider_recyclerView)
                }, 4000)
            }, 2000)*/
            if (albumOrientation == 1) {
                setInvisibleProgressBarIfLandscape()
            } else {
                setInvisibleProgressBar()
            }
            openMenu()
        } else {
            activityCurlLandscapeBinding.progressBarConstraint.visibility = View.VISIBLE
            activityCurlLandscapeBinding.activityCurlStudioLogoImageView.visibility = View.INVISIBLE
            Handler().postDelayed({
                if (Network_check.isNetworkAvailable(this)) {
                    activityCurlLandscapeBinding.progressTextView.text = "0%"
                    //DLog("DownloadImages in CL: ", "${cursor?.getString(0)}")
                    cursor.forEach { it ->
                        DLog("CurlActivity: inside do while", it)
                        val drUpdateTask = DownloadResultUpdateTask(this)
                        val downloadTask = DownloadTask(
                            it,
                            2,
                            imageTypeMap[it] ?: 3,
                            this,
                            drUpdateTask,
                        )
                        DownloadManager.downloadManager?.runDownloadFile(downloadTask)
                    }
                } else {
                    noInternetConnection()
                }
            }, 1000)
        }
        /*val cursor: Cursor? = dbHelper!!.getSingleAlbumOriginalPhotoUrl(albumCode!!)
        if (cursor != null && cursor.count == 0) {
            *//*Handler().postDelayed({
                slideUp(imageview_slider_recyclerView)
                Handler().postDelayed({
                    if (isUp)
                        slideUp(imageview_slider_recyclerView)
                }, 4000)
            }, 2000)*//*
            if (albumOrientation == 1) {
                setInvisibleProgressBarIfLandscape()
            } else {
                setInvisibleProgressBar()
            }
        } else {
            progressBar_constraint.visibility = View.VISIBLE
            activity_curl_studioLogo_imageView.visibility = View.INVISIBLE
            Handler().postDelayed({
                if (Network_check.isNetworkAvailable(this)) {
                    progress_textView.text = "0%"
                    cursor?.moveToFirst()
                    DLog("DownloadImages in CL: ", "${cursor?.getString(0)}")
                    do {
                        DLog("CurlActivity: inside do while", "${cursor?.getString(0)}")
                        val drUpdateTask = DownloadResultUpdateTask(this)
                        val downloadTask = DownloadTask(
                            cursor?.getString(cursor.getColumnIndex(DBStatics.OPjvtFileName))!!,
                            2,
                            this,
                            drUpdateTask
                        )
                        DownloadManager.downloadManager?.runDownloadFile(downloadTask)
                    } while (cursor!!.moveToNext())
                } else {
                    noInternetConnection()
                }
            }, 1000)
        }*/
    }

    // If all images are download, get list for set page that goes to ImageForAlbum
    private fun getModelList() {
        try {
            var i = 1
            if (isShowAlbum) {
                //isShowAlbum = false
                imageArrayList.clear()
                DLog("CurlActivity:", "inside getModelList: [${imageNamesArrayList.size}]")
                //for ((index, value) in imageNamesArrayList.withIndex()) {
                for ((index, value) in imageNamesArrayList.withIndex()) {
                    DLog(
                        "CurlActivity:",
                        "inside getModelList: ${imageNamesArrayList[index]} [$i]"
                    )
                    i = i.plus(1)
                    /*if(index.equals(k)){*/
                    val singlePageData = imageNamesArrayList[index]
                    var file: File? = null

                    if (imageNamesArrayList.size <= 2) {
                        //if (index == 0 || index == imageNamesArrayList.size - 1) {
                        if (StorageUtils.getFile(
                                this,
                                singlePageData.imageName + singlePageData.extension
                            ).exists()
                        ) {
                            file = StorageUtils.getFile(
                                this,
                                singlePageData.imageName + singlePageData.extension
                            )
                        }
                        if (file != null) {
                            val tmp =
                                decodeFileWithSplit(file, mContext!!, singlePageData.imageType)
                            //imageCache1?.removeKey(imageName)
                            if (singlePageData.imageType == AlbumImageType.full) {
                                imageCache1?.removeKey(singlePageData.imageName + "-a" + singlePageData.extension)
                                imageCache1?.removeKey(singlePageData.imageName + "-b" + singlePageData.extension)
                                imageCache1?.addBitmapToCache(
                                    singlePageData.imageName + "-a" + singlePageData.extension,
                                    tmp[0]
                                )
                                imageCache1?.addBitmapToCache(
                                    singlePageData.imageName + "-b" + singlePageData.extension,
                                    tmp[1]
                                )
                            } else {
                                imageCache1?.removeKey(singlePageData.imageName + "-b" + singlePageData.extension)
                                imageCache1?.addBitmapToCache(
                                    singlePageData.imageName + "-b" + singlePageData.extension,
                                    tmp[0]
                                )
                            }
                        } else {
                            //addTemporaryLoadingImageByIndex(index, imageName)
                        }
                        // }
                    } else if (index == 0) {
                        if (StorageUtils.getFile(
                                this,
                                singlePageData.imageName + singlePageData.extension
                            ).exists()
                        ) {
                            file = StorageUtils.getFile(
                                this,
                                singlePageData.imageName + singlePageData.extension
                            )
                        }
                        if (file != null) {
                            val tmp =
                                decodeFileWithSplit(file, mContext!!, singlePageData.imageType)
                            DLog("CurlActivity", "getModelList() :: STEP 1 IF")
                            if (singlePageData.imageType == AlbumImageType.full) {
                                imageCache1?.removeKey(singlePageData.imageName + "-a" + singlePageData.extension)
                                imageCache1?.removeKey(singlePageData.imageName + "-b" + singlePageData.extension)
                                imageCache1?.addBitmapToCache(
                                    singlePageData.imageName + "-a" + singlePageData.extension,
                                    tmp[0]
                                )
                                imageCache1?.addBitmapToCache(
                                    singlePageData.imageName + "-b" + singlePageData.extension,
                                    tmp[1]
                                )
                            } else {
                                imageCache1?.removeKey(singlePageData.imageName + "-a" + singlePageData.extension)
                                imageCache1?.removeKey(singlePageData.imageName + "-b" + singlePageData.extension)
                                imageCache1?.addBitmapToCache(
                                    singlePageData.imageName + "-a" + singlePageData.extension,
                                    tmp[0]
                                )
                                imageCache1?.addBitmapToCache(
                                    singlePageData.imageName + "-b" + singlePageData.extension,
                                    tmp[0]
                                )
                            }

                            DLog("CurlActivity", "getModelList() :: STEP 2 IF")
                        } else {
                            DLog("CurlActivity", "getModelList() :: STEP 3 IF ELSE")
                            //addTemporaryLoadingImageByIndex(index, imageName)
                        }
                    } else if (index == 1) {
                        //addTemporaryLoadingImageByIndex(index, imageName)
                        if (singlePageData.imageType == AlbumImageType.half) {
                            if (StorageUtils.getFile(
                                    this,
                                    singlePageData.imageName + singlePageData.extension
                                ).exists()
                            ) {
                                file = StorageUtils.getFile(
                                    this,
                                    singlePageData.imageName + singlePageData.extension
                                )
                            }
                            if (file != null) {
                                val tmp =
                                    decodeFileWithSplit(file, mContext!!, singlePageData.imageType)
                                DLog("CurlActivity", "getModelList() :: STEP 1 IF")

                                //imageCache1?.removeKey(singlePageData.imageName + "-a" + singlePageData.extension)
                                imageCache1?.removeKey(singlePageData.imageName + "-b" + singlePageData.extension)
                                /*imageCache1?.addBitmapToCache(
                                    singlePageData.imageName + "-a" + singlePageData.extension,
                                    tmp[0]
                                )*/
                                imageCache1?.addBitmapToCache(
                                    singlePageData.imageName + "-b" + singlePageData.extension,
                                    tmp[0]
                                )
                            }
                            DLog("CurlActivity", "getModelList() :: STEP 2 IF")
                        } else {
                            DLog("CurlActivity", "getModelList() :: STEP 3 IF ELSE")
                            //addTemporaryLoadingImageByIndex(index, imageName)
                        }
                    }
                }
                DLog("Step", "4")

                fillPage()
                imageDecodeImage = ImageDecodeImage()
                imageDecodeImage?.execute("")

                DLog("Step", "7")
            }
        } catch (e: OutOfMemoryError) {
            DLog("CurlActivity : ", "error : ${e.message}")
        } catch (e: NullPointerException) {
            DLog(
                "CurlActivity  : ",
                "error : 'int android.graphics.Bitmap.getWidth() : ${e.message}"
            )
            getModelList()
        }
    }

//    private fun reduceBitmapSize(imageFilePath: File): Bitmap? {
//        val bmOptions: BitmapFactory.Options = BitmapFactory.Options()
//        bmOptions.inJustDecodeBounds = true
//        BitmapFactory.decodeFile(imageFilePath.absolutePath, bmOptions)
//        bmOptions.inSampleSize = calculateInSampleSize(bmOptions)
//        bmOptions.inJustDecodeBounds = false
//        return BitmapFactory.decodeFile(imageFilePath.absolutePath, bmOptions)
//    }

    private fun addTemporaryLoadingImageByIndex(index: Int, imageName: String) {
        if (index % 2 == 0) {
            when (albumOrientation) {
                1 -> imageCache1?.addBitmapToCache(
                    imageName,
                    BitmapFactory.decodeResource(resources, R.drawable.image_load_landscape_right)
                )

                2 -> imageCache1?.addBitmapToCache(
                    imageName,
                    BitmapFactory.decodeResource(resources, R.drawable.image_load_portrait_right)
                )

                else -> imageCache1?.addBitmapToCache(
                    imageName,
                    BitmapFactory.decodeResource(resources, R.drawable.image_load_square_right)
                )
            }
        } else {
            when (albumOrientation) {
                1 -> imageCache1?.addBitmapToCache(
                    imageName,
                    BitmapFactory.decodeResource(resources, R.drawable.image_load_landscape_left)
                )

                2 -> imageCache1?.addBitmapToCache(
                    imageName,
                    BitmapFactory.decodeResource(resources, R.drawable.image_load_portrait_left)
                )

                else -> imageCache1?.addBitmapToCache(
                    imageName,
                    BitmapFactory.decodeResource(resources, R.drawable.image_load_square_left)
                )
            }
        }
    }

    private fun addTemporaryLoadingImageByPage(page: String, imageName: String) {
        if (page == "a") {
            when (albumOrientation) {
                1 -> imageCache1?.addBitmapToCache(
                    imageName,
                    BitmapFactory.decodeResource(resources, R.drawable.image_load_landscape_left)
                )

                2 -> imageCache1?.addBitmapToCache(
                    imageName,
                    BitmapFactory.decodeResource(resources, R.drawable.image_load_portrait_left)
                )

                else -> imageCache1?.addBitmapToCache(
                    imageName,
                    BitmapFactory.decodeResource(resources, R.drawable.image_load_square_left)
                )
            }
        } else {
            when (albumOrientation) {
                1 -> imageCache1?.addBitmapToCache(
                    imageName,
                    BitmapFactory.decodeResource(resources, R.drawable.image_load_landscape_right)
                )

                2 -> imageCache1?.addBitmapToCache(
                    imageName,
                    BitmapFactory.decodeResource(resources, R.drawable.image_load_portrait_right)
                )

                else -> imageCache1?.addBitmapToCache(
                    imageName,
                    BitmapFactory.decodeResource(resources, R.drawable.image_load_square_right)
                )
            }
        }
    }

//    override fun setDecodedImageInBitmap(imageName: String, bitmap: Bitmap) {
//        decodedImagesCount.plus(1)
//        imageCache1?.addBitmapToCache(imageName, tmp)
//        if (imageNamesArrayList.size + 1 == decodedImagesCount) {
//            fillPage()
//            if (dbHelper?.getSingleAlbumOriginalPhotoUrl(albumCode!!)!!.count == 0) {
//                //getMergedImageNameArrayList() // For recycler view in bottom
//                ImageDecodeImage().execute("")
//            } else {
//                val coverImage = dbHelper?.getCoverImageOfAlbum(albumCode!!)
//                if (coverImage != "") {
//                    val imageFile = File(
//                        getExternalFilesDir(null)?.toString(),
//                        getString(R.string.main_folder_name) + "/" + coverImage
//                    )
//                    imageCache1?.removeKey(coverImage)
//                    imageCache1?.addBitmapToCache(coverImage, decodeFile(imageFile, this))
//                }
//            }
//        }
//    }

    fun getResizedBitmap(bitmap: Bitmap): Bitmap {
        val metrics = DisplayMetrics()
        (this).windowManager.defaultDisplay.getMetrics(metrics)
        val screenWidth = metrics.widthPixels
        val screenHeight = metrics.heightPixels
        return Bitmap.createScaledBitmap(bitmap, screenWidth, screenHeight, true)
    }

    //@SuppressLint("StaticFieldLeak")
    inner class ImageDecodeImage : AsyncTask<String, Int, String>() {

        override fun doInBackground(vararg params: String): String? {
            try {
                DLog("CurlActivity:", "inside ImageDecodeImage: ${imageNamesArrayList.size}")
                //if (isActivityForeground) {
                //if (isCancelled) {
                //isShowAlbum = false
                imageArrayList.clear()
                for ((index, value) in imageNamesArrayList.withIndex()) {
                    DLog(
                        "CurlActivity:",
                        "inside ImageDecodeImage: ${imageNamesArrayList.get(index)}"
                    )
                    /*if(index.equals(k)){*/
                    val singlePageData = imageNamesArrayList.get(index)
                    var file: File? = null

                    if (StorageUtils.getFile(
                            this@CurlActivity,
                            singlePageData.imageName + singlePageData.extension
                        ).exists()
                    ) {
                        file = StorageUtils.getFile(
                            this@CurlActivity,
                            singlePageData.imageName + singlePageData.extension
                        )
                    } /*else {
                            File(getExternalFilesDir(null)?.toString(), getString(R.string.main_folder_name) + "/thumb/" + imageName)
                        }*/

                    //val tmp = BitmapFactory.decodeFile(file.absolutePath)
                    if (file != null) {
                        val tmp = decodeFileWithSplit(file, mContext!!, singlePageData.imageType)
                        //imageCache1?.removeKey(singlePageData.imageName)
                        //imageCache1?.addBitmapToCache(singlePageData.imageName, tmp)
                        if (singlePageData.imageType == AlbumImageType.full) {
                            imageCache1?.removeKey(singlePageData.imageName + "-a" + singlePageData.extension)
                            imageCache1?.removeKey(singlePageData.imageName + "-b" + singlePageData.extension)
                            imageCache1?.addBitmapToCache(
                                singlePageData.imageName + "-a" + singlePageData.extension,
                                tmp[0]
                            )
                            imageCache1?.addBitmapToCache(
                                singlePageData.imageName + "-b" + singlePageData.extension,
                                tmp[1]
                            )
                        } else {
                            /*if (imageDownloadStatusMap.entries.toList()[1].key == "${singlePageData.imageName}${singlePageData.extension}") {
                                imageCache1?.removeKey(singlePageData.imageName + "-a" + singlePageData.extension)
                                imageCache1?.addBitmapToCache(singlePageData.imageName + "-a" + singlePageData.extension, tmp[0])
                            } else {
                                imageCache1?.removeKey(singlePageData.imageName + "-b" + singlePageData.extension)
                                imageCache1?.addBitmapToCache(singlePageData.imageName + "-b" + singlePageData.extension, tmp[0])
                            }*/
                            if (imageDownloadStatusMap.entries.toList()[1].key == "${singlePageData.imageName}${singlePageData.extension}") {
                                imageCache1?.removeKey(singlePageData.imageName + "-b" + singlePageData.extension)
                                imageCache1?.addBitmapToCache(
                                    singlePageData.imageName + "-b" + singlePageData.extension,
                                    tmp[0]
                                )
                            } else {
                                imageCache1?.removeKey(singlePageData.imageName + "-a" + singlePageData.extension)
                                imageCache1?.addBitmapToCache(
                                    singlePageData.imageName + "-a" + singlePageData.extension,
                                    tmp[0]
                                )
                            }
                        }
                    }

                    if (isCancelled) {
                        break
                    }

                    //bitmapHashMap.put(imageName, Bitmap.createBitmap(tmp))
                }
                DLog("Step", "4")
                //fillPage()
                DLog("Step", "7")
                //}
            } catch (e: OutOfMemoryError) {
                DLog("CurlActivity : ", "error : ${e.message}")
            } catch (e: NullPointerException) {
                DLog(
                    "CurlActivity  : ",
                    "error : 'int android.graphics.Bitmap.getWidth() : ${e.message}"
                )
                //getModelList()
            }
            return null
        }

        override fun onPostExecute(s: String?) {
            super.onPostExecute(s)
            //fillPage()
            DLog("CurlActivity", "ImageDecodeImage :: onPostExecute()")
            showRecyclerView()
        }
    }

    // set a Images in PageFlipping Curl
    private fun fillPage() {

        isAlbumVisible = true
        //getMergedImageNameArrayList()
        // hiding the page_status bar
        window.setFlags(
            WindowManager.LayoutParams.FLAG_FULLSCREEN,
            WindowManager.LayoutParams.FLAG_FULLSCREEN
        )
        curl.setPageProvider(PageProvider(/*viewSingleAlbumActivityModelList*/))
        curl.setSizeChangedObserver(SizeChangedObserver())
        when {
            clickedPositon == 1 -> curl.currentIndex = 0
            clickedPositon == 2 -> curl.currentIndex = 1
            clickedPositon % 2 == 0 -> curl.currentIndex = (clickedPositon / 2)
            clickedPositon % 2 != 0 -> {
                val clickedPosition = clickedPositon - 1
                curl.currentIndex = (clickedPosition / 2) + 1
            }

            else -> curl.currentIndex = 0
        }
        //curl.setBackgroundColor(-0xdfd7d0)
        //curl.setBackgroundColor(-0x000000)
        //curl.setBackgroundColor(0x00000000)
        //curl.setBackgroundColor(0xff0000)
        //curl.setBackgroundColor(Color.parseColor("#00000000"))
        //curl.setBackgroundColor(Color.parseColor("#ffff0000"))
        if (MainActivity.albumViewBackgroundColor.isNotEmpty()) {
            if (MainActivity.albumViewBackgroundColor.split(",").isNotEmpty()) {
                curl.setBackgroundColor(
                    Color.parseColor(
                        "#${
                            MainActivity.albumViewBackgroundColor.split(
                                ","
                            )[0]
                        }"
                    )
                )
            }
        }
    }

    //ImageViewSlider
    private fun showRecyclerView() {
        DLog("CurlActivity", "ImageDecodeImage :: onPostExecute() showRecyclerView()")
        val customThumbnailAdapter = ImageViewSliderAdapter1(this, albumImagesMap)
        //val customThumbnailAdapter = ImageViewSliderAdapter1(this, mergedBitmapImageNameArrayList!!)
        if (albumOrientation == 1) {
            activityCurlLandscapeBinding.imageviewSliderRecyclerView.layoutManager =
                androidx.recyclerview.widget.LinearLayoutManager(
                    this,
                    androidx.recyclerview.widget.LinearLayoutManager.HORIZONTAL,
                    false
                )
            DLog("CurlActivity", "fu if  curl :: () ()")

        } else {
            activityCurlLandscapeBinding.imageviewSliderRecyclerView.layoutManager =
                androidx.recyclerview.widget.LinearLayoutManager(
                    this,
                    androidx.recyclerview.widget.LinearLayoutManager.VERTICAL,
                    false
                )
            DLog("CurlActivity", "fu else  curl :: () ()")

        }
        customThumbnailAdapter.setOnItemClickListener(this)
        activityCurlLandscapeBinding.imageviewSliderRecyclerView.adapter = customThumbnailAdapter
        /*Handler().postDelayed({
            customThumbnailAdapter.notifyDataSetChanged()
        }, 4000)*/
    }

    // slide the view from below itself to the current position
    private fun slideUp(recyclerView: androidx.recyclerview.widget.RecyclerView) {
        //recyclerView.visibility = View.VISIBLE
        //if(imageDownloadStatusMap.filter { !it.value }.toList().isEmpty()) {
        DLog("slideUp", "slideUp  if")
        isUp = true
        showRecyclerView()
        recyclerView.visibility = View.VISIBLE
        /*  DLog("visibility", "${recyclerView.isShown}")
      val animate = TranslateAnimation(
              0f, // fromXDelta
              0f, // toXDelta
              recyclerView.height.toFloat(), // fromYDelta
              0f)                // toYDelta
      animate.duration = 500
      animate.fillAfter = true
      recyclerView.startAnimation(animate)*/
        //}
    }

    // slide the view from its current position to below itself
    private fun slideDown(view: androidx.recyclerview.widget.RecyclerView) {
        view.visibility = View.INVISIBLE
        isUp = false
        /* val animate = TranslateAnimation(
                 0f, // fromXDelta
                 0f, // toXDelta
                 0f, // fromYDelta
                 view.height.toFloat()) // toYDelta
         animate.duration = 500
         animate.fillAfter = true
         view.startAnimation(animate)*/

    }

    public override fun onPause() {
        isActivityForeground = false
        imageDecodeImage?.cancel(true)
        AppConst.DISABLE_OR_ENABLE_CURL_ACTIVITY_CARD = true

        DLog("CurlActivity: ", "AlbumMusic onPause() step 1")
        DLog("CurlActivity: ", "${AppConst.DISABLE_OR_ENABLE_CURL_ACTIVITY_CARD}")

        DLog("CurlActivity: ", "AlbumMusic onPause() step 2")
        if (onBackPressedValue) {
            setIntPreference(mContext!!, SharedPreferenceConst.CURRENT_INDEX, 0)
        } else {
            setIntPreference(mContext!!, SharedPreferenceConst.CURRENT_INDEX, currentIndexValue)
        }

        DLog("CurlActivity: ", "AlbumMusic onPause() step 3")
        DLog("On pause", "on pause $mPlayer")
        DLog("CurlActivity: ", "AlbumMusic onPause() step 4")
        try {
            if (mPlayer != null) {
                DLog("CurlActivity: ", "AlbumMusic onPause() step 5")
                // mPlayer?.stop()
                if (i == 0) {
                    DLog("CurlActivity: ", "AlbumMusic onPause() step 6")
                    activityCurlLandscapeBinding.fab5.setImageResource(R.drawable.ic_music_stop_note_black_24dp)
                    i = 2
                    mPlayer!!.pause()
                    DLog("CurlActivity: ", "AlbumMusic onPause() step 7")
                    length = mPlayer!!.currentPosition
                    //mPlayer?.release()
                    musicPlay = true
                    DLog("CurlActivity: ", "AlbumMusic onPause() step 8")
                } else if (i == 2) {
                    DLog("CurlActivity: ", "AlbumMusic onPause() step 9")
                    i = 0
                }
            }
        } catch (e: Exception) {
        }
        curl.onPause()
        DLog("CurlActivity: ", "AlbumMusic onPause() step 10")
        super.onPause()
        CacheAsyncTask().execute(MESSAGE_FLUSH)
    }

    private fun checkForExistingAlbumImages(lastUpdatedAt: Int) {
        if (dbHelper!!.ifAlbumImageExistsOrNot(albumCode!!)) {
            checkImages()
            //startAlbumUpdateWorker(lastUpdatedAt)
        } else {
            this.finish()
            //CustomToast.alert(this, resources.getString(R.string.no_images_available_in_album))
            Toast.makeText(
                this,
                resources.getString(R.string.no_images_available_in_album),
                Toast.LENGTH_LONG
            ).show()
        }
    }

    public override fun onResume() {

        isActivityForeground = true
        DLog("CurlActivity: ", "AlbumMusic onResume() step 1")
        curl.currentIndex = getIntPreference(mContext!!, SharedPreferenceConst.CURRENT_INDEX)

        DLog("CurlActivity: ", "isFABOpen: $isFABOpen")
        if (isFABOpen) {
            DLog("CurlActivity: ", "AlbumMusic onResume() step 2")
            activityCurlLandscapeBinding.activityCurlStudioLogoImageView.visibility = View.INVISIBLE
            activityCurlLandscapeBinding.activityCurlSmallStudioLogoImageView.visibility = View.GONE
        } else {
            DLog("CurlActivity: ", "AlbumMusic onResume() step 3")
            if (dbHelper?.isAllImagesDownloaded(albumCode!!)!!) {
                activityCurlLandscapeBinding.activityCurlStudioLogoImageView.visibility =
                    View.VISIBLE
            } else {
                activityCurlLandscapeBinding.activityCurlStudioLogoImageView.visibility =
                    View.INVISIBLE
            }
            activityCurlLandscapeBinding.activityCurlSmallStudioLogoImageView.visibility = View.GONE
        }
        DLog("CurlActivity: ", "AlbumMusic onResume() step 4")
        if (mPlayer != null) {
            DLog("CurlActivity: ", "AlbumMusic onResume() step 5")
            DLog("Onresume", "onresume")
            if (musicPlay) {
                DLog("CurlActivity: ", "AlbumMusic onResume() step 6")
                DLog("musicPlay", "true")
                if (i == 2) {
                    DLog("CurlActivity: ", "AlbumMusic onResume() step 7")
                    activityCurlLandscapeBinding.fab5.setImageResource(R.drawable.ic_music_note_black_24dp)
                    mPlayer!!.seekTo(length)
                    mPlayer!!.start()
                    i = 0
                } else if (i == 0) {
                    DLog("CurlActivity: ", "AlbumMusic onResume() step 8")
                    activityCurlLandscapeBinding.fab5.setImageResource(R.drawable.ic_music_stop_note_black_24dp)
                    mPlayer?.pause()
                    i = 2
                }
                DLog("CurlActivity: ", "AlbumMusic onResume() step 9")
            }
            DLog("CurlActivity: ", "AlbumMusic onResume() step 10")
        }
        DLog("CurlActivity: ", "AlbumMusic onResume() step 11")
        super.onResume()
        curl.onResume()

        //onStartContent()
        //checkPermission()
    }

    override fun onRetainCustomNonConfigurationInstance(): Any = curl.currentIndex

    private inner class PageProvider : CurlView.PageProvider {

        override fun getPageCount(): Int {
            //return if(true) imageNamesArrayListSize / 2 + 1 else imageNamesArrayListSize / 2
            return totalAlbumPaperSize
        }

        private fun loadBitmap(width: Int, height: Int, index: Int, bitmap: Bitmap): Bitmap {

            DLog("CurlActivity: ", "inside PageProvider loadBitmap")

            val b = Bitmap.createBitmap(
                width, height,
                Bitmap.Config.ARGB_8888
            )
            b.eraseColor(-0x1)
            val c = Canvas(b)
            val d = BitmapDrawable(resources, bitmap)
            val margin = 0
            val border = 0
            val r = Rect(margin, margin, width - margin, height - margin)

            val p = Paint()
            p.color = Color.rgb(151, 124, 83)
            c.drawRect(r, p)
            r.left += border
            r.right -= border
            r.top += border
            r.bottom -= border

            d.bounds = r
            d.draw(c)

            return b
        }

        private fun loadBitmap1(width: Int, height: Int, index: Int, bitmap: Bitmap): Bitmap {

            DLog("CurlActivity: ", "inside PageProvider loadBitmap 1")

            val b = Bitmap.createBitmap(
                width, height,
                Bitmap.Config.ARGB_8888
            )
            b.eraseColor(-0x1)
            val c = Canvas(b)
            val bOutput: Bitmap
            val matrix = Matrix()
            matrix.preScale(-1.0f, 1.0f)
            //try {
            bOutput = Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
            /*}catch (e: OutOfMemoryError){

            }*/

            val d = BitmapDrawable(resources, bOutput)

            val margin = 0
            val border = 0
            val r = Rect(margin, margin, width - margin, height - margin)

            val p = Paint()
            p.color = Color.rgb(151, 124, 83)
            c.drawRect(r, p)
            r.left += border
            r.right -= border
            r.top += border
            r.bottom -= border

            d.bounds = r
            d.draw(c)

            return b
        }

        override fun getCurlState(state: String?) {
            mStateOfCurl = if (state != null) {
                state
            } else {
                "0"
            }
        }

        override fun updatePage(page: CurlPage, width: Int, height: Int, k: Int) {
            // DLog("page numbers", "${page} ${width} ${height} ${k}")
            //var imageNamesArrayList = mutableListOf<String>()

            var even = 0
            var odd = 0

            currentIndexValue = k

            val albumImagesMapKeyArray = albumImagesMap.keys.toTypedArray()
            DLog(
                "CurlActivity :",
                "updatePage Key Array : " + Arrays.toString(albumImagesMapKeyArray)
            )
            val imageList = albumImagesMap[albumImagesMapKeyArray.get(k)]
            //var nextImageList = albumImagesMap[albumImagesMapKeyArray.get(k+1)]
            //var previousImageList = albumImagesMap[albumImagesMapKeyArray.get(k-1)]

            /*setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageList!![0])
            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageList!![1])*/

            DLog("CurlActivity :", "K Value: $k  -- $mStateOfCurl")
            try {
                if (mStateOfCurl == "0") {
                    // left curl
                    when (k) {
                        0, 1 -> {
                            // val list = albumImagesMap[albumImagesMapKeyArray.get(0)]
                            val list = try {
                                albumImagesMap[albumImagesMapKeyArray.get(1)]!!
                            } catch (e: java.lang.IndexOutOfBoundsException) {
                                albumImagesMap[albumImagesMapKeyArray.get(0)]!!
                            }
                            if (list!!.get(0).isNotEmpty() && list.get(1).isNotEmpty()) {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list.get(0))
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list.get(1))
                            } else if (list.get(0).isNotEmpty() && list.get(1).isEmpty()) {
                                setStringPreference(
                                    mContext!!,
                                    FIRST_IMAGE_ZOOM,
                                    albumImagesMap[albumImagesMapKeyArray.get(0)]!!.get(1)
                                )
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list.get(0))
                            } else if (list.get(0).isEmpty() && list.get(1).isNotEmpty()) {
                                setStringPreference(
                                    mContext!!,
                                    FIRST_IMAGE_ZOOM,
                                    albumImagesMap[albumImagesMapKeyArray.get(0)]!!.get(1)
                                )
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list.get(1))
                            }
                            // val list1 =albumImagesMap[albumImagesMapKeyArray.get(1)]
                        }

                        totalAlbumPaperSize - 2 -> {
                            val newKValue = totalAlbumPaperSize - 1
                            val list = albumImagesMap[albumImagesMapKeyArray.get(newKValue)]
                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list!![0])
                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])

                            if (list[0].isNotEmpty() && list[1].isNotEmpty()) {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[0])
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])
                            } else if (list[0].isNotEmpty() && list[1].isEmpty()) {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[0])
                                setStringPreference(
                                    mContext!!,
                                    SECOND_IMAGE_ZOOM,
                                    albumImagesMap[albumImagesMapKeyArray.get(0)]!!.get(0)
                                )
                            } else if (list[0].isEmpty() && list[1].isNotEmpty()) {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[1])
                                setStringPreference(
                                    mContext!!,
                                    SECOND_IMAGE_ZOOM,
                                    albumImagesMap[albumImagesMapKeyArray.get(0)]!!.get(0)
                                )
                            } else {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[0])
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])
                            }
                        }

                        else -> {
                            val previousImageList =
                                albumImagesMap[albumImagesMapKeyArray.get(k + 1)]
                            //  DLog("right curl numbers11", "${k} ${(k * 2) - 2}  ${(k * 2) - 1}   ${imageNamesArrayList.get((k * 2) - 2)} ${imageNamesArrayList.get((k * 2) - 1)}")
                            setStringPreference(
                                mContext!!,
                                FIRST_IMAGE_ZOOM,
                                previousImageList!![0]
                            )
                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, previousImageList[1])
                        }
                    }
                } else if (mStateOfCurl == "1") {
                    // right curl
                    when (k) {
                        0 -> {
                            val list = albumImagesMap[albumImagesMapKeyArray.get(0)]
                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list!![0])
                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])
                        }

                        totalAlbumPaperSize - 1 -> {
                            val newKValue = totalAlbumPaperSize - 1
                            val list = albumImagesMap[albumImagesMapKeyArray.get(newKValue)]
                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list!![0])
                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])

                            if (list[0].isNotEmpty() && list[1].isNotEmpty()) {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[0])
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])
                            } else if (list[0].isNotEmpty() && list[1].isEmpty()) {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[0])
                                setStringPreference(
                                    mContext!!,
                                    SECOND_IMAGE_ZOOM,
                                    albumImagesMap[albumImagesMapKeyArray.get(0)]!!.get(0)
                                )
                            } else if (list[0].isEmpty() && list[1].isNotEmpty()) {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[1])
                                setStringPreference(
                                    mContext!!,
                                    SECOND_IMAGE_ZOOM,
                                    albumImagesMap[albumImagesMapKeyArray.get(0)]!!.get(0)
                                )
                            } else {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[0])
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])
                            }
                        }

                        else -> {
                            //val currentPos = k + 1
                            // try {
                            // DLog("page numbers11", "${currentPos} ${(currentPos * 2) - 2}  ${(currentPos * 2) - 1}  ${imageNamesArrayList.get((currentPos * 2) - 2)}  ${imageNamesArrayList.get((currentPos * 2) - 1)} ")
                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageList!![0])
                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageList[1])
                        }
                    }
                }
            } catch (e: ArrayIndexOutOfBoundsException) {
                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageList!![0])
                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageList[1])
            }


            /*if (true) {
                if (mStateOfCurl.equals("0")) {
                    // left curl
                    when (k) {
                        0 -> {
                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageNamesArrayList[(k)])
                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageNamesArrayList[(k + 1)])
                        }
                        imageNamesArrayListSize / 2 -> {
                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageNamesArrayList[(k * 2) - 2])
                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageNamesArrayList.get((k * 2) - 1))
                        }
                        else -> {
                            val currentPos = k + 1
                            try {
                                // DLog("page numbers11", "${currentPos} ${(currentPos * 2) - 2}  ${(currentPos * 2) - 1}  ${imageNamesArrayList.get((currentPos * 2) - 2)}  ${imageNamesArrayList.get((currentPos * 2) - 1)} ")
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageNamesArrayList[(currentPos * 2) - 2])
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageNamesArrayList[(currentPos * 2) - 1])
                            } catch (e: IndexOutOfBoundsException) {
                                DLog("CurlActivity ERROR: ", e.message.toString())
                            }
                        }
                    }
                } else if (mStateOfCurl.equals("1")) {
                    // right curl
                    when (k) {
                        0 -> {
                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageNamesArrayList[(k)])
                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageNamesArrayList[(k + 1)])
                        }
                        imageNamesArrayListSize / 2 -> {
                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageNamesArrayList[(k * 2) - 2])
                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageNamesArrayList[(k * 2) - 1])
                        }
                        else -> {
                            //  DLog("right curl numbers11", "${k} ${(k * 2) - 2}  ${(k * 2) - 1}   ${imageNamesArrayList.get((k * 2) - 2)} ${imageNamesArrayList.get((k * 2) - 1)}")
                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageNamesArrayList[(k * 2) - 2])
                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageNamesArrayList[(k * 2) - 1])
                        }
                    }
                }
            } else {
                if (k == 0) {// || k==imageNamesArrayList.size/2){
                    setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageNamesArrayList[(k * 2)])
                    setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageNamesArrayList[imageNamesArrayList.size - 1])
                }
                //else if(k <= imageNamesArrayList.size/2 ){
                else if (k in 0..imageNamesArrayList.size / 2) {
                    setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageNamesArrayList[((k * 2) - 1)])
                    setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageNamesArrayList[(k * 2)])
                } else {
                    setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageNamesArrayList[(k * 2)])
                    setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageNamesArrayList[imageNamesArrayList.size - 1])
                }
            }*/

            //val tmp1 = BitmapFactory.decodeResource(resources, R.drawable.download)

            //try {


            //DLog("CurlActivity :","update imageList : $imageList [next]  ${albumImagesMap[albumImagesMapKeyArray.get(k+1)]}")

            DLog("CurlActivity :", "totalAlbumPaperSize : $totalAlbumPaperSize , k : $k")
            if (totalAlbumPaperSize - 1 == k) {
                try {
                    if (albumImagesMap[albumImagesMapKeyArray.get(k)]!!.get(0) == "" || albumImagesMap[albumImagesMapKeyArray.get(
                            k
                        )]!!.get(1) == ""
                    ) {
                        DLog("CurlActivity : ", "updatePage : if step 1 K::$k")
                        page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_FRONT)
                    } else {
                        DLog("CurlActivity : ", "updatePage : if step 2 K::$k")
                        page.setTexture(
                            loadBitmap(
                                width,
                                height,
                                k,
                                getBitmapFromIndex1(imageList?.get(1)!!, imageList.get(2))
                            ), CurlPage.SIDE_FRONT
                        )
                    }
                } catch (e: OutOfMemoryError) {
                    page.setTexture(
                        loadBitmap(width, height, k, getSampleEmptyBitmap()),
                        CurlPage.SIDE_FRONT
                    )
                }

                try {
                    val imageList = albumImagesMap[albumImagesMapKeyArray.get(0)]
                    page.setTexture(
                        loadBitmap1(
                            width,
                            height,
                            k,
                            getBitmapFromIndex1(imageList?.get(0)!!, imageList.get(2)!!)
                        ), CurlPage.SIDE_BACK
                    )
                } catch (e: OutOfMemoryError) {
                    page.setTexture(
                        loadBitmap1(width, height, k, getSampleEmptyBitmap()),
                        CurlPage.SIDE_BACK
                    )
                }
            } else if (k == 0) {

                try {
                    if (albumImagesMap[albumImagesMapKeyArray.get(k)]!!.get(1) == "") {
                        DLog("CurlActivity : ", "updatePage : if else step 1")
                        page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_FRONT)
                    } else {
                        DLog(
                            "CurlActivity : ",
                            "updatePage : if else step 2 K::$k : ${imageList!![1]}"
                        )
                        page.setTexture(
                            loadBitmap(
                                width,
                                height,
                                k,
                                getBitmapFromIndex1(imageList.get(1)!!, imageList.get(2)!!)
                            ), CurlPage.SIDE_FRONT
                        )
                    }
                } catch (e: OutOfMemoryError) {
                    page.setTexture(
                        loadBitmap(width, height, k, getSampleEmptyBitmap()),
                        CurlPage.SIDE_FRONT
                    )
                }

                try {
                    if (albumImagesMap[albumImagesMapKeyArray.get(k + 1)]!!.get(0) != "" && albumImagesMap[albumImagesMapKeyArray.get(
                            k + 1
                        )]!!.get(1) != ""
                    ) {
                        DLog("CurlActivity : ", "updatePage : if else step 3 K::$k")
                        val nextImageList = albumImagesMap[albumImagesMapKeyArray.get(k + 1)]
                        page.setTexture(
                            loadBitmap1(
                                width,
                                height,
                                k,
                                getBitmapFromIndex1(nextImageList!![0], nextImageList[2])
                            ), CurlPage.SIDE_BACK
                        )
                    } else {
                        page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_BACK)
                    }
                } catch (e: OutOfMemoryError) {
                    page.setTexture(
                        loadBitmap1(width, height, k, getSampleEmptyBitmap()),
                        CurlPage.SIDE_BACK
                    )
                }

            } else if (k == 1) {

                try {
                    if (albumImagesMap[albumImagesMapKeyArray.get(k)]!!.get(1) == "") {
                        DLog("CurlActivity : ", "updatePage : if else step 1")
                        page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_FRONT)
                    } else {
                        DLog(
                            "CurlActivity : ",
                            "updatePage : if else step 2 K::$k : ${imageList!![0]}"
                        )
                        page.setTexture(
                            loadBitmap(
                                width,
                                height,
                                k,
                                getBitmapFromIndex1(imageList?.get(1)!!, imageList.get(2))
                            ), CurlPage.SIDE_FRONT
                        )
                    }
                } catch (e: OutOfMemoryError) {
                    page.setTexture(
                        loadBitmap(width, height, k, getSampleEmptyBitmap()),
                        CurlPage.SIDE_FRONT
                    )
                }

                try {
                    if (albumImagesMap[albumImagesMapKeyArray.get(k + 1)]!!.get(0) == "") {
                        if (albumImagesMap[albumImagesMapKeyArray.get(k + 1)]!!.get(1) != "") {
                            val nextImageList = albumImagesMap[albumImagesMapKeyArray.get(k + 1)]
                            DLog(
                                "CurlActivity : ",
                                "updatePage : if else step 4 K::$k : ${nextImageList!![1]}"
                            )
                            page.setTexture(
                                loadBitmap1(
                                    width,
                                    height,
                                    k,
                                    getBitmapFromIndex1(nextImageList!![1], nextImageList[2])
                                ), CurlPage.SIDE_BACK
                            )
                        }
                    } else {
                        val nextImageList = albumImagesMap[albumImagesMapKeyArray.get(k + 1)]
                        DLog(
                            "CurlActivity : ",
                            "updatePage : if else step 4 K::$k : ${nextImageList!![0]}"
                        )
                        page.setTexture(
                            loadBitmap1(
                                width,
                                height,
                                k,
                                getBitmapFromIndex1(nextImageList!![0], nextImageList[2])
                            ), CurlPage.SIDE_BACK
                        )
                    }
                } catch (e: OutOfMemoryError) {
                    page.setTexture(
                        loadBitmap1(width, height, k, getSampleEmptyBitmap()),
                        CurlPage.SIDE_BACK
                    )
                }

            } else {

                try {
                    if (albumImagesMap[albumImagesMapKeyArray.get(k)]!!.get(0) != "" && albumImagesMap[albumImagesMapKeyArray.get(
                            k
                        )]!!.get(1) != ""
                    ) {
                        DLog(
                            "CurlActivity : ",
                            "updatePage : if else step 2 K::$k : ${imageList!![0]}"
                        )
                        page.setTexture(
                            loadBitmap(
                                width,
                                height,
                                k,
                                getBitmapFromIndex1(imageList?.get(1)!!, imageList.get(2))
                            ), CurlPage.SIDE_FRONT
                        )
                    } else {
                        DLog("CurlActivity : ", "updatePage : if else step 1")
                        page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_FRONT)
                    }
                } catch (e: OutOfMemoryError) {
                    page.setTexture(
                        loadBitmap(width, height, k, getSampleEmptyBitmap()),
                        CurlPage.SIDE_FRONT
                    )
                }


                try {
                    if (albumImagesMap[albumImagesMapKeyArray.get(k + 1)]!!.get(0) == "") {
                        if (albumImagesMap[albumImagesMapKeyArray.get(k + 1)]!!.get(1) != "") {
                            val nextImageList = albumImagesMap[albumImagesMapKeyArray.get(k + 1)]
                            DLog(
                                "CurlActivity : ",
                                "updatePage : if else step 4 K::$k : ${nextImageList!![1]}"
                            )
                            page.setTexture(
                                loadBitmap1(
                                    width,
                                    height,
                                    k,
                                    getBitmapFromIndex1(nextImageList!![1], nextImageList[2])
                                ), CurlPage.SIDE_BACK
                            )
                        }
                    } else {
                        val nextImageList = albumImagesMap[albumImagesMapKeyArray.get(k + 1)]
                        DLog(
                            "CurlActivity : ",
                            "updatePage : if else step 4 K::$k : ${nextImageList!![0]}"
                        )
                        page.setTexture(
                            loadBitmap1(
                                width,
                                height,
                                k,
                                getBitmapFromIndex1(nextImageList!![0], nextImageList[2])
                            ), CurlPage.SIDE_BACK
                        )
                    }
                } catch (e: OutOfMemoryError) {
                    page.setTexture(
                        loadBitmap1(width, height, k, getSampleEmptyBitmap()),
                        CurlPage.SIDE_BACK
                    )
                }
            }


            /*var albumImagesMapKeyArray = albumImagesMap.keys.toTypedArray()
            DLog("CurlActivity :", "updatePage Key Array : " + Arrays.toString(albumImagesMapKeyArray))
            var imageList = albumImagesMap[albumImagesMapKeyArray.get(k)]
            //DLog("CurlActivity :","update imageList : $imageList [next]  ${albumImagesMap[albumImagesMapKeyArray.get(k+1)]}")

            DLog("CurlActivity :","totalAlbumPaperSize : $totalAlbumPaperSize , k : $k")
            if(totalAlbumPaperSize - 1 == k){
                if(albumImagesMap[albumImagesMapKeyArray.get(k)]!!.get(1) == "") {
                    DLog("CurlActivity : ","updatePage : if step 1 K::$k")
                    page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_FRONT)
                }else{
                    DLog("CurlActivity : ","updatePage : if step 2 K::$k")
                    page.setTexture(loadBitmap(width, height, k, getBitmapFromIndex1(imageList?.get(1)!!)), CurlPage.SIDE_FRONT)
                }
                //page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_BACK)
                val imageList = albumImagesMap[albumImagesMapKeyArray.get(0)]
                page.setTexture(loadBitmap1(width, height, k, getBitmapFromIndex1(imageList?.get(0)!!)), CurlPage.SIDE_BACK)
            } else {
                if(albumImagesMap[albumImagesMapKeyArray.get(k)]!!.get(1) == "") {
                    DLog("CurlActivity : ","updatePage : if else step 1")
                    page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_FRONT)
//                    }else{
                    DLog("CurlActivity : ","updatePage : if else step 2 K::$k : ${imageList!![0]}")
                    page.setTexture(loadBitmap(width, height, k, getBitmapFromIndex1(imageList?.get(1)!!)), CurlPage.SIDE_FRONT)
                }
                if (albumImagesMap[albumImagesMapKeyArray.get(k+1)]!!.get(0) == "") {
                    DLog("CurlActivity : ","updatePage : if else step 3 K::$k")
                    page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_BACK)
                }else{
                    var nextImageList = albumImagesMap[albumImagesMapKeyArray.get(k+1)]
                    DLog("CurlActivity : ","updatePage : if else step 4 K::$k : ${nextImageList!![0]}")
                    page.setTexture(loadBitmap1(width, height, k, getBitmapFromIndex1(nextImageList!![0])), CurlPage.SIDE_BACK)
                }
            }*/

            /*if(k == totalAlbumPaperSize){
            page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_FRONT)
            page.setTexture(loadBitmap(width, height, k, getBitmapFromIndex1(imageList?.get(0)!!)), CurlPage.SIDE_BACK)
        }*/


            /*} catch (e: Exception) {
            }*/

            /*try {
                if(true) {
                    if (k == 0) {

                        val front = loadBitmap(width, height, k, getBitmapFromIndex(k))
                        page.setTexture(front, CurlPage.SIDE_FRONT)
                        page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_BACK)

                    } else if (k != 0 && k == 1 && k != imageNamesArrayList.size / 2 + 1) { // 1,

                        val front = loadBitmap(width, height, k, getBitmapFromIndex(k))
                        page.setTexture(front, CurlPage.SIDE_FRONT)
                        val back = loadBitmap1(width, height, k, getBitmapFromIndex(k + 1))
                        page.setTexture(back, CurlPage.SIDE_BACK)

                    } else if (k != 0 && k != 1 && k % 2 != 0 && k != imageNamesArrayList.size / 2) {

                        odd = k - 1
                        val front = loadBitmap(width, height, k, getBitmapFromIndex(odd + k))
                        page.setTexture(front, CurlPage.SIDE_FRONT)
                        val back = loadBitmap1(width, height, k, getBitmapFromIndex(k + k))
                        page.setTexture(back, CurlPage.SIDE_BACK)

                    } else if (k != 0 && k % 2 == 0 && k != imageNamesArrayList.size / 2) {

                        val back = loadBitmap1(width, height, k, getBitmapFromIndex(k + k))
                        page.setTexture(back, CurlPage.SIDE_BACK)
                        even = k - 1
                        val back1 = loadBitmap(width, height, k, getBitmapFromIndex(even + k))
                        page.setTexture(back1, CurlPage.SIDE_FRONT)

                    }
                    if (k == imageNamesArrayList.size / 2) {

                        odd = k - 1
                        val back = loadBitmap1(width, height, k, getBitmapFromIndex(odd + k))
                        page.setTexture(back, CurlPage.SIDE_BACK)
                        page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_FRONT)

                    }
                    indexvalue = k
                } else {
                    DLog("k value ","$k")
                    page.setTexture(loadBitmap(width, height, k, getBitmapFromIndex(k*2)), CurlPage.SIDE_FRONT)
                    DLog("K value1 :","${k*2}")
                    page.setTexture(loadBitmap1(width, height, k, getBitmapFromIndex((k*2)+1)), CurlPage.SIDE_BACK)
                    DLog("K value1 :","${(k*2)+1}")
                    indexvalue = k
                }
            } catch (e: IndexOutOfBoundsException) {
                DLog("CurlActivity :", "${e.message}")
            } catch (e: Exception) {
                DLog("CurlActivity :", "${e.message}")
            }*/
        }
    }

    private fun getBitmapFromIndex(index: Int): Bitmap {
        return bitmapHashMap[bitmapHashMap.keys.toTypedArray().get(index)]!!
    }

    fun getBitmapFromIndex1(imageUrl: String, imageType: String): Bitmap {

        /*try {
            return bitmapHashMap1.get(imageUrl)?.get()!!
        }catch (e: KotlinNullPointerException){
            val w = 10
            val h = 10

            val conf = Bitmap.Config.ARGB_8888 // see other conf types
            return Bitmap.createBitmap(w, h, conf)
        }*/

        //return bitmapHashMap.get(imageUrl)!!
        try {
            //return imageCache1!!.getBitmapFromDiskCache(imageUrl)
            return imageCache1!!.getBitmapFromDiskCache(imageUrl)
        } catch (e: java.lang.NullPointerException) {
            DLog(
                "CurlActivity :",
                "inside getBitmapFromIndex1 ERROR: NullPointerException :: ${e.toString()}"
            )
            return getCacheImageBitmap(imageUrl, imageType)
        } catch (e: IllegalStateException) {
            DLog(
                "CurlActivity :",
                "inside getBitmapFromIndex1 ERROR: IllegalStateException :: ${e.toString()}"
            )
            return getCacheImageBitmap(imageUrl, imageType)
        } catch (e: OutOfMemoryError) {
            return getSampleEmptyBitmap()
        }

        /*DLog("CurlActivity :","inside getBitmapFromIndex1 $imageUrl")
        try {
            return cache!!.getImageFromWarehouse(imageUrl)!!
        }catch (e: KotlinNullPointerException){
            val w = 10
            val h = 10

            val conf = Bitmap.Config.ARGB_8888 // see other conf types
            return Bitmap.createBitmap(w, h, conf)
        }*/
    }

    private fun getCacheImageBitmap(imageUrl: String, imageType: String): Bitmap {
        val imageName = imageUrl.substring(0, imageUrl.lastIndexOf("-"))
        val imageExtension = imageUrl.substring(imageUrl.lastIndexOf("."), imageUrl.length)
        val imageNameInFile = imageName + imageExtension
        DLog("CurlActivity", "getCacheImageBitmap() :: $imageUrl :: $imageNameInFile")
        val file = if (StorageUtils.getFile(this, imageNameInFile).exists()) {
            //DLog("CurlActivty:", "inside getModelList: inside if ${imageNamesArrayList.get(index)}")
            StorageUtils.getFile(this, imageNameInFile)
        } else {
            StorageUtils.getThumbFile(this, imageNameInFile)
        }

        //var tmp = BitmapFactory.decodeFile(file.absolutePath)
        val tmp = decodeFileWithSplit(file, this, imageType.toInt())
        bitmapHashMap[imageUrl] = getSampleEmptyBitmap()
        imageCache1?.removeKey(imageUrl)
        if (imageType == AlbumImageType.full.toString()) {
            imageCache1?.addBitmapToCache("$imageName-a$imageExtension", tmp[0])
            imageCache1?.addBitmapToCache("$imageName-b$imageExtension", tmp[1])
            /*if(imageUrl.endsWith('a')) {
                imageCache1?.addBitmapToCache(imageUrl, tmp[0])
            }else {
                imageCache1?.addBitmapToCache(imageUrl, tmp[1])
            }*/
        } else {
            imageCache1?.addBitmapToCache(imageUrl, tmp[0])
            /*if (imageDownloadStatusMap.entries.toList()[1].key == "${imageName}${imageExtension}") {
                imageCache1?.removeKey("$imageName-b$imageExtension")
                imageCache1?.addBitmapToCache("$imageName-b$imageExtension", tmp[0])
            } else {
                imageCache1?.removeKey("$imageName-a$imageExtension")
                imageCache1?.addBitmapToCache("$imageName-a$imageExtension", tmp[0])
            }*/
        }
        //imageCache1?.addBitmapToCache(imageUrl, tmp)
        try {
            return imageCache1!!.getBitmapFromDiskCache(imageUrl)
        } catch (e: IllegalStateException) {
            /*bitmapHashMap.put(imageUrl, Bitmap.createBitmap(w, h, conf))
            imageCache1?.removeKey(imageUrl)
            imageCache1?.addBitmapToCache(imageUrl, tmp)
            return imageCache1!!.getBitmapFromDiskCache(imageUrl)*/
            return getSampleEmptyBitmap()
        } /*catch (e: java.lang.NullPointerException) {
            return getSampleEmptyBitmap()
        }*/
    }

    /* CurlView size changed observer.*/

    private inner class SizeChangedObserver : CurlView.SizeChangedObserver {
        override fun onSizeChanged(w: Int, h: Int) {
            /*if (w > h) {
                mCurlView!!.setViewMode(CurlView.SHOW_ONE_PAGE)
                mCurlView!!.setMargins(.1f, .05f, .1f, .05f)
            } else {
                mCurlView!!.setViewMode(CurlView.SHOW_ONE_PAGE)
                mCurlView!!.setMargins(.1f, .1f, .1f, .1f)
            }*/
            if (w > h) {
                curl.setViewMode(CurlView.SHOW_TWO_PAGES)
                // curl!!.setMargins(.1f, .05f, .1f, .05f)

                curl.setMargins(.0f, .0f, .0f, .0f)
            } else {
                curl.setViewMode(CurlView.SHOW_ONE_PAGE)
                curl.setMargins(.1f, .1f, .1f, .1f)
            }
        }
    }

    override fun downloadCompleteListener() = checkImages()

    override fun singleImageClickListener(position: Int, imageList: ArrayList<String>) {
        curl.currentIndex = position

        if (position != 0 && position != mergedBitmapImageNameArrayList.size - 1) {
            /*setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageNamesArrayList.get((position * 2) - 2))
            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageNamesArrayList.get((position * 2) - 1))*/

            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageList[0])
            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageList[1])
        }
    }

    override fun getBitmapListener(imageUrl: String, imageType: String): Bitmap {
        /*val options = BitmapFactory.Options()
        options.inSampleSize = 2
        folderPath = this.getExternalFilesDir(null)?.toString() + "/.photomall/thumb/"
        if (File(folderPath, imageUrl).exists()) {
            image = File(folderPath, imageUrl)
            //bitmap = EncryptAndDecryptFiles.decodeFile(image!!, this)
            //var bitmap = BitmapFactory.decodeFile(image!!.absolutePath)
            //val bitmap = BitmapFactory.decodeStream(image!!.inputStream(), null, options)
            //bitmapImage = getResizedBitmap(bitmap)
        } else {
            folderPath = this.getExternalFilesDir(null)?.toString() + "/.photomall/"
            image = File(folderPath, imageUrl)
            //bitmap = BitmapFactory.decodeStream(image!!.inputStream(), null, options)
            //var bitmap = BitmapFactory.decodeFile(image!!.absolutePath)
            //val bitmap = BitmapFactory.decodeStream(image!!.inputStream(), null, options)
            //bitmapImage = getResizedBitmap(bitmap)
        }*/

        //val bitmap = BitmapFactory.decodeStream(image!!.inputStream(), null, options)

        //return Bitmap.createBitmap(bitmap)
        //return bitmap!!
        //return decodeFile(image!!, this)
        return getBitmapFromIndex1(imageUrl, imageType)
    }

    override fun deleteImageListener(position: Int, it: View) {}

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 1 && resultCode == Activity.RESULT_OK) {
            DLog("CurlActivity : ", "inside onActivityResult 1")
            /* Handler().postDelayed({
                 recreate()
             }, 1000)*/

            if (dbHelper!!.ifAlbumImageExistsOrNot(albumCode!!)) {
                val intentViewSingleAlbum = Intent(mContext, CurlActivity::class.java)
                intentViewSingleAlbum.putExtra("albumCode", albumCode!!)
                //intentViewSingleAlbum.putExtra("album_name", albumName)
                intentViewSingleAlbum.putExtra("musicCode", musicCode)
                intentViewSingleAlbum.putExtra("albumSize", albumSize)
                intentViewSingleAlbum.putExtra("albumType", albumType)
                intentViewSingleAlbum.putExtra("updatedAt", lastUpdatedAt)
                intentViewSingleAlbum.putExtra("orientation", orientation)
                //intentViewSingleAlbum.putExtra("eventsRandomId", eventsRandomId)
                intentViewSingleAlbum.putExtra("eventsPasscode", eventsPasscode)
                intentViewSingleAlbum.putExtra("eventsUrl", eventsUrl)
                intentViewSingleAlbum.putExtra("eventType", eventsType)
                intentViewSingleAlbum.putExtra("eventId", eventCode)
                intentViewSingleAlbum.putExtra("canTakeScreenshot", canTakeScreenshot)
                startActivity(intentViewSingleAlbum)
                finish()
            } else {
                this.finish()
                //CustomToast.alert(this, resources.getString(R.string.no_images_available_in_album))
                Toast.makeText(
                    this,
                    resources.getString(R.string.no_images_available_in_album),
                    Toast.LENGTH_LONG
                ).show()
            }
            //setImagesInImageArrayList()
            //checkImages()
            //recreate()
            //onStartContent()
            //onStart()
            //getModelList()
        } else {
            DLog("CurlActivity : ", "inside onActivityResult 2")
            //isNotComeFromBackPressed = false
            finish()
        }
    }

    private fun checkInternetInitially() {
        if (!dbHelper!!.isOriginalsDownload(albumCode!!)) {
            val alertDialog = AlertDialog.Builder(this, R.style.AlertDialogTheme).create()
            alertDialog.setTitle(this.resources.getString(R.string.you_are_offline))
            alertDialog.setMessage(this.resources.getString(R.string.check_connection))
            alertDialog.setCanceledOnTouchOutside(false)
            alertDialog.setButton(AlertDialog.BUTTON_POSITIVE, "Retry") { dialogInterface, i ->
                if (Network_check.isNetworkAvailable(this)) {
                    alertDialog.dismiss()
                    checkImages()
                } else {
                    checkInternetInitially()
                }
            }
            alertDialog.show()
            DLog("checkInternetInitially1 :", "${dbHelper!!.isOriginalsDownload(albumCode!!)}")
        } else {
            DLog("checkInternetInitially :", "${dbHelper!!.isOriginalsDownload(albumCode!!)}")
        }
    }

    private fun checkInternet() {
        val alertDialog = AlertDialog.Builder(this, R.style.AlertDialogTheme).create()
        alertDialog.setTitle(this.resources.getString(R.string.you_are_offline))
        alertDialog.setMessage(this.resources.getString(R.string.check_connection))
        alertDialog.setCanceledOnTouchOutside(false)
        alertDialog.setButton(AlertDialog.BUTTON_POSITIVE, "Retry") { dialogInterface, i ->
            if (Network_check.isNetworkAvailable(this)) {
                alertDialog.dismiss()
                //setCustomProgressBar()
                onStartContent()
            } else {
                checkInternet()
            }
        }
        alertDialog.show()
    }

    /*private fun getUnDownloadedUrls() {
        val cursor: Cursor? = dbHelper!!.getSingleAlbumOriginalPhotoUrl(albumId!!)
        if (Network_check.isNetworkAvailable(this)) {
            if (cursor != null && cursor.count > 0) {
                progress_textView.text = "0%"
                cursor.moveToFirst()
                DLog("DownloadImages in CL: ", "${cursor.getString(0)}")
                do {
                    DLog("CurlActivity: inside do while", "${cursor.getString(0)}")
                    val drUpdateTask = DownloadResultUpdateTask(this)
                    val downloadTask = DownloadTask(cursor.getString(0), 3, this, drUpdateTask)
                    DownloadManager.downloadManager?.runDownloadFile(downloadTask)
                } while (cursor.moveToNext())
            } else {
                DLog("DownloadImages :", "inside if else")
                if (albumOrientation == 1) {
                    setInvisibleProgressBarIfLandscape()
                } else {
                    setInvisibleProgressBar()
                }
            }
        } else {
            noInternetConnection()
            // CustomToast.alert(this,resources.getString(R.string.no_internet))
        }
    }*/

    private fun noInternetConnection() {
        //dismiss()
        if (!dbHelper!!.isOriginalsDownload(albumCode!!)) {
            val alertDialog = AlertDialog.Builder(this, R.style.AlertDialogTheme).create()
            alertDialog.setTitle(this.resources.getString(R.string.you_are_offline))
            alertDialog.setMessage(this.resources.getString(R.string.check_connection))
            alertDialog.setCanceledOnTouchOutside(false)
            alertDialog.setButton(AlertDialog.BUTTON_POSITIVE, "Retry") { dialogInterface, i ->
                if (Network_check.isNetworkAvailable(this)) {
                    alertDialog.dismiss()
                    downloadOriginalAlbumImages()
                    //getUndownloadedUrls()
                }
            }
            alertDialog.setButton(AlertDialog.BUTTON_NEGATIVE, "Cancel") { dialogInterface, i ->
                alertDialog.dismiss()
            }
            alertDialog.show()
        } else {

        }
    }

    /*fun visibleCurlView() {
        activity_curl_constraint.visibility = View.VISIBLE
        fab.visibility = View.VISIBLE
    }*/

    override fun setPercent(imageUrl: String, imageBitmap: Bitmap, imageType: Int) {

        val imageOriginalFile = StorageUtils.getFile(this, imageUrl)
        /*File(Environment.getDataDirectory(), getString(R.string.main_folder_name) + "/" + imageUrl)*/
        var originalBitmap: Bitmap? = null

        /* Display display = getWindowManager().getDefaultDisplay()
         int displayWidth = display.getWidth()
         BitmapFactory.Options options = new BitmapFactory.Options()
         options.inJustDecodeBounds = true
         BitmapFactory.decodeResource(getResources(), R.drawable.largeimage, options)
         int width = options.outWidth
                 if (width > displayWidth) {
                     int widthRatio = Math.round((float) width / (float) displayWidth)
                     options.inSampleSize = widthRatio
                 }
         options.inJustDecodeBounds = false
         Bitmap scaledBitmap =  BitmapFactory.decodeResource(getResources(),
         R.drawable.largeimage, options)
         largeImage.setImageBitmap(scaledBitmap)*/
        DLog("CurlActivity ::", "setPercent STEP 1")
        if (imageOriginalFile.exists()) {
            DLog("CurlActivity ::", "setPercent STEP 2")
            try {
                /*if (readBitmapInFo(imageOriginalFile) > megaBytesFree()) {
                    originalBitmap = subSampleImage(32, imageOriginalFile)
                } else {
                    //originalBitmap = BitmapFactory.decodeFile(imageOriginalFile.absolutePath)

                    val options = BitmapFactory.Options()
                    //options.inJustDecodeBounds = true
                    //options.inPreferredConfig = Bitmap.Config.RGB_565 //RGB_565 ARGB_8888
                    options.inSampleSize = 2

                    *//*val bitmap = BitmapFactory.decodeStream(imageOriginalFile.inputStream(), null, options)
                    //bitmapHashMap.put(imageName, getResizedBitmap(bitmap))
                    originalBitmap = getResizedBitmap(bitmap)*//*

                    //var tmp = BitmapFactory.decodeFile(imageOriginalFile.absolutePath)
                    var tmp = decodeFile(imageOriginalFile!!, this)
                    //bitmapHashMap.put(imageUrl, bmp)
                    imageCache1?.removeKey(imageUrl)
                    //imageCache1?.addBitmapToCache(imageUrl, Bitmap.createBitmap(tmp))
                    imageCache1?.addBitmapToCache(imageUrl, tmp)
                }*/
                val imageName = imageUrl.substring(0, imageUrl.lastIndexOf("."))
                val extension = imageUrl.substring(imageUrl.lastIndexOf("."), imageUrl.length)
                if (imageType == AlbumImageType.full) {
                    DLog("CurlActivity ::", "setPercent STEP 21 $imageName :: $extension")
                    val fileBitmap = BitmapFactory.decodeFile(imageOriginalFile.absolutePath)
                    /*val bm1 = Bitmap.createBitmap(
                        imageBitmap,
                        0,
                        0,
                        imageBitmap.width / 2,
                        imageBitmap.height
                    )
                    val bm2 = Bitmap.createBitmap(
                        imageBitmap,
                        imageBitmap.width / 2,
                        0,
                        imageBitmap.width / 2,
                        imageBitmap.height
                    )*/
                    val bm1 = Bitmap.createBitmap(
                        fileBitmap,
                        0,
                        0,
                        fileBitmap.width / 2,
                        fileBitmap.height
                    )
                    val bm2 = Bitmap.createBitmap(
                        fileBitmap,
                        fileBitmap.width / 2,
                        0,
                        fileBitmap.width / 2,
                        fileBitmap.height
                    )
                    imageCache1?.removeKey("$imageName-a$extension")
                    imageCache1?.removeKey("$imageName-b$extension")
                    imageCache1?.addBitmapToCache("$imageName-a$extension", bm1)
                    imageCache1?.addBitmapToCache("$imageName-b$extension", bm2)
                } else {
                    DLog("CurlActivity ::", "setPercent STEP 3")
                    if (imageDownloadStatusMap.entries.toList()[1].key == imageUrl) {
                        imageCache1?.removeKey("$imageName-b$extension")
                        imageCache1?.addBitmapToCache("$imageName-b$extension", imageBitmap)
                    } else {
                        imageCache1?.removeKey("$imageName-a$extension")
                        imageCache1?.addBitmapToCache("$imageName-a$extension", imageBitmap)
                    }
                }
                DLog("CurlActivity ::", "setPercent STEP 4")
                /*imageCache1?.removeKey(imageUrl)
                imageCache1?.addBitmapToCache(imageUrl, imageBitmap)*/

                //originalBitmap = BitmapFactory.decodeFile(imageOriginalFile.absolutePath)
            } catch (e: IllegalStateException) {
                DLog("CurlActivityLandscape ERROR :", e.message.toString())
            }
        } else {
            DLog("CurlActivity ::", "setPercent STEP 5")
            val imageThumbfile = StorageUtils.getThumbFile(this, imageUrl)
            /*File(Environment.getDataDirectory(), getString(R.string.main_folder_name) + "/thumb/" + imageUrl)*/
            if (readBitmapInFo(imageThumbfile) > megaBytesFree()) {
                originalBitmap = subSampleImage(32, imageThumbfile)
            } else {
                originalBitmap = BitmapFactory.decodeFile(imageThumbfile.absolutePath)
            }

            /* DLog("imageThumbfile","imageThumbfile")
             val display = getWindowManager().getDefaultDisplay()
             val displayWidth = (display.width).toDouble()
             val options = BitmapFactory.Options()
             options.inJustDecodeBounds = true
             *//*BitmapFactory.decodeResource(getResources(), R.drawable.largeimage, options)*//*
            BitmapFactory.decodeFile(imageThumbfile.absolutePath, options)
            val width = (options.outWidth)
            if (width > displayWidth) {
                val widthRatio = Math.round(width / displayWidth)
                options.inSampleSize = widthRatio.toInt()
            }
            options.inJustDecodeBounds = false;
            originalBitmap =   BitmapFactory.decodeFile(imageThumbfile.absolutePath, options)*/

            originalBitmap = BitmapFactory.decodeFile(imageThumbfile.absolutePath)
        }
        DLog("CurlActivity ::", "setPercent STEP 6")
        if (originalBitmap != null) {
            DLog("CurlActivity ::", "setPercent STEP 1")
            //bitmapHashMap.put(imageUrl, Bitmap.createBitmap(originalBitmap))
            imageCache1?.removeKey(imageUrl)
            imageCache1?.addBitmapToCache(imageUrl, tmp)
        }
        DLog("CurlActivity ::", "setPercent STEP 7")
        val cursor = dbHelper!!.totalOriginalImagesDownloaded(albumCode!!)
        totalUndownloadedImages = dbHelper!!.totalOriginalImagesUnDownloaded(albumCode!!)
        totalDownloadedImages = cursor
        if (totalDownloadedImages == 0) {
            totalDownloadedImages = 1
        }
        var percent: Int = 1
        try {
            percent = (totalDownloadedImages!! * 100) / totalUndownloadedImages!!
            DLog("CurlActivity ::", "setPercent STEP 71 $percent")
        } catch (e: ArithmeticException) {
            DLog("DownloadImagesFragment :", e.message.toString())
        }
        activityCurlLandscapeBinding.downloadTextView.setTextColor(Color.parseColor("#${MainActivity.progressBarColor}"))
        activityCurlLandscapeBinding.activityCurlSmallStudioLogoImageView.visibility =
            View.INVISIBLE
        activityCurlLandscapeBinding.progressBar.progress = percent
        //progressBar.progressTintList = ColorStateList.valueOf(Color.parseColor("#${MainActivity.progressBarColor}"))
        activityCurlLandscapeBinding.progressTextView.text = "$percent%"
        //progress_textView.setTextColor(Color.parseColor("#${MainActivity.progressBarColor}"))

        if (isActivityForeground) {
            if (percent >= 100) {
                DLog("CurlActivity ::", "setPercent STEP 8")
                //getMergedImageNameArrayList()
                activityCurlLandscapeBinding.activityCurlSmallStudioLogoImageView.visibility =
                    View.VISIBLE
                if (albumOrientation == 1) {
                    setInvisibleProgressBarIfLandscape()
                } else {
                    setInvisibleProgressBar()
                }
                if (mWakeLock!!.isHeld()) {
                    DLog("CurlActivityLandscape: ", "inside isOriginalsDownloadInSingleAlbum if 2")
                    mWakeLock!!.release()
                }
                Handler().postDelayed({
                    slideUp(activityCurlLandscapeBinding.imageviewSliderRecyclerView)
                }, 100)
                Handler().postDelayed({
                    openMenu()
                }, 500)


                /*val coverImage = dbHelper?.getCoverImageOfAlbum(albumId!!)
                if (coverImage != "") {
                    val imageFile = File(getExternalFilesDir(null)?.toString(), getString(R.string.main_folder_name) + "/" + coverImage)
                    imageCache1?.removeKey(coverImage)
                    imageCache1?.addBitmapToCache(coverImage, decodeFile(imageFile, this))
                }*/

                /*if(mWakeLock != null) {
                mWakeLock?.release()
            }*/
                //getMergedImageNameArrayList()
            } else {
                DLog("CurlActivity ::", "setPercent STEP 9")
                //slideDown(imageview_slider_recyclerView)
            }
        }
        //getUndownloadedUrls()
        /*val cursor1: Cursor? = dbHelper!!.getSingleAlbumOriginalPhotoUrl(albumId!!)
        DLog("CurlActivity:","inside setPercent 16")
        if (Network_check.isNetworkAvailable(this)) {
            DLog("CurlActivity:","inside setPercent 17")
            if (cursor1 != null && cursor1.count == 0) {
                DLog("CurlActivity:","inside setPercent 18")
                setInvisibleProgressBar()
                //getModelList()
            }
        } else {
            DLog("CurlActivity:","inside setPercent 19")
            noInternetConnection()
        }*/
    }

    /*fun setPercent() {
        val cursor = dbHelper!!.totalOriginalImagesDownloaded(albumId!!)
        totalUndownloadedImages = dbHelper!!.totalOriginalImagesUnDownloaded(albumId!!).count
        totalDownloadedImages = cursor.count
        if (totalDownloadedImages == 0) {
            totalDownloadedImages = 1
        }
        var percent: Int = 1
        try {
            percent = (totalDownloadedImages!! * 100) / totalUndownloadedImages!!
        } catch (e: ArithmeticException) {
            DLog("DownloadImagesFragment :", e.message.toString())
        }
        progressBar.setProgress(percent)
        progress_textView.text = "$percent%"
//        if(percent == 100){
//           setInvisibleProgressBar()
//        }
        getUnDownloadedUrls()
    }*/

    /* fun visibleFabLayout() {
         fab_layout.visibility = View.VISIBLE
         fabLayout4.visibility = View.VISIBLE
         fabLayout3.visibility = View.VISIBLE
         fabLayout5.visibility = View.VISIBLE
         fabLayout6.visibility = View.VISIBLE
         fabLayout7.visibility = View.VISIBLE
         back_arrow_fabLayout.visibility = View.VISIBLE
     }*/

    private fun setInvisibleProgressBarIfLandscape() {
        activityCurlLandscapeBinding.progressBarConstraint.visibility = View.GONE
        activityCurlLandscapeBinding.activityCurlStudioLogoImageView.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout4.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout3.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout5.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout6.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout7.visibility = View.VISIBLE
        //if (lastUpdatedAt == 0 || !Network_check.isNetworkAvailable(this)) {
        DLog("CurlActivity", "setInvisibleProgressBarIfLandscape IF")
        playMusic()
        /*} else {
            DLog("CurlActivity", "setInvisibleProgressBarIfLandscape IF ELSE ")
        }*/
        guideView1 =
            getIntPreference(this, SharedPreferenceConst.GUIDEVIEW_COMPLETED_ALBUM_LANDSCAPE)
        if (guideView1 == 0) {
            if (albumOrientation == 1) {
                getSequence1().show()
            }
            setIntPreference(this, SharedPreferenceConst.GUIDEVIEW_COMPLETED_ALBUM_LANDSCAPE, 1)
        }
    }

    private fun setInvisibleProgressBar() {
        DLog("CurlActivity ::", "setInvisibleProgressBar :: $musicCode")
        activityCurlLandscapeBinding.progressBarConstraint.visibility = View.GONE
        activityCurlLandscapeBinding.activityCurlStudioLogoImageView.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout.visibility = View.VISIBLE
        //if (!Network_check.isNetworkAvailable(this))
        playMusic()
    }

    override fun onBackPressed() {
        super.onBackPressed()
        //mWakeLock!!.release()
        /*if (mWakeLock != null) {
            DLog("CurlActivityLandscape: ", "inside isOriginalsDownloadInSingleAlbum if 2")

        }*/

        imageDecodeImage?.cancel(true)
        DLog("CurlActivity: ", "onBackPressed()")
        isActivityForeground = false
        onBackPressedValue = true
//        DLog("OnBackPressed", "On backpressed ${mPlayer!!.isPlaying}")
        if (mPlayer != null) {
            try {
                //  mPlayer!!.pause()
                mPlayer!!.release()
            } catch (e: java.lang.IllegalStateException) {

            }
        }
        CacheAsyncTask().execute(MESSAGE_CLEAR)
        /*val intent = Intent(mContext, ViewUserAlbumActivity::class.java)
        intent.putExtra("frag", "")
        startActivity(intent)
        finish()*/
    }

    fun visibleFabLayout() {
        activityCurlLandscapeBinding.fabLayout1.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout2.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout3.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout4.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout5.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout6.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout7.visibility = View.VISIBLE
        activityCurlLandscapeBinding.backArrowFabLayout.visibility = View.VISIBLE
    }

    private fun showFABMenuIfLandscape() {

        DLog("showFABMenuIfLandscape", "showFAb")
        activityCurlLandscapeBinding.activityCurlStudioLogoImageView.visibility = View.GONE
        activityCurlLandscapeBinding.activityCurlSmallStudioLogoImageView.visibility = View.GONE
        isFABOpen = true
        activityCurlLandscapeBinding.fabLayout1.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout2.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fab8.visibility = View.VISIBLE
        //fabLayout3.visibility = View.VISIBLE
        //fabLayout4.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout5.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout6.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout7.visibility = View.VISIBLE
        activityCurlLandscapeBinding.backArrowFabLayout.visibility = View.VISIBLE

        activityCurlLandscapeBinding.fab.animate().rotationBy(180f)
            .setListener(object : Animator.AnimatorListener {
                override fun onAnimationStart(animator: Animator) {}
                override fun onAnimationEnd(animator: Animator) {
                    if (activityCurlLandscapeBinding.fab.rotation != 180f) {

                        activityCurlLandscapeBinding.fab.rotation = 180f
                    }
                }

                override fun onAnimationCancel(animator: Animator) {}
                override fun onAnimationRepeat(animator: Animator) {}
            })

        activityCurlLandscapeBinding.backArrowFabLayout.animate()
            .translationX(resources.getDimension(R.dimen.standard_60))
        activityCurlLandscapeBinding.fabLayout1.animate()
            .translationX(resources.getDimension(R.dimen.standard_120))
        activityCurlLandscapeBinding.fabLayout2.animate()
            .translationX(resources.getDimension(R.dimen.standard_170))
        //fabLayout3.animate().translationX(resources.getDimension(R.dimen.standard_250))
        //fabLayout4.animate().translationX(resources.getDimension(R.dimen.standard_190))
        activityCurlLandscapeBinding.fabLayout5.animate()
            .translationX(resources.getDimension(R.dimen.standard_220))
        activityCurlLandscapeBinding.fabLayout7.animate()
            .translationX(resources.getDimension(R.dimen.standard_270))
        activityCurlLandscapeBinding.fabLayout6.animate()
            .translationX(resources.getDimension(R.dimen.standard_320))
        activityCurlLandscapeBinding.fab8.animate()
            .translationX(resources.getDimension(R.dimen.standard_350))
        /*********4.44pm************/
    }

    private fun closeFABMenuIfLandscape() {
        activityCurlLandscapeBinding.activityCurlStudioLogoImageView.visibility = View.VISIBLE
        activityCurlLandscapeBinding.activityCurlSmallStudioLogoImageView.visibility = View.GONE
        //isFABOpen = false
        //imageview_slider_recyclerView.visibility = View.INVISIBLE
        //slideDown(imageview_slider_recyclerView)
        activityCurlLandscapeBinding.fab.animate().rotationBy(-180f)
        activityCurlLandscapeBinding.backArrowFabLayout.animate().translationX(0f)
        activityCurlLandscapeBinding.fabLayout1.animate().translationX(0f)
        activityCurlLandscapeBinding.fabLayout2.animate().translationX(0f)
        activityCurlLandscapeBinding.fabLayout5.animate().translationX(0f)
        activityCurlLandscapeBinding.fabLayout7.animate().translationX(0f)
        activityCurlLandscapeBinding.fabLayout6.animate().translationX(0f)
        activityCurlLandscapeBinding.fab8.animate().translationX(0f)
            .setListener(object : Animator.AnimatorListener {
                override fun onAnimationStart(animator: Animator) {

                }

                override fun onAnimationEnd(animator: Animator) {
                    if (!isFABOpen) {
                        activityCurlLandscapeBinding.fabLayout1.visibility = View.GONE
                        activityCurlLandscapeBinding.fabLayout2.visibility = View.GONE
                        //fabLayout3.visibility = View.GONE
                        //fabLayout4.visibility = View.GONE
                        activityCurlLandscapeBinding.fabLayout5.visibility = View.GONE
                        activityCurlLandscapeBinding.fabLayout7.visibility = View.GONE
                        activityCurlLandscapeBinding.fabLayout6.visibility = View.GONE
                        activityCurlLandscapeBinding.fab8.visibility = View.GONE
                        activityCurlLandscapeBinding.backArrowFabLayout.visibility = View.GONE
                    }
                    if (activityCurlLandscapeBinding.fab.rotation != 180f) {
                        activityCurlLandscapeBinding.fab.rotation = 180f
                    }
                }

                override fun onAnimationCancel(animator: Animator) {

                }

                override fun onAnimationRepeat(animator: Animator) {
                }
            })
    }

    private fun showFABMenu() {
        activityCurlLandscapeBinding.activityCurlStudioLogoImageView.visibility = View.GONE
        activityCurlLandscapeBinding.activityCurlSmallStudioLogoImageView.visibility = View.GONE
        //isFABOpen = true
        //imageview_slider_recyclerView.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout1.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout2.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout3.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout4.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout5.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout6.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fabLayout7.visibility = View.VISIBLE
        activityCurlLandscapeBinding.backArrowFabLayout.visibility = View.VISIBLE
        activityCurlLandscapeBinding.fab.animate().rotationBy(180f)
            .setListener(object : Animator.AnimatorListener {
                override fun onAnimationStart(animator: Animator) {}
                override fun onAnimationEnd(animator: Animator) {
                    if (activityCurlLandscapeBinding.fab.rotation != 180f) {
                        activityCurlLandscapeBinding.fab.rotation = 180f
                    }
                }

                override fun onAnimationCancel(animator: Animator) {}
                override fun onAnimationRepeat(animator: Animator) {}
            })

        /*fabLayout1.animate().translationY(resources.getDimension(R.dimen.standard_40))
        fabLayout2.animate().translationY(resources.getDimension(R.dimen.standard_60))
        fabLayout3.animate().translationY(resources.getDimension(R.dimen.standard_100))
        fabLayout4.animate().translationY(resources.getDimension(R.dimen.standard_120))*/
        /* fabLayout5.animate().translationX(resources.getDimension(R.dimen.dimen5))
         fabLayout7.animate().translationX(resources.getDimension(R.dimen.dimen7))
         fabLayout6.animate().translationX(resources.getDimension(R.dimen.dimen6))*/

        if (albumOrientation == 2) {
            activityCurlPortraitBinding.fabLayout1.animate()
                .translationY(resources.getDimension(R.dimen.portrait_image_icon_y_axis))//image standard_70
            activityCurlPortraitBinding.fabLayout2.animate()
                .translationY(resources.getDimension(R.dimen.portrait_zoom_icon_y_axis))//zoom standard_130
            activityCurlPortraitBinding.fabLayout3.animate()
                .translationY(resources.getDimension(R.dimen.portrait_right_icon_y_axis))//right arrow standard_250
            activityCurlPortraitBinding.fabLayout4.animate()
                .translationY(resources.getDimension(R.dimen.portrait_left_icon_y_axis))//left arrow standard_190
            activityCurlPortraitBinding.fabLayout5.animate()
                .translationX(resources.getDimension(R.dimen.portrait_music_icon_x_axis))//music standard
            activityCurlPortraitBinding.fabLayout7.animate()
                .translationX(resources.getDimension(R.dimen.portrait_share_icon_x_axis))//share standard1
            activityCurlPortraitBinding.fabLayout7.animate()
            activityCurlPortraitBinding.fabLayout6.animate()
                .translationX(resources.getDimension(R.dimen.portrait_help_icon_x_axis))//help standard2
            activityCurlPortraitBinding.fabLayout7.animate()
            activityCurlPortraitBinding.backArrowFabLayout.animate()
                .translationX(resources.getDimension(R.dimen.portrait_back_arrow_icon_x_axis))//back arrow
        } else {
            activityCurlLandscapeBinding.fabLayout1.animate()
                .translationY(resources.getDimension(R.dimen.square_image_icon_y_axis))//image standard_70
            activityCurlLandscapeBinding.fabLayout2.animate()
                .translationY(resources.getDimension(R.dimen.square_zoom_icon_y_axis))//zoom standard_130
            activityCurlLandscapeBinding.fabLayout3.animate()
                .translationY(resources.getDimension(R.dimen.square_right_icon_y_axis))//right arrow standard_250
            activityCurlLandscapeBinding.fabLayout4.animate()
                .translationY(resources.getDimension(R.dimen.square_left_icon_y_axis))//left arrow standard_190
            activityCurlLandscapeBinding.fabLayout5.animate()
                .translationX(resources.getDimension(R.dimen.square_music_icon_x_axis))//music standard
            activityCurlLandscapeBinding.fabLayout7.animate()
                .translationX(resources.getDimension(R.dimen.square_share_icon_x_axis))//share standard1
            activityCurlLandscapeBinding.fabLayout6.animate()
                .translationX(resources.getDimension(R.dimen.square_help_icon_x_axis))//help standard2
            activityCurlLandscapeBinding.backArrowFabLayout.animate()
                .translationX(resources.getDimension(R.dimen.square_back_arrow_icon_x_axis))//back arrow
        }

    }

    private fun closeFABMenu() {
        activityCurlLandscapeBinding.activityCurlStudioLogoImageView.visibility = View.VISIBLE
        activityCurlLandscapeBinding.activityCurlSmallStudioLogoImageView.visibility = View.GONE
        //isFABOpen = false
        //imageview_slider_recyclerView.visibility = View.INVISIBLE
        slideDown(activityCurlLandscapeBinding.imageviewSliderRecyclerView)
        activityCurlLandscapeBinding.fab.animate().rotationBy(-180f)
        activityCurlLandscapeBinding.backArrowFabLayout.animate().translationX(0f)
        activityCurlLandscapeBinding.fabLayout1.animate().translationY(0f)
        activityCurlLandscapeBinding.fabLayout2.animate().translationY(0f)
        activityCurlLandscapeBinding.fabLayout3.animate().translationY(0f)
        activityCurlLandscapeBinding.fabLayout4.animate()
            .translationY(0f)/*.setListener(object : Animator.AnimatorListener {*/
        activityCurlLandscapeBinding.fabLayout5.animate().translationX(0f)
        activityCurlLandscapeBinding.fabLayout7.animate().translationX(0f)
        activityCurlLandscapeBinding.fabLayout6.animate().translationX(0f)
            .setListener(object : Animator.AnimatorListener {
                override fun onAnimationStart(animator: Animator) {
                }

                override fun onAnimationEnd(animator: Animator) {
                    if (!isFABOpen) {
                        activityCurlLandscapeBinding.fabLayout1.visibility = View.GONE
                        activityCurlLandscapeBinding.fabLayout2.visibility = View.GONE
                        activityCurlLandscapeBinding.fabLayout3.visibility = View.GONE
                        activityCurlLandscapeBinding.fabLayout4.visibility = View.GONE
                        activityCurlLandscapeBinding.fabLayout5.visibility = View.GONE
                        activityCurlLandscapeBinding.fabLayout7.visibility = View.GONE
                        activityCurlLandscapeBinding.fabLayout6.visibility = View.GONE
                        activityCurlLandscapeBinding.backArrowFabLayout.visibility = View.GONE
                    }
                    if (activityCurlLandscapeBinding.fab.rotation != -180f) {
                        activityCurlLandscapeBinding.fab.rotation = -180f
                    }
                }

                override fun onAnimationCancel(animator: Animator) {
                }

                override fun onAnimationRepeat(animator: Animator) {
                }
            })
    }

    override fun onDestroy() {
        super.onDestroy()

        apiCall?.disposeApiCall()
        apiCallForJson?.disposeApiCallForJson()

        mPlayer?.release()
        //cache?.clearCache()
        CacheAsyncTask().execute(MESSAGE_CLOSE)

    }

    @SuppressLint("Range")
    private fun playMusic1() {
        DLog("CurlActivity: ", "playMusic() step 1 $music :: $musicCode")
        try {
            if (mPlayer == null) {
                mPlayer = MediaPlayer()
                mPlayer!!.isLooping = true
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                //DLog("CurlActivity: ", "playMusic() step 1")
                val audioAttrib = AudioAttributes.Builder()
                    .setLegacyStreamType(AudioManager.STREAM_MUSIC)
                    .setUsage(AudioAttributes.USAGE_MEDIA)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .build()
                //mSound = new SoundPool.Builder().setAudioAttributes(audioAttrib).setMaxStreams(6).build();
                //DLog("CurlActivity: ", "playMusic() step 2")
                mPlayer?.setAudioAttributes(audioAttrib)
                //DLog("CurlActivity: ", "playMusic() step 3")
            } else {
                //DLog("CurlActivity: ", "playMusic() step 4")
                mPlayer?.setAudioStreamType(AudioManager.STREAM_MUSIC)
            }

            DLog("isMusicStopped", "$isMusicStopped")

            /*if (music != "") {
                val musicFilePath = getExternalFilesDir(null)?.absolutePath + "/${resources.getString(R.string.main_folder_name)}/$music"
                val musicFile = File(musicFilePath)
                if (musicFile.exists()) {
                    playFromLocale(musicFilePath)
                } else {
                    if (Network_check.isNetworkAvailable(this) && isAvailableExternalMemorySize(this, (1 * 1024 * 1024))) {
                        DownloadAlbumMusic(this).execute()
                    } else {
                        DLog("CurlActivity: ", "playMusic() step 5")
                        playFromAsset()
                    }
                }
            } else {
                DLog("CurlActivity: ", "playMusic() step 6")
                playFromAsset()
            }*/

            musicCode = dbHelper?.getAlbumMusicId(albumCode!!)
            if (musicCode != "") {
                val musicCursor = dbHelper?.getAlbumMusic(albumCode!!)
                DLog(
                    "CurlActivity: ",
                    "playMusic() step 0 :: ${DatabaseUtils.dumpCursorToString(musicCursor)}"
                )
                if (musicCursor!!.count > 0 && musicCursor.moveToFirst()) {
                    DLog("CurlActivity: ", "playMusic() step 1")
                    if (musicCursor.getInt(musicCursor.getColumnIndex(DBStatics.OPjvtFileDownloaded)) == 0) {
                        DLog("CurlActivity: ", "playMusic() step 2")
                        if (musicCursor.getInt(musicCursor.getColumnIndex(DBStatics.OPjvtFileMode)) == 1) {
                            DLog("CurlActivity: ", "playMusic() step 3")
                            if (Network_check.isNetworkAvailable(this) && isAvailableExternalMemorySize(
                                    this,
                                    musicCursor.getInt(musicCursor.getColumnIndex(DBStatics.OPjvtFileSize))
                                        .toLong()
                                )
                            ) {
                                DLog("CurlActivity: ", "playMusic() step 4")
                                DownloadAlbumMusic(
                                    this,
                                    musicCursor.getInt(musicCursor.getColumnIndex(DBStatics.OPjvtFileCode)),
                                    musicCursor.getString(musicCursor.getColumnIndex(DBStatics.OPjvtFileName)),
                                    musicCursor.getString(musicCursor.getColumnIndex(DBStatics.ALBUM_MUSIC_URL))
                                ).execute()
                            } else {
                                DLog("CurlActivity: ", "playMusic() step 5")
                                playFromAsset()
                            }
                            DLog("CurlActivity: ", "playMusic() step 6")
                        } else {
                            DLog("CurlActivity: ", "playMusic() step 7")
                            music =
                                musicCursor.getString(musicCursor.getColumnIndex(DBStatics.OPjvtFileName))
                            callApiForGetTemporaryUrlAlbumMusic(
                                musicCursor.getInt(
                                    musicCursor.getColumnIndex(
                                        DBStatics.OPjvtFileCode
                                    )
                                )
                            )
                        }
                    } else {
                        DLog("CurlActivity: ", "playMusic() step 8")
                        /*val musicFilePath =
                            getExternalFilesDir(null)?.absolutePath + "/${resources.getString(R.string.main_folder_name)}/${
                                musicCursor.getString(musicCursor.getColumnIndex(DBStatics.ALBUM_MUSIC_NAME))
                            }"*/
                        val musicFilePath = StorageUtils.getFile(
                            this,
                            musicCursor.getString(musicCursor.getColumnIndex(DBStatics.OPjvtFileName))
                        ).absolutePath
                        val musicFile = File(musicFilePath)
                        if (musicFile.exists()) {
                            playFromLocale(musicFilePath)
                        }
                    }
                }
            }
        } catch (e: IllegalStateException) {
        } catch (e: java.lang.Exception) {
        }
    }

    @SuppressLint("Range")
    private fun playMusic() {
        DLog("CurlActivity: ", "playMusic() step 1 $music :: $musicCode ")
        try {
            if (mPlayer == null) {
                mPlayer = MediaPlayer()
                mPlayer!!.isLooping = true
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                //DLog("CurlActivity: ", "playMusic() step 1")
                val audioAttrib = AudioAttributes.Builder()
                    .setLegacyStreamType(AudioManager.STREAM_MUSIC)
                    .setUsage(AudioAttributes.USAGE_MEDIA)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .build()
                //mSound = new SoundPool.Builder().setAudioAttributes(audioAttrib).setMaxStreams(6).build();
                //DLog("CurlActivity: ", "playMusic() step 2")
                mPlayer?.setAudioAttributes(audioAttrib)
                //DLog("CurlActivity: ", "playMusic() step 3")
            } else {
                //DLog("CurlActivity: ", "playMusic() step 4")
                mPlayer?.setAudioStreamType(AudioManager.STREAM_MUSIC)
            }

            DLog("isMusicStopped", "$isMusicStopped")

            /*if (music != "") {
                val musicFilePath = getExternalFilesDir(null)?.absolutePath + "/${resources.getString(R.string.main_folder_name)}/$music"
                val musicFile = File(musicFilePath)
                if (musicFile.exists()) {
                    playFromLocale(musicFilePath)
                } else {
                    if (Network_check.isNetworkAvailable(this) && isAvailableExternalMemorySize(this, (1 * 1024 * 1024))) {
                        DownloadAlbumMusic(this).execute()
                    } else {
                        DLog("CurlActivity: ", "playMusic() step 5")
                        playFromAsset()
                    }
                }
            } else {
                DLog("CurlActivity: ", "playMusic() step 6")
                playFromAsset()
            }*/

            if (musicCode != "") {
                //val musicCursor = dbHelper?.getAlbumMusic(albumCode!!)
                DLog(
                    "CurlActivity: ",
                    "playMusic() step 0 :: $musicCode"
                )

                DLog("CurlActivity: ", "playMusic() step 1")

                if (!StorageUtils.getFile(this, musicCode!! + ".mp3").exists()) {
                    DLog("CurlActivity: ", "playMusic() step 2")
                    if (Network_check.isNetworkAvailable(this)) {
                        DownloadAlbumMusic(
                            this,
                            0,
                            musicCode!!,
                            ""
                        ).execute()
                    }
                    DLog("CurlActivity: ", "playMusic() step 6")
                } else {
                    DLog("CurlActivity: ", "playMusic() step 8")
                    /*val musicFilePath =
                        getExternalFilesDir(null)?.absolutePath + "/${resources.getString(R.string.main_folder_name)}/${
                            musicCursor.getString(musicCursor.getColumnIndex(DBStatics.ALBUM_MUSIC_NAME))
                        }"*/
                    val musicFilePath = StorageUtils.getFile(
                        this,
                        musicCode!! + ".mp3"
                    ).absolutePath
                    val musicFile = File(musicFilePath)
                    if (musicFile.exists()) {
                        playFromLocale(musicFilePath)
                    }
                }
            }
        } catch (e: IllegalStateException) {
        } catch (e: java.lang.Exception) {
        }
    }

    fun playFromLocale(musicFilePath: String) {
        try {
            DLog("CurlActivity: ", "playFromLocale step 1")
            if (!mPlayer!!.isPlaying) {
                val musicFile = FileInputStream(File(musicFilePath))
                mPlayer?.setDataSource(musicFile.fd)
                mPlayer?.prepare()
                mPlayer?.isLooping = true

                if (!isMusicStopped) {
                    mPlayer?.start()
                }
                mPlayer?.setOnCompletionListener {
                    //mPlayer?.release()
                    //playMusic()
                    //fab5.setImageResource(R.drawable.ic_music_stop_note_black_24dp)
                    //i = 2
                }
                mPlayer?.setOnPreparedListener {
                    if (!isMusicStopped) {
                        mPlayer?.start()
                    }
                }
            }
        } catch (e: IllegalStateException) {
            DLog("CurlActivity: ", "playFromLocale step 5 IllegalStateException")
        } catch (e: IOException) {
            DLog("CurlActivity: ", "playFromLocale step 5 IOException")
            playFromAsset()
        }
    }

    fun playFromAsset() {
        afd = assets.openFd("default_music.mp3")
        mPlayer?.setDataSource(afd!!.fileDescriptor, afd!!.startOffset, afd!!.length)
        mPlayer?.prepare()
        if (!isMusicStopped) {
            mPlayer?.start()
        }

        mPlayer?.setOnPreparedListener {
            if (!isMusicStopped) {
                mPlayer?.start()
            }
        }
        mPlayer?.setOnCompletionListener {
            //fab5.setImageResource(R.drawable.ic_music_stop_note_black_24dp)
            //i = 2
        }
    }

    private fun callApiForGetTemporaryUrlAlbumMusic(musicId: Int) {
        val jsonObject = JsonObject()
        val fileJsonArray = JsonArray()
        val idJsonObject = JsonObject()
        idJsonObject.addProperty("id", musicId)
        fileJsonArray.add(idJsonObject)
        jsonObject.add("file", fileJsonArray)
        apiCallForJson?.APIRequestForJson(
            ApiUrls.JVT_FILE_URL,
            jsonObject,
            JvtFilesTemporaryUrl::class.java,
            this,
            3,
            false
        )
    }

    /*fun playMusic1() {

        if (Network_check.isNetworkAvailable(this)) {
            DLog("mPlayer", "${mPlayer}")
            if (mPlayer == null) {
                mPlayer = MediaPlayer()
            }
            DLog("mPlayer11", "${mPlayer}")
            if (mPlayer != null) {
                try {
                    DLog("mPlayer112", "${mPlayer}")
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        DLog("mPlayer1121", "${mPlayer}")
                        val audioAttrib = AudioAttributes.Builder()
                                .setLegacyStreamType(AudioManager.STREAM_MUSIC)
                                .setUsage(AudioAttributes.USAGE_MEDIA)
                                .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                                .build()
                        //mSound = new SoundPool.Builder().setAudioAttributes(audioAttrib).setMaxStreams(6).build();
                        DLog("mPlayer1121i", "${mPlayer}")
                        mPlayer?.setAudioAttributes(audioAttrib)
                        DLog("mPlayer1121i", "${mPlayer}")
                    } else {
                        DLog("mPlayer1122", "${mPlayer}")
                        mPlayer?.setAudioStreamType(AudioManager.STREAM_MUSIC)
                    }

                    if (music != "") {
                        DLog("Music if condition", "${AppConst.STORAGE_URL + music}")
                        //mPlayer?.setDataSource(CommonConst.AUDIO_URL + music)
                        var url = "${AppConst.STORAGE_URL}${dbHelper?.getStudioId(eventId!!)}/${albumId}/audio/$music"
                        DLog("CurlActivity: ", "music url : $url")
                        mPlayer?.setDataSource(url)
                        mPlayer?.prepare()
                        mPlayer?.start()
                        mPlayer?.setOnCompletionListener {
                            //April 30
                            //mPlayer?.release()
                            //playMusic()
                            fab5.setImageResource(R.drawable.ic_music_stop_note_black_24dp)
                            i = 2
                        }
                        mPlayer?.setOnPreparedListener {
                            mPlayer?.start()
                        }
                    } else {
                        DLog("Else condition", "default_music.mp3")
                        afd = getAssets().openFd("default_music.mp3")
                        mPlayer?.setDataSource(afd!!.getFileDescriptor(), afd!!.getStartOffset(), afd!!.getLength())
                        mPlayer?.prepare()
                        mPlayer?.start()

                        mPlayer?.setOnPreparedListener {
                            mPlayer?.start()
                        }

                        mPlayer?.setOnCompletionListener {

                            fab5.setImageResource(R.drawable.ic_music_stop_note_black_24dp)
                            i = 2
                        }
                    }
                } catch (e: IllegalStateException) {
                }
            }
        } else {
            // no internet
        }

    }*/


    /*fun playMusic() {

        DLog("mPlayer", "${mPlayer}")
        if (mPlayer == null) {
            mPlayer = MediaPlayer()
        }
        DLog("mPlayer11", "${mPlayer}")
        if (mPlayer != null) {
            try {
                DLog("mPlayer112", "${mPlayer}")
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    DLog("mPlayer1121", "${mPlayer}")
                    val audioAttrib = AudioAttributes.Builder()
                            .setLegacyStreamType(AudioManager.STREAM_MUSIC)
                            .setUsage(AudioAttributes.USAGE_MEDIA)
                            .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                            .build()
                    //mSound = new SoundPool.Builder().setAudioAttributes(audioAttrib).setMaxStreams(6).build();
                    DLog("mPlayer1121i", "${mPlayer}")
                    mPlayer?.setAudioAttributes(audioAttrib)
                    DLog("mPlayer1121i", "${mPlayer}")
                } else {
                    DLog("mPlayer1122", "${mPlayer}")
                    mPlayer?.setAudioStreamType(AudioManager.STREAM_MUSIC)
                }

                if (music != "") {
                    DLog("Music if condition", "${AppConst.STORAGE_URL + music}")
                    //mPlayer?.setDataSource(CommonConst.AUDIO_URL + music)
                    var url = "${AppConst.STORAGE_URL}${dbHelper?.getStudioId(eventId!!)}/${albumId}/audio/$music"
                    DLog("CurlActivity: ", "music url : $url")
                    mPlayer?.setDataSource(url)
                    mPlayer?.prepare()
                    mPlayer?.start()
                    mPlayer?.setOnCompletionListener {
                        //April 30
                        //mPlayer?.release()
                        //playMusic()
                        fab5.setImageResource(R.drawable.ic_music_stop_note_black_24dp)
                        i = 2
                    }
                    mPlayer?.setOnPreparedListener {
                        mPlayer?.start()
                    }
                    *//*DLog("Else condition", "default_music.mp3")
                    afd = getAssets().openFd("default_music.mp3")
                    mPlayer?.setDataSource(afd!!.getFileDescriptor(), afd!!.getStartOffset(), afd!!.getLength())
                    mPlayer?.prepare()
                    mPlayer?.start()

                    mPlayer?.setOnPreparedListener {
                        mPlayer?.start()
                    }

                    mPlayer?.setOnCompletionListener {

                        //April 30
                        //playMusic()
                        //mPlayer?.release()
                        fab5.setImageResource(R.drawable.ic_music_stop_note_black_24dp)
                        i = 2
                    }*//*
                } else {
                    DLog("Else condition", "default_music.mp3")
                    afd = getAssets().openFd("default_music.mp3")
                    mPlayer?.setDataSource(afd!!.getFileDescriptor(), afd!!.getStartOffset(), afd!!.getLength())
                    mPlayer?.prepare()
                    mPlayer?.start()

                    mPlayer?.setOnPreparedListener {
                        mPlayer?.start()
                    }

                    mPlayer?.setOnCompletionListener {

                        //April 30
                        //playMusic()
                        //mPlayer?.release()
                        fab5.setImageResource(R.drawable.ic_music_stop_note_black_24dp)
                        i = 2
                    }
                }
            } catch (e: IllegalStateException) {
            }
        }
        //Glide.with(this).load(R.drawable.animated_audio_play1).into(gifImageView)
    }*/

    fun setGifImage() {
        /* gifImageView= findViewById<GifImageView>(R.id.gifImageView)
         gifImageView?.setGifImageResource(R.drawable.animated_audio_play)*/
    }

    fun startServiceForUpdateAlbum() {
        /*var intent = Intent(this, UpdateEvents::class.java)
        intent.putExtra("albumId", albumId!!)
        intent.putExtra("albumType", albumType!!)
        intent.putExtra("lastUpdatedAt", lastUpdatedAt!!)
        startService(intent)*/ //28-05-2019
    }

    /*fun getCurlActivityData() {
        val cursor = dbHelper!!.getCurlActivityInfo(albumId!!)
        DLog("CurlActivity 11: ", "${DatabaseUtils.dumpCursorToString(cursor)}")
        if (cursor.count > 0 && cursor.moveToFirst()) {
            do {
                albumId = cursor.getInt(cursor.getColumnIndex(DBStatics.ALBUM_ID))
                albumName = cursor.getString(cursor.getColumnIndex(DBStatics.ALBUMS_ALBUM_NAME))
                albumType = cursor.getInt(cursor.getColumnIndex(DBStatics.ALBUMS_ALBUM_TYPE))
                lastUpdatedAt = cursor.getInt(cursor.getColumnIndex(DBStatics.ALBUMS_UPDATED_AT))
                //music = cursor.getString(cursor.getColumnIndex(DBStatics.ALBUMS_MUSIC))
                orientation = cursor.getString(cursor.getColumnIndex(DBStatics.ALBUMS_ALBUM_ORIENTATION_TYPE))
                albumSize = cursor.getString(cursor.getColumnIndex(DBStatics.ALBUMS_ALBUM_IMAGE_SIZE))
                eventsRandomId = cursor.getString(cursor.getColumnIndex(DBStatics.EVENTS_RANDOM_ID))
                eventsPasscode = cursor.getInt(cursor.getColumnIndex(DBStatics.EVENTS_PASSCODE))
                eventsUrl = cursor.getString(cursor.getColumnIndex(DBStatics.EVENTS_URL))
                eventsType = cursor.getInt(cursor.getColumnIndex(DBStatics.EVENTS_TYPE))
                eventId = cursor.getInt(cursor.getColumnIndex(DBStatics.EVENTS_ID))
            } while (cursor.moveToNext())
        }
        DLog("CurlActivity 11: ", "$albumId  $albumName $lastUpdatedAt $eventId ")
    }*/

    private fun saveWidthAndHeightInPreference() {
        //setIntPreference(this, SharedPreferenceConst.WIDTH_IN_CURLVIEW, curl_view.width)
        //setIntPreference(this, SharedPreferenceConst.HEIGHT_IN_CURLVIEW, curl_view.height)
    }

    /*fun shareAlbum(albumUrl: String, passcode: String) {
        val isReadyForShareAlbum = dbHelper!!.isReadyForShareAlbum(albumUrl)
        val isUserLogin = SharedPreferenceHelper.getBooleanPreference(mContext!!, SharedPreferenceConst.IS_USER_LOGIN, false)
        if (isUserLogin) {
            val name = SharedPreferenceHelper.getStringPreference(mContext!!, SharedPreferenceConst.USER_NAME, "")
            ShareCompat.IntentBuilder.from(this)
                    .setType("text/plain")
                    .setChooserTitle("Share with")
                    .setText(name + " " + getString(R.string.share_album_content_if_login_1) + " ${AppConst.SHARE_ALBUM_LINK}$albumUrl/$passcode")
                    .startChooser()
        } else if (isReadyForShareAlbum) {
            val name = SharedPreferenceHelper.getStringPreference(mContext!!, SharedPreferenceConst.USER_NAME, "")
            ShareCompat.IntentBuilder.from(this)
                    .setType("text/plain")
                    .setChooserTitle("Share with")
                    .setText(name + " " + getString(R.string.share_album_content_if_not_login_1) + " ${AppConst.SHARE_ALBUM_LINK}$albumUrl/$passcode")
                    .startChooser()
        } else {
            CustomToast.showLongToast(this, getString(R.string.kindly_login_to_share_album))
            val loginIntent = Intent(this, UserLoginActivity::class.java)
            startActivity(loginIntent)
        }
    }*/

    private fun showImageViewSliderLandscapeView(): BubbleShowCaseBuilder {
        return BubbleShowCaseBuilder(this)
            .title(getString(R.string.show_image_view_slider_title))
            .description(getString(R.string.show_image_view_slider_description))
            .backgroundColor(
                AppColors.getColor(
                    this,
                    //AppColorConstants.albumViewGuideCardBackgroundColor
                    "#${MainActivity.iconBackgroundColor}"
                )
            )
            .image(ContextCompat.getDrawable(this, R.drawable.ic_photo_library)!!)
            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
            .textColor(
                AppColors.getColor(
                    this,
                    //AppColorConstants.albumViewGuideCardTextColor
                    "#${MainActivity.iconColor}"
                )
            )
            .targetView(activityCurlLandscapeBinding.fab1)
            .listener(object : BubbleShowCaseListener { //Listener for user actions
                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the target
                }

                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the close button
                }

                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the bubble
                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
                }

                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the background dim
                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
                }
            })
    }

    private fun showImageViewSlider(position: BubbleShowCase.ArrowPosition): BubbleShowCaseBuilder {
        return BubbleShowCaseBuilder(this)
            .title(getString(R.string.show_image_view_slider_title))
            .description(getString(R.string.show_image_view_slider_description))
            .arrowPosition(position)
            .backgroundColor(
                AppColors.getColor(
                    this,
                    //AppColorConstants.albumViewGuideCardBackgroundColor
                    "#${MainActivity.iconBackgroundColor}"
                )
            )
            .image(ContextCompat.getDrawable(this, R.drawable.ic_photo_library)!!)
            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
            .textColor(
                AppColors.getColor(
                    this,
                    //AppColorConstants.albumViewGuideCardTextColor
                    "#${MainActivity.iconColor}"
                )
            )
            .targetView(activityCurlLandscapeBinding.fab1)
            .listener(object : BubbleShowCaseListener { //Listener for user actions
                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the target
                }

                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the close button
                }

                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the bubble
                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
                }

                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the background dim
                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
                }
            })
    }

    private fun zoomImageViewLandscapeView(): BubbleShowCaseBuilder {
        return BubbleShowCaseBuilder(this)
            .title(getString(R.string.zoom_image_view_title))
            .description(getString(R.string.zoom_image_view_description))
            .backgroundColor(
                AppColors.getColor(
                    this,
                    //AppColorConstants.albumViewGuideCardBackgroundColor
                    "#${MainActivity.iconBackgroundColor}"
                )
            )
            .image(ContextCompat.getDrawable(this, R.drawable.ic_zoom)!!)
            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
            .textColor(
                AppColors.getColor(
                    this,
                    //AppColorConstants.albumViewGuideCardTextColor
                    "#${MainActivity.iconColor}"
                )
            )
            .targetView(activityCurlLandscapeBinding.fab2)
            .listener(object : BubbleShowCaseListener { //Listener for user actions
                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the target
                }

                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the close button
                }

                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the bubble
                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
                }

                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the background dim
                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
                }
            })
    }

    private fun zoomImageView(position: BubbleShowCase.ArrowPosition): BubbleShowCaseBuilder {
        return BubbleShowCaseBuilder(this)
            .title(getString(R.string.zoom_image_view_title))
            .description(getString(R.string.zoom_image_view_description))
            .arrowPosition(position)
            .backgroundColor(
                AppColors.getColor(
                    this,
                    //AppColorConstants.albumViewGuideCardBackgroundColor
                    "#${MainActivity.iconBackgroundColor}"
                )
            )
            .image(ContextCompat.getDrawable(this, R.drawable.ic_zoom)!!)
            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
            .textColor(
                AppColors.getColor(
                    this,
                    //AppColorConstants.albumViewGuideCardTextColor
                    "#${MainActivity.iconColor}"
                )
            )
            .targetView(activityCurlLandscapeBinding.fab2)
            .listener(object : BubbleShowCaseListener { //Listener for user actions
                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the target
                }

                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the close button
                }

                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the bubble
                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
                }

                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the background dim
                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
                }
            })
    }

    private fun moveLeftAlbumViewPage(position: BubbleShowCase.ArrowPosition): BubbleShowCaseBuilder {
        return BubbleShowCaseBuilder(this)
            .title(getString(R.string.move_left_album_view_page_title))
            .description(getString(R.string.move_left_album_view_page_description))
            .arrowPosition(position)
            .backgroundColor(
                AppColors.getColor(
                    this,
                    //AppColorConstants.albumViewGuideCardBackgroundColor
                    "#${MainActivity.iconBackgroundColor}"
                )
            )
            .image(ContextCompat.getDrawable(this, R.drawable.ic_chevron_left_arrow)!!)
            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
            .textColor(
                AppColors.getColor(
                    this,
                    //AppColorConstants.albumViewGuideCardTextColor
                    "#${MainActivity.iconColor}"
                )
            )
            .targetView(activityCurlLandscapeBinding.fab4)
            .listener(object : BubbleShowCaseListener { //Listener for user actions
                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the target
                }

                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the close button
                }

                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the bubble
                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
                }

                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the background dim
                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
                }
            })
    }

    private fun moveRightAlbumViewPage(position: BubbleShowCase.ArrowPosition): BubbleShowCaseBuilder {
        return BubbleShowCaseBuilder(this)
            .title(getString(R.string.move_right_album_view_page_title))
            .description(getString(R.string.move_right_album_view_page_description))
            .arrowPosition(position)
            .backgroundColor(
                AppColors.getColor(
                    this,
                    //AppColorConstants.albumViewGuideCardBackgroundColor
                    "#${MainActivity.iconBackgroundColor}"
                )
            )
            .image(ContextCompat.getDrawable(this, R.drawable.ic_launcher_right_arrow)!!)
            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
            .textColor(
                AppColors.getColor(
                    this,
                    //AppColorConstants.albumViewGuideCardTextColor
                    "#${MainActivity.iconColor}"
                )
            )
            .targetView(activityCurlLandscapeBinding.fab3)
            .listener(object : BubbleShowCaseListener { //Listener for user actions
                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the target
                }

                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the close button
                }

                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the bubble
                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
                }

                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the background dim
                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
                }
            })
    }

    private fun listenMusicLandcapeView(): BubbleShowCaseBuilder {
        return BubbleShowCaseBuilder(this)
            .title(getString(R.string.listen_music_title))
            .description(getString(R.string.listen_music_description))
            .backgroundColor(
                AppColors.getColor(
                    this,
                    //AppColorConstants.albumViewGuideCardBackgroundColor
                    "#${MainActivity.iconBackgroundColor}"
                )
            )
            .image(ContextCompat.getDrawable(this, R.drawable.ic_music_note_black_24dp)!!)
            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
            .textColor(
                AppColors.getColor(
                    this,
                    //AppColorConstants.albumViewGuideCardTextColor
                    "#${MainActivity.iconColor}"
                )
            )
            .targetView(activityCurlLandscapeBinding.fab5)
            .listener(object : BubbleShowCaseListener { //Listener for user actions
                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the target
                }

                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the close button
                }

                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the bubble
                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
                }

                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the background dim
                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
                }
            })
    }

    private fun listenMusic(position: BubbleShowCase.ArrowPosition): BubbleShowCaseBuilder {
        return BubbleShowCaseBuilder(this)
            .title(getString(R.string.listen_music_title))
            .description(getString(R.string.listen_music_description))
            .arrowPosition(position)
            .backgroundColor(ContextCompat.getColor(this, R.color.curl_guideView_color))
            .image(ContextCompat.getDrawable(this, R.drawable.ic_music_note_black_24dp)!!)
            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
            .textColor(ContextCompat.getColor(this, R.color.curl_guideView_text_color))
            .targetView(activityCurlLandscapeBinding.fab5)
            .listener(object : BubbleShowCaseListener { //Listener for user actions
                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the target
                }

                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the close button
                }

                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the bubble
                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
                }

                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the background dim
                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
                }
            })
    }

    fun bubbleShowbackPressLandscapeView(): BubbleShowCaseBuilder {
        return BubbleShowCaseBuilder(this).title(getString(R.string.back_press_title))
            .backgroundColor(
                AppColors.getColor(
                    this,
                    //AppColorConstants.albumViewGuideCardBackgroundColor
                    "#${MainActivity.iconBackgroundColor}"
                )
            )
            .image(ContextCompat.getDrawable(this, R.drawable.ic_back_arrow)!!)
            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
            .textColor(
                AppColors.getColor(
                    this,
                    //AppColorConstants.albumViewGuideCardTextColor
                    "#${MainActivity.iconColor}"
                )
            )
            .targetView(activityCurlLandscapeBinding.backArrowFab)
            .listener(object : BubbleShowCaseListener { //Listener for user actions
                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the target
                }

                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the close button
                }

                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the bubble
                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
                }

                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the background dim
                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
                }
            })
    }

    private fun shareEventLandscapeView(): BubbleShowCaseBuilder {
        return BubbleShowCaseBuilder(this)
            .title(getString(R.string.share_event_title))
            .description(getString(R.string.share_event_description))
            .backgroundColor(
                AppColors.getColor(
                    this,
                    //AppColorConstants.albumViewGuideCardBackgroundColor
                    "#${MainActivity.iconBackgroundColor}"
                )
            )
            .image(ContextCompat.getDrawable(this, R.drawable.ic_share_black_24dp)!!)
            .closeActionImage(ContextCompat.getDrawable(this, R.drawable.ic_failure)!!)
            .textColor(
                AppColors.getColor(
                    this,
                    //AppColorConstants.albumViewGuideCardTextColor
                    "#${MainActivity.iconColor}"
                )
            )
            .targetView(activityCurlLandscapeBinding.fab7)
            .listener(object : BubbleShowCaseListener { //Listener for user actions
                override fun onTargetClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the target
                }

                override fun onCloseActionImageClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks the close button
                }

                override fun onBubbleClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the bubble
                    bubbleShowCase.dismiss() //If you want to close the bubble when the user clicks on it.
                }

                override fun onBackgroundDimClick(bubbleShowCase: BubbleShowCase) {
                    //Called when the user clicks on the background dim
                    bubbleShowCase.finishSequence() //If you want to close all the sequence when the user clicks on background dim.
                }
            })
    }

    private fun getSequence(): BubbleShowCaseSequence {
        DLog("Success", "Ok1")


        if (albumOrientation == 1) {
            return BubbleShowCaseSequence().addShowCases(
                listOf(
                    bubbleShowbackPressLandscapeView(),
                    showImageViewSliderLandscapeView(),
                    zoomImageViewLandscapeView(),
                    listenMusicLandcapeView(),
                    shareEventLandscapeView()

                    /* moveLeftAlbumViewPage(),
                     moveRightAlbumViewPage()*/
                )
            )
        } else {
            return BubbleShowCaseSequence().addShowCases(
                listOf(
                    showImageViewSlider(BubbleShowCase.ArrowPosition.LEFT),
                    zoomImageView(BubbleShowCase.ArrowPosition.LEFT),
                    moveLeftAlbumViewPage(BubbleShowCase.ArrowPosition.LEFT),
                    moveRightAlbumViewPage(BubbleShowCase.ArrowPosition.LEFT),
                    bubbleShowbackPressLandscapeView(),
                    listenMusicLandcapeView(),
                    shareEventLandscapeView()
                )
            )
        }
    }

    private fun getSequence1(): BubbleShowCaseSequence {
        return BubbleShowCaseSequence().addShowCases(
            listOf(
                moveLeftAlbumViewPage(BubbleShowCase.ArrowPosition.RIGHT),
                moveRightAlbumViewPage(BubbleShowCase.ArrowPosition.RIGHT)
            )
        )
    }

    private fun getSequence2(position: Int): BubbleShowCaseSequence {
        DLog("Success", "Ok1")
        if (position == 1) {
            return BubbleShowCaseSequence().addShowCases(
                listOf(
                    moveLeftAlbumViewPage(BubbleShowCase.ArrowPosition.RIGHT),
                    moveRightAlbumViewPage(BubbleShowCase.ArrowPosition.RIGHT),
                    bubbleShowbackPressLandscapeView(),
                    showImageViewSliderLandscapeView(),
                    zoomImageViewLandscapeView(),
                    listenMusicLandcapeView(),
                    shareEventLandscapeView()
                )
            )
        } else {
            return BubbleShowCaseSequence().addShowCases(
                listOf(
                    showImageViewSlider(BubbleShowCase.ArrowPosition.LEFT),
                    zoomImageView(BubbleShowCase.ArrowPosition.LEFT),
                    moveLeftAlbumViewPage(BubbleShowCase.ArrowPosition.LEFT),
                    moveRightAlbumViewPage(BubbleShowCase.ArrowPosition.LEFT),
                    bubbleShowbackPressLandscapeView(),
                    listenMusicLandcapeView(),
                    shareEventLandscapeView()
                )
            )
        }
    }

    private fun loadNextPageWithFlipAnimationRightToLeft() {
        activityCurlLandscapeBinding.fab3.isClickable = false
        val fromXPosition = intArrayOf(curl.right)
        val fromYPosition = curl.top
        val toXPosition = curl.left
        val downTime = SystemClock.uptimeMillis()
        val eventTime = SystemClock.uptimeMillis()
        val me = arrayOf(
            MotionEvent.obtain(
                downTime,
                eventTime,
                MotionEvent.ACTION_DOWN,
                fromXPosition[0].toFloat(),
                fromYPosition.toFloat(),
                0
            )
        )

        DLog("FAB3 current index", "$fromXPosition $fromYPosition $toXPosition")
        curl.dispatchTouchEvent(me[0])
        val handler = Handler()
        handler.postDelayed(object : Runnable {
            override fun run() {
                var me = MotionEvent.obtain(
                    downTime,
                    eventTime,
                    MotionEvent.ACTION_MOVE,
                    fromXPosition[0].toFloat(),
                    fromYPosition.toFloat(),
                    0
                )
                curl.dispatchTouchEvent(me)
                fromXPosition[0] = fromXPosition[0] - 10
                if (fromXPosition[0] > toXPosition) {
                    handler.postDelayed(this, 2)
                    DLog("inside if", "inside")
                    // fab3.isClickable = true
                } else {
                    DLog("inside else", "else")
                    me = MotionEvent.obtain(
                        downTime,
                        eventTime,
                        MotionEvent.ACTION_UP,
                        fromXPosition[0].toFloat(),
                        fromYPosition.toFloat(),
                        0
                    )
                    curl.dispatchTouchEvent(me)
                    activityCurlLandscapeBinding.fab3.isClickable = true
                }
                DLog("delay mills", "delay")
            }
        }, 1)
    }

    private fun loadNextPageWithFlipAnimationLeftToRight() {
        activityCurlLandscapeBinding.fab4.isClickable = false
        val fromXPosition = intArrayOf(curl.left)
        val fromYPosition = curl.bottom
        val toXPosition = curl.right
        val downTime = SystemClock.uptimeMillis()
        val eventTime = SystemClock.uptimeMillis()
        DLog("FAB4 current index", "$fromXPosition $fromYPosition $toXPosition")

        val me = arrayOf(
            MotionEvent.obtain(
                downTime,
                eventTime,
                MotionEvent.ACTION_DOWN,
                fromXPosition[0].toFloat(),
                fromYPosition.toFloat(),
                0
            )
        )
        curl.dispatchTouchEvent(me[0])
        val handler = Handler()
        handler.postDelayed(object : Runnable {
            override fun run() {
                var me = MotionEvent.obtain(
                    downTime,
                    eventTime,
                    MotionEvent.ACTION_MOVE,
                    fromXPosition[0].toFloat(),
                    fromYPosition.toFloat(),
                    0
                )
                curl.dispatchTouchEvent(me)
                fromXPosition[0] = fromXPosition[0] + 10
                if (fromXPosition[0] < toXPosition) {
                    handler.postDelayed(this, 2)
                } else {
                    me = MotionEvent.obtain(
                        downTime,
                        eventTime,
                        MotionEvent.ACTION_UP,
                        fromXPosition[0].toFloat(),
                        fromYPosition.toFloat(),
                        0
                    )
                    curl.dispatchTouchEvent(me)
                    activityCurlLandscapeBinding.fab4.isClickable = true
                }
            }
        }, 1)
    }

//    fun autoPlayPage() {
//        val fromXPosition = intArrayOf(curl.getRight())
//        val fromYPosition = curl.getTop()
//        val toXPosition = curl.getLeft()
//        val downTime = SystemClock.uptimeMillis()
//        val eventTime = SystemClock.uptimeMillis()
//        val me = arrayOf(
//            MotionEvent.obtain(
//                downTime,
//                eventTime,
//                MotionEvent.ACTION_DOWN,
//                fromXPosition[0].toFloat(),
//                fromYPosition.toFloat(),
//                0
//            )
//        )
//        curl.dispatchTouchEvent(me[0])
//
//        for (images in 0 until imageNamesArrayList.size / 2) {
//            DLog("FAB3 current index", "$images ")
//            val handler = Handler()
//            handler.postDelayed(object : Runnable {
//                override fun run() {
//                    var me = MotionEvent.obtain(
//                        downTime,
//                        eventTime,
//                        MotionEvent.ACTION_MOVE,
//                        fromXPosition[0].toFloat(),
//                        fromYPosition.toFloat(),
//                        0
//                    )
//                    curl.dispatchTouchEvent(me)
//                    fromXPosition[0] = fromXPosition[0] - 10
//                    if (fromXPosition[0] > toXPosition) {
//                        handler.postDelayed(this, 2)
//                    } else {
//                        me = MotionEvent.obtain(
//                            downTime,
//                            eventTime,
//                            MotionEvent.ACTION_UP,
//                            fromXPosition[0].toFloat(),
//                            fromYPosition.toFloat(),
//                            0
//                        )
//                        curl.dispatchTouchEvent(me)
//                    }
//                }
//            }, 1)
//        }
//        DLog("FAB3 current index", "$fromXPosition $fromYPosition $toXPosition")
//    }
//
//    fun updatePage11(page: CurlPage, width: Int, height: Int, k: Int) {
//        // DLog("page numbers", "${page} ${width} ${height} ${k}")
//        //var imageNamesArrayList = mutableListOf<String>()
//
//        var even = 0
//        var odd = 0
//
//        currentIndexValue = k
//
//        /*   DLog("imageNamesArrayList Size", "${imageNamesArrayList.size}")
//
//           DLog("page numbers", "${k}  ${(k * 2) + 1} ${(k * 2) - 1}")
//
//           DLog("page numbers", "${k} -- ${mStateOfCurl}")*/
//
//        if (mStateOfCurl == "0") {
//            // left curl
//            when (k) {
//                0 -> {
//                    setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageNamesArrayList[(k)])
//                    setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageNamesArrayList[(k + 1)])
//                }
//                imageNamesArrayListSize / 2 -> {
//                    setStringPreference(
//                        mContext!!,
//                        FIRST_IMAGE_ZOOM,
//                        imageNamesArrayList[(k * 2) - 2]
//                    )
//                    setStringPreference(
//                        mContext!!,
//                        SECOND_IMAGE_ZOOM,
//                        imageNamesArrayList.get((k * 2) - 1)
//                    )
//                }
//                else -> {
//                    val currentPos = k + 1
//                    try {
//                        // DLog("page numbers11", "${currentPos} ${(currentPos * 2) - 2}  ${(currentPos * 2) - 1}  ${imageNamesArrayList.get((currentPos * 2) - 2)}  ${imageNamesArrayList.get((currentPos * 2) - 1)} ")
//                        setStringPreference(
//                            mContext!!,
//                            FIRST_IMAGE_ZOOM,
//                            imageNamesArrayList[(currentPos * 2) - 2]
//                        )
//                        setStringPreference(
//                            mContext!!,
//                            SECOND_IMAGE_ZOOM,
//                            imageNamesArrayList[(currentPos * 2) - 1]
//                        )
//                    } catch (e: IndexOutOfBoundsException) {
//                        DLog("CurlActivity ERROR: ", e.message.toString())
//                    }
//                }
//            }
//        } else if (mStateOfCurl.equals("1")) {
//            // right curl
//            when (k) {
//                0 -> {
//                    setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageNamesArrayList[(k)])
//                    setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageNamesArrayList[(k + 1)])
//                }
//                imageNamesArrayListSize / 2 -> {
//                    setStringPreference(
//                        mContext!!,
//                        FIRST_IMAGE_ZOOM,
//                        imageNamesArrayList[(k * 2) - 2]
//                    )
//                    setStringPreference(
//                        mContext!!,
//                        SECOND_IMAGE_ZOOM,
//                        imageNamesArrayList[(k * 2) - 1]
//                    )
//                }
//                else -> {
//                    //  DLog("right curl numbers11", "${k} ${(k * 2) - 2}  ${(k * 2) - 1}   ${imageNamesArrayList.get((k * 2) - 2)} ${imageNamesArrayList.get((k * 2) - 1)}")
//                    setStringPreference(
//                        mContext!!,
//                        FIRST_IMAGE_ZOOM,
//                        imageNamesArrayList[(k * 2) - 2]
//                    )
//                    setStringPreference(
//                        mContext!!,
//                        SECOND_IMAGE_ZOOM,
//                        imageNamesArrayList[(k * 2) - 1]
//                    )
//                }
//            }
//        }
//
//        //val tmp1 = BitmapFactory.decodeResource(resources, R.drawable.download)
//        try {
//            if (k == 0) {
///*                    val front = loadBitmap(width, height, k, bitmapArrayList.get(k))
//                    //DLog("i Value First", "${k}")*/
//                //val front = loadBitmap(width, height, k, bitmapArrayList.get(k))
//                val front = loadBitmap(width, height, k, getBitmapFromIndex(k))
//                // DLog("i Value First", "${k}")
//
//                page.setTexture(front, CurlPage.SIDE_FRONT)
//                page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_BACK)
//                //  currentIndex=k
//            }/*else if(k!=imageNamesArrayListSize && k!=0 ) {
//                if (k % 2 == 0) {// even
//                    val front = loadBitmap(width, height, k, bitmapArrayList.get(k))
//                    DLog("i Value Second", "${k}")
//                    page.setTexture(front, CurlPage.SIDE_BACK)
//
//                      val back = loadBitmap1(width, height, k, bitmapArrayList.get(k + 1))
//                    page.setTexture(back, CurlPage.SIDE_FRONT)
//                    DLog("i Value Third", "${k}")
//                } else {// odd
//                    val front = loadBitmap(width, height, k, bitmapArrayList.get(k))
//                    DLog("i Value Second", "${k}")
//                    page.setTexture(front, CurlPage.SIDE_FRONT)
//
//                    val back = loadBitmap1(width, height, k, bitmapArrayList.get(k + 1))
//                    page.setTexture(back, CurlPage.SIDE_BACK)
//                    DLog("i Value Third", "${k}")
//                }
//            }*/
//            else if (k != 0 && k == 1 && k != imageNamesArrayList.size / 2 + 1) { // 1
///*
//
//                    val front = loadBitmap(width, height, k, bitmapArrayList.get(k))
//                    // DLog("i Value Second", "${k}")
//*/
//
//                val front = loadBitmap(width, height, k, getBitmapFromIndex(k))
//                // DLog("i Value Second", "${k}")
//
//                page.setTexture(front, CurlPage.SIDE_FRONT)
//                val back = loadBitmap1(width, height, k, getBitmapFromIndex(k + 1))
//                page.setTexture(back, CurlPage.SIDE_BACK)
//                //  DLog("i Value Third", "${k}")
//            } else if (k != 0 && k != 1 && k % 2 != 0 && k != imageNamesArrayList.size / 2) {
//                odd = k - 1
///*
//
//                    val front = loadBitmap(width, height, k, bitmapArrayList.get(odd + k))
//                    // DLog("i Value Fourth", "${odd + k}")
//*/
//
//                val front = loadBitmap(width, height, k, getBitmapFromIndex(odd + k))
//                //   DLog("i Value Fourth", "${odd + k}")
//
//                page.setTexture(front, CurlPage.SIDE_FRONT)
//
//                val back = loadBitmap1(width, height, k, getBitmapFromIndex(k + k))
//                page.setTexture(back, CurlPage.SIDE_BACK)
//                //  DLog("i Value ", "${k + k}")
//            } else if (k != 0 && k % 2 == 0 && k != imageNamesArrayList.size / 2) {
//                val back = loadBitmap1(width, height, k, getBitmapFromIndex(k + k))
//                page.setTexture(back, CurlPage.SIDE_BACK)
//                //  DLog("i Value Third", "${k + k}")
//                even = k - 1
//                val back1 = loadBitmap(width, height, k, getBitmapFromIndex(even + k))
//                page.setTexture(back1, CurlPage.SIDE_FRONT)
//                // DLog("i Value Third", "${even + k}")
//
//            }
//            if (k == imageNamesArrayList.size / 2) {
//                odd = k - 1
//                val back = loadBitmap1(width, height, k, getBitmapFromIndex(odd + k))
//                page.setTexture(back, CurlPage.SIDE_BACK)
//                //  DLog("i Value Fourth", "${k}")
//
//                /*val back1=loadBitmap(width,height,k,tmp1)
//                page.setTexture(back1, CurlPage.SIDE_FRONT)*/
//                page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_FRONT)
//
//            }
//            indexvalue = k
//
//        } catch (e: IndexOutOfBoundsException) {
//            DLog("CurlActivity :", "${e.message}")
//        } catch (e: Exception) {
//            DLog("CurlActivity :", "${e.message}")
//        }
//    }

    private fun loadBitmap(width: Int, height: Int, k: Int, bitmapFromIndex: Bitmap): Bitmap? = null

    private fun loadBitmap1(width: Int, height: Int, k: Int, bitmapFromIndex: Bitmap): Bitmap? =
        null

    private val MESSAGE_CLEAR = 0
    private val MESSAGE_INIT_DISK_CACHE = 1
    private val MESSAGE_FLUSH = 2
    private val MESSAGE_CLOSE = 3

    inner class CacheAsyncTask : AsyncTask<Any, Void, Void>() {

        override fun doInBackground(vararg params: Any): Void? {
            when (params[0] as Int) {
                MESSAGE_CLEAR -> imageCache1?.clearCache()
                MESSAGE_INIT_DISK_CACHE -> imageCache1?.initDiskCache()
                MESSAGE_FLUSH -> imageCache1?.flush()
                MESSAGE_CLOSE -> imageCache1?.close()
            }
            return null
        }
    }

    fun getSampleEmptyBitmap(): Bitmap {
        /*val w = 10
        val h = 10
        val conf = Bitmap.Config.ARGB_8888 // see other conf types
        var bitmap = Bitmap.createBitmap(w, h, conf)*/

        //val width = getIntPreference(this, SharedPreferenceConst.WIDTH_PIXELS)
        //val height = getIntPreference(this, SharedPreferenceConst.HEIGHT_PIXELS)

        //var bitmap = Bitmap.createBitmap(curlViewWidth!!, curlViewHeight!!, Bitmap.Config.ARGB_8888)
        val bitmap = Bitmap.createBitmap(320, 426, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        val paint = Paint()
        paint.color = Color.WHITE
        canvas.drawRect(0F, 0F, 320.toFloat(), 426.toFloat(), paint)

        return bitmap

        /*if(sampleBitmap != null)
            return sampleBitmap!!
        else{
            val w = 10
            val h = 10
            val conf = Bitmap.Config.ARGB_8888 // see other conf types
            return Bitmap.createBitmap(w, h, conf)
        }*/

        //canvas.drawRect(0F, 0F, width.toFloat(), height.toFloat(), paint)
        //return bitmap
    }

    fun drawTextToBitmap(bitmap: Bitmap): Bitmap {
        val text = "Loading..."
        val scale = resources.displayMetrics.density
        var bitmapConfig = bitmap.config
        // set default bitmap config if none
        if (bitmapConfig == null) {
            bitmapConfig = Bitmap.Config.ARGB_8888
        }
        // resource bitmaps are imutable,
        // so we need to convert it to mutable one
        val newBitmap = bitmap.copy(bitmapConfig, true)
        val canvas = Canvas(newBitmap)
        // new antialised Paint
        val paint = Paint(Paint.ANTI_ALIAS_FLAG)
        // text color - #3D3D3D
        //paint.color = Color.rgb(61, 61, 61)
        paint.color = Color.BLACK
        // text size in pixels
        paint.textSize = 25 * scale
        // text shadow
        paint.setShadowLayer(1f, 0f, 1f, Color.WHITE)
        // draw text to the Canvas center
        val bounds = Rect()
        paint.getTextBounds(text, 0, text.length, bounds)
        val x = (bitmap.width - bounds.width()) / 2
        val y = (bitmap.height + bounds.height()) / 2
        canvas.drawText(text, x.toFloat(), y.toFloat(), paint)
        return newBitmap
    }

    fun drawTextToBitmap1(bitmapOriginal: Bitmap): Bitmap {
        val textToDraw = "Loading..."
        val newBitmap = bitmapOriginal.copy(bitmapOriginal.config?: Bitmap.Config.ARGB_8888, true)
        val newCanvas = Canvas(newBitmap)
        val paint = Paint(Paint.ANTI_ALIAS_FLAG)
        paint.color = Color.RED
        paint.textSize = 50.toFloat()
        val bounds = Rect()
        paint.getTextBounds(textToDraw, 0, textToDraw.length, bounds)
        val x = 0
        val y = newBitmap.height
        newCanvas.drawText(textToDraw, x.toFloat(), y.toFloat(), paint)
        return newBitmap
    }

    fun drawTextToBitmap2(): Bitmap {
        val bitmapOriginal =
            BitmapFactory.decodeResource(resources, R.drawable.image_load_landscape)
        val textToDraw = "Loading..."
        val newBitmap = bitmapOriginal.copy(bitmapOriginal.config?: Bitmap.Config.ARGB_8888, true)
        val newCanvas = Canvas(newBitmap)
        val paint = Paint(Paint.ANTI_ALIAS_FLAG or Paint.LINEAR_TEXT_FLAG)
        paint.color = Color.RED
        paint.textSize = 1500.toFloat()
        val bounds = Rect()
        paint.getTextBounds(textToDraw, 0, textToDraw.length, bounds)
        val x = 0
        //var y = newBitmap.height
        val y = 0
        newCanvas.drawText(textToDraw, x.toFloat(), y.toFloat(), paint)
        return newBitmap
    }

    companion object {

        var imageDownloadStatusMap: HashMap<String, Boolean> = HashMap()
        var imageTypeMap: HashMap<String, Int> = HashMap()

        class DownloadAlbumMusic(
            private val curlActivity: CurlActivity,
            private val musicId: Int,
            private val musicName: String,
            private val audioUrl: String,
        ) : AsyncTask<String, Int, Boolean>() {

            override fun doInBackground(vararg params: String): Boolean? {

                /*val projectFolder = File(
                    curlActivity.getExternalFilesDir(null)?.absolutePath,
                    curlActivity.resources.getString(R.string.main_folder_name)
                )*/
                val projectFolder = StorageUtils.getCacheFolder(curlActivity)


                if (!projectFolder.exists()) {
                    projectFolder.mkdir()
                }

                val thumbFolder = File(projectFolder, "/")
                if (!thumbFolder.exists()) {
                    thumbFolder.mkdir()
                }

                //val audioUrl = "${AppConst.STORAGE_URL}${curlActivity.dbHelper?.getStudioId(curlActivity.eventId!!)}/${curlActivity.albumId}/audio/${curlActivity.music}"


                val musicPath = "${MainActivity.publicPath}/$musicName"
                DLog("CurlActivity : ", "DownloadAlbumMusic()  $musicName :: $musicPath ")
                val file = File(thumbFolder, "$musicName.mp3")
                try {
                    val policy = StrictMode.ThreadPolicy.Builder().permitAll().build()
                    StrictMode.setThreadPolicy(policy)

                    if (!file.exists()) {
                        //file.mkdir()
                        val url = URL(musicPath)
                        DLog("CurlActivity : ", "DownloadAlbumMusic() inside if() $audioUrl ")
                        val connection1 = url.openConnection() as HttpURLConnection
                        if (connection1.responseCode != 403) {
                            val connection = url.openConnection() as HttpURLConnection
                            connection.requestMethod = "GET"
                            connection.doInput = true
                            connection.connect()

                            DLog("CurlActivity: ", "AUDIO: ${connection.inputStream}")

                            connection.inputStream.use { input ->
                                file.outputStream().use { fileOut ->
                                    input.copyTo(fileOut, 1024)
                                }
                            }
                            return true
                        } else if (connection1.responseCode == 403) {
                            curlActivity.sendSlackNotification(
                                musicId,
                                WebConstants.ERROR_403_WHILE_FILE_DOWNLOAD
                            )
                            return false
                        }
                    } else {
                        return true
                    }
                } catch (e: Exception) {
                    DLog("Exception 1: ", "${e.message}  $file")
                }
                return false
            }

            override fun onPostExecute(isDownload: Boolean?) {
                super.onPostExecute(isDownload)
                //fillPage()
                try {
                    /*val musicFilePath = curlActivity.getExternalFilesDir(null)?.absolutePath + "/${
                        curlActivity.resources.getString(R.string.main_folder_name)
                    }/$musicName"*/
                    if (isDownload!!) {
                        //curlActivity.dbHelper!!.updateDownloadStatus(musicId, 1)
                        curlActivity.playFromLocale(
                            StorageUtils.getFile(
                                curlActivity,
                                "$musicName.mp3"
                            ).absolutePath
                        )
                    }/* else {
                        curlActivity.dbHelper!!.updateDownloadStatus(musicId, 0)
                        curlActivity.playFromAsset()
                    }*/
                } catch (e: java.lang.Exception) {
                }
            }
        }

        class DownloadStudioLogo(
            private val curlActivity: CurlActivity,
            private val logoName: String,
            private val extension: String,
        ) : AsyncTask<String, Int, Boolean>() {

            override fun doInBackground(vararg params: String): Boolean? {

                val projectFolder = StorageUtils.getCacheFolder(curlActivity)


                if (!projectFolder.exists()) {
                    projectFolder.mkdir()
                }

                val thumbFolder = File(projectFolder, "/")
                if (!thumbFolder.exists()) {
                    thumbFolder.mkdir()
                }

                //val audioUrl = "${AppConst.STORAGE_URL}${curlActivity.dbHelper?.getStudioId(curlActivity.eventId!!)}/${curlActivity.albumId}/audio/${curlActivity.music}"


                val musicPath = "${MainActivity.publicPath}/$logoName"
                DLog("CurlActivity : ", "DownloadAlbumMusic()  $logoName :: $musicPath ")
                val file = File(thumbFolder, "$logoName$extension")
                try {
                    val policy = StrictMode.ThreadPolicy.Builder().permitAll().build()
                    StrictMode.setThreadPolicy(policy)

                    if (!file.exists()) {
                        //file.mkdir()
                        val url = URL(musicPath)
                        DLog("CurlActivity : ", "DownloadAlbumMusic() inside if()  ")
                        val connection1 = url.openConnection() as HttpURLConnection
                        if (connection1.responseCode != 403) {
                            val connection = url.openConnection() as HttpURLConnection
                            connection.requestMethod = "GET"
                            connection.doInput = true
                            connection.connect()

                            DLog("CurlActivity: ", "AUDIO: ${connection.inputStream}")

                            connection.inputStream.use { input ->
                                file.outputStream().use { fileOut ->
                                    input.copyTo(fileOut, 1024)
                                }
                            }
                            return true
                        } else if (connection1.responseCode == 403) {
                            /*curlActivity.sendSlackNotification(
                                musicId,
                                WebConstants.ERROR_403_WHILE_FILE_DOWNLOAD
                            )*/
                            return false
                        }
                    } else {
                        return true
                    }
                } catch (e: Exception) {
                    DLog("Exception 1: ", "${e.message}  $file")
                }
                return false
            }

            override fun onPostExecute(isDownload: Boolean?) {
                super.onPostExecute(isDownload)
                //fillPage()
                try {

                    if (isDownload!!) {
                        curlActivity.activityCurlLandscapeBinding.activityCurlStudioLogoImageView.setBackgroundColor(
                            Color.parseColor("#${MainActivity.studioLogoBackgroundColor}")
                        )
                        curlActivity.imageCache1?.addBitmapToCache(
                            TransportDataKeys.studioLogo,
                            //EncryptAndDecryptFiles.decodeFileWithoutSplit(file, this)
                            BitmapFactory.decodeFile(
                                StorageUtils.getFile(
                                    curlActivity,
                                    "$logoName$extension"
                                ).absolutePath
                            )
                        )
                        try {
                            curlActivity.activityCurlLandscapeBinding.activityCurlStudioLogoImageView.setImageBitmap(
                                curlActivity.imageCache1!!.getBitmapFromDiskCache(
                                    TransportDataKeys.studioLogo
                                )
                            )
                        } catch (e: IllegalStateException) {
                            val bitmap = Bitmap.createBitmap(320, 426, Bitmap.Config.ARGB_8888)
                            val canvas = Canvas(bitmap)
                            val paint = Paint()
                            paint.color = Color.BLACK
                            canvas.drawRect(0F, 0F, 320.toFloat(), 426.toFloat(), paint)
                            curlActivity.activityCurlLandscapeBinding.activityCurlStudioLogoImageView.setImageBitmap(
                                bitmap
                            )
                        } catch (e: Exception) {
                            val bitmap = Bitmap.createBitmap(320, 426, Bitmap.Config.ARGB_8888)
                            val canvas = Canvas(bitmap)
                            val paint = Paint()
                            paint.color = Color.BLACK
                            canvas.drawRect(0F, 0F, 320.toFloat(), 426.toFloat(), paint)
                            curlActivity.activityCurlLandscapeBinding.activityCurlStudioLogoImageView.setImageBitmap(
                                bitmap
                            )
                        }
                    }
                } catch (e: java.lang.Exception) {
                }
            }
        }
    }

    private fun setColors() {
        //var df: FloatingActionButton = fab
        //fab.setBackgroundColor()
        //fab.setBackgroundColor(Color.parseColor("#ffffff"))
        /*fab.backgroundTintList = ColorStateList.valueOf(Color.parseColor("#ffffff"))
        fab.setColorFilter(
            Color.parseColor("#ff0000")
        )*/
        /*fab.backgroundTintList = ColorStateList.valueOf(AppColors.getColor(
            this,
            AppColorConstants.albumViewRoundBackgroundColor
        ))*/

        findViewById<ConstraintLayout>(R.id.main_layout).setBackgroundDrawable(
            linearGradientDrawable()
        )

        //curl.setBackgroundColor(-0x000000)


        val fabList = listOf<FloatingActionButton>(
            activityCurlLandscapeBinding.fab,
            activityCurlLandscapeBinding.fab1,
            activityCurlLandscapeBinding.fab2,
            activityCurlLandscapeBinding.fab3,
            activityCurlLandscapeBinding.fab4,
            activityCurlLandscapeBinding.fab5,
            activityCurlLandscapeBinding.fab6,
            activityCurlLandscapeBinding.fab7,
            activityCurlLandscapeBinding.backArrowFab,
            activityCurlLandscapeBinding.fab8,
        )
        /*fabList.forEach {
            it.backgroundTintList = ColorStateList.valueOf(
                AppColors.getColor(
                    this,
                    AppColorConstants.albumViewRoundBackgroundColor
                )
            )
            //it.drawable = linearGradientDrawable()
            //it.setBackgroundDrawable(linearGradientDrawable())
            //it.background.mutate().setTint(ContextCompat.getColor(this, AppColors.getColor(this, AppColorConstants.albumViewRoundBackgroundColor)))
            it.setColorFilter(
                AppColors.getColor(
                    this,
                    AppColorConstants.albumViewRoundIconColor
                )
            )
        }*/
        fabList.forEach {
            it.backgroundTintList = ColorStateList.valueOf(
                AppColors.getColor(
                    this,
                    "#${MainActivity.iconBackgroundColor}"
                )
            )
            it.setColorFilter(
                AppColors.getColor(
                    this,
                    "#${MainActivity.iconColor}"
                )
            )
        }

        activityCurlLandscapeBinding.downloadTextView.setTextColor(Color.parseColor("#${MainActivity.progressBarColor}"))
        //activity_curl_studioLogo_imageView.visibility = View.INVISIBLE
        //progressBar.progressTintList = ColorStateList.valueOf(Color.parseColor("#${MainActivity.progressBarColor}"))
        //progressBar.progressDrawable.colorFilter = LightingColorFilter(-0x1000000, customColorInt)
        activityCurlLandscapeBinding.progressBar.getProgressDrawable().setColorFilter(
            Color.parseColor("#${MainActivity.progressBarColor}"),
            android.graphics.PorterDuff.Mode.SRC_IN
        );
        activityCurlLandscapeBinding.progressTextView.setTextColor(Color.parseColor("#${MainActivity.progressBarColor}"))
    }

    private fun linearGradientDrawable(): GradientDrawable {
        DLog("CurlActivity :: ", "linearGradientDrawable :: studioId = ${MainActivity.studioId}")
        DLog(
            "CurlActivity :: ",
            "linearGradientDrawable :: publicPath = ${MainActivity.publicPath}"
        )
        DLog(
            "CurlActivity :: ",
            "linearGradientDrawable :: screenDisplay = ${MainActivity.screenDisplay}"
        )
        DLog(
            "CurlActivity :: ",
            "linearGradientDrawable :: albumViewBackgroundColor = ${MainActivity.albumViewBackgroundColor}"
        )
        DLog("CurlActivity :: ", "linearGradientDrawable :: iconColor = ${MainActivity.iconColor}")
        DLog(
            "CurlActivity :: ",
            "linearGradientDrawable :: iconBackgroundColor = ${MainActivity.iconBackgroundColor}"
        )
        DLog(
            "CurlActivity :: ",
            "linearGradientDrawable :: studioLogoBackgroundColor = ${MainActivity.studioLogoBackgroundColor}"
        )
        val backgroundColors = MainActivity.albumViewBackgroundColor.split(",")
        return GradientDrawable().apply {
            colors = intArrayOf(
                Color.parseColor("#${backgroundColors[0]}"),
                //Color.parseColor("#8DB600"),
                Color.parseColor("#${backgroundColors[1]}")
            )
            gradientType = GradientDrawable.LINEAR_GRADIENT
            shape = GradientDrawable.RECTANGLE
            orientation = GradientDrawable.Orientation.BOTTOM_TOP

            // border around drawable
            //setStroke(5,Color.parseColor("#4B5320"))
        }
    }

}