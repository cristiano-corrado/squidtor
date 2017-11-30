pipeline {
  agent {
    docker {
      image 'urand0m/squidtor:latest'
      args '--rm -h squidtor -p 3400:3400'
    }
    
  }
  stages {
    stage('Build') {
      steps {
        sh 'hostname && ip addr show'
        sh 'id'
      }
    }
    stage('Test Proxy') {
      steps {
        sh 'which curl && curl -x 127.0.0.1:3400'
      }
    }
  }
}
