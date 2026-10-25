allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val userHome: String = System.getProperty("user.home")
val buildBase = File(userHome, ".ciltizi_build")
rootProject.layout.buildDirectory.set(buildBase)

subprojects {
    val newSubprojectBuildDir = File(buildBase, project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
