package `in`.photomall.photomall_flutter.model.api

/**
 * Created by Jovee-2 on 08-Jul-17.
 */


data class RefreshImageUrl(
    val `data`: Data
)

data class Data(
    val images: List<Image>
)

data class Image(
    val detail: Detail,
    val id: Int,
    val status: String,
    val type: Int
)

data class Detail(
    val original_url: String,
    val thumb_url: String
)

/*
data class SampleData(
    val `data`: Data
)

data class Data(
    val images: List<Image>
)

data class Image(
    val detail: Detail,
    val id: String,
    val update_status: String,
    val type: Int
)

data class Detail(
    val original_url: String,
    val thumb_url: String
)*/
