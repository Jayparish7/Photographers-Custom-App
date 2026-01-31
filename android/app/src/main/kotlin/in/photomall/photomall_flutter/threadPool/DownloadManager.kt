package `in`.photomall.photomall_flutter.threadPool

import `in`.photomall.photomall_flutter.utils.Others.DLog
import java.util.concurrent.BlockingQueue
import java.util.concurrent.LinkedBlockingQueue
import java.util.concurrent.ThreadPoolExecutor
import java.util.concurrent.TimeUnit


class DownloadManager private constructor() {
    private val downloadThreadPool: ThreadPoolExecutor
    private val downaloadWorkQueue: BlockingQueue<Runnable>

    //to runs task on main thread from background thread
    val mainThreadExecutor: MainThreadExecutor?
        get() = handler

    init {

        if(THREAD_POOL_SIZE <= 0){
            THREAD_POOL_SIZE = 2
        }

        DLog("DownloadManager: ", "THREAD POOL SIZE: $THREAD_POOL_SIZE")

        downaloadWorkQueue = LinkedBlockingQueue<Runnable>()

        downloadThreadPool = ThreadPoolExecutor(THREAD_POOL_SIZE, THREAD_POOL_SIZE,
                50, TimeUnit.MILLISECONDS, downaloadWorkQueue)
    }

    fun runDownloadFile(task: Runnable) {
        downloadThreadPool.execute(task)
    }

    companion object {

        /*private val CORE_POOL_SIZE = Runtime.getRuntime().availableProcessors() / 2
        private val MAX_POOL_SIZE = Runtime.getRuntime().availableProcessors() / 2*/

        private var THREAD_POOL_SIZE = Runtime.getRuntime().availableProcessors() - 2

        private val KEEP_ALIVE_TIME = 50

        var downloadManager: DownloadManager? = null
            private set
        private var handler: MainThreadExecutor? = null

        init {
            downloadManager = DownloadManager()
            handler = MainThreadExecutor()
        }
    }
}