import sbt._
import Keys._
import PlayProject._

object ApplicationBuild extends Build {

    val appName         = "isee"
    val appVersion      = "1.0.0"

    val appDependencies = Seq(
      // Add your project dependencies here,
    )

    val main = play.Project(appName, appVersion, appDependencies).settings(
      // Add your own project settings here   
      scalacOptions in Compile += "-feature"
    )

}
