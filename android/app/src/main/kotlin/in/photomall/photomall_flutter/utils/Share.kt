package `in`.photomall.photomall_flutter.utils

import `in`.photomall.photomall_flutter.R
import `in`.photomall.photomall_flutter.api.AppConst
import `in`.photomall.photomall_flutter.api.CommonConst.IS_PHOTOMALL_APP
import `in`.photomall.photomall_flutter.api.SharedPreferenceConst
import `in`.photomall.photomall_flutter.database.DbHelper
import `in`.photomall.photomall_flutter.utils.Others.DLog
import android.app.Activity
import android.content.Context
import androidx.core.app.ShareCompat

object Share {

    fun event(activity: Activity, mContext: Context, eventUrl: String, eventName: String) {
        val dbHelper = DbHelper(mContext)

        val isReadyForShareAlbum = dbHelper.isReadyForShareAlbum(eventUrl)
        //val eventStudioRandomUrl = dbHelper.getStudioRandomUrl(eventUrl)
        val eventStudioRandomUrl = ""

        //DLog("EventURlShare", "$eventStudioRandomUrl -- $eventUrl -- $eventId")
        val isUserLogin = SharedPreferenceHelper.getBooleanPreference(mContext, SharedPreferenceConst.IS_USER_LOGIN, false)

        when {
            isUserLogin -> {
                shareLinkForEvent(activity, mContext, mContext.getString(R.string.is_on_1)+" "+mContext.getString(R.string.app_name)+" "+mContext.getString(R.string.share_album_content_if_login_1), eventUrl, "/$eventStudioRandomUrl", eventName)
            }
            isReadyForShareAlbum -> {
                shareLinkForEvent(activity, mContext, mContext.getString(R.string.i_am_on_1)+" "+mContext.getString(R.string.app_name)+" "+mContext.getString(R.string.share_album_content_if_not_login_1), eventUrl, "/$eventStudioRandomUrl", eventName)
            }
//            else -> {
//                CustomToast.alert(mContext, mContext.getString(R.string.login_to_share_your_album))
//                val loginIntent = Intent(mContext, UserLoginActivity::class.java)
//                mContext.startActivity(loginIntent)
//            }
        }
    }

    fun shareLinkForEvent(activity: Activity, mContext: Context, shareContent: String, eventUrl: String, studioRandomUrl: String, eventName: String) {

        DLog("EventURlShare", "${studioRandomUrl}")
        var mStudioRandomUrl: String? = null
        if (IS_PHOTOMALL_APP) {
            if (studioRandomUrl.equals("/")) {
                mStudioRandomUrl = mContext.getString(R.string.path_prefix)
            } else {
                mStudioRandomUrl = studioRandomUrl
            }
        } else {
            mStudioRandomUrl = mContext.getString(R.string.path_prefix)
        }
        val name = SharedPreferenceHelper.getStringPreference(mContext, SharedPreferenceConst.USER_NAME, "")
        /* ShareCompat.IntentBuilder.from(activity)
                 .setType("text/plain")
                 .setChooserTitle("Share with")
                 .setText(name + " " + shareContent + " ${AppConst.SHARE_ALBUM_LINK}${mStudioRandomUrl}/$eventUrl" +" "+mContext.resources.getString(R.string.enter_event_url) +" ${eventUrl}" )
                 .startChooser()*/

        ShareCompat.IntentBuilder.from(activity)
            .setType("text/plain")
            .setChooserTitle("Share with")
            .setText(String.format(mContext.resources.getString(R.string.android_app_share_link), eventName)+" "+ getAppPlayStoreLink(mContext,mStudioRandomUrl!!) +" "+mContext.resources.getString(R.string.event_key_share_content)+" $eventUrl " +mContext.resources.getString(R.string.share_content_common)+" ${AppConst.SHARE_ALBUM_LINK}${mStudioRandomUrl}/$eventUrl .")
            .startChooser()

        DLog("ShareLink", " ${AppConst.SHARE_ALBUM_LINK}${mStudioRandomUrl}/$eventUrl")
    }

    fun app(activity: Activity, context: Context) {

        ShareCompat.IntentBuilder.from(activity)
            .setType("text/plain")
            .setChooserTitle("Share with")
            .setText(context.getString(R.string.share_app_info)+" - "+ AppConst.PLAY_STORE_LINK_2 + activity.packageName)
            .startChooser()

        /* if (SharedPreferenceHelper.getBooleanPreference(context, SharedPreferenceConst.IS_USER_LOGIN, false)) {
             val name = SharedPreferenceHelper.getStringPreference(context, SharedPreferenceConst.USER_NAME, "")
             ShareCompat.IntentBuilder.from(activity)
                     .setType("text/plain")
                     .setChooserTitle("Share with")
                     .setText(name +" "+context.getString(R.string.is_on_1)+" "+context.getString(R.string.app_name)+" "+context.getString(R.string.share_app_content_if_login_1) +" "+ AppConst.PLAY_STORE_LINK_2 + activity.packageName)
                     .startChooser()
         } else {
             ShareCompat.IntentBuilder.from(activity)
                     .setType("text/plain")
                     .setChooserTitle("Share with")
                     .setText(context.getString(R.string.i_am_on_1)+" "+context.getString(R.string.app_name)+" "+context.getString(R.string.share_app_content_if_not_login_1) +" "+ AppConst.PLAY_STORE_LINK_2 + activity.packageName)
                     .startChooser()
         }*/

    }

    fun playStoreLink(context:Context):String{
        return AppConst.PLAY_STORE_LINK_2+context.packageName
    }

    fun getAppPlayStoreLink(context: Context,studioShortUrl:String):String{ //short play store link
        return "${AppConst.SHARE_ALBUM_LINK}${studioShortUrl}/${context.resources.getString(R.string.app_download)}"

    }
}