pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    
    // ✅ FIX: Changed from 8.7.3 to 8.9.1 to support SDK 36 and activity-compose
    id("com.android.application") version "8.9.1" apply false
    
    // ✅ UPDATE: Modern version for Google Services (Late 2025 standard)
    id("com.google.gms.google-services") version "4.4.2" apply false
    
    // ✅ UPDATE: Ensure Kotlin is 2.1.0 to match your previous file
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")