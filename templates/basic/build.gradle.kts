plugins {
    id("wearfaces.watch-face")
}

android {
    namespace = "{{PACKAGE_NAME}}"

    defaultConfig {
        applicationId = "{{PACKAGE_NAME}}"
        versionCode = 1
        versionName = "{{VERSION_NAME}}"
    }
}
