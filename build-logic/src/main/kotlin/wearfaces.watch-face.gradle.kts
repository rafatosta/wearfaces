plugins {
    id("com.android.application")
}

val releaseKeystore = System.getenv("WEARFACES_KEYSTORE")
val releaseStorePassword = System.getenv("WEARFACES_STORE_PASSWORD")
val releaseKeyAlias = System.getenv("WEARFACES_KEY_ALIAS")
val releaseKeyPassword = System.getenv("WEARFACES_KEY_PASSWORD")

android {
    compileSdk = 35
    buildToolsVersion = "36.0.0"
    enableKotlin = false

    defaultConfig {
        minSdk = 34
        targetSdk = 35
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
            // Removes generated R bytecode so WFF APKs remain resource-only.
            isDebuggable = false
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
        lintConfig = rootProject.file("gradle/wearface-lint.xml")
    }
}
