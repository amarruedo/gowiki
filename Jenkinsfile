node {
    stage "Prepare environment"
        checkout scm
        def environment  = docker.build "amarruedo/gowiki:${env.GIT_COMMIT}"

        environment.inside {

            stage "Build"
                sh "go build -o build/wiki wiki.go"

            stage "Test"
                sh "mkdir -p reports/"
                sh "2>&1 go test -v | go2xunit -output reports/tests.xml"
                step([$class: 'XUnitBuilder',
                      thresholds: [[$class: 'FailedThreshold', unstableThreshold: '1']],
                      tools: [[$class: 'JUnitType', pattern: 'reports/*.xml']]])
                zip dir: 'build/', archive: true, glob: '', zipFile: "gowiki-${env.BUILD_ID}.zip"
                //step([$class: 'ArtifactArchiver', artifacts: 'build/wiki', fingerprint: true])

            stage 'Deployment'
                def server = Artifactory.server("artifactory-test")
                def uploadSpec = """{
                  "files": [
                  {
                    "pattern": "gowiki-${env.BUILD_ID}.zip",
                    "target": "golang/"
                  }
                  ]
                  }"""

                def buildInfo = Artifactory.newBuildInfo()
                buildInfo.env.capture = true
                buildInfo = server.upload(uploadSpec)
                server.publishBuildInfo(buildInfo)

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
