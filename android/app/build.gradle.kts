plugins {
    id "com.android.application"
    id "kotlin-android"
    // Plugin Flutter dipanggil secara otomatis
    id "dev.flutter.flutter-gradle-plugin"
}

def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
if (flutterVersionCode == null) {
    flutterVersionCode = '1'
}

def flutterVersionName = localProperties.getProperty('flutter.versionName')
if (flutterVersionName == null) {
    flutterVersionName = '1.0'
}

android {
    namespace "com.example.aplikasi_kisahloka"
    
    // Wajib diubah ke 36 untuk mendukung plugin file_picker dan lifecycle terbaru
    compileSdkVersion 36

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    defaultConfig {
        // ID aplikasi unik Anda
        applicationId "com.example.aplikasi_kisahloka"
        
        // Menggunakan minSdkVersion bawaan Flutter
        minSdkVersion flutter.minSdkVersion
        targetSdkVersion 34
        
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }

    buildTypes {
        release {
            // Pengaturan penandatanganan aplikasi untuk rilisan
            signingConfig signingConfigs.debug
        }
    }
}

flutter {
    source '../..'
}

dependencies {
    // Dependency bawaan Kotlin/Android
}