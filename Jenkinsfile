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
        script {
          // Perform dependency check
          dependencyCheck(additionalArguments: ''' 
                        -o \'./\'
                        -s \'./\'
                        -f \'ALL\' 
                        --prettyPrint''', odcInstallation: 'dp-Check')
          
          // Read the dependency-check report
          def report = readFile('dependency-check-report.xml')

          // Parse the report and perform checks, for example:
          if (report.contains('high')) {
            error('High risk vulnerabilities found in dependencies')
          } else {
            echo 'No high risk vulnerabilities found'
          }
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
  }
}
