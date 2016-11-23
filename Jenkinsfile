node {
    stage "Prepare environment"
        checkout scm
        def environment  = docker.build "amarruedo/gowiki:${env.BUILD_NUMBER}"

        environment.inside {
            stage "Test"
                sh "2>&1 go test -v | go2xunit -output tests.xml"

            stage "Build"
                sh "go build"

           step([$class: 'XUnitBuilder',
                  thresholds: [[$class: 'FailedThreshold', unstableThreshold: '1']],
                  tools: [[$class: 'JUnitType', pattern: '*.xml']]])
           }

     stage "Cleanup"
        def workspace = pwd()
        deleteDir()
        dir("${workspace}@script") {
          deleteDir()
        }
        dir("${workspace}@tmp") {
          deleteDir()
        }
}
