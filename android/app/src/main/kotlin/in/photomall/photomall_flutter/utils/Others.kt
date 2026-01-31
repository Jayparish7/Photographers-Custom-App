package `in`.photomall.photomall_flutter.utils

import `in`.photomall.photomall_flutter.R
import `in`.photomall.photomall_flutter.api.AppConst
import `in`.photomall.photomall_flutter.api.AppConst.PLAY_STORE_LINK_1
import `in`.photomall.photomall_flutter.api.AppConst.PLAY_STORE_LINK_2
import `in`.photomall.photomall_flutter.api.CommonConst
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Typeface
import android.net.Uri
import android.os.Build
import android.os.StatFs
import android.util.DisplayMetrics
import android.util.Log
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.snackbar.Snackbar
import java.io.File
import java.text.SimpleDateFormat
import java.util.*


/**
 * Created by prandex-and-05 on 23/4/18.
 */


object Others {

    fun DLog(tag: String, message: String) {
        if (true) {
            Log.e(tag, message)
            /*Log.v(tag, message)
            Log.d(tag, message)
            Log.i(tag, message)*/

        }
    }

    fun getImageName(imageNameWithExtension: String): String {
        return File(imageNameWithExtension).nameWithoutExtension
    }

    fun showNormalSnackBar(mContext: Context, message: String) {
        //snackbar((mContext as Activity).findViewById(android.R.id.content), message)
        //Snackbar()
        //snackbar((mContext as Activity).findViewById(R.id.content), message)
        Snackbar.make((mContext as Activity).findViewById(android.R.id.content), message, Snackbar.LENGTH_SHORT).show()
    }

    fun showAlertSnackBar(mContext: Context, message: String) {
        val snackbar = Snackbar.make((mContext as Activity).findViewById(android.R.id.content), message, Snackbar.LENGTH_LONG)
        val snackbarLayout = snackbar.view
        val textView = snackbarLayout.findViewById(com.google.android.material.R.id.snackbar_text) as TextView
        textView.setCompoundDrawablesWithIntrinsicBounds(R.drawable.ic_warning_white_24dp, 0, 0, 0)
        textView.compoundDrawablePadding = 30
        snackbar.show()
    }
    
    fun openPlayStoreApp(context: Context) {
        try {
            context.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(PLAY_STORE_LINK_1 + context.packageName)))
        } catch (error: android.content.ActivityNotFoundException) {
            context.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(PLAY_STORE_LINK_2 + context.packageName)))
        }
    }

    fun isAvailableStorageSpace(context: Context) {
        val externalStorageDir = context.getExternalFilesDir(null)
        val statFs = StatFs(externalStorageDir!!.absolutePath)
        val blocks = statFs.availableBlocks.toLong()
        val free = blocks * statFs.blockSize / 1024 / 1024
    }

    fun isAvailableExternalMemorySize(context: Context, albumSize1: Long): Boolean {
        //val albumSize = albumSize1 + 5242880
        val albumSize = (albumSize1 * 2) + (50 * 1024 * 1024)
        //val albumSize = albumSize1 + (230 * 1024 * 1024)
        DLog("others : ", "inside isAvailableExternalMemorySize ORIGINAL: ${(albumSize1 / 1024) / 1024} MB")
        try {
            //val path = context.getExternalFilesDir(null)?.toString()
            val path = context.applicationContext.applicationInfo.dataDir
            val stat = StatFs(path)
            var blockSize: Long? = null
            var availableBlocks: Long? = null
            if (android.os.Build.VERSION.SDK_INT >= 18) {
                blockSize = stat.blockSizeLong
                availableBlocks = stat.availableBlocksLong
            } else {
                blockSize = stat.availableBlocks.toLong()
                availableBlocks = stat.blockSize.toLong()
            }
            val spaceInKB = formatSize(availableBlocks * blockSize)
            //spaceInKB += 1024

            DLog("Others : ", "isAvailableExternalMemorySize: (NEEDED) AlbumSize: ${(albumSize / 1024) / 1024} MB , FreeSpace: ${spaceInKB / 1024} MB")
            return albumSize / 1024 < spaceInKB
        } catch (e: NullPointerException) {
        }
        return true
    }

    fun isAbleToViewAlbumWithOriginalImages(context: Context, albumSize1: Int): Boolean {
        val albumSize = (albumSize1 * 2)
        try {
            //val path = context.getExternalFilesDir(null)?.toString()
            val path = context.applicationContext.applicationInfo.dataDir
            val stat = StatFs(path)
            var blockSize: Long? = null
            var availableBlocks: Long? = null
            if (android.os.Build.VERSION.SDK_INT >= 18) {
                blockSize = stat.blockSizeLong
                availableBlocks = stat.availableBlocksLong
            } else {
                blockSize = stat.availableBlocks.toLong()
                availableBlocks = stat.blockSize.toLong()
            }
            val spaceInKB = formatSize(availableBlocks * blockSize)
            //spaceInKB += 1024
            DLog("Others : ", "isAvailableExternalMemorySize: (NEEDED) AlbumSize: ${(albumSize / 1024) / 1024} MB , FreeSpace: ${spaceInKB / 1024} MB")
            return albumSize / 1024 < spaceInKB
        } catch (e: NullPointerException) {
        }
        return true
    }

    fun externalMemoryAvailable(context: Context): Boolean {
        return android.os.Environment.getExternalStorageState() == android.os.Environment.MEDIA_MOUNTED
    }

    fun formatSize(size: Long): Long {
        var size = size
        //var suffix: String? = null
        if (size >= 1024) {
            //suffix = "KB"
            size /= 1024
            /* if (size >= 1024) {
                 suffix = "MB"
                 size /= 1024
             }*/
        }
        /*val resultBuffer = StringBuilder(java.lang.Long.toString(size))
        var commaOffset = resultBuffer.length - 3
        while (commaOffset > 0) {
            resultBuffer.insert(commaOffset, ',')
            commaOffset -= 3
        }*/
        /*if (suffix != null) resultBuffer.append(suffix)
        return resultBuffer.toString()*/
        return size
    }

    fun getCurrentDate(): String {
        val sdf = SimpleDateFormat("yyyyMMdd")
        return sdf.format(Date())
    }

    fun getVersionName(mContext: Context): String {
        var version = ""
        try {
            val pInfo = mContext.packageManager.getPackageInfo(mContext.packageName, 0)
            version = pInfo.versionName ?: "1.0.0"
        } catch (e: PackageManager.NameNotFoundException) {
            e.printStackTrace()
        }
        return version
    }

    fun getVersionCode(mContext: Context): String {
        val mpackageManager = mContext.packageManager.getPackageInfo(mContext.packageName, 0)
        var versionCode: Int = 0
        try {
            versionCode = if (Build.VERSION.SDK_INT >= 28) {
                mpackageManager.longVersionCode.toInt() // avoid huge version numbers and you will be ok
            } else {
                mpackageManager.versionCode
            }
        } catch (e: java.lang.Exception) {
        }
        return versionCode.toString()

    }

    fun getResizedBitmap(bitmap: Bitmap, activity: AppCompatActivity): Bitmap {
        val metrics = DisplayMetrics()
        activity.getWindowManager().getDefaultDisplay().getMetrics(metrics)
        val screenWidth = metrics.widthPixels
        val screenHeight = metrics.heightPixels
        return Bitmap.createScaledBitmap(bitmap, screenWidth, screenHeight, true)
    }

    fun setFontAwesomeIcon(context: Context): Typeface {
        return Typeface.createFromAsset(context.getAssets(), "fonts/fontawesome.ttf")
    }

    fun getPublicUrlForGallery(albumCode: String, image: String): String {
        return "${AppConst.STORAGE_URL}${CommonConst.STUDIO_RANDOM_ID}/${albumCode}/images/original/others/${image}"
    }

    //showNormalSnackbar
    fun showNormalSnackbar(mContext: Context, message: String) {
        //snackbar((mContext as Activity).findViewById(android.R.id.content), message)
        //Snackbar()
        //snackbar((mContext as Activity).findViewById(R.id.content), message)
        Snackbar.make((mContext as Activity).findViewById(android.R.id.content), message, Snackbar.LENGTH_SHORT).show()
    }

    fun showAlertSnackbar(mContext: Context, message: String) {
        val snackbar = Snackbar.make((mContext as Activity).findViewById(android.R.id.content), message, Snackbar.LENGTH_LONG)
        val snackbarLayout = snackbar.view
        val textView = snackbarLayout.findViewById(com.google.android.material.R.id.snackbar_text) as TextView
        textView.setCompoundDrawablesWithIntrinsicBounds(R.drawable.ic_warning_white_24dp, 0, 0, 0)
        textView.compoundDrawablePadding = 30
        snackbar.show()
    }

    
    

    
}
