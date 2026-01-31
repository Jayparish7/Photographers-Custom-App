package `in`.photomall.photomall_flutter.threadPool

import `in`.photomall.photomall_flutter.api.Api
import `in`.photomall.photomall_flutter.api.ApiUrls
import `in`.photomall.photomall_flutter.api.WebConstants
import `in`.photomall.photomall_flutter.database.DbHelper
import `in`.photomall.photomall_flutter.model.api.CommonResponse
import `in`.photomall.photomall_flutter.retrofitHelper.APICall
import `in`.photomall.photomall_flutter.retrofitHelper.APIListener
import `in`.photomall.photomall_flutter.utils.Network_check
import `in`.photomall.photomall_flutter.utils.Others.DLog
import `in`.photomall.photomall_flutter.utils.StorageUtils
import `in`.photomall.photomall_flutter.view.activity.CurlActivity
import `in`.photomall.photomall_flutter.view.activity.MainActivity
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.StrictMode
import java.io.*
import java.net.*
import javax.net.ssl.SSLException
import javax.net.ssl.SSLHandshakeException

class DownloadTask(var imageUrl: String, var page_status: Int, var imageType: Int, var mContext: Context,
                   var resultUpdateTask: DownloadResultUpdateTask) : Runnable {

    override fun run() {
        if (downloadFile()) {
            resultUpdateTask.setImageUrl(imageUrl, bmp!!, imageType)
            //msg = "file downloaded successful $imageUrl"
        } else {
            //msg = "failed to download the file $imageUrl"
        }
        DownloadManager.downloadManager!!.mainThreadExecutor?.execute(resultUpdateTask)
    }

    //var originalName: String? = null
    var bmp: Bitmap? = null

    var isAbleToDownload: Boolean = true

    private fun downloadFile(): Boolean {

        if (Network_check.isNetworkAvailable(mContext) && isAbleToDownload) {
            val w = 10
            val h = 10
            val conf = Bitmap.Config.ARGB_8888 // see other conf types
            bmp = Bitmap.createBitmap(w, h, conf)

            val dbHelper = DbHelper(mContext)
            //var df = dbHelper.getCompletedAlbumOriginalImageUrl(imageUrl)
            //DLog("DownloadTask : ImageUrl", "root df: $df")
            val type = "/"

            val projectFolder = StorageUtils.getCacheFolder(mContext)
            //val projectFolder = File("${mContext.applicationContext.applicationInfo.dataDir}/app_flutter")
            if (!projectFolder.exists()) {
                projectFolder.mkdir()
            }

            val thumbFolder = File(projectFolder, type)
            if (!thumbFolder.exists()) {
                thumbFolder.mkdir()
            }

            DLog("DownloadTask : ImageUrl", imageUrl)
            val file = File(thumbFolder, imageUrl)
            val imageExtension = imageUrl.substring(imageUrl.lastIndexOf(".") + 1, imageUrl.length)

            //DLog("DownloadTask : ImageExtension", "${imageExtension}")
            val imageName = imageUrl.substring(0, imageUrl.lastIndexOf("."))
            //originalName = imageUrl.substring(0, imageUrl.length.minus(imageExtension.length) - 1)

            try {
                val policy = StrictMode.ThreadPolicy.Builder().permitAll().build()
                StrictMode.setThreadPolicy(policy)
                var urlString: String = ""

                if (page_status == 0 || page_status == 2 || page_status == 6) {
                    //urlString = dbHelper.getCompletedAlbumOriginalImageUrl(imageUrl)
                    urlString = "${MainActivity.publicPath}/$imageName"
                }

                DLog("DownloadTask UrlString", "$urlString : $imageUrl -- $page_status")

                val url = URL(urlString)

                if (!file.exists()) {
                    val connection1 = url.openConnection() as HttpURLConnection
                    DLog("DownloadImagesAsyncTast : ", "RESPONSE code : ${connection1.responseCode}")
                    if (connection1.responseCode != 403) {
                        val connection = url.openConnection() as HttpURLConnection
                        connection.doInput = true
                        connection.connect()

                        val input = connection.inputStream

                        var myBitmap: Bitmap = bmp!!
                        if (page_status == 4 || page_status == 5 || page_status == 0 || page_status == 11 || page_status == 6) {
                            if (input != null) {
                                myBitmap = BitmapFactory.decodeStream(input)
                                bmp = myBitmap
                            }
                        } else { // 12, 2 (album cover and its images)
                            if (input != null) {
                                myBitmap = BitmapFactory.decodeStream(input)
                                bmp = myBitmap
                            }
                        }
                        val stream = FileOutputStream(file)
                        val outstream = ByteArrayOutputStream()

                        if (imageExtension.endsWith("jpg") || imageExtension.endsWith("jpeg")) {
                            myBitmap.compress(Bitmap.CompressFormat.JPEG, 100, outstream)
                        } else if (imageExtension.endsWith("png")) {
                            myBitmap.compress(Bitmap.CompressFormat.PNG, 100, outstream)
                        } else if (imageExtension.endsWith("webp")) {
                            myBitmap.compress(Bitmap.CompressFormat.WEBP, 100, outstream)
                        }

                        val byteArray = outstream.toByteArray()

                        if (page_status == 2) {
                            stream.write(byteArray)
                        }

                        stream.close()

                        if (page_status == 0 || page_status == 2 || page_status == 12 || page_status == 6) {
                            dbHelper.addOriginalInfo(1, imageUrl)
                        }
                    } else if (connection1.responseCode == 404) {
                        DLog("DownloadTask :", "inside else if(404) image url : $urlString")
                        setUndownloadStatus(dbHelper, imageUrl)
                        return false
                    } else if (connection1.responseCode == 403) {
                        DLog("DownloadTask :", "inside else if(403) image url : $urlString")
                        setUndownloadStatus(dbHelper, imageUrl)
                        sendSlackNotification(WebConstants._403_ERROR)
                    }
                }
                DLog("DownloadTask :", "downloadFile() : step 10")

            } catch (e: OutOfMemoryError) {
                DLog("OutOfMemoryError : ", "${e.message}")
                setUndownloadStatus(dbHelper, imageUrl)
                return false
            } catch (e: FileNotFoundException) {
                return false
            } catch (e: MalformedURLException) {
                return false
            } catch (e: ConnectException) {
                return false
            } catch (e: UnknownHostException) {
                return false
            } catch (e: SSLException) {
                return false
            } catch (e: SSLHandshakeException) { // I/O Error
                return false
            } catch (e: EOFException) {
                return false
            } catch (e: Exception) {
                return false
            }
            return true
        } else {
            return false
        }
    }

    private fun sendSlackNotification(errorType: String) {
        val hashMap = HashMap<String, String>()
        hashMap[Api.TYPE] = errorType
        APICall(mContext).APIRequest(ApiUrls.SLACK_NOTIFICATION, hashMap, CommonResponse::class.java, object : APIListener {
            override fun onSuccess(from: Int, response: Any) {}
            override fun onFailure(from: Int, response: Any) {}
            override fun onNetworkFailure(from: Int) {}
        }, 1, "", false)
    }

    private fun setUndownloadStatus(dbHelper: DbHelper, originalName: String) {
        if (page_status == 3) {
            dbHelper.addOriginalInfo(0, originalName)
        } else {
            dbHelper.addThumbnailInfo(0, originalName)
        }
        DLog("DownloadTask :", "inside setUndownloadStatus() originalName : $originalName")
    }
}