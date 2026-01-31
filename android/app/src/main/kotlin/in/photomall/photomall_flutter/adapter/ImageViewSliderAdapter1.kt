package `in`.photomall.photomall_flutter.adapter

import `in`.photomall.photomall_flutter.R
import `in`.photomall.photomall_flutter.database.AlbumImageType
import `in`.photomall.photomall_flutter.database.DbHelper
import `in`.photomall.photomall_flutter.interfaces.AlbumThumbnailDownloadCompletedListener
import `in`.photomall.photomall_flutter.utils.Others.DLog
import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import androidx.recyclerview.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup         //ItemImageViewSliderBinding
//import kotlinx.android.synthetic.main.imageview_slider_recyclerview_resource.view.*
import `in`.photomall.photomall_flutter.databinding.ImageviewSliderRecyclerviewResourceBinding
import java.lang.IndexOutOfBoundsException

class ImageViewSliderAdapter1(internal var context: Context, internal var imageViewSliderActivityModel: LinkedHashMap<String, ArrayList<String>>) : androidx.recyclerview.widget.RecyclerView.Adapter<ImageViewSliderAdapter1.ViewHolder>() {
    internal var dbHelper: DbHelper? = null
    var folderPath: String? = null
    var selectedPos: Int? = null

    var result: Bitmap? = null
    var canvas: Canvas? = null

    var albumThumbnailDownloadCompletedListener: AlbumThumbnailDownloadCompletedListener? = null

    init {
        //dbHelper = DbHelper.getInstance(context.applicationContext)
        dbHelper = DbHelper.getInstance(context)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.imageview_slider_recyclerview_resource, parent, false)
        val binding = ImageviewSliderRecyclerviewResourceBinding.inflate(LayoutInflater.from(parent.context), parent, false)

        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(imageViewSliderActivityModel["${position + 1}"], position)
    }

    private fun createSingleImageFromMultipleImages(firstImage: Bitmap, secondImage: Bitmap): Bitmap {

        DLog("Width", "${firstImage.width} ${secondImage.width} ${firstImage.height} ${secondImage.height}")
       // result = Bitmap.createBitmap((firstImage.width + secondImage.width), secondImage.height, secondImage.config)
        result = Bitmap.createBitmap(
            (firstImage.width + secondImage.width),
            secondImage.height,
            secondImage.config ?: Bitmap.Config.ARGB_8888
        )

        canvas = Canvas(result!!)
        canvas!!.drawBitmap(firstImage, 0f, 0f, null)
        canvas!!.drawBitmap(secondImage, firstImage.width.toFloat(), 0f, null)
        return result!!
    }


    fun setOnItemclickListener(albumThumbnailDownloadCompletedListener: AlbumThumbnailDownloadCompletedListener) {
        this.albumThumbnailDownloadCompletedListener = albumThumbnailDownloadCompletedListener
    }

    fun setOnItemClickListener(albumThumbnailDownloadCompletedListener: AlbumThumbnailDownloadCompletedListener) {
        this.albumThumbnailDownloadCompletedListener = albumThumbnailDownloadCompletedListener
    }

    override fun getItemCount(): Int {
        DLog("imageViewSliderActivityModel", "${imageViewSliderActivityModel.size}")
        return imageViewSliderActivityModel.size
    }

    inner class ViewHolder(private val binding: ImageviewSliderRecyclerviewResourceBinding) : RecyclerView.ViewHolder(binding.root) {

        fun bind(imageList: ArrayList<String>?, position: Int) {
           // val binding = ImageviewSliderRecyclerviewResourceBinding.inflate(LayoutInflater.from(parent.context), parent, false)

            try {
                if (imageList!![0] != "" && imageList!![1] != "") {
                    binding.spaceView.visibility = View.GONE
                }

                /*if(imageList!![2] == AlbumImageType.full.toString()){
                    itemView.imageview_slider_recyclerview_resource_imageView1.setImageBitmap(albumThumbnailDownloadCompletedListener?.getBitmapListener(imageList[0], imageList[2]))
                }else{
                    if(imageList!![0] != ""){
                        itemView.imageview_slider_recyclerview_resource_imageView1.setImageBitmap(albumThumbnailDownloadCompletedListener?.getBitmapListener(imageList[0], imageList[2]))
                    }else if(imageList!![1] != ""){
                        itemView.imageview_slider_recyclerview_resource_imageView1.setImageBitmap(albumThumbnailDownloadCompletedListener?.getBitmapListener(imageList[1], imageList[2]))
                    }
                }*/

                //var isShown = false
                if (imageList!![0] != "") {
                    //isShown = true
                    //itemView.imageview_slider_recyclerview_resource_imageView1.setImageBitmap(albumThumbnailDownloadCompletedListener?.getBitmapListener(imageList[0], imageList[2]))
                    binding.imageviewSliderRecyclerviewResourceImageView1.setImageBitmap(albumThumbnailDownloadCompletedListener?.getBitmapListener(imageList[0], imageList[2]))
                } else {
                    DLog("ImageViewSliderAdapter1:", "bind() inside 1 else")
                    //itemView.imageview_slider_recyclerView_resource_constraintLayout1.visibility = View.GONE
                    binding.imageviewSliderRecyclerViewResourceConstraintLayout1.visibility = View.GONE
                }

                //if(!isShown) {
                if (imageList[1] != "") {
                    //itemView.imageview_slider_recyclerview_resource_imageView2.setImageBitmap(
                    binding.imageviewSliderRecyclerviewResourceImageView2.setImageBitmap(
                            albumThumbnailDownloadCompletedListener?.getBitmapListener(imageList[1], imageList[2])
                    )
                } else {
                    DLog("ImageViewSliderAdapter1:", "bind() inside 2 else")
                   // itemView.imageview_slider_recyclerView_resource_constraintLayout2.visibility =
                          //  View.GONE
                    binding.imageviewSliderRecyclerViewResourceConstraintLayout2.visibility =
                            View.GONE
                }
                //}
                if (imageList!![0] != "" && imageList!![1] != "") {
                    //itemView.imageview_slider_recyclerView_resource_constraintLayout2.visibility = View.GONE
                }
                //itemView.imageview_slider_recyclerview_resource_imageView1.setOnClickListener

                binding.imageviewSliderRecyclerviewResourceImageView1.setOnClickListener {
                    selectedPos = position
                    //notifyDataSetChanged()
                    albumThumbnailDownloadCompletedListener?.singleImageClickListener(position, imageList)
                }
                //itemView.imageview_slider_recyclerview_resource_imageView2.setOnClickListener
                binding.imageviewSliderRecyclerviewResourceImageView2.setOnClickListener {
                    selectedPos = position
                    //notifyDataSetChanged()
                    albumThumbnailDownloadCompletedListener?.singleImageClickListener(position, imageList)
                }

                /*if(selectedPos==position) {
                itemView.imageview_slider_recyclerView_resource_constraintLayout.background= getDrawable(context,R.drawable.bg_button_with_border)
            } else {
                itemView.imageview_slider_recyclerView_resource_constraintLayout.setBackgroundColor(ContextCompat.getColor(context,R.color.black))
            }*/
            } catch (e: IndexOutOfBoundsException) {
            } catch (e: ArrayIndexOutOfBoundsException) {
            } catch (e: Exception) {
            }

        }
    }
}