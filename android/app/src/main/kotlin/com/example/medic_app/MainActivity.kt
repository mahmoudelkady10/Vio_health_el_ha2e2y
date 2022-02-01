package com.example.medic_app

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Bundle
import android.os.PersistableBundle
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.android.FlutterActivity
import com.example.medic_app.activity.HealthMonitorActivity as SecondActivity

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.viohealth/channels"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        GeneratedPluginRegister.registerGeneratedPlugins(FlutterEngine(this@MainActivity))
        MethodChannel(flutterEngine?.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if(call.method.equals("openHealthMonitor")) {
                openHealthMonitor()
            }
            else if(call.method.equals("getData")){
                val key: String? = call.argument<String>("key");
                val file: String? = call.argument<String>("file");

                when {
                    key == null -> {
                        result.error("KEY_MISSING", "Argument 'key' is not provided.", null)
                    }
                    file == null -> {
                        result.error("FILE_MISSING", "Argument 'file' is not provided.", null)
                    }
                    else -> {
                        val value = getData(file.toString(), key.toString())
                        result.success(value)
                    }
                }
            } else if(call.method.equals("deleteData")) {
                deleteData()
            }

        }
    }

    private fun openHealthMonitor(){
        startActivity(Intent(this@MainActivity, SecondActivity::class.java))

    }

    private fun getData(file: String, key: String): String? {
        return context.getSharedPreferences(
                file,
                Context.MODE_PRIVATE
        ).getString(key, null)

    }

    private fun deleteData(): String {
        val preferences = getSharedPreferences("Data", MODE_PRIVATE)
        val editor = preferences.edit()
        editor.clear()
        editor.apply()

        return "Values cleared"
    }


}

