pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh '''sh \'gcc -o hello main.c\'
'''
      }
    }

    stage('Docker Build') {
      steps {
        sh ' docker.build(\'my-image-name\')'
      }
    }

    stage('Docker Deploy') {
      steps {
        sh '''docker.image(\'my-image-name\').push(\'latest\')
'''
      }
    }

  }
}