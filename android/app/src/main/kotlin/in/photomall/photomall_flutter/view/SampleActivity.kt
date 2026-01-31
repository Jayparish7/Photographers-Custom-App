package `in`.photomall.photomall_flutter.view

import `in`.photomall.photomall_flutter.R
import `in`.photomall.photomall_flutter.database.DbHelper
import `in`.photomall.photomall_flutter.utils.curl.CurlPage
import `in`.photomall.photomall_flutter.utils.curl.CurlView
import android.graphics.*
import android.graphics.drawable.BitmapDrawable
import android.os.Bundle
import android.util.DisplayMetrics
import android.util.Log
import android.view.WindowManager
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout
import com.google.gson.Gson
//import kotlinx.android.synthetic.main.activity_sample.*
import java.io.File
import java.util.*
import kotlin.collections.ArrayList
import kotlin.collections.LinkedHashMap


class SampleActivity : AppCompatActivity() {

    private var albumImagesMap = LinkedHashMap<Int, ArrayList<String>>()
    private var bitmapHashMap = LinkedHashMap<String, Bitmap>()
    private var clickedPosition: Int = 0
    private var mStateOfCurl: String = "0"
    private var currentIndexValue: Int = 0
    private var totalAlbumPaperSize = 0
    lateinit var curl: CurlView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_sample)


        val text = intent!!.extras!!.getString("key")
        val albumId = intent!!.extras!!.getString("albumId")!!

        val curlAlbumImageDataModel: CurlAlbumImageDataModel = Gson().fromJson(text, CurlAlbumImageDataModel::class.java)


        for (image in curlAlbumImageDataModel.images) {

            val imageName = getImageName(image.image_name)


            if (image.image_order in albumImagesMap.keys) {

                if (imageName.endsWith("a")) {
                    albumImagesMap[image.image_order]!![0] = image.image_name
                } else {
                    albumImagesMap[image.image_order]!![1] = image.image_name
                }
            } else {
                val newList = ArrayList<String>()

                if (imageName.endsWith("a")) {
                    newList.add(0, image.image_name)
                    newList.add(1, "")
                } else {
                    newList.add(0, "")
                    newList.add(1, image.image_name)
                }
                albumImagesMap[image.image_order] = newList
            }

        }

        Log.e("map", Gson().toJson(albumImagesMap))

        totalAlbumPaperSize = albumImagesMap.size

        albumImagesMap.forEach { value ->
            value.value.forEach {
                if (it != "") {
                    bitmapHashMap[it] = getImageFile(it)
                }
            }
        }


        calculateRatio(36, 12)

        var dbHelper = DbHelper.getInstance(this)
        //var df = dbHelper.getClickedAlbumImages(albumId)
        //DLog("SampleActivity: ", "df cursor: ${DatabaseUtils.dumpCursorToString(df)}")


        //fillPage()

    }


    // set a Images in PageFlipping Curl
    private fun fillPage() {

        //isAlbumVisible = true
        //getMergedImageNameArrayList()
        // hiding the page_status bar
        window.setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN)
        curl.setPageProvider(PageProvider(/*viewSingleAlbumActivityModelList*/))
        curl.setSizeChangedObserver(SizeChangedObserver())
        when {
            clickedPosition == 1 -> curl.currentIndex = 0
            clickedPosition == 2 -> curl.currentIndex = 1
            clickedPosition % 2 == 0 -> curl.currentIndex = (clickedPosition / 2)
            clickedPosition % 2 != 0 -> {
                val clickedPosition = clickedPosition - 1
                curl.currentIndex = (clickedPosition / 2) + 1
            }
            else -> curl.currentIndex = 0
        }
        //curl.setBackgroundColor(-0xdfd7d0)
        curl.setBackgroundColor(-0x000000)

        calculateRatio(36, 12)
    }

    private inner class SizeChangedObserver : CurlView.SizeChangedObserver {
        override fun onSizeChanged(w: Int, h: Int) {
            /*if (w > h) {
                mCurlView!!.setViewMode(CurlView.SHOW_ONE_PAGE)
                mCurlView!!.setMargins(.1f, .05f, .1f, .05f)
            } else {
                mCurlView!!.setViewMode(CurlView.SHOW_ONE_PAGE)
                mCurlView!!.setMargins(.1f, .1f, .1f, .1f)
            }*/
            if (w > h) {
                curl.setViewMode(CurlView.SHOW_TWO_PAGES)
                // curl!!.setMargins(.1f, .05f, .1f, .05f)

                curl.setMargins(.0f, .0f, .0f, .0f)
            } else {
                curl.setViewMode(CurlView.SHOW_ONE_PAGE)
                curl.setMargins(.1f, .1f, .1f, .1f)
            }
        }
    }


    private inner class PageProvider : CurlView.PageProvider {

        override fun getPageCount(): Int {
            //return if(true) imageNamesArrayListSize / 2 + 1 else imageNamesArrayListSize / 2
            return totalAlbumPaperSize
        }

        private fun loadFrontBitmap(width: Int, height: Int, index: Int, bitmap: Bitmap): Bitmap {

            showLog("CurlActivity: ", "inside PageProvider loadBitmap")

            val b = Bitmap.createBitmap(width, height,
                    Bitmap.Config.ARGB_8888)
            b.eraseColor(-0x1)
            val c = Canvas(b)
            val d = BitmapDrawable(resources, bitmap)
            val margin = 0
            val border = 0
            val r = Rect(margin, margin, width - margin, height - margin)

            val p = Paint()
            p.color = Color.rgb(151, 124, 83)
            c.drawRect(r, p)
            r.left += border
            r.right -= border
            r.top += border
            r.bottom -= border

            d.bounds = r
            d.draw(c)

            return b
        }

        private fun loadBackBitmap(width: Int, height: Int, index: Int, bitmap: Bitmap): Bitmap {

            showLog("CurlActivity: ", "inside PageProvider loadBitmap 1")

            val b = Bitmap.createBitmap(width, height,
                    Bitmap.Config.ARGB_8888)
            b.eraseColor(-0x1)
            val c = Canvas(b)
            val bOutput: Bitmap
            val matrix = Matrix()
            matrix.preScale(-1.0f, 1.0f)
            //try {
            bOutput = Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
            /*}catch (e: OutOfMemoryError){

            }*/

            val d = BitmapDrawable(resources, bOutput)

            val margin = 0
            val border = 0
            val r = Rect(margin, margin, width - margin, height - margin)

            val p = Paint()
            p.color = Color.rgb(151, 124, 83)
            c.drawRect(r, p)
            r.left += border
            r.right -= border
            r.top += border
            r.bottom -= border

            d.bounds = r
            d.draw(c)

            return b
        }

        override fun getCurlState(state: String?) {
            mStateOfCurl = state ?: "0"
        }

        override fun updatePage(page: CurlPage, width: Int, height: Int, k: Int) {
            // showLog("page numbers", "${page} ${width} ${height} ${k}")
            //var imageNamesArrayList = mutableListOf<String>()

            var even = 0
            var odd = 0

            currentIndexValue = k

            val albumImagesMapKeyArray = albumImagesMap.keys.toTypedArray()
            showLog("CurlActivity :", "updatePage Key Array : " + Arrays.toString(albumImagesMapKeyArray))
            val imageList = albumImagesMap[albumImagesMapKeyArray.get(k)]
            //var nextImageList = albumImagesMap[albumImagesMapKeyArray.get(k+1)]
            //var previousImageList = albumImagesMap[albumImagesMapKeyArray.get(k-1)]

            /*setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageList!![0])
            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageList!![1])*/

            showLog("CurlActivity :", "K Value: $k  -- ${mStateOfCurl}")
            /*try {
                if (mStateOfCurl.equals("0")) {
                    // left curl
                    when (k) {
                        0, 1 -> {
                            // val list = albumImagesMap[albumImagesMapKeyArray.get(0)]
                            var list = try {
                                albumImagesMap[albumImagesMapKeyArray.get(1)]!!
                            } catch (e: java.lang.IndexOutOfBoundsException) {
                                albumImagesMap[albumImagesMapKeyArray.get(0)]!!
                            }
                            if (list!!.get(0).isNotEmpty() && list.get(1).isNotEmpty()) {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list.get(0))
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list.get(1))
                            } else if (list.get(0).isNotEmpty() && list.get(1).isEmpty()) {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, albumImagesMap[albumImagesMapKeyArray.get(0)]!!.get(1))
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list.get(0))
                            } else if (list.get(0).isEmpty() && list.get(1).isNotEmpty()) {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, albumImagesMap[albumImagesMapKeyArray.get(0)]!!.get(1))
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list.get(1))
                            }
                            // val list1 =albumImagesMap[albumImagesMapKeyArray.get(1)]
                        }
                        totalAlbumPaperSize - 2 -> {
                            val newKValue = totalAlbumPaperSize - 1
                            val list = albumImagesMap[albumImagesMapKeyArray.get(newKValue)]
                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list!![0])
                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])

                            if (list[0].isNotEmpty() && list[1].isNotEmpty()) {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[0])
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])
                            } else if (list[0].isNotEmpty() && list[1].isEmpty()) {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[0])
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, albumImagesMap[albumImagesMapKeyArray.get(0)]!!.get(0))
                            } else if (list[0].isEmpty() && list[1].isNotEmpty()) {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[1])
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, albumImagesMap[albumImagesMapKeyArray.get(0)]!!.get(0))
                            } else {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[0])
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])
                            }
                        }
                        else -> {
                            val previousImageList = albumImagesMap[albumImagesMapKeyArray.get(k + 1)]
                            //  showLog("right curl numbers11", "${k} ${(k * 2) - 2}  ${(k * 2) - 1}   ${imageNamesArrayList.get((k * 2) - 2)} ${imageNamesArrayList.get((k * 2) - 1)}")
                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, previousImageList!![0])
                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, previousImageList[1])
                        }
                    }
                } else if (mStateOfCurl.equals("1")) {
                    // right curl
                    when (k) {
                        0 -> {
                            val list = albumImagesMap[albumImagesMapKeyArray.get(0)]
                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list!![0])
                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])
                        }
                        totalAlbumPaperSize - 1 -> {
                            val newKValue = totalAlbumPaperSize - 1
                            val list = albumImagesMap[albumImagesMapKeyArray.get(newKValue)]
                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list!![0])
                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])

                            if (list[0].isNotEmpty() && list[1].isNotEmpty()) {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[0])
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])
                            } else if (list[0].isNotEmpty() && list[1].isEmpty()) {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[0])
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, albumImagesMap[albumImagesMapKeyArray.get(0)]!!.get(0))
                            } else if (list[0].isEmpty() && list[1].isNotEmpty()) {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[1])
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, albumImagesMap[albumImagesMapKeyArray.get(0)]!!.get(0))
                            } else {
                                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, list[0])
                                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, list[1])
                            }
                        }
                        else -> {
                            //val currentPos = k + 1
                            // try {
                            // showLog("page numbers11", "${currentPos} ${(currentPos * 2) - 2}  ${(currentPos * 2) - 1}  ${imageNamesArrayList.get((currentPos * 2) - 2)}  ${imageNamesArrayList.get((currentPos * 2) - 1)} ")
                            setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageList!![0])
                            setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageList[1])
                        }
                    }
                }
            } catch (e: ArrayIndexOutOfBoundsException) {
                setStringPreference(mContext!!, FIRST_IMAGE_ZOOM, imageList!![0])
                setStringPreference(mContext!!, SECOND_IMAGE_ZOOM, imageList[1])
            }*/

            showLog("CurlActivity :", "totalAlbumPaperSize : $totalAlbumPaperSize , k : $k")
            if (totalAlbumPaperSize - 1 == k) {
                try {
                    if (albumImagesMap[albumImagesMapKeyArray.get(k)]!!.get(0) == "" || albumImagesMap[albumImagesMapKeyArray.get(k)]!!.get(1) == "") {
                        showLog("CurlActivity : ", "updatePage : if step 1 K::$k")
                        page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_FRONT)
                    } else {
                        showLog("CurlActivity : ", "updatePage : if step 2 K::$k")
                        page.setTexture(loadFrontBitmap(width, height, k, getBitmapFromIndex1(imageList?.get(1)!!)), CurlPage.SIDE_FRONT)
                    }
                } catch (e: OutOfMemoryError) {
                    page.setTexture(loadFrontBitmap(width, height, k, getSampleEmptyBitmap()), CurlPage.SIDE_FRONT)
                }

                try {
                    val imageList = albumImagesMap[albumImagesMapKeyArray.get(0)]
                    page.setTexture(loadBackBitmap(width, height, k, getBitmapFromIndex1(imageList?.get(0)!!)), CurlPage.SIDE_BACK)
                } catch (e: OutOfMemoryError) {
                    page.setTexture(loadBackBitmap(width, height, k, getSampleEmptyBitmap()), CurlPage.SIDE_BACK)
                }
            } else if (k == 0) {

                try {
                    if (albumImagesMap[albumImagesMapKeyArray.get(k)]!!.get(1) == "") {
                        showLog("CurlActivity : ", "updatePage : if else step 1")
                        page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_FRONT)
                    } else {
                        showLog("CurlActivity : ", "updatePage : if else step 2 K::$k : ${imageList!![1]}")
                        page.setTexture(loadFrontBitmap(width, height, k, getBitmapFromIndex1(imageList?.get(1)!!)), CurlPage.SIDE_FRONT)
                    }
                } catch (e: OutOfMemoryError) {
                    page.setTexture(loadFrontBitmap(width, height, k, getSampleEmptyBitmap()), CurlPage.SIDE_FRONT)
                }

                try {
                    if (albumImagesMap[albumImagesMapKeyArray.get(k + 1)]!!.get(0) != "" && albumImagesMap[albumImagesMapKeyArray.get(k + 1)]!!.get(1) != "") {
                        showLog("CurlActivity : ", "updatePage : if else step 3 K::$k")
                        var nextImageList = albumImagesMap[albumImagesMapKeyArray.get(k + 1)]
                        page.setTexture(loadBackBitmap(width, height, k, getBitmapFromIndex1(nextImageList!![0])), CurlPage.SIDE_BACK)
                    } else {
                        page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_BACK)
                    }
                } catch (e: OutOfMemoryError) {
                    page.setTexture(loadBackBitmap(width, height, k, getSampleEmptyBitmap()), CurlPage.SIDE_BACK)
                }

            } else if (k == 1) {

                try {
                    if (albumImagesMap[albumImagesMapKeyArray.get(k)]!!.get(1) == "") {
                        showLog("CurlActivity : ", "updatePage : if else step 1")
                        page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_FRONT)
                    } else {
                        showLog("CurlActivity : ", "updatePage : if else step 2 K::$k : ${imageList!![0]}")
                        page.setTexture(loadFrontBitmap(width, height, k, getBitmapFromIndex1(imageList?.get(1)!!)), CurlPage.SIDE_FRONT)
                    }
                } catch (e: OutOfMemoryError) {
                    page.setTexture(loadFrontBitmap(width, height, k, getSampleEmptyBitmap()), CurlPage.SIDE_FRONT)
                }

                try {
                    if (albumImagesMap[albumImagesMapKeyArray.get(k + 1)]!!.get(0) == "") {
                        if (albumImagesMap[albumImagesMapKeyArray.get(k + 1)]!!.get(1) != "") {
                            var nextImageList = albumImagesMap[albumImagesMapKeyArray.get(k + 1)]
                            showLog("CurlActivity : ", "updatePage : if else step 4 K::$k : ${nextImageList!![1]}")
                            page.setTexture(loadBackBitmap(width, height, k, getBitmapFromIndex1(nextImageList!![1])), CurlPage.SIDE_BACK)
                        }
                    } else {
                        var nextImageList = albumImagesMap[albumImagesMapKeyArray.get(k + 1)]
                        showLog("CurlActivity : ", "updatePage : if else step 4 K::$k : ${nextImageList!![0]}")
                        page.setTexture(loadBackBitmap(width, height, k, getBitmapFromIndex1(nextImageList!![0])), CurlPage.SIDE_BACK)
                    }
                } catch (e: OutOfMemoryError) {
                    page.setTexture(loadBackBitmap(width, height, k, getSampleEmptyBitmap()), CurlPage.SIDE_BACK)
                }

            } else {

                try {
                    if (albumImagesMap[albumImagesMapKeyArray.get(k)]!!.get(0) != "" && albumImagesMap[albumImagesMapKeyArray.get(k)]!!.get(1) != "") {
                        showLog("CurlActivity : ", "updatePage : if else step 2 K::$k : ${imageList!![0]}")
                        page.setTexture(loadFrontBitmap(width, height, k, getBitmapFromIndex1(imageList?.get(1)!!)), CurlPage.SIDE_FRONT)
                    } else {
                        showLog("CurlActivity : ", "updatePage : if else step 1")
                        page.setColor(Color.rgb(180, 180, 180), CurlPage.SIDE_FRONT)
                    }
                } catch (e: OutOfMemoryError) {
                    page.setTexture(loadFrontBitmap(width, height, k, getSampleEmptyBitmap()), CurlPage.SIDE_FRONT)
                }

                try {
                    if (albumImagesMap[albumImagesMapKeyArray.get(k + 1)]!!.get(0) == "") {
                        if (albumImagesMap[albumImagesMapKeyArray.get(k + 1)]!!.get(1) != "") {
                            var nextImageList = albumImagesMap[albumImagesMapKeyArray.get(k + 1)]
                            showLog("CurlActivity : ", "updatePage : if else step 4 K::$k : ${nextImageList!![1]}")
                            page.setTexture(loadBackBitmap(width, height, k, getBitmapFromIndex1(nextImageList!![1])), CurlPage.SIDE_BACK)
                        }
                    } else {
                        var nextImageList = albumImagesMap[albumImagesMapKeyArray.get(k + 1)]
                        showLog("CurlActivity : ", "updatePage : if else step 4 K::$k : ${nextImageList!![0]}")
                        page.setTexture(loadBackBitmap(width, height, k, getBitmapFromIndex1(nextImageList!![0])), CurlPage.SIDE_BACK)
                    }
                } catch (e: OutOfMemoryError) {
                    page.setTexture(loadBackBitmap(width, height, k, getSampleEmptyBitmap()), CurlPage.SIDE_BACK)
                }
            }
        }
    }

    private fun getSampleEmptyBitmap(): Bitmap {
        return Bitmap.createBitmap(10, 10, Bitmap.Config.ARGB_8888)
    }


    fun showLog(key: String, value: String) {
        Log.e(key, value)
    }

    private fun getBitmapFromIndex1(s: String): Bitmap {
        return bitmapHashMap[s]!!
    }


    private fun getImageName(imageNameWithExtension: String): String {
        return File(imageNameWithExtension).nameWithoutExtension
    }

    private fun calculateRatio(width: Int, height: Int) {
        val metrics: DisplayMetrics = this.resources.displayMetrics
        if (metrics.widthPixels > metrics.heightPixels) {
            (curl.layoutParams as ConstraintLayout.LayoutParams).dimensionRatio = "$width:$height"
        } else {
            (curl.layoutParams as ConstraintLayout.LayoutParams).dimensionRatio = "$height:$width"
        }
    }

    private fun getImageFile(imageName: String): Bitmap {
        val applicationDirectory = applicationContext.applicationInfo.dataDir
        val imgFile = File("$applicationDirectory/app_flutter/$imageName")
        if (imgFile.exists()) {
            // Toast.makeText(applicationContext, "true", Toast.LENGTH_LONG).show()
            Log.e("image file", "image file exists")
            return BitmapFactory.decodeFile(imgFile.absolutePath)
            // image_view.setImageBitmap(myBitmap)
        } else {
            // Toast.makeText(applicationContext, "false", Toast.LENGTH_LONG).show()
            Log.e("image file", "image file not exists")
            return getSampleEmptyBitmap()
        }
    }

}


data class CurlAlbumImageDataModel(
        val images: List<Image>
)

data class Image(
        val image_name: String,
        val image_order: Int
)
