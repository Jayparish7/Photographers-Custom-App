package `in`.photomall.photomall_flutter.utils.appColors

data class DesignDataModel(
    val update_required: Int?,
    val last_updated_at: Int?,
    val `data`: Data?
)

data class Data(
    val app_colors: List<AppColor?>?,
    val countries: List<Country?>?,
    val design_properties: List<DesignProperty?>?,
    val fonts: List<Font?>?
)

data class AppColor(
    val code: String?,
    val last_updated_at: Int?,
    val name: String?,
    val type: Int?,
    val value: Value?
)

data class Country(
    val code: String?,
    val id: Int?,
    val name: String?,
    val short_code: String?
)

data class DesignProperty(
    val code: String?,
    val last_updated_at: Int?,
    val name: String?,
    val value: String?
)

data class Font(
    val code: String?,
    val font: String?,
    val last_updated_at: Int?,
    val name: String?,
    val symbol: String?
)

data class Value(
    val alignment1: Int?,
    val alignment2: Int?,
    val color: Any?
)