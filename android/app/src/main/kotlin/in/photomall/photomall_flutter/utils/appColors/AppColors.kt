package `in`.photomall.photomall_flutter.utils.appColors

import `in`.photomall.photomall_flutter.api.SharedPreferenceConst
import `in`.photomall.photomall_flutter.utils.Others.DLog
import `in`.photomall.photomall_flutter.utils.SharedPreferenceHelper
import android.content.Context
import android.graphics.Color
import com.google.gson.Gson

object AppColors {

    private var designDataModel: DesignDataModel? = null

    fun getColor(context: Context, colorName: String): Int {
        return Color.parseColor(colorName)
        if (designDataModel == null) {
            val designData: String? = SharedPreferenceHelper.getStringPreference(
                context,
                SharedPreferenceConst.DESIGN_DATA,
                ""
            )
            DLog("AppColors ", "getColor() :: designData :: $designData")
            if (designData!!.isNotEmpty()) {
                designDataModel = Gson().fromJson(
                    designData.toString(),
                    DesignDataModel::class.java
                ) as DesignDataModel
            }
        }
        return Color.parseColor(AppColorConstants.defaultColorsMap[colorName]!!)
        if (designDataModel != null) {
            val colorData: AppColor? =
                designDataModel!!.data!!.app_colors!!.filter { it!!.type == 1 }
                    .firstOrNull { it!!.name == colorName }
            return if (colorData != null) {
                Color.parseColor(colorData.value?.color as String)
            } else {
                Color.parseColor(AppColorConstants.defaultColorsMap[colorName]!!)
            }
        } else {
            return Color.parseColor(AppColorConstants.defaultColorsMap[colorName]!!)
        }
    }

}

object AppColorConstants {
    const val albumViewRoundIconColor = "albumViewRoundIconColor"
    const val albumViewRoundBackgroundColor = "albumViewRoundBackgroundColor"
    const val albumViewGuideCardBackgroundColor = "albumViewGuideCardBackgroundColor"
    const val albumViewGuideCardTextColor = "albumViewGuideCardTextColor"

    val defaultColorsMap =
        hashMapOf(
            albumViewRoundIconColor to "#000000",
            albumViewRoundBackgroundColor to "#FFFFFF",
            albumViewGuideCardBackgroundColor to "#FFFFFF",
            albumViewGuideCardTextColor to "#000000"
        )

}
