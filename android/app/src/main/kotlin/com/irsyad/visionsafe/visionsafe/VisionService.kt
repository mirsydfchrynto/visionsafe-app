package com.irsyad.visionsafe.visionsafe

import android.app.*
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import android.util.Log
import androidx.camera.core.ImageProxy
import java.util.concurrent.Executors

import android.content.pm.ServiceInfo
import androidx.core.app.NotificationManagerCompat

/**
 * Orchestrator Utama (Service).
 */
class VisionService : Service(), androidx.lifecycle.LifecycleOwner {

    private val lifecycleRegistry = androidx.lifecycle.LifecycleRegistry(this)
    override val lifecycle: androidx.lifecycle.Lifecycle get() = lifecycleRegistry
    private lateinit var cameraManager: VisionCameraManager
    private lateinit var analyzer: VisionAnalyzer
    private lateinit var overlayManager: BlurOverlayManager
    private val cameraExecutor = Executors.newSingleThreadExecutor()

    private val SAMPLING_RATE_MS = 500L
    private var lastProcessedTime = 0L
    private var violationStartTime = 0L
    private var violationThresholdCm = 35.0
    private val TRIGGER_DELAY_MS = 1500L

    companion object {
        var instance: VisionService? = null
    }

    fun updateThreshold(newThreshold: Double) {
        violationThresholdCm = newThreshold
        Log.d("VisionSafe", "Threshold updated to: $newThreshold cm")
    }

    private val screenStateReceiver = object : android.content.BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            when (intent.action) {
                Intent.ACTION_SCREEN_OFF -> {
                    Log.d("VisionSafe", "Screen OFF: Pausing AI")
                    cameraManager.stop()
                }
                Intent.ACTION_SCREEN_ON -> {
                    Log.d("VisionSafe", "Screen ON: Resuming AI")
                    cameraManager.start()
                }
            }
        }
    }

    override fun onCreate() {
        super.onCreate()
        instance = this
        Log.d("VisionSafe", "VisionService Created")
        lifecycleRegistry.handleLifecycleEvent(androidx.lifecycle.Lifecycle.Event.ON_CREATE)

        analyzer = VisionAnalyzer(this)
        overlayManager = BlurOverlayManager(this)
        cameraManager = VisionCameraManager(this, this, cameraExecutor) { processImage(it) }

        createNotificationChannel()

        val filter = android.content.IntentFilter().apply {
            addAction(Intent.ACTION_SCREEN_OFF)
            addAction(Intent.ACTION_SCREEN_ON)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(screenStateReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(screenStateReceiver, filter)
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        lifecycleRegistry.handleLifecycleEvent(androidx.lifecycle.Lifecycle.Event.ON_START)
        
        intent?.getDoubleExtra("threshold", -1.0)?.let {
            if (it > 0) violationThresholdCm = it
        }

        // Cek Izin Kamera sebelum startForeground (Krusial untuk Android 14+)
        if (androidx.core.content.ContextCompat.checkSelfPermission(this, android.Manifest.permission.CAMERA) 
            != android.content.pm.PackageManager.PERMISSION_GRANTED) {
            Log.e("VisionSafe", "Batal menjalankan service: Izin Kamera tidak diberikan.")
            stopSelf()
            return START_NOT_STICKY
        }

        try {
            // Android 14 (API 34) Foreground Service Compliance
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                startForeground(1, createNotification(), ServiceInfo.FOREGROUND_SERVICE_TYPE_CAMERA)
            } else {
                startForeground(1, createNotification())
            }
            
            if (cameraManager.isCameraActive().not()) {
                cameraManager.start()
            }
        } catch (e: Exception) {
            Log.e("VisionSafe", "Gagal menjalankan Foreground Service", e)
            stopSelf()
        }

        return START_STICKY
    }

    private fun processImage(imageProxy: ImageProxy) {
        val currentTime = System.currentTimeMillis()
        if (currentTime - lastProcessedTime < SAMPLING_RATE_MS) {
            imageProxy.close()
            return
        }
        lastProcessedTime = currentTime

        val result = analyzer.analyze(imageProxy)
        // Log krusial untuk memastikan AI deteksi di background
        if (result != null) {
            Log.d("VisionSafe", "AI STATUS: FACE DETECTED AT ${result.distance.toInt()} CM. Blink: ${result.isBlinking}")
        } else {
            Log.v("VisionSafe", "AI STATUS: NO FACE")
        }
        
        handleResult(result, currentTime)
        imageProxy.close()
    }

    private fun handleResult(result: VisionAnalyzer.AnalysisResult?, currentTime: Long) {
        if (result == null) {
            violationStartTime = 0L
            updateOverlay(false, false)
            return
        }

        val distance = result.distance
        val isViolation = distance < violationThresholdCm
        sendTelemetry(distance, isViolation, result.isBlinking)

        if (isViolation) {
            if (violationStartTime == 0L) violationStartTime = currentTime
            
            val violationDuration = currentTime - violationStartTime
            if (violationDuration > 10000L) { // 10 Detik: Emergency Lock
                Log.w("VisionSafe", "!!! EMERGENCY LOCK !!!")
                updateOverlay(true, isEmergency = true)
            } else if (violationDuration > TRIGGER_DELAY_MS) { // 1.5 Detik: Normal Blur
                Log.w("VisionSafe", "!!! CRITICAL DISTANCE !!! Showing Blur.")
                updateOverlay(true, isEmergency = false)
            }
        } else {
            violationStartTime = 0L
            updateOverlay(false, false)
        }
    }

    private fun sendTelemetry(distance: Double, isViolation: Boolean, isBlinking: Boolean) {
        MainActivity.eventSink?.let { sink ->
            android.os.Handler(android.os.Looper.getMainLooper()).post {
                sink.success(mapOf(
                    "distance" to distance, 
                    "isViolation" to isViolation, 
                    "isBlinking" to isBlinking,
                    "timestamp" to System.currentTimeMillis()
                ))
            }
        }
    }

    private fun updateOverlay(show: Boolean, isEmergency: Boolean) {
        android.os.Handler(android.os.Looper.getMainLooper()).post {
            if (show) overlayManager.show(isEmergency) else overlayManager.hide()
        }
    }

    private fun createNotification(): Notification {
        return NotificationCompat.Builder(this, "VisionSafeServiceChannel")
            .setContentTitle("VisionSafe: Mata Vizo Melindungi")
            .setContentText("Status: Aktif & Mengawasi")
            .setSmallIcon(android.R.drawable.ic_menu_view)
            .setOngoing(true)
            .setCategory(Notification.CATEGORY_SERVICE)
            .setPriority(NotificationCompat.PRIORITY_MAX) // Prioritas tertinggi
            .build()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel("VisionSafeServiceChannel", "VisionSafe Guard", NotificationManager.IMPORTANCE_HIGH).apply {
                description = "Layanan monitoring jarak pandang real-time"
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            }
            getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
        }
    }

    override fun onDestroy() {
        instance = null
        lifecycleRegistry.handleLifecycleEvent(androidx.lifecycle.Lifecycle.Event.ON_DESTROY)
        unregisterReceiver(screenStateReceiver)
        cameraManager.stop()
        analyzer.close()
        cameraExecutor.shutdown()
        overlayManager.hide()
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
