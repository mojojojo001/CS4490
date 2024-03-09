pipeline {
    agent any
  
    environment {
        IMAGE_NAME = 'my-image-name'
        IMAGE_TAG = 'latest'
        CONTAINER_NAME = "my-container-${BUILD_NUMBER}" 
        ZAP_REPORT = 'zap-report.html'
    }

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
                    // Run OWASP ZAP baseline scan against localhost
                    bat "docker run -v %cd%:/zap/wrk/:rw owasp/zap2docker-stable zap-baseline.py -t http://localhost:80 -r ${ZAP_REPORT}"
                }
            }
        }

        stage('Deploy') {
            steps {
                bat "docker run -d --name ${CONTAINER_NAME} -p 80:80 ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
    }

    post {
        always {
            // Archive ZAP report as a build artifact
            archiveArtifacts artifacts: "${ZAP_REPORT}", onlyIfSuccessful: true
        }
    }
}
