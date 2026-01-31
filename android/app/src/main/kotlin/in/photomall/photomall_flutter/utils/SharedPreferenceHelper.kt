package `in`.photomall.photomall_flutter.utils

import `in`.photomall.photomall_flutter.api.Api
import android.content.Context
import android.content.SharedPreferences

/**
 * Created by Jovee-2 on 04-Jul-17.
 */

class SharedPreferenceHelper {
    companion object {

        fun getStringPreference(context: Context, key: String, defaultTest: String): String? {
            return getPreference(context).getString("flutter.$key", defaultTest)
        }

        fun setStringPreference(context: Context, key: String, value: String) {
            getPreference(context).edit().putString("flutter.$key", value).apply()
        }

        fun getBooleanPreference(context: Context, key: String, default_value: Boolean?): Boolean {
            return getPreference(context).getBoolean("flutter.$key", default_value!!)
        }

        fun setBooleanPreference(context: Context, key: String, value: Boolean?) {
            getPreference(context).edit().putBoolean("flutter.$key", value!!).apply()
        }

        fun getIntPreference(context: Context, key: String): Int {
            return getPreference(context).getInt("flutter.$key", 0)
        }

        fun setIntPreference(context: Context, key: String, value: Int) {
            getPreference(context).edit().putInt("flutter.$key", value).apply()
        }

        fun getLongPreference(context: Context, key: String): Long {
            return getPreference(context).getLong("flutter.$key", 0)
        }

        fun setLongPreference(context: Context, key: String, value: Long) {
            getPreference(context).edit().putLong("flutter.$key", value).apply()
        }

        private fun getPreference(context: Context): SharedPreferences {
            return context.getSharedPreferences(Api.SHARED_PREFERENCE_NAME, Context.MODE_PRIVATE)
        }

        fun removeKey(context: Context, key: String) {// remove sharedpreference after logout
            getPreference(context).edit().remove("flutter.$key").apply()
        }

        fun getDefaultSharedPreferences(context: Context): SharedPreferences {
            return context.getSharedPreferences(getDefaultSharedPreferencesName(context),
                    getDefaultSharedPreferencesMode())
        }

        private fun getDefaultSharedPreferencesName(context: Context): String {
            return context.packageName + "_preferences"
        }

        private fun getDefaultSharedPreferencesMode(): Int {
            return Context.MODE_PRIVATE
        }
    }

}
