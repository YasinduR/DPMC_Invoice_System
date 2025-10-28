plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // NEW: Apply the Google Services plugin
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.myapp"
    compileSdk = flutter.compileSdkVersion
    // ndkVersion = flutter.ndkVersion
    ndkVersion = "27.0.12077973" // <-- TO THIS VALUE

    compileOptions {
        // --- CHANGE: Correct Kotlin DSL syntax ---
        isCoreLibraryDesugaringEnabled = true
        // --- End of CHANGE ---
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.myapp"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// --- CHANGE: Correct Kotlin DSL syntax for dependencies ---
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // NEW: Add Firebase BoM (Bill of Materials) for consistent versions
    // Use the latest stable version of Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))

    // NEW: Add Firebase Messaging library
    implementation("com.google.firebase:firebase-messaging")

    // Optional: Add Firebase Analytics if you want to track FCM events
    implementation("com.google.firebase:firebase-analytics")
}
// --- End of CHANGE ---