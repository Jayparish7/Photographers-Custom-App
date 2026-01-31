package `in`.photomall.photomall_flutter.asyncTask

import `in`.photomall.photomall_flutter.api.Api
import `in`.photomall.photomall_flutter.api.ApiUrls
import `in`.photomall.photomall_flutter.api.WebConstants
import `in`.photomall.photomall_flutter.database.DbHelper
import `in`.photomall.photomall_flutter.model.api.RefreshImageUrl
import `in`.photomall.photomall_flutter.model.other.UnDownloadedImageData
import `in`.photomall.photomall_flutter.retrofitHelper.APICallForJson
import `in`.photomall.photomall_flutter.retrofitHelper.APIListener
import `in`.photomall.photomall_flutter.threadPool.DownloadResultUpdateTaskListener
import `in`.photomall.photomall_flutter.utils.NotifyToSlack
import `in`.photomall.photomall_flutter.utils.Others
import `in`.photomall.photomall_flutter.utils.Others.DLog
import android.annotation.SuppressLint
import android.content.Context
import android.database.Cursor
import android.database.DatabaseUtils
import android.graphics.Bitmap
import androidx.work.Data
import androidx.work.ListenableWorker
import androidx.work.WorkerParameters
import androidx.work.impl.utils.futures.SettableFuture
import com.google.common.util.concurrent.ListenableFuture
import com.google.gson.Gson
import com.photomall.photoalbum.photomallUser.appUtils.downloadImagesUtils.DownloadTempImages
import java.lang.Exception

class GetUnDownloadedImageUrlWorker(context: Context, params: WorkerParameters) : ListenableWorker(context, params),
    DownloadResultUpdateTaskListener {


    var pageStatus: Int? = null

    var cursor: Cursor? = null

    var dbHelper: DbHelper? = null
    var mContext: Context? = null
    var eventId: String? = null
    var resultTwo: Boolean = false

    var mFuture: SettableFuture<Result>? = null

    var insufficientStorage: Boolean? = null

    //var photomallDao: PhotomallDao? = null

    init {
        this.mContext = context
        dbHelper = DbHelper(mContext)
    }

    @SuppressLint("RestrictedApi")
    override fun startWork(): ListenableFuture<Result> {

        mFuture = SettableFuture.create<Result>()

        pageStatus = inputData.getInt(Api.PAGE_STATUS, 0)
        eventId = inputData.getString(Api.EVENT_OR_ALBUM_ID)
        insufficientStorage = inputData.getBoolean(Api.INSUFFICIENT_STORAGE, true)

        //photomallDao = PhotomallDB.getInstance(mContext!!).photomallDao()

        Others.DLog("GetUnDownloadedImageUrlworkerStorage ", "${insufficientStorage}")

        try {
            if (insufficientStorage!!) { // true

                when (pageStatus) {
                    /*8 -> { // Gallery Album Images
                        startDownloadGalleryImages()
                    }*/
                    0 -> {
                        startEventCoverImages()
                    }
                    else -> {
                        checkForDownloads()
                    }
                }
            } else {
                mFuture!!.set(Result.success(createOutputData(4)))
            }
            //latch!!.await(MAX_WAIT_TIME_SECONDS, TimeUnit.SECONDS)

            return mFuture as ListenableFuture<Result>

        } catch (e: Exception) {
            mFuture!!.set(Result.failure())

            return mFuture as ListenableFuture<Result>
        }
    }

    private fun checkForDownloads() {
        val jsonObject = DownloadTempImages.getImagesIdAndAddToJsonObject(pageStatus!!, eventId!!, dbHelper!!, mContext!!)
        val convertToModel = Gson().fromJson(jsonObject.toString(), UnDownloadedImageData::class.java)

        DLog("GetUnDownloadedImageUrlworker 1 ", "$convertToModel   $pageStatus  $eventId ")

        if (!convertToModel.image_ids.isNullOrEmpty()) {

            APICallForJson(applicationContext).APIRequestForJson(ApiUrls.REFRESH_IMAGE_URL, jsonObject, RefreshImageUrl::class.java, object :
                APIListener {

                @SuppressLint("RestrictedApi")
                override fun onSuccess(from: Int, response: Any) {
                    handleResponse(response)
                }

                @SuppressLint("RestrictedApi")
                override fun onFailure(from: Int, response: Any) {
                    setFutureResponse(2)
                }

                @SuppressLint("RestrictedApi")
                override fun onNetworkFailure(from: Int) {
                    setFutureResponse(3)
                }

            }, 1, false, isRunningForeground = false)
        } else {
            //setFutureResponse(5)
            downloadImages()
        }

    }

    private fun createOutputData(data: Int): Data {
        return Data.Builder()
                .putInt(Api.UPDATE_IMAGES_WORKER_OUTPUT_DATA, data)
                .build()
    }

    @SuppressLint("RestrictedApi")
    override fun setPercent(imageUrl: String, bmp: Bitmap, imageType: Int) {
        //mFuture!!.set(Result.success(createOutputData(1)))
        if (pageStatus == 8) { // Gallery Album Images
            /*if (runBlocking { withContext(Dispatchers.Default) { photomallDao!!.getSingleAlbumOriginalPhotoUrl(eventId!!) } }.isEmpty()) {
                mFuture!!.set(Result.success(createOutputData(1)))
            }*/
        } else if (pageStatus == 4) {
            /*if (runBlocking { withContext(Dispatchers.Default) { photomallDao?.viewPredesignedAlbumsPageDownloadableImages()!! } }.isEmpty()) {
                DLog("GetUnDownloadedImageUrlworker :", "inside setPercent if")
                mFuture!!.set(Result.success(createOutputData(1)))
            } else {
                DLog("GetUnDownloadedImageUrlworker :", "inside setPercent if else")
            }*/
        } else {
            if (DownloadTempImages.getUnDownloadedTempImagesCursor(pageStatus!!, eventId!!, dbHelper!!).count == 0) {
                DLog("GetUnDownloadedImageUrlworker :", "inside setPercent if")
                mFuture!!.set(Result.success(createOutputData(1)))
            } else {
                DLog("GetUnDownloadedImageUrlworker :", "inside setPercent if else")
            }
        }
    }

    @SuppressLint("RestrictedApi")
    fun setFutureResponse(data: Int) {
        mFuture!!.set(Result.success(createOutputData(data)))
    }

    fun handleResponse(response: Any) {
        val result = response as RefreshImageUrl
        DLog("DownloadImagesActivity :", "inside onSuccess 1")
        result.data.images.forEach {
            if (it.status == "success") {
               /* if (it.type == 11) { // invitation images
                    dbHelper?.insertRefreshedInvitationImageUrl(it.id, it.detail.original_url, it.detail.thumb_url)
                }*/
                if (it.type == 12 || it.type == 0 || it.type == 2 || it.type == 6) { // album and event cover images
                    dbHelper?.insertRefreshedAlbumImagesAndEventCoverImageUrl(it.id, it.detail.original_url, it.detail.thumb_url)
                }
               /* if (it.type == 4) {
                    //dbHelper?.insertRefreshedPredesignedImageUrl(it.id, it.detail.original_url, it.detail.thumb_url)
                    runBlocking { withContext(Dispatchers.Default) { photomallDao?.insertRefreshedPredesignedImageUrl(it.id, it.detail.original_url, it.detail.thumb_url) } }
                }*/
            } else {
                sendSlackNotification(WebConstants.ERROR_FAILED_FROM_IMAGE_RESPONSE, it.id)
                /*if (it.type == 11) { // invitation images
                    dbHelper?.deleteInvitationImage(it.id)
                }
                if (it.type == 12 || it.type == 2) { // album and event cover images
                    dbHelper?.deleteAlbumImagesAndEventCoverImage(it.id)
                }
                if (it.type == 4) {
                    //dbHelper?.deletePredesignedAlbumImages(it.id)
                    runBlocking {
                        withContext(Dispatchers.Default) {
                            photomallDao?.deleteFromPDAlbumImages(it.id)
                            photomallDao?.deletePdAlbumUsingCoverImageId(it.id)
                        }
                    }
                }
                if (it.type == 0 || it.type == 6) {
                    dbHelper?.deleteAlbumImagesAndEventCoverImage(it.id)
                    //dbHelper?.
                    // ADD ANOTHER QUERY
                }*/
            }
        }
        downloadImages()
    }

    @SuppressLint("Range")
    private fun downloadImages(){
        DLog("DownloadImagesActivity :", "inside onSuccess 2")
        val cursor = DownloadTempImages.getUnDownloadedTempImagesCursor(pageStatus!!, eventId!!, dbHelper!!)

        if (pageStatus == 0 || pageStatus == 6) {
            if (cursor.count > 0 && cursor.moveToFirst()) {
                do {
//                    val drUpdateTask = DownloadResultUpdateTask(this)
//                    val downloadTask = DownloadTask(cursor.getString(cursor.getColumnIndex(DBStatics.imageName)), pageStatus!!, mContext!!, drUpdateTask)
//                    DownloadManager.downloadManager?.runDownloadFile(downloadTask)
                } while (cursor.moveToNext())
            }else{
                setFutureResponse(5)
            }
        }
        /*if (pageStatus == 1) {
            val albumCursor = dbHelper?.totalAlbumsViewUnDownloadedCoverImages(eventId!!)
            if(cursor.count > 0 || albumCursor!!.count > 0){
                if (cursor.count > 0 && cursor.moveToFirst()) {
                    do {
                        val drUpdateTask = DownloadResultUpdateTask(this)
                        val downloadTask = DownloadTask(cursor.getString(cursor.getColumnIndex(DBStatics.INVITATIONS_IMAGE_URL)) + cursor.getString(cursor.getColumnIndex(DBStatics.INVITATIONS_IMAGE_EXTENSION)), 11, mContext!!, drUpdateTask)
                        DownloadManager.downloadManager?.runDownloadFile(downloadTask)
                    } while (cursor.moveToNext())
                }
                if (albumCursor!!.count > 0 && albumCursor.moveToFirst()) {
                    do {
                        val drUpdateTask = DownloadResultUpdateTask(this)
                        val downloadTask = DownloadTask(albumCursor.getString(albumCursor.getColumnIndex(DBStatics.ALBUM_IMAGES_IMAGE)) + albumCursor.getString(albumCursor.getColumnIndex(DBStatics.ALBUM_IMAGES_IMAGE_EXTENSION)), 12, mContext!!, drUpdateTask)
                        DownloadManager.downloadManager?.runDownloadFile(downloadTask)
                    } while (albumCursor.moveToNext())
                }
            }else{
                setFutureResponse(5)
            }
        }*/
        if (pageStatus == 2) {
            if (cursor.count > 0 && cursor.moveToFirst()) {
                do {
//                    val drUpdateTask = DownloadResultUpdateTask(this)
//                    val downloadTask = DownloadTask(cursor.getString(cursor.getColumnIndex(DBStatics.imageName)), pageStatus!!, mContext!!, drUpdateTask)
//                    DownloadManager.downloadManager?.runDownloadFile(downloadTask)
                } while (cursor.moveToNext())
            }else{
                setFutureResponse(5)
            }
        }

        /*val images: List<PreDesignedAlbumImages>
        if (pageStatus == 4 || pageStatus == 5) {
            images = if (pageStatus == 4) {
                runBlocking { withContext(Dispatchers.Default) { photomallDao!!.viewPredesignedAlbumsPageDownloadableImages() } }
            } else {
                runBlocking { withContext(Dispatchers.Default) { photomallDao!!.totalPredesignedOriginalImagesUnDownloadedForGenerateJson(eventId!!) } }
            }
            if(images.isNotEmpty()) {
                images.forEach {
                    if(it.pdAlbumImagesOriginalUrl!!.isNotEmpty()) {
                        val drUpdateTask = DownloadResultUpdateTask(this)
                        val downloadTask = DownloadTask(it.pdAlbumImagesImage + it.pdAlbumImagesExtension, pageStatus!!, mContext!!, drUpdateTask)
                        DownloadManager.downloadManager?.runDownloadFile(downloadTask)
                    }
                }
            }else{
                setFutureResponse(5)
            }
        }*/

        /*if (pageStatus == 4 || pageStatus == 5) {
            if (cursor.count > 0 && cursor.moveToFirst()) {
                do {
                    val drUpdateTask = DownloadResultUpdateTask(this)
                    val downloadTask = DownloadTask(cursor.getString(cursor.getColumnIndex(DBStatics.PREDESIGNED_ALBUM_IMAGES_IMAGE)) + cursor.getString(cursor.getColumnIndex(DBStatics.PREDESIGNED_ALBUM_IMAGES_EXTENSION)), pageStatus!!, mContext!!, drUpdateTask)
                    DownloadManager.downloadManager?.runDownloadFile(downloadTask)
                    *//*val drUpdateTask = PredesignedDownloadResultUpdateTask(this)
                    val downloadTask = PreDesignedDownloadTask(cursor.getString(cursor.getColumnIndex(DBStatics.PREDESIGNED_ALBUM_IMAGES_IMAGE)) + cursor.getString(cursor.getColumnIndex(DBStatics.PREDESIGNED_ALBUM_IMAGES_EXTENSION)), pageStatus!!, this, drUpdateTask)
                    PredesignedDownloadManager.downloadManager?.runDownloadFile(downloadTask)*//*
                } while (cursor.moveToNext())
            }
        }*/
    }

    private fun sendSlackNotification(errorType: String, imageId: Int) {
        val hashMap = HashMap<String, String>()
        hashMap[Api.TYPE] = errorType
        hashMap[Api.IMAGE_ID_DATA] = imageId.toString()
        NotifyToSlack(mContext!!, hashMap).execute()
        /*APICall(mContext!!).APIRequest(ApiUrls.SLACK_NOTIFICATION, hashMap, SlackNotificationResponse::class.java, object : APIListener {
            override fun onSuccess(from: Int, response: Any) {}
            override fun onFailure(from: Int, response: Any) {}
            override fun onNetworkFailure(from: Int) {}
        }, 1, "", false)*/
    }

    /*private fun startDownloadGalleryImages() {

        val imageUrlList = runBlocking { withContext(Dispatchers.Default) { photomallDao?.getAlbumImages(eventId!!) } }
        imageUrlList!!.forEach {
            photomallDao?.updateAlbumImagesUrl(it.imageId, Others.getPublicUrlForGallery(it.albumId, it.image))
        }

        val cursor: List<SingleAlbumOriginalPhotoUrl>? = runBlocking { withContext(Dispatchers.Default) { photomallDao!!.getSingleAlbumOriginalPhotoUrl(eventId!!) } }
        cursor!!.forEach {
            val drUpdateTask = DownloadResultUpdateTask(this)
            val downloadTask = DownloadTask(it.image + it.image_extension, 8, mContext!!, drUpdateTask)
            DownloadManager.downloadManager?.runDownloadFile(downloadTask)
        }
    }*/

    @SuppressLint("Range")
    private fun startEventCoverImages() {
        val cursor = dbHelper!!.getEventsUnDownloadedCoverImages()
        DLog("GetUnDownloadedImageUrlworker :", "startEventCoverImages() :: ${DatabaseUtils.dumpCursorToString(cursor)}")
//        if (cursor.count > 0 && cursor.moveToFirst()) {
//            do {
//                val drUpdateTask = DownloadResultUpdateTask(this)
//                val downloadTask = DownloadTask(cursor.getString(cursor.getColumnIndex(DBStatics.imageName)), 0, mContext!!, drUpdateTask)
//                DownloadManager.downloadManager?.runDownloadFile(downloadTask)
//            } while (cursor.moveToNext())
//        }
    }

}