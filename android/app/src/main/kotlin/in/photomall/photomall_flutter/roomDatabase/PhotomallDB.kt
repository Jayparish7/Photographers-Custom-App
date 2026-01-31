package `in`.photomall.photomall_flutter.roomDatabase

//import com.photomall.photoalbum.photomallUser.utils.Others.DLog

//import com.photomall.photoalbum.photomallUser.R
//import com.photomall.photoalbum.photomallUser.api.AppConst


//@Database(
//    entities = [
//        Orders::class,
////            PreDesignedAlbumImages::class,
////            PreDesignedAlbumImagesComments::class,
////            RecentEditedPdImagesImportanceLevel::class,
////            RecentEditedPdImages::class,
////            Events::class,
////            Albums::class,
////            AlbumImages::class,
////            Videos::class,
////            AlbumMusics::class
//    ], version = 1, exportSchema = false
//)
//abstract class PhotomallDB : RoomDatabase() {
//
//    abstract fun photomallDao(): PhotomallDao
//
//    companion object {
//
//        var INSTANCE: PhotomallDB? = null
//
//        //var mContext: Context? = null
//
//        fun getInstance(context: Context): PhotomallDB {
//
//            //if(mContext == null) mContext = context
//
//            if (INSTANCE == null) {
//                // synchronized(UserDatabase::class.java) {
//                INSTANCE = Room.databaseBuilder(
//                    context.applicationContext,
//                    PhotomallDB::class.java, "photomall.db"
//                ).createFromAsset(
//                    context.applicationContext.getDatabasePath(
//                        "photomall.db"
//                    ).path
//                )
//                    //.addMigrations(MIGRATION_2_3)
//                    .fallbackToDestructiveMigration()
//                    .build()
//                //  }
//            }
//            return INSTANCE!!
//        }
//
//        private val MIGRATION_2_3: Migration = object : Migration(2, 3) {
//            override fun migrate(database: SupportSQLiteDatabase) {
//                // Since we didn't alter the table, there's nothing else to do here.
//                /*DLog("PhotomallDB: ","MIGRATION_2_3: migrate()")
//                var photomallDao = getInstance(mContext!!).photomallDao()
//                photomallDao.getStudioGalleryAlbumImages().forEach {
//                    val originalImage = File(mContext!!.getExternalFilesDir(null)?.toString() + "/" + mContext!!.getString(R.string.main_folder_name), it.image+it.imageExtension)*//* File(Environment.getDataDirectory().toString() + "/" + context.getString(R.string.main_folder_name) , photoUrl)*//*
//                    //val original_image = File(Environment.getExternalStorageDirectory(), context.resources.getString(R.string.main_folder_name) + "/" +photoUrl)
//                    if (originalImage.delete()) {
//                        DLog("PhotomallDB :", "${it.image} original deleted")
//                    }
//                    if (originalImage.exists()) {
//                        originalImage.canonicalFile.delete()
//                        if (originalImage.exists()) {
//                            mContext!!.deleteFile(originalImage.name)
//                        }
//                    }
//                }
//
//                photomallDao.updateGalleryAlbumImagesStatusToZero()*/
//
//            }
//        }
//
//    }
//}
//
//@Dao
//interface PhotomallDao {
//    var query: String
//        get() = "SELECT jvtFiles.${DBStatics.OPjvtFileCode}, jvtFiles.${DBStatics.OPjvtFileName}, jvtFiles.${DBStatics.OPjvtFileSize} from ${DBStatics.OPtableJvtFiles} jvtFiles " +
//                "INNER JOIN ${DBStatics.OPtableJvtFileConnectors} jvtFileConnectors " +
//                "ON jvtFiles.${DBStatics.OPjvtFileCode} = jvtFileConnectors.${DBStatics.OPjvtFileConnectorJvtFileCode} AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleType} = \"${TransportDataKeys.orders}\" AND jvtFileConnectors.${DBStatics.OPjvtFileConnectorTag} = \"${TransportDataKeys.originalImage}\" AND files.${DBStatics.OPjvtFileDownloaded} = 0 " +
//                "INNER JOIN ${DBStatics.OPtableOrders} orde " +
//                "ON jvtFileConnectors.${DBStatics.OPjvtFileConnectorAbleCode} = orde.${DBStatics.OPorderCode} AND orde.${DBStatics.OPorderAlbumCode} = \"edtbcqmf\" ORDER BY orde.${DBStatics.OPorderPriority} DESC"
//        set(value) = TODO()
//
//    //val df = dbWritable.rawQuery(query, null).count
//    @Query("SELECT COUNT(album_code) FROM orders")
//    fun getPredesignedAlbumLastUpdatedAt(): Int
//}