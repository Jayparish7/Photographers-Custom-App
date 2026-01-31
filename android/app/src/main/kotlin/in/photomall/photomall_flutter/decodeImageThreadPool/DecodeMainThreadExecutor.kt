package com.photomall.photoalbum.photomallUser.decodeImageThreadPool

import android.os.Handler
import android.os.Looper
import java.util.concurrent.Executor


class DecodeMainThreadExecutor : Executor {

    private val handler = Handler(Looper.getMainLooper())

    override fun execute(runnable: Runnable) {
        handler.post(runnable)
    }
}