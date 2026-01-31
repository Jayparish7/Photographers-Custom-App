package `in`.photomall.photomall_flutter.appUtils.memoryManagement

import `in`.photomall.photomall_flutter.utils.Others.DLog
import android.app.ActivityManager
import android.content.Context
import android.content.Context.ACTIVITY_SERVICE
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import java.io.File

object MemUtils {

    val BYTES_IN_MB = 1024.0F * 1024.0F

    val BYTES_PER_PX = 4.0F

    fun megaBytesFree(): Float {
        val rt = Runtime.getRuntime()
        val bytesUsed = rt.totalMemory()
        val mbUsed = bytesUsed / BYTES_IN_MB
        val mbFree = megaBytesAvailable() - mbUsed
        return mbFree
    }

    private fun showAvailableMemory(context: Context) {
        val mi = ActivityManager.MemoryInfo()
        val activityManager: ActivityManager? = context.getSystemService(ACTIVITY_SERVICE) as ActivityManager?
        activityManager!!.getMemoryInfo(mi)
        val availableMegs: Long = mi.availMem / 1048576L
        DLog("MemUtils: ", "Available memory = $availableMegs MB")
    }

    fun calculateHeapMemory(): Long {
        val runtime = Runtime.getRuntime()
        val maxMemory = runtime.maxMemory()

        // Getting how much of the heap your app currently uses:
        val usedMemory = runtime.totalMemory() - runtime.freeMemory()

        // Getting how much of the heap your app can now use (available memory) :
        val availableMemory = maxMemory - usedMemory

        DLog("MemUtils(): ", "calculateHeapMemory() MAX: ${maxMemory / BYTES_IN_MB} :: TOTAL: ${runtime.totalMemory() / BYTES_IN_MB} :: USED: ${usedMemory / BYTES_IN_MB} :: AVAILABLE: ${availableMemory / BYTES_IN_MB} :: FREE: ${runtime.freeMemory() / BYTES_IN_MB}")

        //return runtime.freeMemory()
        return availableMemory

    }

    fun megaBytesAvailable(): Float {
        val rt = Runtime.getRuntime()
        val bytesAvailable = rt.maxMemory()
        return bytesAvailable / BYTES_IN_MB
    }

    fun readBitmapInFo(file: File): Float {
        val options = BitmapFactory.Options()
        options.inJustDecodeBounds = true
        BitmapFactory.decodeFile(file.absolutePath, options)
        val imageHeight = options.outHeight
        val imageWidth = options.outWidth
        return imageWidth * imageHeight * BYTES_PER_PX / BYTES_IN_MB
    }

    fun subSampleImage(powerOf2: Int, file: File): Bitmap? {
        if (powerOf2 < 1 || powerOf2 > 32) {
            //return
        }
        val options = BitmapFactory.Options()
        options.inJustDecodeBounds = false
        options.inSampleSize = powerOf2
        val bmp = BitmapFactory.decodeFile(file.absolutePath)
        return bmp
    }



}