buildscript {
    repositories {
        google() // ✅ Ensure this is here
        mavenCentral() // ✅ Ensure this is here
    }
    dependencies {
        classpath("com.google.gms:google-services:4.3.15") // ✅ Ensure this is here
    }
}

allprojects {
    repositories {
        google() // ✅ Ensure this is here
        mavenCentral() // ✅ Ensure this is here
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
