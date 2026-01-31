package `in`.photomall.photomall_flutter.utils

import `in`.photomall.photomall_flutter.api.ApiUrls
import `in`.photomall.photomall_flutter.retrofitHelper.APICall
import `in`.photomall.photomall_flutter.retrofitHelper.APIListener
import android.content.Context
import java.util.HashMap

class NotifyToSlack(var context: Context, var hashMap: HashMap<String, String>) {
    fun execute() {
        /*val hashMap = HashMap<String, String>()
        hashMap[Api.TYPE] = WebConstants.ERROR_IN_TRUE_CALLER*/
        APICall(context).APIRequest(ApiUrls.SLACK_NOTIFICATION, hashMap, SlackNotificationResponse::class.java, object :
            APIListener {
            override fun onSuccess(from: Int, response: Any) {}
            override fun onFailure(from: Int, response: Any) {}
            override fun onNetworkFailure(from: Int) {}
        }, 1, "", false)
    }
}

data class SlackNotificationResponse(var data: Any)