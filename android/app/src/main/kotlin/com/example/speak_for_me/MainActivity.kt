package com.example.speak_for_me

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val channel = "com.example.speak_for_me/file_saver"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            if (call.method == "saveToDownloads") {
                val fileName = call.argument<String>("fileName") ?: "export.txt"
                val content = call.argument<ByteArray>("content")

                if (content == null) {
                    result.error("INVALID_ARGS", "content is null", null)
                    return@setMethodCallHandler
                }

                Log.d("SpeakForMe", "saveToDownloads called, fileName=$fileName, SDK=${Build.VERSION.SDK_INT}")
                try {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        Log.d("SpeakForMe", "Using MediaStore API")
                        val values = ContentValues().apply {
                            put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                            put(MediaStore.Downloads.MIME_TYPE, "text/plain")
                            put(MediaStore.Downloads.IS_PENDING, 1)
                        }
                        val uri = contentResolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
                        Log.d("SpeakForMe", "MediaStore URI: $uri")
                        if (uri != null) {
                            contentResolver.openOutputStream(uri)?.use { it.write(content) }
                            values.clear()
                            values.put(MediaStore.Downloads.IS_PENDING, 0)
                            contentResolver.update(uri, values, null, null)
                            Log.d("SpeakForMe", "File saved successfully")
                            result.success(true)
                        } else {
                            Log.e("SpeakForMe", "URI is null")
                            result.error("SAVE_ERROR", "Impossible de créer le fichier", null)
                        }
                    } else {
                        Log.d("SpeakForMe", "Using legacy FileOutputStream")
                        val downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
                        FileOutputStream(File(downloadsDir, fileName)).use { it.write(content) }
                        Log.d("SpeakForMe", "File saved successfully (legacy)")
                        result.success(true)
                    }
                } catch (e: Exception) {
                    Log.e("SpeakForMe", "Error saving file: ${e.message}", e)
                    result.error("SAVE_ERROR", e.message, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
