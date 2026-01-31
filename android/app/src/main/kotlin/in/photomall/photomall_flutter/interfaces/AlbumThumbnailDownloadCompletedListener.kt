package `in`.photomall.photomall_flutter.interfaces

import android.graphics.Bitmap
import android.view.View

/**
 * Created by Jovee-2 on 10-Jul-17.
 */

interface AlbumThumbnailDownloadCompletedListener {

    fun singleImageClickListener(position: Int, imageList: ArrayList<String>)
    fun getBitmapListener(imageUrl: String, imageType: String): Bitmap
    fun deleteImageListener(position: Int,it: View)
}
