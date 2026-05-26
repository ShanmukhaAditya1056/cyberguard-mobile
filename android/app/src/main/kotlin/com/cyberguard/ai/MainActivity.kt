package com.cyberguard.ai

import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.wifi.WifiManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "cyberguard/app_inspector"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInstalledApps" -> {
                    try {
                        val includeSystem = call.argument<Boolean>("includeSystem") ?: false
                        val packages = packageManager.getInstalledPackages(PackageManager.GET_PERMISSIONS)
                        val apps = packages.mapNotNull { pkg ->
                            val appInfo = pkg.applicationInfo ?: return@mapNotNull null
                            val isSystem = (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0
                            if (!includeSystem && isSystem) {
                                return@mapNotNull null
                            }
                            val name = packageManager.getApplicationLabel(appInfo).toString()
                            val permissions = pkg.requestedPermissions?.toList() ?: emptyList()
                            mapOf(
                                "name" to name,
                                "packageName" to pkg.packageName,
                                "permissions" to permissions,
                                "firstInstallTime" to pkg.firstInstallTime,
                                "lastUpdateTime" to pkg.lastUpdateTime,
                                "isSystem" to isSystem
                            )
                        }
                        result.success(apps)
                    } catch (error: Exception) {
                        result.error("APP_LIST_ERROR", error.message, null)
                    }
                }
                "getWifiInfo" -> {
                    try {
                        val connectivityManager =
                            getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
                        val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
                        val network = connectivityManager.activeNetwork
                        val capabilities = connectivityManager.getNetworkCapabilities(network)
                        val isWifi = capabilities?.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) == true
                        if (!isWifi) {
                            result.success(
                                mapOf(
                                    "isWifi" to false,
                                    "ssid" to null,
                                    "bssid" to null,
                                    "rssi" to null,
                                    "frequency" to null,
                                    "linkSpeed" to null,
                                    "security" to "UNKNOWN"
                                )
                            )
                            return@setMethodCallHandler
                        }
                        val info = wifiManager.connectionInfo
                        val rawSsid = info?.ssid
                        val ssid =
                            rawSsid?.takeUnless { it == "<unknown ssid>" }?.replace("\"", "")
                        val bssid = info?.bssid
                        val rssi = info?.rssi
                        val frequency = info?.frequency
                        val linkSpeed = info?.linkSpeed
                        val capabilitiesInfo =
                            wifiManager.scanResults.firstOrNull { it.SSID == ssid }?.capabilities ?: ""
                        val security = when {
                            capabilitiesInfo.contains("WPA3") -> "WPA3"
                            capabilitiesInfo.contains("WPA2") -> "WPA2"
                            capabilitiesInfo.contains("WPA") -> "WPA"
                            capabilitiesInfo.contains("WEP") -> "WEP"
                            capabilitiesInfo.isNotEmpty() -> "OPEN"
                            else -> "UNKNOWN"
                        }
                        result.success(
                            mapOf(
                                "isWifi" to true,
                                "ssid" to ssid,
                                "bssid" to bssid,
                                "rssi" to rssi,
                                "frequency" to frequency,
                                "linkSpeed" to linkSpeed,
                                "security" to security
                            )
                        )
                    } catch (error: Exception) {
                        result.error("WIFI_INFO_ERROR", error.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
