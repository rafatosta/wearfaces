plugins {
    alias(libs.plugins.android.application)
}

val releaseKeystore = System.getenv("WEARFACES_KEYSTORE")
val releaseStorePassword = System.getenv("WEARFACES_STORE_PASSWORD")
val releaseKeyAlias = System.getenv("WEARFACES_KEY_ALIAS")
val releaseKeyPassword = System.getenv("WEARFACES_KEY_PASSWORD")

android {
    namespace = "com.rtosta.wearfaces.flow"
    compileSdk = 34
    buildToolsVersion = "36.0.0"
    enableKotlin = false

    defaultConfig {
        applicationId = "com.rtosta.wearfaces.flow"
        minSdk = 34
        targetSdk = 34
        versionCode = 1
        versionName = "0.1.0"
    }

    signingConfigs {
        if (listOf(releaseKeystore, releaseStorePassword, releaseKeyAlias, releaseKeyPassword).all { !it.isNullOrBlank() }) {
            create("release") {
                storeFile = file(releaseKeystore!!)
                storePassword = releaseStorePassword
                keyAlias = releaseKeyAlias
                keyPassword = releaseKeyPassword
            }
        }
    }

    buildTypes {
        debug {
            // Removes generated R bytecode so this WFF APK remains resource-only.
            isMinifyEnabled = true
        }
        release {
            isMinifyEnabled = true
            isShrinkResources = false
            signingConfig = signingConfigs.findByName("release")
        }
    }

    lint {
        abortOnError = true
        warningsAsErrors = true
        lintConfig = file("lint.xml")
    }
}
