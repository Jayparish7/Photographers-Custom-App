package `in`.photomall.photomall_flutter.utils

import `in`.photomall.photomall_flutter.model.other.ConnectionModel
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.net.ConnectivityManager.TYPE_WIFI
import android.net.ConnectivityManager.CONNECTIVITY_ACTION
import android.net.NetworkInfo
import androidx.lifecycle.LiveData

class NetworkConnectionLiveData(private val context: Context) : LiveData<ConnectionModel>() {

    private val networkReceiver = object : BroadcastReceiver() {

        override fun onReceive(context: Context, intent: Intent) {
            if (intent.getExtras() != null) {
                val activeNetwork = intent.extras!!.get(ConnectivityManager.EXTRA_NETWORK_INFO) as NetworkInfo
                val isConnected = activeNetwork != null && activeNetwork!!.isConnectedOrConnecting
                if (isConnected) {
                    when (activeNetwork!!.getType()) {
                        ConnectivityManager.TYPE_WIFI -> postValue(ConnectionModel(TYPE_WIFI, true))
                        ConnectivityManager.TYPE_MOBILE -> postValue(ConnectionModel(ConnectivityManager.TYPE_MOBILE, true))
                    }
                } else {
                    postValue(ConnectionModel(0, false))
                }
            }
        }
    }

    override fun onActive() {
        super.onActive()
        val filter = IntentFilter(CONNECTIVITY_ACTION)
        context.registerReceiver(networkReceiver, filter)
    }

    override fun onInactive() {
        super.onInactive()
        context.unregisterReceiver(networkReceiver)
    }
}