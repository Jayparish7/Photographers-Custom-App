package `in`.photomall.photomall_flutter.retrofitHelper

import `in`.photomall.photomall_flutter.api.ApiUrls
import `in`.photomall.photomall_flutter.api.CommonConst
import `in`.photomall.photomall_flutter.api.SharedPreferenceConst
import `in`.photomall.photomall_flutter.utils.SharedPreferenceHelper.Companion.getStringPreference
import android.content.Context
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.Response
import retrofit2.Retrofit
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

/**
 * Created by prandex-and-05 on 6/2/18.
 */

class APIClient {

    companion object {

        fun getClient(mcontext: Context): APIInterface? {

           /* val interceptor: Interceptor = object : Interceptor {
                override fun intercept(chain: Interceptor.Chain): Response {
                    val request = chain.request()
                    if (request.url().encodedPath().equals(ApiUrls.LOGIN, ignoreCase = true)
                            || request.url().encodedPath().equals(ApiUrls.OTP, ignoreCase = true)
                            || request.url().encodedPath().equals(ApiUrls.USER_REGISTER, ignoreCase = true)
                            || request.url().encodedPath().equals(ApiUrls.SET_PASSWORD, ignoreCase = true)
                            && request.method().equals("post", ignoreCase = true)) {
                        return chain.proceed(request)
                    }
                    val newRequest = request.newBuilder()
                            .addHeader("Content-Type", "application/json")
                            .addHeader("Accept", "application/json")
                            .addHeader("Authorization", "Bearer" + ' ' + getStringPreference(mcontext, SharedPreferenceConst.ACCESS_TOKEN, "test"))
                            .build()
                    return chain.proceed(newRequest)
                }
            }*/

            val okHttpClient = OkHttpClient.Builder()
                    .connectTimeout(300, TimeUnit.SECONDS)
                    .readTimeout(300, TimeUnit.SECONDS)
                    .writeTimeout(300, TimeUnit.SECONDS)
                    //.addInterceptor(interceptor)
                    .build()

            return Retrofit.Builder()
                    .baseUrl(CommonConst.BASE_URL)
                    .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                    .addConverterFactory(GsonConverterFactory.create())
                    .client(okHttpClient)
                    .build()
                    .create(APIInterface::class.java)
        }

    }
}