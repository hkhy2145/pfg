package com.example.app

import android.app.Service
import android.content.Intent
import android.os.IBinder

class BackgroundService : Service() {
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Start your background tasks or Flutter code here
        return START_STICKY
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }
}
