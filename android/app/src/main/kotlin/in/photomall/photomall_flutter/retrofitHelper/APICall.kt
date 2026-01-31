package `in`.photomall.photomall_flutter.retrofitHelper

import `in`.photomall.photomall_flutter.api.Api
import `in`.photomall.photomall_flutter.api.ApiUrls
import `in`.photomall.photomall_flutter.api.SharedPreferenceConst
import `in`.photomall.photomall_flutter.utils.CustomProgressDialog
import `in`.photomall.photomall_flutter.utils.Network_check
import `in`.photomall.photomall_flutter.utils.Others
import `in`.photomall.photomall_flutter.utils.Others.DLog
import `in`.photomall.photomall_flutter.utils.SharedPreferenceHelper.Companion.getLongPreference
import `in`.photomall.photomall_flutter.utils.SharedPreferenceHelper.Companion.getStringPreference
import android.app.ProgressDialog
import android.content.Context
import android.widget.Toast
import com.google.gson.Gson
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import io.reactivex.schedulers.Schedulers

/**
 * Created by prandex-and-05 on 6/2/18.
 */
class APICall(private val mContext: Context) {

    var progressDialog: ProgressDialog? = null
    val createRetrofitApiClient by lazy {
        APIClient.getClient(mContext)
    }
    var from: Int? = null

    private var responseListener: APIListener? = null

    var customProgressDialog: CustomProgressDialog? = null

    var apiCallDisposable: Disposable? = null

    fun APIRequest(url: String, hmap: HashMap<String, String>, responseModel: Class<*>,
                   apiResponseListener: APIListener, from: Int, message: String,
                   showProgressDialogue: Boolean = true) {

        DLog("Access_token", "Value: ${getStringPreference(mContext, SharedPreferenceConst.ACCESS_TOKEN, "")}")
        //DLog("BASE_URL:", "Value: ${CommonConst.BASE_URL}")

        if (Network_check.isNetworkAvailable(mContext)) {

            if (showProgressDialogue) {
                createDialog(message, url)
            }

            //val isChangeGoogleAdvertisingId = getBooleanPreference(mContext, SharedPreferenceConst.IS_CHANGE_GOOGLE_ADVERTISING_ID, false)

            if (url != ApiUrls.DEVICE_REGISTER) {
                hmap[Api.KEY_CLIENT_ID] = getLongPreference(mContext, SharedPreferenceConst.CLIENT_ID).toString()
                /*hmap[Api.IS_CHANGE_GOOGLE_ADVERTISING_ID] = if (isChangeGoogleAdvertisingId) "1" else "0"
                if (isChangeGoogleAdvertisingId) {
                    hmap[Api.REGISTER_KEY_GOOGLE_ADVERTISING_ID] = getStringPreference(mContext, SharedPreferenceConst.GOOGLE_ADVERTISING_ID, "")!!
                }*/
                //new
                hmap["client_secret"] = getStringPreference(mContext, "client_secret", "").toString();
                //new
            }

            //new
            hmap["app_version_code"] = 183.toString(); //packageInfo.buildNumber;
            hmap["studio_random_id"] = "stage";
            //new

            printApiRequestHasmap(url, hmap)
            //System.gc()
            apiCallDisposable = createRetrofitApiClient!!.postRequest(url, hmap)
                    .subscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe({ result ->

                        /*if (isChangeGoogleAdvertisingId)
                            setBooleanPreference(mContext, SharedPreferenceConst.IS_CHANGE_GOOGLE_ADVERTISING_ID, false)*/

                        if (showProgressDialogue) {
                            dismissDialog()
                        }
                        if (result.isSuccessful) {
                            if (result.code() == 204) {
                                apiResponseListener.onSuccess(from, "")
                            } else {
                                val response = result.body()!!.string()
                                printResponse(response, result.code(), url)
                                try {
                                    apiResponseListener.onSuccess(from, Gson().fromJson(response, responseModel))
                                } catch (e: Exception) {
                                    e.printStackTrace()
                                    printErrorMessage(e.message, url)
                                }
                            }
                        } else {
                            val errorResponse = result.errorBody()!!.string()
                            printResponse(errorResponse, result.code(), url)

                            when (result.code()) {
                                304 -> {
                                    //No update needed
                                    if (url == ApiUrls.PRE_DESIGNED_ALBUM) {
                                        apiResponseListener.onNetworkFailure(from)
                                    } else if (url == ApiUrls.UPDATE_EVENTS_DETAILS) {
                                        apiResponseListener.onNetworkFailure(from)
                                    } else if (url == ApiUrls.UPDATE_ALBUM) {
                                        apiResponseListener.onNetworkFailure(from)
                                    }
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
                                    /*var intent = Intent(mContext, AppForceUpdateActivity::class.java)
                                    mContext.startActivity(intent)*/
                                }
                                500 -> {

                                    /* errorCodePopup(mContext.resources.getString(R.string.something_went_wrong))*/
                                    // server internal error
                                    if (url == ApiUrls.USER_EVENTS) {
                                        apiResponseListener.onNetworkFailure(from)
                                    } else {
                                        Toast.makeText(mContext, "Try again later", Toast.LENGTH_LONG).show()
                                    }
                                }
                                502 -> {

                                    // Bad Gateway, it means version either deprecated or not listed in our system
                                }
                                503 -> {
                                    /*var intent = Intent(mContext, ServerMaintainenceActivity::class.java)
                                    mContext.startActivity(intent)*/
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
                        DLog("response error", error.toString())
                    })
        } else {
            showNetworkError()
            apiResponseListener.onNetworkFailure(from)
        }
    }

    private fun dismissDialog() {
        //progressDialog?.dismiss()
        customProgressDialog?.dismiss()
    }

    private fun createDialog(message: String, url: String) {
        //wait_getMyAlbums = showProgressDialog(mcontext, message)
        /*progressDialog = ProgressDialog(mContext, R.style.MyAlertDialogStyle)
        progressDialog?.setMessage(message)
        progressDialog?.show()*/
        customProgressDialog = CustomProgressDialog(mContext, url)
        customProgressDialog!!.show()
    }

    private fun printErrorMessage(message: String?, url: String) {
        DLog("Api Response GsonConverter error message ($url)", message.toString())
    }

    private fun printApiRequestHasmap(url: String, hmap: java.util.HashMap<String, String>) {
        DLog("api " + url + " ", "Hasmap-> " + Gson().toJson(hmap))
    }

    private fun printResponse(result: String, errorCode: Int, url: String) {
        DLog("raw_result for " +
                "" + url, " Response code-> $errorCode , Json-> $result")
    }

    private fun handleError(error: Throwable) {
        DLog("API CALL : ", "inside Apirequest handle error method")
        //progressDialogLoader?.dismissProgressDialog(mcontext as Activity)
        responseListener?.onFailure(from!!, error)
        DLog("response error", error.message.toString())
        //mContext.toast("response error")
    }

    fun showNetworkError() {
        //snackbar((mContext as Activity).findViewById(android.R.id.content), "You are offline")
        Others.showAlertSnackbar(mContext!!, "You are offline")
        //mcontext.toast("Check your Network Connection")
    }

    fun disposeApiCall() {
        if (apiCallDisposable != null) {
            apiCallDisposable?.dispose()
        }
    }

}
