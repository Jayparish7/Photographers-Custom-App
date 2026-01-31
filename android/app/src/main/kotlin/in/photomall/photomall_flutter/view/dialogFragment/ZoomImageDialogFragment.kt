package `in`.photomall.photomall_flutter.view.dialogFragment

import `in`.photomall.photomall_flutter.R
import `in`.photomall.photomall_flutter.adapter.GetBitmapListener
import `in`.photomall.photomall_flutter.adapter.InvitationImageViewSliderAdapter
import `in`.photomall.photomall_flutter.api.AppConst.IS_LOG_ENABLED
import `in`.photomall.photomall_flutter.api.SharedPreferenceConst.FIRST_IMAGE_ZOOM
import `in`.photomall.photomall_flutter.api.SharedPreferenceConst.SECOND_IMAGE_ZOOM
import `in`.photomall.photomall_flutter.database.AlbumImageType
import `in`.photomall.photomall_flutter.utils.CircleIndicator
import `in`.photomall.photomall_flutter.utils.ExtendedViewPager
import `in`.photomall.photomall_flutter.utils.Others.DLog
import `in`.photomall.photomall_flutter.utils.SharedPreferenceHelper.Companion.getStringPreference
import `in`.photomall.photomall_flutter.view.activity.CurlActivity
import android.app.Activity
import android.app.Dialog
import android.content.Context
import android.graphics.*
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.view.*
import android.widget.RelativeLayout
import `in`.photomall.photomall_flutter.databinding.ZoomImageDialogBinding
//import kotlinx.android.synthetic.main.zoom_image_dialog.view.*
import java.io.File

class ZoomImageDialogFragment : androidx.fragment.app.DialogFragment(), GetBitmapListener {

    var view1: View? = null

    var mContext: Context? = null

    lateinit var viewPagerAdapter: ExtendedViewPager

    var firstImage: String? = null
    var secondImage: String? = null

    var albumImageList = ArrayList<String>()
    var mindicator: CircleIndicator? = null

    var file: File? = null

    var albumSize: Int = 0

    var result: Bitmap? = null
    var canvas: Canvas? = null
    var resized: Bitmap? = null

    var imageHeight = 0
    var imageWidth = 0

    var typeOfScreen: Int = 0

    var curlActivity: Activity? = null

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mContext = context
    }

    override fun onStart() {
        super.onStart()
        val dialog = dialog
        if (dialog != null) {
            val width = ViewGroup.LayoutParams.MATCH_PARENT
            val height = ViewGroup.LayoutParams.MATCH_PARENT
            dialog.window!!.setLayout(width, height)
        }
    }

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        //return super.onCreateDialog(savedInstanceState)
        val root = RelativeLayout(activity)
        root.layoutParams = ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        val dialog = Dialog(mContext!!)
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE)
        dialog.setContentView(root)
        dialog.window!!.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        dialog.window!!.setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        return dialog
    }
    private lateinit var binding: ZoomImageDialogBinding

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {

        //Couldn't Capture Screenshot
        if (!IS_LOG_ENABLED) {
            dialog!!.window!!.setFlags(WindowManager.LayoutParams.FLAG_SECURE,
                    WindowManager.LayoutParams.FLAG_SECURE)
        }

        view1 = inflater.inflate(R.layout.zoom_image_dialog, container, false)
        binding = ZoomImageDialogBinding.inflate(inflater, container, false)

        if (arguments != null) {
            //albumSize= arguments!!.getInt("Album_Size")
            imageWidth = requireArguments().getInt("width")
            imageHeight = requireArguments().getInt("height")
            typeOfScreen = requireArguments().getInt("typeOfScreen")

        }

        firstImage = getStringPreference(mContext!!, FIRST_IMAGE_ZOOM, "")
        secondImage = getStringPreference(mContext!!, SECOND_IMAGE_ZOOM, "")

        albumImageList.add(firstImage!!)
        albumImageList.add(secondImage!!)

        curlActivity = activity as CurlActivity

        DLog("First Image and Second Image", "${firstImage},${secondImage} ${albumSize}")

        fillImagesInViewPager()

        binding!!.zoomImageDialogExitImageView.setOnClickListener {
            dismiss()
        }
        //return view1!!
        return binding.root
    }

   /* private fun getFilePath(imageName: String): Bitmap {
        val options = BitmapFactory.Options()
        options.inSampleSize = 2
        file = File(mContext!!.getExternalFilesDir(null), mContext!!.getString(R.string.main_folder_name) + "/" + imageName)
        val bitmap = BitmapFactory.decodeStream(file!!.inputStream(), null, options)
        return bitmap!!
    }

    private fun createSingleImageFromMultipleImages(firstImage: Bitmap, secondImage: Bitmap): Bitmap {
        DLog("Width", "${firstImage.width} ${secondImage.width} ${firstImage.height} ${secondImage.height}")
        result = Bitmap.createBitmap((firstImage.width + secondImage.width), secondImage.height, secondImage.config)
        drawBitmap(result!!, firstImage, secondImage)
        return result!!
    }

    private fun createSingleImageFromMultipleImages1(firstImage: Bitmap, secondImage: Bitmap): Bitmap {
        DLog("Width", "${firstImage.width} ${secondImage.width} ${firstImage.height} ${secondImage.height}")
        resized = Bitmap.createScaledBitmap(secondImage, firstImage.width, firstImage.height, true)
        result = Bitmap.createBitmap((firstImage.width + resized!!.width), firstImage.height, secondImage.config)
        drawBitmap(result!!, firstImage, resized!!)
        return result!!
    }*/

    private fun drawBitmap(result: Bitmap, firstImage: Bitmap, secondImage: Bitmap) {
        DLog("Width", "${firstImage.width.toFloat()}")
        canvas = Canvas(result)
        canvas!!.drawBitmap(firstImage, 0f, 0f, null)
        canvas!!.drawBitmap(secondImage, firstImage.width.toFloat(), 0f, null)
    }

    private fun fillImagesInViewPager() {
        viewPagerAdapter = binding.viewPager//view1!!.findViewById(R.id.view_pager) as ExtendedViewPager
        viewPagerAdapter.adapter = InvitationImageViewSliderAdapter(mContext!!, albumImageList, this)
        mindicator = binding.homeFragmentImageSliderIndicator
        mindicator?.setViewPager(viewPagerAdapter)
    }

    override fun getDecryptedImageBitmap(imageUrl: String): Bitmap {
        if(firstImage!!.isNotEmpty() && secondImage!!.isNotEmpty()){
            return (curlActivity!! as CurlActivity).getBitmapFromIndex1(imageUrl, AlbumImageType.full.toString())
        }
        return (curlActivity!! as CurlActivity).getBitmapFromIndex1(imageUrl, AlbumImageType.half.toString())
       /* return if (typeOfScreen == 1) {
            (curlActivity!! as CurlActivity).getBitmapFromIndex1(imageUrl)
        }else if(typeOfScreen == 2){
            (curlActivity!! as GalleryCurlActivity).getBitmapFromIndex1(imageUrl)
        }else{
            (curlActivity!! as CurlActivity).getBitmapFromIndex1(imageUrl)
        }*/
    }

    override fun onResume() {
        // Store access variables for window and blank point
        val window = dialog!!.window
        val size = Point()
        // Store dimensions of the screen in `size`
        val display = window!!.windowManager.defaultDisplay
        display.getSize(size)
        // Set the width of the dialog proportional to 75% of the screen width
        window.setLayout((size.x * 1).toInt(), WindowManager.LayoutParams.MATCH_PARENT)
        window.setGravity(Gravity.CENTER)
        // Call super onResume after sizing
        super.onResume()
    }
}