package `in`.photomall.photomall_flutter.threadPool

import android.graphics.Bitmap

class DownloadResultUpdateTask(var listener: DownloadResultUpdateTaskListener) : Runnable {

    private var imageUrl: String? = null
    private var imageBitmap: Bitmap? = null
    private var imageType: Int? = null

    fun setImageUrl(imageUrl: String, bmp: Bitmap, imageType: Int) {
        this.imageUrl = imageUrl
        this.imageBitmap = bmp
        this.imageType = imageType
    }

    override fun run() {
        if (listener != null) {
            if (imageUrl != null) {
                listener.setPercent(imageUrl!!, imageBitmap!!, imageType!!)
            }
        }
    }
}

interface DownloadResultUpdateTaskListener {
    fun setPercent(imageUrl: String, imageBitmap: Bitmap, imageType: Int)
}