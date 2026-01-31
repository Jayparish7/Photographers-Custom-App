package `in`.photomall.photomall_flutter.model.api.jvtFilesUrl

data class JvtFilesTemporaryUrl(
    val files: List<File>
)

data class File(
    val detail: Detail,
    val id: Int,
    val status: Int
)

data class Detail(
    val extension: String,
    val `file`: String,
    val size: Long
)