plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.papiers_de_toilette"
    compileSdk = flutter.compileSdkVersion
    // The project previously forced an NDK version coming from Flutter (flutter.ndkVersion).
    // That can cause a build failure if the specified NDK folder is missing or corrupted
    // (for example: missing source.properties). Commenting out the explicit ndkVersion
    // allows Gradle/Android toolchain to pick a suitable installed NDK version.
    // If you need to force a specific NDK version, set `ndkVersion = "<version>"`
    // to a value you have installed (e.g. "25.2.9519653").
    // ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.papiers_de_toilette"
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
