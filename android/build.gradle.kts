buildscript {
    ext {
        // Define Kotlin version if not already defined elsewhere
        kotlin_version = '1.8.20' // Use your actual Kotlin version
        // Define google-services plugin version
        google_services_version = '4.4.0' // Use the latest stable version
    }
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Add your Android Gradle Plugin and Kotlin Gradle Plugin here
        classpath 'com.android.tools.build:gradle:8.0.0' // Use your actual Android Gradle Plugin version
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        // NEW: Add the Google Services plugin classpath
        classpath "com.google.gms:google-services:$google_services_version"
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
