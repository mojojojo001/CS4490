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