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
        bat 'docker build -t my-image-name .'
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
        bat 'docker run -d --name your_container_name -p 80:80 my-image-name:latest'
      }
    }

  }
}