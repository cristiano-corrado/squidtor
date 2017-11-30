pipeline {
  agent none
  stages {
    stage('Back-end') {
      parallel {
        stage('Back-end') {
          agent {
            docker {
              image 'urand0m/squidtor:latest'
              args '--rm -d -h squidtor -p 3400:3400'
            }
            
          }
          steps {
            sh 'id'
          }
        }
        stage('') {
          steps {
            echo 'There you go docker run'
          }
        }
      }
    }
    stage('Front-end') {
      parallel {
        stage('Front-end') {
          agent {
            node {
              label 'localsystem'
            }
            
          }
          steps {
            sh 'id'
            sh 'netstat -vpltnu'
          }
        }
        stage('Front Now') {
          steps {
            echo 'frontend'
          }
        }
      }
    }
  }
}