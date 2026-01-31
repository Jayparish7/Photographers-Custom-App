package `in`.photomall.photomall_flutter.utils

import `in`.photomall.photomall_flutter.R
import `in`.photomall.photomall_flutter.utils.EncryptAndDecryptFiles.decodeFile
import `in`.photomall.photomall_flutter.utils.EncryptAndDecryptFiles.encodeFile
import `in`.photomall.photomall_flutter.utils.EncryptAndDecryptFiles.getKeyFromJNI
import `in`.photomall.photomall_flutter.view.activity.MainActivity
import android.content.Context
import android.util.Log
import java.io.BufferedOutputStream
import java.io.File
import java.io.FileOutputStream

object StorageUtils {
    var enableEncrypt = false
    fun getFile(context: Context, fileName: String): File {
        //return File(context.getExternalFilesDir(null)?.toString(), context.getString(R.string.main_folder_name) + "/" + fileName)
        //return File(context.dataDir.absolutePath, "/$fileName")
        //File("")
        /*val imageName = fileName.substring(0, fileName.lastIndexOf("."))
        val imageExtension = fileName.substring(fileName.lastIndexOf("."), fileName.length)
        var fileName1 = "$imageName$imageExtension"
        Log.e("StorageUtils ", "getFile :: ${context.applicationContext.applicationInfo.dataDir}/app_flutter/$fileName1")
        return File("${context.applicationContext.applicationInfo.dataDir}/app_flutter" + "/" + fileName1)*/
        //Log.e("StorageUtils ", "getFile :: ${context.applicationContext.applicationInfo.dataDir}/app_flutter/$fileName1")
        //return File("${context.applicationContext.applicationInfo.dataDir}/app_flutter" + "/" + fileName1)
        return File(getCacheFolder(context), fileName)
    }

    fun getFileAsBytes(context: Context, fileName: String): ByteArray {
        val imageName = fileName.substring(0, fileName.lastIndexOf("."))
        val imageExtension = fileName.substring(fileName.lastIndexOf("."), fileName.length)
        var fileName1 = "$imageName$imageExtension"
        return if (enableEncrypt) {
            decodeFile(
                getKeyFromJNI(context),
                EncryptAndDecryptFiles.readFile(File("${context.applicationContext.applicationInfo.dataDir}/app_flutter" + "/" + fileName1))
            )
        } else {
            File("${context.applicationContext.applicationInfo.dataDir}/app_flutter" + "/" + fileName1).readBytes()
        }
        //return decodeFile(File("${context.applicationContext.applicationInfo.dataDir}/app_flutter" + "/" + fileName1).readBytes(), context)
    }

    fun saveFile(context: Context, fileName: String, byteArray: ByteArray) {
        val file =
            File("${context.applicationContext.applicationInfo.dataDir}/app_flutter" + "/" + fileName)
        val bos = BufferedOutputStream(FileOutputStream(file))
        val filesBytes =
            if (enableEncrypt) encodeFile(getKeyFromJNI(context), byteArray) else byteArray
        //val filesBytes = byteArray
        bos.write(filesBytes)
        bos.flush()
        bos.close()
    }

    fun getThumbFile(context: Context, fileName: String): File {
        return File(
            context.getExternalFilesDir(null).toString(),
            context.getString(R.string.main_folder_name) + "/thumb/" + fileName
        )
    }

    fun getCacheFolder(context: Context): File {
        return File(
            context.cacheDir?.toString(),
            MainActivity.studioId
        )
       /* return File(
            context.getExternalFilesDir(null)?.toString(),
            context.getString(R.string.main_folder_name)
        )*/
    }

}