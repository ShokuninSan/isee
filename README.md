# Welcome to iSee

An awesome application recognizing drawn images, backed by the synaptic machine learning framework!

## Installation requirements

SBT ist required to run the iSee application. Please follow the instructions on the [Scala SBT](http://www.scala-sbt.org/release/docs/Getting-Started/Setup.html) page for setup.

## Run the application

To run the application make sure you are in the root of the project and issue the following commands:

    $ sbt
    Loading /Users/rene/bin/sbt/bin/sbt-launch-lib.bash
    Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
    [info] Loading project definition from /Users/rene/projects/isee/project
    [info] Set current project to isee (in build file:/Users/rene/projects/isee/)
    [isee] $

When you type `sbt` you should see a similar output as above. Now type `run` at the sbt prompt:

    [isee] $ run

    --- (Running the application from SBT, auto-reloading is enabled) ---

    [info] play - Listening for HTTP on /0:0:0:0:0:0:0:0:9000

    (Server started, use Ctrl+D to stop and go back to the console...)

This starts an HTTP server listening on port 9000. Now navigate your browser to <http://localhost:9000>.

Have a lot of fun!
