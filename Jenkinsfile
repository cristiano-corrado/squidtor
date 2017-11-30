pipeline {
  agent none
  stages {
    stage('Back-end') {
      parallel {
        stage('Back-end') {
          agent {
            dockerfile {
              filename 'Dockerfile'
            }
            
          }
          steps {
            sh 'id'
          }
        }
        stage('Back End') {
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