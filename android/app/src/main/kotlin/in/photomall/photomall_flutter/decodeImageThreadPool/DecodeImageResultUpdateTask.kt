package com.photomall.photoalbum.photomallUser.decodeImageThreadPool

import android.graphics.Bitmap


//class DecodeImageResultUpdateTask(var listener: DecodeImageResultUpdateTaskListener) : Runnable {
//
//    private var imageName: String? = null
//    private var imageBitmap: Bitmap? = null
//
//    fun setImageBitmap(imageName: String, imageBitmap: Bitmap) {
//        this.imageName = imageName
//        this.imageBitmap = imageBitmap
//    }
//
//    override fun run() {
//        if (listener != null) {
//            if (imageBitmap != null) {
//                listener.setDecodedImageInBitmap(imageName!!, imageBitmap!!)
//            }
//        }
//    }
//}
//
//interface DecodeImageResultUpdateTaskListener {
//    fun setDecodedImageInBitmap(imageName: String, bitmap: Bitmap)
//}