plugins {
    id("com.android.application")
    id("com.google.gms.google-services")  // FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.musicapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"  // Set NDK version explicitly

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.musicapp"
        minSdk = 23  // Updated to match Firebase requirement
        targetSdk = 30  // Update to a suitable version
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
