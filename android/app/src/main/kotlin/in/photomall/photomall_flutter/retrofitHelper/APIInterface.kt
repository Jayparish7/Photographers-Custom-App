package `in`.photomall.photomall_flutter.retrofitHelper

import androidx.annotation.Keep
import com.google.gson.JsonObject
import okhttp3.ResponseBody
import io.reactivex.Observable
import retrofit2.Response
import retrofit2.http.*
import retrofit2.http.POST



/**
 * Created by prandex-and-05 on 6/2/18.
 */
@Keep
interface APIInterface {

    @POST
    @FormUrlEncoded
    fun postRequest(@Url url: String , @FieldMap params: Map<String, String>): Observable<Response<ResponseBody>>

    /*@POST
    @FormUrlEncoded
    fun postJson( @FieldMap params: Map<String, String>): Observable<Response<ResponseBody>>*/

  /*  @POST(ApiUrls.DEVICE_REGISTER)
    @FormUrlEncoded
    fun appRegister(@Field("device_id") device_id : String,
                    @Field("device_manufacturer") device_manufacturer : String,
                    @Field("device_model_name") device_model_name : String,
                    @Field("android_version") android_version : String) : Observable<DeviceRegisterResult>

    @POST(ApiUrls.LOGIN)
    @FormUrlEncoded
    fun userLogin(@Field("username") username : String,
                    @Field("password") password : String,
                    @Field("grant_type") grant_type : String,
                    @Field("scope") scope : String,
                    @Field("client_id") client_id : String,
                    @Field("client_secret") client_secret : String,
                    @Field("last_updated_at") last_updated_at : String) : Observable<LoginResults>*/

    /*@Multipart
    @POST("api/v1/persons")
    fun uploadImage(@Part image: MultipartBody.Part): Observable<ImageUpload>
*/

    /*@Headers("Content-Type:application/json")
    @POST("userbind")
    fun postJson(@Body body: JsonObject): Observable<SendAlbumIdResult>*/

    /*@POST(ApiUrls.USER_BIND)
    fun postJson(@Body body: JsonObject): Observable<Response<ResponseBody>>*/

    @POST
    fun postJson(@Url url: String, @Body body: JsonObject): Observable<Response<ResponseBody>>

    /*@POST(ApiUrls.SET_IMAGE_STATUS)
    fun postImageStatusJson(@Body body: JsonObject): Observable<Response<ResponseBody>>*/

    /*@POST(ApiUrls.USER_BIND)
    fun postJson(@Body body: JsonObject): Observable<SendAlbumIdResult>*/

    /*@Headers("Content-Type:application/json")
    @POST(ApiUrls.USER_BIND)
    fun postJson(@Header("Authorization") authorization : String,
                 @Body body: JsonObject): Observable<SendAlbumIdResult>*/

    /*@POST(ApiUrls.USER_ALBUMS)
    @FormUrlEncoded
    fun getUserAlbums(@Field("last_updated_at") last_updated_at: String): Observable<Response<ResponseBody>>*/

    /*@POST(ApiUrls.USER_ALBUMS)
    @FormUrlEncoded
    fun getUserAlbums(@Header("Authorization") authorization : String,
                      @Field("last_updated_at") last_updated_at: String,
                      @Field("client_id") client_id : String): Observable<UserAlbums>*/

    /*@GET(value = "popular")
    fun getPopular(@Query(value = "api_key", encoded = false) apiKey: String, @Query(value = "page", encoded = false) page: Int): Call<PDImageResponse>*/

}