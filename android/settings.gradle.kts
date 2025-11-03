pluginManagement {
    // Resolve Flutter SDK path robustly to avoid stale/invalid paths
    var flutterSdkPath = run {
        val properties = java.util.Properties()
        val localProps = file("local.properties")
        if (localProps.exists()) {
            localProps.inputStream().use { properties.load(it) }
        }
        properties.getProperty("flutter.sdk")
    }

    // Fallback to environment variables if needed
    val envFlutter = System.getenv("FLUTTER_HOME")
        ?: System.getenv("FLUTTER_ROOT")

    if ((flutterSdkPath == null || flutterSdkPath.isBlank()) && envFlutter != null) {
        flutterSdkPath = envFlutter
    }

    // Final fallback to common Windows install location
    val defaultFlutter = "C:/src/flutter"
    val gradleDirFromLocal = if (flutterSdkPath != null) file("$flutterSdkPath/packages/flutter_tools/gradle") else null
    val gradleDirFromEnv = if (envFlutter != null) file("$envFlutter/packages/flutter_tools/gradle") else null
    val gradleDirFromDefault = file("$defaultFlutter/packages/flutter_tools/gradle")

    val finalFlutterGradleDir = when {
        gradleDirFromLocal != null && gradleDirFromLocal.exists() -> gradleDirFromLocal
        gradleDirFromEnv != null && gradleDirFromEnv.exists() -> gradleDirFromEnv
        gradleDirFromDefault.exists() -> gradleDirFromDefault
        else -> null
    }

    if (finalFlutterGradleDir == null) {
        throw GradleException(
            "Unable to locate Flutter SDK gradle directory. Checked: " +
                listOfNotNull(
                    gradleDirFromLocal?.path,
                    gradleDirFromEnv?.path,
                    gradleDirFromDefault.path
                ).joinToString(", ") +
                ". Please update android/local.properties (flutter.sdk) or set FLUTTER_HOME/FLUTTER_ROOT."
        )
    }

    includeBuild(finalFlutterGradleDir.path)

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.9.1" apply false
    // START: FlutterFire Configuration
    id("com.google.gms.google-services") version("4.3.15") apply false
    // END: FlutterFire Configuration
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
