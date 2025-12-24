plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.local_skill_share"
    
    // ✅ Updated to 36 to satisfy your plugins (Geolocator, Maps, etc.)
    compileSdk = 36 
    
    ndkVersion = "27.0.12077973"

    compileOptions {
        // ✅ AGP 8.9+ requires Java 17 or higher
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.local_skill_share"
        
        // Many modern plugins now require at least API 24
        minSdk = 24 
        
        // ✅ Target 36 to match the compile SDK
        targetSdk = 36 
        
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
