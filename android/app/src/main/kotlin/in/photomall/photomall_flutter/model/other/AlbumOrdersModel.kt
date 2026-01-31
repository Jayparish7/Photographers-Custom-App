package `in`.photomall.photomall_flutter.model.other

class AlbumOrdersModel : ArrayList<AlbumOrdersModelItem>()

data class AlbumOrdersModelItem(
    val code: String?,
    val image_type: Int?,
    var jvt_file_connectors: List<JvtFileConnector?>?,
    val last_updated_at: Int?,
    val original_file_name: String?,
    val priority: Int?
)

data class JvtFileConnector(
    val code: String?,
    val jvt_file: JvtFile?,
    val name: String?,
    val screen_display: Int?
)

data class JvtFile(
    val code: String?,
    val extension: String?,
    val mode: Int?,
    val name: String?,
    val size: Int?
)
