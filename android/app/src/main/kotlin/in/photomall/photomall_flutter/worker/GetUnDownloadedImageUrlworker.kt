package `in`.photomall.photomall_flutter.worker

import `in`.photomall.photomall_flutter.api.Api
import `in`.photomall.photomall_flutter.api.ApiUrls
import `in`.photomall.photomall_flutter.appUtils.GetUnDownloadedImages
import `in`.photomall.photomall_flutter.database.DbHelper
import `in`.photomall.photomall_flutter.model.api.RefreshImageUrl
import `in`.photomall.photomall_flutter.model.other.UnDownloadedImageData
import `in`.photomall.photomall_flutter.retrofitHelper.APICallForJson
import `in`.photomall.photomall_flutter.retrofitHelper.APIListener
import `in`.photomall.photomall_flutter.threadPool.DownloadResultUpdateTaskListener
import `in`.photomall.photomall_flutter.utils.Others.DLog
import android.annotation.SuppressLint
import android.content.Context
import android.database.Cursor
import android.graphics.Bitmap
import androidx.work.Data
import androidx.work.ListenableWorker
import androidx.work.WorkerParameters
import androidx.work.impl.utils.futures.SettableFuture
import com.google.common.util.concurrent.ListenableFuture
import com.google.gson.Gson
import java.lang.Exception

class GetUnDownloadedImageUrlworker(context: Context, params: WorkerParameters) : ListenableWorker(context, params), DownloadResultUpdateTaskListener {

    var pageStatus: Int? = null

    var cursor: Cursor? = null

    var dbHelper: DbHelper? = null
    var mContext: Context? = null
    var eventId: String? = null
    var resultTwo: Boolean = false

    var mFuture: SettableFuture<Result>? = null

    var insufficientStorage: Boolean? = null

    init {
        this.mContext = context
        dbHelper = DbHelper.getInstance(mContext!!)
    }

    @SuppressLint("RestrictedApi")
    override fun startWork(): ListenableFuture<Result> {

        mFuture = SettableFuture.create<Result>()

        pageStatus = inputData.getInt(Api.PAGE_STATUS, 0)
        eventId = inputData.getString(Api.EVENT_OR_ALBUM_ID)
        insufficientStorage = inputData.getBoolean(Api.INSUFFICIENT_STORAGE, true)

        DLog("GetUnDownloadedImageUrlworkerStorage ", "${insufficientStorage}")

        try {
            if (insufficientStorage!!) { // true
                checkForDownloads()
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
        val jsonObject = GetUnDownloadedImages.getJson(dbHelper!!, eventId!!)
        val convertToModel = Gson().fromJson(jsonObject.toString(), UnDownloadedImageData::class.java)

        DLog("GetUnDownloadedImageUrlworker 1 ", "$convertToModel   $pageStatus  $eventId ")

        if (!convertToModel.image_ids.isNullOrEmpty()) {

            APICallForJson(applicationContext).APIRequestForJson(ApiUrls.REFRESH_IMAGE_URL, jsonObject, RefreshImageUrl::class.java, object : APIListener {

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

            }, 1, false)
        } else {
            setFutureResponse(5)
        }

    }

    private fun createOutputData(data: Int): Data {
        return Data.Builder()
                .putInt(Api.UPDATE_IMAGES_WORKER_OUTPUT_DATA, data)
                .build()
    }

    @SuppressLint("RestrictedApi")
    override fun setPercent(imageUrl: String, bmp: Bitmap, imageType: Int) {
        if (GetUnDownloadedImages.getCursor(dbHelper!!, eventId!!).count == 0) {
            DLog("GetUnDownloadedImageUrlworker :", "inside setPercent if")
            mFuture!!.set(Result.success(createOutputData(1)))
        } else {
            DLog("GetUnDownloadedImageUrlworker :", "inside setPercent if else")
        }
    }

    @SuppressLint("RestrictedApi")
    fun setFutureResponse(data: Int) {
        mFuture!!.set(Result.success(createOutputData(data)))
    }

    @SuppressLint("Range")
    fun handleResponse(response: Any) {
        val result = response as RefreshImageUrl
        DLog("DownloadImagesActivity :", "inside onSuccess 1")
        result.data.images.forEach {
            if (it.status == "success") {
                if (it.type == 2) { // album and event cover images
                    dbHelper?.insertRefreshedAlbumImagesAndEventCoverImageUrl(it.id, it.detail.original_url, it.detail.thumb_url)
                }
            } else {
                if (it.type == 2) { // album and event cover images
                    dbHelper?.deleteAlbumImagesAndEventCoverImage(it.id)
                }
            }
        }
        DLog("DownloadImagesActivity :", "inside onSuccess 2")
        val cursor = GetUnDownloadedImages.getCursor(dbHelper!!, eventId!!)
        if (cursor.count > 0 && cursor.moveToFirst()) {
//            do {
//                val drUpdateTask = DownloadResultUpdateTask(this)
//                val downloadTask = DownloadTask(cursor.getString(cursor.getColumnIndex(DBStatics.imageId)), pageStatus!!, mContext!!, drUpdateTask)
//                DownloadManager.downloadManager?.runDownloadFile(downloadTask)
//            } while (cursor.moveToNext())
        }
    }
}