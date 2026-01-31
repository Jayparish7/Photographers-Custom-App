package `in`.photomall.photomall_flutter.model.other

data class UnDownloadedImageData(
    val image_ids: List<ImagesId>
)

data class ImagesId(
    val id: Int,
    val type: Int
)