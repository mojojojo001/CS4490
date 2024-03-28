pipeline {
  agent any
  environment {
    FABRIC_BIN = 'C:\\Users\\alabb\\fabric-samples\\bin\\' // Path to the directory containing Fabric binaries
    IMAGE_NAME = 'my-image-name'
    IMAGE_TAG = 'latest'
    CONTAINER_NAME = "my-container-${BUILD_NUMBER}"
  }
  stages {
    stage('Build') {
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

    stage('Deploy Fabric Network') {
      steps {
        // Add steps to set up your Fabric network
        script {
          // Generate crypto materials
          bat "${FABRIC_BIN}cryptogen generate --config={FABRIC_BIN}/crypto-config.yaml"

          // Create channel artifacts
          bat "${FABRIC_BIN}configtxgen -profile MyChannelProfile -outputCreateChannelTx ./channel.tx -channelID mychannel"

          // Join peers to channel
          bat "${FABRIC_BIN}peer channel join -b ./channel.block"
        }
      }
    }

    stage('Deploy') {
      steps {
        bat "docker run -d --name ${CONTAINER_NAME} -p 80:80 ${IMAGE_NAME}:${IMAGE_TAG}"
      }
    }
  }
}
