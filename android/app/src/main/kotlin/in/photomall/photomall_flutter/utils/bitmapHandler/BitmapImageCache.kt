package `in`.photomall.photomall_flutter.utils.bitmapHandler

import `in`.photomall.photomall_flutter.utils.Others.DLog
import android.graphics.Bitmap

class BitmapImageCache {
    private var imagesWarehouse: androidx.collection.LruCache<String, Bitmap>? = null

    fun initializeCache() {
        //val maxMemory = (Runtime.getRuntime().maxMemory() / 1024).toInt()

        val maxMemory = 1024 * 1024 * 30

        val cacheSize = maxMemory / 1

        DLog("BitmapImageCache :","cache size = $cacheSize : ${Runtime.getRuntime().maxMemory()}")

        imagesWarehouse = object : androidx.collection.LruCache<String, Bitmap>(cacheSize) {
            override fun sizeOf(key: String, value: Bitmap): Int {
                // The cache size will be measured in kilobytes rather than number of items.

                val bitmapByteCount = value.rowBytes * value.height

                return bitmapByteCount / 1024
            }
        }
    }

    fun addImageToWarehouse(key: String, value: Bitmap) {
        DLog("BitmapImageCache :","imageUrl = $value")
        if (imagesWarehouse != null && imagesWarehouse!!.get(key) == null) {
            DLog("BitmapImageCache :","imageUrl1 = $value")
            imagesWarehouse!!.put(key, value)
        }
    }

    fun getImageFromWarehouse(key: String?): Bitmap? {
        return if (key != null) {
            DLog("BitmapImageCache :","getImageFromWarehouse if = $key")
            imagesWarehouse!!.get(key)
        } else {
            DLog("BitmapImageCache :","getImageFromWarehouse if else = $key")
            null
        }
    }

    fun removeImageFromWarehouse(key: String) {
        imagesWarehouse!!.remove(key)
    }

    fun clearCache() {
        if (imagesWarehouse != null) {
            imagesWarehouse!!.evictAll()
        }
    }

    companion object {

        private var cache: BitmapImageCache? = null

        val instance: BitmapImageCache
            get() {
                if (cache == null) {
                    cache = BitmapImageCache()
                }

                return cache!!
            }
    }

}