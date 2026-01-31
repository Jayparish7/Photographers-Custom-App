package com.photomall.photoalbum.photomallUser.decodeImageThreadPool

//import com.photomall.photoalbum.photomallUser.R

//class DecodeImageTask(var mContext: Context, var imageName: String, var file: File,
//                      var resultUpdateTask: DecodeImageResultUpdateTask) : Runnable {
//
//
//    override fun run() {
//
//        val w = 1
//        val h = 1
//
//        val conf = Bitmap.Config.ARGB_8888 // see other conf types
//        val bmp = Bitmap.createBitmap(w, h, conf)
//
//        //var tmp = BitmapFactory.decodeFile(file.absolutePath)
//        //var tmp = decodeFile(file, this)
//        /*bitmapHashMap.put(imageName, bmp)
//        imageCache1?.addBitmapToCache(imageName, tmp)*/
//
//        try {
//            resultUpdateTask.setImageBitmap(imageName, BitmapFactory.decodeResource(mContext.resources,
//                R.drawable.image_load_landscape))
//            //resultUpdateTask.setImageBitmap(imageName, BitmapFactory.decodeFile(file.absolutePath))
//            //resultUpdateTask.setImageBitmap(imageName, decodeFile(file, mContext))
//            //resultUpdateTask.setImageBitmap(imageName, Bitmap.createBitmap(decodeFile(file, mContext)))
//        }catch (e: OutOfMemoryError){
//            resultUpdateTask.setImageBitmap(imageName, bmp)
//        }
//
//        DecodeImageManager.downloadManager!!.mainThreadExecutor
//                ?.execute(resultUpdateTask)
//    }
//}