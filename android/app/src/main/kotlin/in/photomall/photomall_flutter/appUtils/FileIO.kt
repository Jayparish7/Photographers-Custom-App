package `in`.photomall.photomall_flutter.appUtils

import `in`.photomall.photomall_flutter.R
import `in`.photomall.photomall_flutter.appUtils.memoryManagement.MemUtils
import `in`.photomall.photomall_flutter.utils.Others.DLog
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import java.io.*
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException

object FileIO {

    var decodedBitmap: Bitmap? = null
    
    fun readFile(file: File): ByteArray {
        var contents: ByteArray? = null

        val size = file.length().toInt()
        contents = ByteArray(size)
        try {
            val buf = BufferedInputStream(FileInputStream(file))
            try {
                buf.read(contents)
                buf.close()
            } catch (e: IOException) {
                e.printStackTrace()
            }

        } catch (e: FileNotFoundException) {
            e.printStackTrace()
        }

        return contents
    }

    fun hashKey(key: String): String {
        var cacheKey: String
        try {
            val mDigest = MessageDigest.getInstance("MD5")
            mDigest.update(key.toByteArray())
            cacheKey = bytesToHexString(mDigest.digest())
        } catch (e: NoSuchAlgorithmException) {
            cacheKey = key.hashCode().toString()
        }
        return cacheKey
    }

    private fun bytesToHexString(bytes: ByteArray): String {
        val sb = StringBuilder()
        for (i in bytes.indices) {
            val hex = Integer.toHexString(0xFF and bytes[i].toInt())
            if (hex.length == 1) {
                sb.append('0')
            }
            sb.append(hex)
        }
        return sb.toString()
    }

        fun getBitmapFromFile(file: File, context: Context): Bitmap {
        try {
            //System.gc()
            val decodedData = readFile(file)
            decodedBitmap = BitmapFactory.decodeByteArray(decodedData, 0, decodedData.size)

            val size = (decodedBitmap!!.width * decodedBitmap!!.height * 4)

            if(size >= MemUtils.calculateHeapMemory()){
                DLog("EncryptAndDecryptFiles: ", "decodeFile() if")
                decodedBitmap = BitmapFactory.decodeResource(context.resources, R.drawable.no_memory_available_error)
            } else {
                DLog("EncryptAndDecryptFiles: ", "decodeFile() if else")
            }
            DLog("EncryptAndDecryptFiles: ", "decodeFile() WIDTH: ${decodedBitmap!!.width} :: HEIGHT: ${decodedBitmap!!.height} :: SIZE: ${size / MemUtils.BYTES_IN_MB} :: REMAIN")

            return decodedBitmap!!

        } catch (e: Exception) {
            e.printStackTrace()
        } catch (e: java.lang.OutOfMemoryError) {
            DLog("EncryptAndDecryptFiles: ", "decodeFile() Catch :: OutOfMemoryError")
            return Bitmap.createBitmap(5, 5, Bitmap.Config.ARGB_8888)
        }
        val w = 1
        val h = 1
        val conf = Bitmap.Config.ARGB_8888 // see other conf types
        val bmp = Bitmap.createBitmap(w, h, conf)
        return bmp
    }

}