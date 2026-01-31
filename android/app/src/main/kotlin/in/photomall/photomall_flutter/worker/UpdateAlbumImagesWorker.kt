package `in`.photomall.photomall_flutter.worker

import `in`.photomall.photomall_flutter.api.Api
import `in`.photomall.photomall_flutter.api.ApiUrls
import `in`.photomall.photomall_flutter.appUtils.InsertAlbums
import `in`.photomall.photomall_flutter.database.DbHelper
import `in`.photomall.photomall_flutter.model.api.eventAlbums.EventAlbumImagesResult
import `in`.photomall.photomall_flutter.retrofitHelper.APICall
import `in`.photomall.photomall_flutter.retrofitHelper.APIListener
import `in`.photomall.photomall_flutter.utils.Others
import com.google.common.util.concurrent.ListenableFuture
import android.annotation.SuppressLint
import android.content.Context
import androidx.work.Data
import androidx.work.ListenableWorker
import androidx.work.WorkerParameters
import androidx.work.impl.utils.futures.SettableFuture
import com.google.gson.Gson
import java.io.File

class UpdateAlbumImagesWorker(context: Context, params: WorkerParameters) : ListenableWorker(context, params) {


    var mContext: Context? = null
    var dbHelper: DbHelper? = null
    var mFuture:SettableFuture<Result>?=null

    init {
        mContext = context
        dbHelper = DbHelper.getInstance(mContext!!)

    }


    @SuppressLint("RestrictedApi")
    override fun startWork(): ListenableFuture<Result> {

        val mApplicationContext = applicationContext
        //val projectFolder = File(mApplicationContext.getExternalFilesDir(null)?.absolutePath, mApplicationContext.getString(R.string.main_folder_name))
        val projectFolder = File("${applicationContext.applicationInfo.dataDir}/app_flutter")

         mFuture = SettableFuture.create<Result>()

        try {
            Others.DLog("UpdateEventDetailsWorker 1", "UpdateEventDetailsWorker")
            val hashMap = HashMap<String, String>()
            hashMap.put(Api.KEY_ALBUM_ID, inputData.getInt(Api.KEY_ALBUM_ID, 0).toString())
            hashMap.put(Api.KEY_LAST_UPDATED_AT, inputData.getString(Api.LAST_UPDATED_AT).toString())
            APICall(applicationContext).APIRequest(ApiUrls.UPDATE_ALBUM, hashMap, EventAlbumImagesResult::class.java, object : APIListener {
                
                override fun onSuccess(from: Int, response: Any) {
                    val result =/* (response as EventAlbumImagesResult).data.album*/Gson().toJson(response)

                    if (Others.isAvailableExternalMemorySize(applicationContext, InsertAlbums.getAlbumSize(result))) {
                        InsertAlbums.updateAlbumImages(result, dbHelper!!, projectFolder)
                        setFutureResponse(1)
                    } else {
                        // insufficient storage
                        setFutureResponse(4)
                    }
                }

                override fun onFailure(from: Int, response: Any) {
                    setFutureResponse(2)
                }

                override fun onNetworkFailure(from: Int) {//304
                    setFutureResponse(3)
                }

            }, 1, "", false)

            return mFuture as ListenableFuture<Result>

        } catch (e: Exception) {
            Others.DLog("UpdateEventDetailsWorker 2", "${e.message}")

            mFuture!!.set(Result.failure())
            return mFuture as ListenableFuture<Result>
        }
    }

    fun createAlbumOutputData(data:Int):Data{
        return Data.Builder()
                .putInt(Api.UPDATE_ALBUM_WORKER_OUTPUT_DATA, data)
                .build()
    }

    @SuppressLint("RestrictedApi")
    fun setFutureResponse(from:Int){
        mFuture!!.set(Result.success(createAlbumOutputData(from)))
    }

}