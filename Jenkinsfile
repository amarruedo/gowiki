node {
    stage "Prepare environment"
        checkout scm
        def environment  = docker.build "amarruedo/gowiki:${env.GIT_COMMIT}"

        environment.inside {

            stage "Build"
                sh "go build"

            stage "Test"
                sh "2>&1 go test -v | go2xunit -output tests.xml"
                step([$class: 'XUnitBuilder',
                      thresholds: [[$class: 'FailedThreshold', unstableThreshold: '1']],
                      tools: [[$class: 'JUnitType', pattern: '*.xml']]])
                step([$class: 'ArtifactArchiver', artifacts: 'gowiki', fingerprint: true])


        }
        
     stage "Workspace cleanup"
        def workspace = pwd()
        deleteDir()
        dir("${workspace}@script") {
          deleteDir()
        }
        dir("${workspace}@tmp") {
          deleteDir()
        }
}
