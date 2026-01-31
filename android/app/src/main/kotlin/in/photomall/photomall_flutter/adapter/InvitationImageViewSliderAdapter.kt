package `in`.photomall.photomall_flutter.adapter
import `in`.photomall.photomall_flutter.R
import `in`.photomall.photomall_flutter.utils.Others.DLog
import `in`.photomall.photomall_flutter.utils.StorageUtils
import android.content.Context
import android.graphics.Bitmap
import android.widget.LinearLayout
import android.view.ViewGroup
import android.view.LayoutInflater
import android.view.View
import `in`.photomall.photomall_flutter.databinding.PagerItemBinding
//import kotlinx.android.synthetic.main.fragment_event_home.*

import java.io.File


public class InvitationImageViewSliderAdapter(var mContext: Context,var invitationImages:ArrayList<String>, var listener: GetBitmapListener) : androidx.viewpager.widget.PagerAdapter() {
    var mLayoutInflater: LayoutInflater
    var file:File?=null


    init {
        mLayoutInflater = mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
    }

    override fun getCount(): Int {
        return invitationImages.size
    }

    override fun isViewFromObject(view: View, `object`: Any): Boolean {
        return view === `object` as LinearLayout

    }


    override fun instantiateItem(container: ViewGroup, position: Int): Any {
        val itemView = mLayoutInflater.inflate(R.layout.pager_item, container, false)
        val binding = PagerItemBinding.inflate(LayoutInflater.from(container.context), container, false)

        //val file = getFile(invitationImages[position])
        val imageName = invitationImages[position].substring(0, invitationImages[position].lastIndexOf("-"))
        val imageExtension = invitationImages[position].substring(invitationImages[position].lastIndexOf("."), invitationImages[position].length)
        val imageNameInFile = imageName + imageExtension
        val file = StorageUtils.getFile(mContext, imageNameInFile)
        if (file.exists()) {
            //tmp = BitmapFactory.decodeFile(file!!.absolutePath)
            //tmp = decodeFile(file!!, mContext)
            var tmp:Bitmap?=null

            tmp = listener.getDecryptedImageBitmap(invitationImages[position])
            tmp.let {
                binding.pagerItemImageView.setImageBitmap(Bitmap.createBitmap(it))
                container.addView(binding.root)
            }
            //itemView.pager_item_imageView.setImageBitmap(Bitmap.createBitmap(tmp!!))
            //Picasso.get().load(file!!).error(R.drawable.logo).into(itemView.pager_item_imageView)
            DLog("ImageInZoomViewDialogFragment :", "File ${invitationImages[position]} exists")
        } else {
            DLog("ImageInZoomViewDialogFragment :", "File ${invitationImages[position]} not exists")
        }

        container.addView(itemView)

        //return itemView
        return binding.root

    }

    override fun destroyItem(container: ViewGroup, position: Int, `object`: Any) {
        container.removeView(`object` as LinearLayout)
    }

    fun getFile(imageName: String): File {
        val applicationDirectory = mContext.applicationContext.applicationInfo.dataDir
        return File("$applicationDirectory/app_flutter/$imageName")
    }

}

interface GetBitmapListener{
    fun getDecryptedImageBitmap(imageUrl: String): Bitmap
}