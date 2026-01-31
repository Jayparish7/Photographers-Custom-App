package `in`.photomall.photomall_flutter.utils.bitmapHandler

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.BitmapDrawable
import android.os.Build
import android.util.LruCache
import java.lang.ref.SoftReference
import java.util.*
import kotlin.collections.HashSet

class DecodeBitmap {
    var reusableBitmaps: MutableSet<SoftReference<Bitmap>>? = null
    private lateinit var memoryCache: LruCache<String, BitmapDrawable>
// If you're running on Honeycomb or newer, create a
// synchronized HashSet of references to reusable bitmaps.

    init {
        //if (Utils.hasHoneycomb()) {
        reusableBitmaps = Collections.synchronizedSet(HashSet<SoftReference<Bitmap>>())
        // }

        val maxMemory = (Runtime.getRuntime().maxMemory() / 1024).toInt()

        // Use 1/8th of the available memory for this memory cache.
        val cacheSize = maxMemory / 8

        memoryCache = object : LruCache<String, BitmapDrawable>(cacheSize) {

            // Notify the removed entry that is no longer being cached.
            override fun entryRemoved(
                    evicted: Boolean,
                    key: String,
                    oldValue: BitmapDrawable,
                    newValue: BitmapDrawable
            ) {
                if (oldValue is RecyclingBitmapDrawable) {
                    // The removed entry is a recycling drawable, so notify it
                    // that it has been removed from the memory cache.
                    oldValue.setIsCached(false)
                } else {
                    // The removed entry is a standard BitmapDrawable.
                   // if (Utils.hasHoneycomb()) {
                    // We're running on Honeycomb or later, so add the bitmap
                    // to a SoftReference set for possible use with inBitmap later.
                    reusableBitmaps?.add(SoftReference(oldValue.bitmap))
                    //}
                }
            }
        }
    }

    /*private fun addInBitmapOptions(options: BitmapFactory.Options, cache: ImageCache1?) {
        // inBitmap only works with mutable bitmaps, so force the decoder to
        // return mutable bitmaps.
        options.inMutable = true

        // Try to find a bitmap to use for inBitmap.
        cache?.getBitmapFromReusableSet(options)?.also { inBitmap ->
            // If a suitable bitmap has been found, set it as the value of
            // inBitmap.
            options.inBitmap = inBitmap
        }
    }*/

    // This method iterates through the reusable bitmaps, looking for one
// to use for inBitmap:
    fun getBitmapFromReusableSet(options: BitmapFactory.Options): Bitmap? {
        reusableBitmaps?.takeIf { it.isNotEmpty() }?.let { reusableBitmaps ->
            synchronized(reusableBitmaps) {
                val iterator: MutableIterator<SoftReference<Bitmap>> = reusableBitmaps.iterator()
                while (iterator.hasNext()) {
                    iterator.next().get()?.let { item ->
                        if (item.isMutable) {
                            // Check to see it the item can be used for inBitmap.
                            if (canUseForInBitmap(item, options)) {
                                // Remove from reusable set so it can't be used again.
                                iterator.remove()
                                return item
                            }
                        } else {
                            // Remove from the set if the reference has been cleared.
                            iterator.remove()
                        }
                    }
                }
            }
        }
        return null
    }




    private fun canUseForInBitmap(candidate: Bitmap, targetOptions: BitmapFactory.Options): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            // From Android 4.4 (KitKat) onward we can re-use if the byte size of
            // the new bitmap is smaller than the reusable bitmap candidate
            // allocation byte count.
            val width: Int = targetOptions.outWidth / targetOptions.inSampleSize
            val height: Int = targetOptions.outHeight / targetOptions.inSampleSize
            val byteCount: Int = width * height * getBytesPerPixel(candidate.config ?: Bitmap.Config.ARGB_8888)
            byteCount <= candidate.allocationByteCount
        } else {
            // On earlier versions, the dimensions must match exactly and the inSampleSize must be 1
            candidate.width == targetOptions.outWidth
                    && candidate.height == targetOptions.outHeight
                    && targetOptions.inSampleSize == 1
        }
    }

    /**
     * A helper function to return the byte usage per pixel of a bitmap based on its configuration.
     */
    private fun getBytesPerPixel(config: Bitmap.Config): Int {
        return when (config) {
            Bitmap.Config.ARGB_8888 -> 4
            Bitmap.Config.RGB_565, Bitmap.Config.ARGB_4444 -> 2
            Bitmap.Config.ALPHA_8 -> 1
            else -> 1
        }
    }



}