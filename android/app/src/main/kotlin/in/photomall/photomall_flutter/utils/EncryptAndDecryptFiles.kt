package `in`.photomall.photomall_flutter.utils

import org.bouncycastle.jce.provider.BouncyCastleProvider
import `in`.photomall.photomall_flutter.R
import `in`.photomall.photomall_flutter.appUtils.memoryManagement.MemUtils
import `in`.photomall.photomall_flutter.database.AlbumImageType
import `in`.photomall.photomall_flutter.utils.Others.DLog
import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Log
import java.io.*
import java.security.*
import javax.crypto.*
import javax.crypto.spec.PBEKeySpec
import javax.crypto.spec.SecretKeySpec


object EncryptAndDecryptFiles {

    var decodedBitmap: Bitmap? = null
    var encryptionAndDecryptionKey: String? = null

    // var options:

    external fun getKey(): String

    var iv: ByteArray? = null

    init {
        //System.loadLibrary("keys")
        //iv = getIV()
    }

    /*fun getNativeKey() {
        var sd = getKeyFromJNI()
        DLog("EncryptAndDecryptFiles : ", "KEY : $sd")
    }*/

    var algorithm = "AES"
    var yourKey: SecretKey? = null

    private fun getIV(): ByteArray {
        val random = SecureRandom()
        return random.generateSeed(16)
    }

    @SuppressLint("DeletedProvider")
    @Throws(Exception::class)
    fun generateKey(): SecretKey? {
        val keyStart = "ddddd".toByteArray(charset("UTF-8"))
        val kgen = KeyGenerator.getInstance("AES")
        //val sr = SecureRandom.getInstance("SHA1PRNG", "Crypto")
        //sr.setSeed(keyStart)
        kgen.init(128)
        //val skey = kgen.generateKey()
        return kgen.generateKey()
    }

    //@Throws(Exception::class)
    fun encodeFile(fileData: ByteArray): ByteArray {
        //val skeySpec = SecretKeySpec(generateKey(), "AES")
        /*fileData.forEach {
            DLog("EncryptAndDecrypt:", "inside encodeFile fileData: $it")
        }*/

        val skeySpec = generateKey()
        val cipher: Cipher
        var encrypted: ByteArray? = null
        //try {
        // Get Cipher instance for AES algorithm
        cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
        // Initialize cipher
        //cipher.init(Cipher.ENCRYPT_MODE, skeySpec, IvParameterSpec(iv))
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec)
        // Encrypt the image byte data
        encrypted = cipher.doFinal(fileData)

        DLog("EncryptAndDecrypt:", "inside encodeFile try")


        /* val arrayInputStream = ByteArrayInputStream(encrypted)

         var bmp = BitmapFactory.decodeStream(
                 arrayInputStream)

         if(arrayInputStream == null){
             DLog("EncryptAndDecrypt:", "inside encodeFile check bmp is null")
         }else{
             DLog("EncryptAndDecrypt:", "inside encodeFile check bmp is not null")
         }*/

        /*val options = BitmapFactory.Options()
        var bmp = BitmapFactory.decodeByteArray(encrypted, 0 , encrypted!!.size, options)*/

        return encrypted!!

        /*return BitmapFactory.decodeByteArray(
                encrypted,
                0,
                encrypted!!.size)!!*/
        /*} catch (e: Exception) {
            DLog("EncryptAndDecrypt:", "inside encodeFile catch : ${e.message}")
            //e.printStackTrace()
        }
        val w = 1
        val h = 1
        val conf = Bitmap.Config.ARGB_8888 // see other conf types
        val bmp = Bitmap.createBitmap(w, h, conf)
        return bmp*/
    }

    //@Throws(Exception::class)
    /*fun decodeFile(file: File): Bitmap {
        DLog("decodeFile", "${file}")

        var file1 = FileInputStream(file)
        //val skeySpec = SecretKeySpec(generateKey(), "AES")
        val skeySpec = generateKey()
        val cipher: Cipher
        var decryptedData: ByteArray? = null
        var cis: CipherInputStream? = null
        var fileFromBytes: File? = null

        var bis: ByteArrayInputStream? = null
        var ois: ObjectInputStream? = null

        try {
            cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
            //cipher.init(Cipher.DECRYPT_MODE, skeySpec, IvParameterSpec(iv))
            cipher.init(Cipher.DECRYPT_MODE, skeySpec)
            // Create CipherInputStream to read and decrypt the image data
            cis = CipherInputStream(file1, cipher)
            // Write encrypted image data to ByteArrayOutputStream
            val buffer = ByteArrayOutputStream()
            val data = ByteArray(2048)
            while (cis.read(data) != -1) {
                buffer.write(data)
            }
            buffer.flush()
            decryptedData = buffer.toByteArray()
        } catch (e: EOFException) {
            DLog("EncryptAndDecrypt:", "er : ${e.message}")
            e.printStackTrace()
        } finally {
            try {
                file1.close()
                cis!!.close()
            } catch (e: IOException) {
                e.printStackTrace()
            }
        }
//        val w = 1
//        val h = 1
//        val conf = Bitmap.Config.ARGB_8888 // see other conf types
//        val bmp = Bitmap.createBitmap(w, h, conf)
//        return bmp

//        bis = ByteArrayInputStream(decryptedData)
//        ois = ObjectInputStream(bis)
//        fileFromBytes = ois.readObject() as File
//        bis?.close()
//        ois?.close()

        //File(decryptedData)
        val arrayInputStream = ByteArrayInputStream(decryptedData)
        DLog("EncryptAndDecrypt : ", "arrayInputStream: " + arrayInputStream.toString())
        val bitmap = BitmapFactory.decodeStream(arrayInputStream)

        //val bmp = BitmapFactory.decodeByteArray(decryptedData, 0, decryptedData!!.size)
        return bitmap
    }*/

    ////////////////////////////////////////////

    //@Throws(NoSuchAlgorithmException::class, InvalidKeySpecException::class)
    fun generateKey(passphraseOrPin: CharArray, salt: ByteArray): SecretKey {
        // Number of PBKDF2 hardening rounds to use. Larger values increase
        // computation time. You should select a value that causes computation
        // to take >100ms.
        val iterations = 1000

        // Generate a 256-bit key
        val outputKeyLength = 256

        val secretKeyFactory = SecretKeyFactory
                .getInstance("PBKDF2WithHmacSHA1")
        val keySpec = PBEKeySpec(passphraseOrPin, salt, iterations, outputKeyLength)
        yourKey = secretKeyFactory.generateSecret(keySpec)
        return yourKey!!
    }

    //@Throws(NoSuchAlgorithmException::class)
    fun generateSalt(): SecretKey {
        // Generate a 256-bit key
        val outputKeyLength = 256

        val secureRandom = SecureRandom()
        // Do *not* seed secureRandom! Automatically seeded from system entropy.
        val keyGenerator = KeyGenerator.getInstance("AES")
        keyGenerator.init(outputKeyLength, secureRandom)
        return keyGenerator.generateKey()
    }

    /*fun createSecretKey(context: Context) {
        val p = charArrayOf('p', 'a', 's', 's')
        val yourKey = generateKey(p, generateSalt().toString().toByteArray())
        //val filesBytes = encodeFile(yourKey, byteArray)
        setStringPreference(context, SharedPreferenceConst.SECRET_KEY, yourKey.toString())
    }*/

    fun getKeyFromJNI(context: Context): SecretKey {

        //val p = getKey()
        val p = encryptionAndDecryptionKey
        val yourKey = generateKey(p!!.toCharArray(), p.toByteArray())
        return yourKey

        /*val p = charArrayOf('p', 'a', 's', 's')
        val yourKey = generateKey(p, "pass".toByteArray())
        return yourKey*/

        /*var yourKey = getStringPreference(context, SharedPreferenceConst.SECRET_KEY, "")
        val decodedKey = Base64.getDecoder().decode(yourKey)
        return SecretKeySpec(decodedKey, 0, decodedKey.size, "AES")*/
    }

    //@Throws(Exception::class)
    //fun encodeFile(yourKey: String, fileData: ByteArray): ByteArray {
    fun encodeFile(yourKey: SecretKey, fileData: ByteArray): ByteArray {
        val data = yourKey.encoded
        //val data = yourKey.toByteArray()
        val skeySpec = SecretKeySpec(data, 0, data.size, algorithm)
        val cipher = Cipher.getInstance(algorithm)
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec)
        return cipher.doFinal(fileData)
    }

    //@Throws(Exception::class)
    //fun decodeFile(yourKey: String, fileData: ByteArray): ByteArray {
    fun decodeFile(yourKey: SecretKey, fileData: ByteArray): ByteArray {
        val data = yourKey.encoded
        //val data = yourKey.toByteArray()
        val skeySpec = SecretKeySpec(data, 0, data.size, algorithm)
        val cipher = Cipher.getInstance(algorithm)
        cipher.init(Cipher.DECRYPT_MODE, skeySpec)
        return cipher.doFinal(fileData)
    }

    fun saveFile(file: File, byteArray: ByteArray, context: Context) {
        try {
            /*DLog("EncryptAndDecryptFiles: ","saveFile: ${file.absolutePath} : ${file.path}")
            var filePath = file.absolutePath
            var encryptedFileName = filePath.substring(0, filePath.lastIndexOf('/')) + "/${hashKey(file.name)}"
            DLog("EncryptAndDecryptFiles: ","saveFile: substring : $encryptedFileName")
            //filePath.replace(file.name, hashKey(file.name))
            //DLog("EncryptAndDecryptFiles: ","File: $filePath : ${hashKey(file.name)}")
            file.renameTo(File(encryptedFileName))
            //hashKey(file.name)*/
            //val file = File(Environment.getExternalStorageDirectory() + File.separator, encryptedFileName)
            //val bos = BufferedOutputStream(FileOutputStream(File(encryptedFileName)))
            val bos = BufferedOutputStream(FileOutputStream(file))
            val p = charArrayOf('p', 'a', 's', 's')
            //val yourKey = generateKey(p, generateSalt().toString().toByteArray())
            //val yourKey = generateKey(p, "pass".toByteArray())
            //val yourKey = getStringPreference(context, SharedPreferenceConst.SECRET_KEY, "")
            val filesBytes = encodeFile(getKeyFromJNI(context), byteArray)
            bos.write(filesBytes)
            bos.flush()
            bos.close()
        } catch (e: FileNotFoundException) {
            e.printStackTrace()
        } catch (e: IOException) {
            e.printStackTrace()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun decodeFileWithSplit(file: File, context: Context, imageType: Int): List<Bitmap> {
        try {
            /*var filePath = file.absolutePath
            filePath.replace(file.name, hashKey(file.name))*/
            /*var filePath = file.absolutePath
            var encryptedFileName = filePath.substring(0, filePath.lastIndexOf('/')) + "/${hashKey(file.name)}"
            file.renameTo(File(encryptedFileName))
            DLog("EncryptAndDecryptFiles: ","decodeFile: ${encryptedFileName} : ${file.path}")*/
            //val yourKey = getStringPreference(context, SharedPreferenceConst.SECRET_KEY, "")
            //val decodedData = decodeFile(getKeyFromJNI(context), readFile(File(encryptedFileName)))

            //decodedBitmap!!.recycle()
            //System.gc()

            decodedBitmap = if(StorageUtils.enableEncrypt){
                //val decodedData = decodeFile(getKeyFromJNI(context), readFile(file))
                val decodedData = decodeImageFile(getKeyFromJNI(context), readFile(file), file)
                //val decodedData = decodeImageFile(getKeyFromJNI(context), file)
                BitmapFactory.decodeByteArray(decodedData, 0, decodedData.size)
            }else{
                BitmapFactory.decodeFile(file.absolutePath)
            }

            val size = (decodedBitmap!!.width * decodedBitmap!!.height * 4)

            if(size >= MemUtils.calculateHeapMemory()){
                DLog("EncryptAndDecryptFiles: ", "decodeFile() if")
                //decodedBitmap = Bitmap.createBitmap(0, 0, Bitmap.Config.ARGB_8888)
                decodedBitmap = BitmapFactory.decodeResource(context.resources, R.drawable.no_memory_available_error)
            } else {
                DLog("EncryptAndDecryptFiles: ", "decodeFile() if else")
            }

            DLog("EncryptAndDecryptFiles: ", "decodeFile() WIDTH: ${decodedBitmap!!.width} :: HEIGHT: ${decodedBitmap!!.height} :: SIZE: ${size / MemUtils.BYTES_IN_MB} :: REMAIN")

            //MemUtils.calculateHeapMemory()
            if(imageType == AlbumImageType.full) {
                val bm1 = Bitmap.createBitmap(decodedBitmap!!, 0, 0, decodedBitmap!!.width / 2, decodedBitmap!!.height)
                val bm2 = Bitmap.createBitmap(decodedBitmap!!, decodedBitmap!!.width / 2, 0, decodedBitmap!!.width / 2, decodedBitmap!!.height)
                return  arrayListOf(bm1, bm2)
            }
            return arrayListOf(decodedBitmap!!)

        } catch (e: Exception) {
            e.printStackTrace()
        } catch (e: java.lang.OutOfMemoryError) {
            DLog("EncryptAndDecryptFiles: ", "decodeFile() Catch :: OutOfMemoryError")
            val sampleBitmap = Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888)
            return if(imageType == AlbumImageType.full) arrayListOf(sampleBitmap, sampleBitmap) else arrayListOf(sampleBitmap)
        }
        val w = 1
        val h = 1
        val conf = Bitmap.Config.ARGB_8888 // see other conf types
        val bmp = Bitmap.createBitmap(w, h, conf)
        return if(imageType == AlbumImageType.full) arrayListOf(bmp, bmp) else arrayListOf(bmp)
    }

    fun decodeFileWithoutSplit(file: File, context: Context): Bitmap {
        try {

            decodedBitmap = if(StorageUtils.enableEncrypt){
                //val decodedData = decodeFile(getKeyFromJNI(context), readFile(file))
                val decodedData = decodeImageFile(getKeyFromJNI(context), readFile(file), file)
                //val decodedData = decodeImageFile(getKeyFromJNI(context), file)
                BitmapFactory.decodeByteArray(decodedData, 0, decodedData.size)
            }else{
                BitmapFactory.decodeFile(file.absolutePath)
            }

            //val decodedData = decodeFile(getKeyFromJNI(context), readFile(file))
            //decodedBitmap = BitmapFactory.decodeByteArray(decodedData, 0, decodedData.size)

            val size = (decodedBitmap!!.width * decodedBitmap!!.height * 4)

            if(size >= MemUtils.calculateHeapMemory()){
                DLog("EncryptAndDecryptFiles: ", "decodeFile() if")
                //decodedBitmap = Bitmap.createBitmap(0, 0, Bitmap.Config.ARGB_8888)
                decodedBitmap = BitmapFactory.decodeResource(context.resources, R.drawable.no_memory_available_error)
            } else {
                DLog("EncryptAndDecryptFiles: ", "decodeFile() if else")
            }

            DLog("EncryptAndDecryptFiles: ", "decodeFile() WIDTH: ${decodedBitmap!!.width} :: HEIGHT: ${decodedBitmap!!.height} :: SIZE: ${size / MemUtils.BYTES_IN_MB} :: REMAIN")

            //MemUtils.calculateHeapMemory()

            return decodedBitmap!!

        } catch (e: Exception) {
            e.printStackTrace()
        } catch (e: java.lang.OutOfMemoryError) {
            DLog("EncryptAndDecryptFiles: ", "decodeFile() Catch :: OutOfMemoryError")
            return Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888)
        }
        val w = 1
        val h = 1
        val conf = Bitmap.Config.ARGB_8888 // see other conf types
        val bmp = Bitmap.createBitmap(w, h, conf)
        return bmp
    }

    fun decodeFile2(file: File, context: Context): Bitmap {
        try {
            /*var filePath = file.absolutePath
            filePath.replace(file.name, hashKey(file.name))*/
            /*var filePath = file.absolutePath
            var encryptedFileName = filePath.substring(0, filePath.lastIndexOf('/')) + "/${hashKey(file.name)}"
            file.renameTo(File(encryptedFileName))
            DLog("EncryptAndDecryptFiles: ","decodeFile: ${encryptedFileName} : ${file.path}")*/
            //val yourKey = getStringPreference(context, SharedPreferenceConst.SECRET_KEY, "")
            //val decodedData = decodeFile(getKeyFromJNI(context), readFile(File(encryptedFileName)))

            //decodedBitmap!!.recycle()
            //System.gc()
            
            val decodedData = decodeFile(getKeyFromJNI(context), readFile(file))
            //val str = String(decodedData)
            //DLog("EncryptAndDecryptFiles: ","DECODED FILE CONTENTS : $str")
            decodedBitmap = BitmapFactory.decodeByteArray(decodedData, 0, decodedData.size)

            val size = (decodedBitmap!!.width * decodedBitmap!!.height * 4)

            if(size >= MemUtils.calculateHeapMemory()){
                DLog("EncryptAndDecryptFiles: ", "decodeFile() if")
                //decodedBitmap = Bitmap.createBitmap(0, 0, Bitmap.Config.ARGB_8888)
                decodedBitmap = BitmapFactory.decodeResource(context.resources, R.drawable.no_memory_available_error)
            } else {
                DLog("EncryptAndDecryptFiles: ", "decodeFile() if else")
            }

            DLog("EncryptAndDecryptFiles: ", "decodeFile() WIDTH: ${decodedBitmap!!.width} :: HEIGHT: ${decodedBitmap!!.height} :: SIZE: ${size / MemUtils.BYTES_IN_MB} :: REMAIN")

            //MemUtils.calculateHeapMemory()

            return decodedBitmap!!

        } catch (e: Exception) {
            e.printStackTrace()
        } catch (e: java.lang.OutOfMemoryError) {
            DLog("EncryptAndDecryptFiles: ", "decodeFile() Catch :: OutOfMemoryError")
            return Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888)
        }
        val w = 1
        val h = 1
        val conf = Bitmap.Config.ARGB_8888 // see other conf types
        val bmp = Bitmap.createBitmap(w, h, conf)
        return bmp
    }

    fun decodeFile1(file: File, context: Context, imageType: Int): List<Bitmap> {
        try {
            /*var filePath = file.absolutePath
            filePath.replace(file.name, hashKey(file.name))*/
            /*var filePath = file.absolutePath
            var encryptedFileName = filePath.substring(0, filePath.lastIndexOf('/')) + "/${hashKey(file.name)}"
            file.renameTo(File(encryptedFileName))
            DLog("EncryptAndDecryptFiles: ","decodeFile: ${encryptedFileName} : ${file.path}")*/
            //val yourKey = getStringPreference(context, SharedPreferenceConst.SECRET_KEY, "")
            //val decodedData = decodeFile(getKeyFromJNI(context), readFile(File(encryptedFileName)))

            //decodedBitmap!!.recycle()
            //System.gc()
            val decodedData = decodeFile(getKeyFromJNI(context), readFile(file))
            //val str = String(decodedData)
            //DLog("EncryptAndDecryptFiles: ","DECODED FILE CONTENTS : $str")
            decodedBitmap = BitmapFactory.decodeByteArray(decodedData, 0, decodedData.size)

            val size = (decodedBitmap!!.width * decodedBitmap!!.height * 4)

            if(size >= MemUtils.calculateHeapMemory()){
                DLog("EncryptAndDecryptFiles: ", "decodeFile() if")
                //decodedBitmap = Bitmap.createBitmap(0, 0, Bitmap.Config.ARGB_8888)
                decodedBitmap = BitmapFactory.decodeResource(context.resources, R.drawable.no_memory_available_error)
            } else {
                DLog("EncryptAndDecryptFiles: ", "decodeFile() if else")
            }

            DLog("EncryptAndDecryptFiles: ", "decodeFile() WIDTH: ${decodedBitmap!!.width} :: HEIGHT: ${decodedBitmap!!.height} :: SIZE: ${size / MemUtils.BYTES_IN_MB} :: REMAIN")

            //MemUtils.calculateHeapMemory()
            if(imageType == AlbumImageType.full) {
                val bm1 = Bitmap.createBitmap(decodedBitmap!!, 0, 0, decodedBitmap!!.width / 2, decodedBitmap!!.height)
                val bm2 = Bitmap.createBitmap(decodedBitmap!!, decodedBitmap!!.width / 2, 0, decodedBitmap!!.width / 2, decodedBitmap!!.height)
                return  arrayListOf(bm1, bm2)
            }
            return arrayListOf(decodedBitmap!!)

        } catch (e: Exception) {
            e.printStackTrace()
        } catch (e: java.lang.OutOfMemoryError) {
            DLog("EncryptAndDecryptFiles: ", "decodeFile() Catch :: OutOfMemoryError")
            val sampleBitmap = Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888)
            return if(imageType == AlbumImageType.full) arrayListOf(sampleBitmap, sampleBitmap) else arrayListOf(sampleBitmap)
        }
        val w = 1
        val h = 1
        val conf = Bitmap.Config.ARGB_8888 // see other conf types
        val bmp = Bitmap.createBitmap(w, h, conf)
        return if(imageType == AlbumImageType.full) arrayListOf(bmp, bmp) else arrayListOf(bmp)
    }

    fun readFile(file: File): ByteArray {
        var contents: ByteArray? = null

        //val file = File(Environment.getExternalStorageDirectory() + File.separator, "")
        val size = file.length().toInt()
        contents = ByteArray(size)
        try {
            val buf: BufferedInputStream = BufferedInputStream(FileInputStream(file))
            try {
                buf.read(contents)
                buf.close()
            } catch (e: IOException) {
                e.printStackTrace()
            }

            val filePath = "/sdcard/utf8_file.txt"
            val UTF8 = "utf8"
            val BUFFER_SIZE = 8192

            //val br = BufferedReader(InputStreamReader(FileInputStream(filePath), UTF8), BUFFER_SIZE)
            //val bw = BufferedWriter(OutputStreamWriter(FileOutputStream(filePath), UTF8), BUFFER_SIZE)

        } catch (e: FileNotFoundException) {
            e.printStackTrace()
        }

        return contents
    }

    fun hashKey(key: String): String {
        var cacheKey: String
        try {
            val mDigest = MessageDigest.getInstance("MD5")
            mDigest.update(key.toByteArray())
            cacheKey = bytesToHexString(mDigest.digest())
        } catch (e: NoSuchAlgorithmException) {
            cacheKey = key.hashCode().toString()
        }
        return cacheKey
    }

    private fun bytesToHexString(bytes: ByteArray): String {
        // http://stackoverflow.com/questions/332079
        val sb = StringBuilder()
        for (i in bytes.indices) {
            val hex = Integer.toHexString(0xFF and bytes[i].toInt())
            if (hex.length == 1) {
                sb.append('0')
            }
            sb.append(hex)
        }
        return sb.toString()
    }

    fun getBitmapFromFile(file: File, context: Context): Bitmap {
        try {
            //System.gc()
            val decodedData = readFile(file)
            decodedBitmap = BitmapFactory.decodeByteArray(decodedData, 0, decodedData.size)

            val size = (decodedBitmap!!.width * decodedBitmap!!.height * 4)

            if(size >= MemUtils.calculateHeapMemory()){
                DLog("EncryptAndDecryptFiles: ", "decodeFile() if")
                decodedBitmap = BitmapFactory.decodeResource(context.resources, R.drawable.no_memory_available_error)
            } else {
                DLog("EncryptAndDecryptFiles: ", "decodeFile() if else")
            }
            DLog("EncryptAndDecryptFiles: ", "decodeFile() WIDTH: ${decodedBitmap!!.width} :: HEIGHT: ${decodedBitmap!!.height} :: SIZE: ${size / MemUtils.BYTES_IN_MB} :: REMAIN")

            return decodedBitmap!!

        } catch (e: Exception) {
            e.printStackTrace()
        } catch (e: java.lang.OutOfMemoryError) {
            DLog("EncryptAndDecryptFiles: ", "decodeFile() Catch :: OutOfMemoryError")
            return Bitmap.createBitmap(5, 5, Bitmap.Config.ARGB_8888)
        }
        val w = 1
        val h = 1
        val conf = Bitmap.Config.ARGB_8888 // see other conf types
        val bmp = Bitmap.createBitmap(w, h, conf)
        return bmp
    }

    fun decodeImageFile(yourKey: SecretKey, fileData: ByteArray, file: File) : ByteArray{

        //FileInputStream
        /*val ins: InputStream = FileInputStream(file)
        val baos = ByteArrayOutputStream()
        var b: Int
        while (ins.read().also { b = it } != -1) {
            //Log.e("AES_Cipher", "while decryptEPUB() ::" + b);
            baos.write(b)
        }*/

        //val key = "my 32 length key................"
        val key = encryptionAndDecryptionKey
        //val strToDecrypt = "5EXk6YFXnUYqTjWwlADRpYfS0ayQQYVWjFL21l/VjHRyn9r75/qO4K6b3wFABnZelU1Re2JMuGx8b550KvQ8/GO2b/TLwZulBMIRiXWkp8hee7uQNbMMoBFBR6E2oNWj"
        //val strToDecrypt = output
        Security.addProvider(BouncyCastleProvider())
        val keyBytes: ByteArray
        //var file: File? = null
        //file.readBytes()

        var strToDecrypt = ""
        try {
            //keyBytes = key!!.toByteArray(charset("UTF8"))
            keyBytes = key!!.toByteArray()
            val skey: SecretKeySpec = SecretKeySpec(keyBytes, "AES")
            //val input = org.bouncycastle.util.encoders.Base64.decode(strToDecrypt?.trim { it <= ' ' }?.toByteArray(charset("UTF8")))
            //val input = org.bouncycastle.util.encoders.Base64.decode(fileData)
            //val input = Base64.decode(fileData, Base64.DEFAULT);
            val input = fileData
            //val input = Base64.decode(strToDecrypt?.trim { it <= ' ' }?.toByteArray(charset("UTF8")), android.util.Base64.DEFAULT)


            //val data = yourKey.encoded
            val data = key!!.toByteArray()
            val skeySpec = SecretKeySpec(data, "AES")
            val cipher = Cipher.getInstance("AES/ECB/PKCS7Padding")
            cipher.init(Cipher.DECRYPT_MODE, skeySpec)
            return  cipher.doFinal(fileData)

            Log.e("MainActivity:", "decryptWithAES() :: STEP 1")
            synchronized(Cipher::class.java) {
                val cipher = Cipher.getInstance("AES/ECB/PKCS7Padding")
                //val cipher = Cipher.getInstance("AES/SIC/PKCS7")
                //val cipher = Cipher.getInstance("AES/CBC/PKCS7")
                //val cipher = Cipher.getInstance("AES/SIC/NoPadding")
                //val cipher = Cipher.getInstance("AES/ECB/PKCS7")
                //val cipher = Cipher.getInstance("AES/CBC/PKCS7Padding")
                //val random = SecureRandom()
                //ivSpec = IvParameterSpec(random.generateSeed(16))

                cipher.init(Cipher.DECRYPT_MODE, skey)
                Log.e("MainActivity:", "decryptWithAES() :: STEP 2")
                val plainText = ByteArray(cipher.getOutputSize(input.size))
                var ptLength = cipher.update(input, 0, input.size, plainText, 0)
                //ptLength += cipher.doFinal(plainText, ptLength)
                var decryptedString = String(plainText)
                decryptedString = decryptedString.trim { it <= ' ' }
                Log.e("MainActivity:", "decryptWithAES() :: STEP 3 $decryptedString")
                //return decryptedString
                return cipher.doFinal(plainText)
            }
        } catch (uee: UnsupportedEncodingException) {
            uee.printStackTrace()
        } catch (ibse: IllegalBlockSizeException) {
            ibse.printStackTrace()
        } catch (bpe: BadPaddingException) {
            bpe.printStackTrace()
        } catch (ike: InvalidKeyException) {
            ike.printStackTrace()
        } catch (nspe: NoSuchPaddingException) {
            nspe.printStackTrace()
        } catch (nsae: NoSuchAlgorithmException) {
            nsae.printStackTrace()
        } catch (e: ShortBufferException) {
            e.printStackTrace()
        }
        val w = 1
        val h = 1
        val conf = Bitmap.Config.ARGB_8888 // see other conf types
        val bitmap = Bitmap.createBitmap(w, h, conf)
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 90, stream)
        return stream.toByteArray()
    }

    fun byteArrayOfInts(vararg ints: Int) = ByteArray(ints.size) { pos -> ints[pos].toByte() }


    /*@SuppressLint("DeletedProvider")
    @Throws(Exception::class)
    fun generateKey(password: String): ByteArray {
        val keyStart = password.toByteArray(charset("UTF-8"))
        val kgen = KeyGenerator.getInstance("AES")
        val sr = SecureRandom.getInstance("SHA1PRNG")
        sr.setSeed(keyStart)
        kgen.init(128, sr)
        val skey = kgen.generateKey()
        return skey.getEncoded()
    }

    @Throws(Exception::class)
<<<<<<< HEAD
    fun encodeFile(key: ByteArray, fileData: ByteArray): ByteArray {
        val skeySpec = SecretKeySpec(key, "AES")
        val cipher = Cipher.getInstance("AES")
=======
    fun encodeFile(fileData: ByteArray): ByteArray {

        val skeySpec = SecretKeySpec(generateKey(getKey()), "AES/CBC/PKCS5Padding")
        val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
>>>>>>> c852585f807b9b0e6b0faef3449763f2fc0bc7d6
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec)
        return cipher.doFinal(fileData)
    }

    @Throws(Exception::class)
<<<<<<< HEAD
            /* fun decodeFile(key: ByteArray, fileData: ByteArray): ByteArray {
                 val skeySpec = SecretKeySpec(key, "AES")
                 val cipher = Cipher.getInstance("AES")
                 cipher.init(Cipher.DECRYPT_MODE, skeySpec)
                 return cipher.doFinal(fileData)
             }*/


    fun decodeFile(key: ByteArray, fileData: ByteArray): Bitmap {
        val skeySpec = SecretKeySpec(key, "AES")
        val cipher = Cipher.getInstance("AES")
        cipher.init(Cipher.DECRYPT_MODE, skeySpec)
        var decryptData = cipher.doFinal(fileData)

        DLog("Decoded","${BitmapFactory.decodeByteArray(decryptData, 0, decryptData.size)}")

        return BitmapFactory.decodeByteArray(decryptData, 0, decryptData.size)


    }


     fun encrypt(skey: ByteArray, data: ByteArray): ByteArray? {


        val skeySpec = SecretKeySpec(skey, "AES")


        val cipher: Cipher


        var encrypted: ByteArray? = null


        try {
            // Get Cipher instance for AES algorithm

            cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")


            // Initialize cipher


            cipher.init(Cipher.ENCRYPT_MODE, skeySpec, IvParameterSpec(getIV()))


            // Encrypt the image byte data


            encrypted = cipher.doFinal(data)


        } catch (e: Exception) {


            e.printStackTrace()

        }


        return encrypted


    }


    private fun getIV(): ByteArray {


        val random = SecureRandom()


        return random.generateSeed(16)
    }


    fun decrypt(skey: ByteArray, fis: FileInputStream) {


        DLog("fis","${fis}")
        val skeySpec = SecretKeySpec(skey, "AES")


        val cipher: Cipher


        var decryptedData: ByteArray? = null


        var cis: CipherInputStream? = null

        var fileFromBytes:File?=null


        try {


            cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")


            cipher.init(Cipher.DECRYPT_MODE, skeySpec, IvParameterSpec(getIV()))


            // Create CipherInputStream to read and decrypt the image data


            cis = CipherInputStream(fis, cipher)


            // Write encrypted image data to ByteArrayOutputStream


            val buffer = ByteArrayOutputStream()


            val data = ByteArray(2048)


            while (cis!!.read(data) !== -1) {

                buffer.write(data)
                DLog("buffer","${buffer.write(data)}")
            }

            buffer.flush()

            decryptedData = buffer.toByteArray()

            DLog("decryptedData","${decryptedData}")

            val bis = ByteArrayInputStream(decryptedData)
            val ois = ObjectInputStream(bis)
            fileFromBytes = ois.readObject() as File

            DLog("fileFromBytes","${fileFromBytes}")
            bis.close()
            ois.close()

        } catch (e: Exception) {

            e.printStackTrace()

        } finally {

            try {
                fis.close()

                cis!!.close()

            } catch (e: IOException) {


                e.printStackTrace()
            }

        }

      //  return fileFromBytes!!
    }
=======
    fun decodeFile(file: File): Bitmap {

        var bytes = file.readBytes()
        DLog("EncryptAndDecrypt : ","bytes: "+bytes.toString())

//        val size = file.length()
//        val bytes = ByteArray(size.toInt())
//        val buf = BufferedInputStream(FileInputStream(file))
//        buf.read(bytes,0,bytes.size)
//        buf.close()
//
//        val tmp = BitmapFactory.decodeFile(file.absolutePath)
//        val stream = ByteArrayOutputStream()
//        tmp.compress(CompressFormat.JPEG, 100, stream)

        val skeySpec = SecretKeySpec(generateKey(getKey()), "AES/CBC/PKCS5Padding")
        val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
        cipher.init(Cipher.DECRYPT_MODE, skeySpec)
        //return cipher.doFinal(stream.toByteArray())
        var byteArray = cipher.doFinal(bytes)
        DLog("EncryptAndDecrypt : ","byteArray: "+byteArray.toString())

        //val bmp = BitmapFactory.decodeByteArray(byteArray, 0, byteArray)
        val arrayInputStream = ByteArrayInputStream(byteArray)
        DLog("EncryptAndDecrypt : ","arrayInputStream: "+arrayInputStream.toString())
        val bitmap = BitmapFactory.decodeStream(arrayInputStream)
        //DLog("EncryptAndDecrypt : ","bitmap: "+bmp.toString())
        return bitmap
        //val bitmap = BitmapFactory.decodeByteArray(byteArray, 0, cipher.doFinal(stream.toByteArray()).length)
    }*/

}