pipeline {
  agent any
  stages {
    stage('build') {
      steps {
        bat 'gcc -o hello main.c'
      }
    }

    stage('Docker Build') {
      steps {
        bat "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
      }
    }

    stage('OWASP Dependency-Check Vulnerabilities') {
      steps {
        dependencyCheck(additionalArguments: ''' 
                        -o \'./\'
                        -s \'./\'
                        -f \'ALL\' 
                        --prettyPrint''', odcInstallation: 'dp-Check')
        dependencyCheckPublisher(pattern: 'dependency-check-report.xml')
      }
    }

    stage('Security Scan with OWASP ZAP') {
      steps {
        script {
          docker.image('owasp/zap2docker-stable').run("-t -d -p 8090:8090 -p 9090:9090")

          // Perform ZAP Spidering and Active Scan against localhost
          sh "docker run -v %cd%:/zap/wrk/:rw owasp/zap2docker-stable zap-baseline.py -t http://localhost:80 -r zap-report.html"
        }

      }
    }

    stage('Deploy') {
      steps {
        bat "docker run -d --name ${CONTAINER_NAME} -p 80:80 ${IMAGE_NAME}:${IMAGE_TAG}"
      }
    }

  }
  environment {
    IMAGE_NAME = 'my-image-name'
    IMAGE_TAG = 'latest'
    CONTAINER_NAME = "my-container-${BUILD_NUMBER}"
    ZAP_REPORT = 'zap-report.html'
  }
  post {
    always {
      archiveArtifacts(artifacts: "${ZAP_REPORT}", onlyIfSuccessful: true)
    }

  }
}
