pipeline {
  agent any
  stages {
    stage('log') {
      steps {
        sh '''sh \'ls -la
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