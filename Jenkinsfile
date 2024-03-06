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

    stage('Docker Deploy') {
      steps {
        bat 'docker push my-image-name:latest'
      }
    }

  }
}