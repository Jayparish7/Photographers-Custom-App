package com.photomall.photoalbum.photomallUser.decodeImageThreadPool

import `in`.photomall.photomall_flutter.utils.Others.DLog
import java.util.concurrent.BlockingQueue
import java.util.concurrent.LinkedBlockingQueue
import java.util.concurrent.ThreadPoolExecutor
import java.util.concurrent.TimeUnit


class DecodeImageManager private constructor() {
    private val downloadThreadPool: ThreadPoolExecutor
    private val downaloadWorkQueue: BlockingQueue<Runnable>

    //to runs task on main thread from background thread
    val mainThreadExecutor: DecodeMainThreadExecutor?
        get() = handler

    init {
        downaloadWorkQueue = LinkedBlockingQueue<Runnable>()
        DLog("DecodeImageManager: ","core size: $CORE_POOL_SIZE")
        downloadThreadPool = ThreadPoolExecutor(CORE_POOL_SIZE, MAX_POOL_SIZE,
                50, TimeUnit.MILLISECONDS, downaloadWorkQueue)
    }

    fun runDecodeFile(task: Runnable) {
        downloadThreadPool.execute(task)
    }

    companion object {

        private val CORE_POOL_SIZE = Runtime.getRuntime().availableProcessors()
        private val MAX_POOL_SIZE = Runtime.getRuntime().availableProcessors()
        private val KEEP_ALIVE_TIME = 50

        var downloadManager: DecodeImageManager? = null
            private set
        private var handler: DecodeMainThreadExecutor? = null

        init {
            downloadManager = DecodeImageManager()
            handler = DecodeMainThreadExecutor()
        }
    }
}