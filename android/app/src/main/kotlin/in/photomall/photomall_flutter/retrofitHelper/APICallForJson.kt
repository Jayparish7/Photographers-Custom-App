package `in`.photomall.photomall_flutter.retrofitHelper
import `in`.photomall.photomall_flutter.api.Api
import `in`.photomall.photomall_flutter.api.ApiUrls
import `in`.photomall.photomall_flutter.api.SharedPreferenceConst
import `in`.photomall.photomall_flutter.utils.CustomProgressDialog
import `in`.photomall.photomall_flutter.utils.Network_check
import `in`.photomall.photomall_flutter.utils.Others
import `in`.photomall.photomall_flutter.utils.Others.DLog
import `in`.photomall.photomall_flutter.utils.SharedPreferenceHelper.Companion.getLongPreference
import android.content.Context
import android.widget.Toast
import com.google.gson.Gson
import com.google.gson.JsonObject
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import io.reactivex.schedulers.Schedulers

/**
 * Created by prandex-and-05 on 6/2/18.
 */
class APICallForJson(val mContext: Context) {

    private val createRetrofitApiClient by lazy {
        APIClient.getClient(mContext)
    }
    var from : Int? = null

    private var responseListener: APIListener? = null

    var customProgressDialog: CustomProgressDialog? = null

    var apiCallDisposable: Disposable? = null

    fun APIRequestForJson(url: String, jObject: JsonObject, responseModel: Class<*>,
                   apiResponseListener : APIListener, from: Int, showProgressDialogue: Boolean = true, isRunningForeground: Boolean = true) {

        if (Network_check.isNetworkAvailable(mContext)) {

            if (showProgressDialogue) {
                createDialog()
            }

            //val isChangeGoogleAdvertisingId = getBooleanPreference(mContext, SharedPreferenceConst.IS_CHANGE_GOOGLE_ADVERTISING_ID, false)

            jObject.addProperty(Api.KEY_CLIENT_ID, getLongPreference(mContext, SharedPreferenceConst.CLIENT_ID))
            /*jObject.addProperty(Api.IS_CHANGE_GOOGLE_ADVERTISING_ID, if(isChangeGoogleAdvertisingId) "1" else "0")
            if(isChangeGoogleAdvertisingId){
                jObject.addProperty(Api.REGISTER_KEY_GOOGLE_ADVERTISING_ID, getStringPreference(mContext, SharedPreferenceConst.GOOGLE_ADVERTISING_ID, ""))
            }*/

            printApiRequestHasmap(url, jObject)
            apiCallDisposable = createRetrofitApiClient!!.postJson(url,jObject)
                    .subscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe({ result ->

                        /*if(isChangeGoogleAdvertisingId)
                            SharedPreferenceHelper.setBooleanPreference(mContext, SharedPreferenceConst.IS_CHANGE_GOOGLE_ADVERTISING_ID, false)*/

                        if (showProgressDialogue) {
                            dismissDialog()
                        }
                        if (result.isSuccessful) {
                            val response = result.body()!!.string()
                            printResponse(response, result.code(), url)
                            try {
                                apiResponseListener.onSuccess(from, Gson().fromJson(response, responseModel))
                            } catch (e: Exception) {
                                e.printStackTrace()
                                printErrorMessage(e.message)
                            }
                        } else {
                            if(url == ApiUrls.USER_BIND){
                                apiResponseListener.onNetworkFailure(from)
                            }
                            val errorResponse = result.errorBody()!!.string()
                            printResponse(errorResponse, result.code(), url)

                            when (result.code()) {
                                304 -> {
                                    //No update needed
                                    //apiResponseListener.onNetworkFailure(from)
                                }
                                400 -> {
                                    //General Api error
                                    /*snackbar((mContext as Activity).findViewById(android.R.id.content), result.code().toString())*/
                                    /*val message = Gson().fromJson(result.errorBody()!!.charStream(), responseModel::class.java)
                                    Others.DLog("message",message.err)*/
                                    apiResponseListener.onFailure(from, Gson().fromJson(errorResponse, responseModel))
                                }

                                401 -> {
                                    //un authorized

                                    /*snackbar((mContext as Activity).findViewById(android.R.id.content), "unauthorized")*/
                                    /*ProperLogout.removeUserInfo(mContext,1,this as LifecycleOwner)*/
                                    DLog("messagesss 401 :", "${url}")
                                    //GenerateRefreshToken(mContext, url, hmap, responseModel, apiResponseListener, from, showProgressDialogue)
                                }
                                429 -> {
                                    /*logoutSetPreference(mContext)
                                    removeSharedPreferenceKeys(mContext)
                                    removeTable(mContext)*/
                                }

                                /* 412 -> {
                                     //412 Precondition Failed---> proof waiting for verification
                                     errorCodePopup(mContext.resources.getString(R.string.proof_waiting))
                                 }
                                 413 -> {
                                     *//*snackbar((mContext as Activity).findViewById(android.R.id.content), "Image Size is Too Large")*//*
                                    errorCodePopup(mContext.resources.getString(R.string.large_image_size))
                                }

                                422 -> {
                                    //422 Unprocessable Entity--->proof not submitted
                                    errorCodePopup(mContext.resources.getString(R.string.proof_notsubmitted))
                                }
                                423 -> {//423 Locked --->disabled account for 24 hours
                                    errorCodePopup(mContext.resources.getString(R.string.account_disabled))
                                }
                                426 -> {
                                    //  app force upgrade
                                    mContext.startActivity(Intent(mContext, AppForceUpgrade::class.java))
                                }*/

                                426 -> {
                                    //  app force upgrade
                                   //mContext.startActivity(Intent(mContext, AppForceUpdateActivity::class.java))
                                }
                                500 -> {

                                    /* errorCodePopup(mContext.resources.getString(R.string.something_went_wrong))*/
                                    // server internal error
                                    //mContext.toast("Try again later,")
                                    Toast.makeText(mContext, "Try again later,", Toast.LENGTH_LONG).show()
                                }
                                502 -> {

                                    // Bad Gateway, it means version either deprecated or not listed in our system
                                }
                                503 -> {
                                    if(isRunningForeground) {
                                        /*val intent = Intent(mContext, ServerMaintainenceActivity::class.java)
                                        mContext.startActivity(intent)*/
                                        Others.showAlertSnackBar(mContext, "Server Under Maintenance")
                                    }
                                }
                                else -> {
                                }
                            }
                        }

                    }, { error ->
                        if (showProgressDialogue) {
                            dismissDialog()
                        }
                        error.printStackTrace()
                        DLog("JSON response error", error.toString())
                    })

        } else {
            showNetworkError()
            apiResponseListener.onNetworkFailure(from)
        }

        /*if (Network_check.isNetworkAvailable(mcontext)) {
            if(showProgressDialogue) {
                createDialog(message)
            }

            this.from=from
            this.responseListener=apiListener
            createRetrofitApiClient?.postRequest(url, queryParams)?.subscribeOn(Schedulers.io())
                    ?.observeOn(AndroidSchedulers.mainThread())
                    ?.subscribe({ response ->
                        if (response.isSuccessful) {
                            DLog("APICall : ","isSuccessful")
                            if(showProgressDialogue) {
                                dismissDialog()
                            }
                            try{
                                apiListener.onSuccess(from, Gson().fromJson(response.body()!!.string(), responseModel))
                            }catch (e:Exception){
                                e.printStackTrace()
                            }

                        } else {
                            DLog("API CALL for ($url): ","inside Apirequest and response else error ${response.code()}" )
                            DLog("API CALL Error Body: ",response.errorBody().toString())
                            DLog("API CALL Message: ",response.message())
                            when (response.code()) {
                                400 -> {
                                    dismissDialog()
                                    apiListener.onNetworkFailure(from)
                                }
                                401 -> {
                                    //un authorized
                                }
                                500 -> {
                                    // server internal error
                                    mcontext.toast("Try again later")
                                    if(showProgressDialogue) {
                                        dismissDialog()
                                    }
                                }
                                502 -> {
                                    // Bad Gateway, it means version either deprecated or not listed in our system
                                }
                            }
                        }
                    }, { error ->
                        DLog("API CALL : ","inside Apirequest handle error" )
                        if(showProgressDialogue){
                            dismissDialog()
                        }
                        DLog("response error", "${error.message.toString()}${error.localizedMessage}")
                    })
        } else {
            showNetworkError()
        }*/
    }
    private fun dismissDialog() {
        //progressDialog?.dismiss()
        customProgressDialog?.dismiss()
    }
    private fun createDialog() {
        //wait_getMyAlbums = showProgressDialog(mcontext, message)
        /*progressDialog = ProgressDialog(mContext, R.style.MyAlertDialogStyle)
        progressDialog?.setMessage(message)
        progressDialog?.show()*/
        customProgressDialog = CustomProgressDialog(mContext, "")
        customProgressDialog!!.show()
    }

    private fun printErrorMessage(message: String?) {
        DLog("JSON Api Response GsonConverter error message", message.toString())
    }

    private fun printApiRequestHasmap(url: String, hmap: JsonObject) {
        DLog("JSON api " + url + " ", "Hasmap-> " + hmap.toString())
    }

    private fun printResponse(result: String, errorCode: Int, url: String) {

        DLog("JSON raw_result for " +
                "" + url, " Response code-> " + errorCode + " , Json-> " + result)
        /*if(errorCode==304){
            SharedPreferenceHelper.setBooleanPreference(mContext,"304",true)
        }*/
    }

    private fun handleError(error: Throwable) {
        DLog("JSON API CALL : ","inside Apirequest handle error method" )
        //progressDialogLoader?.dismissProgressDialog(mcontext as Activity)
        responseListener?.onFailure(from!!, error)
        DLog("JSON response error", error.message.toString())
        //mContext.toast("response error")
    }
    fun showNetworkError() {
        //snackbar((mContext as Activity).findViewById(android.R.id.content), "You are offline")
        Others.showAlertSnackbar(mContext!!, "You are offline")
        //mcontext.toast("Check your Network Connection")
    }

    fun disposeApiCallForJson() {
        if (apiCallDisposable != null) {
            apiCallDisposable?.dispose()
        }
    }
    
}

























/*
package com.example.jovee_2.photomall_main.RetrofitHelper
//package com.joveeinfotech.kinship

import android.app.Activity
import android.app.ProgressDialog
import android.content.Context
import com.example.jovee_2.photomall_main.R
import com.example.jovee_2.photomall_main.Utils.Network_check
import com.example.jovee_2.photomall_main.Utils.Others.DLog
import com.example.jovee_2.photomall_main.Utils.ProgressDialoghelper
import com.google.gson.Gson
//mport com.joveeinfotech.bloodex.utils.Others.DLog
import io.reactivex.Observable
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import io.reactivex.schedulers.Schedulers
import okhttp3.ResponseBody
import org.jetbrains.anko.design.snackbar
//import org.jetbrains.anko.toast
//import org.jetbrains.anko.design.snackbar
import retrofit2.Response

*/
/**
 * Created by prandex-and-05 on 6/2/18.
 *//*

class APICall(val mcontext: Context) {

    //private var call: Call? = null
    lateinit var disposable: Disposable

    var wait_getMyAlbums : ProgressDialoghelper? = null

    var progressDialog: ProgressDialog? = null

    val createRetrofitApiClient by lazy {
        APIClient.getClient(mcontext)
    }

    var from : Int? = null

    private var observable: Observable<Response<ResponseBody>>? = null

    private var responseListener: APIListener? = null

    enum class Method {
        GET, POST, PUT, DELETE

    }

    fun APIRequest(url: String, queryParams: HashMap<String, String>, responseModel: Class<*>,
                   apiListener : APIListener, from: Int, message: String,
                   showProgressDialogue: Boolean = true) {
        //DLog("API CALL : ", "inside Apirequest1")
        //if (!NetworkConnectionStatus.Connected(mcontext)) {
        if (Network_check.isNetworkAvailable(mcontext)) {
            //progressDialogLoader?.createProgressDialog(mcontext, message)
            if(showProgressDialogue) {
                createDialog(message)
            }
            DLog("API CALL : ", "inside Apirequest")
            this.from=from
            this.responseListener=apiListener

            createRetrofitApiClient?.postRequest(url, queryParams)?.subscribeOn(Schedulers.io())
                    ?.observeOn(AndroidSchedulers.mainThread())
                    ?.subscribe({ response ->
                        */
/*DLog("Response code for($url) : ",response.code().toString())
*//*

                        //DLog("API CALL : ","inside Apirequest and response" )
                        if (response.isSuccessful) {
                            DLog("APICall : ","isSuccessful ${response.body()?.string()}")                            //DLog("GetAlbums body : ",response.body()!!.toString())
                            */
/*try {
                                Log.e("API CALL : ","inside Apirequest isSuccessful" )
                                //progressDialogLoader?.dismissProgressDialog(mcontext)
                                if(showProgressDialogue) {
                                    dismissDialog()
                                }
                                apiListener.onSuccess(from, Gson().fromJson(response.body()!!.string(), responseModel))
                            } catch (e: Exception) {
                                e.printStackTrace()
                                handleError(Throwable(e.cause))
                            }*//*

                            if(showProgressDialogue) {
                                dismissDialog()
                            }


                            */
/*val str="{'update_status':true,'token_type':'Bearer','expires_in':31536000,'access_token':'ZUgzNFcCzhp2eO9i3IE6odkdJCloK9vzLkNZyqpid8','refresh_token':'d7b28aeef6'}"*//*

                            try {
                                DLog("GSON :",response.body()!!.string())
                                apiListener.onSuccess(from, Gson().fromJson(response.body()!!.string(), responseModel))
                            }catch (e:Exception){
                                DLog("Gson Converter Error",e.message.toString())
                            }

                        } else {
                            DLog("API CALL for ($url): ","inside Apirequest and response else error ${response.code()}" )
                            DLog("API CALL Error Body: ",response.errorBody().toString())
                            DLog("API CALL Body: ",response.body().toString())
                            DLog("API CALL Message: ",response.message())
                            //val errorMessage = JSONObject(response.code().toString())
                            //HelperClass.SOT(mContext, errorMessage.getString("error_message").toString())
                            //mcontext.toast(errorMessage.getString("error_message").toString())
                            when (response.code()) {
                                401 -> {
                                    //un authorized
                                    //snackbar((mContext as Activity).findViewById(android.R.id.content), "un authorized")
                                }
                                500 -> {
                                    // server internal error
                                }
                                502 -> {
                                    // Bad Gateway, it means version either deprecated or not listed in our system
                                }
                            }
                            //DLog("GetAlbums error body : ",response.errorBody().toString())
                        }
                    }, { error ->
                        DLog("API CALL : ","inside Apirequest handle error" )
                        //progressDialogLoader?.dismissProgressDialog(mcontext as Activity)
                        if(showProgressDialogue){
                            dismissDialog()
                        }
                        //responseListener?.onFailure(from, error)
                        DLog("response error", "${error.message.toString()}${error.localizedMessage}")
                    })
        } else {
            showNetworkError()
        }
    }

    private fun dismissDialog() {
        progressDialog?.dismiss()
    }

    private fun createDialog(message: String) {
        //wait_getMyAlbums = showProgressDialog(mcontext, message)
        progressDialog = ProgressDialog(mcontext, R.style.MyAlertDialogStyle)
        progressDialog?.setMessage(message)
        progressDialog?.show()
    }

    private fun handleError(error: Throwable) {
        DLog("API CALL : ","inside Apirequest handle error method" )
        //progressDialogLoader?.dismissProgressDialog(mcontext as Activity)
        responseListener?.onFailure(from!!, error)
        DLog("response error", error.message.toString())
        //mContext.toast("response error")
    }

    fun showNetworkError() {
        snackbar((mcontext as Activity).findViewById(android.R.id.content), "You are offline")
        //mcontext.toast("Check your Network Connection")
    }
}*/
