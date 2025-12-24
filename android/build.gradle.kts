buildscript {
    // Define the Kotlin version (2.1.0 is stable as of late 2025)
    val kotlinVersion = "2.1.0"

    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // ✅ AGP 8.9.1 is the minimum required for SDK 36 support
        classpath("com.android.tools.build:gradle:8.9.1")
        
        // ✅ Updated Kotlin plugin to match modern standards
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")

        // Firebase / Google Services
        classpath("com.google.gms:google-services:4.4.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Flutter build directory optimization
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
