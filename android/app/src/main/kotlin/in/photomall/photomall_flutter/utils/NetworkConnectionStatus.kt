package `in`.photomall.photomall_flutter.utils

import `in`.photomall.photomall_flutter.retrofitHelper.APICall
import android.content.Context
import android.net.ConnectivityManager

/**
 * Created by UmaShankar on 28-09-2016.
 */
/*object NetworkConnectionStatus {

    fun Connected(context: Context): Boolean {

        val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val networkInfo = cm.activeNetworkInfo
        *//*boolean wifi = networkInfo.getType() == ConnectivityManager.*//*
        return networkInfo != null && networkInfo.isConnected && networkInfo.isAvailable
    }
}*/
object Network_check {

    //companion object {
        var apicall : APICall? =null
        fun isNetworkAvailable(context: Context): Boolean {
            var networkavailable = false


            try {
                val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
                val activeNetworkInfo = connectivityManager.activeNetworkInfo

                if (connectivityManager != null && activeNetworkInfo != null && activeNetworkInfo.isConnectedOrConnecting) {
                    networkavailable = true
                } else {
                    networkavailable = false
                    apicall?.showNetworkError()
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }

            return networkavailable
        }
    //}
}