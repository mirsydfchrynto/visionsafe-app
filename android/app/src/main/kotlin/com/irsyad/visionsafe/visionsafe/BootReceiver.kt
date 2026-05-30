package com.irsyad.visionsafe.visionsafe

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.content.ContextCompat

/**
 * Receiver untuk menjalankan VisionService otomatis saat HP nyala.
 * Bagian dari Fortress Protocol: "Unstoppable".
 */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED || 
            intent.action == "android.intent.action.QUICKBOOT_POWERON") {
            
            // Cegah crash ForegroundServiceDidNotStartInTimeException di Android 14+
            // dengan mengecek izin terlebih dahulu.
            val hasCamera = ContextCompat.checkSelfPermission(context, android.Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED
            if (!hasCamera) {
                return
            }
            
            val serviceIntent = Intent(context, VisionService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(serviceIntent)
            } else {
                context.startService(serviceIntent)
            }
        }
    }
}
