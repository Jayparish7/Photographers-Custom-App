package `in`.photomall.photomall_flutter.model.api.eventAlbums


data class EventAlbumImagesResult(
        val data: Data
)

data class Data(
        val album: Albums
)

data class Albums(
        val id: Int,
        val name: String,
        val images: List<Image>,
        //val number_of_half_image: Int,
        val last_updated_at: Int
)

data class Image(
        val `data`: DataXX,
        val id: Int,
        val update_status: Int
)

data class DataXX(
        val id: Int,
        val image: String,
        val name: String,
        val original_size: Long,
        val selected_status: Int,
        val thumb_size: Int,
        val image_order: Int
)


/*
data class EventAlbumImagesResult(
    val data: Data
)

data class Data(
    val album: Albums
)

data class Albums(
    val data: DataX,
    val id: Int,
    val update_status: Int
)

data class DataX(
    val images: List<Image>,
    //val number_of_half_image: Int,
    val last_updated_at: Int,
    val name: String
)

data class Image(
    val `data`: DataXX,
    val id: Int,
    val update_status: Int
)

data class DataXX(
        val id: Int,
        val image: String,
        val name: String,
        val original_size: Long,
        val selected_status: Int,
        val thumb_size: Int,
        val image_order: Int
)*/
