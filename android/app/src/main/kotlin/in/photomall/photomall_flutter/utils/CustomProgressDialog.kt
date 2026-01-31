package `in`.photomall.photomall_flutter.utils

/**
 * Created by Vigneshkumar M
 */

import `in`.photomall.photomall_flutter.R
import android.app.ProgressDialog
import android.content.Context

class CustomProgressDialog(context: Context, url: String) {

    var progressDialog: ProgressDialog? = null
    var message: String? = null
    var mUrl: String = ""

    init {
        this.mUrl = url
        if (progressDialog == null) {
            progressDialog = ProgressDialog(context)
            //message = context.getString(R.string.message_loading)
            message = "xvdd"
        }
    }

    //@Synchronized
    fun show() {
        progressDialog!!.setMessage(message)


        /*if(mUrl==ApiUrls.PRE_DESIGNED_ALBUM){
            progressDialog!!.setCancelable(true)
        }else{
            progressDialog!!.setCancelable(false)
        }*/
        progressDialog!!.setCancelable(true)
        progressDialog!!.setProgressStyle(ProgressDialog.STYLE_SPINNER)
        progressDialog!!.window?.setBackgroundDrawableResource(android.R.color.transparent)
        progressDialog!!.show()
        progressDialog!!.setContentView(R.layout.custom_progress_dialog)
    }

    //@Synchronized
    fun dismiss() {
        if (progressDialog == null && !progressDialog!!.isShowing) {
            return
        } else {
            progressDialog!!.dismiss()
        }
    }


    /* fun cancelProgress(){
         progressDialog!!.dismiss()
     }
 */


}