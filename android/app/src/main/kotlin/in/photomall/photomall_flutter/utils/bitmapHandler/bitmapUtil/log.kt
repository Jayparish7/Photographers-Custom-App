@file:JvmName("Others")

package `in`.photomall.photomall_flutter.utils.bitmapHandler.bitmapUtil

import `in`.photomall.photomall_flutter.api.AppConst
import android.util.Log

fun log(tag: String, message: String) {
    if (AppConst.IS_LOG_ENABLED) {
        Log.e(tag, message)
    }
}